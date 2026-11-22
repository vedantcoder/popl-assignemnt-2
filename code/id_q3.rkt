#lang racket/base

; S1.a: Inorder Binary Tree Traversal
; File: id_q3.rkt
;
; Representation:
; A binary tree is either '() or a 3-element list (value left right).

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
