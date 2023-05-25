; *********************************************************************
; * IST-UL
; * Modulo:    grupo32.asm
; * Descrição: Projeto Intermédia do grupo 32
; *
; *********************************************************************

; **********************************************************************
; * Constantes
; **********************************************************************
DISPLAYS            EQU 0A000H   ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN             EQU 0C000H   ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL             EQU 0E000H   ; endereço das colunas do teclado (periférico PIN)
LINHA1              EQU 1        ; linha a testar (4ª linha, 1000b)
LINHA4              EQU 8
MASCARA             EQU 0FH      ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
TECLA_ESQUERDA      EQU 1        ; tecla na primeira coluna do teclado (tecla C)
TECLA_DIREITA       EQU 2        ; tecla na segunda coluna do teclado (tecla D)

COMANDOS            EQU 6000H   ; endereço de base dos comandos do MediaCenter

DEFINE_LINHA        EQU COMANDOS + 0AH    ; endereço do comando para definir a linha
DEFINE_COLUNA       EQU COMANDOS + 0CH    ; endereço do comando para definir a coluna
DEFINE_PIXEL        EQU COMANDOS + 12H    ; endereço do comando para escrever um pixel
APAGA_AVISO         EQU COMANDOS + 40H    ; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ          EQU COMANDOS + 02H    ; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO     EQU COMANDOS + 42H    ; endereço do comando para selecionar uma imagem de fundo
TOCA_SOM            EQU COMANDOS + 5AH    ; endereço do comando para tocar um som

LINHA_TOPO          EQU 0        ; linha do topo do ecrã
COLUNA_ESQ          EQU 0        ; coluna mais à esquerda
COLUNA_CENT         EQU 32       ; coluna central
COLUNA_DIR          EQU 63       ; coluna mais à direita

LINHA_PAINEL        EQU 27       ; linha do painel da nave
COLUNA_PAINEL       EQU 25       ; coluna do painel da nave

LARGURA_AST         EQU 5        ; largura do asteroide
ALTURA_AST          EQU 5        ; altura do asteroide

LARGURA_PAINEL      EQU 15       ; largura do painel da nave
ALTURA_PAINEL       EQU 5        ; altura do painel da nave

LARGURA_SONDA       EQU 1        ; largura das sondas
ALTURA_SONDA        EQU 1        ; altura das sondas

PIXEL_VERM          EQU 0FF00H   ; pixel vermelho opaco
PIXEL_VERM_TRANS    EQU 0FF00H   ; pixel vermelho translucido
PIXEL_VERDE         EQU 0FF0000H ; pixel verde opaco
PIXEL_VERDE_TRANS   EQU 0FF0000H ; pixel verde translucido
PIXEL_AZUL          EQU 0FFH     ; pixel azul opaco
PIXEL_VIOLETA       EQU 0FA3CH  ; pixel violeta opaco 
PIXEL_AMAR          EQU 0FFF0H  ; pixel opaco amarelo
PIXEL_CAST          EQU 0F850H  ; pixel opaco castanho
PIXEL_AMAR_TRANS    EQU 05FF0H  ; pixel amarelo translucido 
PIXEL_CINZ_ESC      EQU 0F777H  ; pixel cinzento escuro opaco 
PIXEL_CINZ_CLA      EQU 0FFFFH  ; pixel cinzento claro opaco 

ATRASO_SONDA		EQU	9000H
; *********************************************************************************
; * Dados 
; *********************************************************************************
	PLACE       1000H
pilha:
	STACK 100H			; espaço reservado para a pilha 
						; (200H bytes, pois são 100H words)
SP_inicial:				; este é o endereço (1200H) com que o SP deve ser 
						; inicializado. O 1.º end. de retorno será 
						; armazenado em 11FEH (1200H-2)
							
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

SONDA:                  ; tabela que define a sonda (cor, pixels)
	WORD 		LARGURA_SONDA
	WORD		ALTURA_SONDA
    WORD        PIXEL_CAST 

posicao_asteroide:		; posição do asteroide
	WORD LINHA_TOPO
	WORD COLUNA_ESQ

valor_display:          ; valor para escrever no display
    WORD 0              ;

; *********************************************************************************
; * Código
; *********************************************************************************
PLACE      0
inicio:		
; inicializações
    MOV  SP, SP_inicial		; inicializa SP para a palavra a seguir
                    ; à última da pilha
                            
    MOV  [APAGA_AVISO], R1	; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1	; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
    MOV	 R1, 0			; cenário de fundo número 0
    MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo
    MOV  R8, 0              ; número inicial do display

