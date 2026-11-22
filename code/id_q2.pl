% P2: Form a Valid Arithmetic Equation
% File: id_q2.pl

:- use_module(library(lists)).

% operator(?Op)
% Valid arithmetic binary operators.
operator(+).
operator(-).
operator(*).
operator(/).

% split_list(+List, -Left, -Right)
% Splits List into two non-empty lists Left and Right, preserving order.
split_list([H|T], [H], T) :-
    T \= [].
split_list([H|T], [H|LeftRest], Right) :-
    split_list(T, LeftRest, Right).

% build_expr(+List, -Expr)
% Generates all valid expression trees for a given list of numbers.
% Leaves are num(X), internal nodes are op(Op, Left, Right).
build_expr([X], num(X)).
build_expr(List, op(Op, LeftExpr, RightExpr)) :-
    split_list(List, LeftList, RightList),
    build_expr(LeftList, LeftExpr),
    build_expr(RightList, RightExpr),
    operator(Op).

% eval_expr(+Expr, -Value)
% Evaluates an expression tree Expr to an integer Value.
% Division is valid only when exact (mod is 0) and divisor is non-zero.
eval_expr(num(X), X) :-
    integer(X).
eval_expr(op(+, Left, Right), Value) :-
    eval_expr(Left, VL),
    eval_expr(Right, VR),
    Value is VL + VR.
eval_expr(op(-, Left, Right), Value) :-
    eval_expr(Left, VL),
    eval_expr(Right, VR),
    Value is VL - VR.
eval_expr(op(*, Left, Right), Value) :-
    eval_expr(Left, VL),
    eval_expr(Right, VR),
    Value is VL * VR.
eval_expr(op(/, Left, Right), Value) :-
    eval_expr(Left, VL),
    eval_expr(Right, VR),
    VR =\= 0,
    VL mod VR =:= 0,
    Value is VL // VR.

% op_prec(+Op, -Precedence)
% Higher precedence binds tighter (*, / > +, -).
op_prec(+, 1).
op_prec(-, 1).
op_prec(*, 2).
op_prec(/, 2).

% expr_to_string(+Expr, -String)
% Converts an expression tree Expr to its canonical SWI-Prolog string representation
% adhering to precedence and left-associativity rules.
expr_to_string(num(X), String) :-
    number_codes(X, Codes),
    string_codes(String, Codes).
expr_to_string(op(Op, Left, Right), String) :-
    op_prec(Op, Prec),
    left_to_string(Left, Prec, LStr),
    right_to_string(Right, Prec, RStr),
    atom_string(Op, OpStr),
    string_concat(LStr, OpStr, Temp),
    string_concat(Temp, RStr, String).

% left_to_string(+Expr, +ParentPrec, -String)
% Left child requires parens only if its operator has strictly lower precedence.
left_to_string(num(X), _, String) :-
    expr_to_string(num(X), String).
left_to_string(op(Op, Left, Right), ParentPrec, String) :-
    op_prec(Op, Prec),
    expr_to_string(op(Op, Left, Right), InnerStr),
    (   Prec < ParentPrec
    ->  string_concat("(", InnerStr, T),
        string_concat(T, ")", String)
    ;   String = InnerStr
    ).

% right_to_string(+Expr, +ParentPrec, -String)
% Right child requires parens if its operator has same or lower precedence.
right_to_string(num(X), _, String) :-
    expr_to_string(num(X), String).
right_to_string(op(Op, Left, Right), ParentPrec, String) :-
    op_prec(Op, Prec),
    expr_to_string(op(Op, Left, Right), InnerStr),
    (   Prec =< ParentPrec
    ->  string_concat("(", InnerStr, T),
        string_concat(T, ")", String)
    ;   String = InnerStr
    ).
