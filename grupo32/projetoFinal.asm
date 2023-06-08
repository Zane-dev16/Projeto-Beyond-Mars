; *********************************************************************
; * IST-UL
; * Modulo:    grupo32.asm
; * Descrição: Projeto Intermédia do grupo 32
; *
; *********************************************************************

; **********************************************************************
; * Constantes
; **********************************************************************
DISPLAYS            EQU 0A000H  ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN             EQU 0C000H  ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL             EQU 0E000H  ; endereço das colunas do teclado (periférico PIN)
LINHA1              EQU 1       ; 1ª linha
LINHA4              EQU 8       ; 4ª linha
MASCARA_TECLA       EQU 0FH     ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
MASCARA_GERADOR_ALEATORIO   EQU 0F0H    ; para isolar os 4 bits do maior peso (pseudo-aleatórias)

TECLA_SONDA_ESQ     EQU 0       ; tecla para lancar uma sonda a esquerda (tecla 0)
TECLA_SONDA_CENT    EQU 1       ; tecla para lancar uma sonda no centro (tecla 1)
TECLA_SONDA_DIR     EQU 2       ; tecla para lancar uma sonda a direita (tecla 2)
TECLA_INICIO_JOGO   EQU 12      ; tecla para iniciar o jogo (tecla C)
TECLA_PAUSA         EQU 13      ; tecla para pausa e continuar o jogo (tecla D)
TECLA_TERMINA       EQU 14      ; tecla para pausa e continuar o jogo (tecla E)
TECLA_REINICIA      EQU 12      ; tecla para reiniciar o jogo (tecla F)
CRIA_ASTEROIDE      EQU 16      ; para criar um asteroide quando um for destruido
MODO_EXPLOSAO       EQU 17      ; para terminar o jogo com explosão
MODO_SEM_ENERGIA    EQU 18      ; para terminar o jogo quando energia é esgotada

INICIO_ENERGIA      EQU 100     ;
ENERGIA_SONDA       EQU -5      ; corresponde ao gasto da energia pelo disparo de uma sonda
FATOR_INICIAL       EQU 1000    ;

COMANDOS				EQU	6000H			; endereço de base dos comandos do MediaCenter

LE_COR_PIXEL				EQU	COMANDOS + 10H		; endereço do comando para ler a cor de um pixel
ESTADO_PIXEL				EQU	COMANDOS + 14H		; endereço do comando para ler o estado de um pixel (ligado-1, desligado-0)
DEFINE_LINHA    		    EQU COMANDOS + 0AH		; endereço do comando para definir a linha
DEFINE_COLUNA   		    EQU COMANDOS + 0CH		; endereço do comando para definir a coluna
DEFINE_PIXEL    		    EQU COMANDOS + 12H		; endereço do comando para escrever um pixel
APAGA_AVISO     		    EQU COMANDOS + 40H		; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRA	 		        EQU COMANDOS + 02H		; endereço do comando para apagar todos os pixels já desenhados
FUNDO_ECRA                  EQU COMANDOS + 42H		; endereço do comando para selecionar uma imagem de fundo
MSG                         EQU COMANDOS + 46H      ; endereço do comando para sobrepor uma imagem (mensagem) à imagem de fundo
APAGA_MSG                   EQU COMANDOS + 44H      ; endereço do comando para apagar a imagem sobreposta
REPRODUZ_SOM_VIDEO          EQU COMANDOS + 5AH      ; endereço do comando para reproduzir um som ou video
PARA_SOM_VIDEO              EQU COMANDOS + 68H      ; endereço do comando para para todos os sons e videos

FUNDO_INICIAL       EQU 0
FUNDO_JOGO          EQU 1
FUNDO_EXPLOSAO      EQU 2
FUNDO_ENERGIA       EQU 3

MSG_TRANSPARENTE    EQU 4
MSG_INICIAR         EQU 5
MSG_PAUSA           EQU 6
MSG_EXPLOSAO        EQU 7
MSG_SEM_ENERGIA     EQU 8

SOM_INICIO         EQU 0
SOM_DISPARO        EQU 1
SOM_AST_DESTRUIDO  EQU 2
SOM_AST_MINERADO   EQU 3
SOM_EXPLOSAO       EQU 4
SOM_PAUSA          EQU 5
SOM_SEM_ENERGIA    EQU 6

LINHA_TOPO        	EQU 0       ; linha do topo do ecrã
COLUNA_ESQ			EQU 0       ; coluna mais à esquerda
COLUNA_CENT         EQU 32      ; coluna central
COLUNA_DIR          EQU 63      ; coluna mais à direita

LINHA_PAINEL        EQU 27      ; linha do painel da nave
COLUNA_PAINEL       EQU 25      ; coluna do painel da nave

LINHA_CIMA_PAINEL	EQU 26		 ; linha acima do painel

DIRECAO_ESQ         EQU -1      ; para mover um objeto a esquerda
DIRECAO_CENT        EQU 0       ; para mover um objeto verticalmente
DIRECAO_DIR         EQU 1       ; para mover um objeto a direita

COLUNA_SONDA_ESQ    EQU 26      ; coluna inicial de uma sonda a esquerda
COLUNA_SONDA_DIR    EQU 38      ; coluna inicial de uma sonda a direita

LARGURA_SONDA       EQU 1        ; largura das sondas
ALTURA_SONDA        EQU 1        ; altura das sondas

LARGURA_AST			EQU	5		; largura do asteroide
ALTURA_AST          EQU 5       ; altura do asteroide 

LARGURA_PAINEL      EQU 15      ; largura do painel da nave
ALTURA_PAINEL       EQU 5       ; altura do painel da nave

LARGURA_LUZES       EQU 11      ; largura dos luzes do painel
ALTURA_LUZES        EQU 2       ; altura dos luzes do painel

PROX_ANIM_PAINEL    EQU 48      ; para obter os pixels do proximo animação do painel      

PIXEL_VERM		    EQU	0FF00H	; pixel vermelho opaco
PIXEL_VERM_TRANS    EQU	0FF00H	; pixel vermelho translucido
PIXEL_VERD          EQU 0F0F0H  ; pixel verde opaco 
PIXEL_VERD_TRANS    EQU 0F0F0H  ; pixel verde translucido 
PIXEL_AZUL          EQU 0F0BFH  ; pixel azul opaco 
PIXEL_VIOLETA       EQU 0FA3CH  ; pixel violeta opaco 
PIXEL_AMAR          EQU 0FFF0H  ; pixel opaco amarelo
PIXEL_CAST          EQU 0F850H  ; pixel opaco castanho
PIXEL_AMAR_TRANS    EQU 05FF0H  ; pixel amarelo translucido 
PIXEL_CINZ_ESC      EQU 0F777H  ; pixel cinzento escuro opaco 
PIXEL_CINZ_CLA      EQU 0FFFFH  ; pixel cinzento claro opaco 

