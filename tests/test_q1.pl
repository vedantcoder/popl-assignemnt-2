% Test cases for P1: Department Assignment Puzzle
% Run: swipl -q -f code/id_q1.pl -f tests/test_q1.pl -g run_tests -t halt

:- use_module(library(lists)).

% run_tests/0
% Runs all test predicates and reports results.
run_tests :-
    format("Running P1 tests...~n"),
    test_main_runs,
    test_solve_returns_solution,
    test_all_attributes_distinct,
    test_clue_1,
    test_clue_2,
    test_clue_3,
    test_clue_4,
    test_clue_5,
    test_clue_6,
    test_clue_7,
    test_clue_8,
    format("All P1 tests passed.~n").

% test_main_runs: main/0 executes without error
test_main_runs :-
    ( main -> format("  PASS: main/0 runs successfully~n")
    ; format("  FAIL: main/0 did not succeed~n"), fail
    ).

% test_solve_returns_solution: solve/1 returns a 4-element list
test_solve_returns_solution :-
    solve(S),
    length(S, 4),
    S = [p('Alex',_,_,_), p('Ben',_,_,_), p('Carla',_,_,_), p('Dana',_,_,_)],
    format("  PASS: solve/1 returns valid 4-person solution~n").

% test_all_attributes_distinct: all departments, languages, projects are unique
test_all_attributes_distinct :-
    solve([p(_,D1,L1,P1), p(_,D2,L2,P2), p(_,D3,L3,P3), p(_,D4,L4,P4)]),
    msort([D1,D2,D3,D4], Ds), length(Ds, 4),
    msort([L1,L2,L3,L4], Ls), length(Ls, 4),
    msort([P1,P2,P3,P4], Ps), length(Ps, 4),
    format("  PASS: all attributes are distinct~n").

% Individual clue tests: each clue holds for the solution
test_clue_1 :-
    solve(S), clue(1, S),
    format("  PASS: clue 1 holds~n").

test_clue_2 :-
    solve(S), clue(2, S),
    format("  PASS: clue 2 holds~n").

test_clue_3 :-
    solve(S), clue(3, S),
    format("  PASS: clue 3 holds~n").

test_clue_4 :-
    solve(S), clue(4, S),
    format("  PASS: clue 4 holds~n").

test_clue_5 :-
    solve(S), clue(5, S),
    format("  PASS: clue 5 holds~n").

test_clue_6 :-
    solve(S), clue(6, S),
    format("  PASS: clue 6 holds~n").

test_clue_7 :-
    solve(S), clue(7, S),
    format("  PASS: clue 7 holds~n").

test_clue_8 :-
    solve(S), clue(8, S),
    format("  PASS: clue 8 holds~n").
