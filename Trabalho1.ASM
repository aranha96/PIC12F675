;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA��ES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2016                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERS�O: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRI��O DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINI��ES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADR�O MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINA��O DE MEM�RIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINI��O DE COMANDOS DE USU�RIO PARA ALTERA��O DA P�GINA DE MEM�RIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEM�RIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAM�RIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARI�VEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DOS NOMES E ENDERE�OS DE TODAS AS VARI�VEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDERE�O INICIAL DA MEM�RIA DE
					;USU�RIO
		W_TEMP		;REGISTRADORES TEMPOR�RIOS PARA USO
		STATUS_TEMP	;JUNTO �S INTERRUP��ES
		ENTRADA		;FILE DE ENTRADO EM HEXADECIMAL
		DADO		;FILE DE SA�DA
		QUOCIENTE	;QUOCIENTE DA DIVIS�O
		DIVIDENDO	;VALOR A SER DIVIDIDO

		;NOVAS VARI�VEIS

	ENDC			;FIM DO BLOCO DE MEM�RIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SA�DAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO SA�DA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDERE�O INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    IN�CIO DA INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDERE�O DE DESVIO DAS INTERRUP��ES. A PRIMEIRA TAREFA � SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERA��O FUTURA

	ORG	0x04			;ENDERE�O INICIAL DA INTERRUP��O
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SER� ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUP��ES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SA�DA DA INTERRUP��O                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUP��O

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRI��O DE FUNCIONAMENTO
; E UM NOME COERENTE �S SUAS FUN��ES.

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000000' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SA�DAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN

	;CORPO DA ROTINA PRINCIPAL
	MOVLW	0XFF	    ;MOVER O VALOR HEXADECIMAL PARA O WORK
	MOVWF	ENTRADA	    ;MOVER O VALOR DO WORK PARA O FILE ENTRADA
	CLRF	QUOCIENTE   ;LIMPAR O VALOR DO FILE QUOCIENTE
	CLRF	DADO	    ;LIMPAR O VALOR DO FILE DADO
	MOVWF	DIVIDENDO   ;MOVER O VALOR DO WORK PARA O FILE DIVIDENDO
	MOVLW	.10	    ;MOVER O VALOR 10 PARA O WORK
	GOTO	UNIDADE	    ;IR PARA A SESS�O DE DIVIS�O PARA SE OBTER A UNIDADE
	
UNIDADE
	SUBWF	DIVIDENDO   ;SUBTRAIR O VALOR 10 NO WORK DO VALOR CONTIDO NO DIVIDENDO, ARMAZENA O RESULTADO NO DIVIDENDO
	INCF	QUOCIENTE   ;INCREMENTA EM 1 O QUOCIENTE PARA CADA OPERA��O DE SUBTRA��O
	BTFSC	STATUS,Z    ;VERIFICA SE A OPERA��O N�O RESULTOU EM ZERO
	GOTO	EXATO_U	    ;CASO RESULTADO SEJA ZERO IR PARA O SETOR DE SOLU��O EXATA PARA A CASA DA UNIDADE
	BTFSC	STATUS,C    ;VERIFICA SE A OPERA��O DEU NEGATIVA
	GOTO	UNIDADE	    ;SE N�O DEU NEGATIVA VOLTAR PARA O COME�O DA DIVIS�O E INICIAR MAIS UM ITERA��O
	GOTO	RESTO_U	    ;SE RESULTADO FOR NEGATIVO PARTIR PARA OBTER O RESTO E O QUOCIENTE DA OPERA��O

EXATO_U
	MOVLW	.0	    ;MOVER O VALOR ZERO PARA O WORK 
	MOVWF	DADO	    ;MOVER O VALOR DO WORK PARA O FILE DADO
	MOVFW	QUOCIENTE   ;MOVER O VALOR DO FILE QUOCIENTE PARA O WORK
	MOVWF	DIVIDENDO   ;MOVER O VALOR DO WORK PARA O FILE DIVIDENDO
	CLRF	QUOCIENTE   ;LIMPAR O FILE QUOCIENTE
	GOTO	DEZENA	    ;IR PARA A SESS�O DE DIVIS�O PARA OBTER A DEZENA

RESTO_U
	ADDWF	DIVIDENDO,W ;COMO O VALOR DO DIVIDENDO ESTA NEGATIVO(COMPLEMENTO) SOMA O VALOR DO WORK PARA RECUPERAR O RESTO, SOLU��O ARMAZENADA NO WORK
	DECF	QUOCIENTE   ;DECREMENTO O QUOCIENTE EM 1 PARA OBTER SEU VALOR VERDADEIRO
	MOVWF	DADO	    ;MOVE O VALOR DO RESTO DA OPERA��O CONTIDO NO WORK PARA O FILE DADO(SA�DA)
	MOVFW	QUOCIENTE   ;MOVE O VALOR DO FILE QUOCIENTE PARA O WORK
	MOVWF	DIVIDENDO   ;MOVE O VALOR DO WORK PARA O FILE DIVIDENDO
	CLRF	QUOCIENTE   ;LIMPAR O FILE QUOCIENTE
	GOTO	DEZENA	    ;IR PARA A SESS�O DE DIVIS�O PARA OBTER A DEZENA

