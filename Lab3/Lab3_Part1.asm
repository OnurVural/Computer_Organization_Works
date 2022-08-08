# Program to count the number of add and lw instructions.
.text
main: 

	lw	$t3, int	# lwCount++
	# TEST FOR MAIN PROGRAM
	# prepare the arguments 
	la 	$a0, main
	la 	$a1, exit

	jal	instructionCount  # try for main 
	
	# extract the results
	add	$t0, $v0, $zero # addCount++
	add	$t1, $v1, $zero # addCount++	
	
	# print msg main
	li	$v0, 4
	la	$a0, main_Prompt
	syscall
	
	# print msg add number
	li	$v0, 4
	la	$a0, num_add_Prompt
	syscall
	
	# print add number
	li	$v0, 1
	add	$a0, $t0, $zero # addCount++
	syscall
	
	# print msg lw number
	li	$v0, 4
	la	$a0, num_lw_Prompt
	syscall
		
	# print lw number
	li	$v0, 1
	add	$a0, $t1, $zero # addCount++
	syscall
	
	# TEST FOR SUB PROGRAM
	# prepare the arguments 
	la 	$a0, instructionCount
	la 	$a1, instructionCountEnd

	jal	instructionCount  # try for main 
	
	# extract the results
	add	$t0, $v0, $zero # addCount++
	add	$t1, $v1, $zero # addCount++	
	
	# print msg sub
	li	$v0, 4
	la	$a0, sub_Prompt
	syscall
	
	# print msg add number
	li	$v0, 4
	la	$a0, num_add_Prompt
	syscall
	
	# print add number
	li	$v0, 1
	add	$a0, $t0, $zero # addCount++
	syscall
	
	# print msg lw number
	li	$v0, 4
	la	$a0, num_lw_Prompt
	syscall
		
	# print lw number
	li	$v0, 1
	add	$a0, $t1, $zero # addCount++
	syscall

exit:	# end program
	li	$v0, 4
	la	$a0, Arch_Sig
	syscall
			
	li 	$v0, 10
	syscall

#=================================================================
# instructionCount: subprogram that count number of "add" and "lw" instructions
# @param:  $a0: starting address to check the instrucitons ( start of range)
# @param:  $a1: ending address to check the instrucitons ( end of range)
# @return: $v0: number of add instructions
# @return: $v1: number of lw instructions
instructionCount:
	# Allocate Memory
	addi	$sp, $sp, -28
	sw	$s0, 24($sp)
	sw	$s1, 20($sp)
	sw	$s2, 16($sp)
	sw	$s3, 12($sp)
	sw	$s4, 8($sp)
	sw	$s5, 4($sp)
	sw	$s6, 0($sp)
	
	add	$s0, $a0, $zero # addCount++
	add	$s1, $a1, $zero # addCount++
	add	$s2, $zero, $zero # to hold current instruction # addCount++
	add	$s3, $zero, $zero # to hold number of add instructions # addCount++
	add	$s4, $zero, $zero # to hold number of lw instructions # addCount++
	addi	$s5, $zero, 32
	addi	$s6, $zero, 35
next:
	bgt	$s0, $s1, done	
	lw	$s2, 0($s0) # get the current instruction # lwCount++
	
	srl	$s2, $s2, 26 # get only the first 6 bits
	bne	$s2, $zero, cont1
	lw	$s2, 0($s0) # lwCount++
	andi	$s2, $s2, 63 # mask all the other bits
	beq	$s2, $s5, increment_add
	
cont1: 
	lw	$s2, 0($s0) # get the current instruction # lwCount++
	srl	$s2, $s2, 26
	# andi	$s2, $s2, 0x111111 # mask all the other bits
	beq	$s2, $s6, increment_lw
cont2:		
	addi	$s0, $s0, 4 # pass to next instruction address	
	j	next
	

	
done:
	# place results into return values
	add	$v0, $s3, $zero  # addCount++
	add	$v1, $s4, $zero  # addCount++

	# Dellocate Memory
	lw	$s6, 0($sp) # lwCount++
	lw	$s5, 4($sp) # lwCount++
	lw	$s4, 8($sp) # lwCount++
	lw	$s3, 12($sp) # lwCount++
	lw	$s2, 16($sp) # lwCount++
	lw	$s1, 20($sp) # lwCount++
	lw	$s0, 24($sp) # lwCount++
	addi	$sp, $sp, 28
instructionCountEnd:	jr	$ra

increment_add:
	addi	$s3, $s3, 1
	j cont1

increment_lw:
	addi	$s4, $s4, 1
	j cont2

#=================================================================

.data
int:		.word	3
newLine:	.asciiz "\n"
main_Prompt: 	.asciiz "\nThe number of add and lw instructions in main program"
sub_Prompt: 	.asciiz "\n\nThe number of add and lw instructions in sub program"
num_add_Prompt: .asciiz "\nThe number of add instructions between the range is: "
num_lw_Prompt:  .asciiz "\nThe number of lw instructions between the range is: "
Arch_Sig    :   .asciiz "\n********************\n*Made by Onur Vural* \n********************"  
