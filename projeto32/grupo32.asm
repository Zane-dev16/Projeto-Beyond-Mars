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
    MOV  R6, 0         ;
    MOV  R1, LINHA1    ; testar a linha 1

espera_tecla:          ; neste ciclo espera-se até uma tecla ser premida
    MOVB [R2], R1      ; escrever no periférico de saída (linhas)
    MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
    AND  R0, R5        ; elimina bits para além dos bits 0-3
    CMP  R0, 0         ; há tecla premida?
    JNZ  tecla_premida ; se houver uma tecla premida, salta
    CMP R1, 5          ; chegou à última linha?
    SHL R1, 1          ; testar a próxima linha
    JMP espera_tecla   ; continua a testar a proxima linha
    
tecla_premida:         ; vai mostrar a linha e a coluna da tecla no display
    MOV  R7, 1         ;
adicione_fila:         ; neste ciclo adicione 4 vezes a linha do teclado
    SHR  R0, 1         ; desloca à direita 1 bit
    CMP  R0, 0         ; se a linha ja for avaliada
    JZ   fila_avaliada ; escreve o valor obtido nos displays
    ADD  R6, R7        ; adicione 4 ao valor a ser escrito no display
    JMP  adicione_fila ;

fila_avaliada:         ;
    CMP  R7, 4         ;
    JZ  display_tecla  ;
    MOV  R7, 4         ;
    MOV  R0, R1        ;
    JMP  adicione_fila ;

display_tecla:         ; escreve linha e coluna nos displays
    CMP  R6, 4         ; a tecla premida foi 4?
    JZ decr_display    ; se a tecla premida for 4, decrementa o valor no display
    CMP  R6, 5         ; a tecla premida foi 5?
    JZ incr_display    ; se a tecla premida for 5, incrementa o valor no display
    JMP ha_tecla       ; espera para a próxima tecla ser premida


decr_display:          ;
    DEC  R8            ;
    MOVB [R4], R8      ;
    JMP ha_tecla       ;
    
incr_display:          ;
    INC   R8            ;
    MOVB [R4], R8      ;
    JMP ha_tecla       ;

ha_tecla:              ; neste ciclo espera-se até NENHUMA tecla estar premida
    MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
    AND  R0, R5        ; elimina bits para além dos bits 0-3
    CMP  R0, 0         ; há tecla premida?
    JNZ  ha_tecla      ; se ainda houver uma tecla premida, espera até não haver
    JMP  ciclo         ; repete ciclo
