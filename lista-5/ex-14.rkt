;; Lista 05 - Autorreferência e Recursividade
;;
;; Exercício 14

#lang racket

(require examples)


;; Lista(Número) -> Número
;;
;; Calcula a amplitude dos valores de uma lista não vazia de números, isto é, a diferença entre
;; os valores máximo e mínimo da lista.

(examples
 (check-equal? (amplitude (list 1)) 0)
 (check-equal? (amplitude (list 2 4/2 2.0 2 2 6/3)) 0)
 (check-equal? (amplitude (list 7 0 1 2 3 4 5 6)) 7)
 (check-equal? (amplitude (list 99 55 3 27 101 14 100 102)) 99)
 (check-equal? (amplitude (list 3 6 9 12 15 18 21 24 27 30)) 27))

(define (amplitude lst)
  (- (maximo lst) (minimo lst)))


;; Lista(Número) -> Número
;;
;; Retorna o número máximo, ou seja, o maior de uma lista.

(examples
 (check-equal? (maximo (list 1)) 1)
 (check-equal? (maximo (list 2 4/2 2.0 2 2 6/3)) 2)
 (check-equal? (maximo (list 7 0 1 2 3 4 5 6)) 7)
 (check-equal? (maximo (list 99 55 3 27 101 14 100 102)) 102))

(define (maximo lst)
  (cond
    [(empty? (rest lst)) (first lst)]  ; lista unitária
    [(> (first lst) (maximo (rest lst))) (first lst)]
    [else
     (maximo (rest lst))]))


;; Lista(Número) -> Número
;;
;; Retorna o número mínimo, ou seja, o menor de uma lista.

(examples
 (check-equal? (minimo (list 1)) 1)
 (check-equal? (minimo (list 2 4/2 2.0 2 2 6/3)) 2)
 (check-equal? (minimo (list 7 0 1 2 3 4 5 6)) 0)
 (check-equal? (minimo (list 99 55 3 27 101 14 100 102)) 3))

(define (minimo lst)
  (cond
    [(empty? (rest lst)) (first lst)]  ; lista unitária
    [(< (first lst) (minimo (rest lst))) (first lst)]
    [else
     (minimo (rest lst))]))
