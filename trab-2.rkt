#lang racket
(require examples)

;; futuramente, separar as estruturas e funções internas das funções que manipulam os objetos em arquivos diferentes

(struct enigma (descricao solucao pistas efeito item))
;; Enigma representa ...?
;;   descricao: String - detalhamento do enigma.
;;   solucao  : String - resposta esperada.
;;   pistas   : list(String) - sugestões para ajudar na solução.
;;   efeito   : String - consequência de resolver o enigma.
;;   item     : list(String) - objeto(s) adicionado(s) ao inventário do jogador.

(define arquivo-criptografado (enigma "Cada letra carrega o peso de algo repetido infinitas vezes...\n\n‘     1    2   3    4   5   6   7   8   9   0  -  =  backspace\ntab   _   W   E   _  T   Y   U   I   O   P   ́  [   enter\ncapslock  A  S  D   _   _    H   _   K   _  Ç  ~   ]\nshift \\   Z   X   C   V   B   N   M   ,   .   /  shift\nctrl   fn   alt          space         ctrl    /"
                                      "CODING"
                                      (list "1:\n'Cada tecla desgastada do teclado é uma peça do quebra-cabeça. Mas cuidado com\nas armadilhas! Nem todas as letras estão onde parecem estar.'"
                                            "2:\n'A cifra é um jogo de troca. O que foi avançado deve agora recuar para revelar a verdade.'"
                                            "3:\n'Nem todas as combinações levam ao sucesso.Um passo é pouco, dois é demais,\nmas o terceiro é o caminho certo.'")
                                      "Acesso ao arquivo desbloqueado!\nA senha foi adicionada ao seu inventário."
                                      (list "Senha do arquivo")))

(define quebrar-senha (enigma "Esse arquivo contém o endereço para um local conhecido, mas inseguro…\nsggk://wrm.fvn.yi"
                              "http://din.uem.br"
                              (list "1: Quando as coisas parecem estar fora de ordem, lembre-se: às vezes, reverter é a chave para o progresso."
                                    "2: O segredo está no inverso da ordem usual. Se o alfabeto fosse uma estrada, imagine percorrê-la de costas. O final pode ser mais próximo do que parece."
                                    "3: No espelho, a ordem se inverte. Tente olhar para o alfabeto de um outro lado.")
                              "adiciona o endereço do site do DIN ao inventário do jogador"
                              (list "Endereço do site do DIN")))

(define explorar-vulnerabilidade (enigma "Não seguro! http://din.uem.br\nSua conexão com esse site não é segura. É recomendado não fornecer informações confidenciais a esse site (por exemplo, senhas ou cartões de crédito), porque elas podem ser roubadas por invasores."
                                         "https://din.uem.br"
                                         (list "1: Hackers Target Traditional Privacy Settings (hackers visam configurações tradicionais de privacidade)"
                                               "2: Handling Traffic Through Protected Servers (gerenciando o tráfego através de servidores protegidos)"
                                               "3: Hardening Technology Through Protected Security (fortalecendo a tecnologia através de segurança protegida)")
                                         "Acesso ao Data Center desbloqueado!\nUma chave foi adicionada ao seu inventário."
                                         (list "Chave Data Center")))


; ao imprimir a descrição do enigma, para respeitar as quebras de linhas, utilizar o método display
; (display (enigma-descricao arquivo-criptografado))

;; Enigma  String  Jogador -> Jogador
;;
;; Gerencia a resolução de um enigma.
;; Se a resposta fornecida for correta, o inventário do jogador é atualizado com o item do enigma.
;; Caso contrário, os pontos de vida do jogador são decrementados em 1.
;; Retorna o jogador atualizado.

