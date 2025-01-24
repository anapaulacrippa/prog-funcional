;; Lista 05 - Autorreferência e Recursividade
;;
;; Exercício 18

#lang racket

(require examples)
(require "ex-17.rkt")


;; Número Natural -> Boolean
;;
;; Verifica se um número natural é perfeito.
;; Um número natural é perfeito se a soma dos seu divisores, exceto ele mesmo, é igual a ele. 

(examples
 (check-equal? (natural-perfeito 2) #f)
 (check-equal? (natural-perfeito 6) #t)
 (check-equal? (natural-perfeito 28) #t)
 (check-equal? (natural-perfeito 81) #f)
 (check-equal? (natural-perfeito 100) #f)
 (check-equal? (natural-perfeito 496) #t)
 (check-equal? (natural-perfeito 8128) #t))

(define (natural-perfeito n)
  (= n (soma (divisores n (sub1 n)))))


;; (list Número) -> Número
;;
;; Retorna a soma de todos os elementos de uma lista de números.

(examples
 (check-equal? (soma (list 1 2 3 4 5)) 15)
 (check-equal? (soma (list 10 20 30)) 60)
 (check-equal? (soma (list 100)) 100)
 (check-equal? (soma empty) 0)
 (check-equal? (soma (list 5 10 15 20 25 30)) 105))

(define (soma lst)
  (cond
    [(empty? lst) 0] ; se a lista for vazia, a soma é 0
    [else
     (+ (first lst) (soma (rest lst)))]))
