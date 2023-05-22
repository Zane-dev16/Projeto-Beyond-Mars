; *********************************************************************
; * IST-UL
; * Modulo:    grupo32.asm
; * Descrição: Projeto Intermédia do grupo 32
; *
; *********************************************************************

; **********************************************************************
; * Constantes
; **********************************************************************
DISPLAYS   EQU 0A000H  ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN    EQU 0C000H  ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL    EQU 0E000H  ; endereço das colunas do teclado (periférico PIN)
LINHA1      EQU 1       ; linha a testar (4ª linha, 1000b)
LINHA4      EQU 8;
MASCARA    EQU 0FH     ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
TECLA_ESQUERDA			EQU 1		; tecla na primeira coluna do teclado (tecla C)
TECLA_DIREITA			EQU 2		; tecla na segunda coluna do teclado (tecla D)

COMANDOS				EQU	6000H			; endereço de base dos comandos do MediaCenter

DEFINE_LINHA    		EQU COMANDOS + 0AH		; endereço do comando para definir a linha
DEFINE_COLUNA   		EQU COMANDOS + 0CH		; endereço do comando para definir a coluna
DEFINE_PIXEL    		EQU COMANDOS + 12H		; endereço do comando para escrever um pixel
APAGA_AVISO     		EQU COMANDOS + 40H		; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	 		EQU COMANDOS + 02H		; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO  EQU COMANDOS + 42H		; endereço do comando para selecionar uma imagem de fundo
TOCA_SOM				EQU COMANDOS + 5AH		; endereço do comando para tocar um som

LINHA        		EQU  16        ; linha do boneco (a meio do ecrã))
COLUNA			EQU  30        ; coluna do boneco (a meio do ecrã)

MIN_COLUNA		EQU  0		; número da coluna mais à esquerda que o objeto pode ocupar
MAX_COLUNA		EQU  63        ; número da coluna mais à direita que o objeto pode ocupar
ATRASO			EQU	400H		; atraso para limitar a velocidade de movimento do boneco

LARGURA			EQU	5		; largura do boneco
COR_PIXEL			EQU	0FF00H	; cor do pixel: vermelho em ARGB (opaco e vermelho no máximo, verde e azul a 0)


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
							
DEF_BONECO:					; tabela que define o boneco (cor, largura, pixels)
	WORD		LARGURA
	WORD		COR_PIXEL, 0, COR_PIXEL, 0, COR_PIXEL		; # # #   as cores podem ser diferentes de pixel para pixel
     

; *********************************************************************************
; * Código
; *********************************************************************************
PLACE      0
inicio:		
; inicializações
    MOV  R4, DISPLAYS  ; endereço do periférico dos displays
    MOV  SP, SP_inicial		; inicializa SP para a palavra a seguir
                    ; à última da pilha
                            
    MOV  [APAGA_AVISO], R1	; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1	; apaga todos os pixels já desenhados (o valor de R1 não é relevante)

; corpo principal do programa
ciclo:
    MOV  R1, LINHA1    ; testar a linha 1

espera_tecla:          ; neste ciclo espera-se até uma tecla ser premida
    CALL escreve_linha ;
    CALL   le_coluna   ; leitura na linha ativada do teclado
    CMP  R0, 0         ; há tecla premida?
    JNZ  calcula_tecla ; se houver uma tecla premida, salta
    CMP R1, 5          ; chegou à última linha?
    JGE ciclo          ; se chegou à última linha, repete ciclo
    SHL R1, 1          ; testar a próxima linha
    JMP espera_tecla   ; continua o ciclo na próxima linha
    
calcula_tecla:         ; calcula o valor da tecla
    MOV  R6, 0         ; inicia valor da tecla no 0

calc_val_lin_col:      ; neste ciclo calcula-se o valor da linha/coluna
    SHR  R1, 1         ; desloca à direita 1 bit
    CMP  R1, 0         ; o valor da linha/coluna ja foi calculada?
    JZ   lin_col_avaliada; se ja for calculada, salta
    INC  R6        ; incrementa o valor calculada
    JMP  calc_val_lin_col; repete ciclo

lin_col_avaliada:      ; passo seguinte depois da cálculo da linha/coluna
    CMP  R0, 0         ; foi avaliada a linha e coluna?
    JZ  exec_tecla     ; se for ambas avaliadas, salta
    SHL  R6, 2         ; linha*4
    MOV  R1, R0        ; configure para o cálculo da coluna
    MOV  R0, 0         ; apaga o valor da coluna
    JMP  calc_val_lin_col; calcula o valor da coluna

exec_tecla:            ; executa instrucoes de acordo com a tecla premida
    CMP  R6, 5         ; a tecla premida foi 5?
    JZ decr_display    ; se for 5, decrementa valor no display
    CMP  R6, 6         ; a tecla premida foi 6?
    JZ incr_display    ; se for 6, incrementa valor no display
    JMP espera_nao_tecla; espera até a tecla ser libertada

decr_display:          ; decrementa o valor no display
    DEC  R8            ; decrementa o valor para ser escrito no display
    MOV [R4], R8      ; escrever o valor no display
    JMP espera_nao_tecla; espera até a tecla ser libertada
    
incr_display:          ; incrementa o valor no display
    INC   R8           ; incrementa o valor para ser escrito no display
    MOV [R4], R8       ; escrever o valor no display
    JMP espera_nao_tecla; espera até a tecla ser libertada


espera_nao_tecla:      ; neste ciclo espera-se até a tecla estar libertada
    CALL le_coluna     f; leitura na linha ativada do teclado
    CMP  R0, 0         ; há tecla premida?
    JNZ  espera_nao_tecla; se a tecla ainda for premida, espera até não haver
    JMP  ciclo         ; repete ciclo


; **********************************************************************
; ESCREVE_LINHA - Faz uma leitura às teclas de uma linha do teclado e retorna o valor lido
; Argumentos:	R1 - linha a testar (em formato 1, 2, 4 ou 8)
;
; **********************************************************************

escreve_linha:
	PUSH	R2
	MOV  R2, TEC_LIN   ; endereço do periférico das linhas
	MOVB [R2], R1      ; escrever no periférico de saída (linhas)
    POP R2

; **********************************************************************
; LE_COLUNA - Faz uma leitura às teclas de uma linha do teclado e retorna o valor lido
; Argumentos:	R1 - linha a testar (em formato 1, 2, 4 ou 8)
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


