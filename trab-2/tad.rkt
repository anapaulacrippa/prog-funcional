#lang racket

(provide (all-defined-out))

(struct enigma (descricao solucao pistas efeito item))
;; Enigma representa ...?
;;   descricao: String - detalhamento do enigma.
;;   solucao  : String - resposta esperada.
;;   pistas   : list(String) - sugestões para ajudar na solução.
;;   efeito   : String - consequência de resolver o enigma.
;;   item     : list(String) - objeto(s) adicionado(s) ao inventário do jogador.
