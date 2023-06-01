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
LINHA1              EQU 1       ; linha a testar (4ª linha, 1000b)
LINHA4              EQU 8;
MASCARA             EQU 0FH     ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
TECLA_ESQUERDA		EQU 1		; tecla na primeira coluna do teclado (tecla C)
TECLA_DIREITA		EQU 2		; tecla na segunda coluna do teclado (tecla D)
INICIO_ENERGIA      EQU 100     ;
FATOR_INICIAL       EQU 1000    ;

COMANDOS				EQU	6000H			; endereço de base dos comandos do MediaCenter

DEFINE_LINHA    		    EQU COMANDOS + 0AH		; endereço do comando para definir a linha
DEFINE_COLUNA   		    EQU COMANDOS + 0CH		; endereço do comando para definir a coluna
DEFINE_PIXEL    		    EQU COMANDOS + 12H		; endereço do comando para escrever um pixel
APAGA_AVISO     		    EQU COMANDOS + 40H		; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRA	 		        EQU COMANDOS + 02H		; endereço do comando para apagar todos os pixels já desenhados
FUNDO_ECRA                  EQU COMANDOS + 42H		; endereço do comando para selecionar uma imagem de fundo
TOCA_SOM				    EQU COMANDOS + 5AH		; endereço do comando para tocar um som
IMAGEM_FRONTAL              EQU COMANDOS + 46H      ; endereço do comando para sobrepor uma imagem à imagem de fundo

FUNDO_INICIAL      EQU 0
FUNDO_JOGO         EQU 1
FUNDO_EXPLOSAO     EQU 4
FUNDO_ENERGIA      EQU 3

IMAGEM_INICIAR     EQU 2
IMAGEM_PAUSA       EQU 5
IMAGEM_EXPLOSAO    EQU 6
IMAGEM_SEM_ENERGIA EQU 7

SOM_INICIO         EQU 0
SOM_DISPARO        EQU 1
SOM_AST_DESTRUIDO  EQU 2
SOM_AST_MINERADO   EQU 3
SOM_EXPLOSAO       EQU 4
SOM_SEM_ENERGIA    EQU 5

LINHA_TOPO        	EQU 0       ; linha do topo do ecrã
COLUNA_ESQ			EQU 0       ; coluna mais à esquerda
COLUNA_CENT         EQU 32      ; coluna central
COLUNA_DIR          EQU 63      ; coluna mais à direita

LINHA_PAINEL        EQU 27      ; linha do painel da nave
COLUNA_PAINEL       EQU 27      ; coluna do painel da nave

LINHA_CIMA_PAINEL	EQU 26		 ; linha acima do painel

LARGURA_SONDA       EQU 1        ; largura das sondas
ALTURA_SONDA        EQU 1        ; altura das sondas

LARGURA_AST			EQU	5		; largura do asteroide
ALTURA_AST          EQU 5       ; altura do asteroide 

LARGURA_PAINEL      EQU 15      ; largura do painel da nave
ALTURA_PAINEL       EQU 5       ; altura do painel da nave

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

TAMANHO_PILHA		EQU  100H      ; tamanho de cada pilha, em words

; *********************************************************************************
; * Dados 
; *********************************************************************************
	PLACE       1000H

; Reserva do espaço para as pilhas dos processos
	STACK TAMANHO_PILHA		; espaço reservado para a pilha do processo "programa principal"
SP_inicial_prog_princ:		; este é o endereço com que o SP deste processo deve ser inicializado
							
	STACK TAMANHO_PILHA		; espaço reservado para a pilha do processo "teclado"
SP_inicial_painel:			; este é o endereço com que o SP deste processo deve ser inicializado
		
	STACK TAMANHO_PILHA		; espaço reservado para a pilha do processo "teclado"
SP_inicial_sonda:			; este é o endereço com que o SP deste processo deve ser inicializado

	STACK TAMANHO_PILHA		; espaço reservado para a pilha do processo "teclado"
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

SONDA:                   ; tabela que define a sonda (cor, pixels)
    WORD    LARGURA_SONDA
    WORD    ALTURA_SONDA
    WORD    PIXEL_CAST

posicao_asteroide:       ; posição do asteroide
    WORD    LINHA_TOPO
    WORD    COLUNA_ESQ

; Tabela das rotinas de interrupção
tab:
	WORD rot_int_0			; rotina de atendimento da interrupção 0
	WORD rot_int_1			; rotina de atendimento da interrupção 1
	WORD rot_int_2			; rotina de atendimento da interrupção 2
	WORD rot_int_3			; rotina de atendimento da interrupção 3

