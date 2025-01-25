#lang racket
(require examples)
(require "tad.rkt")

;; futuramente, separar as estruturas e funções internas das funções que manipulam os objetos em arquivos diferentes

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

(define descriptografar-senha (enigma "A quantidade de bits em um byte padrão.\nO número máximo que pode ser representado em 8 bits sem sinal.\nO total de combinações possíveis com 2 entradas em uma tabela verdade.\nO total de níveis de cache na maioria das CPUs modernas"
                                      "825543"
                                      (list "1: A senha está oculta em números, mas as palavras indicam a sequência."
                                            "2: Tente concatenar cada uma das suas descobertas."
                                            "3: Para resolver, pense nos fundamentos: bits, combinações e camadas... O segredo está na essência do hardware e do software.")
                                      "Decodificação bem sucedida!"
                                      (list "Senha do servidor")))

(define reconhecimento-ip (enigma "Um código misterioso pisca no monitor principal, como um sinal de alerta. Para acessá-lo, você deve decifrar o código Morse e obter o IP correto!\n.---- ..--- --... .-.-.- ----- .-.-.- ----- .-.-.- .----"
                                  "127.0.0.1"
                                  (list "1: Não esqueça: decifrar é apenas metade da batalha. Saber onde procurar é o verdadeiro segredo."
                                        "2: Você está mais perto do que imagina. Para decifrar, lembre-se: vá direto ao ponto... ou seria o traço?"
                                        "3: Dizem que sem esse número, nenhum hacker se sente em casa.")
                                  "IP reconhecido corretamente! Acesso às configurações de rede liberado."
                                  (list "IP Local")))

(define identificar-padrao-anomalo (enigma "Os logs da estação mostram um padrão incomum de acessos a um servidor crítico. A cada 5 segundos, um IP desconhecido está tentando acessar o sistema. Seu desafio é identificar o IP anômalo e bloquear a ameaça antes que seja tarde demais.\n\nAcessos nos últimos segundos:\n192.168.0.101\n192.168.0.102\n192.168.0.103\n10.0.0.255\n192.168.0.101\n192.168.0.102\n192.168.0.103\n10.0.0.255\n192.168.0.101\n192.168.0.102\n192.168.0.103\n10.0.0.255"
                                           "10.0.0.255"
                                           (list "1: A maioria segue um padrão previsível, mas um deles se destaca. Olhe com atenção."
                                                 "2: As redes locais geralmente começam com 192.168 ou 10.0.0, mas nem todo endereço é confiável."
                                                 "3: Algo está se repetindo muito rápido. Está fora do comum para um sistema legítimo...")
                                           "Acesso bloqueado com sucesso! O sistema está protegido novamente."
                                           (list "IP Anômalo")))

(define reconectar-cabos (enigma "Quatro cabos coloridos (Azul, Amarelo, Vermelho, Verde) estão desconectados. Você precisa conectá-los na sequência certa usando '->' para evitar uma sobrecarga."
                                 "Vermelho -> Verde -> Azul -> Amarelo"
                                 (list "1: Siga a lógica do semáforo, mas lembre-se de que Verde é o próximo passo."
                                       "2: Não se apresse, a ordem certa é fundamental para evitar um curto-circuito."
                                       "3: Entre o calor do vermelho e a calma do azul, o verde se destaca. Depois disso, o Sol brilha amarelo.")
                                 "Os cabos estão conectados e o gerador pode ser ligado."
                                 (list "Sequência de cabos correta")))

(define restaurar-energia (enigma "O painel de controle está piscando com códigos de erro. Digite o código correto para reiniciar o sistema."
                                  "2306"
                                  (list "1: Os códigos de erro são uma pista para o que está faltando. Tente pensar em um pioneiro da computação."
                                        "2: É alguém que fez uma contribuição significativa na decifração durante a guerra."
                                        "3: O aniversário deste gênio pode ser a chave para o código.")
                                  "Energia restaurada no sistema!"
                                  (list "Código para reiniciar o sistema")))

