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
;;   descricao: String       - texto explicativo do enigma.
;;   solucao  : String       - resposta esperada.
;;   pistas   : list(String) - sugestões para ajudar na solução.
;;   efeito   : String       - consequência de resolver o enigma.
;;   item     : list(String) - objeto(s) adicionado(s) ao inventário do jogador após a solução.

(struct objeto (nome descricao interacao) #:transparent)
;; Um objeto é um item interativo que pertence a um ambiente.
;;   nome     : String        - identificação do objeto.
;;   descricao: String        - detalhes sobre o objeto.
;;   interacao: (list String) - ação que pode ser realizada a partir do objeto. Podem iniciar enigmas. 

(struct ambiente (nome descricao objetos enigmas saida1 saida2 estado) #:transparent)
;; Um ambiente representa uma sala que contém objetos interativos, enigmas e conexões com outros ambientes.
;;   nome          : String             - nome do ambiente.
;;   descricao     : String             - detalhes sobre o ambiente.
;;   objetos       : (list objeto)      - objetos presentes para interação.
;;   enigmas       : (list enigma)      - enigmas associados ao ambiente.
;;   saida1, saida2: ambiente | Boolean - direções possíveis para outros ambientes. Caso não haja saídas disponíveis, representado por #f.
;;   estado        : Boolean            - status atual do ambiente (#t para acesso liberado ou #f para acesso desbloqueado).



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Instâncias por ambientes


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; (1) SALA DE CONTROLE

(define teclado-desgastado (objeto "Teclado Desgastado" "Um teclado velho e usado, com algumas teclas apagadas. Pode ser útil para inserir comandos."
                                   (list examinar-simbolos)))

;; Jogador  Ambiente -> Enigma | Jogador
;;
;; Representa a interações possível com o objeto "Teclado Desgastado".
;; Inicia o enigma "Arquivo Criptografado"

(define (examinar-simbolos jogador ambiente)
  (displayln "Examinando os símbolos no teclado...") (iniciar-enigma arquivo-criptografado jogador))

(define arquivo-criptografado (enigma "Cada letra carrega o peso de algo repetido infinitas vezes...\n\n‘     1    2   3    4   5   6   7   8   9   0  -  =  backspace\ntab   _   W   E   _  T   Y   U   I   O   P   ́  [   enter\ncapslock  A  S  D   _   _    H   _   K   _  Ç  ~   ]\nshift \\   Z   X   C   V   B   N   M   ,   .   /  shift\nctrl   fn   alt          space         ctrl    /"
                                      "CODING"
                                      (list "1:\n'Cada tecla desgastada do teclado é uma peça do quebra-cabeça. Mas cuidado com\nas armadilhas! Nem todas as letras estão onde parecem estar.'"
                                            "2:\n'A cifra é um jogo de troca. O que foi avançado deve agora recuar para revelar a verdade.'"
                                            "3:\n'Nem todas as combinações levam ao sucesso.Um passo é pouco, dois é demais,\nmas o terceiro é o caminho certo.'")
                                      "Acesso ao arquivo desbloqueado!\nA senha foi adicionada ao seu inventário."
                                      (list "Senha do arquivo")))

(define painel-controle (objeto "Painel de Controle" 
                                "Um painel com diversas luzes e botões. Ele monitora e gerencia o acesso ao sistema." 
                                (list inserir-cod-acesso destrancar-data-center)))

;; Jogador Ambiente -> (list Jogador Ambiente)
;;
;; Representa uma interação possível com o objeto "Painel de Controle".
;; Inicia o enigma "Quebrar Senha".

(define (inserir-cod-acesso jogador ambiente)
  (if (member "Senha do arquivo" (jogador-inventario jogador))
      (begin
        (displayln "Inserindo código de acesso...")
        (displayln "Arquivo desbloqueado com sucesso.")
        (iniciar-enigma quebrar-senha jogador)) 
      (begin
        (displayln "Você precisa da senha do arquivo para desbloqueá-lo.")
        (list jogador ambiente))))

(define quebrar-senha (enigma "Esse arquivo contém o endereço para um local conhecido, mas inseguro…\nsggk://wrm.fvn.yi"
                              "http://din.uem.br"
                              (list "1: Quando as coisas parecem estar fora de ordem, lembre-se: às vezes, reverter é a chave para o progresso."
                                    "2: O segredo está no inverso da ordem usual. Se o alfabeto fosse uma estrada, imagine percorrê-la de costas. O final pode ser mais próximo do que parece."
                                    "3: No espelho, a ordem se inverte. Tente olhar para o alfabeto de um outro lado.")
                              "adiciona o endereço do site do DIN ao inventário do jogador"
                              (list "Endereço do site do DIN")))

;; Jogador  Ambiente -> (list Jogador Ambiente)
;;
;; Representa uma interação possível com o objeto "Painel de Controle".

(define (destrancar-data-center jogador ambiente)
  (if (member "Chave Data Center" (jogador-inventario jogador)) 
      (begin
        (let* ([jogador-atualizado 
                (atualiza 'inventario jogador "Chave Data Center")] ; remove a chave do inventário
               [jogador-atualizado-completo
                (atualiza 'inventario jogador-atualizado "http://din.uem.br")] ; remove o site do Din do inventário
               [jogador-atualizado-final
                (atualiza 'inventario jogador-atualizado-completo "Senha do arquivo")] ; remove a "senha do arquivo"
               [ambiente-atualizado 
                (atualiza 'estado ambiente #t)]) ; atualiza o estado do ambiente
          (displayln "O item 'Chave Data Center' foi removido do seu inventário")
          (displayln "O Data Center foi destrancado!")
          (list jogador-atualizado-final ambiente-atualizado)))
      (begin
        (displayln "Você precisa de uma chave para destrancar o Data Center.")
        (list jogador ambiente)))) ; jogador e data-center não são alterados

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; (2) DATA CENTER


;; Enigmas


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

;; Objetos


(define monitor-rede (objeto "Monitor de Rede" 
                             "Um monitor que exibe conexões de rede e informações em tempo real." 
                             (list consultar-historico explorar-vulnerabilidades))) ; interacoes

(define servidor-principal (objeto "Servidor Principal" 
                                   "A peça central do sistema. Um terminal exibe informações críticas e opções avançadas de acesso." 
                                   (list insepcionar-logs descripto-senha)))

(define estacao-trabalho (objeto "Estação de Trabalho" 
                                 "Uma estação com múltiplos monitores exibindo gráficos, logs de rede e alertas de segurança." 
                                 (list analisar-trafego identificar-anomalos)))

(define cabos-soltos (objeto "Cabos Soltos"
                             "Cabos espalhados pela sala, parcialmente desconectados. Eles fazem parte de um sistema mais complexo, devem ser ligados na sequência certa." 
                             (list arrumar-cabos)))

(define painel-controle-energia (objeto "Painel de Controle de Energia"
                                        "Um painel de controle com diversos botões e luzes piscando. Para um sistema de energia instável, o painel é a chave para restaurar a energia." 
                                        (list arrumar-energia)))

(define gerador-principal (objeto "Gerador Principal"
                                  "O gerador garante o fornecimento de energia sempre que há falhas na corrente elétrica, assegurando a continuidade do sistema." 
                                  (list restaurar-gerador)))

(define computadores-especializados (objeto "Computadores Especializados"
                                            "Uma estação de computadores com software avançado projetada para tarefas de criptografia e análise de dados."
                                            (list acessar-ferramentas-cripto decifrar-mensagem-cifrada)))

(define livros-criptografia (objeto "Livros de Criptografia"
                                    "Uma coleção de livros e manuais detalhando técnicas e algoritmos criptográficos, tanto clássicos quanto modernos."
                                    (list consultar-livros buscar-tecnica-cripto)))

(define quadro-branco (objeto "Quadro Branco com Anotações"
                              "Um quadro branco cheio de anotações."
                              (list analisar-anotacoes resolver-quebra-cabeca)))

(define computador-rival (objeto "Computador do Rival"
                                 "Um computador altamente protegido, com várias camadas de segurança. O sistema precisa ser acessado para desativar o controle do hacker rival."
                                 (list quebrar-senha desativar-sistema)))

(define telas-monitoramento (objeto "Telas de Monitoramento"
                                    "Uma série de telas mostrando dados do sistema e da rede. Elas escondem informações cruciais."
                                    (list resgatar-arquivo)))

;; Ambientes

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
                              (list arquivo-criptografado quebrar-senha brecha-sistema) ; enigmas
                              lab-cripto #f
                              #f))

(define sala-controle (ambiente "Sala de Controle" "Descrição da Sala de Controle"
                                (list teclado-desgastado painel-controle monitor-rede) ; objetos
                                (list ); enigmas
                                data-center porao-energia
                                #t))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Interações 


           
;; Interações possíveis com o objeto "Monitor de Rede"
(define (explorar-vulnerabilidades jogador ambiente)
  (if (member "http://din.uem.br" (jogador-inventario jogador))
      (begin
        (displayln "Explorando vulnerabilidades...")
        (iniciar-enigma brecha-sistema jogador))
      (begin
        (displayln "Você precisa do 'http://din.uem.br' no seu inventário para explorar vulnerabilidades.")
        (list jogador ambiente)))) ; Caso o jogador não tenha o item, nada muda


;; Interações possíveis com o objeto "Servidor Principal"
(define (descripto-senha jogador ambiente)
  (displayln "Descriptografando senha...")
  (iniciar-enigma descriptografar-senha jogador))


;; Interações possíveis com o objeto "Estação de Trabalho"
(define (analisar-trafego jogador ambiente)
  (displayln "Analisando tráfego de rede...")
  (iniciar-enigma reconhecimento-ip jogador))

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


;; Interações possíveis com o objeto "Cabos Soltos"
(define (arrumar-cabos jogador ambiente)
  (displayln "Reconectando cabos...")
  (iniciar-enigma reconectar-cabos jogador))


;; Interações possíveis com o objeto "Controle de Energia"
(define (arrumar-energia jogador ambiente)
  (displayln "Restaurando energia...")
  (iniciar-enigma restaurar-energia))

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