evento_sonda:			; LOCK que controla a temporização do movimento da sonda
	LOCK 0				; LOCK para a rotina de interrupção 0

evento_asteroide:		; LOCKs que controla a temporização do movimento do asteroide
	LOCK 0				; LOCK para a rotina de interrupção 0

evento_display:			; LOCK que controla a temporização do display
	LOCK 0				; LOCK para a rotina de interrupção 0

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
    MOV [estado_jogo], R1           ; jogo ainda não iniciado
    MOV [FUNDO_ECRA], R1         ; coloca imagem de fundo incial
    MOV R1, IMAGEM_INICIAR
    MOV [IMAGEM_FRONTAL], R1    ; sobrepõe letras sobre a imagem inicial

    EI0                 ; permite interrupções 0
    EI1                 ; permite interrupções 1
    EI2                 ; permite interrupções 2
    EI3                 ; permite interrupções 3
	EI					; permite interrupções (geral)

	; cria processos.

    CALL teclado

obtem_tecla:	
	MOV	R1, [coluna_carregada]	; bloqueia neste LOCK a coluna carregada
    MOV R2, [linha_carregada]   ; bloqueia neste LOCK a linha carregada
    CMP R2, LINHA1              ; verifica se foi premida uma tecla da 1ª linha
    JZ linha1
    CMP R2, LINHA4              ; verifica se foi premida uma tecla da 4ª linha
    JZ linha4
    JMP obtem_tecla             ; se a tecla premida não foi da linha 1 oou 4 ignora a tecla

linha1:
    MOV R3, [estado_jogo]       
    CMP R3, FUNDO_INICIAL       ; verifica se o jogo já foi iniciado
    JZ obtem_tecla              ; caso ainda nao tenha sido iniciado ignora a tecla
    CMP R1, 1                   ; verifica se a tecla premida foi o 0
    ;JZ sonda_esq
    CMP R1, 2                   ; verifica se a tecla premida foi o 1
    ;JZ sonda_centro
    CMP R1, 3                   ; verifica se a tecla premida foi o 2
    ;JZ sonda_dir
    JMP obtem_tecla             ; se a tecla premida não foi nenhuma das anteriores ignora a tecla

linha4:
    CMP R1, 1                   ; verifica se a tecla premida foi o C
    JZ inicia_jogo
    CMP R1, 2                   ; verifica se a tecla premida foi o D
    ;JZ suspende_continua
    CMP R1, 3                   ; verifica se a tecla premida foi o E
    ;JZ termina
    JMP obtem_tecla             ; se a tecla premida não foi nenhuma das anteriores ignora a tecla

inicia_jogo:
    MOV R3, [estado_jogo]
    CMP R3, FUNDO_INICIAL       ; verifica se o jogo já foi iniciado
    JZ obtem_tecla              ; caso ainda já tenha sido iniciado ignora a tecla
    MOV R1, FUNDO_JOGO
    MOV [estado_jogo], R1       ; atualiza estado do jogo
    MOV [FUNDO_ECRA], R1         ; coloca imagem de fundo para durante o jogo
    CALL painel
    CALL asteroide
    CALL sonda
energia:
    MOV R8, INICIO_ENERGIA

atualiza_display:
    CALL escreve_display
    MOV R0, [evento_display]
    ADD R8, R0
    JMP atualiza_display
; **********************************************************************
; Processo
;
; TECLADO - Processo que deteta quando se carrega numa tecla na 4ª linha
;		  do teclado e escreve o valor da coluna num LOCK.
;
; **********************************************************************

PROCESS SP_inicial_teclado	; Processo com valor para inicializar o SP

teclado:					; processo que implementa o comportamento do teclado
	MOV  R2, TEC_LIN		; endereço do periférico das linhas
	MOV  R3, TEC_COL		; endereço do periférico das colunas
	MOV  R5, MASCARA		; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

espera_tecla:				; neste ciclo espera-se até uma tecla ser premida

	YIELD				    ; este ciclo é potencialmente bloqueante, pelo que tem de
						    ; ter um ponto de fuga (aqui pode comutar para outro processo)

	MOV  R1, LINHA1	        ; testar a linha 4

