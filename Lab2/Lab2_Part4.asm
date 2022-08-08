# Subprogram to count the number of occurrences of the bit pattern stored in $a0 in $a1
.text
main:
	# print welcome msg
	li	$v0, 4
	la	$a0, WelcomePrompt
	syscall 
	
	# print welcome msg
	li	$v0, 4
	la	$a0, enter1
	syscall 
	
	li	$v0, 5
	syscall 
	move    $t0, $v0
	
	# print welcome msg
	li	$v0, 4
	la	$a0, enter2
	syscall 
	
	li	$v0, 5
	syscall 
	move    $t1, $v0
	
	# print welcome msg
	li	$v0, 4
	la	$a0, enter3
	syscall 
	
	li	$v0, 5
	syscall 
	move    $t2, $v0
	
	
	
	
	
	
	
	
	
	
	# print the pattern
	li	$v0, 4
	la	$a0, bitPatternPrompt
	syscall 
	
	li	$v0, 34
	move	$a0, $t1
	syscall 
	
	# print the number to search pattern
	li	$v0, 4
	la	$a0, numberPrompt
	syscall 
	
	li	$v0, 34
	move	$a0, $t0
	syscall 
	
	# print pattern size
	li	$v0, 4
	la	$a0, bitPSizePrompt
	syscall 
	
	li	$v0, 1
	move	$a0, $t2
	syscall
	
	#-------------------------------------------------------------
	# prepare arguments
	move	$a0, $t1 
	move	$a1, $t0
	move	$a2, $t2

	
	# invoke subprogram
	jal	NumBitPattern	
	# extract the return value
	move	$t0, $v0
	
	# print the result
	li	$v0, 4
	la	$a0, resultPrompt
	syscall 
	
	li	$v0, 1
	move	$a0, $t0
	syscall 
	
	# end program
	li	$v0, 10
	syscall 

#-----------------------------------------------------------------------------------------
# NumBitPattern:
# @param  $a0: the bit pattern itself
# @param  $a1: the number to check bit pattern
# @param  $a2: the size of bit pattern 
# @return $v0: the number of occurences of the given bit pattern
NumBitPattern:
	# Allocate space in memory
	addi	$sp, $sp, -28 	# we use 7 registers
	sw	$s0, 16($sp) 	# for putting the bit pattern
	sw	$s1, 12($sp) 	# for putting the bits to search the pattern
	sw	$s2, 8($sp) 	# for putting patternSize
	sw	$s3, 4($sp) 	# for total number of moves
	sw	$s4, 0($sp) 	# for iteration (i)
	sw	$s5, 0($sp) 	# to hold the current and operation value (bit check)
	sw	$s6, 0($sp) 	# to return the total num
	
	move	$s0, $a0 # load the bit-pattern
	move	$s1, $a1 # load the number to be checked 
	move	$s2, $a2 # load the pattern size
	
	# to find how many iterations is required in total
	addi	$s3, $s3, 32 
	div	$s3, $s2
	mflo	$s3 # how many moves we need
	
	add	$s4, $zero, $zero # i = 0
	add	$s5, $zero, $zero # not essential as it will be overwritten 
	add	$s6, $zero, $zero # total = 0
	
	
loop:
	beq	$s4, $s3, done	# while ( i < numOfMoves)
	and	$s5, $s0, $s1   # compare the least significant only - mask others
	beq	$s5, $s0, increment # check it being equal to bit pattern
cont:
	srlv	$s1, $s1, $s2	# shift by >> pattern size
	addi	$s4, $s4, 1 	# i = i + 1
	j loop
done:	
	# Deallocate space in memory
	move	$v0, $s6
	addi	$sp, $sp, 12
	jr	$ra

increment:
	addi	$s6, $s6, 1 # total = total + 1
	j	cont
	
#-----------------------------------------------------------------------------------------
.data
num:			.word -252645136
pattern:		.word 15
patternSize:		.word 4
WelcomePrompt:		.asciiz "\nThis program counts the number of occurrences of a specific bit pattern"
enter1:			.asciiz "\nPlease enter num: "
enter2:			.asciiz "\nPlease enter bit pattern: "
enter3:			.asciiz "\nPlease enter bitpattern size: "
bitPatternPrompt:	.asciiz "\nThe bit pattern is: "
numberPrompt:		.asciiz "\nThe number to check bit pattern is: "
bitPSizePrompt:		.asciiz "\nThe size of bit pattern is: " 
resultPrompt:		.asciiz "\nThe number of occurences for the bit pattern is: "
empty:			.asciiz "\n"
