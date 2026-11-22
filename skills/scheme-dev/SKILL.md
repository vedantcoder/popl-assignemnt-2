---
name: scheme-dev
description: Development guide and strict restrictions for Scheme/Racket 8.18 in CS F301 POPL Assignment 2
---

# Scheme / Racket 8.18 Development Guide

This guide establishes the mandatory rules, environment specifications, coding conventions, algorithmic patterns, and validation checklists for CS F301 POPL Assignment 2 (Scheme component: S1 – Binary Tree Traversals).

---

## 1. Environment & Target Language

- **Implementation:** Racket 8.18
- **Language Directive:** Must start with `#lang racket/base`
  - Do NOT use `#lang racket` (it imports extra syntax and libraries).
  - Do NOT use `(require ...)` of any kind in the submitted solution.
- **Operating Environment:** Windows development environment / cross-platform Racket runtime.
- **File Execution:** Code must load silently without producing any side effects or top-level execution output.
- **Testing Isolation:** Testing setups or test harnesses must remain completely separate and must NEVER introduce prohibited libraries, test frameworks (such as `rackunit`), or unwhitelisted helper functions into the submitted implementation file (`code/id_q3.rkt`).

---

## 2. Mandatory Built-in Whitelist

Submitted Scheme code must strictly restrict itself to the following whitelisted built-in forms and procedures:

### Core Forms & Binding
- `define`
- `lambda`
- `let`, `let*`, `letrec`, `named let`
- `if`
- `cond` (with `else`)
- `and`, `or`, `not`
- `begin`
- `quote` (or `'`)

### List Operations & Pair Inspection
- `cons`
- `car`, `cdr`
- Permitted compositions of `car` and `cdr` up to 4 levels:
  - 2 levels: `caar`, `cadr`, `cdar`, `cddr`
  - 3 levels: `caaar`, `caadr`, `cadar`, `caddr`, `cdaar`, `cdadr`, `cddar`, `cdddr`
  - 4 levels: `caaaar`, `caaadr`, `caadar`, `caaddr`, `cadaar`, `cadadr`, `caddar`, `cadddr`, etc.
- `list`
- `null?`, `pair?`, `eq?`
- `assq`, `assoc`

### Arithmetic & Comparison
- `+`, `-`, `*`
- `<`, `>`, `<=`, `>=`, `=`
- `max`

### I/O & Output
- `display`
- `newline`

---

## 3. Strictly Prohibited Features

Any use of the following features constitutes an assignment violation:
- **No Mutation:** `set!`, `set-car!`, `set-cdr!`, or any mutating forms.
- **No Non-List Data Structures:** No vectors, hash tables, or strings. All data must be represented exclusively using lists, pairs, symbols, and numbers from the whitelist.
- **No Prohibited Higher-Order or List Convenience Built-ins:**
  - `append`
  - `reverse`
  - `map`, `filter`, `foldl`, `foldr`
  - `length`
  - `member`, `memq`, `memv`
  - `list-ref`, `list-tail`
- **No Iteration Loops:** No `do`, `for`, `for/list`, or comprehension macros.
- **No Advanced Language Features:** No `require`, `match`, `struct`, `printf`, `format`, or syntax objects.

---

## 4. Coding Conventions

1. **Pure Functional Programming:** Every function must be referentially transparent and side-effect free (except dedicated display procedures).
2. **Descriptive Names:** Use clear identifiers (`tree`, `left-subtree`, `right-subtree`, `node-val`, `acc`, etc.).
3. **Explicit Recursion & Accumulators:**
   - Since `append` and `reverse` are banned, construct lists using `cons` and recursion.
   - For linear-time traversals without `append`, use an accumulator argument (e.g. `(traverse-helper node acc)`).
4. **Tail Recursion:** Prefer tail-recursive helpers with accumulators where appropriate.
5. **Modular Architecture:** Keep helper functions small, focused, and single-purpose.
6. **Documentation & Comments:** Document base cases, structural assumptions, and non-obvious recursive paths.
7. **No Top-Level Execution:** Never invoke test calls, demonstrations, or driver procedures at the top level of `code/id_q3.rkt`. When the file is loaded via `racket` or `load`, it must produce zero standard output.

---

## 5. S1-Specific Specifications: Binary Tree Traversals

### Binary Tree Representation
Binary trees are represented using nested lists:
- **Empty Tree:** Represented by the empty list `'()`.
- **Non-Empty Tree:** Represented as a 3-element list `(value left right)`:
  - `value`: `(car tree)`
  - `left`: `(cadr tree)`
  - `right`: `(caddr tree)`

### Core Operations

