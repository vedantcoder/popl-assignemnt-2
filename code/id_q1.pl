% P1: Department Assignment Puzzle
% File: id_q1.pl

:- use_module(library(lists)).

% solution(-Solution)
% Generates a list of four p(Name, Dept, Lang, Project) terms
% in order Alex, Ben, Carla, Dana, with all attributes distinct.
solution(Solution) :-
    Solution = [
        p('Alex', DA, LA, PA),
        p('Ben',  DB, LB, PB),
        p('Carla', DC, LC, PC),
        p('Dana', DD, LD, PD)
    ],
    permutation([research, development, design, testing], [DA, DB, DC, DD]),
    permutation([python, java, 'c++', javascript], [LA, LB, LC, LD]),
    permutation(['AI', web, embedded, data], [PA, PB, PC, PD]).

% clue(+N, +Solution)
% Succeeds when clue number N holds in the given Solution.

% Clue 1: The friend who prefers the AI project does not work in research
%         and is not Dana.
clue(1, Solution) :-
    member(p(Name, Dept, _, 'AI'), Solution),
    Dept \= research,
    Name \= 'Dana'.

% Clue 2: Alex does not work in development and does not prefer C++.
clue(2, Solution) :-
    member(p('Alex', Dept, Lang, _), Solution),
    Dept \= development,
    Lang \= 'c++'.

% Clue 3: The friend working in the testing department likes Python.
clue(3, Solution) :-
    member(p(_, testing, python, _), Solution).

% Clue 4: Ben prefers web projects and does not work in testing.
clue(4, Solution) :-
    member(p('Ben', Dept, _, web), Solution),
    Dept \= testing.
