; *********************************************************************
; * IST-UL
; * Modulo:    grupo32.asm
; * Descrição: Projeto do grupo 32
; *
; *********************************************************************

; **********************************************************************
; * Constantes
; **********************************************************************

DISPLAYS                    EQU 0A000H          ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN                     EQU 0C000H          ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL                     EQU 0E000H          ; endereço das colunas do teclado (periférico PIN)
LINHA1                      EQU 1               ; 1ª linha
MASCARA_TECLA               EQU 0FH             ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
MASCARA_GERADOR_ALEATORIO   EQU 0F0H            ; para isolar os 4 bits do maior peso (pseudo-aleatórias)

TECLA_SONDA_ESQ             EQU 0               ; tecla para lancar uma sonda a esquerda (tecla 0)
TECLA_SONDA_CENT            EQU 1               ; tecla para lancar uma sonda no centro (tecla 1)
TECLA_SONDA_DIR             EQU 2               ; tecla para lancar uma sonda a direita (tecla 2)
TECLA_INICIO_JOGO           EQU 12              ; tecla para iniciar o jogo (tecla C)
TECLA_PAUSA                 EQU 13              ; tecla para pausa e continuar o jogo (tecla D)
TECLA_TERMINA               EQU 14              ; tecla para pausa e continuar o jogo (tecla E)
MODO_SEM_ENERGIA            EQU 15              ; para terminar o jogo quando energia é esgotada
MODO_EXPLOSAO               EQU 16              ; para terminar o jogo com explosão
CRIA_ASTEROIDE              EQU 17              ; para criar um asteroide quando um for destruido

JOGO_INICIADO               EQU 1               ; jogo iniciado
JOGO_PAUSA                  EQU 0               ; jogo em pausa
JOGO_TERMINADO              EQU 2               ; jogo terminado

INICIO_ENERGIA              EQU 100             ; valor inicial da energia
ENERGIA_SONDA               EQU -5              ; gasto da energia pelo disparo de uma sonda
FATOR_INICIAL               EQU 1000            ; fator para obter digitos para colocar no display

COMANDOS			        EQU	6000H			; endereço de base dos comandos do MediaCenter

LE_COR_PIXEL		        EQU	COMANDOS + 10H	; endereço do comando para ler a cor de um pixel
ESTADO_PIXEL		        EQU	COMANDOS + 14H	; endereço do comando para ler o estado de um pixel (ligado-1, desligado-0)
DEFINE_LINHA    	        EQU COMANDOS + 0AH	; endereço do comando para definir a linha
DEFINE_COLUNA   	        EQU COMANDOS + 0CH	; endereço do comando para definir a coluna
DEFINE_PIXEL    	        EQU COMANDOS + 12H	; endereço do comando para escrever um pixel
APAGA_AVISO     	        EQU COMANDOS + 40H	; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRA	 		        EQU COMANDOS + 02H	; endereço do comando para apagar todos os pixels já desenhados
FUNDO_ECRA                  EQU COMANDOS + 42H	; endereço do comando para selecionar uma imagem de fundo
MSG                         EQU COMANDOS + 46H  ; endereço do comando para sobrepor uma imagem (mensagem) à imagem de fundo
APAGA_MSG                   EQU COMANDOS + 44H  ; endereço do comando para apagar a imagem sobreposta
REPRODUZ_SOM_VIDEO          EQU COMANDOS + 5AH  ; endereço do comando para reproduzir um som ou video
PARA_SOM_VIDEO              EQU COMANDOS + 68H  ; endereço do comando para para todos os sons e videos

FUNDO_INICIAL               EQU 0               ; ordem da imagem para o fundo inicial
FUNDO_JOGO                  EQU 1               ; ordem da imagem para o fundo durante o jogo
FUNDO_EXPLOSAO              EQU 2               ; ordem da imagem para o fundo quando um asteroide colide com a nave
FUNDO_ENERGIA               EQU 3               ; ordem da imagem para o fundo quando a nave fica sem energia
FUNDO_TERMINA               EQU 4               ; ordem da imagem para o fundo quando o utilizador decide terminar o jogo

MSG_INICIAR                 EQU 5               ; mensagem a apresentar antes de iniciar o jogo
MSG_PAUSA                   EQU 6               ; mensagem a apresentar com o jogo em pausa
MSG_EXPLOSAO                EQU 7               ; mensagem a apresentar quando um asteroide colide com a nave
MSG_SEM_ENERGIA             EQU 8               ; mensagem a apresentar quando a nave fica sem energia
MSG_TERMINA                 EQU 9               ; mensagem a apresentar quando o utilizador decide terminar o jogo

SOM_INICIO                  EQU 0               ; som quando o jogo é iniciado
SOM_DISPARO                 EQU 1               ; som quando uma sonda é disparada
SOM_AST_DESTRUIDO           EQU 2               ; som quando um asteroide é destruido
SOM_AST_MINERADO            EQU 3               ; som quando um asteroide é minerado
SOM_EXPLOSAO                EQU 4               ; som quando um asteroide colide com a nave
SOM_PAUSA                   EQU 5               ; som duranto a pausa do jogo
SOM_SEM_ENERGIA             EQU 6               ; som quando a nave fica sem energia
SOM_TERMINA                 EQU 7               ; som quando o utilizador decide terminar o jogo

LINHA_TOPO        	        EQU 0               ; linha do topo do ecrã
LINHA_BASE                  EQU 32              ; linha da base do ecrã
COLUNA_ESQ			        EQU 0               ; coluna mais à esquerda
COLUNA_CENT                 EQU 32              ; coluna central
COLUNA_DIR                  EQU 63              ; coluna mais à direita

LINHA_PAINEL                EQU 27              ; linha do painel da nave
LINHA_CIMA_PAINEL	        EQU 26		        ; linha acima do painel
COLUNA_PAINEL               EQU 25              ; coluna do painel da nave

COLUNA_SONDA_ESQ            EQU 26              ; coluna inicial de uma sonda a esquerda
COLUNA_SONDA_DIR            EQU 38              ; coluna inicial de uma sonda a direita

GASTO_ENERGIA_TEMPO         EQU -3              ; valor de energia gasto pela nave a cada 3 segundos
VALOR_RECURSOS              EQU 25              ; valor dos recursos em energia
ALCANCE_SONDA               EQU 12              ; alcance da sonda
SONDA_NAO_LANCADA           EQU 62              ; soma da linha e coluna quando a sonda não é lançada

DIRECAO_ESQ                 EQU -1              ; para mover um objeto a esquerda
DIRECAO_CENT                EQU 0               ; para mover um objeto verticalmente
DIRECAO_DIR                 EQU 1               ; para mover um objeto a direita

LARGURA_SONDA               EQU 1               ; largura das sondas
ALTURA_SONDA                EQU 1               ; altura das sondas

LARGURA_AST			        EQU	5		        ; largura do asteroide
ALTURA_AST                  EQU 5               ; altura do asteroide 

LARGURA_PAINEL              EQU 15              ; largura do painel da nave
ALTURA_PAINEL               EQU 5               ; altura do painel da nave

LARGURA_LUZES               EQU 11              ; largura dos luzes do painel
ALTURA_LUZES                EQU 2               ; altura dos luzes do painel

PROX_ANIM_PAINEL            EQU 48              ; para obter os pixels do proximo animação do painel      

PIXEL_VERM		            EQU	0FF00H	        ; pixel vermelho opaco
PIXEL_VERM_TRANS            EQU	0FF00H	        ; pixel vermelho translucido
PIXEL_VERD                  EQU 0F0F0H          ; pixel verde opaco 
PIXEL_VERD_TRANS            EQU 0F0F0H          ; pixel verde translucido 
PIXEL_AZUL                  EQU 0F0BFH          ; pixel azul opaco 
PIXEL_VIOLETA               EQU 0FA3CH          ; pixel violeta opaco 
PIXEL_AMAR                  EQU 0FFF0H          ; pixel opaco amarelo
PIXEL_CAST                  EQU 0F850H          ; pixel opaco castanho
PIXEL_AMAR_TRANS            EQU 05FF0H          ; pixel amarelo translucido 
PIXEL_CINZ_ESC              EQU 0F777H          ; pixel cinzento escuro opaco 
PIXEL_CINZ_CLA              EQU 0FFFFH          ; pixel cinzento claro opaco 

N_ASTEROIDES                EQU 4               ; nº de asteroides em simultaneo
N_SONDA                     EQU 3               ; nº de sondas em simultaneo
TAMANHO_PILHA		        EQU 100H            ; tamanho de cada pilha, em words

; *********************************************************************************
; * Dados 
; *********************************************************************************

	PLACE       1000H

; Reserva do espaço para as pilhas dos processos
	STACK TAMANHO_PILHA		                    ; espaço reservado para a pilha do processo "programa principal"
SP_inicial_prog_princ:		                    ; este é o endereço com que o SP deste processo deve ser inicializado

	STACK TAMANHO_PILHA		                    ; espaço reservado para a pilha do processo "programa principal"
SP_inicial_energia:		                        ; este é o endereço com que o SP deste processo deve ser inicializado

	STACK TAMANHO_PILHA		                    ; espaço reservado para a pilha do processo "teclado"
SP_inicial_teclado:		                        ; este é o endereço com que o SP deste processo deve ser inicializado
							
	STACK TAMANHO_PILHA		                    ; espaço reservado para a pilha do processo "teclado"
SP_inicial_painel:			                    ; este é o endereço com que o SP deste processo deve ser inicializado
		
	STACK TAMANHO_PILHA * N_SONDA		        ; espaço reservado para a pilha do processo "teclado"
SP_inicial_sonda:			                    ; este é o endereço com que o SP deste processo deve ser inicializado

	STACK TAMANHO_PILHA	* N_ASTEROIDES	        ; espaço reservado para a pilha do processo "teclado"
SP_inicial_asteroide:		                    ; este é o endereço com que o SP deste processo deve ser inicializado
													
