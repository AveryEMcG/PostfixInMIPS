	.data
    np: .asciiz "enter number: "
    op: .asciiz "enter operator: "
errstr: .asciiz "operator not supported"
   res: .asciiz "result: "



	.text

main:
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
	# at this point, t0 has left side, t1 has right side, and t2 has operator
	
add:    bne $t2, 43, sub
	# add t1 and t2 and jump to print result
	add $t3, $t0, $t1
	j pres

sub:    bne $t2, 45, mul
	sub $t3, $t0, $t1
	j pres

mul:    bne $t2, 42, div
	mul $t3, $t0, $t1
	j pres

div:    bne $t2, 47, err
	div $t3, $t0, $t1
	j pres

err:    la $a0, errstr
	li $v0, 5
	syscall
	
pres:   la $a0, res
	li $v0, 4
	syscall
	
	move $a0, $t3
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall
	
