	.data
    np: .asciiz "enter number: "
    op: .asciiz "enter operator: "
errstr: .asciiz "operator not supported"
   res: .asciiz "result: "

	.text

main:

	move $fp, $sp
	addi $sp, $sp -16
	
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
	sw $t0, 16($sp)
	sw $t1, 12($sp)
	
add:    bne $t2, 43, sub
	jal addOperation
	j pres

sub:    bne $t2, 45, mul
	jal subOperation
	j pres

mul:    bne $t2, 42, div
	jal multOperation
	j pres

div:    bne $t2, 47, err
	jal divOperation
	j pres

err:    la $a0, errstr
	li $v0, 5
	syscall
	
pres:   
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
	sw $ra, 8($sp) # push return program counter to stack
	sw $fp, 4($sp) # push value of current frame pointer to stack
	move $fp, $sp
	
	lw $t0, 16($fp)
	lw $t1, 12($fp)
	
	add $v0, $t0, $t1
	
	lw $t0, 8($fp)
	jr $t0
	
subOperation:   
	sw $ra, 8($sp) # push return program counter to stack
	sw $fp, 4($sp) # push value of current frame pointer to stack
	move $fp, $sp
	
	lw $t0, 16($fp)
	lw $t1, 12($fp)
	
	sub $v0, $t0, $t1
	
	lw $t0, 8($fp)
	jr $t0	
	
divOperation:   
	sw $ra, 8($sp) # push return program counter to stack
	sw $fp, 4($sp) # push value of current frame pointer to stack
	move $fp, $sp
	
	lw $t0, 16($fp)
	lw $t1, 12($fp)
	
	div $v0, $t0, $t1
	
	lw $t0, 8($fp)
	jr $t0	
	
multOperation:   
	sw $ra, 8($sp) # push return program counter to stack
	sw $fp, 4($sp) # push value of current frame pointer to stack
	move $fp, $sp
	
	lw $t0, 16($fp)
	lw $t1, 12($fp)
	
	mul $v0, $t0, $t1
	
	lw $t0, 8($fp)
	jr $t0	
		