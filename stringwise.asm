	.data
prompt:	.asciiz "enter a string: "
errstr: .asciiz "operator not supported"
   res: .asciiz "result: "
panic: .asciiz "HELLO\n"
	.text

	.macro exit
	li $v0, 10
	syscall
	.end_macro 

main:

	move $fp, $sp
	
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
	
	# allocate 128 bytes on the heap for storing seen numbers
	li $a0, 128
	li $v0, 9
	syscall
	move $s1, $v0
	# byte s1[128]
	
	# allocate 128 words on the heap for storing a stack of operands 
	li $a0, 512
	li $v0, 9
	syscall
	move $s2, $v0
	# int s2[128]
	
	la $t0, ($s0)

while:
	lb $t1, ($t0)
	beqz $t1, end
	sub $t2, $t1, '0'
	bltz $t2, temporary_panic
	bgt $t2, 9, temporary_panic
	# we know it's a digit
	
	#sb $s1 
	
	move $a0, $t1
	li $v0, 11
	syscall
	addi $t0, $t0, 1
	j while
	
temporary_panic:
	li $v0, 4
	la $a0, panic
	syscall
	
	
end:
	exit