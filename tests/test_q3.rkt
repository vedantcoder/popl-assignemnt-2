#lang racket/base

; Test cases for S1: Binary Tree Traversals
; Run: racket tests/test_q3.rkt

; Dynamically locate and access the 27_q3 module without modifying code/27_q3.rkt
(define id-q3-path
  (cond
    ((file-exists? "code/27_q3.rkt") "code/27_q3.rkt")
    ((file-exists? "../code/27_q3.rkt") "../code/27_q3.rkt")
    ((file-exists? "code/id_q3.rkt") "code/id_q3.rkt")
    (else "../code/id_q3.rkt")))

(dynamic-require id-q3-path #f)
(define id-q3-ns (module->namespace id-q3-path))

(define print-inorder (namespace-variable-value 'print-inorder #t #f id-q3-ns))
(define print-all-traversals (namespace-variable-value 'print-all-traversals #t #f id-q3-ns))
(define print-height-and-leaves (namespace-variable-value 'print-height-and-leaves #t #f id-q3-ns))

; Capture standard output from a nullary procedure to verify exact string output and newlines
(define (capture-output thunk)
  (let ((out (open-output-string)))
    (parameterize ((current-output-port out))
      (thunk))
    (get-output-string out)))

; Test assertion helper: compares captured output against expected output
; Returns #t on pass, #f on failure
(define (check-output test-name thunk expected)
  (let ((actual (capture-output thunk)))
    (if (equal? actual expected)
        (begin
          (display "  PASS: ")
          (display test-name)
          (newline)
          #t)
        (begin
          (display "  FAIL: ")
          (display test-name)
          (newline)
          (display "    Expected: ")
          (display expected)
          (display "    Actual:   ")
          (display actual)
          #f))))

; Helper to count the number of failed (#f) test outcomes in a list of booleans
(define (count-failures results)
  (cond
    ((null? results) 0)
    ((not (car results)) (+ 1 (count-failures (cdr results))))
    (else (count-failures (cdr results)))))

; Test trees
(define t-empty '())
(define t-single '(5 () ()))
(define t1 '(4 (2 (1 () ()) (3 () ())) (6 (5 () ()) (7 () ()))))
(define t2 '(1 () (2 () (3 () ()))))
(define t3 '(a (b () ()) (c () ())))
(define t-left '(3 (2 (1 () ()) ()) ()))

; Run all test cases, track failures, and exit with code 1 if any test fails
(define (run-tests)
  (display "Running S1 tests...\n")

  (let* ((results
          (list
           ; Group 1: print-inorder tests
           (check-output "print-inorder empty tree -> ()"
                         (lambda () (print-inorder t-empty))
                         "()\n")
           (check-output "print-inorder single node (5 () ()) -> (5)"
                         (lambda () (print-inorder t-single))
                         "(5)\n")
           (check-output "print-inorder balanced t1 -> (1 2 3 4 5 6 7)"
                         (lambda () (print-inorder t1))
                         "(1 2 3 4 5 6 7)\n")
           (check-output "print-inorder right-skewed t2 -> (1 2 3)"
                         (lambda () (print-inorder t2))
                         "(1 2 3)\n")
           (check-output "print-inorder symbol tree t3 -> (b a c)"
                         (lambda () (print-inorder t3))
                         "(b a c)\n")
           (check-output "print-inorder left-skewed tree -> (1 2 3)"
                         (lambda () (print-inorder t-left))
                         "(1 2 3)\n")

           ; Group 2: print-all-traversals tests
           (check-output "print-all-traversals empty tree -> 3 lines of ()"
                         (lambda () (print-all-traversals t-empty))
                         "()\n()\n()\n")
           (check-output "print-all-traversals single node -> 3 lines of (5)"
                         (lambda () (print-all-traversals t-single))
                         "(5)\n(5)\n(5)\n")
           (check-output "print-all-traversals balanced t1 -> inorder, preorder, postorder"
                         (lambda () (print-all-traversals t1))
                         "(1 2 3 4 5 6 7)\n(4 2 1 3 6 5 7)\n(1 3 2 5 7 6 4)\n")
           (check-output "print-all-traversals right-skewed t2 -> (1 2 3), (1 2 3), (3 2 1)"
                         (lambda () (print-all-traversals t2))
                         "(1 2 3)\n(1 2 3)\n(3 2 1)\n")
           (check-output "print-all-traversals symbol tree t3 -> (b a c), (a b c), (b c a)"
                         (lambda () (print-all-traversals t3))
                         "(b a c)\n(a b c)\n(b c a)\n")
           (check-output "print-all-traversals left-skewed tree -> (1 2 3), (3 2 1), (1 2 3)"
                         (lambda () (print-all-traversals t-left))
                         "(1 2 3)\n(3 2 1)\n(1 2 3)\n")

           ; Group 3: print-height-and-leaves tests
           (check-output "print-height-and-leaves empty tree -> (0 0)"
                         (lambda () (print-height-and-leaves t-empty))
                         "(0 0)\n")
           (check-output "print-height-and-leaves single node -> (1 1)"
                         (lambda () (print-height-and-leaves t-single))
                         "(1 1)\n")
           (check-output "print-height-and-leaves balanced t1 -> (3 4)"
                         (lambda () (print-height-and-leaves t1))
                         "(3 4)\n")
           (check-output "print-height-and-leaves right-skewed t2 -> (3 1)"
                         (lambda () (print-height-and-leaves t2))
                         "(3 1)\n")
           (check-output "print-height-and-leaves symbol tree t3 -> (2 2)"
                         (lambda () (print-height-and-leaves t3))
                         "(2 2)\n")
           (check-output "print-height-and-leaves left-skewed tree -> (3 1)"
                         (lambda () (print-height-and-leaves t-left))
                         "(3 1)\n")))
         (failures (count-failures results)))
    (if (= failures 0)
        (begin
          (display "All S1 tests passed.\n")
          (exit 0))
        (begin
          (display "Some S1 tests failed: ")
          (display failures)
          (display " failure(s).\n")
          (exit 1)))))

(run-tests)
