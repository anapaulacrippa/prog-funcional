#lang racket

(require "tad.rkt")
(require "novo-hacker.rkt")
(provide (all-defined-out))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Interações

;; Interações possíveis com o objeto "Teclado Desgastado"
(define (digitar-comando jogador ambiente)
  (displayln "Você está digitando um comando..."))

(define (examinar-simbolos jogador ambiente)
  (displayln "Examinando os símbolos no teclado..."))


;; Interações possíveis com o objeto "Painel de Controle"
(define (reiniciar-sistema jogador ambiente)
  (displayln "Sistema reiniciado com sucesso."))

(define (destrancar-data-center jogador ambiente) ; só pode ser iniciado ao finalizar o enigma 3, ou seja, com a chave
  (if (member "Chave Data Center" (jogador-inventario jogador)) 
      (begin
        (let ([jogador-atualizado 
               (atualiza 'inventario jogador "Chave Data Center")]) ; remove a chave do inventário
          (let ([jogador-atualizado-completo
                 (atualiza 'inventario jogador-atualizado "http://din.uem.br")]) ; remove o site do Din do inventário
            (let ([jogador-atualizado-final
                   (atualiza 'inventario jogador-atualizado-completo "Senha do arquivo")]) ; remove a "senha do arquivo"
              (let ([ambiente-atualizado 
                     (atualiza 'estado ambiente #t)]) 
                (displayln "O item 'Chave Data Center' foi removido do seu inventário")
                (displayln "O Data Center foi destrancado!")
                (list jogador-atualizado-final ambiente-atualizado))))))
      (begin
        (displayln "Você precisa de uma chave para destrancar o Data Center.")
        (list jogador ambiente)))) ; jogador e data-center não são alterados

(define (inserir-cod-acesso jogador ambiente)
  (if (member "Senha do arquivo" (jogador-inventario jogador))
      (begin
        (let ([jogador-atualizado 
               (atualiza 'inventario jogador "Senha do arquivo")]) 
          (displayln "Inserindo código de acesso...")
          (displayln "Arquivo desbloqueado com sucesso.")
          (list jogador-atualizado)))
      (begin
        (displayln "Você precisa da senha do arquivo para desbloqueá-lo.")
        (list jogador ambiente)))) ; caso o jogador não tenha a senha, nada muda
           
     
;; Interações possíveis com o objeto "Monitor de Rede"
(define (consultar-historico jogador ambiente)
  (displayln "Consultando histórico de rede..."))

(define (explorar-vulnerabilidades jogador ambiente)
  (if (member "http://din.uem.br" (jogador-inventario jogador))
      (begin
        (displayln "Explorando vulnerabilidades...")) 
      (begin
        (displayln "Você precisa do 'site do Din' no seu inventário para explorar vulnerabilidades.")
        (list jogador ambiente)))) ; Caso o jogador não tenha o item, nada muda



;; Interações possíveis com o objeto "Servidor Principal"
(define (inspecionar-logs jogador ambiente)
  (displayln "Inspecionando logs do servidor..."))

(define (descripto-senha jogador ambiente)
  (displayln "Descriptografando senha..."))


;; Interações possíveis com o objeto "Estação de Trabalho"
(define (analisar-trafego jogador ambiente)
  (displayln "Analisando tráfego de rede..."))

(define (identificar-anomalos jogador ambiente)
  (if (member "IP Anômalo" (jogador-inventario jogador))
      (begin
        (let ([jogador-atualizado 
               (atualiza 'inventario jogador "IP Anômalo")]) ; remove IP Anômalo
          (let ([jogador-atualizado-completo
                 (atualiza 'inventario jogador-atualizado "IP Local")]) ; remove IP Local
            (let ([jogador-atualizado-final
                   (atualiza 'inventario jogador-atualizado-completo "Senha do servidor")]) ; remove Senha do servidor
              (list jogador-atualizado-final ambiente))))) ; caso tenha "IP Anômalo"
      (begin
        (displayln "Nenhum IP Anômalo encontrado.") ; caso não tenha "IP Anômalo"
        (list jogador ambiente)))) ; retorna o jogador e ambiente inalterados

;; Interações possíveis com o objeto "Cabos Soltos"
(define (reconectar-cabos jogador ambiente)
  (displayln "Reconectando cabos..."))


;; Interações possíveis com o objeto "Controle de Energia"
(define (restaurar-energia jogador ambiente)
  (displayln "Restaurando energia..."))


;; Interações possíveis com o objeto "Gerador Principal"
(define (restaurar-gerador jogador ambiente)
  (if (member "Código do gerador" (jogador-inventario jogador))
      (begin
        (let ([jogador-atualizado 
               (atualiza 'inventario jogador "Código do gerador")]) ; remove Código do gerador
          (let ([jogador-atualizado-completo
                 (atualiza 'inventario jogador-atualizado "Código para reiniciar o sistema")]) ; remove Código para reiniciar o sistema
            (let ([jogador-atualizado-final
                   (atualiza 'inventario jogador-atualizado-completo "Sequência de cabos correta")]) ; remove Sequência de cabos correta
              (list jogador-atualizado-final ambiente)))))
      (begin
        (displayln "Você precisa do Código do gerador.")
        (list jogador ambiente))))

  
;; Interações possíveis com o objeto "Computadores Especializados"
(define (acessar-ferramentas-cripto jogador ambiente)
  (displayln "Acessando ferramentas de criptografia..."))

(define (decifrar-mensagem-cifrada jogador ambiente)
  (displayln "Decifrando mensagem cifrada..."))


;; Interações possíveis com o objeto "Livros de Criptografia"
(define (consultar-livros jogador ambiente)
  (displayln "Consultando livros de criptografia..."))

(define (buscar-tecnica-cripto jogador ambiente)
  (displayln "Buscando técnica de criptografia..."))

  
;; Interações possíveis com o objeto "Quadro Branco"
(define (analisar-anotacoes jogador ambiente)
  (displayln "Analisando anotações no quadro..."))

(define (resolver-quebra-cabeca jogador ambiente)
  (if (member "Chave Sala do Hacker Rival" (jogador-inventario jogador))
      (begin
        (let ([jogador-atualizado 
               (atualiza 'inventario jogador "Chave Sala do Hacker Rival")]) ; remove a chave da sala do Hacker Rival
          (let ([jogador-atualizado-completo
                 (atualiza 'inventario jogador-atualizado "Ferramentas de Substituição por Palavra-Chave")]) ; remove Ferramentas de Substituição por Palavra-Chave
            (let ([jogador-atualizado-final
                   (atualiza 'inventario jogador-atualizado-completo "Técnica de decodificação Vigenère")]) ; remove Técnica de decodificação Vigenère
              (let ([ambiente-atualizado 
                     (atualiza 'estado ambiente #t)]) ; libera o acesso à sala do Hacker Rival
                (displayln "O item 'Chave Sala do Hacker Rival' foi removido do seu inventário")
                (displayln "Acesso à Sala do Hacker Rival liberado!")
                (list jogador-atualizado-final ambiente-atualizado))))))
      (begin
        (displayln "Você precisa da chave para abrir a Sala do Hacker Rival.")
        (list jogador ambiente))))

  
;; Interações possíveis com o objeto "Computador do Rival"
(define (quebrar-senha jogador ambiente)
  (displayln "Quebrando a senha do sistema do rival..."))

(define (desativar-sistema jogador ambiente)
  (displayln "Desativando sistema do rival..."))

;; Interações possíveis com o objeto "Telas de Monitoramento"
(define (resgatar-arquivo jogador ambiente)
  (if (member "Comando correto para desligar o sistema" (jogador-inventario jogador))
      (begin
        (let ([jogador-atualizado 
               (atualiza 'inventario jogador "Comando correto para desligar o sistema")]) ; remove o comando correto
          (let ([jogador-atualizado-completo
                 (atualiza 'inventario jogador-atualizado "Acesso ao computador do hacker rival")]) ; remove o acesso ao computador
            (displayln "O arquivo crucial foi resgatado com sucesso!")
            (list jogador-atualizado-completo ambiente))))
      (begin
        (displayln "Você precisa do comando correto para desligar o sistema do rival.")
        (list jogador ambiente)))) 