TAMANHO_PILHA		EQU 100H    ; tamanho de cada pilha, em words
N_ASTEROIDES        EQU 4       ; nº de asteroides em simultaneo
N_SONDA             EQU 3       ; nº de sondas em simultaneo

JOGO_INICIADO       EQU 1       ; jogo iniciado
JOGO_PAUSA          EQU 0       ; jogo em pausa
JOGO_TERMINADO      EQU 2      ; jogo terminado

; *********************************************************************************
; * Dados 
; *********************************************************************************
	PLACE       1000H

; Reserva do espaço para as pilhas dos processos
	STACK TAMANHO_PILHA		; espaço reservado para a pilha do processo "programa principal"
SP_inicial_prog_princ:		; este é o endereço com que o SP deste processo deve ser inicializado

	STACK TAMANHO_PILHA		; espaço reservado para a pilha do processo "programa principal"
SP_inicial_energia:		; este é o endereço com que o SP deste processo deve ser inicializado

	STACK TAMANHO_PILHA		; espaço reservado para a pilha do processo "teclado"
SP_inicial_teclado:		; este é o endereço com que o SP deste processo deve ser inicializado
							
	STACK TAMANHO_PILHA		; espaço reservado para a pilha do processo "teclado"
SP_inicial_painel:			; este é o endereço com que o SP deste processo deve ser inicializado
		
	STACK TAMANHO_PILHA * N_SONDA		; espaço reservado para a pilha do processo "teclado"
SP_inicial_sonda:			; este é o endereço com que o SP deste processo deve ser inicializado

	STACK TAMANHO_PILHA	* N_ASTEROIDES	; espaço reservado para a pilha do processo "teclado"
SP_inicial_asteroide:		; este é o endereço com que o SP deste processo deve ser inicializado
							
						
ASTEROIDE_PERIGO:		; tabela que define o asteroide perigoso (cor, largura, pixels, altura)
	WORD		LARGURA_AST
    WORD        ALTURA_AST
	WORD		0, PIXEL_VERM, PIXEL_VERM, PIXEL_VERM, 0		
    WORD		PIXEL_VERM, PIXEL_VERM, PIXEL_VERM, PIXEL_VERM, PIXEL_VERM
    WORD		PIXEL_VERM, PIXEL_VERM, PIXEL_VERM, PIXEL_VERM, PIXEL_VERM
    WORD		PIXEL_VERM, PIXEL_VERM, PIXEL_VERM, PIXEL_VERM, PIXEL_VERM
    WORD		0, PIXEL_VERM, PIXEL_VERM, PIXEL_VERM, 0

ASTEROIDE_COM_RECURSOS:	; tabela que define o asteroide com recursos (cor, largura, pixels, altura)
	WORD		LARGURA_AST
    WORD        ALTURA_AST
	WORD		0, 0, PIXEL_VERD, 0, 0		
    WORD		0, PIXEL_VERD, PIXEL_VERD, PIXEL_VERD, 0
    WORD		PIXEL_VERD, PIXEL_VERD, PIXEL_VERD, PIXEL_VERD, PIXEL_VERD
    WORD		0, PIXEL_VERD, PIXEL_VERD, PIXEL_VERD, 0
    WORD		0, 0, PIXEL_VERD, 0, 0 

RECURSOS:				; tabela que define os recursos (cor, largura, pixels, altura)
	WORD		LARGURA_AST
    WORD        ALTURA_AST
	WORD		PIXEL_AZUL, 0, PIXEL_AZUL, 0, PIXEL_AZUL		
    WORD		0, PIXEL_AZUL, PIXEL_AZUL, PIXEL_AZUL, 0
    WORD		PIXEL_AZUL, PIXEL_AZUL, PIXEL_AZUL, PIXEL_AZUL, PIXEL_AZUL
    WORD		0, PIXEL_AZUL, PIXEL_AZUL, PIXEL_AZUL, 0
    WORD		PIXEL_AZUL, 0, PIXEL_AZUL, 0, PIXEL_AZUL 

PAINEL_NAVE:			; tabela que define o painel da nave (cor, largura, pixels, altura)
	WORD		LARGURA_PAINEL
    WORD        ALTURA_PAINEL
	WORD		0, 0, PIXEL_CINZ_ESC, PIXEL_CINZ_ESC, PIXEL_CINZ_ESC, PIXEL_CINZ_ESC, PIXEL_CINZ_ESC, PIXEL_CINZ_ESC, PIXEL_CINZ_ESC, PIXEL_CINZ_ESC, PIXEL_CINZ_ESC, PIXEL_CINZ_ESC, PIXEL_CINZ_ESC, 0, 0		
    WORD		0, PIXEL_CINZ_ESC, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_ESC, 0
    WORD		PIXEL_CINZ_ESC, PIXEL_CINZ_CLA, PIXEL_VERM_TRANS, PIXEL_CINZ_CLA, PIXEL_AMAR_TRANS, PIXEL_CINZ_CLA, PIXEL_VIOLETA, PIXEL_CINZ_CLA, PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_AMAR_TRANS, PIXEL_CINZ_CLA, PIXEL_VERD_TRANS, PIXEL_CINZ_CLA, PIXEL_CINZ_ESC
    WORD		PIXEL_CINZ_ESC, PIXEL_CINZ_CLA, PIXEL_VERM, PIXEL_CINZ_CLA, PIXEL_AMAR, PIXEL_CINZ_CLA, PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_VIOLETA, PIXEL_CINZ_CLA, PIXEL_AMAR, PIXEL_CINZ_CLA, PIXEL_VERD, PIXEL_CINZ_CLA, PIXEL_CINZ_ESC
    WORD		PIXEL_CINZ_ESC, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_CLA, PIXEL_CINZ_ESC 

ANIMACAO_PAINEL_1:
	WORD		LARGURA_LUZES
    WORD        ALTURA_LUZES
    WORD		PIXEL_AMAR, PIXEL_CINZ_CLA, PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_VERD, PIXEL_CINZ_CLA, PIXEL_CAST, PIXEL_CINZ_CLA, PIXEL_VERM
    WORD		PIXEL_AMAR, PIXEL_CINZ_CLA, PIXEL_CAST, PIXEL_CINZ_CLA, PIXEL_VERD, PIXEL_CINZ_CLA, PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_VERM

ANIMACAO_PAINEL_2:
	WORD		LARGURA_LUZES
    WORD        ALTURA_LUZES
    WORD		PIXEL_VERD_TRANS, PIXEL_CINZ_CLA, PIXEL_AMAR_TRANS, PIXEL_CINZ_CLA, PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_VIOLETA, PIXEL_CINZ_CLA, PIXEL_AMAR_TRANS, PIXEL_CINZ_CLA, PIXEL_VERM_TRANS
    WORD		PIXEL_VERD, PIXEL_CINZ_CLA, PIXEL_AMAR, PIXEL_CINZ_CLA, PIXEL_VIOLETA, PIXEL_CINZ_CLA, PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_AMAR, PIXEL_CINZ_CLA, PIXEL_VERM

