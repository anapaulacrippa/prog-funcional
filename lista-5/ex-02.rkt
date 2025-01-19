;; Lista 05 - Autorreferência e Recursividade
;;
;; Exercício 02

#lang racket

(require examples)

;; ListaDeNúmeros -> Número
;;
;; Calcule o produto de todos os elementos de uma lista de números.
;; Se a lista é vazia, o produto é 1.

(examples
 (check-equal? (produto empty) 1)
 (check-equal? (produto (cons 3 (cons 5 (cons 2 empty)))) 30)
 (check-equal? (produto (cons 8 (cons 0 (cons 4 (cons 9 empty))))) 0)
 (check-equal? (produto (cons 9.9 (cons 1 (cons 3.3 empty)))) 32.67)
 (check-equal? (produto (list 15 2 13 3 9 5 30 6 2 66 72 0)) 0))

(define (produto lst)
  (cond
    [(empty? lst) 1] ; se a lista for vazia, o produto é 1
    [else
     (* (first lst) (produto (rest lst)))]))
