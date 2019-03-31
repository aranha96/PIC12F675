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
		ENTRADA		;FILE DE ENTRADO EM HEXADECIMAL
		DADO		;FILE DE SAÍDA
		QUOCIENTE	;QUOCIENTE DA DIVISÃO
		DIVIDENDO	;VALOR A SER DIVIDIDO

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
	MOVLW	B'00000000' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000100'
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
	MOVLW	0XFF	    ;MOVER O VALOR HEXADECIMAL PARA O WORK
	MOVWF	ENTRADA	    ;MOVER O VALOR DO WORK PARA O FILE ENTRADA
	CLRF	QUOCIENTE   ;LIMPAR O VALOR DO FILE QUOCIENTE
	CLRF	DADO	    ;LIMPAR O VALOR DO FILE DADO
	MOVWF	DIVIDENDO   ;MOVER O VALOR DO WORK PARA O FILE DIVIDENDO
	MOVLW	.10	    ;MOVER O VALOR 10 PARA O WORK
	GOTO	UNIDADE	    ;IR PARA A SESSÃO DE DIVISÃO PARA SE OBTER A UNIDADE
	
UNIDADE
	SUBWF	DIVIDENDO   ;SUBTRAIR O VALOR 10 NO WORK DO VALOR CONTIDO NO DIVIDENDO, ARMAZENA O RESULTADO NO DIVIDENDO
	INCF	QUOCIENTE   ;INCREMENTA EM 1 O QUOCIENTE PARA CADA OPERAÇÃO DE SUBTRAÇÃO
	BTFSC	STATUS,Z    ;VERIFICA SE A OPERAÇÃO NÃO RESULTOU EM ZERO
	GOTO	EXATO_U	    ;CASO RESULTADO SEJA ZERO IR PARA O SETOR DE SOLUÇÃO EXATA PARA A CASA DA UNIDADE
	BTFSC	STATUS,C    ;VERIFICA SE A OPERAÇÃO DEU NEGATIVA
	GOTO	UNIDADE	    ;SE NÃO DEU NEGATIVA VOLTAR PARA O COMEÇO DA DIVISÃO E INICIAR MAIS UM ITERAÇÃO
	GOTO	RESTO_U	    ;SE RESULTADO FOR NEGATIVO PARTIR PARA OBTER O RESTO E O QUOCIENTE DA OPERAÇÃO

EXATO_U
	MOVLW	.0	    ;MOVER O VALOR ZERO PARA O WORK 
	MOVWF	DADO	    ;MOVER O VALOR DO WORK PARA O FILE DADO
	MOVFW	QUOCIENTE   ;MOVER O VALOR DO FILE QUOCIENTE PARA O WORK
	MOVWF	DIVIDENDO   ;MOVER O VALOR DO WORK PARA O FILE DIVIDENDO
	CLRF	QUOCIENTE   ;LIMPAR O FILE QUOCIENTE
	GOTO	DEZENA	    ;IR PARA A SESSÃO DE DIVISÃO PARA OBTER A DEZENA

RESTO_U
	ADDWF	DIVIDENDO,W ;COMO O VALOR DO DIVIDENDO ESTA NEGATIVO(COMPLEMENTO) SOMA O VALOR DO WORK PARA RECUPERAR O RESTO, SOLUÇÃO ARMAZENADA NO WORK
	DECF	QUOCIENTE   ;DECREMENTO O QUOCIENTE EM 1 PARA OBTER SEU VALOR VERDADEIRO
	MOVWF	DADO	    ;MOVE O VALOR DO RESTO DA OPERAÇÃO CONTIDO NO WORK PARA O FILE DADO(SAÍDA)
	MOVFW	QUOCIENTE   ;MOVE O VALOR DO FILE QUOCIENTE PARA O WORK
	MOVWF	DIVIDENDO   ;MOVE O VALOR DO WORK PARA O FILE DIVIDENDO
	CLRF	QUOCIENTE   ;LIMPAR O FILE QUOCIENTE
	GOTO	DEZENA	    ;IR PARA A SESSÃO DE DIVISÃO PARA OBTER A DEZENA