(define (resolver-enigma enigma resposta player)
  (if (string=? (string-upcase resposta) (enigma-solucao enigma))
      ; resposta correta
      (let ([jogador-atualizado (struct-copy jogador player
                                            [inventario (append (jogador-inventario player) (enigma-item enigma))])])
        (displayln (enigma-efeito enigma))
        jogador-atualizado)
      ; resposta incorreta
      (let ([jogador-atualizado (struct-copy jogador player
                                             [pontos-vida (- (jogador-pontos-vida player) 1)])])
        (display "(!) Resposta incorreta. Tente novamente. Vidas restantes: ")
        (display (jogador-pontos-vida jogador-atualizado))
        jogador-atualizado)))

; utilizar funções de alta ordem para atualizar os campos de uma struct
;(define (atualizar-inv jogador novo-obj)
  ;(define player (jogador (jogador-nome jogador) (append (jogador-inventario jogador) novo-obj) (jogador-pontos-vida jogador) (jogador-localizacao jogador)))
  ;)


; (define p (iniciar-enigma arquivo-criptografado player))

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
        [(string=? entrada "pista") ; se o jogador quiser uma pista
         (if (null? pistas-restantes)
             (begin
               (displayln "Não há mais pistas disponíveis.")
               (loop pistas-restantes player-atualizado))
             (begin
               (displayln (string-append "\nPista " (first pistas-restantes)))
               (loop (rest pistas-restantes) player-atualizado)))]
        [else ; se o jogador inseriu uma tentativa de resposta
         (resolver-enigma enigma-iniciado entrada player-atualizado)])))
  (loop (enigma-pistas enigma-iniciado) player))
  

; begin -> agrupa e executa múltiplas expressões, retornando o valor da última expressão executada


(struct objeto (nome descricao interacao))
;; nome: Identificação do objeto.
;; descricao: Detalhes sobre o objeto.
;; interacao: Ação que pode ser realizada (ex.: chave, alavanca).

(define teclado-desgastado (objeto "Teclado Desgastado"
                                   "Descrição do Teclado Desgastado"
                                   (list)))
                                   ;(list digitar-comando examinar-simbolos)))

(define painel-controle (objeto "Painel de Controle"
                                "Descrição do Painel de Controle"
                                (list)))
                               ;(list reiniciar-sistema destrancar-data-center inserir-cod-acesso)))

(define monitor-rede (objeto "Monitor de Rede"
                             "Descrição do Monitor de Rede"
                             (list)))
                             ;(list consultar-historico explorar-vulnerabilidades)))

;; ação que pode ser realizada
;; inicia o enigma 1 -> decifrar criptografia de arquivo
;(define (examinar-simbolos jogador)
;  )

;; só pode ser iniciado ao finalizar o enigma 3, ou seja, com a chave
(define (destrancar-data-center jogador)
  (if (member "chave" (jogador-inventario jogador))
      (begin
        (displayln "O Data Center foi destrancado!")
        jogador) ; assim o jogador nao ta sendo alterado
      ; é preciso remover a chave do inventario (e avisar em uma mensagem)
      ; é preciso alterar o estado do data center de #f para #t, pois agora o acesso foi liberado
      (begin
        (displayln "Você precisa de uma chave para destrancar o Data Center.")
        jogador))) ; jogador e data-center não são alterados

(define (interagir objeto jogador)
  (cond
    [(string=? (objeto-interacao objeto) "chave")
     (if (member "chave" (jogador-inventario jogador))
         (displayln "Você usou a chave para destrancar algo.")
         (displayln "Você precisa de uma chave!"))]
    [else (displayln "Nada acontece.")]))

