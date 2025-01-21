;; Lista 05 - Autorreferência e Recursividade
;;
;; Exercício 06

#lang racket

(require examples)

;; Lista(Inteiro) -> Lista(Inteiro)
;;
;; Remove todos os valores nulos de uma lista de inteiros.

(examples
 (check-equal? (remove-nulos empty) '())
 (check-equal? (remove-nulos (cons 1 (cons 2 (cons 3 (cons 4 empty))))) (list 1 2 3 4))
 (check-equal? (remove-nulos (list 0 0 0 0 0 0 0 0)) '())
 (check-equal? (remove-nulos (list 30 6 19 66 2 72 3 9 0 5 15 0 2 13)) (list 30 6 19 66 2 72 3 9 5 15 2 13))
 (check-equal? (remove-nulos (cons 13 (cons 10 (cons 3 (cons 20 (cons 0 empty)))))) (list 13 10 3 20)))

(define (remove-nulos lst)
  (cond
   [(empty? lst) '()]
   [(not (equal? 0 (first lst)))  ; se for diferente de 0, insere na lista
    (cons (first lst) (remove-nulos (rest lst)))]
   [else  ; se for igual a 0, deve ser ignorado 
    (remove-nulos (rest lst))]))
