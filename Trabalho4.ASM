;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA��ES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2014                            *
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
#INCLUDE <P12F675.INC>	;ARQUIVO PADR�O MICROCHIP PARA 12F675

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
		DADO		;ARMAZENA O DADO PARA A EEPROM

		;NOVAS VARI�VEIS
		CONTADOR	;CONTADOR DO LA�O, VAI DE 0 A 40
		POSICAO_A	;VALOR DA POSICAO A SER DESLOCADA
		POSICAO_B	;VALOR DA POSICAO A SER COMPARADA PARA SABER SE IRA OCORRER O DESLOCAMENTO OU NAO
		VALOR_A		;VALOR ENCONTRADO NA POSICAO A
		VALOR_B		;VALOR ENCONTRADO NA POSICAO B
    		AUXILIAR	;ARMAZENA O VALOR DA POSICAO ORIGINAL DE A PARA AUXILIAR O CONTADOR

	ENDC			;FIM DO BLOCO DE MEM�RIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA
; INICIALIZA��O DA EEPROM, DE ACORDO COM A DESCRI��O NO ARQUIVO "Def_Rega_Formigas.inc"

;A PARTIR DO ENDERE�O ZERO DA EEPROM, DADOS EM ORDEM ALEAT�RIA
	ORG 0x2100
	DE	0X89,0X1E,0X39,0X9F,0XC2,0X0C,0XAB,0X33,0X63,0XD3,0X95,0X7B,0X38,0XD6,0X1E,0X48
	DE	0XDB,0XD8,0X86,0XFD,0XA5,0XFC,0X0C,0XBE,0X68,0X9B,0XD9,0X10,0XD8,0XEC,0X90,0X91
	DE	0XAA,0XBB,0XCC,0XDD,0XEE,0XF1,0XC9,0X77

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
LE_EEPROM
;LER DADO DA EEPROM, CUJO ENDERE�O � INDICADO EM W
;DADO LIDO RETORNA EM W
	ANDLW	.127		;LIMITA ENDERE�O MAX. 127
	BANK1				;ACESSO VIA BANK 1
	MOVWF	EEADR		;INDICA O END. DE LEITURA
	BSF		EECON1,RD	;INICIA O PROCESSO DE LEITURA
	MOVF	EEDATA,W	;COLOCA DADO LIDO EM W
	BANK0				;POSICIONA PARA BANK 0
	RETURN

GRAVA_EEPROM
;ESCREVE DADO (DADO) NA EEPROM, CUJO ENDERE�O � INDICADO EM W
	ANDLW	.127		;LIMITA ENDERE�O MAX. 127
	BANK1				;ACESSO VIA BANK 1
	MOVWF	EEADR
	MOVF	DADO,W
	MOVWF	EEDATA
	BSF		EECON1,WREN ;HABILITA ESCRITA
	BCF		INTCON,GIE	;DESLIGA INTERRUP��ES
	MOVLW	B'01010101'	;DESBLOQUEIA ESCRITA
	MOVWF	EECON2		;
	MOVLW	B'10101010'	;DESBLOQUEIA ESCRITA
	MOVWF	EECON2		;
	BSF		EECON1,WR ;INICIA A ESCRITA
AGUARDA
	BTFSC	EECON1,WR ;TERMINOU?
	GOTO	AGUARDA
	BSF		INTCON,GIE ;HABILITA INTERRUP��ES
	BANK0				;POSICIONA PARA BANK 0
	RETURN

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00100000' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
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
	BSF	GPIO,GP5	    ;LIGA O LED NA PORTA GP5
	CLRF	AUXILIAR	    ;LIMPA A VARIAVEL AUXILIAR
	CLRF	CONTADOR	    ;LIMPA A VARIAVEL CONTADOR
	CLRF	POSICAO_A	    ;LIMPA A VARIAVEL POSICAO A
	
	
	
ORDENACAO

	INCF	POSICAO_A	    ;INCREMENTA A POSICAO A PARA COMECAR PELO SEGUNDO VALOR
	MOVFW	POSICAO_A	    ;MOVE A POSICAO A PARA O WORK
	MOVWF	AUXILIAR	    ;COPIA O VALOR DA POSICAO A NO AUXILIAR
	CALL	LE_EEPROM	    ;VERIFICA O VALOR ENCONTRADO NA EEPROM NA POSICAO A E ARMAZENA NO WORK
	MOVWF	VALOR_A		    ;MOVE O VALOR DO WORK PARA O VALOR DE A
	DECF	POSICAO_A,W	    ;DECREMENTA A POSICAO A PARA DESCOBRIR A POSICAO B E ARMAZENA NO WORK
	MOVWF	POSICAO_B	    ;MOVE O VALOR NO WORK PARA A POSICAO B	
	CALL	LE_EEPROM	    ;VERIFICA O VALOR ENCONTRADO NA EEPROM NA POSICAO B E ARMAZENA NO WORK
	MOVWF	VALOR_B		    ;MOVE O VALOR DO WORK PARA O VALOR DE B
	GOTO	COMPARACAO	    ;VAI PARA A O LABEL COMPARACAO
	