(struct ambiente (nome descricao objetos enigmas saida1 saida2 estado))
;; nome: Nome do ambiente (ex.: "Sala de Controle").
;; descricao: Texto descritivo do ambiente.
;; objetos: Lista de objetos presentes.
;; enigmas: Lista de enigmas associados ao ambiente.
;; saida1, saida2: Direções possíveis para outros ambientes. --> TRANSFORMAR EM LISTA
;; estado: Representação do status atual (#t = liberado ou #f = desbloqueado).

(define sala-rival (ambiente "Sala do Hacker Rival" "Descrição da Sala do Hacker Rival"
                             (list ) ; objetos
                             (list ) ; enigmas
                             #f #f
                             #f))

(define sala-emerg (ambiente "Sala de Emergência" "Descrição da Sala de Emergência"
                             (list ) ; objetos
                             (list ) ; enigmas
                             #f #f
                             #f))

(define lab-cripto (ambiente "Laboratório de Criptografia" "Descrição do Laboratório de Criptografia"
                             (list ) ; objetos
                             (list ) ; enigmas
                             sala-emerg #f
                             #f))

(define porao-energia (ambiente "Porão de Energia" "Descrição do Porão de Energia"
                                   (list ) ; objetos
                                   (list ) ; enigmas
                                   lab-cripto sala-rival
                                   #f))

(define data-center (ambiente "Data Center" "Descrição do Data Center"
                              (list ) ; objetos
                              (list arquivo-criptografado quebrar-senha explorar-vulnerabilidade) ; enigmas
                              lab-cripto #f
                              #f))

(define sala-controle (ambiente "Sala de Controle" "Descrição da Sala de Controle"
                                (list teclado-desgastado painel-controle monitor-rede) ; objetos
                                (list ); enigmas
                                data-center porao-energia
                                #t))

;; navegação pelos ambientes

(define (navegar ambiente escolha)
  (cond
    ;; se não houver saída disponível ou se a escolha for inválida, retorna o próprio ambiente
   [(string=? escolha "esquerda") (or (ambiente-saida1 ambiente) ambiente)]
   [(string=? escolha "direita") (or (ambiente-saida2 ambiente) ambiente)]
   [else ambiente]))  ;; escolha inválida

(define (explorar ambiente jogador)
  (displayln (ambiente-descricao ambiente))
  (displayln "Você vê os seguintes objetos:")
  (for-each displayln (map objeto-nome (ambiente-objetos ambiente)))
  (displayln "Digite o nome do objeto que deseja explorar")
  (filter (string-upcase (read-line)) (ambiente-objetos ambiente)))
  ;(displayln "Saídas disponíveis:")
  ;(for-each displayln (ambiente-saidas ambiente)))


(struct jogador (nome inventario pontos-vida localizacao) #:transparent)
;; nome: Nome do jogador.
;; inventario: Lista de objetos carregados.
;; pontos-vida: Quantidade de vida restante.
;; localizacao: Ambiente atual.

;(define player (jogador "Ana" '() 10 sala-controle))
; pensar em inicializar inventario com algum papel com código a ser decifrado futuramente
; a ideia é ter somente um jogador, já que a única interação é por linhas de comando
; mas para ser puramente funcional, não pode haver essa definição inicial (como uma global var)
; pedir no início do jogo para o jogador definir esse perfil
  
(define (executar-jogo)
  ; explicação inicial do funcionamento do jogo
  (displayln "Seja bem-vindo ao Scape Room: Hacker vs. Hacker!") ; melhorar isso

  ; escolha do nome do jogador
  (displayln "Digite o nome do jogador: ")
  (define nome-escolhido (read-line))
  (define player (jogador nome-escolhido '() 10 sala-controle))
    
  ; explicação do inventario, qtde de pontos de vida e localização inicial
  (displayln (string-append "\nOlá, " nome-escolhido "!\n\nVocê possui um inventário para guardar objetos valiosos para explorar o sistema, mas inicialmente ele está vazio.\n\nVocê possui 10 pontos de vida, que são subtraídos a cada tentativa incorreta nas soluções dos enigmas.\n\nPara cada enigma são disponibilizadas 3 pistas para te ajudar (elas não interferem nos pontos de vida).\n\nVocê está na Sala de Controle.\n"))

  ; função recursiva que faz o loop do jogo
  (define (loop-jogo jogador)
    (explorar (jogador-localizacao player) player)

    )

  (loop-jogo player)
  )


(define player (jogador "Ana" (list) 10 sala-controle))