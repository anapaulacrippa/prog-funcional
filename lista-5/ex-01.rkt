;; Lista 05 - Autorreferência e Recursividade
;;
;; Exercício 01

#lang racket

(require examples)

;; Lista(String) -> String
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

(define (concatena lst)
  (cond
    [(empty? lst) ""] ; se a lista for vazia, nada a concatenar
    [(empty? (rest lst)) (first lst)] ; se a lista só tem um elemento, devolve ele
    [else
     (string-append (first lst) (concatena (rest lst)))]))
