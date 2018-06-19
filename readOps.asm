	.data
    np: .asciiz "enter number: "
    op: .asciiz "enter operator: "
errstr: .asciiz "operator not supported"
   res: .asciiz "result: "

	.text

main:

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
	
	li $v0, 10
	syscall
	
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
		
