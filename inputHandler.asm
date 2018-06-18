.data

     text:  .asciiz "Enter 2 digits (with a return line after each) and a character. The program will repeat it back to you."

.text

 main:
 
    # Printing out the text
    li $v0, 4
    la $a0, text
    syscall

    # getting first integer
    li $v0, 5
    syscall
    # saving output to t0
    move $t0, $v0
    
    # getting second integer
    li $v0, 5
    syscall
    # saving output to t0
    move $t1, $v0
    
    # Getting the character
    li $v0, 12
    syscall
    # saving output to t0
    move $t2, $v0
    
 
    # Printing out the first number
    li $v0, 1
    move $a0, $t0
    syscall

 
    # Printing out the second number
    li $v0, 1
    move $a0, $t1
    syscall
    
    # Printing out the character
    li $v0, 11
    move $a0, $t2
    syscall



    # End Program
    li $v0, 10
    syscall
