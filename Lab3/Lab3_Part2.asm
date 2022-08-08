# MIPS program to test recursive division of a positive number by subtraction 
.text
main:
	# print prompts
	li	$v0, 4
	la	$a0, WelcomeMsg
	syscall
	
	# print dividend prompt
	li	$v0, 4
	la	$a0, EnterDividend
	syscall
	
	# get first num from user
	li	$v0, 5
	syscall 
	move    $t0, $v0
	
	# print divisor prompt
	li	$v0, 4
	la	$a0, EnterDivisor
	syscall
	
	# get second num from user
	li	$v0, 5
	syscall 
	move    $t1, $v0
	#=========================================================
	# prepare the arguments
	add	$a0, $t0, $zero
	add	$a1, $t1, $zero
	# invoke the subprogram
	jal	RecursiveDivision
	#extract the result
	add	$t4, $v0, $zero
	add	$t5, $v1, $zero
	#=========================================================		
	
	# print result of division
	li	$v0, 4
	la	$a0, DivResult
	syscall
	
	li	$v0, 1
	add     $a0, $t4, $zero
	syscall 
	
	# print result of remainder
	li	$v0, 4
	la	$a0, RemResult
	syscall
	
	li	$v0, 1
	add     $a0, $t5, $zero
	syscall 
	
	li	$t6, 1 # to check user decision to continue or not
	
ask:
	# ask user to continue or not
	li	$v0, 4
	la	$a0, ContMsg
	syscall
	
	li	$v0, 5
	syscall 
	move    $t3, $v0
	
	# Double defense technique: the user needs to enter either 0 or 1 or we will keep asking the question
	beq	$t3, $zero, exit
	bne	$t3, $t6, ask 
	j main

exit:   # end program
	li	$v0, 4
	la	$a0, Arch_Sig
	syscall
			
	li 	$v0, 10
	syscall

#=================================================================
# RecursiveDivision: calculates result of integer divison recursively
# @param  $a0: the dividend
# @param  $a1: the divisor
# @return $v0: the result of division
# @return $v1: the remainder of division
RecursiveDivision:
	# Allocate Memory
	addi 	$sp, $sp, -12
	sw  	$a0, 8($sp) # store dividend
	sw   	$a1, 4($sp) # store divisor
	sw   	$ra, 0($sp) # store $ra
	
	# BASE CASE: if ( dividend < divisor )=> return 0
	bge  	$a0, $a1, else # if ( dividend < divisor )
	add 	$v0, $zero, $zero # to return 0
	add 	$v1, $a0, $zero # return dividend
	addi	$sp, $sp, 12 # restore $sp	
	jr	$ra # return
	
	# RECURSIVE CASE: else => return RecursiveDivision( dividend - divisor, divisor ) + 1;  
else:	
	sub	$a0, $a0, $a1 # dividend = dividend - divisor
	jal	RecursiveDivision # recursive call
	lw	$ra, 0($sp)  # restore $ra
	lw   	$a1, 4($sp)  # restore $a1
	lw  	$a0, 8($sp)  # restore $a0
	addi	$sp, $sp, 12 # restore $sp
	addi	$v0, $v0, 1  # RecursiveDivision( dividend - divisor, divisor ) + 1
	add	$v1, $v1, $zero  # remainder is obtained by recursive call itself
	jr	$ra # return
#=================================================================
.data
WelcomeMsg:   .asciiz "\n========= recursive divison calculator ============"
EnterDividend: .asciiz "\nPlease enter the dividend:  "	
EnterDivisor:  .asciiz "\nPlease enter the divisor:  "	
DivResult:     .asciiz "\nThe result of the division is: "	
RemResult:     .asciiz "\nWith remainder of : "
ContMsg:      .asciiz "\nDo you want to continue? (Press 0 to exit, 1 to continue): "  
Arch_Sig:     .asciiz "\n********************\n*Made by Onur Vural* \n********************"  