ANIMACAO_PAINEL_3:
	WORD		LARGURA_LUZES
    WORD        ALTURA_LUZES
    WORD		PIXEL_VIOLETA, PIXEL_CINZ_CLA, PIXEL_VERD, PIXEL_CINZ_CLA, PIXEL_AMAR, PIXEL_CINZ_CLA, PIXEL_CAST, PIXEL_CINZ_CLA, PIXEL_VERM, PIXEL_CINZ_CLA, PIXEL_AMAR
    WORD		PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_VERD_TRANS, PIXEL_CINZ_CLA, PIXEL_VIOLETA, PIXEL_CINZ_CLA, PIXEL_AMAR_TRANS, PIXEL_CINZ_CLA, PIXEL_CAST, PIXEL_CINZ_CLA, PIXEL_AMAR_TRANS

ANIMACAO_PAINEL_4:
	WORD		LARGURA_LUZES
    WORD        ALTURA_LUZES
    WORD		PIXEL_CAST, PIXEL_CINZ_CLA, PIXEL_VERM, PIXEL_CINZ_CLA, PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_VERM_TRANS, PIXEL_CINZ_CLA, PIXEL_VERM, PIXEL_CINZ_CLA, PIXEL_AZUL
    WORD		PIXEL_VERD, PIXEL_CINZ_CLA, PIXEL_VIOLETA, PIXEL_CINZ_CLA, PIXEL_AMAR_TRANS, PIXEL_CINZ_CLA, PIXEL_VIOLETA, PIXEL_CINZ_CLA, PIXEL_CAST, PIXEL_CINZ_CLA, PIXEL_VIOLETA

ANIMACAO_PAINEL_5:
	WORD		LARGURA_LUZES
    WORD        ALTURA_LUZES
    WORD		PIXEL_VERD, PIXEL_CINZ_CLA, PIXEL_VERD_TRANS, PIXEL_CINZ_CLA, PIXEL_CAST, PIXEL_CINZ_CLA, PIXEL_VIOLETA, PIXEL_CINZ_CLA, PIXEL_VERM, PIXEL_CINZ_CLA, PIXEL_CAST
    WORD		PIXEL_VERM, PIXEL_CINZ_CLA, PIXEL_AMAR, PIXEL_CINZ_CLA, PIXEL_AMAR_TRANS, PIXEL_CINZ_CLA, PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_VERD, PIXEL_CINZ_CLA, PIXEL_AZUL

ANIMACAO_PAINEL_6:
	WORD		LARGURA_LUZES
    WORD        ALTURA_LUZES
    WORD		PIXEL_VERM, PIXEL_CINZ_CLA, PIXEL_AMAR, PIXEL_CINZ_CLA, PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_VIOLETA, PIXEL_CINZ_CLA, PIXEL_AMAR, PIXEL_CINZ_CLA, PIXEL_VERD
    WORD		PIXEL_VERM_TRANS, PIXEL_CINZ_CLA, PIXEL_AMAR_TRANS, PIXEL_CINZ_CLA, PIXEL_VIOLETA, PIXEL_CINZ_CLA, PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_AMAR_TRANS, PIXEL_CINZ_CLA, PIXEL_VERD_TRANS

ANIMACAO_PAINEL_7:
	WORD		LARGURA_LUZES
    WORD        ALTURA_LUZES
    WORD		PIXEL_VERD, PIXEL_CINZ_CLA, PIXEL_AMAR, PIXEL_CINZ_CLA, PIXEL_VIOLETA, PIXEL_CINZ_CLA, PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_AMAR, PIXEL_CINZ_CLA, PIXEL_VERM
    WORD		PIXEL_VERD_TRANS, PIXEL_CINZ_CLA, PIXEL_AMAR_TRANS, PIXEL_CINZ_CLA, PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_VIOLETA, PIXEL_CINZ_CLA, PIXEL_AMAR_TRANS, PIXEL_CINZ_CLA, PIXEL_VERM_TRANS

ANIMACAO_PAINEL_8:
	WORD		LARGURA_LUZES
    WORD        ALTURA_LUZES
    WORD		PIXEL_AMAR, PIXEL_CINZ_CLA, PIXEL_CAST, PIXEL_CINZ_CLA, PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_VIOLETA, PIXEL_CINZ_CLA, PIXEL_VERD, PIXEL_CINZ_CLA, PIXEL_VERM
    WORD		PIXEL_AZUL, PIXEL_CINZ_CLA, PIXEL_AMAR_TRANS, PIXEL_CINZ_CLA, PIXEL_AMAR, PIXEL_CINZ_CLA, PIXEL_CAST, PIXEL_CINZ_CLA, PIXEL_VERM_TRANS, PIXEL_CINZ_CLA, PIXEL_VERD_TRANS



SONDA:                   ; tabela que define a sonda (cor, pixels)
    WORD    LARGURA_SONDA
    WORD    ALTURA_SONDA
    WORD    PIXEL_CAST

posicao_asteroide:       ; posição do asteroide
    WORD    LINHA_TOPO
    WORD    COLUNA_ESQ

sondas_lancadas:
    WORD    30, 32   ; coordenadas da primeira sonda
    WORD    30, 32   ; coordenadas da segunda sonda
    WORD    30, 32   ; coordenadas da terceira sonda


; Tabela das rotinas de interrupção
tab:
	WORD rot_int_0			; rotina de atendimento da interrupção 0
	WORD rot_int_1			; rotina de atendimento da interrupção 1
	WORD rot_int_2			; rotina de atendimento da interrupção 2
	WORD rot_int_3			; rotina de atendimento da interrupção 3

evento_asteroide:		; LOCKs que controla a temporização do movimento do asteroide
	LOCK 0				; LOCK para a rotina de interrupção 0

evento_sonda:			; LOCK que controla a temporização do movimento da sonda
	LOCK 0				; LOCK para a rotina de interrupção 1

evento_display:			; LOCK que controla a temporização do display
	LOCK 0				; LOCK para a rotina de interrupção 2

evento_painel:			; LOCK que controla a temporização do animação do painel
	LOCK 0				; LOCK para a rotina de interrupção 3

tecla_carregada:
    LOCK 0              ; LOCK para o teclado comunicar aos restantes processos que coluna detetou

pausa_processos:        ; LOCK para pausar os processos quando o jogo está em pausa
	LOCK 0

momento_jogo:            ; controlar se o jogo já foi iniciado
    WORD 0

estado_jogo:          ; LOCK para o teclado comunicar aos restantes processos o estado do jogo
    WORD 0


