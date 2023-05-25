
ASTEROIDE_COM_RECURSOS:     ; tabela que define o asteroide com recursos (cor, largura, pixels, altura)
    WORD    LARGURA_AST
    WORD    ALTURA_AST
    WORD    0, 0, PIXEL_VERD, 0, 0
    WORD    0, PIXEL_VERD, PIXEL_VERD, PIXEL_VERD, 0
    WORD    PIXEL_VERD, PIXEL_VERD, PIXEL_VERD, PIXEL_VERD, PIXEL_VERD
    WORD    0, PIXEL_VERD, PIXEL_VERD, PIXEL_VERD, 0
    WORD    0, 0, PIXEL_VERD, 0, 0

RECURSOS:                   ; tabela que define os recursos (cor, largura, pixels, altura)
    WORD    LARGURA_AST
    WORD    ALTURA_AST
    WORD    PIXEL_AZUL, 0, PIXEL_AZUL, 0, PIXEL_AZUL
    WORD    0, PIXEL_AZUL, PIXEL_AZUL, PIXEL_AZUL, 0
    WORD    PIXEL_AZUL, PIXEL_AZUL, PIXEL_AZUL, PIXEL_AZUL, PIXEL_AZUL
    WORD    0, PIXEL_AZUL, PIXEL_AZUL, PIXEL_AZUL, 0
    WORD    PIXEL_AZUL, 0, PIXEL_AZUL, 0, PIXEL_AZUL

ATRASO_SONDA		EQU	9000H	; atraso que determina a velocidade da SONDA
MOVES_SONDA			EQU 12		; número de movimentos da sonda

posição_asteroide_cent:
    MOV  R1, LINHA_TOPO			; linha do asteroide
    MOV  R2, COLUNA_CENT		; coluna do asteroide
	;MOV	R4, DEF_BONECO		; endereço da tabela que define o asteroide

posição_asteroide_dir:
    MOV  R1, LINHA_TOPO			; linha do asteroide
    MOV  R2, COLUNA_DIR		; coluna do asteroide
	;MOV	R4, DEF_BONECO		; endereço da tabela que define o asteroide