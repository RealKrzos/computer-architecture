.data
RAM:	.space	4096	# zakładamy, że tablica nie przekroczy rozmiaru 4096 bajtów
row:	.word 0
col:	.word 0

prompt1: .asciiz "Set array rows: "
prompt2: .asciiz "Set array colums: "

prompt3: .asciiz "\nChoose action. Read (0) / Write (1)"
prompt4: .asciiz "Row: "
prompt5: .asciiz "Column: "
prompt6: .asciiz "Err. Must be 0 or 1."

#Variables
# $t0 - rows 
# $t1 - columns
# $t2 - total number of bytes for the rows arr
# $t3 - address of the column arr, included byte offset
# 

.text	
main:
	### Pytanie o kolumny i wiersze
	
	# Ask for rows 
	li $v0, 4
	la $a0, prompt1
	syscall
	
	li $v0, 5
	syscall
	sw $a0, row
	move $t0, $a0
	
	# Ask for columns
	li $v0, 4
	la $a0, prompt2
	syscall
	
	li $v0, 5
	syscall
	sw $a0, col
	move $t1, $a0
	
	### Obliczenia dla tablicy adresów
	
	# Allocate memory for adresses
	sll $t2, $t0, 2		# 2 for int, 2^2 = 4, sll has lesser time complexity than mul
	la $t3, RAM
	addu $t3, $t3, $t2	# calculating byte offset in RAM, from the offset the second part of the array can begin
	
	

	#Wypełnienie tablicy
	
	#infinite loop do odczytywania tablicy, index dla (3,4) = 4 * (row*3 + 4)
	
	
# $t0 - wprowadzona liczba przez użytkownika 
ask_for_action:
    # Ask for action
    li $v0, 4
    la $a0, prompt3
    syscall
    
    li $v0, 5
    syscall
    move $t0, $v0  # Move the input value to $t0 (or $a0)
    
    beq $v0, 0, read  # Branch if input is 0
    beq $a0, 1, write    # Branch if input is 1
    
    li $v0, 6
    la $a0, prompt4
    syscall
    
    j ask_for_action  # Jump back to the beginning to ask for action again

	
read:
	li $v0, 4
	la $a0, prompt4
	syscall

	j ask_for_action
write:
	li $v0, 4
	la $a0, prompt4
	syscall
	
	j ask_for_action

end:
	li $v0, 10
	syscall
