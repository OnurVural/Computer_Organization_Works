# program to check if an array is a symmetric array or not
.text
	add	$t0, $zero, $zero # $t0 = 0
	la 	$t1, array
	lw	$t2, arrsize 
        # find midpoint of array and load it $t0
        li      $t3, 2
	div     $t2, $t3  # midpoint = (int) (arrsize / 2)
	mflo 	$t3 # put the result into $t3
	# ----------------
	
	la 	$t4, array # pointing to first element
	
	# we need for another pointer pointing last item, in order to do that
	li      $t6, 4
	mult  	$t2, $t6 # multiply arraysize and 4 to get index
	mflo    $t6
	subi	$t6, $t6, 4 # this is because index starts from zero
	# ----------------
	#la $t5, last-1(array) # pointing to last element
	la 	$t5, array
	add 	$t5, $t5, $t6
#-------------------------------------------------------------------------------------------
print:
	beq $t0, $t2, nextStep
# display i'th element
	li $v0, 1
	lw $a0, 0($t1)
	syscall
# --------------------

# print ,
	li $v0, 4
	la $a0, arraySpace
	syscall
# --------------------
	addi $t1, $t1, 4 
	addi $t0, $t0, 1 #i++
j print

nextStep:
	li $v0, 4
	la $a0, emptySpace
	syscall

	add	$t0, $zero, $zero # $t0 = 0 (initialize again for another usage as iterator)
j compare

compare:
	beq $t0, $t3, symmetric #the comparison will proceed until we reach midpoint of array
	#load the values for comparison
	lw $t6, 0($t4) 
	lw $t7, 0($t5)
	#----------------------------
	bne $t6, $t7, asymmetric # if spot the items in symmetric positions are not equal, we exit immediately
	
	addi $t4, $t4, 4 #increase first index for next comparison
	subi $t5, $t5, 4 #decrease second index for next comparison
	addi $t0, $t0, 1 #i++ (THIS INDICATES NO OF KEY COMPARISONS IN ARRAY-which is up to midpoint)		
j compare	

symmetric:
# Print YES message
	li	$v0, 4
	la	$a0, messageYes
	syscall 

# END PROGRAM
	li	$v0, 10
	syscall

asymmetric:
# Print NO message
	li	$v0, 4
	la	$a0, messageNo
	syscall 
			
# END PROGRAM
	li	$v0, 10
	syscall


.data
array:		.word 1, 2, 7, 2, 1
arrsize:	.word 5
messageYes:     .asciiz "The above array is symmetric...\n"
messageNo:      .asciiz "The above array is NOT symmetric...\n"
arraySpace:	.asciiz ", "
emptySpace:	.asciiz "\n->"
