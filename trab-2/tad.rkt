#lang racket

(provide (all-defined-out))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Estruturas

(struct jogador (nome inventario pontos-vida localizacao) #:transparent)
;; Um jogador é o participante do jogo.
;;   nome       : String        - nome escolhido pelo jogador no início do jogo.
;;   inventario : (list String) - objetos carregados.
;;   pontos-vida: Inteiro       - quantidade de vida restante. Só pode ser reduzido. É inicializado como 10.
;;   localizacao: ambiente      - ambiente atual.

(struct enigma (descricao solucao pistas efeito item))
;; Enigma representa um desafio interativo que o jogador precisa resolver.
;;   descricao: String        - texto explicativo do enigma.
;;   solucao  : String        - resposta esperada.
;;   pistas   : (list String) - sugestões para ajudar na solução.
;;   efeito   : String        - consequência de resolver o enigma.
;;   item     : (list String) - objeto(s) adicionado(s) ao inventário do jogador após a solução.

(struct objeto (nome descricao interacao) #:transparent)
;; Um objeto é um item interativo que pertence a um ambiente.
;;   nome     : String        - identificação do objeto.
;;   descricao: String        - detalhes sobre o objeto.
;;   interacao: procedure     - ação que pode ser realizada a partir do objeto. Podem iniciar enigmas. 

(struct ambiente (nome descricao objetos enigmas saida) #:transparent)
;; Um ambiente representa uma sala que contém objetos interativos, enigmas e conexões com outros ambientes.
;;   nome     : String             - nome do ambiente.
;;   descricao: String             - detalhes sobre o ambiente.
;;   objetos  : (list objeto)      - objetos presentes para interação.
;;   enigmas  : (list enigma)      - enigmas associados ao ambiente.
;;   saida    : ambiente | Boolean - direção possível para outros ambientes. Caso não haja saída disponível, representado por #f.
