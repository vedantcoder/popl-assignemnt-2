# S2 tests (insert-if-short)

How to run one test (from the repo folder):

```
cp code/id_q4.rkt /tmp/test_s2.rkt
echo '(print-insert-result)' >> /tmp/test_s2.rkt
echo '<input>' | racket /tmp/test_s2.rkt
```

## Examples from the assignment

| Input (x lst n) | Expected output |
|---|---|
| `42 ((1 2) (3 4 5) (6) ()) 3` | `((42 1 2) (3 4 5) (42 6) (42))` |
| `0 (((1) 2) (3) ((4 5 6) ())) 3` | `((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))` |
| `7 () 3` | `(7)` |
| `7 () 0` | `()` |

## Edge cases

| Input (x lst n) | Expected output | Why |
|---|---|---|
| `9 () 1` | `(9)` | empty list has length 0 < 1 |
| `9 (1 2 3) 3` | `(1 2 3)` | length 3 is not < 3 |
| `9 (1 2 3) 4` | `(9 1 2 3)` | length 3 < 4 |
| `9 (()) 1` | `((9))` | outer length 1 is not < 1, inner () has length 0 < 1 |
| `9 (a b c) 0` | `(a b c)` | nothing is shorter than 0 |

## Big inputs

- 10,000-element flat list, n = 20000: result length should be 10001.
- 10,000-element flat list, n = 5: result length should stay 10000.
- Nesting depth 100, n = 5: runs without crashing; top-level length is 2.