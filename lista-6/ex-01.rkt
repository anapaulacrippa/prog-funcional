;; Lista 06 - Árvores e Processamento Simultâneo
;;
;; Exercício 1

#lang racket
(require examples)

(struct no (valor esq dir) #:transparent)

;;   t4  3
;;      / \
;; t3  4   7  t2
;;    /   / \
;;   3   8   9  t1
;;          /
;;    t0   10

(define t0 (no 10 empty empty))
(define t1 (no 9 t0 empty))
(define t2 (no 7 (no 8 empty empty) t1))
(define t3 (no 4 (no 3 empty empty) empty))
(define t4 (no 3 t2 t3))

;; ÁrvoreBinária  Número -> ÁrvoreBinária
;;
;; Recebe uma árvore binária *t* e um número *n*.
;; Retorna uma nova árvore binária com *n* somado a cada elemento.
;; Uma árvore vazia retorna a mesma árvore.

(examples
 (check-equal? (soma-elem empty 7) '())
 (check-equal? (soma-elem t0 2) (no 12 '() '()))
 (check-equal? (soma-elem t1 3) (no 12 (no 13 '() '()) '()))
 (check-equal? (soma-elem t2 0) (no 7 (no 8 '() '()) (no 9 (no 10 '() '()) '())))
 (check-equal? (soma-elem t3 10) (no 14 (no 13 '() '()) '()))
 (check-equal? (soma-elem t4 1) (no 4 (no 8 (no 9 '() '()) (no 10 (no 11 '() '()) '()))
                                      (no 5 (no 4 '() '()) '()))))

(define (soma-elem t n)
  (cond
    [(empty? t) '()]  ; árvore vazia
    [else
     (no (+ n (no-valor t))
         (soma-elem (no-esq t) n)   ; atualiza o valor do nó esq
         (soma-elem (no-dir t) n))]))  ; atualiza o valor do nó dir
