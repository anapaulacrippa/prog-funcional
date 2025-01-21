;; Lista 05 - Autorreferência e Recursividade
;;
;; Exercício 11

#lang racket

(require examples)

;; Lista(Numero) -> Boolean
;;
;; Verifica se uma lista de números está em ordem não decrescente.
;; Caso a lista seja vazia ou contenha somente um elemento, considera-se que é verdadeiro.

(examples
 (check-equal? (nao-decrescente empty) #t)
 (check-equal? (nao-decrescente (list 1 2)) #t)
 (check-equal? (nao-decrescente (list 1 2 3 4 5 4)) #f)
 (check-equal? (nao-decrescente (list 3 9 20 51 310 2003)) #t)
 (check-equal? (nao-decrescente (list 3 3 3 3 3 3 3)) #t)
 (check-equal? (nao-decrescente (list 13 10 20 0 3 3 9 2005)) #f))

(define (nao-decrescente lst)
  (cond
    [(empty? lst) #t]
    [(empty? (rest lst)) #t]
    [(> (first lst) (first (rest lst))) #f]
    [else
     (nao-decrescente (rest lst))]))
