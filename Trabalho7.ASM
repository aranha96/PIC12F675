;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2016                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERSÃO: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRIÇÃO DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINIÇÕES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINAÇÃO DE MEMÓRIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINIÇÃO DE COMANDOS DE USUÁRIO PARA ALTERAÇÃO DA PÁGINA DE MEMÓRIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEMÓRIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAMÓRIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIÁVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DOS NOMES E ENDEREÇOS DE TODAS AS VARIÁVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDEREÇO INICIAL DA MEMÓRIA DE
					;USUÁRIO
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO ÀS INTERRUPÇÕES

		;NOVAS VARIÁVEIS
		LED_AZUL
		LED_VERMELHO
		LED_VERDE

	ENDC			;FIM DO BLOCO DE MEMÓRIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SAÍDAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO SAÍDA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDEREÇO INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    INÍCIO DA INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDEREÇO DE DESVIO DAS INTERRUPÇÕES. A PRIMEIRA TAREFA É SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERAÇÃO FUTURA

	ORG	0x04			;ENDEREÇO INICIAL DA INTERRUPÇÃO
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SERÁ ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUPÇÕES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SAÍDA DA INTERRUPÇÃO                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUPÇÃO

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRIÇÃO DE FUNCIONAMENTO
; E UM NOME COERENTE ÀS SUAS FUNÇÕES.

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1			;ALTERA PARA O BANCO 1
	MOVLW	B'00111000'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS) - GP3 E GP5 ENTRADAS, GP1,GP2 E GP0 SAIDAS
	MOVWF	TRISIO		;COMO SAÍDAS
	MOVLW	B'00011000'	;PORTA GP4 PRA CONVERSÃO
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000010'	;TMR0 1:8
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	BANK0			;RETORNA PARA O BANCO
	MOVLW	B'00001101'
	MOVWF	ADCON0
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
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
	GOTO	DESLIGADO_VERDE	    ;VERIFICA SE O RESULTADO É 00 OU 10
	GOTO	VERMELHO_AZUL	    ;VERIFICA SE O RESULTADO É 01 OU 11
	
DESLIGADO_VERDE
	BTFSC	GPIO,GP5	    ;SE GP5 FOR 1 ELE É 10, OU SEJA VERDE
	GOTO	VERDE		    ;GP5 = 1 E GP3 = 0
	GOTO	DESLIGADO	    ;GP5 = 0 E GP3 = 0

VERMELHO_AZUL
	BTFSS	GPIO,GP5	    ;SE GP5 FOR 1 É 11, OU SEJA AZUL
	GOTO	VERMELHO	    ;GP5 = 0 E GP3 = 1
	GOTO	AZUL		    ;GP5 = 1 E GP3 = 1
	
VERDE				    ;GP1
	BSF	ADCON0,GO	    ;DIGITALIZA A ENTRADA ANALOGICA DA PORTA GP4
	BTFSC	ADCON0,GO
	GOTO	$-1
	MOVFW	ADRESH
	MOVWF	LED_VERDE	    ;SALVA O VALOR DO ADRESH NA VARIAVEL LED_VERDE
	MOVLW	.0		    ;VERIFICA SE LED_VERDE POSSUI TENSÃO ZERO
	SUBWF	LED_VERDE,W
	BTFSS	STATUS,Z
	GOTO	ONDA_G		    ;SE NÃO TIVER GERA A ONDA ADEQUADA
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
	GOTO	CHAVE_ZERO	    ;VERIFICA SE NÃO HOUVE MUDANÇA DE CHAVE

VERMELHO			    ;GP0
	BSF	ADCON0,GO	    ;DIGITALIZA A ENTRADA ANALOGICA DA PORTA GP4
	BTFSC	ADCON0,GO
	GOTO	$-1
	MOVFW	ADRESH
	MOVWF	LED_VERMELHO	    ;SALVA O VALOR DO ADRESH NA VARIAVEL LED_VERMELHO
	MOVLW	.0		    ;VERIFICA SE LED_VERMELHO POSSUI TENSÃO ZERO
	SUBWF	LED_VERMELHO,W
	BTFSS	STATUS,Z
	GOTO	ONDA_R		    ;SE NÃO TIVER GERA A ONDA ADEQUADA
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
	GOTO	CHAVE_ZERO	    ;VERIFICA SE NÃO HOUVE MUDANÇA DE CHAVE
	
AZUL				    ;GP2
	BSF	ADCON0,GO	    ;DIGITALIZA A ENTRADA ANALOGICA DA PORTA GP4
	BTFSC	ADCON0,GO
	GOTO	$-1
	MOVFW	ADRESH
	MOVWF	LED_AZUL	    ;SALVA O VALOR DO ADRESH NA VARIAVEL LED_AZUL
	MOVLW	.0		    ;VERIFICA SE LED_AZUL POSSUI TENSÃO ZERO
	SUBWF	LED_AZUL,W
	BTFSS	STATUS,Z
	GOTO	ONDA_B		    ;SE NÃO TIVER GERA A ONDA ADEQUADA
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
	GOTO	CHAVE_ZERO	    ;VERIFICA SE NÃO HOUVE MUDANÇA DE CHAVE
	
DESLIGADO			    ;DESLIGA TODOS OS LEDS
	BCF	GPIO,GP0
	BCF	GPIO,GP1
	BCF	GPIO,GP2
	GOTO	MAIN
	
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