ASTEROIDE_PERIGO:		                        ; tabela que define o asteroide perigoso (cor, largura, pixels, altura)
	WORD		LARGURA_AST                     ; valor de largura do asteroide sem recursos
    WORD        ALTURA_AST                      ; valor de altura do asteroide sem recursos
	WORD		0, PIXEL_VERM, PIXEL_VERM, PIXEL_VERM, 0		
    WORD		PIXEL_VERM, PIXEL_VERM, PIXEL_VERM, PIXEL_VERM, PIXEL_VERM
    WORD		PIXEL_VERM, PIXEL_VERM, PIXEL_VERM, PIXEL_VERM, PIXEL_VERM
    WORD		PIXEL_VERM, PIXEL_VERM, PIXEL_VERM, PIXEL_VERM, PIXEL_VERM
    WORD		0, PIXEL_VERM, PIXEL_VERM, PIXEL_VERM, 0

ASTEROIDE_COM_RECURSOS:	                        ; tabela que define o asteroide com recursos (cor, largura, pixels, altura)
	WORD		LARGURA_AST                     ; valor de largura do asteroide com recursos
    WORD        ALTURA_AST                      ; valor de altura do asteroide com recursos
	WORD		0, 0, PIXEL_VERD, 0, 0		
    WORD		0, PIXEL_VERD, PIXEL_VERD, PIXEL_VERD, 0
    WORD		PIXEL_VERD, PIXEL_VERD, PIXEL_VERD, PIXEL_VERD, PIXEL_VERD
    WORD		0, PIXEL_VERD, PIXEL_VERD, PIXEL_VERD, 0
    WORD		0, 0, PIXEL_VERD, 0, 0 

ASTEROIDE_MINADO_1:	                            ; 1ª tabela que define a mineração do asteroide com recursos após interseção com sonda
	WORD		LARGURA_AST                     ; valor de largura do asteroide com recursos
    WORD        ALTURA_AST                      ; valor de altura do asteroide com recursos
	WORD		0, 0, 0, 0, 0		
    WORD		0, 0, PIXEL_VERD, 0, 0
    WORD		0, PIXEL_VERD, PIXEL_VERD, PIXEL_VERD, 0
    WORD		0, 0, PIXEL_VERD, 0, 0
    WORD		0, 0, 0, 0, 0 

ASTEROIDE_MINADO_2:	                            ; 2ª tabela que define a mineração do asteroide com recursos após interseção com sonda
	WORD		LARGURA_AST                     ; valor de largura do asteroide com recursos
    WORD        ALTURA_AST                      ; valor de altura do asteroide com recursos
	WORD		0, 0, 0, 0, 0		
    WORD		0, 0, 0, 0, 0
    WORD		0, 0, PIXEL_VERD, 0, 0
    WORD		0, 0, 0, 0, 0
    WORD		0, 0, 0, 0, 0 

EXPLOSAO_ASTEROIDE:				                ; tabela que define a interseção de um asteroide sem recursos com uma sonda
	WORD		LARGURA_AST                     ; valor de largura do asteroide sem recursos
    WORD        ALTURA_AST                      ; valor de altura do asteroide sem recursos
	WORD		PIXEL_AZUL, 0, PIXEL_AZUL, 0, PIXEL_AZUL		
    WORD		0, PIXEL_AZUL, PIXEL_AZUL, PIXEL_AZUL, 0
    WORD		PIXEL_AZUL, PIXEL_AZUL, PIXEL_AZUL, PIXEL_AZUL, PIXEL_AZUL
    WORD		0, PIXEL_AZUL, PIXEL_AZUL, PIXEL_AZUL, 0
    WORD		PIXEL_AZUL, 0, PIXEL_AZUL, 0, PIXEL_AZUL 

PAINEL_NAVE:			                        ; tabela que define o painel da nave (cor, largura, pixels, altura)
	WORD		LARGURA_PAINEL                  ; largura do painel da nave
    WORD        ALTURA_PAINEL                   ; altura do painel da nave
	WORD		0, 0, PIXEL_CINZ_ESC, PIXEL_CINZ_ESC, PIXEL_CINZ_ESC, PIXEL_CINZ_ESC, PIXEL_CINZ_ESC, PIXEL_CINZ_ESC, PIXEL_CINZ_ESC, PIXEL_CINZ_ESC, PIXEL_CINZ_ESC, PIXEL_CINZ_ESC, PIXEL_CINZ_ESC, 0, 0		
    WORD		0, PIXEL_CINZ_ESC, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_ESC, 0
    WORD		PIXEL_CINZ_ESC, PIXEL_CINZ_CLA, PIXEL_VERM_TRANS, PIXEL_CINZ_CLA, PIXEL_AMAR_TRANS, PIXEL_CINZ_CLA, PIXEL_VIOLETA, PIXEL_CINZ_CLA, PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_AMAR_TRANS, PIXEL_CINZ_CLA, PIXEL_VERD_TRANS, PIXEL_CINZ_CLA, PIXEL_CINZ_ESC
    WORD		PIXEL_CINZ_ESC, PIXEL_CINZ_CLA, PIXEL_VERM, PIXEL_CINZ_CLA, PIXEL_AMAR, PIXEL_CINZ_CLA, PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_VIOLETA, PIXEL_CINZ_CLA, PIXEL_AMAR, PIXEL_CINZ_CLA, PIXEL_VERD, PIXEL_CINZ_CLA, PIXEL_CINZ_ESC
    WORD		PIXEL_CINZ_ESC, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_ESC 

ANIMACAO_PAINEL_1:			                    ; tabela que define a 1ª variação do painel da nave
	WORD		LARGURA_LUZES
    WORD        ALTURA_LUZES
    WORD		PIXEL_AMAR, PIXEL_CINZ_CLA, PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_VERD, PIXEL_CINZ_CLA, PIXEL_CAST, PIXEL_CINZ_CLA, PIXEL_VERM
    WORD		PIXEL_AMAR, PIXEL_CINZ_CLA, PIXEL_CAST, PIXEL_CINZ_CLA, PIXEL_VERD, PIXEL_CINZ_CLA, PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_VERM

ANIMACAO_PAINEL_2:			                    ; tabela que define a 2ª variação do painel da nave
	WORD		LARGURA_LUZES
    WORD        ALTURA_LUZES
    WORD		PIXEL_VERD_TRANS, PIXEL_CINZ_CLA, PIXEL_AMAR_TRANS, PIXEL_CINZ_CLA, PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_VIOLETA, PIXEL_CINZ_CLA, PIXEL_AMAR_TRANS, PIXEL_CINZ_CLA, PIXEL_VERM_TRANS
    WORD		PIXEL_VERD, PIXEL_CINZ_CLA, PIXEL_AMAR, PIXEL_CINZ_CLA, PIXEL_VIOLETA, PIXEL_CINZ_CLA, PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_AMAR, PIXEL_CINZ_CLA, PIXEL_VERM

ANIMACAO_PAINEL_3:			                    ; tabela que define a 3ª variação do painel da nave
	WORD		LARGURA_LUZES
    WORD        ALTURA_LUZES
    WORD		PIXEL_VIOLETA, PIXEL_CINZ_CLA, PIXEL_VERD, PIXEL_CINZ_CLA, PIXEL_AMAR, PIXEL_CINZ_CLA, PIXEL_CAST, PIXEL_CINZ_CLA, PIXEL_VERM, PIXEL_CINZ_CLA, PIXEL_AMAR
    WORD		PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_VERD_TRANS, PIXEL_CINZ_CLA, PIXEL_VIOLETA, PIXEL_CINZ_CLA, PIXEL_AMAR_TRANS, PIXEL_CINZ_CLA, PIXEL_CAST, PIXEL_CINZ_CLA, PIXEL_AMAR_TRANS

ANIMACAO_PAINEL_4:			                    ; tabela que define a 4ª variação do painel da nave
	WORD		LARGURA_LUZES
    WORD        ALTURA_LUZES
    WORD		PIXEL_CAST, PIXEL_CINZ_CLA, PIXEL_VERM, PIXEL_CINZ_CLA, PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_VERM_TRANS, PIXEL_CINZ_CLA, PIXEL_VERM, PIXEL_CINZ_CLA, PIXEL_AZUL
    WORD		PIXEL_VERD, PIXEL_CINZ_CLA, PIXEL_VIOLETA, PIXEL_CINZ_CLA, PIXEL_AMAR_TRANS, PIXEL_CINZ_CLA, PIXEL_VIOLETA, PIXEL_CINZ_CLA, PIXEL_CAST, PIXEL_CINZ_CLA, PIXEL_VIOLETA

ANIMACAO_PAINEL_5:			                    ; tabela que define a 5ª variação do painel da nave
	WORD		LARGURA_LUZES
    WORD        ALTURA_LUZES
    WORD		PIXEL_VERD, PIXEL_CINZ_CLA, PIXEL_VERD_TRANS, PIXEL_CINZ_CLA, PIXEL_CAST, PIXEL_CINZ_CLA, PIXEL_VIOLETA, PIXEL_CINZ_CLA, PIXEL_VERM, PIXEL_CINZ_CLA, PIXEL_CAST
    WORD		PIXEL_VERM, PIXEL_CINZ_CLA, PIXEL_AMAR, PIXEL_CINZ_CLA, PIXEL_AMAR_TRANS, PIXEL_CINZ_CLA, PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_VERD, PIXEL_CINZ_CLA, PIXEL_AZUL

ANIMACAO_PAINEL_6:			                    ; tabela que define a 6ª variação do painel da nave
	WORD		LARGURA_LUZES
    WORD        ALTURA_LUZES
    WORD		PIXEL_VERM, PIXEL_CINZ_CLA, PIXEL_AMAR, PIXEL_CINZ_CLA, PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_VIOLETA, PIXEL_CINZ_CLA, PIXEL_AMAR, PIXEL_CINZ_CLA, PIXEL_VERD
    WORD		PIXEL_VERM_TRANS, PIXEL_CINZ_CLA, PIXEL_AMAR_TRANS, PIXEL_CINZ_CLA, PIXEL_VIOLETA, PIXEL_CINZ_CLA, PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_AMAR_TRANS, PIXEL_CINZ_CLA, PIXEL_VERD_TRANS

