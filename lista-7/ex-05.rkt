;; Lista 07 - Funções como valores
;;
;; Exercício 5

#lang racket

;; Expressão inicial:

(let ([x 9])
  (* x
     (let ([x (/ x 3)])
       (+ x x))))

;; Desenvolvimento:

; substituem-se as ocorrências de x por 9
(let ([x 9])
  (* 9
     (let ([x (/ 9 3)])    
       (+ x x))))

; cálculo de x/3, com x=9
(* 9 (let ([x 3])
       (+ x x)))

; substituição das ocorrências do novo valor de x por 3
(* 9 (+ 3 3))

; cálculo da expressão
(* 9 6)

;; Resultado final:

54