; *********************************************************************************
; * Código
; *********************************************************************************
PLACE      0
inicio:
	MOV  SP, SP_inicial_prog_princ		; inicializa SP do programa principal

	MOV  BTE, tab			; inicializa BTE (registo de Base da Tabela de Exceções)
    MOV [APAGA_AVISO], R1                   ; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV [APAGA_ECRA], R1                    ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
    MOV R1, FUNDO_INICIAL
    MOV [FUNDO_ECRA], R1         ; coloca imagem de fundo incial
    MOV R1, MSG_INICIAR
    MOV [MSG], R1    ; sobrepõe letras sobre a imagem inicial

    EI0                 ; permite interrupções 0
    EI1                 ; permite interrupções 1
    EI2                 ; permite interrupções 2
    EI3                 ; permite interrupções 3
	EI					; permite interrupções (geral)

	; cria processos.
    CALL teclado

espera_inicio:
    MOV R1, [tecla_carregada]   ; bloqueia neste LOCK até uma tecla ser carregada
    MOV R2, TECLA_INICIO_JOGO   ;
    CMP R1, R2                  ; verifica se a tecla premida foi o C
    JNZ espera_inicio       ; se a tecla premida não for C repete ciclo
    
inicia_jogo:
    MOV R1, SOM_INICIO
    MOV [REPRODUZ_SOM_VIDEO], R1
    MOV R1, JOGO_INICIADO
    MOV [estado_jogo], R1
    MOV R1, FUNDO_JOGO
    MOV [FUNDO_ECRA], R1        ; coloca imagem de fundo para durante o jogo
    MOV [APAGA_MSG], R1    ; apaga as letras de inicio de jogo

	; cria processos.
    CALL painel
    CALL energia
    CALL inicia_asteroides

obtem_tecla:
    MOV R1, [tecla_carregada]   ; bloqueia neste LOCK até uma tecla ser carregada

    MOV R2, TECLA_SONDA_ESQ    ; tecla para lancar uma sonda no centro (tecla 0)
    CMP R1, R2                  ; tecla para lancar uma sonda a esquerda (tecla 0)
    JZ sonda_esq               ; verifica se a tecla premida foi o 0

    MOV R2, TECLA_SONDA_CENT    ; tecla para lancar uma sonda no centro (tecla 1)
    CMP R1, R2                  ; verifica se a tecla premida foi o 1
    JZ sonda_cent

    MOV R2, TECLA_SONDA_DIR     ; tecla para lancar uma sonda a direita (tecla 2)
    CMP R1, R2                  ; verifica se a tecla premida foi o 2
    JZ sonda_dir

    MOV R2, TECLA_PAUSA        ; tecla para pausa e continuar o jogo
    CMP R1, R2                 ; verifica se a tecla premida foi o D
    JZ suspende_jogo

    MOV R2, TECLA_TERMINA
    CMP R1, R2                   ; verifica se a tecla premida foi o E
    JZ termina_jogo

    MOV R2, CRIA_ASTEROIDE
    CMP R1, R2
    JZ  cria_asteroide

    MOV R2, MODO_EXPLOSAO
    CMP R1, R2
    JZ  termina_jogo_explosão

    MOV R2, MODO_SEM_ENERGIA
    CMP R1, R2
    JZ  sem_energia

    JMP obtem_tecla             ; se a tecla premida não foi nenhuma das anteriores ignora a tecla

sonda_esq:
    MOV R1, [sondas_lancadas]
    MOV R2, [sondas_lancadas + 2]
    ADD R1, R2
    MOV R2, 62
    CMP R1, R2
    JNZ obtem_tecla
    MOV R1, 1
    MOV [sondas_lancadas], R1
    MOV R5, DIRECAO_ESQ
    CALL sonda
    JMP obtem_tecla

sonda_cent:
    MOV R1, [sondas_lancadas + 4]
    MOV R2, [sondas_lancadas + 6]
    ADD R1, R2
    MOV R2, 62
    CMP R1, R2
    JNZ obtem_tecla
    MOV R5, DIRECAO_CENT
    CALL sonda
    JMP obtem_tecla

sonda_dir:
    MOV R1, [sondas_lancadas + 8]
    MOV R2, [sondas_lancadas + 10]
    ADD R1, R2
    MOV R2, 62
    CMP R1, R2
    JNZ obtem_tecla
    MOV R1, 1
    MOV [sondas_lancadas + 4], R1
    MOV R5, DIRECAO_DIR
    CALL sonda
    JMP obtem_tecla

cria_asteroide:
    CALL gera_asteroide
    JMP obtem_tecla

suspende_jogo:
    MOV R1, MSG_PAUSA
    MOV [MSG], R1
    MOV R1, SOM_PAUSA
    MOV [REPRODUZ_SOM_VIDEO], R1
    MOV R1, JOGO_PAUSA
    MOV [estado_jogo], R1       ; bloqueia os processos

pausa_prog_principal:           ; neste ciclo o jogo está em modo pausa
                                ; e apenas sai quando a tecla D for premida
    MOV R1, [tecla_carregada]   ; bloqueia neste LOCK até uma tecla ser carregada
    MOV R2, TECLA_PAUSA         ; tecla para pausa e continuar o jogo
    CMP R1, R2                  ; verifica se a tecla premida foi o D
    JNZ pausa_prog_principal    ; repete o ciclo
    MOV [APAGA_MSG], R1
    MOV R1, JOGO_INICIADO
    MOV [estado_jogo], R1       ; volta ao estado jogo iniciado
    MOV [pausa_processos], R1   ; desbloqueia os processos
    JZ obtem_tecla              ; volta ao ciclo de funciomento da prog_principal

termina_jogo:
    MOV R1, JOGO_TERMINADO
    MOV [estado_jogo], R1
    MOV [APAGA_AVISO], R1                   ; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV R1, FUNDO_INICIAL
    MOV [FUNDO_ECRA], R1         ; coloca imagem de fundo incial
    MOV [APAGA_MSG], R1    ; apaga a mensagem sobreposta, valor de R1 irrelevante
    MOV [APAGA_ECRA], R1                    ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
    JMP espera_inicio

termina_jogo_explosão:
    MOV R1, JOGO_TERMINADO
    MOV [estado_jogo], R1
    JMP espera_inicio

sem_energia:
    MOV R1, JOGO_TERMINADO
    MOV [estado_jogo], R1
    MOV [APAGA_AVISO], R1                   ; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV R1, FUNDO_INICIAL
    MOV [FUNDO_ECRA], R1         ; coloca imagem de fundo incial
    MOV [APAGA_MSG], R1    ; apaga a mensagem sobreposta, valor de R1 irrelevante
    MOV [APAGA_ECRA], R1                    ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
    JMP espera_inicio

; **********************************************************************
; Processo
;
; PAINEL - Processo que desenha um painel controla a sua animação
;
; **********************************************************************

PROCESS SP_inicial_painel	;

painel:
	
	; desenha o painel
    MOV R1, LINHA_PAINEL               ; linha do painel da nave
    MOV R2, COLUNA_PAINEL              ; coluna do painel da nave
    MOV R4, PAINEL_NAVE                ; endereço da tabela que define o painel da nave
    CALL desenha_objeto                ; desenha o objeto a partir da tabela

    MOV R1, LINHA_PAINEL + 2
    MOV R2, COLUNA_PAINEL + 2