ANIMACAO_PAINEL_7:			                    ; tabela que define a 7ª variação do painel da nave
	WORD		LARGURA_LUZES
    WORD        ALTURA_LUZES
    WORD		PIXEL_VERD, PIXEL_CINZ_CLA, PIXEL_AMAR, PIXEL_CINZ_CLA, PIXEL_VIOLETA, PIXEL_CINZ_CLA, PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_AMAR, PIXEL_CINZ_CLA, PIXEL_VERM
    WORD		PIXEL_VERD_TRANS, PIXEL_CINZ_CLA, PIXEL_AMAR_TRANS, PIXEL_CINZ_CLA, PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_VIOLETA, PIXEL_CINZ_CLA, PIXEL_AMAR_TRANS, PIXEL_CINZ_CLA, PIXEL_VERM_TRANS

ANIMACAO_PAINEL_8:			                    ; tabela que define a 8ª variação do painel da nave
	WORD		LARGURA_LUZES
    WORD        ALTURA_LUZES
    WORD		PIXEL_AMAR, PIXEL_CINZ_CLA, PIXEL_CAST, PIXEL_CINZ_CLA, PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_VIOLETA, PIXEL_CINZ_CLA, PIXEL_VERD, PIXEL_CINZ_CLA, PIXEL_VERM
    WORD		PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_AMAR_TRANS, PIXEL_CINZ_CLA, PIXEL_AMAR, PIXEL_CINZ_CLA, PIXEL_CAST, PIXEL_CINZ_CLA, PIXEL_VERM_TRANS, PIXEL_CINZ_CLA, PIXEL_VERD_TRANS

SONDA:                                          ; tabela que define a sonda (cor, pixels)
    WORD        LARGURA_SONDA                   ; largura da sonda
    WORD        ALTURA_SONDA                    ; altura da sonda
    WORD        PIXEL_CAST

sondas_lancadas:                                ; guarda as coordenadas das três sondas
    WORD        30, 32                          ; coordenadas da primeira sonda
    WORD        30, 32                          ; coordenadas da segunda sonda
    WORD        30, 32                          ; coordenadas da terceira sonda

asteroides_em_falta:                            ; número de asteroides em falta (4 - número de asteroides no ecrã)
    WORD        0

estado_jogo:                                    ; guarda o estado do jogo (inicia, pausa, termina)
    WORD        0

; Tabela das rotinas de interrupção
tab:
	WORD rot_int_0			                    ; rotina de atendimento da interrupção 0
                                                ; controla temporização dos asteroides

	WORD rot_int_1			                    ; rotina de atendimento da interrupção 1
                                                ; controla temporização das sondas

	WORD rot_int_2			                    ; rotina de atendimento da interrupção 2
                                                ; controla temporização dos energia

	WORD rot_int_3			                    ; rotina de atendimento da interrupção 3
                                                ; controla temporização do painel

evento_asteroide:		                        ; LOCKs que controla a temporização do movimento do asteroide
	LOCK        0				                ; LOCK corresponde a rotina de interrupção 0

evento_sonda:			                        ; LOCK que controla a temporização do movimento da sonda
	LOCK        0				                ; LOCK corresponde a rotina de interrupção 1

evento_display:			                        ; LOCK que controla a temporização do display
	LOCK        0				                ; LOCK corresponde a rotina de interrupção 2

evento_painel:			                        ; LOCK que controla a temporização do animação do painel
	LOCK        0				                ; LOCK corresponde a rotina de interrupção 3

evento_prog_principal:                          ; LOCK para comunicar ao programa principal as teclas carregadas e colisões
    LOCK        0     

pausa_processos:                                ; LOCK para bloquear os processos quando o jogo está em pausa
	LOCK        0

; *********************************************************************************
; * Código
; *********************************************************************************

PLACE      0
inicio:
	MOV  SP, SP_inicial_prog_princ		        ; inicializa SP do programa principal
	MOV  BTE, tab			                    ; inicializa BTE (registo de Base da Tabela de Exceções)

    MOV  [APAGA_AVISO], R1                      ; apaga o aviso de nenhum cenário selecionado (R1 irrelevante)
    MOV  [APAGA_ECRA], R1                       ; apaga todos os pixels já desenhados (R1 irrelevante)
    MOV  R1, FUNDO_INICIAL
    MOV  [FUNDO_ECRA], R1                       ; coloca imagem de fundo incial
    MOV  R1, MSG_INICIAR
    MOV  [MSG], R1                              ; sobrepõe texto inicial sobre a imagem inicial

    EI0                                         ; permite interrupções 0
    EI1                                         ; permite interrupções 1
    EI2                                         ; permite interrupções 2
    EI3                                         ; permite interrupções 3
	EI					                        ; permite interrupções (geral)

    CALL teclado                                ; cria processo teclado para detetar teclas carregadas

preparacao_jogo:
    CALL prepara_jogo                           ; reinicia valores da memoria (serve para quando o jogo é reiniciado)

espera_inicio:                                  ; este ciclo espera até a tecla C seja carregada para iniciar o jogo
    MOV  R1, [evento_prog_principal]            ; bloqueia neste LOCK até uma tecla ser carregada
    MOV  R2, TECLA_INICIO_JOGO                  ; tecla para iniciar o jogo (tecla C)
    CMP  R1, R2                                 ; verifica se a tecla premida foi o C
    JNZ  espera_inicio                          ; se a tecla premida não foi C repete ciclo

inicia_jogo:
    CALL configura_inicio_jogo                  ; inicia o jogo e inicializa os processos

deteta_eventos:
    MOV  R1, [evento_prog_principal]            ; bloqueia neste LOCK até uma tecla ser carregada

    MOV  R2, TECLA_SONDA_ESQ                    ; tecla para lancar uma sonda à esquerda (tecla 0)
    CMP  R1, R2                                 ; verifica se a tecla premida foi para lancar uma sonda à esquerda
    JZ  sonda_esq                               ; se a tecla premida foi 0, dispara a sonda à esquerda

    MOV  R2, TECLA_SONDA_CENT                   ; tecla para lancar uma sonda no centro (tecla 1)
    CMP  R1, R2                                 ; verifica se a tecla premida foi para lancar uma sonda no centro
    JZ  sonda_cent                              ; se a tecla premida foi 1, dispara a sonda no centro

    MOV  R2, TECLA_SONDA_DIR                    ; tecla para lancar uma sonda à direita (tecla 2)
    CMP  R1, R2                                 ; verifica se a tecla premida foi para lancar uma sonda à direita
    JZ   sonda_dir                              ; se a tecla premida foi 2, dispara a sonda à direita

    MOV  R2, TECLA_PAUSA                        ; tecla para pausa e continuar o jogo (tecla D)
    CMP  R1, R2                                 ; verifica se a tecla premida foi para pausar/continuar o jogo
    JZ   suspende_jogo                          ; se a tecla premida foi D, suspende ou continua o jogo

    MOV  R2, TECLA_TERMINA                      ; tecla para terminar o jogo (tecla E)
    CMP  R1, R2                                 ; verifica se a tecla premida foi para terminar o jogo
    JZ   termina_jogo                           ; se a tecla premida foi E, termina o jogo

    MOV  R2, CRIA_ASTEROIDE                     ; modo para criar uma nova asteroide
    CMP  R1, R2                                 ; verifica se falta asteroides no ecrã
    JZ   cria_asteroides                        ; se faltar, cria asteroides

    MOV  R2, MODO_EXPLOSAO                      ; modo quando um asteroide colidir com a nave
    CMP  R1, R2                                 ; verifica se um asteroide colidiu com a nave
    JZ   termina_jogo_explosao                  ; se colidir, termina o jogo com a explosão da nave

    MOV  R2, MODO_SEM_ENERGIA                   ; modo quando a nave fica sem energia
    CMP  R1, R2                                 ; verifica se a nave está sem energia
    JZ   sem_energia                            ; caso a energia acabe, termina o jogo por falta de energia

    JMP  deteta_eventos                         ; se a tecla premida não foi nenhuma das anteriores repete o ciclo

sonda_esq:
    MOV  R5, DIRECAO_ESQ                        ; direcao da sonda
    CALL dispara_sonda                          ; dispara uma sonda à esquerda
    JMP  deteta_eventos                         ; volta ao ciclo principal

sonda_cent:
    MOV  R5, DIRECAO_CENT                       ; direcao da sonda
    CALL dispara_sonda                          ; dispara uma sonda no centro
    JMP  deteta_eventos                         ; volta ao ciclo principal

sonda_dir:
    MOV  R5, DIRECAO_DIR                        ; direcao da sonda
    CALL dispara_sonda                          ; dispara uma sonda à direita
    JMP  deteta_eventos                         ; volta ao ciclo principal

cria_asteroides:
    CALL gera_asteroides_em_falta               ; cria os asteroides em falta até have 4 no ecrã
    JMP  deteta_eventos                         ; deteta tecla premida, e atua em conformidade

suspende_jogo:
    CALL pausa_jogo                             ; coloca o jogo em pausa

pausa_prog_principal:                           ; neste ciclo o jogo está em modo pausa
                                                ; e apenas sai quando a tecla D for premida
    MOV  R1, [evento_prog_principal]            ; bloqueia neste LOCK até uma tecla ser carregada
    MOV  R2, TECLA_PAUSA                        ; tecla para pausa e continuar o jogo
    MOV  R3, TECLA_TERMINA                      ; tecla para terminar o jogo
    CMP  R1, R3                                 ; verifica se a tecla premida foi para terminar o jogo
    JZ   termina_jogo                           ; caso a tecla premida seja E, termina o jogo por vontade do utilizador

    CMP  R1, R2                                 ; verifica se a tecla premida foi para continuar o jogo
    JNZ  pausa_prog_principal                   ; caso a tecla premida não tenha sido D, continua o ciclo
                                                ; até o utilizador premir a tecla D
    CALL continua_jogo                          ; se a tecla premida foi D, continua o jogo
    JZ   deteta_eventos                         ; volta ao ciclo de funciomento da prog_principal

termina_jogo:
    CALL game_end                               ; termina o jogo por vontade do utilizador
    JMP  preparacao_jogo                        ; prepara o jogo para ser reiniciado

termina_jogo_explosao:
    CALL game_over_explosao                     ; termina o jogo por colisão de uma asteroide com a nave
    JMP  preparacao_jogo                        ; prepara o jogo para reiniciar

