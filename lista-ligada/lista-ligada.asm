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
# s3: sempre guarda o valor do ponteiro para o inicio dos dados do próximo registro
# s0: sempre guarda o valor do ponteiro anterior, que é  usado para fazer conexões entre os registros
main:
	jal reg_input
	
	#Faz a alocação inicial e linka o registro inicial
	#la t6, ponteiro_inicial		#Guarda o ponteiro inicial em t6
	#sw s3, 0(t6)			#Guarda o ponteiro s3 no espaço de memória em t6
	
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
	
	addi a7,zero,5 	#Lê um número inteiro do terminal
	ecall
	add t0,zero,a0	#Guarda o valor  lido em t0
	addi t0, t0, -1	#Decrementa t0, para o loop ficar até o valor certo
	loop_registros:
		#empilhando:
		addi sp,sp,-4	#o sp vai pra posição para colocar um registrador ali
		sw ra, 0(sp)	#salva o RA na pilha
	
		addi t0, t0, -1	#Decrementa t0, para o loop ficar até o valor certo
		jal reg_le_e_coloca_na_memoria	# le um registro por vez
		
		# dsempilhando:
		lw ra, 0(sp)	#volta o valor do RA original
		addi sp,sp,4	#o sp volta para a posição original
		
		#repetimos as leituras até que o numero de registros seja diferente que zero:
		bne t0, zero, loop_registros
		

reg_le_e_coloca_na_memoria:#Chama três funções principais para ler os dados digitados, alocar espaço e copiar os dados para a memória
	#empilha ra
	addi sp,sp,-4	#o sp vai pra posição para colocar um registrador ali
	sw ra, 0(sp)	#salva o RA na pilha
	
	jal reg_leitura_terminal	#Lê os dados e guarda em s1 e s2
	jal reg_aloca		#aloca o registro e o ponteiro guardado está em s3
	jal reg_colocado_memoria	#coloca s1,s2 no ponteiro s3
	
	
	#Verifica o conteúdo do ponteiro inicial, se ele for igual a -1, ele linka de um jeito especial
	la t6, ponteiro_inicial		#t6 guarda o ponteiro inicial
	lw t5, 0(t6)			#t5 guarda o valor do ponteiro inicial
	addi t4,zero,-1			#t4 guarda o que deve ser verificado
	bne t5,t4,nao_linka_com_o_inicio	#Se o valor do ponteiro inicial for -1, ativa o branch
	linka_com_o_inicio:
		sw s3, 0(t6)			#Guarda o ponteiro s3 no espaço de memória em t6
		j link_final
	nao_linka_com_o_inicio:
		#Faz o link do s0 (ponteiro passado) com o s3(registro que acabou de ser criado)
		sw s3, 0(s0)			#Guarda o ponteiro s3 no espaço de memória em s0	
	link_final:
	addi s0,s3,32			#Copia a informação de s3 para s0, para ele ser o último final
	
	#desempilha ra
	lw ra, 0(sp)	#volta o valor do RA original
	addi sp,sp,4	#o sp volta para a posição original
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
	
	addi a7,zero,5 	#Lê um número inteiro do terminal
	ecall
	add s1,zero,a0	#Guarda o valor do ID lido em s1
	
	addi a7,zero,4	#Pede para digitar a string de 28 caracteres
	la a0, pedir_digitar_string
	ecall
	
	addi a1,zero,28
	la a0,string_buffer
	addi a7,zero,8	#Lê uma string de 28 bytes e guarda em a0
	ecall
	add s2,zero,a0	#Copia o endeço de memória do texto digitado e coloca em s2
	
	jr ra		#Retorna a função
	

#Função para alocar os registros na memória. Ela cria o espaço necessário e guarda o valor do ponteiro em s3
reg_aloca:
	addi a7,zero,9
	addi a0,zero,36
	ecall
	addi s3,a0,0
	jr ra

#Função para colocar os dados de s1,s2 na memória s3
reg_colocado_memoria:
	sw s1, 0(s3)	#Copia o inteiro guardado em s1 (ID) para a memória em s3
	addi t4,s3,4	#t4 recebe o valor da memória de s3+4, onde deve começar a escrever a string
	addi t5,s2,0	#copia o ponteiro de string de s2 para t5
	

	#t5 é o que aponta para onde o caractere deve ser copiado, da string lida pelo terminal, mas agora atuando como um contador
	#t4 é o que aponta para o caractere no texto (vindo de s3, mas atuando como um contador)
	#t6 é um registrador que serve apenas para transferir a informação de t6 para a região de memória de t7
	reg_colocado_memoria_loopstring:
		lb t6, 0(t5)	#copia o caractere referenciado em t5 e guarda em t6
		sb t6, 0(t4)	#copia o caractere guardado em t6 para a memória referenciada por t4
		addi t5,t5,1	#adiciona 1 a t5 (copiará o caractere seguinte no próximo ciclo)
		addi t4,t4,1	#adiciona 1 a t4 (guardará o caractere copiado na posição de memória seguinte)
		bnez t6, reg_colocado_memoria_loopstring	#copia até o '\0'
	
	#Após o ciclo:
	addi t6,s3,32	#O ponteiro t6, usado antes como contador, recebe o s3+32, que é exatamente a posição onde deve ficar o ponteiro para o próximo registro
	addi t5,zero,-1	#O ponteiro t5, usado antes como contador, recebe o valor de -1, que é o valor inicial do ponteiro para o próximo registro
	sw t5, 0(t6)
	jr ra

le_registro:#printa o registro que está sendo referenciado por s3 (atualiza s1 e s2 nesse processo)
	#empilha ra
	addi sp,sp,-8	#o sp vai pra posição para colocar um registrador ali
	sw ra, 0(sp)	#salva o RA na pilha
	sw s3, 4(sp)	#salva o s3 na pilha
	
	
	lw s1,0(s3)
	addi s2,s3,4
	jal reg_print
	
	#desempilha ra
	lw s3, 4(sp)	#volta o valor do RA original
	lw ra, 0(sp)	#volta o valor do s3 original
	addi sp,sp,8	#o sp vai pra posição para colocar um registrador ali
	
	jr ra
printa_tudo: #começa com um ponteiro inicial s3 e vai chamando tudo 
	lw s3,ponteiro_inicial #vai para o inicio da lista
	printa_tudo_loop:
		addi sp,sp,-4	#o sp vai pra posição para colocar um registrador ali
		sw ra, 0(sp)	#salva o RA na pilha
		
		jal le_registro
		#Reorganiza o s3 para apontar para o próximo registro da lista encadeada
		add s5,zero,s3		#Lê o local onde está o ponteiro e coloca nele mesmo
		addi s3,s3,32		#Lê o local onde está o ponteiro e coloca nele mesmo
		lw s3,0(s3)
		add s6,zero,s3		#Lê o local onde está o ponteiro e coloca nele mesmo
		
		lw ra, 0(sp)	#volta o valor do RA original
		addi sp,sp,4	#o sp volta para a posição original
		
		
		addi t6,zero,-1#Critério de parada
		bne s3,t6,printa_tudo_loop
	jr ra
