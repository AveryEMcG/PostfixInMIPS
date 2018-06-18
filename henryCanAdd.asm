# read integer from user
li $v0, 5
syscall

move $t0, $v0 # save result of read 

# read integer from user
li $v0, 5
syscall

move $t1, $v0 # save result of read 

add  $t2, $t0, $t1

li $v0, 1 # print integer at $a0
move $a0, $t2

syscall