sem_energia:
    CALL game_over_sem_energia                  ; termina o jogo se a nave ficar sem energia
    JMP  preparacao_jogo                        ; prepara o jogo para reiniciar

; **********************************************************************
; Processo
;
; PAINEL - Processo que desenha um painel controla a sua animação
;
; **********************************************************************

PROCESS SP_inicial_painel

painel:                                        ; desenha o painel
    MOV  R1, LINHA_PAINEL                      ; linha do painel da nave
    MOV  R2, COLUNA_PAINEL                     ; coluna do painel da nave
    MOV  R4, PAINEL_NAVE                       ; endereço da tabela que define o painel da nave
    CALL desenha_objeto                        ; desenha o objeto a partir da tabela

    MOV  R1, LINHA_PAINEL + 2                  ; linha das luzes do painel        
    MOV  R2, COLUNA_PAINEL + 2                 ; coluna das luzes do painel

ciclo_anima_painel:
    MOV  R4, ANIMACAO_PAINEL_1                 ; Primeira forma das luzes do painel

anima_painel:
    MOV  R3, JOGO_INICIADO                     ; valor do modo do jogo iniciado
    MOV  R0, [estado_jogo]                     ; obtem estado do jogo
    CMP  R0, R3                                ; verifica se houve alteração no modo do jogo
    JNZ  altera_modo_painel                    ; caso tenha acontecido alteração no modo do jogo, salta

    MOV  R0, [evento_painel]                   ; Bloqueia até interrupção 3
    CALL desenha_objeto                        ; desenha as luzes do painel

    MOV  R0, ANIMACAO_PAINEL_8
    CMP  R4, R0                                ; verifica se já foi desenhada a ultima variação das luzes do painel
    JZ   ciclo_anima_painel                    ; caso tenha sido desenhada, reinicia o desenho das luzes pela 1ª variação 
    MOV  R0, PROX_ANIM_PAINEL
    ADD  R4, R0                                ; obtem o proximo tabela do animação de luzes
    JMP  anima_painel                          ; desenha proximo animação de luzes

altera_modo_painel:
    MOV R3, JOGO_PAUSA                         ; para verificar se o jogo está em pausa
    CMP R0, R3                                 ; verifica se o jogo está em pausa
    JZ  pausa_painel                           ; se o jogo estiver em pausa, pausa o painel
    MOV [APAGA_ECRA], R1                       ; apaga todos os pixels já desenhados (R1 irrelevante)
    RET                                        ; se não a tecla premida foi para terminar o jogo

pausa_painel:
    MOV  R0, [pausa_processos]                 ; bloqueia neste lock até o jogo continuar
    JMP  anima_painel                          ; depois de ser desbloquado anima o painel de luzwes

sai_painel:
    RET

; **********************************************************************
; Processo
;
; SONDA - Processo que desenha uma sonda e implementa o seu comportamento
;
; Argumento:    R5 - direção da sonda (em formato -1, 0, 1)
;
; **********************************************************************

PROCESS SP_inicial_sonda	                ; Processo com valor para inicializar o SP da sonda

sonda:                                      ; atualiza display de energia
    MOV  R1, SOM_DISPARO                    ; som do lançamento da sonda
    MOV  [PARA_SOM_VIDEO], R1               ; para qualquer som corrente
    MOV  [REPRODUZ_SOM_VIDEO], R1           ; toca som do lançamento

    MOV  R0, ENERGIA_SONDA                  ; energia gasto pela sonda
    MOV  R1, evento_display                 ; LOCK para alterar valor da energia
    MOV  [R1], R0                           ; diminui energia por 5%

    CALL calcula_posicao_sonda              ; calcula a posição da sonda

	MOV  R4, SONDA                          ; tabela que define a sonda
    MOV  R8, ALCANCE_SONDA                  ; alcance da sonda
    CALL calcula_endereco_sondas_lancadas   ; calcula o endereço das coordenadas da sonda correspondente à direção

ciclo_sonda:                                ; guarda posição na tabela

    MOV  [R7], R1                           ; guarda a linha da sonda
    MOV  [R7 + 2], R2                       ; guarda a coluna da sonda

    CALL desenha_objeto                     ; desenha a sonda na nova posição

    MOV  R3, JOGO_INICIADO                  ; para verificar se o jogo ainda está a continuar
    MOV  R6, [estado_jogo]                  ; obtem o estado do jogo
    CMP  R6, R3                             ; verifica se o jogo ainda está a continuar
    JNZ  altera_modo_sonda                  ; salta se o jogo estiver em pausa ou terminado

    MOV	 R3, [evento_sonda]                 ; lê o LOCK e bloqueia até a interrupção escrever nele
    MOV  R9, R5
    INC  R9                                 ; para comparar com referência de colisão (0-2)
    CMP  R3, R9                             ; verifica se houve colisão da sonda com um asteroide
    JZ   sai_sonda                          ; se tiver colisão termina a sonda

    CALL apaga_objeto                       ; apaga a sonda na sua posição atual
    DEC  R1                                 ; a sonda sobe uma linha
    ADD  R2, R5                             ; atualiza posição com argumento da direção
    DEC  R8                                 ; decrementa contador de alcance da sonda
    JZ   sai_sonda                          ; se a sonda chegar ao limite do alcance, termina a sonda
    
	JMP	 ciclo_sonda		                ; se a sonda ainda não tiver chegado ao alcance limite, reinicia o ciclo

altera_modo_sonda:                          ; coloca a sonda em pausa
    YIELD                                   ; ponto de fuga para outros processos
    MOV  R3, JOGO_PAUSA                     ; para verificar se o jogo está em pausa
    MOV  R6, [estado_jogo]                  ; obtem estado do jogo
    CMP  R6, R3                             ; verifica se o jogo está em pausa
    JZ   pausa_sonda                        ; caso o jogo esteja em pausa, pausa a sonda
    JMP  sai_sonda                          ; se não, a tecla premida foi para terminar o jogo

pausa_sonda:
    MOV  R6, [pausa_processos]              ; bloqueia neste lock até o jogo continuar
    JMP  ciclo_sonda                        ; volta ao ciclo, ao continuar o jogo

sai_sonda:
    CALL apaga_objeto                       ; apaga a sonda em sua posição atual
    MOV  R0, 30
    MOV  [R7], R0                           ; reinicia valor na tabela
    MOV  R0, 32
    MOV  [R7 + 2], R0                       ; reinicia valor na tabela
    MOV  R4, R0                             ; apaga a sonda
    RET

; **********************************************************************
; Processo
;
; ASTEROIDE - Processo que desenha um asteroide e implementa o seu comportamento
;
; **********************************************************************

PROCESS SP_inicial_asteroide	            ; Processo com valor para inicializar o SP do asteroide

asteroide:	                                ; gera e desenha o asteroide na sua posição inicial
    MOV  R6, 0                              ; reinicia valor
    MOV  R1, LINHA_TOPO                     ; linha do asteroide
    CALL gera_tipo_asteroide                ; gera o asteroide com ou sem recursos

ciclo_asteroide:
	CALL colisao_painel                     ; verifica colisão com o painel da nave
	CALL desenha_objeto		                ; desenha o asteroide a partir da tabela

    MOV  R3, JOGO_INICIADO                  ; para verificar se o jogo ainda está a continuar
    MOV  R0, [estado_jogo]                  ; obtem estado atual do jogo
    CMP  R0, R3                             ; verifica se o estado do jogo alterou
    JNZ  altera_modo_asteroide              ; se o estado do jogo estiver alterado salta

	MOV	 R3, [evento_asteroide]  	        ; lê o LOCK e bloqueia até a interrupção escrever nele

    CALL apaga_objeto                       ; apaga o objeto na sua posição atual
    INC  R1                                 ; atualiza a posição do asteroide para a próxima linha
    ADD  R2, R5                             ; atualiza a posição do asteroide para a próxima coluna
	CALL colisao_asteroide_3_sondas         ; verifica se a sonda colidiu com um asteroide
    CMP  R6, 1                              ; verifica se ocorreu a colisão
    JZ   asteroide_destruido                ; caso tenha ocorrido, destroi o asteroide

    MOV R7, LINHA_BASE                      ; linha base do ecrã (ultima linha)
    CMP R7, R1                              ; verifica se o asteroide chegou à ultima linha
    JZ  sai_asteroide                       ; se chegar à ultima linha sai

	JMP	ciclo_asteroide		                ; reinicia o ciclo do asteroide

altera_modo_asteroide:
    MOV  R3, JOGO_PAUSA                     ; para verificar se o jogo está em pausa
    MOV  R0, [estado_jogo]                  ; obtem estado do jogo
    CMP  R0, R3                             ; verifica se o jogo está em pausa
    JZ   pausa_asteroide                    ; caso o jogo esteja em pausa, coloca o asteroide em pausa
    MOV  [APAGA_ECRA], R1                   ; apaga todos os pixels já desenhados (R1 irrelevante)
    RET                                     ; se não a tecla premida foi para terminar o jogo

pausa_asteroide:
   MOV  R0, [pausa_processos]               ; bloqueia neste lock até o jogo continuar
   JMP  ciclo_asteroide                     ; volta ao ciclo, ao continuar o jogo

asteroide_destruido:
    MOV  R0, ASTEROIDE_COM_RECURSOS
    CMP  R4, R0                             ; verifica se o asteroide destruido era uma asteroide com recursos
    JZ   mina_asteroide_1                   ; se for um asteroide com recursos, mina o asteroide
    MOV  R0, EXPLOSAO_ASTEROIDE
    CMP  R4, R0                             ; verifica se a sonda colide com a explosão de um asteroide
    JZ   sai_asteroide                      ; caso ocorra a colisão referida atualiza o nº de asteroides em falta
    MOV  R0, ASTEROIDE_MINADO_1
    CMP  R4, R0                             ; verifica se o asteroide já minerado se encontra na 1ª fase de mineração
    JZ   mina_asteroide_2                   ; caso ocorra, passa para a 2ª fase
    MOV  R0, ASTEROIDE_MINADO_2             
    CMP  R4, R0                             ; verifica se o asteroide já minerado se encontra na 2ª fase de mineração
    JZ   sai_asteroide                      ; caso ocorra, atualiza o nº de asteroides em falta

