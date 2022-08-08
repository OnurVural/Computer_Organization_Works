# Subprogram to reverse the order of bits in a decimal as a result.
.text
	lw	$t0, num
	
	# print message
	li	$v0, 4
	la	$a0, msgBegin 
	syscall 
	# Print number as hex from
	li 	$v0, 34
	add 	$a0, $zero, $t0
	syscall

	# prepare the argument
	move	$a0, $t0
	jal	reverseBits # call subprogram
	
	move	$t1, $v0    # get the return value
	
	
	# print message
	li	$v0, 4
	la	$a0, msgEnd 
	syscall
	# Print number as hex from
	li 	$v0, 34
	add 	$a0, $zero, $t1
	syscall
	#end program
	li	$v0, 10
		syscall
#-------------------------------------------------------------------------------------------------
# Subprogram to reverse bits
# @arg $a0: the number to be reversed
# @return $v0: the bitwise reversed number
reverseBits:
	# allocate memory
	addi	$sp, $sp, -20
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$s4, 0($sp)
	
	
	move	$s0, $a0 # get the number
	li	$s1, 1   # for comparing with the last bit
	add	$s2, $zero, $zero # for operation with last bit
	li	$s3, 31  # counter
	add	$s4, $zero, $zero # to hold final result	
	
	
for: 
	and	$s2, $s0, $s1	# in order to put last bit into result 
	srl	$s0, $s0, 1	# >> $s0 (to get in next bit)
	or	$s4, $s4, $s2	# or operatþon to merge the newest bit to the result	
	beq	$s3, $zero, exit
	sll	$s4, $s4, 1	# << $s4
	subi	$s3, $s3, 1	# i--
	j	for 
	
	
exit:
	move	$v0, $s4	
	# deallocate memory
	lw	$s4, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	addi	$sp, $sp, 20
	
	jr	$ra
#-------------------------------------------------------------------------------------------------

.data
num:		.word 	4160749730
msgBegin:	.asciiz "\nThe number before reverse operation: "
msgEnd:		.asciiz "\nThe number after reverse operation : "