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


            
;; make-inserter: returns a function that inserts x at the front of every
;; list (at every nesting level) whose original length satisfies len-ok?.
(define (make-inserter x len-ok?)
  (letrec ((insert
            (lambda (lst)
              (let ((processed
                     (my-map (lambda (e)
                               (if (or (null? e) (pair? e))
                                   (insert e)
                                   e))
                             lst)))
                (if (len-ok? (my-length lst))
                    (cons x processed)
                    processed)))))
    insert))

;; insert-if-short: insert x into every list shorter than n.
(define (insert-if-short x lst n)
  ((make-inserter x (lambda (len) (< len n))) lst))


        
;; print-insert-result: read x, lst, n from stdin (in that order),
;; then display the result followed by a newline.
(define (print-insert-result)
  (let* ((x (read))
         (lst (read))
         (n (read)))
    (display (insert-if-short x lst n))
    (newline)))