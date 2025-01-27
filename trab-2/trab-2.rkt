#lang racket

(require examples)
(require "tad.rkt")
(provide (all-defined-out))

;; Campo  Struct  (list Any) | Any -> Struct
;;
;; Atualiza um campo especificado de uma struct, de acordo com o novo valor informado.
;; Retorna a struct atualizada.

(define (atualiza campo struct novo)
  (cond
    [(equal? campo 'nome)
     (let ([jogador-atualizado (struct-copy jogador struct
                                                    [nome novo])])
              jogador-atualizado)]
    
    [(equal? campo 'inventario)
     (let ([jogador-atualizado
            (if (member novo (jogador-inventario struct))  ; se o item já estiver no inventário
                
                (struct-copy jogador struct [inventario (filter (λ (item) (not (equal? item novo))) (jogador-inventario struct))]) ; remove o item
                
                (struct-copy jogador struct [inventario (append (jogador-inventario struct) novo)]))]) ; caso contrário, adiciona o item
       jogador-atualizado)]

    [(equal? campo 'localizacao)
     (let ([jogador-atualizado (struct-copy jogador struct
                                               [localizacao novo])])
          jogador-atualizado)]
    
    [(equal? campo 'pontos-vida)
     (let ([jogador-atualizado (struct-copy jogador struct [pontos-vida (- (jogador-pontos-vida struct) 1)])])
       jogador-atualizado)]
    ))

;; Enigma  String  Jogador -> Jogador
;;
;; Gerencia a resolução de um enigma.
;; Se a resposta fornecida for correta, o inventário do jogador é atualizado com o item do enigma.
;; Caso contrário, os pontos de vida do jogador são decrementados em 1.
;; Quando as vidas do jogador se esgotam, o jogo é encerrado.
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
    (displayln "\n***************************************************************************************************************************************************\nVocê tem direito a 3 pistas no total.\n\nCaso deseje alguma, digite 'pista'. Caso contrário, insira sua resposta:")
    (let ((entrada (string-downcase (read-line))))
      (cond
        ; se o jogador solicitou uma pista
        [(string=? entrada "pista")
         (if (null? pistas-restantes)
             (begin
               (displayln "Não há mais pistas disponíveis.")
               (loop pistas-restantes player-atualizado))
             (begin
               (displayln (string-append "\nPista " (first pistas-restantes)))
               (loop (rest pistas-restantes) player-atualizado)))]
        ; se o jogador inseriu uma tentativa de resposta
        [else
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


;; Ambiente  Jogador -> Jogador
;;
;; Recebe o ambiente de destino do jogador, o atualiza para esse novo local e 

(define (navegar ambiente jogador)
  (cond
    [(false? (ambiente-saida ambiente))
     (displayln "GAME WIN! Parabéns! Você concluiu o jogo com êxito!\nFeito com <3 por Ana Paula e Pâmela")]
    [else
     (display (ambiente-nome (ambiente-saida ambiente)))
     (displayln (ambiente-descricao ambiente))
     (explorar ambiente (atualiza 'localizacao jogador ambiente))]))

(define (explorar sala jogador)
  (cond
    ; finalizaram as interações possíveis
    [(null? (ambiente-objetos sala))
     (displayln "\nSuas tarefas nesse ambiente foram finalizadas! :D\nSua próxima direção é:")
     ; leva o jogador para o ambiente seguinte
     (navegar (ambiente-saida sala) jogador)]
    [else
     ; ainda há interações possíveis
     (displayln "\nVocê vê os seguintes objetos:") (for-each displayln (map objeto-nome (ambiente-objetos sala)))
     (displayln "\nDigite o nome do objeto que deseja explorar")
     (define obj (first (busca-objeto sala (read-line))))  ; acessa o objeto a ser explorado
     (displayln (objeto-descricao obj))
     (define jog-atual ((objeto-interacao obj) jogador sala))  ; interação do objeto escolhido e chamada para o enigma
     (explorar (struct-copy ambiente sala [objetos (remove obj (ambiente-objetos sala))]) ; com o enigma resolvido, remove-se o objeto do ambiente
               jog-atual)]
  ))


(define (executar-jogo)
  ; explicação inicial do funcionamento do jogo
  (displayln "Seja bem-vindo ao Escape Room: Hacker vs. Hacker!") ; melhorar isso

  ; escolha do nome do jogador
  (displayln "Digite o nome do jogador: ")
  (define nome-escolhido (read-line))
  (define player (jogador nome-escolhido '() 10 sala-controle))
    
  ; explicação do inventario, qtde de pontos de vida e localização inicial
  (displayln (string-append "\nOlá, " nome-escolhido "!\n\n\tVocê possui um inventário para guardar objetos valiosos para explorar o sistema, mas inicialmente ele está vazio.\n\n\tVocê possui 10 pontos de vida, que são subtraídos a cada tentativa incorreta nas soluções dos enigmas.\n\n\tPara cada enigma são disponibilizadas 3 pistas para te ajudar (elas não interferem nos pontos de vida).\n\nVocê está na Sala de Controle."))

  ; exploração dos ambientes, partindo da Sala de Controle
  (displayln (ambiente-descricao sala-controle))
  (explorar (jogador-localizacao player) player))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Instâncias por ambientes

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; (1) SALA DO HACKER RIVALS

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
;; (2) LABORATÓRIO DE CRIPTOGRAFIA

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
;; (3) PORÃO DE ENERGIA

;; Jogador Ambiente -> Enigma | Jogador
;;
;; Representa uma interação possível com o objeto "Cabos Soltos".
;; Inicia o enigma "Reconectar Cabos".

(define (arrumar-cabos jogador ambiente)
  (displayln "Reconectando cabos...") (iniciar-enigma reconectar-cabos jogador))

;; Objeto 1
(define cabos-soltos (objeto "Cabos Soltos" "\nCabos espalhados pela sala, parcialmente desconectados. Eles fazem parte de um sistema mais complexo, devem ser ligados na sequência certa." 
                             arrumar-cabos))  ; interação

;; Enigma 1
(define reconectar-cabos (enigma "\nQuatro cabos coloridos (Azul, Amarelo, Vermelho, Verde) estão desconectados.\nVocê precisa conectá-los na sequência certa usando '->' para evitar uma sobrecarga."
                                 "Vermelho -> Verde -> Azul -> Amarelo"
                                 (list "1:\nSiga a lógica do semáforo, mas lembre-se de que Verde é o próximo passo."
                                       "2:\nNão se apresse, a ordem certa é fundamental para evitar um curto-circuito."
                                       "3:\nEntre o calor do vermelho e a calma do azul, o verde se destaca. Depois disso, o Sol brilha amarelo.")
                                 "Os cabos estão conectados e o gerador pode ser ligado. A sequência de cabos correta foi adicionada ao seu inventário."
                                 (list "Sequência de cabos correta: Vermelho -> Verde -> Azul -> Amarelo")))

;; Jogador Ambiente -> Enigma | Jogador
;;
;; Representa uma interação possível com o objeto "Painel de Controle de Energia".
;; Inicia o enigma "Restaurar Energia".

(define (arrumar-energia jogador ambiente)
  (displayln "Restaurando energia...") (iniciar-enigma restaurar-energia jogador))

;; Objeto 2
(define painel-controle-energia (objeto "Painel de Controle de Energia" "\nUm painel de controle com diversos botões e luzes piscando. Para um sistema de energia instável, o painel é a chave para restaurar a energia." 
                                        arrumar-energia))  ; interação

;; Enigma 2
(define restaurar-energia (enigma "\nO painel de controle está piscando com códigos de erro. Digite o código correto para reiniciar o sistema."
                                  "2306"
                                  (list "1:\nOs códigos de erro são uma pista para o que está faltando. Tente pensar em um pioneiro da computação."
                                        "2:\nÉ alguém que fez uma contribuição significativa na decifração durante a guerra."
                                        "3:\nO aniversário deste gênio pode ser a chave para o código.")
                                  "Energia restaurada no sistema! O código para reiniciar o sistema foi adicionado ao seu inventário."
                                  (list "Código para reiniciar o sistema: 2306")))

;; Jogador Ambiente -> Enigma | Jogador
;;
;; Representa uma interação possível com o objeto "Gerador Principal".
;; Inicia o enigma "Ativar Gerador".

(define (restaurar-gerador jogador ambiente)
  (displayln "Restaurando e ativando gerador...")
  (iniciar-enigma ativar-gerador jogador))

;; Objeto 3
(define gerador-principal (objeto "Gerador Principal" "O gerador garante o fornecimento de energia sempre que há falhas na corrente elétrica, assegurando a continuidade do sistema." 
                                  restaurar-gerador))  ; interação

;; Enigma 3
(define ativar-gerador (enigma "\nO gerador está quase pronto para funcionar, mas precisa de um código especial para ser ativado. Encontre o código no painel e digite a sequência correta.\n\n--------- PAINEL ---------\n| 4 | 8 | 1 | 5 | 1 | 6 |\n| 2 | 3 | 4 | 2 | 7 | 9 |\n--------------------------\nO código que você precisa está escondido aqui. A sequência correta pode estar bem visível entre outros números."
                               "4815162342"
                               (list "1:\nO código está escondido em uma anotação no painel."
                                     "2:\nVerifique se há algum padrão numérico que possa ser a chave."
                                     "3:\nÀs vezes, a solução está bem à vista, entre outros números.")
                               "Gerador ativado com sucesso! O sistema está em pleno funcionamento. O código do gerador foi adicionado ao seu inventário."
                               (list "Código do gerador: 4815162342")))

(define porao-energia (ambiente "Porão de Energia" "Local onde você restaura a energia (não a sua). Os geradores antigos e os paineis piscando mostram que há algo fora do lugar."
                                   (list cabos-soltos ) ; objetos
                                   #f ; lab-cripto ; saída possível
                                   ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; (4) DATA CENTER

;; Jogador Ambiente -> Enigma | Jogador
;;
;; Representa uma interação possível com o objeto "Servidor Principal".
;; Inicia o enigma "Descriptografar Senha".

(define (descobrir-senha jogador ambiente)
  (displayln "\nDescriptografando senha...") (iniciar-enigma descriptografar-senha jogador))

;; Objeto 1
(define servidor-principal (objeto "Servidor Principal" "\nA peça central do sistema. Um terminal exibe informações críticas e opções avançadas de acesso." 
                                   descobrir-senha))  ; interação

;; Enigma 1
(define descriptografar-senha (enigma "\nA quantidade de bits em um byte padrão.\nO número máximo que pode ser representado em 8 bits sem sinal.\nO total de combinações possíveis com 2 entradas em uma tabela verdade.\nO total de níveis de cache na maioria das CPUs modernas"
                                      "825543"
                                      (list "1:\nA senha está oculta em números, mas as palavras indicam a sequência."
                                            "2:\nTente concatenar cada uma das suas descobertas."
                                            "3:\nPara resolver, pense nos fundamentos: bits, combinações e camadas... O segredo está na essência do hardware e do software.")
                                      "Decodificação bem sucedida!"
                                      (list "Senha do servidor")))

;; Jogador Ambiente -> Enigma | Jogador
;;
;; Representa uma interação possível com o objeto "Estação de Trabalho".
;; Inicia o enigma "Identificar Padrões Anômalos".

(define (descobrir-anomalos jogador ambiente)
  (displayln "\nDescriptografando senha...") (iniciar-enigma identificar-anomalo jogador))

;; Objeto 2
(define estacao-trabalho (objeto "Estação de Trabalho" 
                                 "\nUma estação com múltiplos monitores exibindo gráficos, logs de rede e alertas de segurança." 
                                 descobrir-anomalos))  ; interação

;; Enigma 2
(define identificar-anomalo (enigma "\nOs logs da estação mostram um padrão incomum de acessos a um servidor crítico. A cada 5 segundos, um IP desconhecido está tentando acessar o sistema.\nSeu desafio é identificar o IP anômalo e bloquear a ameaça antes que seja tarde demais.\n\nAcessos nos últimos segundos:\n192.168.0.101\n192.168.0.102\n192.168.0.103\n10.0.0.255\n192.168.0.101\n192.168.0.102\n192.168.0.103\n10.0.0.255\n192.168.0.101\n192.168.0.102\n192.168.0.103\n10.0.0.255"
                                    "10.0.0.255"
                                    (list "1:\nA maioria segue um padrão previsível, mas um deles se destaca. Olhe com atenção."
                                          "2:\nAs redes locais geralmente começam com 192.168 ou 10.0.0, mas nem todo endereço é confiável."
                                          "3:\nAlgo está se repetindo muito rápido. Está fora do comum para um sistema legítimo...")
                                    "Acesso anômalo bloqueado com sucesso! O sistema está protegido novamente."
                                    (list "IP Anômalo")))

(define data-center (ambiente "Data Center" "\nAqui fica o servidor principal do sistema e você pode coletar dados críticos"
                              (list servidor-principal estacao-trabalho)  ; objetos
                              porao-energia))  ; saída possível
                              
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; (5) SALA DE CONTROLE

;; Jogador  Ambiente -> Enigma | Jogador
;;
;; Representa a interação possível com o objeto "Teclado Desgastado".
;; Inicia o enigma "Arquivo Criptografado"

(define (examinar-simbolos jogador ambiente)
  (displayln "\nExaminando os símbolos no teclado...") (iniciar-enigma arquivo-criptografado jogador))

;; Objeto 1
(define teclado-desgastado (objeto "Teclado Desgastado" "Um teclado velho e usado, com algumas teclas apagadas. Pode ser útil para inserir comandos."
                                   examinar-simbolos))  ; interação

;; Enigma 1
(define arquivo-criptografado (enigma "\nCada letra carrega o peso de algo repetido infinitas vezes...\n\n‘     1    2   3    4   5   6   7   8   9   0  -  =  backspace\ntab   _   W   E   _  T   Y   U   I   O   P   ́  [   enter\ncapslock  A  S  D   _   _    H   _   K   _  Ç  ~   ]\nshift \\   Z   X   C   V   B   N   M   ,   .   /  shift\nctrl   fn   alt          space         ctrl    /"
                                      "CODING"
                                      (list "1:\nCada tecla desgastada do teclado é uma peça do quebra-cabeça. Mas cuidado com\nas armadilhas! Nem todas as letras estão onde parecem estar."
                                            "2:\nA cifra é um jogo de troca. O que foi avançado deve agora recuar para revelar a verdade."
                                            "3:\nNem todas as combinações levam ao sucesso.Um passo é pouco, dois é demais,\nmas o terceiro é o caminho certo.")
                                      "Inserindo código de acesso...\n...\nAcesso ao arquivo desbloqueado!\nA senha foi adicionada ao seu inventário."
                                      (list "Senha do arquivo")))

;; Jogador Ambiente -> Enigma | Jogador
;;
;; Representa uma interação possível com o objeto "Painel de Controle".
;; Inicia o enigma "Quebrar Senha".

(define (inserir-cod-acesso jogador ambiente) (iniciar-enigma quebrar-senha jogador))

;; Objeto 2
(define painel-controle (objeto "Painel de Controle" "Um painel com diversas luzes e botões. Ele monitora e gerencia o acesso ao sistema." 
                                inserir-cod-acesso))  ; interação

;; Enigma 2
(define quebrar-senha (enigma "\nEsse arquivo contém o endereço para um local conhecido, mas inseguro…\nsggk://wrm.fvn.yi"
                              "http://din.uem.br"
                              (list "1:\nQuando as coisas parecem estar fora de ordem, lembre-se: às vezes, reverter é a chave para o progresso."
                                    "2:\nO segredo está no inverso da ordem usual. Se o alfabeto fosse uma estrada, imagine percorrê-la de costas. O final pode ser mais próximo do que parece."
                                    "3:\nNo espelho, a ordem se inverte. Tente olhar para o alfabeto de um outro lado.")
                              "O endereço do site (inseguro) do DIN foi adicionado ao seu inventário. Seja cauteloso! :O"
                              (list "http://din.uem.br")))

;; Jogador Ambiente -> Enigma | Jogador
;;
;; Representa uma interação possível com o objeto "Monitor de Rede".
;; Inicia o enigma "Explorar Vulnerabilidades".

(define (brecha-sistema jogador ambiente)
  (displayln "\nExplorando vulnerabilidades...") (iniciar-enigma explorar-vulnerabilidades jogador))

;; Objeto 3
(define monitor-rede (objeto "Monitor de Rede" "Um monitor que exibe conexões de rede e informações em tempo real."
                             brecha-sistema))  ; interação

;; Enigma 3
(define explorar-vulnerabilidades (enigma "\nNão seguro! http://din.uem.br\nSua conexão com esse site não é segura. É recomendado não fornecer informações confidenciais a esse site (por exemplo, senhas ou cartões de crédito),\nporque elas podem ser roubadas por invasores."
                                         "https://din.uem.br"
                                         (list "1:\nHackers Target Traditional Privacy Settings (hackers visam configurações tradicionais de privacidade)"
                                               "2:\nHandling Traffic Through Protected Servers (gerenciando o tráfego através de servidores protegidos)"
                                               "3:\nHardening Technology Through Protected Security (fortalecendo a tecnologia através de segurança protegida)")
                                         "\nAcesso ao Data Center desbloqueado!\nUma chave foi adicionada ao seu inventário."
                                         (list "Chave Data Center")))

(define sala-controle (ambiente "Sala de Controle" "\nO ponto de partida, onde você fará análises e monitoramentos do sistema."
                                (list teclado-desgastado painel-controle monitor-rede)  ; objetos
                                data-center))  ; saída disponível                                
