;; Lista 05 - Autorreferência e Recursividade
;;
;; Exercício 07

#lang racket

(require examples)

;; Lista(Booleano) -> Booleano
;;
;; Verifica se todos os elementos de uma lista de booleanos são verdadeiro.
;; Se a lista for vazia, considera-se que é verdadeiro.

(examples
 (check-equal? (verifica-true empty) #t)
 (check-equal? (verifica-true (list #t)) #t)
 (check-equal? (verifica-true (list #f)) #f)
 (check-equal? (verifica-true (list #t #t #t #t #f)) #f)
 (check-equal? (verifica-true (list #t #t #t #t #t #t #t)) #t))

(define (verifica-true lst)
  (cond
    [(empty? lst) #t]
    [(equal? (first lst) #f) #f]
    [else
     (verifica-true (rest lst))]))
