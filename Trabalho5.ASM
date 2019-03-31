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
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000100'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS) GP2 COMO ENTRADA
	MOVWF	TRISIO		;COMO SAÍDAS
	MOVLW	B'00010100'	
	MOVWF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00001001'
	MOVWF	ADCON0
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	;CORPO DA ROTINA PRINCIPAL
	BSF	ADCON0,GO	    ;INICIA A DIGITALIZAÇÃO 
	BTFSC	ADCON0,GO	    ;VERIFICA SE A DIGITALIZAÇÃO ACABOU
	GOTO	$-1		    ;VOLTA PRA LINHA ANTERIOR
	MOVLW	.26		    ;MOVE VALOR 26 (0.5 VOLTS) PARA O WORK
	SUBWF	ADRESH,W	    ;ADRESH - WORK, RESULTADO NO WORK
	BTFSS	STATUS,C	    ;VERIFICA SE A OPERAÇÃO DE NEGATIVO
	GOTO	SETA_ZERO	    ;VAI PARA O LABEL SETA ZERO
	GOTO	TESTA_UM	    ;VAI PARA O LABEL TESTA UM

TESTA_UM
	MOVLW	.52		    ;MOVE VALOR 52(1 VOLT) PARA O WORK
	SUBWF	ADRESH,W	    ;ADRESH - WORK, RESULTADO NO WORK
	BTFSS	STATUS,C	    ;VERIFICA SE A OPERAÇÃO DE NEGATIVO
	GOTO	SETA_UM		    ;VAI PARA O LABEL SETA UM
	GOTO	TESTA_DOIS	    ;VAI PARA O LABEL TESTA DOIS
	
TESTA_DOIS
	MOVLW	.77		    ;MOVE VALOR 77(1.5 VOLT) PARA O WORK
	SUBWF	ADRESH,W	    ;ADRESH - WORK, RESULTADO NO WORK
	BTFSS	STATUS,C	    ;VERIFICA SE A OPERAÇÃO DE NEGATIVO
	GOTO	SETA_DOIS	    ;VAI PARA O LABEL SETA DOIS
	GOTO	TESTA_TRES	    ;VAI PARA O LABEL TESTA TRES
	
TESTA_TRES
	MOVLW	.103		    ;MOVE VALOR 103(2 VOLTS) PARA O WORK
	SUBWF	ADRESH,W	    ;ADRESH - WORK, RESULTADO NO WORK
	BTFSS	STATUS,C	    ;VERIFICA SE A OPERAÇÃO DE NEGATIVO
	GOTO	SETA_TRES	    ;VAI PARA O LABEL SETA TRES
	GOTO	TESTA_QUATRO	    ;VAI PARA O LABEL TESTA QUATRO

TESTA_QUATRO
	MOVLW	.129		    ;MOVE VALOR 129(2.5 VOLTS) PARA O WORK
	SUBWF	ADRESH,W	    ;ADRESH - WORK, RESULTADO NO WORK
	BTFSS	STATUS,C	    ;VERIFICA SE A OPERAÇÃO DE NEGATIVO
	GOTO	SETA_QUATRO	    ;VAI PARA O LABEL SETA QUATRO
	GOTO	TESTA_CINCO	    ;VAI PARA O LABEL TESTA CINCO


TESTA_CINCO
	MOVLW	.154		    ;MOVE VALOR 154(3 VOLTS) PARA O WORK
	SUBWF	ADRESH,W	    ;ADRESH - WORK, RESULTADO NO WORK
	BTFSS	STATUS,C	    ;VERIFICA SE A OPERAÇÃO DE NEGATIVO
	GOTO	SETA_CINCO	    ;VAI PARA O LABEL SETA CINCO
	GOTO	TESTA_SEIS	    ;VAI PARA O LABEL TESTA SEIS

TESTA_SEIS  
	MOVLW	.180		    ;MOVE VALOR 180(3.5 VOLTS) PARA O WORK
	SUBWF	ADRESH,W	    ;ADRESH - WORK, RESULTADO NO WORK
	BTFSS	STATUS,C	    ;VERIFICA SE A OPERAÇÃO DE NEGATIVO
	GOTO	SETA_SEIS	    ;VAI PARA O LABEL SETA SEIS
	GOTO	TESTA_SETE	    ;VAI PARA O LABEL TESTA SETE

TESTA_SETE
	MOVLW	.205		    ;MOVE VALOR 205(4 VOLTS) PARA O WORK
	SUBWF	ADRESH,W	    ;ADRESH - WORK, RESULTADO NO WORK
	BTFSS	STATUS,C	    ;VERIFICA SE A OPERAÇÃO DE NEGATIVO
	GOTO	SETA_SETE	    ;VAI PARA O LABEL SETA SETE
	GOTO	TESTA_OITO	    ;VAI PARA O LABEL TESTA OITO

