---
name: scheme-s2-dev
description: Rules, semantics, checklist and AI failure modes for S2 (conditional insert into a nested list) in Racket, CS F301 Assignment 2. Use together with scheme-dev.
---

# S2: Conditional Insert into a Nested List (Racket)

File: `code/id_q4.rkt`. The general rules in `scheme-dev` still apply: `#lang racket/base`, no `require`, only definitions, silent on load, and only whitelisted built-ins. One extra built-in is allowed for S2: `read`.

## Required definitions
- `(my-length lst)`: number of top-level elements (tail-recursive named let).
- `(my-map f lst)`: own map, built with `cons` and recursion.
- `(make-inserter x len-ok?)`: returns a one-argument function that inserts `x` at the front of every list, at every nesting level, whose ORIGINAL length satisfies `len-ok?`.
- `(insert-if-short x lst n)`: defined using `make-inserter` with `(lambda (len) (< len n))`. The final file contains exactly ONE definition of `insert-if-short`.
- `(print-insert-result)`: no arguments. Reads `x`, `lst`, `n` with `read` (in that order, using `let*`), displays the result, then `newline`. No prompts or other text.

## Semantics
- Length is measured on the original list, before any insertion.
- The top-level list is treated like every other list.
- `()` is a list of length 0, so it becomes `(x)` whenever `0 < n`. This also applies to an empty top-level list.
- Atoms stay unchanged. An element is a list if `(or (null? e) (pair? e))`.

## Coding conventions
- Descriptive names, and a comment above every function saying what it does.
- Pass all state through arguments. No `set!`.
- Hidden tests use nesting depth 100 and lists of 10,000 elements, so test with both.

## How to run and test
Copy the file, add `(print-insert-result)` at the end of the copy, and feed input on stdin:

    cp code/id_q4.rkt /tmp/test_s2.rkt
    echo '(print-insert-result)' >> /tmp/test_s2.rkt
    echo '42 ((1 2) (3 4 5) (6) ()) 3' | racket /tmp/test_s2.rkt

Expected: `((42 1 2) (3 4 5) (42 6) (42))`

## Self-review checklist
- [ ] No `length`, `append`, `reverse`, `map`, `filter`, `set!` or `require` anywhere.
- [ ] `read` is called inside `let*`, so the order is x, lst, n.
- [ ] Length is checked on the original list, not the processed one.
- [ ] `()` is recognised as a list (`null?` as well as `pair?`).
- [ ] Only one definition of `insert-if-short`, and it uses `make-inserter`.
- [ ] Nothing is printed when the file is loaded.
- [ ] Tested with the 4 PDF examples, `n = 0`, an empty list, 10,000 elements and depth 100.

## Known AI failure modes
1. Using the built-in `length` or `map` instead of `my-length` and `my-map`.
2. Treating `()` as an atom, so empty lists never get `x`.
3. Forgetting the top-level list and inserting only into sublists.
4. Measuring length after insertion instead of before.
5. Printing a prompt or extra text around the result.
6. Leaving two definitions of `insert-if-short`.
7. Leaving a test call such as `(print-insert-result)` at the bottom of the file.
8. Reading the input in the wrong order because the `read` calls are not inside `let*`.