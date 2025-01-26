;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Interações

;; Interações possíveis com o objeto "Teclado Desgastado"
(define (examinar-simbolos jogador ambiente)
  (displayln "Examinando os símbolos no teclado...")
  (iniciar-enigma arquivo-criptografado jogador))

;; Interações possíveis com o objeto "Painel de Controle"
(define (destrancar-data-center jogador ambiente)
  (if (member "Chave Data Center" (jogador-inventario jogador)) 
      (begin
        (let* ([jogador-atualizado (atualiza 'inventario jogador "Chave Data Center")] ; remove a chave do inventário
               [ambiente-atualizado (atualiza 'objetos ambiente (list painel-controle))]
               [ambiente-atualizado-enigmas (atualiza 'enigmas ambiente-atualizado (list arquivo-criptografado))])
          (displayln "O item 'Chave Data Center' foi removido do seu inventário")
          (displayln "O Data Center foi destrancado!")
          (iniciar-enigma descriptografar-senha jogador-atualizado)))
      (begin
        (displayln "Você precisa de uma chave para destrancar o Data Center.")
        (list jogador ambiente)))) ; jogador e data-center não são alterados

(define (inserir-cod-acesso jogador ambiente)
  (if (member "Senha do arquivo" (jogador-inventario jogador))
      (begin
        (displayln "Inserindo código de acesso...")
        (displayln "Arquivo desbloqueado com sucesso.")
        (let* ([jogador-atualizado (atualiza 'inventario jogador "Senha do arquivo")]
               [ambiente-atualizado (atualiza 'objetos ambiente (list teclado-desgastado))]
               [ambiente-atualizado-enigmas (atualiza 'enigmas ambiente-atualizado (list arquivo-criptografado))])
          (iniciar-enigma quebrar-senha jogador-atualizado)))
      (begin
        (displayln "Você precisa da senha do arquivo para desbloqueá-lo.")
        (list jogador ambiente))))

;; Interações possíveis com o objeto "Monitor de Rede"
(define (explorar-vulnerabilidades jogador ambiente)
  (if (member "http://din.uem.br" (jogador-inventario jogador))
      (begin
        (displayln "Explorando vulnerabilidades...")
        (let* ([jogador-atualizado (atualiza 'inventario jogador "http://din.uem.br")]
               [ambiente-atualizado (atualiza 'objetos ambiente (list monitor-rede))]
               [ambiente-atualizado-enigmas (atualiza 'enigmas ambiente-atualizado (list quebrar-senha))])           
        (iniciar-enigma explorar-vulnerabilidade jogador-atualizado)))
      (begin
        (displayln "Você precisa do 'http://din.uem.br' no seu inventário para explorar vulnerabilidades.")
        (list jogador ambiente)))) ; Caso o jogador não tenha o item, nada muda
;; ATE AQUI TA TUDO OK (EM TESE)








;;
;; essa função não faz sentido, mas vou deixar salva se for útil futuramente
;;
(define (identificar-anomalos jogador ambiente)
  (if (member "IP Anômalo" (jogador-inventario jogador))
      (begin
        (let* ([jogador-atualizado 
                (atualiza 'inventario jogador "IP Anômalo")] ; remove IP Anômalo
               [jogador-atualizado-completo
                (atualiza 'inventario jogador-atualizado "IP Local")] ; remove IP Local
               [jogador-atualizado-final
                (atualiza 'inventario jogador-atualizado-completo "Senha do servidor")]) ; remove Senha do servidor
          (list jogador-atualizado-final ambiente))) ; retorna o jogador atualizado e o ambiente
      (begin
        (displayln "Nenhum IP Anômalo encontrado.") 
        (list jogador ambiente)))) 