asteroide_perigo_destruido:
    MOV  R4, SOM_AST_DESTRUIDO              ; associa o som do asteroide sem recursos ao ser destruido
    MOV  [PARA_SOM_VIDEO], R4               ; para todos os sons
    MOV  [REPRODUZ_SOM_VIDEO], R4           ; toca o som da colisão da sonda com um asteroide sem recursos
    MOV  R4, EXPLOSAO_ASTEROIDE             ; tabela com o efeito da exposão do asteroide sem recursos
    JMP  muda_asteroide                     ; volta a desenhar o asteroide com o efeito da destruição

sai_asteroide:
    MOV  R0, [asteroides_em_falta]          ; obtem número de asteroides em falta
    INC  R0                                 ; incrementa número de asteroides em falta
    MOV  [asteroides_em_falta], R0          ; colocar de novo no endereço
    MOV  R0, CRIA_ASTEROIDE                 ; cria asteroides até totalizar 4 em simultâneo 
    MOV  [evento_prog_principal], R0
    RET

mina_asteroide_1:
    MOV  R0, SOM_AST_MINERADO               ; associa o som do asteroide com recursos ao ser minerado
    MOV  [PARA_SOM_VIDEO], R0               ; para todos os sons
    MOV  [REPRODUZ_SOM_VIDEO], R0           ; toca o som da mineração de um asteroide sem recursos
    MOV  R0, VALOR_RECURSOS                 ; valor da energia do recurso
    MOV  [evento_display], R0               ; recursos obtidos, adicione 25 a energia
    MOV  R4, ASTEROIDE_MINADO_1             ; 1º estado da mineração de um asteroide com recursos
    JMP  muda_asteroide                     ; desenha asteroide com nova imagem

mina_asteroide_2:
    MOV  R4, ASTEROIDE_MINADO_2             ; 1º estado da mineração de um asteroide com recursos
    JMP  muda_asteroide                     ; desenha asteroide com nova imagem

muda_asteroide:
    DEC  R1                                 ; para desenhar na mesma linha    
    SUB  R2, R5                             ; para desenhar na mesma coluna
	MOV	 R3, [evento_asteroide]  	        ; lê o LOCK e bloqueia até a interrupção escrever nele
    CALL apaga_objeto                       ; apaga o objeto em sua posição atual
    JMP  asteroide_destruido                ; destroi o asteroide

; **********************************************************************
; Processo
;
; ENERGIA - Processo que controla o calculo da energia e escrita ns displays
;
; **********************************************************************

PROCESS SP_inicial_energia	                ; Processo com valor para inicializar o SP da energia

energia:
    MOV  R8, INICIO_ENERGIA                 ; define o valor inicial da energia

atualiza_display:
    MOV  R1, JOGO_INICIADO                  ; para verificar se o jogo ainda está a continuar
    MOV  R0, [estado_jogo]                  ; obtem o estado atual do jogo
    CMP  R0, R1                             ; o jogo está iniciado
    JNZ  altera_modo_energia                ; se o jogo não estiver iniciado, salta

    CMP  R8, 0                              ; verifica se a nave esgotou toda a energia
    JLE  energia_esgotada                   ; caso tenha esgotado a energia, salta
    CALL escreve_display                    ; escreve o valor de energia no display
    MOV  R0, [evento_display]               ; bloqueia o LOCK do display
    ADD  R8, R0                             ; atualliza o valor da energia
    JMP  atualiza_display                   ; atualiza o valor apresentado no display

altera_modo_energia:
    MOV  R1, JOGO_PAUSA                     ; para verificar se o jogo está em pausa
    MOV  R0, [estado_jogo]                  ; obtem estado do jogo
    CMP  R0, R1                             ; verifica se o jogo está em pausa
    JZ   pausa_energia                      ; se o jogo estiver em pausa, pausa a energia
    MOV  [APAGA_ECRA], R1                   ; apaga todos os pixels já desenhados (R1 irrelevante)
    RET

pausa_energia:
    MOV  R0, [pausa_processos]              ; bloqueia neste lock até o jogo continuar
    JMP  atualiza_display                   ; volta ao ciclo, ao continuar o jogo

energia_esgotada:
    MOV  R8, 0                              ; valor da energia igual a 0
    CALL escreve_display                    ; atualiza o display
    MOV  R1, MODO_SEM_ENERGIA               
    MOV  [evento_prog_principal], R1        ; altera o modo do jogo
    RET

; **********************************************************************
; Processo
;
; TECLADO - Processo que deteta quando se carrega numa tecla
;		    escreve o valor da tecla num LOCK.
;
; **********************************************************************

PROCESS SP_inicial_teclado	                ; Processo com valor para inicializar o SP do teclado

teclado:					                ; processo que implementa o comportamento do teclado
    CALL espera_tecla

ha_tecla:					                ; neste ciclo espera-se até NENHUMA tecla estar premida
	YIELD				                    ; este ciclo é potencialmente bloqueante, pelo que tem de
						                    ; ter um ponto de fuga (aqui pode comutar para outro processo)
    CALL calcula_tecla                      ; obtem o valor da tecla selecionada
	MOV	[evento_prog_principal], R2	        ; guarda o valor da tecla selecionada
    CALL espera_libertar_tecla              ; espera até a tecla ser desselecionada

	JMP	teclado		                        ; esta "rotina" nunca retorna porque nunca termina

; **********************************************************************
; PREPARA_JOGO - prepara o jogo e as inicializações na memoria
;
; **********************************************************************

prepara_jogo:
    PUSH R0
    PUSH R1

    MOV  R0, sondas_lancadas                ; endereço da tabela com as posições das sondas lançadas

set_sondas_lancadas:
    MOV  R1, 30                             
    MOV  [R0], R1                           ; guarda um valor neutro na linha da primeira sonda
    ADD  R0, 2                              ; obtem endereço da coluna da 1ª sonda
    MOV  R1, 32
    MOV  [R0], R1                           ; guarda um valor neutro na coluna da primeira sonda
    ADD  R0, 2                              ; obtem endereço da linha da 2ª sonda
    MOV  R1, sondas_lancadas + 12           ; obtem endereço da coluna da 3ª sonda
    CMP  R0, R1                             ; verifica se estão guardadas todas as coordenadas das 3 sondas
    JNZ  set_sondas_lancadas                ; caso ainda não estejam todas guardadas, reinicia o ciclo

set_asteroides_em_falta:
    MOV  R0, 0
    MOV  [asteroides_em_falta], R0          ; coloca o nº de asteroides em 0
    POP  R1
    POP  R0
    RET


; **********************************************************************
; COLISAO_ASTEROIDE_3_SONDAS - deteta colisões entre um asteroide e as sondas
; Argumentos:	R1 - linha do asteroide
;               R2 - colunda do asteroide
;
; Retorna: 	R6 - igual a 1 se uma colisão for detetada
; **********************************************************************

colisao_asteroide_3_sondas:
    PUSH R0
    MOV  R0, 0                              ; identifica o nº da sonda como 0
    CALL colisao_asteroide_sonda            ; verifica se ocorreu uma colisão com a sonda
    MOV  R0, 1                              ; identifica o nº da sonda como 1
    CALL colisao_asteroide_sonda            ; verifica se ocorreu uma colisão com a sonda
    MOV  R0, 2                              ; identifica o nº da sonda como 2
    CALL colisao_asteroide_sonda            ; verifica se ocorreu uma colisão com a sonda
    POP  R0
    RET

; **********************************************************************
; COLISAO_ASTEROIDE_SONDA - deteta colisão entre um asteroide e uma sonda
; Argumentos:	R1 - linha do asteroide
;               R2 - colunda do asteroide
;
; Retorna: 	R6 - igual a 1 se uma colisão for detetada
; **********************************************************************

colisao_asteroide_sonda:
    PUSH R3
    PUSH R4
	PUSH R5
	PUSH R7
	PUSH R8
	PUSH R9
	PUSH R10
	PUSH R11
	MOV	 R5, R1				                ; copia para R5 a primeira linha do asteroide 
	MOV  R7, R2				                ; copia para R7 a primeira coluna do asteroide
	MOV  R10,R1				                ; copia para R10 a primeira linha do asteroide
	MOV  R11,R2				                ; copia para R11 a primeira coluna do asteroide
	SUB  R10,1				                ; obtem a linha acima do asteroide
	SUB  R11,1				                ; obtem a coluna à esquerda do asteroide
	ADD  R5,6				                ; obtem a segunda linha abaixo do asteroide (para melhor deteção de colisões)
	ADD  R7,6				                ; obtem a segunda coluna abaixo do asteroide (para melhor deteção de colisões)
	MOV  R8,sondas_lancadas	                ; obtem a tabela de posições das sondas lançadas

verifica_sonda:
    MOV  R3, R0  			                ; copia numero da sonda (0-sonda da esquerda, 1-sonda central, 2-sonda da direita)
    MOV  R4, 4				                ; multiplicador de endereços na tabela (4 porque cada coordenada de sonda tem 2 valores
                                            ; e cada WORD ocupa 2 endereços) 
    MUL  R3, R4				                ; determina o endereço da sonda
	ADD  R8, R3				                ; determina o endereço da sonda
	MOV  R9, [R8]			                ; obtem a linha da sonda
	CMP  R9, R5				                ; verifica se a sonha está abaixo do asteroide
	JGE  final				                ; se sim termina
	CMP  R9, R10				            ; verifica se a sonda está acima do asteroide
	JLE  final				                ; se sim termina
	ADD  R8, 2				                ; endereço da coluna da sonda
	MOV  R9, [R8]			                ; obtem a coluna da sonda
	CMP  R9, R7				                ; verifica se a sonda está à direita do asteroide
	JGE  final				                ; se sim termina
	CMP  R9, R11				            ; verifica se a sonda está acima do asteroide
	JLE  final				                ; se sim termina
	MOV  R6,1				                ; se a sonda não estiver nem acima nem abaixo nem à esquerda nem à direita então 
                                            ; está dentro do asteroide, retorna em R6 colisão detetada
    MOV  [evento_sonda], R0

    CALL calcula_endereco_sondas_lancadas
    MOV  R4, 30          	                ; linha default da sonda
    MOV  [R7], R4        	                ; reinicia valor da linha da sonda
    MOV  R4, 32          	                ; coluna default da sonda
    MOV  [R7 + 2], R4    	                ; reinicia valor da linha da sonda