ciclo_anima_painel:
    MOV R4, ANIMACAO_PAINEL_1       ; Primeira forma das luzes do painel

anima_painel:
    MOV R3, JOGO_INICIADO
    MOV R0, [estado_jogo]
    CMP R0, R3                  ; O modo do jogo alterou?
    JNZ altera_modo_painel      ; Se for, salta

    MOV R0, [evento_painel]     ; Bloqueia até interrupção 3
    CALL desenha_objeto

    MOV R0, ANIMACAO_PAINEL_8
    CMP R4, R0                  ; Já foi desenhado o ultimo animação
    JZ  ciclo_anima_painel      ; se for, repete a partir da primeira animação
    MOV R0, PROX_ANIM_PAINEL
    ADD R4, R0                  ; obtem o proximo tabela do animação
    JMP anima_painel            ; desenha proximo animação

altera_modo_painel:
    MOV R3, JOGO_PAUSA          ; para verificar se o jogo está em pausa
    CMP R0, R3                  ; O jogo está em pausa?
    JZ  pausa_painel            ; se for, pausa o painel
    MOV [APAGA_ECRA], R1                    ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
    RET                         ; se não a tecla premida foi para terminar o jogo

pausa_painel:
   MOV R0, [pausa_processos]    ; bloqueia neste lock até o jogo continuar
   JMP anima_painel

; **********************************************************************
; Processo
;
; SONDA - Processo que desenha uma sonda e implementa o seu comportamento
;
; Argumento:    R5 - direção da sonda (em formato -1, 0, 1)
;
; **********************************************************************

PROCESS SP_inicial_sonda

sonda:
    ; atualiza display de energia
    MOV R0, ENERGIA_SONDA
    MOV R1, evento_display
    MOV [R1], R0

	; desenha a sonda na sua posição inicial
    MOV R8, 12
	MOV R1, LINHA_CIMA_PAINEL   ; linha da sonda
	MOV R4, SONDA

    CMP R5, DIRECAO_ESQ ; se for lancada uma sonda a esquerda
    JZ pos_sonda_esq    ; inicia coluna a esquerda do painel
    
    CMP R5, DIRECAO_DIR ; se for lancada uma sonda a esquerda
    JZ pos_sonda_dir    ; inicia coluna a esquerda do painel

	MOV R2, COLUNA_CENT	        ; coluna da sonda no centro
    JMP calcula_endereço_sondas_lancadas

pos_sonda_esq:
	MOV R2, COLUNA_SONDA_ESQ     ; inicia coluna a esquerda do painel
    JMP calcula_endereço_sondas_lancadas

pos_sonda_dir:
	MOV R2, COLUNA_SONDA_DIR     ; inicia coluna a direita do painel

calcula_endereço_sondas_lancadas:
    MOV R7, R5  ; cópia do valor da direção
    INC R7
    MOV R0, 4   ; cada par de coordenada são WORDs 2 + 2
    MUL R7, R0  ; calcula posicao na tabela da sondas lançadas
    MOV R0, sondas_lancadas
    ADD R7, R0 ; obtém endereço nas sondas lançadas

ciclo_sonda:

	;CALL colisao_sonda


    ; guarda posição na tabela
    MOV [R7], R1
    MOV [R7 + 2], R2

    CALL  desenha_objeto    ; Desenha o objeto novamente na nova posição

    MOV R3, JOGO_INICIADO       ; para verificar se o jogo ainda está a continuar
    MOV R6, [estado_jogo]       ; obtem o estado do jogo
    CMP R6, R3                  ; O modo do jogo alterou?
    JNZ altera_modo_sonda       ; Se for, salta

    MOV	R3, [evento_sonda]  ; lê o LOCK e bloqueia até a interrupção escrever nele
    MOV R9, R5
    INC R9  ; para comparar com referência de colisão (0-2)
    CMP R3, R9
    JZ sai_sonda   ; se tiver colisão sai

    CALL  apaga_objeto      ; Apaga o objeto em sua posição atual
    DEC R1      ; a sonda sobe uma linha
    ADD R2, R5  ;  atualiza posição com argumento do direção

    DEC R8      ; decrementa contador
    JZ  sai_sonda       ; se o contador for 0 sai
    
	JMP	ciclo_sonda		;

altera_modo_sonda:
    MOV R3, JOGO_PAUSA          ; para verificar se o jogo está em pausa
    MOV R6, [estado_jogo]       ; obtem estado do jogo
    CMP R6, R3                  ; O jogo está em pausa?
    JZ  pausa_sonda             ; se for, pausa
    RET                         ; se não a tecla premida foi para terminar o jogo

pausa_sonda:
   MOV R6, [pausa_processos]    ; bloqueia neste lock até o jogo continuar
   JMP ciclo_sonda              ; volta ao ciclo, a continuar o jogo

sai_sonda:
    MOV R0, 30
    MOV [R7], R0         ; reinicia valor na tabela
    MOV R0, 32
    MOV [R7 + 2], R0     ; reinicia valor na tabela
    MOV R4, R0                    ; apaga a sonda
    RET

; **********************************************************************
; Processo
;
; ASTEROIDE - Processo que desenha um asteroide implementa o seu comportamento
;
; **********************************************************************

PROCESS SP_inicial_asteroide	;

asteroide:
	; gera e desenha o asteroide na sua posição inicial
    MOV R6, 0           ; reinicia valor
    MOV R1, LINHA_TOPO  ; linha do asteroide
    CALL gera_tipo_asteroide

ciclo_asteroide:
	
	CALL 	colisao_painel
	CALL	desenha_objeto		; desenha o boneco a partir da tabela

    MOV R3, JOGO_INICIADO       ; para verificar se o jogo ainda está a continuar
    MOV R0, [estado_jogo]
    CMP R0, R3                  ; O modo do jogo alterou?
    JNZ altera_modo_asteroide      ; Se for, salta

	MOV	R3, [evento_asteroide]  	; lê o LOCK e bloqueia até a interrupção escrever nele

    CALL  apaga_objeto                    ; Apaga o objeto em sua posição atual
    INC   R1    ; Atualiza o posição do asteroide para a próxima linha
    ADD   R2, R5    ; Atualiza o posição do asteroide para a próxima coluna

	CALL	colisao_asteroide
    CMP R6, 1   ; teve colisão?
    JZ  sai_asteroide   ; se tiver sai 

	JMP	ciclo_asteroide		; esta "rotina" nunca retorna porque nunca termina
						; Se se quisesse terminar o processo, era deixar o processo chegar a um RET

altera_modo_asteroide:
    MOV R3, JOGO_PAUSA          ; para verificar se o jogo está em pausa
    MOV R0, [estado_jogo]       ; obtem estado do jogo
    CMP R0, R3                  ; O jogo está em pausa?
    JZ  pausa_asteroide         ; se for, pausa
    MOV [APAGA_ECRA], R1                    ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
    RET                         ; se não a tecla premida foi para terminar o jogo

