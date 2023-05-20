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

; **********************************************************************
; * Código
; **********************************************************************
PLACE      0
inicio:		
; inicializações
    MOV  R2, TEC_LIN   ; endereço do periférico das linhas
    MOV  R3, TEC_COL   ; endereço do periférico das colunas
    MOV  R4, DISPLAYS  ; endereço do periférico dos displays
    MOV  R5, MASCARA   ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

; corpo principal do programa
ciclo:
    MOV  R1, LINHA1    ; testar a linha 1

espera_tecla:          ; neste ciclo espera-se até uma tecla ser premida
    MOVB [R2], R1      ; escrever no periférico de saída (linhas)
    MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
    AND  R0, R5        ; elimina bits para além dos bits 0-3
    CMP  R0, 0         ; há tecla premida?
    JNZ  calcula_tecla ; se houver uma tecla premida, salta
    CMP R1, 5          ; chegou à última linha?
    JGE ciclo          ; se chegou à última linha, repete ciclo
    SHL R1, 1          ; testar a próxima linha
    JMP espera_tecla   ; continua o ciclo na próxima linha
    
calcula_tecla:         ; calcula o valor da tecla
    MOV  R6, 0         ; inicia valor da tecla no 0
    MOV  R7, 1         ; configure o incremento para 1

calc_val_lin_col:      ; neste ciclo calcula-se o valor da linha/coluna
    SHR  R0, 1         ; desloca à direita 1 bit
    CMP  R0, 0         ; o valor da linha/coluna ja foi calculada?
    JZ   lin_col_avaliada; se ja for calculada, salta
    ADD  R6, R7        ; incrementa o valor calculada
    JMP  calc_val_lin_col; repete ciclo

lin_col_avaliada:      ; passo seguinte depois da cálculo da linha/coluna
    CMP  R7, 4         ; foi avaliada a linha e coluna?
    JZ  exec_tecla     ; se for ambas avaliadas, salta
    MOV  R7, 4         ; configure o incremento para 4
    MOV  R0, R1        ; configure para o cálculo da linha
    JMP  calc_val_lin_col; calcula o valor para adicionar utilizando a linha

exec_tecla:            ; executa instrucoes de acordo com a tecla premida
    CMP  R6, 5         ; a tecla premida foi 5?
    JZ decr_display    ; se for 5, decrementa valor no display
    CMP  R6, 6         ; a tecla premida foi 6?
    JZ incr_display    ; se for 6, incrementa valor no display
    JMP ha_tecla       ; espera até a tecla ser libertada

decr_display:          ; decrementa o valor no display
    DEC  R8            ; decrementa o valor para ser escrito no display
    MOVB [R4], R8      ; escrever o valor no display
    JMP ha_tecla       ; espera até a tecla ser libertada
    
incr_display:          ; incrementa o valor no display
    INC   R8           ; incrementa o valor para ser escrito no display
    MOVB [R4], R8      ; escrever o valor no display
    JMP ha_tecla       ; espera até a tecla ser libertada

ha_tecla:              ; neste ciclo espera-se até a tecla estar libertada
    MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
    AND  R0, R5        ; elimina bits para além dos bits 0-3
    CMP  R0, 0         ; há tecla premida?
    JNZ  ha_tecla      ; se a tecla ainda for premida, espera até não haver
    JMP  ciclo         ; repete ciclo