TESTA_OITO
	MOVLW	.231		    ;MOVE VALOR 231(4.5 VOLTS) PARA O WORK
	SUBWF	ADRESH,W	    ;ADRESH - WORK, RESULTADO NO WORK
	BTFSS	STATUS,C	    ;VERIFICA SE A OPERAÇÃO DE NEGATIVO
	GOTO	SETA_OITO	    ;VAI PARA O LABEL SETA OITO
	GOTO	SETA_NOVE	    ;VAI PARA O LABEL SETA NOVE

SETA_ZERO			    ;SETA OS BITS GP5,GP4,GP1,GP0 PRO VALOR 0000
	BCF	GPIO,GP0	    
	BCF	GPIO,GP1
	BCF	GPIO,GP4
	BCF	GPIO,GP5
	GOTO	MAIN		    ;VOLTA PRA MAIN PRA REINICIAR A DIGITALIZAÇÃO
	
SETA_UM				    ;SETA OS BITS GP5,GP4,GP1,GP0 PRO VALOR 0001
	BSF	GPIO,GP0
	BCF	GPIO,GP1
	BCF	GPIO,GP4
	BCF	GPIO,GP5
	GOTO	MAIN		    ;VOLTA PRA MAIN PRA REINICIAR A DIGITALIZAÇÃO

SETA_DOIS			    ;SETA OS BITS GP5,GP4,GP1,GP0 PRO VALOR 0010
	BCF	GPIO,GP0
	BSF	GPIO,GP1
	BCF	GPIO,GP4
	BCF	GPIO,GP5
	GOTO	MAIN		    ;VOLTA PRA MAIN PRA REINICIAR A DIGITALIZAÇÃO

SETA_TRES			    ;SETA OS BITS GP5,GP4,GP1,GP0 PRO VALOR 0011
	BSF	GPIO,GP0
	BSF	GPIO,GP1
	BCF	GPIO,GP4
	BCF	GPIO,GP5
	GOTO	MAIN		    ;VOLTA PRA MAIN PRA REINICIAR A DIGITALIZAÇÃO
	
SETA_QUATRO			    ;SETA OS BITS GP5,GP4,GP1,GP0 PRO VALOR 0100
	BCF	GPIO,GP0
	BCF	GPIO,GP1
	BSF	GPIO,GP4
	BCF	GPIO,GP5
	GOTO	MAIN		    ;VOLTA PRA MAIN PRA REINICIAR A DIGITALIZAÇÃO
	
SETA_CINCO			    ;SETA OS BITS GP5,GP4,GP1,GP0 PRO VALOR 0101
	BSF	GPIO,GP0
	BCF	GPIO,GP1
	BSF	GPIO,GP4
	BCF	GPIO,GP5
	GOTO	MAIN		    ;VOLTA PRA MAIN PRA REINICIAR A DIGITALIZAÇÃO
	
SETA_SEIS			    ;SETA OS BITS GP5,GP4,GP1,GP0 PRO VALOR 0110
	BCF	GPIO,GP0
	BSF	GPIO,GP1
	BSF	GPIO,GP4
	BCF	GPIO,GP5
	GOTO	MAIN		    ;VOLTA PRA MAIN PRA REINICIAR A DIGITALIZAÇÃO
	
SETA_SETE			    ;SETA OS BITS GP5,GP4,GP1,GP0 PRO VALOR 0111
	BSF	GPIO,GP0
	BSF	GPIO,GP1
	BSF	GPIO,GP4
	BCF	GPIO,GP5
	GOTO	MAIN		    ;VOLTA PRA MAIN PRA REINICIAR A DIGITALIZAÇÃO
	
SETA_OITO			    ;SETA OS BITS GP5,GP4,GP1,GP0 PRO VALOR 1000
	BCF	GPIO,GP0
	BCF	GPIO,GP1
	BCF	GPIO,GP4
	BSF	GPIO,GP5
	GOTO	MAIN		    ;VOLTA PRA MAIN PRA REINICIAR A DIGITALIZAÇÃO

SETA_NOVE			    ;SETA OS BITS GP5,GP4,GP1,GP0 PRO VALOR 1001
	BSF	GPIO,GP0
	BCF	GPIO,GP1
	BCF	GPIO,GP4
	BSF	GPIO,GP5
	GOTO	MAIN		    ;VOLTA PRA MAIN PRA REINICIAR A DIGITALIZAÇÃO
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
