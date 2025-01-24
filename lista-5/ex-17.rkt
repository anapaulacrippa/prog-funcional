;; Lista 05 - Autorreferência e Recursividade
;;
;; Exercício 17

#lang racket

(require examples)

;; Número Natural  Número Natural -> (list Número Natural)
;;
;; Recebe dois números naturais maiores que zero, x e n, e devolve uma lista com os divisores
;; de x que são menores ou iguais a n, ordenados crescentemente.

(examples
 (check-equal? (divisores 1 1) (list 1))
 (check-equal? (divisores 4 4) (list 4 2 1))
 (check-equal? (divisores 3905 500) (list 355 71 55 11 5 1))
 (check-equal? (divisores 100 50) (list 50 25 20 10 5 4 2 1))
 (check-equal? (divisores 27 8) (list 3 1)))

(define (divisores x n)
  (cond
    [(= n 1) (cons 1 empty)]
    [(zero? (remainder x n))  ; se o resto da divisão é zero, é divisor
     (cons n (divisores x (sub1 n)))]
    [else
     (divisores x (sub1 n))]))
