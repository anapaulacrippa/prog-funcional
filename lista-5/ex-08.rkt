;; Lista 05 - Autorreferência e Recursividade
;;
;; Exercício 08

#lang racket

(require examples)

;; Lista(Booleano) -> Booleano
;;
;; Verifica se algum dos elementos de uma lista de booleanos é verdadeiro.
;; Se a lista for vazia, considera-se que é falso.

(examples
 (check-equal? (verifica-true empty) #f)
 (check-equal? (verifica-true (list #t)) #t)
 (check-equal? (verifica-true (list #f)) #f)
 (check-equal? (verifica-true (list #f #f #f #f #t)) #t)
 (check-equal? (verifica-true (list #t #t #t #t #f)) #t)
 (check-equal? (verifica-true (list #f #f #f #f #f #f #f)) #f))

(define (verifica-true lst)
  (cond
    [(empty? lst) #f]
    [(equal? (first lst) #t) #t]
    [else
     (verifica-true (rest lst))]))