posicao_painel:
    MOV   R1, LINHA_PAINEL		; linha do painel da nave
    MOV   R2, COLUNA_PAINEL		; coluna do painel da nave
	MOV	  R4, PAINEL_NAVE		; endereço da tabela que define o painel da nave

mostra_painel:
	CALL	desenha_objeto	; desenha o objeto a partir da tabela

tipo_asteroide:
    MOV	 R4, ASTEROIDE_PERIGO		    ; endereço da tabela que define o asteroide

posição_asteroide:
    MOV R1, [posicao_asteroide]	; le valor da linha do asteroide
	MOV R2, [posicao_asteroide + 2] ; le valor da coluna do asteroide (+2 porque a linha é um WORD)

mostra_asteroide:
	CALL	desenha_objeto	; desenha o objeto a partir da tabela


CALL escreve_display    ; inicia o valor no 0
ciclo:
    MOV  R7, LINHA1         ; testar a linha 1
    
    CALL espera_tecla

exec_tecla:                 ; executa instrucoes de acordo com a tecla premida
    CALL calcula_tecla      ; calcula o valor da tecla premida
    CMP  R6, 5              ; a tecla premida foi 5?
    JZ decr_display      ; se for 5, decrementa valor no display
    CMP  R6, 6              ; a tecla premida foi 6?
    JZ incr_display         ; se for 6, incrementa valor no display
	CMP	 R6, 1				; a tecla premida foi 1?
	JZ disparo_vertical		; se for 1 dispara a sonda
    CMP  R6, 0              ; a tecla premida foi 0?
    JZ deslocamento_asteroide; se for 0, move o objeto
    JMP espera_nao_tecla    ; espera até a tecla estar libertada

decr_display:               ; decrementa o valor no display
    MOV  R1, -1             ; decrementa o valor para ser escrito no display
    CALL shift_display      ;
    JMP  espera_nao_tecla    ; espera até a tecla estar libertada
    
incr_display:               ; incrementa o valor no display
    MOV  R1, 1              ; incrementa o valor para ser escrito no display
    CALL  shift_display
    JMP   espera_nao_tecla  ; espera até a tecla estar libertada

disparo_vertical:
    CALL dispara_sonda;
    JMP espera_nao_tecla    ;

deslocamento_asteroide:
    CALL move_asteroide
    JMP espera_nao_tecla    ;

espera_nao_tecla:           ; espera-se até a tecla estar libertada
    CALL espera_libertar_tecla   ;
    JMP  ciclo              ; repete ciclo

; **********************************************************************
; MOVE_ASTEROIDE - Desenha o painel da nave na linha e coluna indicadas
;			       com a forma e cor definidas na tabela indicada.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R4 - tabela que define o boneco
; **********************************************************************

move_asteroide:
    PUSH  R1
	PUSH  R2
    PUSH  R9
    MOV   R1, [posicao_asteroide]	  ; para desenhar objeto na linha seguinte
	MOV   R2, [posicao_asteroide + 2] ; para desenhar objeto na coluna seguinte
	CALL  apaga_objeto		          ; apaga o objeto na sua posição corrente
	INC   R1			              ; para desenhar objeto na linha seguinte
	INC   R2			              ; para desenhar objeto na coluna seguinte
    MOV   [posicao_asteroide], R1	  ; para desenhar objeto na linha seguinte
	MOV   [posicao_asteroide + 2], R2 ; para desenhar objeto na coluna seguinte
    CALL  desenha_objeto		      ; vai desenhar o objeto de novo
    MOV   R9, 0
    MOV   [TOCA_SOM], R9              ; seleciona o cenário de fundo
    JMP   espera_nao_tecla            ; espera até a tecla ser libertada
    POP   R9
    POP	  R2
    POP   R1
    RET
	
; **********************************************************************
; disparo_vertical - Desenha e move a sonda começando na linha e coluna indicadas
;			       com a forma e cor definidas na tabela indicada.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R4 - tabela que define a sonda
; **********************************************************************

dispara_sonda:
	PUSH R1
	PUSH R2
	PUSH R4
	MOV R1,26				;linha inicial da sonda a ser disparada para a frente
	MOV R2,32				;coluna inicial da sonda a ser disparada para a frente
	MOV R4,SONDA
	MOV R9,12				;contador de quadradinhos que a sonda atravessa 