pausa_asteroide:
   MOV R0, [pausa_processos]    ; bloqueia neste lock até o jogo continuar
   JMP ciclo_asteroide              ; volta ao ciclo, a continuar o jogo

sai_asteroide:
    RET

; **********************************************************************
; Processos de colisao
;
; Sonda - Processo que determina a colisao de uma sonda com um asteroide
;		  Argumentos: R1-linha da Sonda	R2-coluna da sonda
;
; **********************************************************************
muda_fundo:
	PUSH R0
	MOV R0,FUNDO_INICIAL		
	MOV [FUNDO_ECRA], R0         ; coloca imagem de fundo incial
	POP R0
	RET
	
colisao_asteroide:
	PUSH R5
	PUSH R7
	PUSH R8
	MOV	R5, R1
	MOV R7, R2
	ADD R5,4
	ADD R7,4
	MOV R8,[sondas_lancadas]
verifica_primeira_sonda:
	CMP R8, R5
	JGE verifica_segunda_sonda
	CMP R8, R1
	JLE verifica_segunda_sonda
	ADD R8, 2
	CMP R8, R7
	JGE verifica_segunda_sonda
	CMP R8, R2
	JLE verifica_segunda_sonda
	CALL muda_fundo
	JMP final
verifica_segunda_sonda:
	ADD R8, 2
	CMP R8, R5
	JGE verifica_terceira_sonda
	CMP R8, R1
	JLE verifica_terceira_sonda
	ADD R8, 2
	CMP R8, R7
	JGE verifica_terceira_sonda
	CMP R8, R2
	JLE verifica_terceira_sonda
	CALL muda_fundo
	JMP final
verifica_terceira_sonda:
	ADD R8, 2
	CMP R8, R5
	JGE verifica_terceira_sonda
	CMP R8, R1
	JLE verifica_terceira_sonda
	ADD R8, 2
	CMP R8, R7
	JGE verifica_terceira_sonda
	CMP R8, R2
	JLE verifica_terceira_sonda
	CALL muda_fundo
	JMP final

final:
	
	POP R8
	POP R7
	POP R5
	RET

; **********************************************************************
; COLISAO_PAINEL - verifica se o asteroide colide com o painel
;
; Retorna: 	
;
; **********************************************************************

colisao_painel:
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	PUSH R9
	PUSH R10
	MOV R5, R1
	MOV R6, R2
	MOV R9, R2
	SUB R9, 1							;coluna à esquerda do asteroide 
	ADD R5, 5							;linha abaixo do asteroide 
	ADD R6, 5							;linha à direita do asteroide
	MOV R10, PIXEL_CINZ_CLA

verica_canto_direito:
	MOV [DEFINE_LINHA],R5				;define a linha do pixel
	MOV [DEFINE_COLUNA],R6				;define a coluna do pixel
	MOV R7, [ESTADO_PIXEL]				;lê o estado do pixel (ligado-1 desligao-0)
	JZ  verifica_canto_esquerdo			;verifica se o painel está no canto inferior esquerdo do asteroide caso o pixel esteja desligado
	MOV R8, [LE_COR_PIXEL]				;lê a cor do pixel 
	CMP R8,R10							;verifica se é um pixel cinzento 
	JNZ verifica_canto_esquerdo			;verifica se o painel está no canto inferior esquerdo do asteroide caso o pixel não seja cinzento
	CALL explosao						;muda o fundo
    JMP termina

verifica_canto_esquerdo:
	MOV [DEFINE_COLUNA],R9				;define a coluna do pixel
	MOV R7, [ESTADO_PIXEL]				;lê o estado do pixel (ligado-1 desligao-0)
	JZ  termina							;termina a rotina caso o pixel esteja desligado
	MOV R8, [LE_COR_PIXEL]				;lê a cor do pixel 
	CMP R8,R10							;verifica se é um pixel cinzento
	JNZ termina							;termina a rotina caso o pixel não seja cinzento
	CALL explosao						;muda o fundo

termina:
	POP R10
	POP R9
	POP R8
	POP R7
	POP R6
	POP R5
	RET

explosao:
    PUSH R1
    MOV R1, JOGO_TERMINADO
    MOV [estado_jogo], R1
    MOV [APAGA_ECRA], R1 ; apaga todos os pixeis do ecrã, R1 irrelevante
    MOV [APAGA_AVISO], R1                   ; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV R1, FUNDO_EXPLOSAO
    MOV [FUNDO_ECRA], R1         ; coloca imagem de fundo incial
    MOV R1, SOM_EXPLOSAO
    MOV [REPRODUZ_SOM_VIDEO], R1
    MOV R1, MSG_EXPLOSAO
    MOV [MSG], R1
    MOV R1, MODO_EXPLOSAO
    MOV [tecla_carregada], R1
    POP R1
    RET


; **********************************************************************
; Processo
;
; ENERGIA - Processo que controla o calculo da energia e escrita ns displays
;
; **********************************************************************

PROCESS SP_inicial_energia	; Processo com valor para inicializar o SP

energia:
    MOV R8, INICIO_ENERGIA

atualiza_display:

    MOV R1, JOGO_INICIADO       ; para verificar se o jogo ainda está a continuar
    MOV R0, [estado_jogo]
    CMP R0, R1                  ; O modo do jogo alterou?
    JNZ altera_modo_energia      ; Se for, salta

    CALL escreve_display
    MOV R9, 94
    CMP R8, R9
    JZ  energia_esgotada
    MOV R0, [evento_display]
    ADD R8, R0
    JMP atualiza_display

altera_modo_energia:
    MOV R1, JOGO_PAUSA          ; para verificar se o jogo está em pausa
    MOV R0, [estado_jogo]       ; obtem estado do jogo
    CMP R0, R1                  ; O jogo está em pausa?
    JZ  pausa_energia           ; se for, pausa
    MOV [APAGA_ECRA], R1                    ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
    RET

pausa_energia:
   MOV R0, [pausa_processos]    ; bloqueia neste lock até o jogo continuar
   JMP atualiza_display              ; volta ao ciclo, a continuar o jogo

energia_esgotada:
    MOV R1, MODO_SEM_ENERGIA
    MOV [tecla_carregada], R1
    RET

; **********************************************************************
; Processo
;
; TECLADO - Processo que deteta quando se carrega numa tecla na 4ª linha
;		  do teclado e escreve o valor da coluna num LOCK.
;
; **********************************************************************

PROCESS SP_inicial_teclado	; Processo com valor para inicializar o SP

teclado:					; processo que implementa o comportamento do teclado
    CALL espera_tecla
ha_tecla:					; neste ciclo espera-se até NENHUMA tecla estar premida

	YIELD				; este ciclo é potencialmente bloqueante, pelo que tem de
						; ter um ponto de fuga (aqui pode comutar para outro processo)

    CALL calcula_tecla
	MOV	[tecla_carregada], R2	; guarda a coluna carregada
    CALL espera_libertar_tecla

	JMP	teclado		; esta "rotina" nunca retorna porque nunca termina


