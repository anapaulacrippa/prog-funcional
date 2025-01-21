;; Lista 05 - Autorreferência e Recursividade
;;
;; Exercício 09

#lang racket

(require examples)

;; Lista(Numero) -> Numero
;;
;; Devolve o último elemento de uma lista não vazia de números.

(examples
 (check-equal? (last-elem (list 0)) 0)
 (check-equal? (last-elem (list 3.9 2.005 13 10 20 0.5 1 7)) 7)
 (check-equal? (last-elem (list 30 1 19 72 30/6 19/66)) 19/66)
 (check-equal? (last-elem (list 3 3 3 3 3 3 3 3 3 3 3 3 9)) 9)
 (check-equal? (last-elem (list 1 2 3 4 5)) 5))

(define (last-elem lst)
  (cond
    [(empty? (rest lst)) (first lst)]  ; somente um elemento, retorna ele
    [else
     (last-elem (rest lst))]))
