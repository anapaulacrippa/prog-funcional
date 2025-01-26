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

    #|
    [(equal? campo 'objetos)
     (let ([ambiente-atualizado (struct-copy ambiente struct
                                                [objetos novo-valor])])
          ambiente-atualizado)]

    [(equal? campo 'enigmas)
     (let ([ambiente-atualizado (struct-copy ambiente struct
                                                [enigmas novo-valor])])
          ambiente-atualizado)]
    |#
    
    [(equal? campo 'objetos)
     (let ([ambiente-atualizado (struct-copy ambiente struct
                                                [objetos novo-valor])])
     (let ([ambiente-atualizado
            (if (member novo-valor (ambiente-objetos struct))  ; se o objeto já estiver no ambiente
                
                (struct-copy ambiente struct [objetos (filter (λ (objeto) (not (equal? objeto novo-valor))) (ambiente-objetos struct))]) ; remove o objeto
                
                (struct-copy ambiente struct [objetos (append (ambiente-objetos struct) novo-valor)]))]) ; caso contrário, adiciona o objeto
          ambiente-atualizado))]

    [(equal? campo 'enigmas)
     (let ([ambiente-atualizado (struct-copy ambiente struct
                                                [enigmas novo-valor])])
     (let ([ambiente-atualizado
            (if (member novo-valor (ambiente-enigmas struct))  ; se o enigma já estiver presente
                
                (struct-copy ambiente struct [enigmas (filter (λ (enigma) (not (equal? enigma novo-valor))) (ambiente-enigmas struct))]) ; remove o enigma
                
                (struct-copy ambiente struct [enigmas (append (ambiente-enigmas struct) novo-valor)]))]) ; caso contrário, adiciona o enigma
          ambiente-atualizado))]

    [(equal? campo 'estado)
     (let ([ambiente-atualizado (struct-copy ambiente struct
                                                [estado novo-valor])])
          ambiente-atualizado)]))

;; Enigma  String  Jogador -> Jogador
;;
;; Gerencia a resolução de um enigma.
;; Se a resposta fornecida for correta, o inventário do jogador é atualizado com o item do enigma.
;; Caso contrário, os pontos de vida do jogador são decrementados em 1.
;; Quando as vidas do jogador se esgotam, o jogo é encerrado
;; Retorna o jogador com os campos atualizados.

(define (resolver-enigma enigma resposta player)
  (cond
    ; se a resposta está correta
    [(string=? (string-upcase resposta) (string-upcase (enigma-solucao enigma)))
     (displayln (enigma-efeito enigma))
     (atualiza 'inventario player (enigma-item enigma))]
    ; se as vidas se esgotaram e a resposta for incorreta
    [(= 1 (jogador-pontos-vida player))
     (displayln "\n*************************************************\n\t\t\t\t\t\n\t\tGAME OVER!\t\t\n\tVocê gastou todas as suas vidas e\t\n\t\to jogo terminou.\t\t\t\n\t\t\t\t\t\t\n*************************************************")
     (exit)]
    ; se a resposta está incorreta, mas ainda há vidas
    [else
     (let ([jogador-atualizado (atualiza 'pontos-vida player -1)])
         (displayln (string-append "(!) Resposta incorreta. Tente novamente. Vidas restantes: " 
                                 (number->string (jogador-pontos-vida jogador-atualizado))))
        (resolver-enigma enigma (read-line) jogador-atualizado))]))
     
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
  (displayln (ambiente-descricao ambiente))
  (cond
    ; finalizaram as interações possíveis
    [(null? (ambiente-objetos ambiente))
     (displayln "\nSuas tarefas nesse ambiente foram finalizadas! Escolha sua próxima direção:")
     (displayln (ambiente-saida1))
     (navegar ambiente (read-line))
     ]
    [else
     ; ainda há interações possíveis
     (displayln "\nVocê vê os seguintes objetos:")
     (for-each displayln (map objeto-nome (ambiente-objetos ambiente)))
     (displayln "\nDigite o nome do objeto que deseja explorar")
     (define obj (first (busca-objeto ambiente (read-line)))) ; acessa o objeto a ser explorado
     ; interação do objeto escolhido e chamada para o enigma
     (define jog-atual ((objeto-interacao obj) jogador ambiente))
     ; com o enigma resolvido, remove-se o objeto do ambiente
     (define ambiente-atual (atualiza 'objetos ambiente (remove obj (ambiente-objetos ambiente))))
     (explorar ambiente-atual jog-atual)]
  ))


(define (executar-jogo)
  ; explicação inicial do funcionamento do jogo
  (displayln "Seja bem-vindo ao Scape Room: Hacker vs. Hacker!") ; melhorar isso

  ; escolha do nome do jogador
  (displayln "Digite o nome do jogador: ")
  (define nome-escolhido (read-line))
  (define player (jogador nome-escolhido '() 10 sala-controle))
    
  ; explicação do inventario, qtde de pontos de vida e localização inicial
  (displayln (string-append "\nOlá, " nome-escolhido "!\n\n\tVocê possui um inventário para guardar objetos valiosos para explorar o sistema, mas inicialmente ele está vazio.\n\n\tVocê possui 10 pontos de vida, que são subtraídos a cada tentativa incorreta nas soluções dos enigmas.\n\n\tPara cada enigma são disponibilizadas 3 pistas para te ajudar (elas não interferem nos pontos de vida).\n\nVocê está na Sala de Controle."))

  ; função recursiva que faz o loop do jogo
  (define (loop-jogo jogador)
    (explorar (jogador-localizacao player) player)

    )

  (loop-jogo player)
  )



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Instâncias por ambientes


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; (5) DATA CENTER

;; Jogador Ambiente -> (list Jogador Ambiente)
;;
;; Representa uma interação possível com o objeto "Servidor Principal".
;; Inicia o enigma "Descriptografar Senha".

(define (descobrir-senha jogador ambiente)
  (displayln "\nDescriptografando senha...")
  (iniciar-enigma descriptografar-senha jogador))

;; Objeto 1
(define servidor-principal (objeto "Servidor Principal" "A peça central do sistema. Um terminal exibe informações críticas e opções avançadas de acesso." 
                                   (list descobrir-senha))) ; interações

;; Enigma 1
(define descriptografar-senha (enigma "A quantidade de bits em um byte padrão.\nO número máximo que pode ser representado em 8 bits sem sinal.\nO total de combinações possíveis com 2 entradas em uma tabela verdade.\nO total de níveis de cache na maioria das CPUs modernas"
                                      "825543"
                                      (list "1: A senha está oculta em números, mas as palavras indicam a sequência."
                                            "2: Tente concatenar cada uma das suas descobertas."
                                            "3: Para resolver, pense nos fundamentos: bits, combinações e camadas... O segredo está na essência do hardware e do software.")
                                      "Decodificação bem sucedida!"
                                      (list "Senha do servidor")))

;; Jogador Ambiente -> (list Jogador Ambiente)
;;
;; Representa uma interação possível com o objeto "Estação de Trabalho".
;; Inicia o enigma "Identificar Padrões Anômalos".

(define (descobrir-anomalos jogador ambiente)
  (displayln "\nDescriptografando senha...")
  (iniciar-enigma identificar-anomalo jogador))

;; Objeto 2
(define estacao-trabalho (objeto "Estação de Trabalho" 
                                 "Uma estação com múltiplos monitores exibindo gráficos, logs de rede e alertas de segurança." 
                                 (list descobrir-anomalos))) ; interações

;; Enigma 2
(define identificar-anomalo (enigma "Os logs da estação mostram um padrão incomum de acessos a um servidor crítico. A cada 5 segundos, um IP desconhecido está tentando acessar o sistema. Seu desafio é identificar o IP anômalo e bloquear a ameaça antes que seja tarde demais.\n\nAcessos nos últimos segundos:\n192.168.0.101\n192.168.0.102\n192.168.0.103\n10.0.0.255\n192.168.0.101\n192.168.0.102\n192.168.0.103\n10.0.0.255\n192.168.0.101\n192.168.0.102\n192.168.0.103\n10.0.0.255"
                                    "10.0.0.255"
                                    (list "1: A maioria segue um padrão previsível, mas um deles se destaca. Olhe com atenção."
                                          "2: As redes locais geralmente começam com 192.168 ou 10.0.0, mas nem todo endereço é confiável."
                                          "3: Algo está se repetindo muito rápido. Está fora do comum para um sistema legítimo...")
                                    "Acesso bloqueado com sucesso! O sistema está protegido novamente."
                                    (list "IP Anômalo")))

(define data-center (ambiente "Data Center" "Aqui fica o servidor principal do sistema e você pode coletar dados críticos"
                              (list servidor-principal estacao-trabalho)  ; objetos
                              (list descriptografar-senha )  ; enigmas
                              #f #f ; lab-cripto #f  ; saídas possíveis
                              #f))  ; acesso bloqueado, inicialmente

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; (6) SALA DE CONTROLE

;; Jogador  Ambiente -> Enigma | Jogador
;;
;; Representa a interação possível com o objeto "Teclado Desgastado".
;; Inicia o enigma "Arquivo Criptografado"

(define (examinar-simbolos jogador ambiente)
  (displayln "\nExaminando os símbolos no teclado...") (iniciar-enigma arquivo-criptografado jogador))

;; Objeto 1
(define teclado-desgastado (objeto "Teclado Desgastado" "Um teclado velho e usado, com algumas teclas apagadas. Pode ser útil para inserir comandos."
                                   examinar-simbolos))

;; Enigma 1
(define arquivo-criptografado (enigma "Cada letra carrega o peso de algo repetido infinitas vezes...\n\n‘     1    2   3    4   5   6   7   8   9   0  -  =  backspace\ntab   _   W   E   _  T   Y   U   I   O   P   ́  [   enter\ncapslock  A  S  D   _   _    H   _   K   _  Ç  ~   ]\nshift \\   Z   X   C   V   B   N   M   ,   .   /  shift\nctrl   fn   alt          space         ctrl    /"
                                      "CODING"
                                      (list "1:\n'Cada tecla desgastada do teclado é uma peça do quebra-cabeça. Mas cuidado com\nas armadilhas! Nem todas as letras estão onde parecem estar.'"
                                            "2:\n'A cifra é um jogo de troca. O que foi avançado deve agora recuar para revelar a verdade.'"
                                            "3:\n'Nem todas as combinações levam ao sucesso.Um passo é pouco, dois é demais,\nmas o terceiro é o caminho certo.'")
                                      "Acesso ao arquivo desbloqueado!\nA senha foi adicionada ao seu inventário."
                                      (list "Senha do arquivo")))

;; Jogador Ambiente -> (list Jogador Ambiente)
;;
;; Representa uma interação possível com o objeto "Painel de Controle".
;; Inicia o enigma "Quebrar Senha".

(define (inserir-cod-acesso jogador ambiente)
  (if (member "Senha do arquivo" (jogador-inventario jogador))
      (begin
        (displayln "Inserindo código de acesso...\nArquivo desbloqueado com sucesso.")
        (let* ([jogador-atualizado (atualiza 'inventario jogador "Senha do arquivo")]
               [ambiente-atualizado (atualiza 'objetos ambiente (list teclado-desgastado))]
               [ambiente-atualizado-enigmas (atualiza 'enigmas ambiente-atualizado (list arquivo-criptografado))])
          (iniciar-enigma quebrar-senha jogador-atualizado)))
      (begin
        (displayln "Você precisa da senha do arquivo para desbloqueá-lo.")
        (list jogador ambiente))))

;; Objeto 2
(define painel-controle (objeto "Painel de Controle" "Um painel com diversas luzes e botões. Ele monitora e gerencia o acesso ao sistema." 
                                inserir-cod-acesso))

;; Enigma 2
(define quebrar-senha (enigma "Esse arquivo contém o endereço para um local conhecido, mas inseguro…\nsggk://wrm.fvn.yi"
                              "http://din.uem.br"
                              (list "1: Quando as coisas parecem estar fora de ordem, lembre-se: às vezes, reverter é a chave para o progresso."
                                    "2: O segredo está no inverso da ordem usual. Se o alfabeto fosse uma estrada, imagine percorrê-la de costas. O final pode ser mais próximo do que parece."
                                    "3: No espelho, a ordem se inverte. Tente olhar para o alfabeto de um outro lado.")
                              "adiciona o endereço do site do DIN ao inventário do jogador"
                              (list "Endereço do site do DIN")))

;; Jogador Ambiente -> (list Jogador Ambiente)
;;
;; Representa uma interação possível com o objeto "Monitor de Rede".
;; Inicia o enigma "Explorar Vulnerabilidades".

(define (brecha-sistema jogador ambiente)
  (if (member "http://din.uem.br" (jogador-inventario jogador))
      (begin
        (displayln "Explorando vulnerabilidades...")
        (iniciar-enigma explorar-vulnerabilidades jogador))
      (begin
        (displayln "Você precisa do 'http://din.uem.br' no seu inventário para explorar vulnerabilidades.")
        (list jogador ambiente)))) ; Caso o jogador não tenha o item, nada muda

;; Objeto 3
(define monitor-rede (objeto "Monitor de Rede" "Um monitor que exibe conexões de rede e informações em tempo real." 
                             brecha-sistema))

;; Enigma 3
(define explorar-vulnerabilidades (enigma "Não seguro! http://din.uem.br\nSua conexão com esse site não é segura. É recomendado não fornecer informações confidenciais a esse site (por exemplo, senhas ou cartões de crédito), porque elas podem ser roubadas por invasores."
                                         "https://din.uem.br"
                                         (list "1: Hackers Target Traditional Privacy Settings (hackers visam configurações tradicionais de privacidade)"
                                               "2: Handling Traffic Through Protected Servers (gerenciando o tráfego através de servidores protegidos)"
                                               "3: Hardening Technology Through Protected Security (fortalecendo a tecnologia através de segurança protegida)")
                                         "Acesso ao Data Center desbloqueado!\nUma chave foi adicionada ao seu inventário."
                                         (list "Chave Data Center")))


(define sala-controle (ambiente "Sala de Controle" "\nO ponto de partida, onde você fará a análises e monitoramentos do sistema."
                                (list teclado-desgastado painel-controle monitor-rede) ; objetos
                                (list arquivo-criptografado quebrar-senha explorar-vulnerabilidades) ; enigmas
                                data-center #f ; porao-energia ; saídas disponíveis
                                #t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; (3) PORÃO DE ENERGIA

(define porao-energia (ambiente "Porão de Energia" "Descrição do Porão de Energia"
                                   (list ) ; objetos
                                   (list ) ; enigmas
                                   #f #f ;lab-cripto sala-rival
                                   #f))

;; Interação 1
;; Objeto 1
;; Enigma 1

;; Interação 2
;; Objeto 2
;; Enigma 2

;; Interação 3
;; Objeto 3
;; Enigma 3

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; (4) LABORATÓRIO DE CRIPTOGRAFIA




;; Interação 1
;; Objeto 1
;; Enigma 1

;; Interação 2
;; Objeto 2
;; Enigma 2

;; Interação 3
;; Objeto 3
;; Enigma 3




(define player (jogador "Ana" '() 10 sala-controle))