; **********************************************************************
; ESPERA_TECLA - Espera até uma tecla seja premida e lê a coluna e linha
;
; Retorna: 	R1 - linha da tecla premida
;           R0 - coluna da tecla premida
;
; **********************************************************************

espera_tecla:				; neste ciclo espera-se até uma tecla ser premida

	WAIT			        ; este ciclo é potencialmente bloqueante, pelo que tem de
						    ; ter um ponto de fuga (aqui pode comutar para outro processo)

	MOV  R1, LINHA1	        ; testar a linha 1
varre_linhas:
    CALL escreve_linha      ; ativar linha no teclado
    CALL le_coluna          ; leitura na linha ativada do teclado
    CMP  R0, 0              ; há tecla premida?
    JNZ sai_varre_linhas    
    CMP R1, 5               ; chegou à última linha?
    JGE espera_tecla        
    SHL R1, 1               ; testar a próxima linha
    JMP varre_linhas        ; continua o ciclo na próxima linha

sai_varre_linhas:
    RET

; **********************************************************************
; ESCREVE_LINHA - Faz uma leitura às teclas de uma linha do teclado e retorna o valor lido
; Argumentos:	R1 - linha a testar (em formato 1, 2, 4 ou 8)
;
; **********************************************************************
escreve_linha:
	PUSH R0
	MOV  R0, TEC_LIN        ; endereço do periférico das linhas
	MOVB [R0], R1           ; escrever no periférico de saída (linhas)
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
	MOV   R1, TEC_COL        ; endereço do periférico das colunas
	MOV   R2, MASCARA_TECLA  ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
	MOVB  R0, [R1]           ; ler do periférico de entrada (colunas)
	AND   R0, R2             ; elimina bits para além dos bits 0-3
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

calcula_tecla:                 ; calcula o valor da tecla
    PUSH  R1
    MOV   R2, 0                ; inicia valor da tecla no 0
    CALL  conta_linhas_colunas
    ADD   R2, R3               ; adicionar numero de linhas
    SHL   R2, 2                ; linhas * 4
    MOV   R1, R0               ; conta as colunas
    CALL  conta_linhas_colunas
    ADD   R2, R3               ; adicionar numero de colunas
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
    MOV  R3, 0                      ; inicia contador no 0

calc_val_lin_col:                   ; neste ciclo calcula-se o valor da linha/coluna
    SHR  R1, 1                      ; desloca à direita 1 bit
    CMP  R1, 0                      ; a quantidade das linhas/colunas ja foi contada?
    JZ   sai_conta_linhas_colunas   ; se ja for contada, salta
    INC  R3                         ; incrementa o valor calculada
    JMP  calc_val_lin_col           ; repete ciclo

sai_conta_linhas_colunas:
    POP  R1
    RET

; **********************************************************************
; espera_libertar_tecla - espera até a tecla premida seja libertada
;
; **********************************************************************

espera_libertar_tecla:              ; neste ciclo espera-se até a tecla estar libertada
    PUSH R0


tecla_premida:
    YIELD				    ; este ciclo é potencialmente bloqueante, pelo que tem de
                        ; ter um ponto de fuga (aqui pode comutar para outro processo)
    CALL le_coluna                  ; leitura na linha ativada do teclado
    CMP  R0, 0                      ; há tecla premida?
    JNZ  tecla_premida              ; se a tecla ainda for premida, espera até não haver
    POP R0
    RET

; **********************************************************************
; ESCREVE_DISPLAY - escreve um valor decimal no display hexadecimal
;                   na forma decimal
; Argumentos:   R8 - valor a escrever no display
;
; **********************************************************************

escreve_display:
    PUSH    R0
    PUSH    R1
    PUSH    R8
    MOV  R0, DISPLAYS  ; endereço do periférico dos displays
    CALL calcula_display
    MOV [R0], R1       ; escrever o valor no display
    POP R8
    POP R1
    POP R0
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
    MOV R0, FATOR_INICIAL; fator para obter os dígitos
    MOV R3, 10  ; para diminuir a potência de 10 do fator
calcula_digito:
    MOD R8, R0  ;
    DIV R0, R3  ; fator para obter proximo digito
    JZ sai_calcula_display; se o fator for menor que 10 sai
    MOV R2, R8  ; copia numero
    DIV R2, R0  ; calcula digito
    SHL R1, 4   ; desloca digitos no resultado para colocar novo digito
    OR  R1, R2  ; coloca novo digito no resultado
    JMP calcula_digito  ;

sai_calcula_display:
    POP R3
    POP R2
    POP R8
    POP R0
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
    MOV   R5, [R4]            ; Obtém a largura do objeto
    MOV   R7, R5              ; Guarda a largura do objeto
    MOV   R8, R2              ; Guarda a coluna inicial
    ADD   R4, 2               ; Endereço da altura do objeto
    MOV   R6, [R4]            ; Obtém a altura do objeto
    ADD   R4, 2               ; Endereço da cor do 1º pixel

desenha_pixels:               ; Desenha os pixels do objeto a partir da tabela
    MOV   R3, [R4]            ; Obtém a cor do próximo pixel do objeto
    CALL  escreve_pixel       ; Escreve um pixel do objeto
    ADD   R4, 2               ; Endereço da cor do próximo pixel
    ADD   R2, 1               ; Próxima coluna
    SUB   R5, 1               ; Menos uma coluna para tratar
    JNZ   desenha_pixels      ; Continua até percorrer toda a largura do objeto
    MOV   R5, R7              ; Retoma o valor de largura do objeto
    MOV   R2, R8              ; Retoma o valor da coluna inicial do objeto
    ADD   R1, 1               ; Próxima linha
    SUB   R6, 1               ; Verifica se todas as linhas já foram desenhadas
    JNZ   desenha_pixels      ; Continua até percorrer toda a altura do objeto
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
    MOV  [DEFINE_LINHA], R1   ; Seleciona a linha
    MOV  [DEFINE_COLUNA], R2  ; Seleciona a coluna
    MOV  [DEFINE_PIXEL], R3   ; Altera a cor do pixel na linha e coluna já selecionadas
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
    MOV   R5, [R4]            ; Obtém a largura do objeto
    MOV   R7, R5              ; Guarda a altura do objeto
    MOV   R8, R2              ; Guarda a coluna inicial do painel
    ADD   R4, 2               ; Endereço da altura do objeto
    MOV   R6, [R4]            ; Obtém a altura do objeto
    ADD   R4, 2               ; Endereço da cor do 1º pixel