varre_linhas:
	MOVB [R2], R1			; escrever no periférico de saída (linhas)
	MOVB R0, [R3]			; ler do periférico de entrada (colunas)
	AND  R0, R5			    ; elimina bits para além dos bits 0-3
	CMP  R0, 0			    ; há tecla premida?
	JNZ   ha_tecla		    ; se há tecla premida espera até não haver
    CMP R1, 5               ; verifica se é a ultima linha do teclado
    JGE espera_tecla        ; se ja tiver verificado todas as linhas reinicia
    SHL R1, 1               ; testar a próxima linha
    JMP varre_linhas        ; continua o ciclo na próxima linha

						
	MOV	[coluna_carregada], R0	; informa quem estiver bloqueado neste LOCK que uma tecla foi carregada
							; (o valor escrito é o número da coluna da tecla no teclado)

ha_tecla:					; neste ciclo espera-se até NENHUMA tecla estar premida

	YIELD				; este ciclo é potencialmente bloqueante, pelo que tem de
						; ter um ponto de fuga (aqui pode comutar para outro processo)

	MOV	[coluna_carregada], R0	; guarda a coluna carregada
    MOV [linha_carregada], R1   ; guarda a linha carregada
    MOVB [R2], R1			; escrever no periférico de saída (linhas)
    MOVB R0, [R3]			; ler do periférico de entrada (colunas)
	AND  R0, R5			; elimina bits para além dos bits 0-3
    CMP  R0, 0			; há tecla premida?
    JNZ  ha_tecla			; se ainda houver uma tecla premida, espera até não haver

	JMP	espera_tecla		; esta "rotina" nunca retorna porque nunca termina
						; Se se quisesse terminar o processo, era deixar o processo chegar a um RET


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

anima_painel:
    WAIT
    RET


; **********************************************************************
; Processo
;
; SONDA - Processo que desenha uma sonda e implementa o seu comportamento
;
; **********************************************************************

PROCESS SP_inicial_sonda	;

	; desenha a sonda na sua posição inicial
sonda:
    MOV R0, 12
	MOV R1, LINHA_CIMA_PAINEL	       ; linha da sonda
	MOV R2, COLUNA_CENT	       ; le valor da coluna da sonda
	MOV R4, SONDA

ciclo_sonda:
    CALL  desenha_objeto              ; Desenha o objeto novamente na nova posição
    MOV	R3, [evento_sonda]  	; lê o LOCK e bloqueia até a interrupção escrever nele
    CALL  apaga_objeto                ; Apaga o objeto em sua posição atual
    DEC   R1                       ; volta para a linha anterior
    DEC R0  ; contador - 1
    JZ  sai_sonda   ; se o contador for 0 sai
	JMP	ciclo_sonda		;

sai_sonda:
    RET



; **********************************************************************
; Processo
;
; ASTEROIDE - Processo que desenha um asteroide implementa o seu comportamento
;
; **********************************************************************

PROCESS SP_inicial_asteroide	;

asteroide:
	
	; desenha o asteroide na sua posição inicial
    MOV R1, 0                          ;  linha do asteroide
    MOV R2, 0                          ; le valor da coluna do asteroide (+2 porque a linha é um WORD)
    MOV R4, ASTEROIDE_PERIGO           ; endereço da tabela que define o asteroide
ciclo_asteroide:
	CALL	desenha_objeto		; desenha o boneco a partir da tabela


	MOV	R3, [evento_asteroide]  	; lê o LOCK e bloqueia até a interrupção escrever nele

    CALL  apaga_objeto                    ; Apaga o objeto em sua posição atual
    INC   R1                              ; Incrementa a posição do asteroide para a próxima linha
    INC   R2                              ; Incrementa a posição do asteroide para a próxima coluna
	JMP	ciclo_asteroide		; esta "rotina" nunca retorna porque nunca termina
						; Se se quisesse terminar o processo, era deixar o processo chegar a um RET


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
; desenha_objeto - Desenha o painel da nave na linha e coluna indicadas
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
; ROT_INT_0 - 	Rotina de atendimento da interrupção 0
; **********************************************************************
rot_int_0:
	MOV	[evento_asteroide], R0	; desbloqueia processo asteroide
	RFE

; **********************************************************************
; ROT_INT_1 - 	Rotina de atendimento da interrupção 1
; **********************************************************************
rot_int_1:
	MOV	[evento_sonda], R0	; desbloqueia processo asteroide
	RFE

; **********************************************************************
; ROT_INT_2 - 	Rotina de atendimento da interrupção 2
;           Trata do gasto da energia ao longo do tempo
; **********************************************************************
rot_int_2:
    PUSH R0
    PUSH R1
    MOV R1, evento_display
    MOV R0, -3
    MOV [R1], R0
    INC R2
    POP R0
    POP R1
	RFE

; **********************************************************************
; ROT_INT_3 - 	Rotina de atendimento da interrupção 3
; **********************************************************************
rot_int_3:
	RFE
