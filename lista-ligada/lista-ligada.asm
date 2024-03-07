# Grupo:
# Amanda Kasat Baltor 13727210
# Arthur Queiroz Moura 13671532
# Lucas Issao Omati 13673090
# Miguel Prates Ferreira 13672745


.data 
	.align 0
	pedir_digitar_id: .asciz "Digite um id: "
	pedir_digitar_string: .asciz "Digite uma string: "
	pedir_digitar_numero_registros: .asciz "Digite a quantidade de registros: "
	falha_de_leitura: .asciz "Os dados digitados sao invalidos"
	
	printa_id: .asciz "\nID: "
	printa_string: .asciz "\nString: "
	
	.align 2
	ponteiro_inicial: .word -1
	string_buffer: .space 28
.text 
	.align 2
	.globl main




# s1: sempre guarda o valor do id do registro selecionado
# s2: sempre guarda o valor da string do registro selecionado
# s3: sempre guarda o valor do ponteiro para o inicio dos dados do pr�ximo registro
# s0: sempre guarda o valor do ponteiro anterior, que �  usado para fazer conex�es entre os registros
main:
	jal reg_input
	
	#Faz a aloca��o inicial e linka o registro inicial
	#la t6, ponteiro_inicial		#Guarda o ponteiro inicial em t6
	#sw s3, 0(t6)			#Guarda o ponteiro s3 no espa�o de mem�ria em t6
	
	#lw a3, ponteiro_inicial		#t6 guarda o ponteiro inicial
	
	jal printa_tudo
	j finaliza_programa

	
finaliza_programa:
	addi a7,zero,10
	ecall	

reg_input:#loop para ler todos os registros
	addi a7,zero,4	#digita a frase pedindo para digitar a quantidade de registros
	la a0, pedir_digitar_numero_registros
	ecall
	
	addi a7,zero,5 	#L� um n�mero inteiro do terminal
	ecall
	add t0,zero,a0	#Guarda o valor  lido em t0
	addi t0, t0, -1	#Decrementa t0, para o loop ficar at� o valor certo
	loop_registros:
		#empilhando:
		addi sp,sp,-4	#o sp vai pra posi��o para colocar um registrador ali
		sw ra, 0(sp)	#salva o RA na pilha
	
		addi t0, t0, -1	#Decrementa t0, para o loop ficar at� o valor certo
		jal reg_le_e_coloca_na_memoria	# le um registro por vez
		
		# dsempilhando:
		lw ra, 0(sp)	#volta o valor do RA original
		addi sp,sp,4	#o sp volta para a posi��o original
		
		#repetimos as leituras at� que o numero de registros seja diferente que zero:
		bne t0, zero, loop_registros
		

reg_le_e_coloca_na_memoria:#Chama tr�s fun��es principais para ler os dados digitados, alocar espa�o e copiar os dados para a mem�ria
	#empilha ra
	addi sp,sp,-4	#o sp vai pra posi��o para colocar um registrador ali
	sw ra, 0(sp)	#salva o RA na pilha
	
	jal reg_leitura_terminal	#L� os dados e guarda em s1 e s2
	jal reg_aloca		#aloca o registro e o ponteiro guardado est� em s3
	jal reg_colocado_memoria	#coloca s1,s2 no ponteiro s3
	
	
	#Verifica o conte�do do ponteiro inicial, se ele for igual a -1, ele linka de um jeito especial
	la t6, ponteiro_inicial		#t6 guarda o ponteiro inicial
	lw t5, 0(t6)			#t5 guarda o valor do ponteiro inicial
	addi t4,zero,-1			#t4 guarda o que deve ser verificado
	bne t5,t4,nao_linka_com_o_inicio	#Se o valor do ponteiro inicial for -1, ativa o branch
	linka_com_o_inicio:
		sw s3, 0(t6)			#Guarda o ponteiro s3 no espa�o de mem�ria em t6
		j link_final
	nao_linka_com_o_inicio:
		#Faz o link do s0 (ponteiro passado) com o s3(registro que acabou de ser criado)
		sw s3, 0(s0)			#Guarda o ponteiro s3 no espa�o de mem�ria em s0	
	link_final:
	addi s0,s3,32			#Copia a informa��o de s3 para s0, para ele ser o �ltimo final
	
	#desempilha ra
	lw ra, 0(sp)	#volta o valor do RA original
	addi sp,sp,4	#o sp volta para a posi��o original
	jr ra
reg_print:
	addi a7,zero,4	#printa para ir imprimindo o texto do id
	la a0, printa_id
	ecall
	
	addi a7,zero,1	#printa o id guardado em s1
	add a0,zero,s1
	ecall
	
	addi a7,zero,4	#printa a string do registro
	la a0, printa_string
	ecall
	
	addi a7,zero,4	#copia a referencia da string de s2 para a0 e printa ela
	add a0,zero,s2
	ecall	
	jr ra

