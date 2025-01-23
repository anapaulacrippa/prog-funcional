;; Lista 07 - Funções como valores
;;
;; Exercício 1

#lang racket

(require examples)

;; Após analisar os exemplos e exercícios e redefinir algumas das funções utilizando funções de alta ordem como foldr, map e filter,
;; percebe-se que as novas funções ficaram mais simples e intuitivas. Abaixo segue alguns exemplos que evidenciam as alterações.


;; (list String) -> String
;;
;; Concatena todos os elementos de uma lista de strings.
;; Se a lista é vazia, devolve "".
;; Se a lista tem apenas um elemento, devolve esse elemento.

(examples
 (check-equal? (concatena empty) "")
 (check-equal? (concatena (cons "funcional" empty)) "funcional")
 (check-equal? (concatena (cons "ana" (cons " " (cons "paula" empty)))) "ana paula")
 (check-equal? (concatena (cons "progr" (cons "ama" (cons "ção" (cons "!" empty))))) "programação!")
 (check-equal? (concatena (cons "a" (cons "n" (cons "a" (cons " " (cons "p" (cons "a" (cons "u" (cons "l" (cons "a" empty)))))))))) "ana paula")
 (check-equal? (concatena (list "Con" "ca" "ten" "a")) "Concatena"))

#|
Implementação anterior:
   
(define (concatena lst)
  (cond
    [(empty? lst) ""]  ; lista vazia, nada a concatenar
    [else
     (string-append (first lst) (concatena (rest lst)))]))
|#

;; Nova implementação com foldr:

(define (concatena lst)
  (foldr string-append "" lst))


;; Lista(Numero) -> Número
;;
;; Calcule o produto de todos os elementos de uma lista de números.
;; Se a lista é vazia, o produto é 1.

(examples
 (check-equal? (produto empty) 1)
 (check-equal? (produto (cons 3 (cons 5 (cons 2 empty)))) 30)
 (check-equal? (produto (cons 8 (cons 0 (cons 4 (cons 9 empty))))) 0)
 (check-equal? (produto (cons 9.9 (cons 1 (cons 3.3 empty)))) 32.67)
 (check-equal? (produto (list 15 2 13 3 9 5 30 6 2 66 72 0)) 0))

#|
Implementação anterior:
 
(define (produto lst)
  (cond
    [(empty? lst) 1]
    [else
     (* (first lst) (produto (rest lst)))]))
|#

;; Nova implementação com foldr:

(define (produto lst)
  (foldr * 1 lst))


;; Lista(String) -> Lista(Número)
;;
;; Cria uma lista de números a partir de uma lista de strings convertendo cada string para um número.
;; Assume-se que todas as strings representam números válidos. 

(examples
 (check-equal? (str->num empty) '())
 (check-equal? (str->num (cons "03092005" empty)) (cons 03092005 empty))
 (check-equal? (str->num (cons "123" (cons "456" (cons "789" empty)))) (list 123 456 789))
 (check-equal? (str->num (list "0" "1" "22" "333" "4444" "55555")) (list 0 1 22 333 4444 55555)))

#|
Implementação anterior:

(define (str->num lst)
  (cond
    [(empty? lst) '()]
    [else
     (cons (string->number (first lst)) (str->num (rest lst)))]))

|#

;; Nova implementação com map:

(define (str->num lst)
  (map string->number lst))
