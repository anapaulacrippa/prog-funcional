;; Lista 05 - Autorreferência e Recursividade
;;
;; Exercício 14

#lang racket

(require examples)

;;
;;
;; Projete uma função que calcule a amplitude dos valores de uma lista não vazia de números, isto é, a
;; diferença entre o valor máximo e mínimo da lista. Dica: crie um plano e use funções auxiliares.

#|
(examples
 (check-equal? (amplitude empty) 0)
 
 )

(define (amplitude lst)

  )
|#

(examples
 (check-equal? (maximo (list 1)) 1)
 (check-equal? (maximo (list 2 4/2 2.0 2 2 6/3)) 2)
 (check-equal? (maximo (list 7 0 1 2 3 4 5 6)) 7)
 (check-equal? (maximo (list 99 55 3 27 101 14 100 102)) 102)
 )

(define (maximo lst)
  (cond
    [(empty? (rest lst)) (first lst)] ; lista de um elemento
    [(> (first lst) (maximo (rest lst))) (first lst)]
    [else
     (maximo (rest lst))]
    )
  )
