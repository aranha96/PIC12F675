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
		LED_AZUL
		LED_VERMELHO
		LED_VERDE

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
	BANK1			;ALTERA PARA O BANCO 1
	MOVLW	B'00111000'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS) - GP3 E GP5 ENTRADAS, GP1,GP2 E GP0 SAIDAS
	MOVWF	TRISIO		;COMO SA�DAS
	MOVLW	B'00011000'	;PORTA GP4 PRA CONVERS�O
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000010'	;TMR0 1:8
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	BANK0			;RETORNA PARA O BANCO
	MOVLW	B'00001101'
	MOVWF	ADCON0
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	CLRF	LED_AZUL
	CLRF	LED_VERMELHO
	CLRF	LED_VERDE
	BCF	GPIO,GP0
	BCF	GPIO,GP1
	BCF	GPIO,GP2
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN

	;CORPO DA ROTINA PRINCIPAL

	
CHAVE_ZERO
	BTFSS	GPIO,GP3	    ;SE GP3 FOR 1 ELE PODE SER OU AZUL OU VERMELHO
	GOTO	DESLIGADO_VERDE	    ;VERIFICA SE O RESULTADO � 00 OU 10
	GOTO	VERMELHO_AZUL	    ;VERIFICA SE O RESULTADO � 01 OU 11
	
DESLIGADO_VERDE
	BTFSC	GPIO,GP5	    ;SE GP5 FOR 1 ELE � 10, OU SEJA VERDE
	GOTO	VERDE		    ;GP5 = 1 E GP3 = 0
	GOTO	DESLIGADO	    ;GP5 = 0 E GP3 = 0

VERMELHO_AZUL
	BTFSS	GPIO,GP5	    ;SE GP5 FOR 1 � 11, OU SEJA AZUL
	GOTO	VERMELHO	    ;GP5 = 0 E GP3 = 1
	GOTO	AZUL		    ;GP5 = 1 E GP3 = 1
	
VERDE				    ;GP1
	BSF	ADCON0,GO	    ;DIGITALIZA A ENTRADA ANALOGICA DA PORTA GP4
	BTFSC	ADCON0,GO
	GOTO	$-1
	MOVFW	ADRESH
	MOVWF	LED_VERDE	    ;SALVA O VALOR DO ADRESH NA VARIAVEL LED_VERDE
	MOVLW	.0		    ;VERIFICA SE LED_VERDE POSSUI TENS�O ZERO
	SUBWF	LED_VERDE,W
	BTFSS	STATUS,Z
	GOTO	ONDA_G		    ;SE N�O TIVER GERA A ONDA ADEQUADA
	BCF	GPIO,GP1	    ;SE TIVER SETA A PORTA EM ZERO
	GOTO	MAIN
	
ONDA_G
	MOVLW	.0		    ;INICIA O CONTADOR
	MOVWF	TMR0
	BSF	GPIO,GP1	    ;SETA A PORTA GP1
	MOVFW	LED_VERDE
	SUBWF	TMR0,W		    ;VERIFICA SE O TIMER ATINGIU O VALOR DO LED_VERDE
	BTFSS	STATUS,Z
	GOTO	$-3
	BCF	GPIO,GP1	    ;QUANDO ATINGIR ZERA A PORTA GP1
	BTFSS	INTCON,T0IF	    ;VERIFICA O ESTOURO DO TIMER COM UM TOTAL DE 2MS, 500HZ
	GOTO	$-1
	BCF	INTCON,T0IF	    ;LIMPA A FLAG DE ESTOURO DO TIMER
	GOTO	CHAVE_ZERO	    ;VERIFICA SE N�O HOUVE MUDAN�A DE CHAVE

VERMELHO			    ;GP0
	BSF	ADCON0,GO	    ;DIGITALIZA A ENTRADA ANALOGICA DA PORTA GP4
	BTFSC	ADCON0,GO
	GOTO	$-1
	MOVFW	ADRESH
	MOVWF	LED_VERMELHO	    ;SALVA O VALOR DO ADRESH NA VARIAVEL LED_VERMELHO
	MOVLW	.0		    ;VERIFICA SE LED_VERMELHO POSSUI TENS�O ZERO
	SUBWF	LED_VERMELHO,W
	BTFSS	STATUS,Z
	GOTO	ONDA_R		    ;SE N�O TIVER GERA A ONDA ADEQUADA
	BCF	GPIO,GP0	    ;SE TIVER SETA A PORTA EM ZERO
	GOTO	MAIN
	
ONDA_R
	MOVLW	.0		    ;INICIA O CONTADOR
	MOVWF	TMR0
	BSF	GPIO,GP0	    ;SETA A PORTA GP0
	MOVFW	LED_VERMELHO
	SUBWF	TMR0,W		    ;VERIFICA SE O TIMER ATINGIU O VALOR DO LED_VERMELHO
	BTFSS	STATUS,Z
	GOTO	$-3
	BCF	GPIO,GP0	    ;QUANDO ATINGIR ZERA A PORTA GP0
	BTFSS	INTCON,T0IF	    ;VERIFICA O ESTOURO DO TIMER COM UM TOTAL DE 2MS, 500HZ
	GOTO	$-1
	BCF	INTCON,T0IF	    ;LIMPA A FLAG DE ESTOURO DO TIMER
	GOTO	CHAVE_ZERO	    ;VERIFICA SE N�O HOUVE MUDAN�A DE CHAVE
	
AZUL				    ;GP2
	BSF	ADCON0,GO	    ;DIGITALIZA A ENTRADA ANALOGICA DA PORTA GP4
	BTFSC	ADCON0,GO
	GOTO	$-1
	MOVFW	ADRESH
	MOVWF	LED_AZUL	    ;SALVA O VALOR DO ADRESH NA VARIAVEL LED_AZUL
	MOVLW	.0		    ;VERIFICA SE LED_AZUL POSSUI TENS�O ZERO
	SUBWF	LED_AZUL,W
	BTFSS	STATUS,Z
	GOTO	ONDA_B		    ;SE N�O TIVER GERA A ONDA ADEQUADA
	BCF	GPIO,GP2	    ;SE TIVER SETA A PORTA EM ZERO
	GOTO	MAIN
	
ONDA_B
	MOVLW	.0		    ;INICIA O CONTADOR
	MOVWF	TMR0
	BSF	GPIO,GP2
	MOVFW	LED_AZUL
	SUBWF	TMR0,W		    ;VERIFICA SE O TIMER ATINGIU O VALOR DO LED_AZUL
	BTFSS	STATUS,Z	    
	GOTO	$-3
	BCF	GPIO,GP2	    ;QUANDO ATINGIR ZERA A PORTA GP2
	BTFSS	INTCON,T0IF	    ;VERIFICA O ESTOURO DO TIMER COM UM TOTAL DE 2MS, 500HZ
	GOTO	$-1
	BCF	INTCON,T0IF	    ;LIMPA A FLAG DE ESTOURO DO TIMER
	GOTO	CHAVE_ZERO	    ;VERIFICA SE N�O HOUVE MUDAN�A DE CHAVE
	
DESLIGADO			    ;DESLIGA TODOS OS LEDS
	BCF	GPIO,GP0
	BCF	GPIO,GP1
	BCF	GPIO,GP2
	GOTO	MAIN
	
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