(define ativar-gerador (enigma "O gerador está quase pronto para funcionar, mas precisa de um código especial para ser ativado. Encontre o código no painel e digite a sequência correta.\n\n--------- PAINEL ---------\n| 4 | 8 | 1 | 5 | 1 | 6 |\n| 2 | 3 | 4 | 2 | 7 | 9 |\n--------------------------\nO código que você precisa está escondido aqui. A sequência correta pode estar bem visível entre outros números."
                               "4815162342"
                               (list "1: O código está escondido em uma anotação no painel."
                                     "2: Verifique se há algum padrão numérico que possa ser a chave."
                                     "3: Às vezes, a solução está bem à vista, entre outros números.")
                               "Gerador ativado com sucesso! O sistema está em pleno funcionamento."
                               (list "Código do gerador")))

(define decifrar-mensagem-cifrada (enigma "Uma mensagem enigmática foi interceptada. Ela está cifrada usando a cifra Vigenère. Mensagem cifrada: UPZVR NQ ZLPUD KRHMQ. Palavra-chave: SECURE."
                                          "PROTEGER OS DADOS É ESSENCIAL"
                                          (list "1: Nem toda cifra é estática. Às vezes, uma palavra é a chave que move os blocos de texto."
                                                "2: Você está seguro quando conhece a palavra certa. Ela sempre protege sua mensagem."
                                                "3: Procure ferramentas nos computadores, elas podem ajudá-lo a quebrar esta cifra dinâmica.")
                                          "Mensagem decifrada com sucesso!"
                                          (list "Técnica de decodificação Vigenère")))

(define encontrar-tecnica-criptografia (enigma "Um livro de criptografia contém uma técnica rara para proteger informações. Identifique o método descrito."
                                               "Cifra de Substituição por Palavra-Chave"
                                               (list "1: Letras podem ser reordenadas, mas algumas palavras abrem portas que outras não."
                                                     "2: O segredo está em uma combinação única e específica."
                                                     "3: A palavra-chave constrói o alfabeto. Observe os exemplos no livro.")
                                               "Técnica de criptografia identificada com sucesso!"
                                               (list "Ferramentas de Substituição por Palavra-Chave")))

(define resolver-quebra-cabeca-quadro-branco (enigma "No quadro branco, há um diagrama confuso de ligações entre servidores. Descubra a rota mais segura para transferir dados. Utilize '->' para demonstrar a rota.\n\n+----+     +----+     +----+     +----+\n| A  |---->| B  |---->| C  |---->| D  |\n+----+     +----+     +----+     +----+\n|                          ^\n|                          |\nv                          |\n+----+     +----+     +----+     +----+\n| E  |---->| F  |---->| G  |---->| H  |\n+----+     +----+     +----+     +----+\nA sua tarefa é escolher a rota mais segura entre A e H.\nCuidado com os pontos vulneráveis no caminho!"
                                                     "A -> E -> F -> G -> H"
                                                     (list "1: Nem sempre o caminho mais curto é o mais seguro."
                                                           "2: Procure padrões de proteção. Certifique-se de evitar os pontos vulneráveis."
                                                           "3: Considere as conexões que passam por pontos mais confiáveis e estáveis.")
                                                     "Rota segura identificada com sucesso!"
                                                     (list "Chave da sala do Hacker Rival")))

(define quebrar-senha-sistema (enigma "O computador do rival exige uma senha que combina lógica e observação. Ele esconde algo no número pi.\n\nDica: Os primeiros 6 dígitos do número pi podem ser a chave que você procura.\nLembre-se: o número pi começa com 3.14159...\n\nDigite a sequência correta para acessar o sistema." 
                                      "314159" 
                                      (list "1: Um número infinito, mas basta um começo. São apenas 6 dígitos."
                                            "2: Procure pela razão entre circunferência e diâmetro. Ele contém a resposta."
                                            "3: Uma constante em círculos, mas que transcende sua forma geométrica.") 
                                      "Senha correta! O computador foi desbloqueado com sucesso." 
                                      (list "Acesso ao computador do hacker rival")))

(define desativar-sistema-rival (enigma "No computador do rival, você encontra uma mensagem embaralhada que precisa ser decifrada para desligar o sistema.\n\nMensagem Embaralhada: otudnws -rhesver\n\nInsira o comando correto para desativar o sistema do rival." 
                                        "shutdown -reverse" 
                                        (list "1: As letras foram misturadas e comprimidas, mas a mensagem ainda está lá."
                                              "2: Procure por padrões e tente dividir a sequência em palavras."
                                              "3: Lembre-se da estrutura comum de comandos de terminal.") 
                                        "Sistema desativado com sucesso! O computador está desligado." 
                                        (list "Comando correto para desligar o sistema")))

