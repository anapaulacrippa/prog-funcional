;; Lista 05 - Autorreferência e Recursividade
;;
;; Exercício 20

#lang racket

(require examples)

;; Número Natural  Número Natural -> Número Natural
;;
;; Soma dois números utilizando recursão e as funções
;; primitivas 'zero?', 'add1' e 'sub1'.

(examples
 (check-equal? (soma 2 3) 5)
 (check-equal? (soma 0 9) 9)
 (check-equal? (soma 8 0) 8)
 (check-equal? (soma -7 -2) -9)
 (check-equal? (soma -5 10) 5))

(define (soma a b)
  (cond
    [(zero? b) a]
    [(> b 0) (soma (add1 a) (sub1 b))]  ; b é positivo
    [(< b 0) (soma (sub1 a) (add1 b))]))  ; b é negativo


;; Número Natural  Número Natural -> Número Natural
;;
;; Subtrai dois números utilizando recursão e as funções
;; primitivas 'zero?', 'add1' e 'sub1'.

(examples
 (check-equal? (subtrai 2 3) -1)
 (check-equal? (subtrai 0 9) -9)
 (check-equal? (subtrai 8 0) 8)
 (check-equal? (subtrai -7 -2) -5)
 (check-equal? (subtrai -5 10) -15))

(define (subtrai a b)
  (cond
    [(zero? b) a]
    [(> b 0) (subtrai (sub1 a) (sub1 b))]  ; b é positivo
    [(< b 0) (subtrai (add1 a) (add1 b))]))  ; b é negativo


;; Número Natural  Número Natural -> Número Natural
;;
;; Multiplica dois números utilizando recursão e as funções
;; primitivas 'zero?', 'add1' e 'sub1'.

(examples
 (check-equal? (multiplica 2 3) 6)
 (check-equal? (multiplica 0 9) 0)
 (check-equal? (multiplica 8 0) 0)
 (check-equal? (multiplica -7 -2) 14)
 (check-equal? (multiplica -5 10) -50))

(define (multiplica a b)
  (cond
    [(zero? b) 0]
    [(> b 0) (soma a (multiplica a (sub1 b)))]  ; b é positivo
    [(< b 0) (- (multiplica a (- b)))]))  ; b é negativo