final:
	POP  R11
	POP  R10
	POP  R9
	POP  R8
	POP  R7
	POP  R5
    POP  R4
    POP  R3
	RET

; **********************************************************************
; COLISAO_PAINEL - verifica se o asteroide colide com o painel
; Argumentos:	R1 - linha do asteroide
;               R2 - colunda do asteroide
;
; **********************************************************************

colisao_painel:
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	PUSH R9
	PUSH R10
	MOV  R5, R1
	MOV  R6, R2
	MOV  R9, R2
	SUB  R9, 1							    ; coluna à esquerda do asteroide 
	ADD  R5, 5							    ; linha abaixo do asteroide 
	ADD  R6, 5							    ; linha à direita do asteroide
	MOV  R10, PIXEL_CINZ_CLA

verica_canto_direito:
	MOV  [DEFINE_LINHA],R5				    ; define a linha do pixel
	MOV  [DEFINE_COLUNA],R6				    ; define a coluna do pixel
	MOV  R7, [ESTADO_PIXEL]				    ; lê o estado do pixel (ligado-1 desligao-0)
	JZ   verifica_canto_esquerdo			; verifica se o painel está no canto inferior esquerdo do asteroide caso o pixel esteja desligado
	MOV  R8, [LE_COR_PIXEL]				    ; lê a cor do pixel 
	CMP  R8,R10							    ; verifica se é um pixel cinzento 
	JNZ  verifica_canto_esquerdo			; verifica se o painel está no canto inferior esquerdo do asteroide caso o pixel não seja cinzento
	CALL explosao						    ; muda o fundo
    JMP  termina

verifica_canto_esquerdo:
	MOV  [DEFINE_COLUNA],R9				    ; define a coluna do pixel
	MOV  R7, [ESTADO_PIXEL]				    ; lê o estado do pixel (ligado-1 desligao-0)
	JZ   termina							; termina a rotina caso o pixel esteja desligado
	MOV  R8, [LE_COR_PIXEL]				    ; lê a cor do pixel 
	CMP  R8,R10							    ; verifica se é um pixel cinzento
	JNZ  termina							; termina a rotina caso o pixel não seja cinzento
	CALL explosao						    ; muda o fundo

termina:
	POP  R10
	POP  R9
	POP  R8
	POP  R7
	POP  R6
	POP  R5
	RET

explosao:
    PUSH R1
    MOV  R1, MODO_EXPLOSAO
    MOV  [evento_prog_principal], R1
    POP  R1
    RET

; **********************************************************************
; ESPERA_TECLA - Espera até uma tecla seja premida e lê a coluna e linha
;
; Retorna: 	R1 - linha da tecla premida
;           R0 - coluna da tecla premida
;
; **********************************************************************

espera_tecla:				                ; neste ciclo espera-se até uma tecla ser premida

	WAIT			                        ; este ciclo é potencialmente bloqueante, pelo que tem de
						                    ; ter um ponto de fuga (aqui pode comutar para outro processo)

	MOV  R1, LINHA1	                        ; testar a linha 1

varre_linhas:
    CALL escreve_linha                      ; ativar linha no teclado
    CALL le_coluna                          ; leitura na linha ativada do teclado
    CMP  R0, 0                              ; há tecla premida?
    JNZ  sai_varre_linhas    
    CMP  R1, 5                              ; chegou à última linha?
    JGE  espera_tecla        
    SHL  R1, 1                              ; testar a próxima linha
    JMP  varre_linhas                       ; continua o ciclo na próxima linha

sai_varre_linhas:
    RET

; **********************************************************************
; ESCREVE_LINHA - Faz uma leitura às teclas de uma linha do teclado e retorna o valor lido
; Argumentos:	R1 - linha a testar (em formato 1, 2, 4 ou 8)
;
; **********************************************************************

escreve_linha:
	PUSH R0
	MOV  R0, TEC_LIN                        ; endereço do periférico das linhas
	MOVB [R0], R1                           ; escrever no periférico de saída (linhas)
    POP  R0
    RET

; **********************************************************************
; LE_COLUNA - Faz uma leitura às teclas de uma linha do teclado e retorna o valor lido
;
; Retorna: 	R0 - valor lido das colunas do teclado (0, 1, 2, 4, ou 8)	
; **********************************************************************

le_coluna:
	PUSH  R1
	PUSH  R2
	MOV   R1, TEC_COL                       ; endereço do periférico das colunas
	MOV   R2, MASCARA_TECLA                 ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
	MOVB  R0, [R1]                          ; ler do periférico de entrada (colunas)
	AND   R0, R2                            ; elimina bits para além dos bits 0-3
	POP	  R2
	POP	  R1
	RET

; **********************************************************************
; CALCULA_TECLA - calcula o valor da tecla premida
; Argumentos:	R0 - coluna da tecla (em formato 1, 2, 4 ou 8)
;               R1 - linha da tecla (em formato 1, 2, 4 ou 8)
;
; Retorna: 	R2 - total
; **********************************************************************

calcula_tecla:                              ; calcula o valor da tecla
    PUSH  R1
    MOV   R2, 0                             ; inicia valor da tecla no 0
    CALL  conta_linhas_colunas
    ADD   R2, R3                            ; adicionar numero de linhas
    SHL   R2, 2                             ; linhas * 4
    MOV   R1, R0                            ; conta as colunas
    CALL  conta_linhas_colunas
    ADD   R2, R3                            ; adicionar numero de colunas
    POP   R1
    RET

; **********************************************************************
; CONTA_LINHAS_COLUNAS - conta numero das linhas/colunas
; Argumentos:	R1 - linha/coluna da tecla (em formato 1, 2, 4 ou 8)
;
; Retorna: 	R3 - total contada
; **********************************************************************

conta_linhas_colunas:
    PUSH R1
    MOV  R3, 0                              ; inicia contador no 0

calc_val_lin_col:                           ; neste ciclo calcula-se o valor da linha/coluna
    SHR  R1, 1                              ; desloca à direita 1 bit
    CMP  R1, 0                              ; a quantidade das linhas/colunas ja foi contada?
    JZ   sai_conta_linhas_colunas           ; se ja for contada, salta
    INC  R3                                 ; incrementa o valor calculada
    JMP  calc_val_lin_col                   ; repete ciclo

sai_conta_linhas_colunas:
    POP  R1
    RET

; **********************************************************************
; espera_libertar_tecla - espera até a tecla premida seja libertada
;
; **********************************************************************

espera_libertar_tecla:                      ; neste ciclo espera-se até a tecla estar libertada
    PUSH R0

tecla_premida:
    YIELD				                    ; este ciclo é potencialmente bloqueante, pelo que tem de
                                            ; ter um ponto de fuga (aqui pode comutar para outro processo)
    CALL le_coluna                          ; leitura na linha ativada do teclado
    CMP  R0, 0                              ; há tecla premida?
    JNZ  tecla_premida                      ; se a tecla ainda for premida, espera até não haver
    POP R0
    RET

; **********************************************************************
; ESCREVE_DISPLAY - escreve um valor decimal no display hexadecimal
;                   na forma decimal
; Argumentos:   R8 - valor a escrever no display
;
; **********************************************************************

escreve_display:
    PUSH R0
    PUSH R1
    PUSH R8
    MOV  R0, DISPLAYS                       ; endereço do periférico dos displays
    CALL calcula_display
    MOV  [R0], R1                           ; escrever o valor no display
    POP  R8
    POP  R1
    POP  R0
    RET

; **********************************************************************
; CALCULA_DISPLAY - calcula o valor hexadecimal para que no display
;                          seja na mesma forma que o argumento decimal
; Argumentos:   R8 - valor decimal
;
; Retorna: 	R1 - valor a escrever no display	
; **********************************************************************

calcula_display:
    PUSH R0
    PUSH R8
    PUSH R2
    PUSH R3
    MOV  R0, FATOR_INICIAL                  ; fator para obter os dígitos
    MOV  R3, 10                             ; para diminuir a potência de 10 do fator

calcula_digito:
    MOD  R8, R0  
    DIV  R0, R3                             ; fator para obter proximo digito
    JZ   sai_calcula_display                ; se o fator for menor que 10 sai
    MOV  R2, R8                             ; copia numero
    DIV  R2, R0                             ; calcula digito
    SHL  R1, 4                              ; desloca digitos no resultado para colocar novo digito
    OR   R1, R2                             ; coloca novo digito no resultado
    JMP  calcula_digito  

sai_calcula_display:
    POP  R3
    POP  R2
    POP  R8
    POP  R0
    RET

; **********************************************************************
; desenha_objeto - Desenha o objeto na linha e coluna indicadas
;                  com a forma e cor definidas na tabela indicada.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R4 - tabela que define o boneco
; **********************************************************************

desenha_objeto:
    PUSH  R1
    PUSH  R2 
    PUSH  R3 
    PUSH  R4 
    PUSH  R5
    PUSH  R6
    PUSH  R7
    PUSH  R8
    MOV   R5, [R4]                          ; obtém a largura do objeto
    MOV   R7, R5                            ; guarda a largura do objeto
    MOV   R8, R2                            ; guarda a coluna inicial
    ADD   R4, 2                             ; endereço da altura do objeto
    MOV   R6, [R4]                          ; obtém a altura do objeto
    ADD   R4, 2                             ; endereço da cor do 1º pixel

desenha_pixels:                             ; desenha os pixels do objeto a partir da tabela
    MOV   R3, [R4]                          ; obtém a cor do próximo pixel do objeto
    CALL  escreve_pixel                     ; escreve um pixel do objeto
    ADD   R4, 2                             ; endereço da cor do próximo pixel
    ADD   R2, 1                             ; próxima coluna
    SUB   R5, 1                             ; menos uma coluna para tratar
    JNZ   desenha_pixels                    ; continua até percorrer toda a largura do objeto
    MOV   R5, R7                            ; retoma o valor de largura do objeto
    MOV   R2, R8                            ; retoma o valor da coluna inicial do objeto
    ADD   R1, 1                             ; próxima linha
    SUB   R6, 1                             ; verifica se todas as linhas já foram desenhadas
    JNZ   desenha_pixels                    ; continua até percorrer toda a altura do objeto
    POP   R8
    POP   R7
    POP   R6
    POP   R5
    POP   R4
    POP   R3
    POP   R2
    POP   R1
    RET