(define enigma-final (enigma "O destino da missão está em suas mãos. O painel de monitoramento brilha com uma sequência numérica que parece aleatória, mas você sabe que ali se esconde a chave para acessar um arquivo crucial. Este é o último obstáculo. O tempo é curto e em breve o acesso ao painel de monitoramento será bloqueado. Você precisa decifrar o padrão escondido na sequência e inserir a resposta antes que seja tarde demais.\n\n-------------- TELA DE MONITORAMENTO ---------------\n|   2   |   4   |   8   |   16   |   32   |   64   |\n----------------------------------------------------\nO sistema está aguardando a próxima entrada na sequência." 
                             "128" 
                             (list "1: Cada número é o dobro do anterior. Pense em como as máquinas armazenam e processam dados." 
                                   "2: A sequência parece simples, mas o próximo número será o próximo na linha, seguindo uma progressão de duplicação." 
                                   "3: Os computadores adoram potências de dois. O que vem depois de 64?") 
                             "Parabéns, você decifrou o último enigma! O arquivo crucial foi recuperado e o sistema do hacker rival foi desativado. Você completou sua missão com sucesso!" 
                             (list "Troféu Chave-Mestra da Rede")))

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


; interações possíveis com o objeto "Teclado Desgastado"
;(define (digitar-comando))
;(define (examinar-simbolos))

; interações possíveis com o objeto "Painel de Controle"
;(define (reiniciar-sistema))

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

;(define (inserir-cod-acesso))

; interações possíveis com o objeto "Monitor de Rede"
;(define (consultar-historico))
;(define (explorar-vulnerabilidades))

(struct objeto (nome descricao interacao) #:transparent)
;; Um objeto é um  ...?
;;   nome: Identificação do objeto.
;;   descricao: Detalhes sobre o objeto.
;;   interacao: Ação que pode ser realizada (ex.: chave, alavanca).

(define teclado-desgastado (objeto "Teclado Desgastado"
                                   "Descrição do Teclado Desgastado"
                                   (list "ana" "paula")))
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
  
(define (interagir objeto jogador)
  (cond
    [(string=? (objeto-interacao objeto) "chave")
     (if (member "chave" (jogador-inventario jogador))
         (displayln "Você usou a chave para destrancar algo.")
         (displayln "Você precisa de uma chave!"))]
    [else (displayln "Nada acontece.")]))

(define (busca-objeto ambiente nome)
  (let ((objetos (ambiente-objetos ambiente))) ; Obtém a lista de objetos do ambiente
    (filter (λ (objeto) (string=? (string-upcase nome)
                                  (string-upcase (objeto-nome objeto))))
            objetos)))  ; retorna a lista filtrada diretamente


(struct ambiente (nome descricao objetos enigmas saida1 saida2 estado) #:transparent)
;; Um ambiente é ..?
;;   nome: Nome do ambiente (ex.: "Sala de Controle").
;;   descricao: Texto descritivo do ambiente.
;;   objetos: Lista de objetos presentes.
;;   enigmas: Lista de enigmas associados ao ambiente.
;;   saida1, saida2: Direções possíveis para outros ambientes. --> TRANSFORMAR EM LISTA
;;   estado: Representação do status atual (#t = liberado ou #f = desbloqueado).

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
                              (list teclado-desgastado painel-controle monitor-rede) ; objetos
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
  (define obj (first (busca-objeto ambiente (read-line)))) ; acessa o objeto a ser explorado
  (displayln "Você tem as possíveis interações:")
  (for-each displayln (objeto-interacao obj))
  (displayln "Digite o nome do objeto que deseja explorar")
  
  )
  
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
  (displayln (string-append "\nOlá, " nome-escolhido "!\n\n\tVocê possui um inventário para guardar objetos valiosos para explorar o sistema, mas inicialmente ele está vazio.\n\n\tVocê possui 10 pontos de vida, que são subtraídos a cada tentativa incorreta nas soluções dos enigmas.\n\n\tPara cada enigma são disponibilizadas 3 pistas para te ajudar (elas não interferem nos pontos de vida).\n\nVocê está na Sala de Controle.\n"))

  ; função recursiva que faz o loop do jogo
  (define (loop-jogo jogador)
    (explorar (jogador-localizacao player) player)

    )

  (loop-jogo player)
  )


(define player (jogador "Ana" (list) 10 sala-controle))