move_sonda:
	CALL desenha_objeto		;desenha a sonda
	
	MOV	R10, ATRASO_SONDA	; atraso para limitar a velocidade de movimento da sonda		
ciclo_atraso_sonda:
	SUB	R10, 1
	JNZ	ciclo_atraso_sonda
	
	CALL  apaga_objeto		;apaga a sonda atual
	SUB	R1, 1				; para desenhar objeto na coluna seguinte (direita ou esquerda)
	SUB R9, 1				;para diminuir o contador de quadradinhos que a sonda atravessou
	CMP R9, 0				;verifica se a sonda já percorreu 12 quadradinhos
	JNE	move_sonda			; vai desenhar a sonda de novo
	POP R4
	POP R2
	POP R1
	RET
	
; **********************************************************************
; DESENHA_OBJETO - Desenha o painel da nave na linha e coluna indicadas
;			       com a forma e cor definidas na tabela indicada.
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
	MOV   R5, [R4]			; obtém a largura do objeto
    MOV   R7, R5            ; guarda a altura do objeto
    MOV   R8, R2            ; guarda a coluna inicial do painel  
	ADD	  R4, 2			    ; endereço da altura do objeto
    MOV   R6, [R4]          ; obtém a altura do objeto
    ADD	  R4, 2			    ; endereço da cor do 1º pixel

desenha_pixels:       		; desenha os pixels do objeto a partir da tabela
	MOV	 R3, [R4]			; obtém a cor do próximo pixel do objeto
	CALL escreve_pixel		; escreve cada pixel do objeto
	ADD	 R4, 2			    ; endereço da cor do próximo pixel 
    ADD  R2, 1              ; próxima coluna
    SUB  R5, 1			    ; menos uma coluna para tratar
    JNZ  desenha_pixels     ; continua até percorrer toda a largura do objeto
    MOV  R5, R7
    MOV  R2, R8
    ADD  R1, 1
    SUB  R6, 1              ; verifica se todas as linhas já foram desenhadas
    JNZ  desenha_pixels     ; continua até percorrer toda a altura do objeto
    POP  R8
    POP  R7
    POP  R6
    POP	 R5
	POP	 R4
	POP	 R3
	POP	 R2
    POP  R1
	RET


; **********************************************************************
; ESCREVE_PIXEL - Escreve um pixel na linha e coluna indicadas.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R3 - cor do pixel (em formato ARGB de 16 bits)
;
; **********************************************************************
escreve_pixel:
	MOV  [DEFINE_LINHA],  R1	; seleciona a linha
	MOV  [DEFINE_COLUNA], R2	; seleciona a coluna
	MOV  [DEFINE_PIXEL],  R3	; altera a cor do pixel na linha e coluna já selecionadas
	RET

; **********************************************************************
; APAGA_objeto - Apaga um objeto na linha e coluna indicadas
;			  com a forma definida na tabela indicada.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R4 - tabela que define o objeto
;
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
	MOV   R5, [R4]			; obtém a largura do objeto
    MOV   R7, R5            ; guarda a altura do objeto
    MOV   R8, R2            ; guarda a coluna inicial do painel  
	ADD	  R4, 2			    ; endereço da altura do objeto
    MOV   R6, [R4]          ; obtém a altura do objeto
    ADD	  R4, 2			    ; endereço da cor do 1º pixel

apaga_pixels:       		; desenha os pixels do objeto a partir da tabela
	MOV	  R3, 0			    ; cor para apagar o próximo pixel do objeto
	CALL  escreve_pixel		; escreve cada pixel do objeto
	ADD	  R4, 2			    ; endereço da cor do próximo pixel 
    ADD   R2, 1             ; próxima coluna
    SUB   R5, 1			    ; menos uma coluna para tratar
    JNZ   apaga_pixels    ; continua até percorrer toda a largura do objeto
    MOV   R5, R7
    MOV   R2, R8
    ADD   R1, 1
    SUB   R6, 1             ; verifica se todas as linhas já foram desenhadas
    JNZ   apaga_pixels    ; continua até percorrer toda a altura do objeto
    POP   R8
    POP   R7
    POP   R6
    POP	  R5
	POP	  R4
	POP	  R3
	POP	  R2
    POP   R1
	RET

; **********************************************************************
; ESPERA_TECLA - Espera até uma tecla seja premida e lê a coluna e linha
;
; Retorna: 	R7 - linha da tecla premida
;           R0 - coluna da tecla premida
;
; **********************************************************************
espera_tecla:               ; neste ciclo espera-se até uma tecla ser premida
    MOV  R7, LINHA1         ; testar a linha 1
