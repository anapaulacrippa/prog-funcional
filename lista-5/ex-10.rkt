;; Lista 05 - Autorreferência e Recursividade
;;
;; Exercício 10

#lang racket

(require examples)

;; (list String) -> Inteiro
;;
;; Determina o tamanho máximo entre todas as strings de uma lista não vazia de strings.

(examples
 (check-equal? (tam-max (list "")) 0)
 (check-equal? (tam-max (list "a")) 1)
 (check-equal? (tam-max (list "a" "aa" "aaa" "a")) 3)
 (check-equal? (tam-max (list "Um" "Dois" "Três" "Quatro" "Cinco")) 6)
 (check-equal? (tam-max (list "programacao" "funcional" "recursividade" "autorreferencia")) 15))

(define (tam-max lst)
  (cond
    [(empty? (rest lst)) (string-length (first lst))]
    [else
     (max (string-length (first lst))
          (tam-max (rest lst)))]))
