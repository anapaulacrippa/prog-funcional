;; Lista 05 - Autorreferência e Recursividade
;;
;; Exercício 16

#lang racket

(require examples)

;; Recebe como entrada um número a (diferente de 0) e um número natural n e
;; calcula o valor a elevado a n.

(examples
 (check-equal? (a-elevado-n 1 0) 1)
 (check-equal? (a-elevado-n 2 2) 4)
 (check-equal? (a-elevado-n 2 5) 32)
 (check-equal? (a-elevado-n 4 4) 256)
 (check-equal? (a-elevado-n 3 1) 3))

(define (a-elevado-n a n)
  (cond
    [(zero? n) 1]
    [else
     (* a (a-elevado-n a (sub1 n)))]))