apaga_pixels:                 ; Apaga os pixels do objeto a partir da tabela
    MOV   R3, 0               ; Cor para apagar o próximo pixel do objeto
    CALL  escreve_pixel       ; Escreve cada pixel do objeto
    ADD   R4, 2               ; Endereço da cor do próximo pixel
    ADD   R2, 1               ; Próxima coluna
    SUB   R5, 1               ; Menos uma coluna para tratar
    JNZ   apaga_pixels        ; Continua até percorrer toda a largura do objeto
    MOV   R5, R7              ; Retoma o valor de largura do objeto
    MOV   R2, R8              ; Retoma o valor da coluna inicial do objeto
    ADD   R1, 1               ; Próxima linha
    SUB   R6, 1               ; Verifica se todas as linhas já foram apagadas
    JNZ   apaga_pixels        ; Continua até percorrer toda a altura do objeto
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
; INICIA_ASTEROIDES - inicia 4 asteroides a movimentar
; **********************************************************************

inicia_asteroides:
    PUSH R0
    PUSH R9
    PUSH R4
    MOV R4, ASTEROIDE_PERIGO
    CALL rand15     ; gera numero aleatória 1-15

   
inicia_ast_esq:         ; asteroide a esquerda
    CMP R9, 0       ;
    JZ inicia_ast_cent_dir
    CALL cria_asteroide_esq

inicia_ast_cent_dir:    ; movimento a direita
    CMP R9, 1
    JZ inicia_ast_cent_cent
    CALL cria_asteroide_cent_dir

inicia_ast_cent_cent:   ; movimento no verticalmente
    CMP R9, 2
    JZ inicia_ast_cent_esq
    CALL cria_asteroide_cent_cent

inicia_ast_cent_esq:    ; movemento a esquerda
    CMP R9, 3
    JZ inicia_ast_dir
    CALL cria_asteroide_cent_esq

inicia_ast_dir:         ; asteroide a esquerda
    CMP R9, 4
    JZ sai_inicia_asteroides
    CALL cria_asteroide_dir

sai_inicia_asteroides:
    POP R4
    POP R9
    POP R0
    

; **********************************************************************
; GERA_TIPO_ASTEROIDE - escolha aleatoriamente a tabela para desenhar o asteroide
; Retorna:  R4 - tabela de asteroide a desenhar
; **********************************************************************

gera_tipo_asteroide:
    PUSH    R0
    PUSH    R1
    MOV R0, MASCARA_GERADOR_ALEATORIO
    MOV R1, [TEC_COL]   ; ler o PIN
    AND R1, R0  ;   isolar 4 bits aleatórios
    SHR R1, 6   ;   isolar e colocar 2 bits à direita (numero aleatório 0-3)
    JZ gera_recursos
    MOV R4, ASTEROIDE_PERIGO
    JMP sai_gera_tipo_asteroide

gera_recursos:
    MOV R4, ASTEROIDE_COM_RECURSOS

sai_gera_tipo_asteroide:
    POP    R1
    POP    R0
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
    MOV R8, 9   ;   para comparar o numero
    CMP R9, R8
    JLE asteroide_cent
    MOV R8, 12  ;
    CMP R9, R8
    JLE asteroide_esq
    CALL cria_asteroide_dir
    JMP sai_gera_asteroide

asteroide_esq:
    CALL cria_asteroide_esq
    JMP sai_gera_asteroide

asteroide_cent:
    MOV R2, COLUNA_CENT
    SUB R2, 2
    MOV R8, 3   ;   divisor
    MOD R9, R8   ;   obtem numero 0-2
    SUB R9, 1  ;   obtem direcao x da forma -1, 0 ou 1
    MOV R5, R9  ;   retornar valor da direcao x
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
    PUSH    R0
rand15_ciclo:   ;para verificar que o número não seja 0
    MOV R0, MASCARA_GERADOR_ALEATORIO
    MOV R9, [TEC_COL]   ; ler o PIN
    AND R9, R0  ;   isolar 4 bits aleatórios

    JZ rand15_ciclo ; se o número for 0 repete
    SHR R9, 4   ;   colocar o 4 bits à direita (numero aleatório 1-15)
    MOV R0, 5   ; divisor
    MOD R9, R0  ; número aleatória 0-4

    POP     R0
    RET

; **********************************************************************
; CRIA_ASTEROIDE_ESQ - cria um asteroide a esquerda
;
; **********************************************************************

cria_asteroide_esq:
    PUSH    R2
    PUSH    R5
    MOV R2, COLUNA_ESQ
    MOV R5, 1
    CALL asteroide
    POP    R5
    POP    R2
    RET

; **********************************************************************
; CRIA_ASTEROIDE_DIR - cria um asteroide a direita
;
; **********************************************************************

cria_asteroide_dir:
    PUSH    R2
    PUSH    R5
    MOV R2, COLUNA_DIR - 4
    MOV R5, -1
    CALL asteroide
    POP    R5
    POP    R2
    RET

; **********************************************************************
; CRIA_ASTEROIDE_CENT_ESQ - cria um asteroide no centro com movimento a esquerda
;
; **********************************************************************

cria_asteroide_cent_esq:
    PUSH    R2
    PUSH    R5
    MOV R2, COLUNA_CENT - 2
    MOV R5, -1
    CALL asteroide
    POP    R5
    POP    R2
    RET

; **********************************************************************
; CRIA_ASTEROIDE_CENT_CENT - cria um asteroide no centro com movimento na vertical
;
; **********************************************************************

cria_asteroide_cent_cent:
    PUSH    R2
    PUSH    R5
    MOV R2, COLUNA_CENT - 2
    MOV R5, 0
    CALL asteroide
    POP    R5
    POP    R2
    RET

; **********************************************************************
; CRIA_ASTEROIDE_CENT_DIR - cria um asteroide no centro com movimento a direita
;
; **********************************************************************

cria_asteroide_cent_dir:
    PUSH    R2
    PUSH    R5
    MOV R2, COLUNA_CENT - 2
    MOV R5, 1
    CALL asteroide
    POP    R5
    POP    R2
    RET

; **********************************************************************
; ROT_INT_0 - 	Rotina de atendimento da interrupção 0
; **********************************************************************
rot_int_0:
	MOV	[evento_asteroide], R0	; desbloqueia processo asteroide
	RFE

; **********************************************************************
; ROT_INT_1 - 	Rotina de atendimento da interrupção 1
; **********************************************************************
rot_int_1:
    PUSH    R0
    MOV R0, 3
	MOV	[evento_sonda], R0	; desbloqueia processo asteroide
    POP     R0
	RFE

; **********************************************************************
; ROT_INT_2 - 	Rotina de atendimento da interrupção 2
;           Trata do gasto da energia ao longo do tempo
; **********************************************************************
rot_int_2:
    PUSH R0
    PUSH R1
    PUSH R5
    MOV R1, evento_display
    MOV R0, -3
    MOV [R1], R0
    POP R5
    POP R1
    POP R0
	RFE

; **********************************************************************
; ROT_INT_3 - 	Rotina de atendimento da interrupção 3
; **********************************************************************
rot_int_3:
	MOV	[evento_painel], R0	; desbloqueia processo painel
	RFE
