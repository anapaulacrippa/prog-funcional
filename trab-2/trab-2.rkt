#lang racket

(require examples)
(require "tad.rkt")
(provide (all-defined-out))


;; Campo  Struct  (list Any) | Any -> Struct
;;
;; Atualiza um campo especificado de uma struct, de acordo com o novo valor informado.
;; Retorna a struct atualizada.

(define (atualiza campo struct novo-valor)
  (cond
    [(equal? campo 'nome)
     (let ([jogador-atualizado (struct-copy jogador struct
                                                    [nome novo-valor])])
              jogador-atualizado)]
    
    [(equal? campo 'inventario)
     (let ([jogador-atualizado
            (if (member novo-valor (jogador-inventario struct))  ; se o item já estiver no inventário
                
                (struct-copy jogador struct [inventario (filter (λ (item) (not (equal? item novo-valor))) (jogador-inventario struct))]) ; remove o item
                
                (struct-copy jogador struct [inventario (append (jogador-inventario struct) novo-valor)]))]) ; caso contrário, adiciona o item
       jogador-atualizado)]

    [(equal? campo 'localizacao)
     (let ([jogador-atualizado (struct-copy jogador struct
                                               [localizacao novo-valor])])
          jogador-atualizado)]
    
    [(equal? campo 'pontos-vida)
     (let ([jogador-atualizado (struct-copy jogador struct [pontos-vida (- (jogador-pontos-vida struct) 1)])])
       jogador-atualizado)]

    ;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    ;;
    ;; JUNTAR TODAS AS 3 CLÁUSULAS ABAIXO, ELAS FAZEM A MESMA COISA NO AMBIENTE
    ;;
    ;; SOBRE O CASO QUE ALTERA O ESTADO DE ACESSO DO AMBIENTE DE #f (BLOQUEADO) PARA #t (LIBERADO),
    ;; ISSO DEVE OCORRER QUANDO O JOGADOR CONSEGUE A PASSAGEM DE UM PARA OUTRO AMBIENTE (OU SEJA, QUANDO RESOLVE
    ;; TODOS OS ENIGMAS DE UM AMBIENTE, ISTO É, A LISTA DE ENIGMAS DO AMBIENTE ESTÁ VAZIA) -> ISSO DEVE SER VERIFICADO,
    ;; MAS PENSO QUE PODE SER EM UMA FUNÇÃO A PARTE...
    ;;
    ;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    [(equal? campo 'objetos)
     (let ([ambiente-atualizado (struct-copy ambiente struct
                                                [objetos novo-valor])])
          ambiente-atualizado)]

    [(equal? campo 'enigmas)
     (let ([ambiente-atualizado (struct-copy ambiente struct
                                                [enigmas novo-valor])])
          ambiente-atualizado)]

    [(equal? campo 'estado)
     (let ([ambiente-atualizado (struct-copy ambiente struct
                                                [estado novo-valor])])
          ambiente-atualizado)]))
#|
;; Casos de teste da função 'atualiza'
(define player (jogador "" '() 10 "Sala de Controle"))
(define player1 (atualiza 'nome player "Alice"))
(define player3 (atualiza 'inventario player1 "Chave"))
(define player4 (atualiza 'localizacao player3 "Data Center"))

(define lugar (ambiente "Ponto de Partida" "Sala de análises e monitoramentos" '("Mesa") '("Enigma 1") "Porão de Energia" "Data Center" #f))
(define lugar1 (atualiza 'objetos lugar '("Mesa" "Computador")))
(define lugar2 (atualiza 'estado lugar1 #t))

(examples
  (check-equal? player1 (jogador "Alice" '() 10 "Sala de Controle"))
  (check-equal? player3 (jogador "Alice" '("Chave") 10 "Sala de Controle"))
  (check-equal? player4 (jogador "Alice" '("Chave") 10 "Data Center"))
  (check-equal? lugar1 (ambiente "Ponto de Partida" "Sala de análises e monitoramentos" '("Mesa" "Computador") '("Enigma 1") "Porão de Energia" "Data Center" #f))
  (check-equal? lugar2 (ambiente "Ponto de Partida" "Sala de análises e monitoramentos" '("Mesa" "Computador") '("Enigma 1") "Porão de Energia" "Data Center" #t)))
|#

;; Enigma  String  Jogador -> Jogador
;;
;; Gerencia a resolução de um enigma.
;; Se a resposta fornecida for correta, o inventário do jogador é atualizado com o item do enigma.
;; Caso contrário, os pontos de vida do jogador são decrementados em 1.
;; Retorna o jogador atualizado.

(define (resolver-enigma enigma resposta player)
  (if (string=? (string-upcase resposta) (string-upcase (enigma-solucao enigma)))
      ; resposta correta
      (begin
        (displayln (enigma-efeito enigma))
        (atualiza 'inventario player (enigma-item enigma))
        
        ; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        ;
        ; aqui é necessário remover o objeto ao qual o enigma resolvido está associado no ambiente
        ;
        ; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        )
      
      ; resposta incorreta
      
      (let ([jogador-atualizado (struct-copy jogador player
                                             [pontos-vida (- (jogador-pontos-vida player) 1)])])
        (display "(!) Resposta incorreta. Tente novamente. Vidas restantes: ")
        (display (jogador-pontos-vida jogador-atualizado))
        jogador-atualizado)))


;; Enigma  Jogador -> Enigma | Jogador
;;
;; Inicia a resolução de um enigma.
;; Gerencia a quantidade de pistas disponíveis para o jogador e as mostra, caso solicitadas.

(define (iniciar-enigma enigma-iniciado player)
  (displayln (enigma-descricao enigma-iniciado))
  (define (loop pistas-restantes player-atualizado)
    (displayln "\n\n\nVocê tem direito a 3 pistas no total.\n\nCaso deseje alguma, digite 'pista'.\n\nCaso contrário, insira sua resposta:")
    (let ((entrada (string-downcase (read-line))))
      (cond
        [(string=? entrada "pista")   ; se o jogador quiser uma pista
         (if (null? pistas-restantes)
             (begin
               (displayln "Não há mais pistas disponíveis.")
               (loop pistas-restantes player-atualizado))
             (begin
               (displayln (string-append "\nPista " (first pistas-restantes)))
               (loop (rest pistas-restantes) player-atualizado)))]
        [else   ; se o jogador inseriu uma tentativa de resposta
         (resolver-enigma enigma-iniciado entrada player-atualizado)])))
  (loop (enigma-pistas enigma-iniciado) player))
  

; begin -> agrupa e executa múltiplas expressões, retornando o valor da última expressão executada


(define (destrancar-data-center jogador) ; só pode ser iniciado ao finalizar o enigma 3, ou seja, com a chave
  (if (member "chave" (jogador-inventario jogador))
      (begin
        (displayln "O Data Center foi destrancado!")
        jogador) ; assim o jogador nao ta sendo alterado
      ; é preciso remover a chave do inventario (e avisar em uma mensagem)
      ; é preciso alterar o estado do data center de #f para #t, pois agora o acesso foi liberado
      (begin
        (displayln "Você precisa de uma chave para destrancar o Data Center.")
        jogador))) ; jogador e data-center não são alterados


;; String  Jogador -> ??
;;
;; Recebe o objeto escolhido para interação pelo jogador em formato de texto

(define (interagir objeto jogador)        ;; ESSA FUNÇÃO AINDA NÃO ESTÁ PRONTA, SÓ COPIEI DA ESPECIFICAÇÃO DO PROFESSOR
  (cond
    [(string=? objeto "chave")
     (if (member "chave" (jogador-inventario jogador))
         (displayln "Você usou a chave para destrancar algo.")
         (displayln "Você precisa de uma chave!"))]
    [else (displayln "Nada acontece.")]))


;; Ambiente String -> (list Objeto)
;;
;; Recebe o nome do objeto a ser buscado no ambiente especificado.
;; Retorna uma lista com o objeto encontrado.

(define (busca-objeto ambiente nome)
  (let ((objetos (ambiente-objetos ambiente))) ; obtém a lista de objetos do ambiente
    (filter (λ (objeto) (string=? (string-upcase nome)
                                  (string-upcase (objeto-nome objeto))))
            objetos)))  ; retorna a lista filtrada diretamente


;; navegação pelos ambientes

(define (navegar ambiente escolha)
  (cond
    ;; se não houver saída disponível ou se a escolha for inválida, retorna o próprio ambiente
   [(string=? escolha "esquerda") (or (ambiente-saida1 ambiente) ambiente)]
   [(string=? escolha "direita") (or (ambiente-saida2 ambiente) ambiente)]
   [else ambiente]))  ;; escolha inválida

(define (explorar ambiente jogador)
  (displayln (ambiente-descricao ambiente)) (displayln "Você vê os seguintes objetos:")
  (for-each displayln (map objeto-nome (ambiente-objetos ambiente)))
  (displayln "Digite o nome do objeto que deseja explorar")
  (define obj (first (busca-objeto ambiente (read-line)))) ; acessa o objeto a ser explorado
  
  (displayln "Você tem as possíveis interações:")
  (for-each displayln (objeto-interacao obj))
  (displayln "Digite o nome da interação desejada") ; nao gostei disso, tenho q mudar
  (interagir (read-line) jogador obj)  

  
  
  ;(displayln "Saídas disponíveis:")
  ;(for-each displayln (ambiente-saidas ambiente)))


(define (executar-jogo)
  ; explicação inicial do funcionamento do jogo
  (displayln "Seja bem-vindo ao Scape Room: Hacker vs. Hacker!") ; melhorar isso

  ; escolha do nome do jogador
  (displayln "Digite o nome do jogador: ")
  (define nome-escolhido (read-line))
  (define player (jogador nome-escolhido '() 10 sala-controle))
    
  ; explicação do inventario, qtde de pontos de vida e localização inicial
  (displayln (string-append "\nOlá, " nome-escolhido "!\n\n\tVocê possui um inventário para guardar objetos valiosos para explorar o sistema, mas inicialmente ele está vazio.\n\n\tVocê possui 10 pontos de vida, que são subtraídos a cada tentativa incorreta nas soluções dos enigmas.\n\n\tPara cada enigma são disponibilizadas 3 pistas para te ajudar (elas não interferem nos pontos de vida).\n\nVocê está na Sala de Controle.\n"))

  ; função recursiva que faz o loop do jogo
  (define (loop-jogo jogador)
    (explorar (jogador-localizacao player) player)

    )

  (loop-jogo player)
  )

(define player (jogador "Ana" '() 10 sala-controle))
