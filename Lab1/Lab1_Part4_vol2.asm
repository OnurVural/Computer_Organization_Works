# Program that computes the mathematical formula A = (B + C *( D / C ) ) % B
.text
# input interface print
	li	$v0, 4
	la	$a0, WelcomeMsj
	syscall
#------------------------------		
# print prompt for B
	li	$v0, 4
	la	$a0, BPrompt
	syscall
# read B
	li	$v0, 5
	syscall
	move	$t0, $v0	  
#------------------------------
# print prompt for C
	li	$v0, 4
	la	$a0, CPrompt
	syscall
# read C
	li	$v0, 5
	syscall
	move	$t1, $v0
#------------------------------
# print prompt for D
	li	$v0, 4
	la	$a0, DPrompt
	syscall
# read D
	li	$v0, 5
	syscall
	move	$t2, $v0
#------------------------------
# Processsing data
# $t3 = D / C
	div	$t2, $t1
	mflo	$t3

# $t4 = C * $t3->(D / C)
	mult	$t1, $t3
	mflo	$t4
# $t5 = B + $t4 ->( C *(D / C)	)	
	add 	$t5, $t0, $t4
	 
# $t5 % B
	div	$t5, $t0	
	mfhi	$t5

# print result prompt
	li	$v0, 4
	la	$a0, resultPrompt
	syscall  
# print the result 
	li	$v0, 1
	move    $a0, $t5
	syscall
# end program
	li	$v0, 10
	syscall 
.data
WelcomeMsj:	.asciiz " Welcome to arithmatic expression calculator!\n->In order to evaluate A = (B + C*(D/C))% B please enter inputs...\n"
BPrompt:	.asciiz "Please enter B: "
CPrompt:	.asciiz "Please enter C: "
DPrompt:	.asciiz "Please enter D: "
resultPrompt:	.asciiz "The result of the expression (A) obtained from (B + C*(D/C))% B is: "