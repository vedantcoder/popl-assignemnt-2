% Test cases for P2: Form a Valid Arithmetic Equation
% Run: swipl -q -l code/27_q2.pl -l tests/test_q2.pl -g run_tests -t halt

:- use_module(library(lists)).

% run_tests/0
% Runs all test cases and reports results.
run_tests :-
    format("Running P2 tests...~n"),
    test_generate_equation_success,
    test_generate_equation_fails,
    test_generate_empty_fails,
    test_generate_single_fails,
    test_all_equations_example1,
    test_all_equations_example2,
    test_all_equations_none,
    test_count_equations,
    test_division_exactness,
    format("All P2 tests passed.~n").

% test_generate_equation_success: [4,2,5,3] produces one of the valid equations
test_generate_equation_success :-
    generate_equation([4,2,5,3], E),
    Valid = ["4*2-5=3", "4*2=5+3", "4-2=5-3", "4/2=5-3",
             "4=2*(5-3)", "4=2+(5-3)", "4=2+5-3"],
    member(E, Valid),
    format("  PASS: generate_equation([4,2,5,3], E) returned valid equation: ~w~n", [E]).

% test_generate_equation_fails: [2,3,4] has no equation, should fail cleanly
test_generate_equation_fails :-
    (   generate_equation([2,3,4], _)
    ->  format("  FAIL: generate_equation([2,3,4]) should fail~n"), fail
    ;   format("  PASS: generate_equation([2,3,4]) correctly fails~n")
    ).

% test_generate_empty_fails: empty list fails cleanly
test_generate_empty_fails :-
    (   generate_equation([], _)
    ->  format("  FAIL: generate_equation([]) should fail~n"), fail
    ;   format("  PASS: generate_equation([]) correctly fails~n")
    ).

% test_generate_single_fails: single-element list fails cleanly
test_generate_single_fails :-
    (   generate_equation([5], _)
    ->  format("  FAIL: generate_equation([5]) should fail~n"), fail
    ;   format("  PASS: generate_equation([5]) correctly fails~n")
    ).

% test_all_equations_example1: [4,2,5,3] returns exactly the 7 sorted equations
test_all_equations_example1 :-
    all_equations([4,2,5,3], Es),
    Expected = ["4*2-5=3", "4*2=5+3", "4-2=5-3", "4/2=5-3",
                "4=2*(5-3)", "4=2+(5-3)", "4=2+5-3"],
    Es == Expected,
    format("  PASS: all_equations([4,2,5,3]) matched all 7 expected equations~n").

% test_all_equations_example2: [2,4,8] returns ["2*4=8"]
test_all_equations_example2 :-
    all_equations([2,4,8], Es),
    Es == ["2*4=8"],
    format("  PASS: all_equations([2,4,8]) returned [\"2*4=8\"]~n").

% test_all_equations_none: [2,3,4] returns []
test_all_equations_none :-
    all_equations([2,3,4], Es),
    Es == [],
    format("  PASS: all_equations([2,3,4]) returned []~n").

% test_count_equations: count_equations([4,2,5,3], 7) succeeds
test_count_equations :-
    count_equations([4,2,5,3], 7),
    format("  PASS: count_equations([4,2,5,3], 7) confirmed~n").

% test_division_exactness: ensures non-integer division is rejected
test_division_exactness :-
    all_equations([7, 2, 3], Es),
    \+ member("7/2=3", Es),
    format("  PASS: exact division requirement enforced~n").