varre_linhas:
    CALL escreve_linha      ; ativar linha no teclado
    CALL le_coluna          ; leitura na linha ativada do teclado
    CMP  R0, 0              ; há tecla premida?
    JNZ sai_espera_tecla    ;
    CMP R7, 5               ; chegou à última linha?
    JGE espera_tecla        ;
    SHL R7, 1               ; testar a próxima linha
    JMP varre_linhas        ; continua o ciclo na próxima linha

sai_espera_tecla:
    RET

; **********************************************************************
; ESCREVE_LINHA - Faz uma leitura às teclas de uma linha do teclado e retorna o valor lido
; Argumentos:	R7 - linha a testar (em formato 1, 2, 4 ou 8)
;
; **********************************************************************
escreve_linha:
	PUSH	R2
	MOV  R2, TEC_LIN   ; endereço do periférico das linhas
	MOVB [R2], R7      ; escrever no periférico de saída (linhas)
    POP R2
    RET

; **********************************************************************
; LE_COLUNA - Faz uma leitura às teclas de uma linha do teclado e retorna o valor lido
;
; Retorna: 	R0 - valor lido das colunas do teclado (0, 1, 2, 4, ou 8)	
; **********************************************************************

le_coluna:
	PUSH	R3
	PUSH	R5
	MOV  R3, TEC_COL   ; endereço do periférico das colunas
	MOV  R5, MASCARA   ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
	MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
	AND  R0, R5        ; elimina bits para além dos bits 0-3
	POP	R5
	POP	R3
	RET

; **********************************************************************
; CALCULA_TECLA - calcula o valor da tecla premida
; Argumentos:	R7 - linha/coluna da tecla (em formato 1, 2, 4 ou 8)
;
; Retorna: 	R6 - total: valor inicial + numero de linhas/colunas
; **********************************************************************

calcula_tecla:              ; calcula o valor da tecla
    PUSH R7
    MOV  R6, 0              ; inicia valor da tecla no 0
    CALL conta_linhas_colunas
    SHL R6, 2               ; linhas * 4
    MOV R7, R0              ; conta as colunas
    CALL conta_linhas_colunas
    POP R7
    RET

; **********************************************************************
; CONTA_LINHAS_COLUNAS - calcula o valor da tecla premida
; Argumentos:	R7 - linha/coluna da tecla (em formato 1, 2, 4 ou 8)
;               R6 - valor inicial
;
; Retorna: 	R6 - total: valor inicial + numero de linhas/colunas
; **********************************************************************

conta_linhas_colunas:
    PUSH    R7

calc_val_lin_col:      ; neste ciclo calcula-se o valor da linha/coluna
    SHR  R7, 1         ; desloca à direita 1 bit
    CMP  R7, 0         ; a quantidade das linhas/colunas ja foi contada?
    JZ   sai_conta_linhas_colunas; se ja for contada, salta
    INC  R6        ; incrementa o valor calculada
    JMP  calc_val_lin_col; repete ciclo

sai_conta_linhas_colunas:
    POP R7
    RET

; **********************************************************************
; shift_display - adicione ao valor no display
; Argumentos:   R8 - valor escrito no display
;               R1 - valor a adicionar ao display
;
; **********************************************************************

shift_display:
    PUSH R1
    PUSH R8
    MOV R8, [valor_display]
    ADD R8, R1
    MOV [valor_display], R8
    CALL escreve_display
    POP R8
    POP R1
    RET

; **********************************************************************
; ESCREVE_DISPLAY - escreve um valor no display
; Argumentos:   R8 - valor a escrever no display
;
; **********************************************************************

escreve_display:
    PUSH    R4
    PUSH    R0
    MOV  R4, DISPLAYS  ; endereço do periférico dos displays
    MOV  R0, [valor_display]  ;
    MOV [R4], R0; escrever o valor no display
    POP R0
    POP R4
    RET

; **********************************************************************
; espera_nao_tecla - escreve um valor no display
; Argumentos:   R8 - valor a escrever no display
;
; **********************************************************************

espera_libertar_tecla:           ; neste ciclo espera-se até a tecla estar libertada
    PUSH R0
    tecla_premida:          ;
    CALL le_coluna          ; leitura na linha ativada do teclado
    CMP  R0, 0              ; há tecla premida?
    JNZ  tecla_premida   ; se a tecla ainda for premida, espera até não haver
    POP R0
    RET