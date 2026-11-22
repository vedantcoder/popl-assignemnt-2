#lang racket/base

; CS F301 POPL Assignment 2 - Scheme Component (S1)
; File: 27_q3.rkt
;
; Representation:
; A binary tree is either '() or a 3-element list (value left right).

; -----------------------------------------------------------------------------
; S1.a: Inorder Binary Tree Traversal
; -----------------------------------------------------------------------------

; inorder-helper: tree, accumulator -> list
; Accumulates values in inorder sequence (left, root, right).
; The accumulator `acc` represents the elements that appear after `tree`.
; By traversing the right subtree first with `acc`, consing the root value,
; and then traversing the left subtree with the resulting accumulator,
; the exact left-to-right inorder is constructed without append or reverse.
(define (inorder-helper tree acc)
  (if (null? tree)
      acc
      (inorder-helper (cadr tree)
                      (cons (car tree)
                            (inorder-helper (caddr tree) acc)))))

; print-inorder: tree -> void
; Traverses the binary tree in inorder and prints the resulting list
; using display, followed by a newline.
(define (print-inorder tree)
  (begin
    (display (inorder-helper tree '()))
    (newline)))

; -----------------------------------------------------------------------------
; S1.b: All Binary Tree Traversals (Inorder, Preorder, Postorder)
; -----------------------------------------------------------------------------

; preorder-helper: tree, accumulator -> list
; Accumulates values in preorder sequence (root, left, right).
; The accumulator `acc` represents the elements that appear after `tree`.
; The right subtree is traversed with `acc` to form the tail, the left subtree
; is traversed with that tail, and finally the root value is consed to the front.
(define (preorder-helper tree acc)
  (if (null? tree)
      acc
      (cons (car tree)
            (preorder-helper (cadr tree)
                             (preorder-helper (caddr tree) acc)))))

; postorder-helper: tree, accumulator -> list
; Accumulates values in postorder sequence (left, right, root).
; The accumulator `acc` represents the elements that appear after `tree`.
; The root value is consed to `acc`, the right subtree is traversed with that
; accumulator, and then the left subtree is traversed with the resulting tail.
(define (postorder-helper tree acc)
  (if (null? tree)
      acc
      (postorder-helper (cadr tree)
                        (postorder-helper (caddr tree)
                                          (cons (car tree) acc)))))

; print-all-traversals: tree -> void
; Prints three lines using display, each followed by a newline:
; 1. Inorder list
; 2. Preorder list
; 3. Postorder list
(define (print-all-traversals tree)
  (begin
    (display (inorder-helper tree '()))
    (newline)
    (display (preorder-helper tree '()))
    (newline)
    (display (postorder-helper tree '()))
    (newline)))

; -----------------------------------------------------------------------------
; S1.c: Tree Height and Leaf Count (Single-Traversal Calculation)
; -----------------------------------------------------------------------------

; height-and-leaves-helper: tree -> (list height leaf-count)
; Computes both height and leaf count in a single recursive traversal.
; 1. Returns '(0 0) for an empty tree.
; 2. Recursively computes the result for left and right subtrees exactly once.
; 3. Height = 1 + max(left-height, right-height).
; 4. Leaf count = 1 if both children are empty; otherwise (left-leaves + right-leaves).
; 5. Returns (list height leaf-count).
(define (height-and-leaves-helper tree)
  (if (null? tree)
      '(0 0)
      (let ((left-res (height-and-leaves-helper (cadr tree)))
            (right-res (height-and-leaves-helper (caddr tree))))
        (let ((h (+ 1 (max (car left-res) (car right-res))))
              (leaves (if (and (null? (cadr tree)) (null? (caddr tree)))
                          1
                          (+ (cadr left-res) (cadr right-res)))))
          (list h leaves)))))

; print-height-and-leaves: tree -> void
; Prints the list (height leaf-count) on exactly one line using display,
; followed by a newline.
(define (print-height-and-leaves tree)
  (begin
    (display (height-and-leaves-helper tree))
    (newline)))
