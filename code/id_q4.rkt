#lang racket/base

;; my-length: number of top-level elements in lst (tail recursive)
(define (my-length lst)
  (let loop ((rest lst) (count 0))
    (if (null? rest)
        count
        (loop (cdr rest) (+ count 1)))))

        
;; my-map: apply f to each top-level element of lst, keeping order.
;; Plain recursion (no reverse/append allowed).
(define (my-map f lst)
  (if (null? lst)
      '()
      (cons (f (car lst))
            (my-map f (cdr lst)))))


            
;; insert-if-short: put x at the front of every list (at every nesting level)
;; whose original length is < n. Atoms are left unchanged.
(define (insert-if-short x lst n)
  (let ((processed
         (my-map (lambda (e)
                   (if (or (null? e) (pair? e))
                       (insert-if-short x e n)
                       e))
                 lst)))
    (if (< (my-length lst) n)
        (cons x processed)
        processed)))