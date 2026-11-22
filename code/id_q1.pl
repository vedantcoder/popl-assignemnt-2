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
