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
		TEMPO		;VARIÁVEL QUE CONTA O TEMPO DE PERMANENCIA DA ONDA EM 1

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
	MOVLW	B'00110011' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS);GP2 COMO ENTRADA, GP0,1,4 E 5 COMO SAIDA
	MOVWF	TRISIO		;COMO SAÍDAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000000'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	BANK0				;RETORNA PARA O BANCO
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
	BTFSS	GPIO,GP2	;VERIFICA SE GP2 ESTÁ EM 1
	GOTO	MAIN		;CASO NÃO ESTEJA VOLTA PRO COMEÇO E FAZ O TESTE DE NOVO
	GOTO	CONTAGEM	;CASO ESTEJA EM 1 INICIA O CONTAGEM DO PERIODO DA ONDE EM 1
	
CONTAGEM
	CLRF	TMR0		;LIMPA O TIMER 0 PRA INICIAR A CONTAGEM
	BTFSC	GPIO,GP2	;VERIFICA SE GP2 ESTÁ EM 0  
	GOTO	CONTAGEM	;CASO NÃO ESTEJA VOLTA PRO INICIO DA CONTAGEM E REFAZ O TESTE	
	MOVFW	TMR0		;CASO ESTEJA EM 0 ARMAZENA O VALOR DO TIMER 0 NO WORK	
	MOVWF	TEMPO		;ARMAZENA O VALOR DO WORK NA VARIAVEL TEMPO
	CLRF	TMR0		;LIMPA O TIMER 0 PARA UMA FUTURA NOVA CONTAGEM
	ADDWF	TEMPO		;SOMA O VALOR DE WORK AO TEMPO(2 X TEMPO) PARA OBTER O PERIODO
	GOTO	CINCO_KHZ	;COM O PERIODO OBTIDO VAI PARA O PRIMEIRO TESTE

CINCO_KHZ
	MOVLW	.221		;MOVE VALOR 221 PARA O WORK
	SUBWF	TEMPO,W		;SUBTRAI O VALOR DO WORK DO TEMPO E ARMAZENA O RESULTADO NO WORK
	BTFSC	STATUS,C	;VERIFICA SE O RESULTADO DA OPERAÇÃO DEU NEGATIVO, INFERIOR A BORDA SUPERIOR
	GOTO	DEZ_KHZ		;CASO O VALOR SEJA POSITIVO VAI PARA O PROXIMO TESTE POIS NÃO PODE SER 5KHZ
	MOVLW	.179		;MOVE VALOR 179 PARA O WORK
	SUBWF	TEMPO,W		;SUBTRAI O VALOR DO WORK DO TEMPO E ARMAZENA O RESULTADO NO WORK
	BTFSS	STATUS,C	;VERIFICA SE O RESULTADO DA OPERAÇÃO DEU POSITIVO, SUPERIOR A BORDA INFERIOR
	GOTO	DEZ_KHZ		;CASO NEGATIVO VAI PARA O PROXIMO TESTE POIS NÃO PODE SER 5KHZ
	BSF	GPIO,GP0	;CASO POSITIVO SETA GP0 INDICANDO QUE A FREQUENCIA DO SINAL É 5KHZ
	
DEZ_KHZ
	MOVLW	.111		;MOVE VALOR 111 PARA O WORK
	SUBWF	TEMPO,W		;SUBTRAI O VALOR DO WORK DO TEMPO E ARMAZENA O RESULTADO NO WORK
	BTFSC	STATUS,C	;VERIFICA SE O RESULTADO DA OPERAÇÃO DEU NEGATIVO, INFERIOR A BORDA SUPERIOR
	GOTO	VINTE_KHZ	;CASO O VALOR SEJA POSITIVO VAI PARA O PROXIMO TESTE POIS NÃO PODE SER 10KHZ
	MOVLW	.89		;MOVE VALOR 89 PARA O WORK
	SUBWF	TEMPO,W		;SUBTRAI O VALOR DO WORK DO TEMPO E ARMAZENA O RESULTADO NO WORK
	BTFSS	STATUS,C	;VERIFICA SE O RESULTADO DA OPERAÇÃO DEU POSITIVO, SUPERIOR A BORDA INFERIOR
	GOTO	VINTE_KHZ	;CASO NEGATIVO VAI PARA O PROXIMO TESTE POIS NÃO PODE SER 10KHZ
	BSF	GPIO,GP1	;CASO POSITIVO SETA GP1 INDICANDO QUE A FREQUENCIA DO SINAL É 10KHZ

VINTE_KHZ
	MOVLW	.56		;MOVE VALOR 56 PARA O WORK
	SUBWF	TEMPO,W		;SUBTRAI O VALOR DO WORK DO TEMPO E ARMAZENA O RESULTADO NO WORK
	BTFSC	STATUS,C	;VERIFICA SE O RESULTADO DA OPERAÇÃO DEU NEGATIVO, INFERIOR A BORDA SUPERIOR
	GOTO	TRINTA_KHZ	;CASO O VALOR SEJA POSITIVO VAI PARA O PROXIMO TESTE POIS NÃO PODE SER 20KHZ
	MOVLW	.44		;MOVE VALOR 44 PARA O WORK
	SUBWF	TEMPO,W		;SUBTRAI O VALOR DO WORK DO TEMPO E ARMAZENA O RESULTADO NO WORK
	BTFSS	STATUS,C	;VERIFICA SE O RESULTADO DA OPERAÇÃO DEU POSITIVO, SUPERIOR A BORDA INFERIOR
	GOTO	TRINTA_KHZ	;CASO NEGATIVO VAI PARA O PROXIMO TESTE POIS NÃO PODE SER 20KHZ
	BSF	GPIO,GP4	;CASO POSITIVO SETA GP4 INDICANDO QUE A FREQUENCIA DO SINAL É 20KHZ

TRINTA_KHZ
	MOVLW	.38		;MOVE VALOR 38 PARA O WORK
	SUBWF	TEMPO,W		;SUBTRAI O VALOR DO WORK DO TEMPO E ARMAZENA O RESULTADO NO WORK
	BTFSC	STATUS,C	;VERIFICA SE O RESULTADO DA OPERAÇÃO DEU NEGATIVO, INFERIOR A BORDA SUPERIOR
	GOTO	FIM		;CASO O VALOR SEJA POSITIVO VAI PARA O FIM DO TESTE POIS NÃO PODE SER 30KHZ
	MOVLW	.29		;MOVE VALOR 29 PARA O WORK
	SUBWF	TEMPO,W		;SUBTRAI O VALOR DO WORK DO TEMPO E ARMAZENA O RESULTADO NO WORK
	BTFSS	STATUS,C	;VERIFICA SE O RESULTADO DA OPERAÇÃO DEU POSITIVO, SUPERIOR A BORDA INFERIOR
	GOTO	FIM		;CASO NEGATIVO VAI PARA O FIM DO TESTE POIS NÃO PODE SER 230KHZ
	BSF	GPIO,GP5	;CASO POSITIVO SETA GP5 INDICANDO QUE A FREQUENCIA DO SINAL É 30KHZ

FIM
	GOTO FIM

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
