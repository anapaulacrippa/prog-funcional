;; Lista 05 - Autorreferência e Recursividade
;;
;; Exercício 13

#lang racket

(require examples)
(require "ex-03.rkt")


;; (list Inteiro) -> String
;;
;; Indica se em uma lista de inteiros existem mais valores positivos ou negativos.

(examples
 (check-equal? (mais-pos-neg? empty) "igual")
 (check-equal? (mais-pos-neg? (list 0 1 2 3 4 5)) "mais positivos")
 (check-equal? (mais-pos-neg? (list 9 -4 -1 8/2 7 -1)) "igual")
 (check-equal? (mais-pos-neg? (list -5 -5 -4 -3 -2 -1 -9 -7)) "mais negativos"))

(define (mais-pos-neg? lst)
  (let ([qtde-pos (conta-positivos lst)])
    (cond
      [(= qtde-pos (/ (qtde-elem lst) 2)) ; mesma quantidade entre positivos e negativos
       "igual"]
      [(>= (- qtde-pos (qtde-elem lst)) 0) ; maior quantidade de positivos
       "mais positivos"]
      [else
       "mais negativos"])))

;; (list Numero) -> Inteiro
;;
;; Conta quantos números positivos existem em uma lista.
;; Assume-se que a lista conterá somente números e que o número zero é positivo.

(examples
 (check-equal? (conta-positivos empty) 0)
 (check-equal? (conta-positivos (list 0 1 2 3 4 5)) 6)
 (check-equal? (conta-positivos (list 9.8 -4 -1 8/2 7 -1)) 3)
 (check-equal? (conta-positivos (list -5 -5 -4 -3 -2 -1 -9 -7)) 0))

(define (conta-positivos lst)
  (cond
    [(empty? lst) + 0]
    [(>= (first lst) 0) (+ 1 (conta-positivos (rest lst)))]
    [else
     (conta-positivos (rest lst))]))