; **********************************************************************
; escreve_pixel - Escreve um pixel na linha e coluna indicadas.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R3 - cor do pixel (em formato ARGB de 16 bits)
; **********************************************************************

escreve_pixel:
    MOV  [DEFINE_LINHA], R1                 ; seleciona a linha
    MOV  [DEFINE_COLUNA], R2                ; seleciona a coluna
    MOV  [DEFINE_PIXEL], R3                 ; altera a cor do pixel na linha e coluna já selecionadas
    RET


; **********************************************************************
; apaga_objeto - Apaga um objeto na linha e coluna indicadas
;                com a forma definida na tabela indicada.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R4 - tabela que define o objeto
; **********************************************************************

apaga_objeto:
    PUSH  R1
    PUSH  R2
    PUSH  R3
    PUSH  R4
    PUSH  R5
    PUSH  R6
    PUSH  R7
    PUSH  R8
    MOV   R5, [R4]                          ; obtém a largura do objeto
    MOV   R7, R5                            ; guarda a altura do objeto
    MOV   R8, R2                            ; guarda a coluna inicial do painel
    ADD   R4, 2                             ; endereço da altura do objeto
    MOV   R6, [R4]                          ; obtém a altura do objeto
    ADD   R4, 2                             ; endereço da cor do 1º pixel

apaga_pixels:                               ; apaga os pixels do objeto a partir da tabela
    MOV   R3, 0                             ; cor para apagar o próximo pixel do objeto
    CALL  escreve_pixel                     ; escreve cada pixel do objeto
    ADD   R4, 2                             ; endereço da cor do próximo pixel
    ADD   R2, 1                             ; próxima coluna
    SUB   R5, 1                             ; menos uma coluna para tratar
    JNZ   apaga_pixels                      ; continua até percorrer toda a largura do objeto
    MOV   R5, R7                            ; retoma o valor de largura do objeto
    MOV   R2, R8                            ; retoma o valor da coluna inicial do objeto
    ADD   R1, 1                             ; próxima linha
    SUB   R6, 1                             ; verifica se todas as linhas já foram apagadas
    JNZ   apaga_pixels                      ; continua até percorrer toda a altura do objeto
    POP   R8
    POP   R7
    POP   R6
    POP   R5
    POP   R4
    POP   R3
    POP   R2
    POP   R1
    RET

; **********************************************************************
; DISPARA_SONDA - dispara a sonda correspondente a direção da sonda
; Argumentos:	R5 - direção do movimento da sonda
;
; **********************************************************************

dispara_sonda:
    PUSH R0
    PUSH R1
    PUSH R2
    MOV  R0, R5                             ; cópia da direção
    INC  R0                                 ; para calcular endereço na tabela (0, 1, 2)
    MOV  R1, 4                              ; para calcular endereço na tabela
    MUL  R0, R1                             ; posicao da sonda relativa a tabela sondas lancadas
    MOV  R1, sondas_lancadas                ; endereço da tabela sondas lancadas
    ADD  R0, R1                             ; endereço das coordenadas da sonda
    MOV  R1, [R0]                           ; obtem linha da sonda esquerda
    ADD  R0, 2                              ; endereço da coluna
    MOV  R2, [R0]                           ; obtem coluna da sonda esquerda
    ADD  R1, R2                             ; soma linha e coluna
    MOV  R2, SONDA_NAO_LANCADA              ; soma que corresponde a uma sonda não lancada
    CMP  R1, R2                             ; a sonda ja está em lançamento
    JNZ  sai_dispara_sonda                  ; se estiver sai

    CALL sonda

sai_dispara_sonda:
    POP     R2
    POP     R1
    POP     R0
    RET

; **********************************************************************
; INICIA_ASTEROIDES - inicia 4 asteroides a movimentar
; **********************************************************************

inicia_asteroides:
    PUSH R0
    PUSH R9
    PUSH R4
    CALL rand15                             ; gera numero aleatória 1-15
    MOV  R0, 5                              ; divisor
    MOD  R9, R0                             ; número aleatória 0-4
   
inicia_ast_esq:                             ; asteroide à esquerda
    CMP  R9, 0       
    JZ   inicia_ast_cent_dir
    CALL cria_asteroide_esq

inicia_ast_cent_dir:                        ; movimento à direita
    CMP  R9, 1
    JZ   inicia_ast_cent_cent
    CALL cria_asteroide_cent_dir

inicia_ast_cent_cent:                       ; movimento na vertical
    CMP  R9, 2
    JZ   inicia_ast_cent_esq
    CALL cria_asteroide_cent_cent

inicia_ast_cent_esq:                        ; movimento à esquerda
    CMP  R9, 3
    JZ   inicia_ast_dir
    CALL cria_asteroide_cent_esq

inicia_ast_dir:                             ; asteroide à esquerda
    CMP  R9, 4
    JZ   sai_inicia_asteroides
    CALL cria_asteroide_dir

sai_inicia_asteroides:
    POP R4
    POP R9
    POP R0
    
; **********************************************************************
; GERA_TIPO_ASTEROIDE - escolha aleatoriamente a tabela para desenhar o asteroide
;
; Retorna:  R4 - tabela de asteroide a desenhar
; **********************************************************************

gera_tipo_asteroide:
    PUSH R0
    PUSH R1
    MOV  R0, MASCARA_GERADOR_ALEATORIO
    MOV  R1, [TEC_COL]                      ; ler o PIN
    AND  R1, R0                             ; isolar 4 bits aleatórios
    SHR  R1, 6                              ; isolar e colocar 2 bits à direita (numero aleatório 0-3)
    JZ   gera_recursos
    MOV  R4, ASTEROIDE_PERIGO
    JMP  sai_gera_tipo_asteroide

gera_recursos:
    MOV  R4, ASTEROIDE_COM_RECURSOS

sai_gera_tipo_asteroide:
    POP  R1
    POP  R0
    RET

; **********************************************************************
; GERA_ASTEROIDES_EM_FALTA - cria o numero de asteroides que estão a faltar
;
; **********************************************************************

gera_asteroides_em_falta:
    PUSH R0
    MOV  R0, [asteroides_em_falta]          ; obtem numero de asteroides para criar
    
cria_asteroide:
    CALL gera_asteroide                     ; cria um novo asteroide aleatoriamente
    DEC  R0                                 ; diminui numero de asteroides a faltar
    JNZ  cria_asteroide                     ; se ainda faltam asteroides a criar repete
    MOV  [asteroides_em_falta], R0          ; coloca 0 no endereço dos asteroides a faltar
    POP  R0
    RET

; **********************************************************************
; GERA_ASTEROIDE - gera valores pseudo-aleatórias para o tipo, posição
;                  e direção para um asteroide
; Retorna:  R1 - linha inicial do asteroide
;           R2 - coluna inicial do asteroide
;           R4 - tipo do asteroide
;           R5 - direcao x do asteroide
;           R6 - direcao y do asteroide
; **********************************************************************

gera_asteroide:
    PUSH R2
    PUSH R5
    PUSH R8
    PUSH R9

    CALL rand15
    MOV  R8, 9
    CMP  R9, R8                             ; caso o nº criado seja 9, cria asteroide no centro
    JLE  asteroide_cent
    MOV  R8, 12
    CMP  R9, R8                             ; caso o nº criado seja 12, cria asteroide à esquerda
    JLE  asteroide_esq
    CALL cria_asteroide_dir
    JMP  sai_gera_asteroide

asteroide_esq:
    CALL cria_asteroide_esq
    JMP  sai_gera_asteroide

asteroide_cent:
    MOV  R2, COLUNA_CENT
    SUB  R2, 2
    MOV  R8, 3                              ; divisor
    MOD  R9, R8                             ; obtem numero 0-2
    SUB  R9, 1                              ; obtem direcao x da forma -1, 0 ou 1
    MOV  R5, R9                             ; retornar valor da direcao x
    CALL asteroide

sai_gera_asteroide:
    POP R9
    POP R8
    POP R5
    POP R2
    RET

; **********************************************************************
; rand15 - gera um número pseudo-aleatória 1-15
;
; Retorna:  R9 - número pseudo-aleatória 1-15
; **********************************************************************

rand15:
    PUSH R0
    MOV  R0, MASCARA_GERADOR_ALEATORIO

rand15_ciclo:                               ; para verificar que o número não seja 0
    YIELD                                   ; este ciclo é potencialmente bloqueante (ponto de fuga)
    MOV  R9, [TEC_COL]                      ; ler o PIN
    AND  R9, R0                             ; isolar 4 bits do maior peso (aleatórios)
    JZ   rand15_ciclo                       ; se o número for 0 repete
    SHR  R9, 4                              ; colocar o 4 bits à direita (numero aleatório 1-15)

    POP  R0
    RET

; **********************************************************************
; CRIA_ASTEROIDE_ESQ - cria um asteroide a esquerda
;
; **********************************************************************

cria_asteroide_esq:                         
    PUSH R2
    PUSH R5
    MOV  R2, COLUNA_ESQ
    MOV  R5, DIRECAO_DIR
    CALL asteroide
    POP  R5
    POP  R2
    RET

; **********************************************************************
; CRIA_ASTEROIDE_DIR - cria um asteroide a direita
;
; **********************************************************************

cria_asteroide_dir:                         
    PUSH R2
    PUSH R5
    MOV  R2, COLUNA_DIR - 4
    MOV  R5, DIRECAO_ESQ
    CALL asteroide
    POP  R5
    POP  R2
    RET

; **********************************************************************
; CRIA_ASTEROIDE_CENT_ESQ - cria um asteroide no centro com movimento a esquerda
;
; **********************************************************************

