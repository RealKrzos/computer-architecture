.data
RAM:    .space 4096    # assuming the array will not exceed 4096 bytes
row:    .word 0
col:    .word 0

prompt1: .asciiz "Set array rows: "
prompt2: .asciiz "Set array columns: "

prompt3: .asciiz "\nChoose action. Read (0) / Write (1)"
prompt4: .asciiz "Row: "
prompt5: .asciiz "Column: "
prompt6: .asciiz "Err. Must be 0 or 1."

# Variables
# $t0 - rows
# $t1 - columns
# $t2 - total number of bytes for the rows arr
# $t3 - address of the column arr, including byte offset

.text
main:
    ### Asking for columns and rows

    # Ask for rows
    li $v0, 4
    la $a0, prompt1
    syscall

    li $v0, 5
    syscall
    sw $v0, row     # Store the input value in row
    move $t0, $v0   # Move the input value to $t0

    # Ask for columns
    li $v0, 4
    la $a0, prompt2
    syscall

    li $v0, 5
    syscall
    sw $v0, col     # Store the input value in col
    move $t1, $v0   # Move the input value to $t1

    ### Calculations for the address array

    # Allocate memory for addresses
    sll $t2, $t0, 2      # 2 for int, 2^2 = 4, sll has lesser time complexity than mul
    la $t3, RAM
    addu $t3, $t3, $t2   # calculating byte offset in RAM, from the offset the second part of the array can begin

    jal fill_array

ask_for_action:
    # Ask for action
    li $v0, 4
    la $a0, prompt3
    syscall

    li $v0, 5
    syscall
    move $t0, $v0  # Move the input value to $t0 (or $a0)

    beq $t0, 0, read    # Branch if input is 0
    beq $t0, 1, write   # Branch if input is 1

    li $v0, 4
    la $a0, prompt6
    syscall

    j ask_for_action   # Jump back to the beginning to ask for action again

read:
    li $v0, 4
    la $a0, prompt4
    syscall

    li $v0, 5
    syscall
    move $t4, $v0    # Move the input value to $t4

    li $v0, 4
    la $a0, prompt5
    syscall

    li $v0, 5
    syscall
    move $t5, $v0    # Move the input value to $t5

    # Calculate the index in the array
    mul $t6, $t4, $t1   # Multiply row by column to get the index
    add $t6, $t6, $t5   # Add the column to the index
    sll $t6, $t6, 2     # Multiply the index by 4 to get the byte offset

    add $t6, $t6, $t3   # Add the byte offset to the address of the array
    lw $t7, 0($t6)      # Load the value at the calculated address

    # Print the value
    li $v0, 1
    move $a0, $t7
    syscall

    j ask_for_action   # Jump back to the beginning to ask for action again

write:
    li $v0, 4
    la $a0, prompt4
    syscall

    li $v0, 5
    syscall
    move $t4, $v0    # Move the input value to $t4

    li $v0, 4
    la $a0, prompt5
    syscall

    li $v0, 5
    syscall
    move $t5, $v0    # Move the input value to $t5

    # Calculate the index in the array
    mul $t6, $t4, $t1   # Multiply row by column to get the index
    add $t6, $t6, $t5   # Add the column to the index
    sll $t6, $t6, 2     # Multiply the index by 4 to get the byte offset

    add $t6, $t6, $t3   # Add the byte offset to the address of the array

    li $v0, 4
    la $a0, prompt5
    syscall

    li $v0, 5
    syscall
    move $t7, $v0    # Move the input value to $t7

    sw $t7, 0($t6)   # Store the value at the calculated address

    j ask_for_action   # Jump back to the beginning to ask for action again
    
fill_array:
    # Save the current address for later use
    move $t8, $ra

    # Initialize the row and column indices
    li $t4, 0   # i index
    li $t5, 0   # j index

fill_loop:
    # Calculate the value to be stored in the array
    mul $t6, $t4, 100    # i * 100
    addi $t7, $t5, 1     # j + 1
    add $t6, $t6, $t7    # i * 100 + (j + 1)

    # Calculate the index in the array
    mul $t9, $t4, $t1    # Multiply row by column
    add $t9, $t9, $t5    # Add the column to the index
    sll $t9, $t9, 2      # Multiply the index by 4 to get the byte offset
    add $t9, $t9, $t3    # Add the byte offset to the address of the array

    # Store the calculated value in the array
    sw $t6, 0($t9)

    # Update the column index
    addi $t5, $t5, 1

    # Check if the column index exceeds the total number of columns
    bge $t5, $t1, next_row

    j fill_loop

next_row:
    # Reset the column index to 0
    li $t5, 0

    # Update the row index
    addi $t4, $t4, 1

    # Check if the row index exceeds the total number of rows
    bge $t4, $t0, end_fill

    j fill_loop

end_fill:
    # Restore the address saved earlier
    move $ra, $t8

    # Return from the function
    jr $ra

end:
    li $v0, 10
    syscall
