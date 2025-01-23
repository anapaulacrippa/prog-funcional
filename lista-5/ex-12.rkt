;; Lista 05 - Autorreferência e Recursividade
;;
;; Exercício 12

#lang racket

(require examples)

;; (list) -> (list)
;;
;; Recebe como entrada uma lista lst e devolve uma lista com os mesmos elementos
;; de lst mas em ordem contrária.

(examples
 (check-equal? (inverte-lista empty) '())
 (check-equal? (inverte-lista (cons "racket" empty)) (list "racket"))
 (check-equal? (inverte-lista (list 1 2 3)) (list 3 2 1))
 (check-equal? (inverte-lista (list "E" "D" "C" "B" "A")) (list "A" "B" "C" "D" "E")))

(define (inverte-lista lst)
  (cond
    [(empty? lst) '()]
    [else
     (append (inverte-lista (rest lst))
             (cons (first lst) empty))]))