COMPARACAO
	
	SUBWF	VALOR_A,W	    ;SUBTRAI A - B, SENDO WORK � IGUAL A B
	BTFSC	STATUS,C	    ;VERIFICA SE O RESULTADO DA OPERACAO DEU NEGATIVO, A MENOR QUE B
	GOTO	TROCA		    ;SE A MAIOR QUE B VAI PRA TROCA
	GOTO	VERIFICA_PROXIMO    ;SE B MAIOR QUE A PROCURA O VIZINHO DE B PARA REALIZAR UMA NOVA COMPARACAO
	
TROCA
	
	MOVFW	VALOR_B		    ;MOVE O VALOR DE B PARA O WORK
	MOVWF	DADO		    ;MOVE O VALOR DO WORK PARA O DADO, PARA QUE POSSA SER ESCRITO NA MEMORIA EEPROM
	MOVFW	POSICAO_A	    ;MOVE A POSICAO DE A PARA O WORK, PARA QUE POSSA SER FEITA A TROCA
	CALL	GRAVA_EEPROM	    ;GRAVA O VALOR DE B NA POSICAO A NA MEMORIA EEPROM
	MOVFW	VALOR_A		    ;MOVE O VALOR DE A PARA O WORK
	MOVWF	DADO		    ;MOVE O VALOR DO WORK PARA O DADO, PARA QUE POSSA SER ESCRITO NA MEMORIA EEPROM
	MOVFW	POSICAO_B	    ;MOVE A POSICAO DE B PARA O WORK, PARA QUE POSSA SER FEITA A TROCA
	CALL	GRAVA_EEPROM	    ;GRAVA O VALOR DE A NA POSICAO B NA MEMORIA EEPROM
		
VERIFICA_PROXIMO
	
	MOVLW	.1		    ;MOVE O VALOR LITERAL 1 PARA O WORK 
	SUBWF	POSICAO_A	    ;SUBTRAI 1 DA POSICAO DE A
	SUBWF	POSICAO_B	    ;SUBTRAI 1 DA POSICAO DE B	
	BTFSC	STATUS,C	    ;VERIFICA SE A SUBTRACAO DE B - 1 DE NEGATIVO
	GOTO	PROXIMO		    ;SE NAO DEU NEGATIVO VAI PARA A PROXIMA POSICAO DE B
	INCF	CONTADOR	    ;SE DEU NEGATIVO INCREMENTA O CONTADOR
	MOVLW	.40		    ;MOVE VALOR LITERAL 40 PARA O WORK
	SUBWF	CONTADOR,W	    ;SUBTRAI CONTADOR - 40
	BTFSS	STATUS,Z	    ;VERIFICA SE O RESULTADO DA OPERACAO FOI ZERO
	GOTO	VOLTA_ORDENAR	    ;SE NAO FOR ZERO INICIA MAIS UM CICLO DE ORDENACAO
	GOTO	FIM		    ;SE FOR ZERO FINALIZA A ORDENACAO
	
PROXIMO
	
	MOVFW	POSICAO_B	    ;MOVE O VALOR DA POSICAO B PARA O WORK
	CALL	LE_EEPROM	    ;ENCONTRA O VALOR NA MEMORIA EEPROM NA NOVA POSICAO DE B E ARMAZENA NO WORK
	MOVWF	VALOR_B		    ;MOVE O VALOR DO WORK PARA O VALOR DE B
	GOTO	COMPARACAO	    ;REINICIA A COMPARACAO
	
VOLTA_ORDENAR
	MOVFW	AUXILIAR	    ;MOVE O VALOR DO AUXILIAR AO WORK
	MOVWF	POSICAO_A	    ;MOVE O VALOR DO WORK A POSICAO A, RECUPERANDO O VALOR ORIGINAL ANTES DOS DECREMENTOS
	GOTO	ORDENACAO	    ;RETOMA A ORDENACAO
		
FIM
	BCF	GPIO,GP5	    ;DESLIGA O LED DA PORTA GP5
	GOTO	FIM		    ;VOLTA PARA O FIM

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
