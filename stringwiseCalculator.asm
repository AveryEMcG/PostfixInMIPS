	.data
prompt:	.asciiz "enter a string: "
errstr: .asciiz "operator not supported"
   res: .asciiz "result: "
panic: .asciiz "BRONT has occurred\n"
    np: .asciiz "enter number: "
    op: .asciiz "enter operator: "

	.text

	.macro PRINTINT
	li $v0, 1
	syscall
	
	li $a0, '\n'
	li $v0, 11
	syscall
	.end_macro
	


	.macro exit
	li $v0, 10
	syscall
	.end_macro 
	
	.macro BRONT
	$t2
	.end_macro

main:

	move $fp, $sp
	
	#print output to user
	la $a0, prompt
	li $v0, 4
	syscall
	
	# allocate 128 bytes on the heap for the string input
	li $a0, 128
	li $v0, 9
	syscall
	
	# char * s0 = string input
	move $s0, $v0

	# read max 128 bytes from the user
	move $a0, $s0
	li $a1, 128
	li $v0, 8
	syscall
	
	# allocate 128 words on the heap for storing a stack of operands 
	li $a0, 512
	li $v0, 9
	syscall
	move $s2, $v0
	
	# int s2[128]
	
	la $t0, ($s0)
	
	#initializing the beginning of our integer array
	li $t3, 0
	sw $t3, ($s2)
	
	move $s3, $s2
	
	
while:
	lb $t1, ($t0)
	beqz $t1, end
	sub $t2, $t1, '0'
	
	bltz $t2, temporary_panic
	bgt $t2, 9, temporary_panic
	# we know it's a digit
	
	lw $t4, ($s3)
	li $t5, 10
	
	#BRONT
	
	mult $t4, $t5
	mflo $t6

	add $t6, $t6, $t2
	move $a0, $t6
	sw $t6, ($s3)
	
	move $a0, $t6
	PRINTINT
	
	addi $t0, $t0, 1
	
	
	j while
	
temporary_panic:
	li $v0, 4
	la $a0, panic
	syscall
	
	j end
	
	#a0 will contain the point in memory where the characters end
	
convertCharsToInt:
	addi $sp, $sp -8
	sw $ra, 4($sp) # push return program counter to stack
	sw $fp, 0($sp) # push value of current frame pointer to stack
	move $fp, $sp
	


calculate:
	addi $sp, $sp -8
	sw $ra, 4($sp) # push return program counter to stack
	sw $fp, 0($sp) # push value of current frame pointer to stack
	move $fp, $sp
	
	la $a0, np
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall

	move $t0, $v0

	la $a0, np
	li $v0, 4
	syscall

	li $v0, 5
	syscall	

	move $t1, $v0

	la $a0, op
	li $v0, 4
	syscall
	
	li $v0, 12
	syscall
	
	move $t2, $v0
	
	move $a0, $t0
	move $a1, $t1
	
add:    bne $t2, 43, sub
	jal addOperation
	j pres

sub:    bne $t2, 45, mul
	jal subOperation
	j pres

mul:    bne $t2, 42, div
	jal multOperation
	j pres

div:    bne $t2, 47, pow
	jal divOperation
	j pres
	
pow:    bne $t2, 94, err
	jal powOperation
	j pres
	

err:    la $a0, errstr
	li $v0, 5
	syscall
	
pres:
	move $sp, $fp   
	move $t3, $v0
	la $a0, res
	li $v0, 4
	syscall
	
	move $a0, $t3
	li $v0, 1
	syscall
	
	#return to caller
	lw $fp, 0($sp)
	lw $ra, 4($sp)
	jr $ra	
	
addOperation:   
	addi $sp, $sp -8
	sw $ra, 4($sp) # push return program counter to stack
	sw $fp, 0($sp) # push value of current frame pointer to stack
	move $fp, $sp
	
	#lw $t0, 16($fp)
	#lw $t1, 12($fp)
	
	add $v0, $a0, $a1
	
	lw $fp, 0($sp)
	
	
	jr $ra
	
subOperation:   
	addi $sp, $sp -8
	sw $ra, 4($sp) # push return program counter to stack
	sw $fp, 0($sp) # push value of current frame pointer to stack
	move $fp, $sp
	
	#lw $t0, 16($fp)
	#lw $t1, 12($fp)
	
	sub $v0, $a0, $a1
	
	lw $fp, 0($sp)
	
	
	jr $ra
	
divOperation:   
	addi $sp, $sp -8
	sw $ra, 4($sp) # push return program counter to stack
	sw $fp, 0($sp) # push value of current frame pointer to stack
	move $fp, $sp
	
	#lw $t0, 16($fp)
	#lw $t1, 12($fp)
	
	div $v0, $a0, $a1
	
	lw $fp, 0($sp)
	
	jr $ra	
	
multOperation:   
	addi $sp, $sp -8
	sw $ra, 4($sp) # push return program counter to stack
	sw $fp, 0($sp) # push value of current frame pointer to stack
	move $fp, $sp
	
	#lw $t0, 16($fp)
	#lw $t1, 12($fp)
	
	mul $v0, $a0, $a1
	
	lw $fp, 0($sp)
	
	jr $ra	

powOperation:
	addi $sp, $sp -8
	sw $ra, 4($sp) # push return program counter to stack
	sw $fp, 0($sp) # push value of current frame pointer to stack
	move $fp, $sp

        beq $a1, 0, basePow #if we got 0th power, 
	j recursePow


basePow:
        li $v0 1 #any number raised to the 0th power will always return 1
        j endPow
       
recursePow:
        addi $a1, $a1, -1 #decrement power
        jal powOperation #recurse
	move $sp, $fp 
	move $t0 $v0
        mul $v0 $a0 $t0 #multiply result by the base and pass it up
	j endPow 
endPow:
	lw $fp, 0($sp)
	lw $ra, 4($sp)
	jr $ra	
		
	
end:
	exit
