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

COMANDOS				EQU	6000H			; endereço de base dos comandos do MediaCenter

DEFINE_LINHA    		    EQU COMANDOS + 0AH		; endereço do comando para definir a linha
DEFINE_COLUNA   		    EQU COMANDOS + 0CH		; endereço do comando para definir a coluna
DEFINE_PIXEL    		    EQU COMANDOS + 12H		; endereço do comando para escrever um pixel
APAGA_AVISO     		    EQU COMANDOS + 40H		; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	 		        EQU COMANDOS + 02H		; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO     EQU COMANDOS + 42H		; endereço do comando para selecionar uma imagem de fundo
TOCA_SOM				    EQU COMANDOS + 5AH		; endereço do comando para tocar um som

LINHA_TOPO        	EQU 0       ; linha do topo do ecrã
COLUNA_ESQ			EQU 0       ; coluna mais à esquerda
COLUNA_CENT         EQU 32      ; coluna central
COLUNA_DIR          EQU 63      ; coluna mais à direita

LINHA_PAINEL        EQU 27      ; linha do painel da nave
COLUNA_PAINEL       EQU 27      ; coluna do painel da nave

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


; *********************************************************************************
; * Dados 
; *********************************************************************************
	PLACE       1000H

; Reserva do espaço para as pilhas dos processos
	STACK TAMANHO_PILHA		; espaço reservado para a pilha do processo "programa principal"
SP_inicial_prog_princ:		; este é o endereço com que o SP deste processo deve ser inicializado
							
	STACK TAMANHO_PILHA		; espaço reservado para a pilha do processo "teclado"
SP_inicial_energia:			; este é o endereço com que o SP deste processo deve ser inicializado
							
	STACK TAMANHO_PILHA * N_BONECOS	; espaço reservado para as pilhas de todos os processos "boneco"
SP_inicial_boneco:					; este é o endereço incial do SP com que o processo "boneco" deve ser declarado no PROCESS,
								; mas cada instância deve depois reinicializar o SP (cada uma com o seu bloco de TAMANHO_PILHA palavras)

							
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
    WORD        PIXEL_CAST 

; *********************************************************************************
; * Código
; *********************************************************************************
PLACE      0
inicio:	    


; **********************************************************************
; Processo
;
; ENERGIA - Processo que deteta quando se carrega numa tecla na 4ª linha
;		  do teclado e escreve o valor da coluna num LOCK.
;
; **********************************************************************

PROCESS SP_inicial_energia	; indicação de que a rotina que se segue é um processo,
						; com indicação do valor para inicializar o SP

energia:
    RET