DEZENA
	MOVLW	.10	    ;MOVER O VALOR 10 PARA O WORK
	SUBWF	DIVIDENDO   ;SUBTRAIR O VALOR 10 NO WORK DO VALOR CONTIDO NO DIVIDENDO, ARMAZENA O RESULTADO NO DIVIDENDO
	INCF	QUOCIENTE   ;INCREMENTA EM 1 O QUOCIENTE PARA CADA OPERAÇÃO DE SUBTRAÇÃO
	BTFSC	STATUS,Z    ;VERIFICA SE A OPERAÇÃO NÃO RESULTOU EM ZERO
	GOTO	EXATO_D	    ;CASO RESULTADO SEJA ZERO IR PARA O SETOR DE SOLUÇÃO EXATA PARA A CASA DA DEZENA
	BTFSC	STATUS,C    ;VERIFICA SE A OPERAÇÃO DEU NEGATIVA
	GOTO	DEZENA	    ;SE NÃO DEU NEGATIVA VOLTAR PARA O COMEÇO DA DIVISÃO E INICIAR MAIS UM ITERAÇÃO
	GOTO	RESTO_D	    ;SE RESULTADO FOR NEGATIVO PARTIR PARA OBTER O RESTO E O QUOCIENTE DA OPERAÇÃO
	
EXATO_D
	MOVLW	.0	    ;MOVER O VALOR ZERO PARA O WORK
	IORWF	DADO	    ;REALIZAR UMA OPERAÇÃO DE OR ENTRE O WORK E O FILE DADO
	MOVFW	QUOCIENTE   ;MOVER O VALOR DO FILE QUOCIENTE PARA O WORK
	MOVWF	DIVIDENDO   ;MOVER O VALOR DO WORK PARA O FILE DIVIDENDO
	CLRF	QUOCIENTE   ;LIMPAR O FILE QUOCIENTE
	GOTO	CENTENA	    ;IR PARA A SESSÃO DE DIVISÃO PARA OBTER A CENTENA
	
RESTO_D
	ADDWF	DIVIDENDO   ;COMO O VALOR DO DIVIDENDO ESTA NEGATIVO(COMPLEMENTO) SOMA O VALOR DO WORK PARA RECUPERAR O RESTO, SOLUÇÃO ARMAZENADA NO DIVIDENDO
	DECF	QUOCIENTE   ;DECREMENTO O QUOCIENTE EM 1 PARA OBTER SEU VALOR VERDADEIRO   
	MOVFW	DADO	    ;MOVER O VALOR DO FILE DADO PARA O WORK
	SWAPF	DIVIDENDO   ;TROCA DE LUGAR OS 4 BITS MENOS SIGNIFICATIVOS COM OS MAIS SIGNIFICATIVOS
	IORWF	DIVIDENDO,W ;REALIZAR UMA OPERAÇÃO DE OR ENTRE O WORK E O FILE DIVIDENDO, ARMAZENA SOLUÇÃO NO WORK
	MOVWF	DADO	    ;MOVER O VALOR DO WORK PARA O FILE DADO(SAÍDA)
	BTFSC	STATUS,Z    ;SE O QUOCIENTE FOR ZERO SIGNIFICA QUE A ENTRADA NÃO POSSUI CENTENA
	GOTO	EXATO_C	    ;IR PARA A SESSÃO ONDE O WORK RECEBE ZERO
	MOVFW	QUOCIENTE   ;MOVE O VALOR DO FILE QUOCIENTE PARA O WORK	
	MOVWF	DIVIDENDO   ;MOVE O VALOR DO WORK PARA O FILE DIVIDENDO
	CLRF	QUOCIENTE   ;LIMPA O QUOCIENTE
	GOTO	CENTENA	    ;IR PARA A SESSÃO DE DIVISÃO PARA OBTER A CENTENA
	
CENTENA
	MOVLW	.10	    ;MOVER O VALOR 10 PARA O WORK
	SUBWF	DIVIDENDO   ;SUBTRAIR O VALOR 10 NO WORK DO VALOR CONTIDO NO DIVIDENDO, ARMAZENA O RESULTADO NO DIVIDENDO
	BTFSC	STATUS,C    ;VERIFICA SE A OPERAÇÃO DEU NEGATIVA
	GOTO	CENTENA	    ;SE NÃO DEU NEGATIVA VOLTAR PARA O COMEÇO DA DIVISÃO E INICIAR MAIS UM ITERAÇÃO
	GOTO	RESTO_C	    ;SE RESULTADO FOR NEGATIVO PARTIR PARA OBTER O RESTO E O QUOCIENTE DA OPERAÇÃO

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
