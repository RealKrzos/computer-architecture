.data
	upper_boundary:	.word	1	# The upper boundary of a randomly generated number

	prompt1_1:	.asciiz	"Welcome to the game! Guess a number between 0 and "
	prompt1_2:	.asciiz	" try to guess the number, the one who's closer to it wins!\n"

	prompt2_1:		.asciiz	"\n===== ROUND "
	prompt2_2:		.asciiz	" ====="

.text
	main:
		# print the welcoming message
		li $v0, 4 
		la $a0, prompt1_1
		syscall

		li $v0, 1
		lw $a0, upper_boundary
		syscall

		li $v0, 4
		la $a0, prompt1_2
		syscall

		# initialise round number
		add $t7, $zero, $t7

	# ========= ARGUMENTS ============
	# $t7 - round counter
	# $t1 - generated number

	loop:

		# increment the round number
		 add $t7, $t7, 1

		# print ===== ROUND ===== 

		li $v0, 4
		la $a0, prompt2_1
		syscall

		li $v0, 1
		add $a0, $zero , $t7
		syscall

		li $v0, 4
		la $a0, prompt2_2
		syscall

		# generate random number withing game's set boundaries		

		li $v0, 41
		syscall
		add $t1, $zero, $a0

		# jump to the loops beginning
		j loop


	

		

		