#### 1. Inorder Traversal (Left - Root - Right)
- Traverse left subtree, visit node, traverse right subtree.
- **No-append implementation pattern:**
  ```scheme
  ;; Accumulator-based traversal where acc holds elements to follow:
  (define (inorder-helper tree acc)
    (if (null? tree)
        acc
        (inorder-helper (cadr tree)
                        (cons (car tree)
                              (inorder-helper (caddr tree) acc)))))
  ```

#### 2. Preorder Traversal (Root - Left - Right)
- Visit node, traverse left subtree, traverse right subtree.
- **No-append implementation pattern:**
  ```scheme
  (define (preorder-helper tree acc)
    (if (null? tree)
        acc
        (cons (car tree)
              (preorder-helper (cadr tree)
                               (preorder-helper (caddr tree) acc)))))
  ```

#### 3. Postorder Traversal (Left - Right - Root)
- Traverse left subtree, traverse right subtree, visit node.
- **No-append implementation pattern:**
  ```scheme
  (define (postorder-helper tree acc)
    (if (null? tree)
        acc
        (postorder-helper (cadr tree)
                          (postorder-helper (caddr tree)
                                            (cons (car tree) acc)))))
  ```

#### 4. Tree Height
- Convention for node-based or edge-based depth:
  - An empty tree `'()` has height `0`.
  - A single node tree `'(v () ())` has height `1`.
  - Non-empty tree: `(+ 1 (max (tree-height left) (tree-height right)))`.
- Always verify problem specification for empty-tree convention (0 vs -1).

#### 5. Leaf Counting
- An empty tree `'()` has `0` leaves.
- A leaf node is defined as a node whose both left and right subtrees are empty:
  `leaf? = (and (null? (cadr tree)) (null? (caddr tree)))` -> returns `1`.
- An internal node sums the leaves of its children:
  `(+ (count-leaves (cadr tree)) (count-leaves (caddr tree)))`.
- *Caution:* Do not count `'()` as a leaf!

#### 6. Required Output Formatting
- When displaying traversal results, output must use `display` directly on the complete resulting list, followed by `newline`:
  ```scheme
  (display (inorder tree))
  (newline)
  ```
- No strings, character formatting, `printf`, or `format` are permitted.

#### 7. Empty-Tree Handling
- Every function must handle `'()` as an immediate base case returning the appropriate identity element:
  - Traversals: `'()`
  - Height: `0`
  - Leaf count: `0`

---

## 6. Self-Review Checklist

Before finalizing any code, verify every item:
- [ ] **Whitelist Compliance:** Does every single token appear on the permitted built-in list?
- [ ] **No Hidden Convenience Functions:** Are `append`, `reverse`, `map`, `filter`, and `length` completely absent?
- [ ] **No Strings or Prohibited Types:** Ensure no strings, vectors, or hash tables are used.
- [ ] **Boundary Trees:**
  - Empty tree `'()` handled cleanly without crashing?
  - Single-node tree `'(X () ())` tested?
- [ ] **Structural Varieties:**
  - Full / balanced trees tested?
  - Left-skewed (degenerate linked list) tested?
  - Right-skewed (degenerate linked list) tested?
- [ ] **Traversal Order:** Does left always precede right? Are preorder/postorder sequences correctly ordered?
- [ ] **Height vs Node Count:** Ensure height measures max depth, not total node count.
- [ ] **Leaf Counting:** Ensure internal nodes with one child do not get counted as leaves, and empty trees return 0.
- [ ] **Exact Output Formatting:** Resulting list displayed directly via `(display result)` followed by `(newline)`.
- [ ] **Output & Side Effects:**
  - Loading the source file produces completely silent output.
  - No `set!` or mutation anywhere.
- [ ] **Test Isolation:** Ensure test dependencies (e.g. `rackunit`) are never imported into the submission code file.

---

## 7. Known AI Failure Modes

1. **Accidental Use of `append` / `reverse`:** LLMs frequently attempt `(append (inorder left) (list val) (inorder right))`. This is strictly forbidden. Accumulator recursion must be used instead.
2. **Importing Libraries:** Injecting `(require racket/list)` or `(require rackunit)`. The submitted code file must not contain any `require`.
3. **Using `#lang racket`:** Defaulting to full Racket instead of `#lang racket/base`.
4. **Confusing Tree Height with Node Count:** Returning total number of elements rather than length of longest path from root.
5. **Misclassifying Leaves:** Treating `'()` as a leaf node, resulting in incorrect leaf counts.
6. **Reversed Preorder/Postorder:** Emitting children in reverse order when building accumulator lists.
7. **Top-Level Driver Execution:** Leaving test evaluations or `display` calls at the bottom of the source file.
8. **Prohibited Display Functions & Strings:** Attempting `(printf ...)` or string-formatting lists rather than displaying the complete resulting list directly.