reg_leitura_terminal:
	addi a7,zero,4	#digita a frase pedindo para digitar o ID
	la a0, pedir_digitar_id
	ecall
	
	addi a7,zero,5 	#L� um n�mero inteiro do terminal
	ecall
	add s1,zero,a0	#Guarda o valor do ID lido em s1
	
	addi a7,zero,4	#Pede para digitar a string de 28 caracteres
	la a0, pedir_digitar_string
	ecall
	
	addi a1,zero,28
	la a0,string_buffer
	addi a7,zero,8	#L� uma string de 28 bytes e guarda em a0
	ecall
	add s2,zero,a0	#Copia o ende�o de mem�ria do texto digitado e coloca em s2
	
	jr ra		#Retorna a fun��o
	

#Fun��o para alocar os registros na mem�ria. Ela cria o espa�o necess�rio e guarda o valor do ponteiro em s3
reg_aloca:
	addi a7,zero,9
	addi a0,zero,36
	ecall
	addi s3,a0,0
	jr ra

#Fun��o para colocar os dados de s1,s2 na mem�ria s3
reg_colocado_memoria:
	sw s1, 0(s3)	#Copia o inteiro guardado em s1 (ID) para a mem�ria em s3
	addi t4,s3,4	#t4 recebe o valor da mem�ria de s3+4, onde deve come�ar a escrever a string
	addi t5,s2,0	#copia o ponteiro de string de s2 para t5
	

	#t5 � o que aponta para onde o caractere deve ser copiado, da string lida pelo terminal, mas agora atuando como um contador
	#t4 � o que aponta para o caractere no texto (vindo de s3, mas atuando como um contador)
	#t6 � um registrador que serve apenas para transferir a informa��o de t6 para a regi�o de mem�ria de t7
	reg_colocado_memoria_loopstring:
		lb t6, 0(t5)	#copia o caractere referenciado em t5 e guarda em t6
		sb t6, 0(t4)	#copia o caractere guardado em t6 para a mem�ria referenciada por t4
		addi t5,t5,1	#adiciona 1 a t5 (copiar� o caractere seguinte no pr�ximo ciclo)
		addi t4,t4,1	#adiciona 1 a t4 (guardar� o caractere copiado na posi��o de mem�ria seguinte)
		bnez t6, reg_colocado_memoria_loopstring	#copia at� o '\0'
	
	#Ap�s o ciclo:
	addi t6,s3,32	#O ponteiro t6, usado antes como contador, recebe o s3+32, que � exatamente a posi��o onde deve ficar o ponteiro para o pr�ximo registro
	addi t5,zero,-1	#O ponteiro t5, usado antes como contador, recebe o valor de -1, que � o valor inicial do ponteiro para o pr�ximo registro
	sw t5, 0(t6)
	jr ra

le_registro:#printa o registro que est� sendo referenciado por s3 (atualiza s1 e s2 nesse processo)
	#empilha ra
	addi sp,sp,-8	#o sp vai pra posi��o para colocar um registrador ali
	sw ra, 0(sp)	#salva o RA na pilha
	sw s3, 4(sp)	#salva o s3 na pilha
	
	
	lw s1,0(s3)
	addi s2,s3,4
	jal reg_print
	
	#desempilha ra
	lw s3, 4(sp)	#volta o valor do RA original
	lw ra, 0(sp)	#volta o valor do s3 original
	addi sp,sp,8	#o sp vai pra posi��o para colocar um registrador ali
	
	jr ra
printa_tudo: #come�a com um ponteiro inicial s3 e vai chamando tudo 
	lw s3,ponteiro_inicial #vai para o inicio da lista
	printa_tudo_loop:
		addi sp,sp,-4	#o sp vai pra posi��o para colocar um registrador ali
		sw ra, 0(sp)	#salva o RA na pilha
		
		jal le_registro
		#Reorganiza o s3 para apontar para o pr�ximo registro da lista encadeada
		add s5,zero,s3		#L� o local onde est� o ponteiro e coloca nele mesmo
		addi s3,s3,32		#L� o local onde est� o ponteiro e coloca nele mesmo
		lw s3,0(s3)
		add s6,zero,s3		#L� o local onde est� o ponteiro e coloca nele mesmo
		
		lw ra, 0(sp)	#volta o valor do RA original
		addi sp,sp,4	#o sp volta para a posi��o original
		
		
		addi t6,zero,-1#Crit�rio de parada
		bne s3,t6,printa_tudo_loop
	jr ra
