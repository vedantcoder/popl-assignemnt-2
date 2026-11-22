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
