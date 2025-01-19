;; Lista 05 - Autorreferência e Recursividade
;;
;; Exercício 03

#lang racket

(require examples)

;; Determine a quantidade de elementos de uma lista de números.
;; Dica: o primeiro elemento pode ser ignorado.
;;

(examples
 (check-equal? (qtde-elem empty) 0)
 (check-equal? (qtde-elem (list 2 -4.2 6 -8 10.9)) 5)
 (check-equal? (qtde-elem (list 0 0 0 0)) 4)
 (check-equal? (qtde-elem (list 3 9 5 15 2 13 30 1 6 72 66)) 11) 
 )

(define (qtde-elem lst)
  (cond
    [(empty? lst) 0]
    []
    )
  )
