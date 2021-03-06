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

		;NOVAS VARI�VEIS
		TEMPO		;VARI�VEL QUE CONTA O TEMPO DE PERMANENCIA DA ONDA EM 1

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
	MOVLW	B'00110011' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS);GP2 COMO ENTRADA, GP0,1,4 E 5 COMO SAIDA
	MOVWF	TRISIO		;COMO SA�DAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000000'
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
	BTFSS	GPIO,GP2	;VERIFICA SE GP2 EST� EM 1
	GOTO	MAIN		;CASO N�O ESTEJA VOLTA PRO COME�O E FAZ O TESTE DE NOVO
	GOTO	CONTAGEM	;CASO ESTEJA EM 1 INICIA O CONTAGEM DO PERIODO DA ONDE EM 1
	
CONTAGEM
	CLRF	TMR0		;LIMPA O TIMER 0 PRA INICIAR A CONTAGEM
	BTFSC	GPIO,GP2	;VERIFICA SE GP2 EST� EM 0  
	GOTO	CONTAGEM	;CASO N�O ESTEJA VOLTA PRO INICIO DA CONTAGEM E REFAZ O TESTE	
	MOVFW	TMR0		;CASO ESTEJA EM 0 ARMAZENA O VALOR DO TIMER 0 NO WORK	
	MOVWF	TEMPO		;ARMAZENA O VALOR DO WORK NA VARIAVEL TEMPO
	CLRF	TMR0		;LIMPA O TIMER 0 PARA UMA FUTURA NOVA CONTAGEM
	ADDWF	TEMPO		;SOMA O VALOR DE WORK AO TEMPO(2 X TEMPO) PARA OBTER O PERIODO
	GOTO	CINCO_KHZ	;COM O PERIODO OBTIDO VAI PARA O PRIMEIRO TESTE

CINCO_KHZ
	MOVLW	.221		;MOVE VALOR 221 PARA O WORK
	SUBWF	TEMPO,W		;SUBTRAI O VALOR DO WORK DO TEMPO E ARMAZENA O RESULTADO NO WORK
	BTFSC	STATUS,C	;VERIFICA SE O RESULTADO DA OPERA��O DEU NEGATIVO, INFERIOR A BORDA SUPERIOR
	GOTO	DEZ_KHZ		;CASO O VALOR SEJA POSITIVO VAI PARA O PROXIMO TESTE POIS N�O PODE SER 5KHZ
	MOVLW	.179		;MOVE VALOR 179 PARA O WORK
	SUBWF	TEMPO,W		;SUBTRAI O VALOR DO WORK DO TEMPO E ARMAZENA O RESULTADO NO WORK
	BTFSS	STATUS,C	;VERIFICA SE O RESULTADO DA OPERA��O DEU POSITIVO, SUPERIOR A BORDA INFERIOR
	GOTO	DEZ_KHZ		;CASO NEGATIVO VAI PARA O PROXIMO TESTE POIS N�O PODE SER 5KHZ
	BSF	GPIO,GP0	;CASO POSITIVO SETA GP0 INDICANDO QUE A FREQUENCIA DO SINAL � 5KHZ
	
DEZ_KHZ
	MOVLW	.111		;MOVE VALOR 111 PARA O WORK
	SUBWF	TEMPO,W		;SUBTRAI O VALOR DO WORK DO TEMPO E ARMAZENA O RESULTADO NO WORK
	BTFSC	STATUS,C	;VERIFICA SE O RESULTADO DA OPERA��O DEU NEGATIVO, INFERIOR A BORDA SUPERIOR
	GOTO	VINTE_KHZ	;CASO O VALOR SEJA POSITIVO VAI PARA O PROXIMO TESTE POIS N�O PODE SER 10KHZ
	MOVLW	.89		;MOVE VALOR 89 PARA O WORK
	SUBWF	TEMPO,W		;SUBTRAI O VALOR DO WORK DO TEMPO E ARMAZENA O RESULTADO NO WORK
	BTFSS	STATUS,C	;VERIFICA SE O RESULTADO DA OPERA��O DEU POSITIVO, SUPERIOR A BORDA INFERIOR
	GOTO	VINTE_KHZ	;CASO NEGATIVO VAI PARA O PROXIMO TESTE POIS N�O PODE SER 10KHZ
	BSF	GPIO,GP1	;CASO POSITIVO SETA GP1 INDICANDO QUE A FREQUENCIA DO SINAL � 10KHZ

VINTE_KHZ
	MOVLW	.56		;MOVE VALOR 56 PARA O WORK
	SUBWF	TEMPO,W		;SUBTRAI O VALOR DO WORK DO TEMPO E ARMAZENA O RESULTADO NO WORK
	BTFSC	STATUS,C	;VERIFICA SE O RESULTADO DA OPERA��O DEU NEGATIVO, INFERIOR A BORDA SUPERIOR
	GOTO	TRINTA_KHZ	;CASO O VALOR SEJA POSITIVO VAI PARA O PROXIMO TESTE POIS N�O PODE SER 20KHZ
	MOVLW	.44		;MOVE VALOR 44 PARA O WORK
	SUBWF	TEMPO,W		;SUBTRAI O VALOR DO WORK DO TEMPO E ARMAZENA O RESULTADO NO WORK
	BTFSS	STATUS,C	;VERIFICA SE O RESULTADO DA OPERA��O DEU POSITIVO, SUPERIOR A BORDA INFERIOR
	GOTO	TRINTA_KHZ	;CASO NEGATIVO VAI PARA O PROXIMO TESTE POIS N�O PODE SER 20KHZ
	BSF	GPIO,GP4	;CASO POSITIVO SETA GP4 INDICANDO QUE A FREQUENCIA DO SINAL � 20KHZ

TRINTA_KHZ
	MOVLW	.38		;MOVE VALOR 38 PARA O WORK
	SUBWF	TEMPO,W		;SUBTRAI O VALOR DO WORK DO TEMPO E ARMAZENA O RESULTADO NO WORK
	BTFSC	STATUS,C	;VERIFICA SE O RESULTADO DA OPERA��O DEU NEGATIVO, INFERIOR A BORDA SUPERIOR
	GOTO	FIM		;CASO O VALOR SEJA POSITIVO VAI PARA O FIM DO TESTE POIS N�O PODE SER 30KHZ
	MOVLW	.29		;MOVE VALOR 29 PARA O WORK
	SUBWF	TEMPO,W		;SUBTRAI O VALOR DO WORK DO TEMPO E ARMAZENA O RESULTADO NO WORK
	BTFSS	STATUS,C	;VERIFICA SE O RESULTADO DA OPERA��O DEU POSITIVO, SUPERIOR A BORDA INFERIOR
	GOTO	FIM		;CASO NEGATIVO VAI PARA O FIM DO TESTE POIS N�O PODE SER 230KHZ
	BSF	GPIO,GP5	;CASO POSITIVO SETA GP5 INDICANDO QUE A FREQUENCIA DO SINAL � 30KHZ

FIM
	GOTO FIM

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
