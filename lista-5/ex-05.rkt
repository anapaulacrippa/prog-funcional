;; Lista 05 - Autorreferência e Recursividade
;;
;; Exercício 05

#lang racket

(require examples)

;; Lista(String) -> Lista(String)
;;
;; Remove todas as strings que não começam com A de uma lista de strings.


(examples
 (check-equal? (remove-nao-A empty) '())
 (check-equal? (remove-nao-A (cons "Ana" (cons "Paula" (cons "Loureiro" (cons "Crippa" empty))))) (list "Ana"))
 (check-equal? (remove-nao-A (list "A" "B" "C" "D" "E" "A")) (list "A" "A"))
 (check-equal? (remove-nao-A (list "Arthur" "ajudou" "Amanda")) (list "Arthur" "Amanda"))
 (check-equal? (remove-nao-A (cons "Lista" (cons "05" (cons "-" (cons "Programação" (cons "Funcional" empty)))))) '()))

(define (remove-nao-A lst)
  (cond
   [(empty? lst) '()]
   [(equal? "A" (substring (first lst) 0 1)) ; se começa com A, insere na lista
    (cons (first lst) (remove-nao-A (rest lst)))]
   [else ; se não começa com A, deve ser ignorado (passa o resto da lista)
    (remove-nao-A (rest lst))]))
