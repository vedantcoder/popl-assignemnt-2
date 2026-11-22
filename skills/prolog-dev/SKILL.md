---
name: prolog-dev
description: Skill file for SWI-Prolog 9.x development in POPL Assignment 2
---

# Prolog Development Guide

## Language & Environment

- **Language:** Prolog
- **Implementation:** SWI-Prolog 9.x
- **Allowed libraries:** `lists`, `apply`, `yall`, `aggregate`

## Naming Conventions

- **Predicates:** `snake_case` — e.g., `count_solutions/2`, `apply_active_clues/2`
- **Variables:** `CamelCase` — e.g., `Solution`, `ActiveClues`, `Dept`
- **Atoms:** lowercase unquoted where possible; quote atoms that contain special characters or start with uppercase — e.g., `'Alex'`, `'c++'`, `'AI'`
- **Functor names:** short, descriptive — e.g., `p(Name, Dept, Lang, Project)`

## Comment Style

- Use `%` for single-line comments
- Describe each predicate above its first clause:
  ```prolog
  % solve(-Solution)
  % Finds a valid assignment satisfying all 8 clues.
  solve(Solution) :-
      ...
  ```
- For multi-line block comments use `/* ... */` sparingly

## How to Run & Test

- **Run main:**
  ```
  swipl -q -f filename.pl -g main -t halt
  ```
- **Run a specific goal:**
  ```
  swipl -q -f filename.pl -g "goal_here" -t halt
  ```
- **Interactive testing:**
  ```
  swipl -q -f filename.pl
  ?- solve(S).
  ```
- **Do NOT** call `halt/0` in your code — the `-t halt` flag handles termination

## Coding Conventions

- Write each logical rule or clue as its own clause — one predicate per logical unit
- Read each predicate declaratively: "clue(1, S) holds when in solution S, the AI-project friend is not in research and is not Dana"
- Use `member/2` to access elements from solution lists
- Use `permutation/2` from `library(lists)` for generating assignments
- Use `findall/3` or `aggregate_all/3` for counting solutions
- Prefer pattern matching over explicit unification with `=`
- Avoid cuts (`!`) unless absolutely necessary; prefer deterministic logic

## Self-Review Checklist

Before finalizing any Prolog file, verify:

- [ ] No `:- initialization(...)` directives anywhere
- [ ] No calls to `halt/0` or `halt/1`
- [ ] No `assert`, `retract`, `assertz`, `assertA`, or any variant
- [ ] No global variables (`b_setval`, `nb_setval`, `b_getval`, `nb_getval`)
- [ ] All atoms with special characters or uppercase starts are properly quoted (`'Alex'`, `'c++'`, `'AI'`)
- [ ] File contains only definitions — no top-level queries
- [ ] Output format matches specification exactly (spacing, brackets, newlines)
- [ ] `main/0` does not call `halt`
- [ ] Runs cleanly with `swipl -q -f file.pl -g main -t halt`
- [ ] No unused predicates or dead code

## Known AI Failure Modes for Prolog

1. **Forgetting to quote atoms:** AI often writes `Alex` instead of `'Alex'`, `c++` instead of `'c++'`, `AI` instead of `'AI'`. Unquoted uppercase atoms are treated as variables.
2. **Adding `:- initialization(main).`:** AI tends to add initialization directives. The grader uses `-g main` to invoke the entry point.
3. **Calling `halt/0`:** AI frequently ends `main` with `halt`. The `-t halt` flag handles this.
4. **Using `assert/retract`:** AI may use dynamic predicates for state. This assignment forbids them.
5. **Incorrect list processing:** AI may confuse `member/2` with `nth0/3` or use incorrect list patterns.
6. **Wrong string types:** SWI-Prolog has atoms, strings (`"..."`), and code lists. AI may mix these up. This assignment uses strings (`"..."`) for equation output.
7. **Non-termination:** AI-generated generate-and-test code may loop instead of failing cleanly when no solution exists.
8. **Hardcoding answers:** AI may skip the logical derivation and just print the answer. The grader tests individual predicates.
9. **Ignoring operator precedence:** When formatting expressions, AI often gets parenthesisation rules wrong, especially for right-associativity edge cases.
10. **Using `writeln` or `write` inconsistently:** AI may add extra spaces or newlines not in the spec.
