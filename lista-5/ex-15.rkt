;; Lista 05 - Autorreferência e Recursividade
;;
;; Exercício 15

#lang racket

(require examples)

;; Número Natural -> Número Natural
;;
;; Recebe um número natural n e calcula o produto dos números de 1 até n,
;; ou seja, o mesmo que calcular o fatorial de n.

(examples
 (check-equal? (fatorial 1) 1)
 (check-equal? (fatorial 2) 2)
 (check-equal? (fatorial 3) 6)
 (check-equal? (fatorial 4) 24)
 (check-equal? (fatorial 5) 120)
 (check-equal? (fatorial 6) 720)
 (check-equal? (fatorial 7) 5040))

(define (fatorial n)
  (cond
    [(= n 1) (* n 1)]
    [else
     (* n (fatorial (sub1 n)))]))
