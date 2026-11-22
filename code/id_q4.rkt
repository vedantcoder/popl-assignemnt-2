#lang racket/base

;; my-length: number of top-level elements in lst (tail recursive)
(define (my-length lst)
  (let loop ((rest lst) (count 0))
    (if (null? rest)
        count
        (loop (cdr rest) (+ count 1)))))