cria_asteroide_cent_esq:                    
    PUSH R2
    PUSH R5
    MOV  R2, COLUNA_CENT - 2
    MOV  R5, DIRECAO_ESQ
    CALL asteroide
    POP  R5
    POP  R2
    RET

; **********************************************************************
; CRIA_ASTEROIDE_CENT_CENT - cria um asteroide no centro com movimento na vertical
;
; **********************************************************************

cria_asteroide_cent_cent:                   
    PUSH R2
    PUSH R5
    MOV  R2, COLUNA_CENT - 2
    MOV  R5, DIRECAO_CENT
    CALL asteroide
    POP  R5
    POP  R2
    RET

; **********************************************************************
; CRIA_ASTEROIDE_CENT_DIR - cria um asteroide no centro com movimento a direita
;
; **********************************************************************

cria_asteroide_cent_dir:                    
    PUSH R2
    PUSH R5
    MOV  R2, COLUNA_CENT - 2
    MOV  R5, DIRECAO_DIR
    CALL asteroide
    POP  R5
    POP  R2
    RET

; **********************************************************************
; CALCULA_ENDERECO_SONDAS_LANCADAS - calcula o endereço das coordenadas sonda
;                                    correspondente a direção
; Argumentos:	R5 - direção do movimento da sonda
;
; Retorna:  R7 - endereço das coordenadas da sonda
; **********************************************************************

calcula_endereco_sondas_lancadas:           
    PUSH R0
    MOV  R7, R5                             ; cópia do valor da direção
    INC  R7
    MOV  R0, 4                              ; cada par de coordenada são WORDs 2 + 2
    MUL  R7, R0                             ; calcula posicao na tabela da sondas lançadas
    MOV  R0, sondas_lancadas
    ADD  R7, R0                             ; obtém endereço nas sondas lançadas
    POP  R0
    RET

; **********************************************************************
; CALCULA_POSICAO_SONDA - calcula os dados para desenhar a sonda
; Argumentos:	R5 - direção do movimento da sonda
;
; Retorna:  R1 - linha inicial da sonda
;           R2 - coluna inicial da sonda
; **********************************************************************

calcula_posicao_sonda:
	MOV  R1, LINHA_CIMA_PAINEL              ; linha da sonda

    CMP  R5, DIRECAO_ESQ                    ; se for lancada uma sonda a esquerda
    JZ   pos_sonda_esq                      ; inicia coluna a esquerda do painel
    
    CMP  R5, DIRECAO_DIR                    ; se for lancada uma sonda a esquerda
    JZ   pos_sonda_dir                      ; inicia coluna a esquerda do painel

	MOV  R2, COLUNA_CENT	                ; coluna da sonda no centro
    JMP  sai_calcula_posicao_sonda

pos_sonda_esq:                              ; define a sonda a esquerda
	MOV  R2, COLUNA_SONDA_ESQ               ; inicia coluna a esquerda do painel
    JMP  sai_calcula_posicao_sonda

pos_sonda_dir:                              ; define a sonda a direita
	MOV  R2, COLUNA_SONDA_DIR               ; inicia coluna a direita do painel

sai_calcula_posicao_sonda:
    RET

; **********************************************************************
; CONFIGURA_INICIO_JOGO - inicia o jogo e inicializa os processos
;
; **********************************************************************

configura_inicio_jogo:
    PUSH R1

    MOV  R1, SOM_INICIO                     ; som do inicio do jogo
    MOV  [PARA_SOM_VIDEO], R1               ; para som corrente
    MOV  [REPRODUZ_SOM_VIDEO], R1           ; toca som do inicio
    MOV  R1, JOGO_INICIADO                  ; estado do jogo inicio
    MOV  [estado_jogo], R1                  ; atualiza estado do jogo
    MOV  R1, FUNDO_JOGO                     ; imagem de fundo do jogo
    MOV  [FUNDO_ECRA], R1                   ; coloca imagem de fundo para durante o jogo
    MOV  [APAGA_MSG], R1                    ; apaga as letras de inicio de jogo
    
    ; cria processos.
    CALL painel                             ; cria o processo painel
    CALL energia                            ; cria o processo energia
    CALL inicia_asteroides                  ; rotina que cria os processos para os 4 asteroides

    POP  R1
    RET

; **********************************************************************
; PAUSA_JOGO - Rotina que coloca o jogo em modo pausa
;
; **********************************************************************

pausa_jogo:
    PUSH R1
    PUSH R2
    PUSH R3

    MOV  R1, MSG_PAUSA
    MOV  [MSG], R1                           ; mostra a mensagem da pausa
    MOV  R1, SOM_PAUSA
    MOV  [PARA_SOM_VIDEO], R1                ; para todos os sons
    MOV  [REPRODUZ_SOM_VIDEO], R1            ; toca o som da pausa
    MOV  R1, JOGO_PAUSA
    MOV  [estado_jogo], R1                   ; bloqueia os processos

    POP  R3
    POP  R2
    POP  R1
    RET

; **********************************************************************
; CONTINUA_JOGO - Rotina que continua o jogo do modo pausa
;
; **********************************************************************

continua_jogo:
    PUSH R1

    MOV  [PARA_SOM_VIDEO], R1               ; para o todos os sons
    MOV  [APAGA_MSG], R1                    ; apaga todas as mensagens 
    MOV  R1, FUNDO_JOGO
    MOV  [FUNDO_ECRA], R1                   ; muda o fundo para o fundo do jogo
    MOV  R1, JOGO_INICIADO
    MOV  [estado_jogo], R1                  ; volta ao estado jogo iniciado
    MOV  [pausa_processos], R1              ; desbloqueia os processos

    POP  R1
    RET

; **********************************************************************
; GAME_END - Rotina que coloca o jogo no modo terminado
;
; **********************************************************************

game_end:
    PUSH R0

    MOV  R1, JOGO_TERMINADO
    MOV  [pausa_processos], R1              ; termina os processos se estiverem em pausa
    MOV  [estado_jogo], R1                  ; termina os processos se não estiverem em pausa
    MOV  [APAGA_AVISO], R1                  ; apaga o aviso de nenhum cenário selecionado (R1 irrelevante)
    MOV  R1, FUNDO_TERMINA
    MOV  [FUNDO_ECRA], R1                   ; coloca imagem de fundo incial
    MOV  R1, MSG_TERMINA
    MOV  [MSG], R1                          ; mostra a mensagem de jogo terminado
    MOV  R1, SOM_TERMINA
    MOV  [PARA_SOM_VIDEO], R1               ; para todos os sons
    MOV  [REPRODUZ_SOM_VIDEO], R1           ; toca o som de jogo terminada
    MOV  [APAGA_ECRA], R1                   ; apaga todos os pixels já desenhados (R1 irrelevante)

    POP  R1
    RET

; **********************************************************************
; GAME_OVER_EXPLOSAO - Rotina que coloca o jogo no modo terminado por explosão
;
; **********************************************************************

game_over_explosao:
    PUSH R1

    MOV  R1, JOGO_TERMINADO
    MOV  [estado_jogo], R1
    MOV  [APAGA_ECRA], R1                   ; apaga todos os pixeis do ecrã, R1 irrelevante
    MOV  [APAGA_AVISO], R1                  ; apaga o aviso de nenhum cenário selecionado (R1 irrelevante)
    MOV  R1, FUNDO_EXPLOSAO
    MOV  [FUNDO_ECRA], R1                   ; coloca imagem de fundo incial
    MOV  R1, SOM_EXPLOSAO
    MOV  [PARA_SOM_VIDEO], R1               ; para todos os sons
    MOV  [REPRODUZ_SOM_VIDEO], R1           ; toca o som da explosão por colisão do asteroide com a nave
    MOV  R1, MSG_EXPLOSAO
    MOV  [MSG], R1                          ; mostra a mensagem da colisão do asteroide com a nave

    POP  R1
    RET

; **********************************************************************
; GAME_OVER_SEM_ENERGIA - Rotina que coloca o jogo no modo terminado por energia esgotada
;
; **********************************************************************

game_over_sem_energia:
    PUSH R1

    MOV  R1, JOGO_TERMINADO
    MOV  [estado_jogo], R1
    MOV  [APAGA_AVISO], R1                  ; apaga o aviso de nenhum cenário selecionado (R1 irrelevante)
    MOV  R1, FUNDO_ENERGIA
    MOV  [FUNDO_ECRA], R1                   ; coloca imagem de fundo incial
    MOV  [APAGA_MSG], R1                    ; apaga a mensagem sobreposta, valor de R1 irrelevante
    MOV  [APAGA_ECRA], R1                   ; apaga todos os pixels já desenhados (R1 irrelevante)
    MOV  R1, SOM_SEM_ENERGIA
    MOV  [PARA_SOM_VIDEO], R1               ; para todos os sons
    MOV  [REPRODUZ_SOM_VIDEO], R1           ; toca o som da nave a ficar sem energia
    MOV  R1, MSG_SEM_ENERGIA
    MOV  [MSG], R1                          ; mostra a mensagem da nave a ficar sem energia

    POP  R1
    RET

; **********************************************************************
; ROT_INT_0 - 	Rotina de atendimento da interrupção 0
; **********************************************************************
rot_int_0:
	MOV	 [evento_asteroide], R0	            ; desbloqueia processo asteroide
	RFE

; **********************************************************************
; ROT_INT_1 - 	Rotina de atendimento da interrupção 1
; **********************************************************************
rot_int_1:
    PUSH R0

    MOV  R0, 3
	MOV	 [evento_sonda], R0	                ; desbloqueia processo asteroide

    POP  R0
	RFE

; **********************************************************************
; ROT_INT_2 - 	Rotina de atendimento da interrupção 2
;           Trata do gasto da energia ao longo do tempo
; **********************************************************************
rot_int_2:
    PUSH R0
    PUSH R1
    PUSH R5

    MOV  R1, evento_display
    MOV  R0, GASTO_ENERGIA_TEMPO            ; desconta o gasto de energia no display
    MOV  [R1], R0

    POP  R5
    POP  R1
    POP  R0
	RFE

; **********************************************************************
; ROT_INT_3 - 	Rotina de atendimento da interrupção 3
; **********************************************************************
rot_int_3:
	MOV	[evento_painel], R0	                ; desbloqueia processo painel
	RFE
