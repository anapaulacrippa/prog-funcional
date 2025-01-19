;; Lista 05 - Autorreferência e Recursividade
;;
;; Exercício 04

#lang racket

(require examples)

;; Lista(String) -> Lista(Número)
;;
;; Cria uma lista de números a partir de uma lista de strings convertendo cada string para um número.
;; Assume-se que todas as strings representam números válidos. 

(examples
 (check-equal? (str->num empty) '())
 (check-equal? (str->num (cons "03092005" empty)) (cons 03092005 empty))
 (check-equal? (str->num (cons "123" (cons "456" (cons "789" empty)))) (list 123 456 789))
 (check-equal? (str->num (list "0" "1" "22" "333" "4444" "55555")) (list 0 1 22 333 4444 55555)))

(define (str->num lst)
  (cond
    [(empty? lst) '()]
    [else
     (cons (string->number (first lst)) (str->num (rest lst)))]))