DEZENA
	MOVLW	.10	    ;MOVER O VALOR 10 PARA O WORK
	SUBWF	DIVIDENDO   ;SUBTRAIR O VALOR 10 NO WORK DO VALOR CONTIDO NO DIVIDENDO, ARMAZENA O RESULTADO NO DIVIDENDO
	INCF	QUOCIENTE   ;INCREMENTA EM 1 O QUOCIENTE PARA CADA OPERA��O DE SUBTRA��O
	BTFSC	STATUS,Z    ;VERIFICA SE A OPERA��O N�O RESULTOU EM ZERO
	GOTO	EXATO_D	    ;CASO RESULTADO SEJA ZERO IR PARA O SETOR DE SOLU��O EXATA PARA A CASA DA DEZENA
	BTFSC	STATUS,C    ;VERIFICA SE A OPERA��O DEU NEGATIVA
	GOTO	DEZENA	    ;SE N�O DEU NEGATIVA VOLTAR PARA O COME�O DA DIVIS�O E INICIAR MAIS UM ITERA��O
	GOTO	RESTO_D	    ;SE RESULTADO FOR NEGATIVO PARTIR PARA OBTER O RESTO E O QUOCIENTE DA OPERA��O
	
EXATO_D
	MOVLW	.0	    ;MOVER O VALOR ZERO PARA O WORK
	IORWF	DADO	    ;REALIZAR UMA OPERA��O DE OR ENTRE O WORK E O FILE DADO
	MOVFW	QUOCIENTE   ;MOVER O VALOR DO FILE QUOCIENTE PARA O WORK
	MOVWF	DIVIDENDO   ;MOVER O VALOR DO WORK PARA O FILE DIVIDENDO
	CLRF	QUOCIENTE   ;LIMPAR O FILE QUOCIENTE
	GOTO	CENTENA	    ;IR PARA A SESS�O DE DIVIS�O PARA OBTER A CENTENA
	
RESTO_D
	ADDWF	DIVIDENDO   ;COMO O VALOR DO DIVIDENDO ESTA NEGATIVO(COMPLEMENTO) SOMA O VALOR DO WORK PARA RECUPERAR O RESTO, SOLU��O ARMAZENADA NO DIVIDENDO
	DECF	QUOCIENTE   ;DECREMENTO O QUOCIENTE EM 1 PARA OBTER SEU VALOR VERDADEIRO   
	MOVFW	DADO	    ;MOVER O VALOR DO FILE DADO PARA O WORK
	SWAPF	DIVIDENDO   ;TROCA DE LUGAR OS 4 BITS MENOS SIGNIFICATIVOS COM OS MAIS SIGNIFICATIVOS
	IORWF	DIVIDENDO,W ;REALIZAR UMA OPERA��O DE OR ENTRE O WORK E O FILE DIVIDENDO, ARMAZENA SOLU��O NO WORK
	MOVWF	DADO	    ;MOVER O VALOR DO WORK PARA O FILE DADO(SA�DA)
	BTFSC	STATUS,Z    ;SE O QUOCIENTE FOR ZERO SIGNIFICA QUE A ENTRADA N�O POSSUI CENTENA
	GOTO	EXATO_C	    ;IR PARA A SESS�O ONDE O WORK RECEBE ZERO
	MOVFW	QUOCIENTE   ;MOVE O VALOR DO FILE QUOCIENTE PARA O WORK	
	MOVWF	DIVIDENDO   ;MOVE O VALOR DO WORK PARA O FILE DIVIDENDO
	CLRF	QUOCIENTE   ;LIMPA O QUOCIENTE
	GOTO	CENTENA	    ;IR PARA A SESS�O DE DIVIS�O PARA OBTER A CENTENA
	
CENTENA
	MOVLW	.10	    ;MOVER O VALOR 10 PARA O WORK
	SUBWF	DIVIDENDO   ;SUBTRAIR O VALOR 10 NO WORK DO VALOR CONTIDO NO DIVIDENDO, ARMAZENA O RESULTADO NO DIVIDENDO
	BTFSC	STATUS,C    ;VERIFICA SE A OPERA��O DEU NEGATIVA
	GOTO	CENTENA	    ;SE N�O DEU NEGATIVA VOLTAR PARA O COME�O DA DIVIS�O E INICIAR MAIS UM ITERA��O
	GOTO	RESTO_C	    ;SE RESULTADO FOR NEGATIVO PARTIR PARA OBTER O RESTO E O QUOCIENTE DA OPERA��O

EXATO_C
	MOVLW	.0	    ;MOVER ZERO PARA O WORK
	GOTO	MAIN	    ;IR PARA O MAIN
	
RESTO_C
	ADDWF	DIVIDENDO,W ;RECUPERA O VALOR DO DIVIDENDO E ARMAZENA O RESULTADO NO WORK
	
	
	GOTO MAIN	    ;IR PARA O MAIN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
