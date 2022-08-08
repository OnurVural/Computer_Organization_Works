# Program to construct a linked list & display the elements recursively
.text
#----------------------------------------------------------------------
	
	
	li	$a0, 10 	#create a linked list with 10 nodes
	jal	createLinkedList
	
	
	# Linked list is pointed by $v0
	move	$a0, $v0	# Pass the linked list address in $a0
	move	$t0, $v0	# Pass the linked list address in $a0
	
	jal printLinkedList
	
	la	$a0, EnterMsg
	li	$v0, 4
	syscall
	
	move	$a0, $t0 # prepare the argument
	
	jal 	DisplayReverseOrderRecursively
#----------------------------------------------------------------------

exit:   # end program
	li	$v0, 4
	la	$a0, Arch_Sig
	syscall
			
	li 	$v0, 10
	syscall

#=================================================================
# DisplayReverseOrderRecursively: sub-program to display elements of a linked list in reverse order by using recursion
# @param  $a0: The head of linked list
DisplayReverseOrderRecursively:
	# Allocate Memory
	addi 	$sp, $sp, -12
	sw  	$s0, 8($sp)
	sw  	$a0, 4($sp) # store dividend
	sw   	$ra, 0($sp) # store $ra
	
	# 1) BASE CASE -> When we reach last node return
	#lw	$s1, 0($a0) # get where the node points
	bne	$a0, $zero, else
	
	addi 	$sp, $sp, 12
	jr	$ra # return
	
else:   # 2) RECURSIVE CASE -> call method for the next node of the list
	lw	$a0, 0($a0) # load the address of next node to point the next node
	jal	DisplayReverseOrderRecursively # recursive call
	
	lw   	$ra, 0($sp) # restore $ra
	lw  	$a0, 4($sp) # restore $a0
	lw  	$s0, 8($sp) # restore $s0
	addi 	$sp, $sp, 12
	
	# 3) PRINT -> element of node----------------------------
	lw	$s0, 4($a0)	# $s2: Data of current node
	
	li	$v0, 1	
	move	$a0, $s0	
	syscall	
	
	li	$v0, 4
	la	$a0, separatorLabel
	syscall
	#-------------------------------------------------------
	jr	$ra # return
#=================================================================

#=================================================================
createLinkedList:
# @param  $a0: No. of nodes to be created ($a0 >= 1)
# @return $v0: returns list head
# Node 1 contains 1 in the data field, node i contains the value i in the data field.
	addi	$sp, $sp, -20
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram
	
	move	$s0, $a0	# $s0: no. of nodes to be created.
	li	$s1, 1		# $s1: Node counter
# Create the first node: header.
# Each node is 8 bytes: link field then data field.
	li	$a0, 8
	li	$v0, 9
	syscall
# OK now we have the list head. Save list head pointer 
	move	$s2, $v0	# $s2 points to the first and last node of the linked list.
	move	$s3, $v0	# $s3 now points to the list head.
	
# sll: So that node 1 data value will be 4, node i data value will be 4*i
	sw	$s1, 4($s2)	# Store the data value.
	
addNode:
# Are we done?
# No. of nodes created compared with the number of nodes to be created.
	beq	$s1, $s0, allDone
	addi	$s1, $s1, 1	# Increment node counter.
	li	$a0, 8 		# Remember: Node size is 8 bytes.
	li	$v0, 9
	syscall
# Connect the this node to the lst node pointed by $s2.
	sw	$v0, 0($s2)
# Now make $s2 pointing to the newly created node.
	move	$s2, $v0	# $s2 now points to the new node.
	
	sw	$s1, 4($s2)	# Store the data value.
	j	addNode
allDone:
# Make sure that the link field of the last node cotains 0.
# The last node is pointed by $s2.
	sw	$zero, 0($s2)
	move	$v0, $s3	# Now $v0 points to the list head ($s3).
	
	# Restore the register values
	lw	$ra, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra
#=========================================================

#=========================================================
printLinkedList:
# Print linked list nodes in the following format
# --------------------------------------
# Node No: xxxx (dec)
# Address of Current Node: xxxx (hex)
# Address of Next Node: xxxx (hex)
# Data Value of Current Node: xxx (dec)
# --------------------------------------

# Save $s registers used
	addi	$sp, $sp, -20
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram

# $a0: points to the linked list.
# $s0: Address of current
# s1: Address of next
# $2: Data of current
# $s3: Node counter: 1, 2, ...
	move $s0, $a0	# $s0: points to the current node.
	li   $s3, 0
printNextNode:
	beq	$s0, $zero, printedAll
				# $s0: Address of current node
	lw	$s1, 0($s0)	# $s1: Address of  next node
	lw	$s2, 4($s0)	# $s2: Data of current node
	addi	$s3, $s3, 1
# $s0: address of current node: print in hex.
# $s1: address of next node: print in hex.
# $s2: data field value of current node: print in decimal.
	la	$a0, line
	li	$v0, 4
	syscall		# Print line seperator
	
	la	$a0, nodeNumberLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s3	# $s3: Node number (position) of current node
	li	$v0, 1
	syscall
	
	la	$a0, addressOfCurrentNodeLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s0	# $s0: Address of current node
	li	$v0, 34
	syscall

	la	$a0, addressOfNextNodeLabel
	li	$v0, 4
	syscall
	move	$a0, $s1	# $s0: Address of next node
	li	$v0, 34
	syscall	
	
	la	$a0, dataValueOfCurrentNode
	li	$v0, 4
	syscall
		
	move	$a0, $s2	# $s2: Data of current node
	li	$v0, 1		
	syscall	

# Now consider next node.
	move	$s0, $s1	# Consider next node.
	j	printNextNode
printedAll:
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra
#=========================================================	
.data
EnterMsg:
	.asciiz "\nThe items of linked list in reverse order: \n"
line:	
	.asciiz "\n --------------------------------------"

nodeNumberLabel:
	.asciiz	"\n Node No: "

separatorLabel:
	.asciiz	",  "
addressOfCurrentNodeLabel:
	.asciiz	"\n Address of Current Node: "
	
addressOfNextNodeLabel:
	.asciiz	"\n Address of Next Node: "
	
dataValueOfCurrentNode:
	.asciiz	"\n Data Value of Current Node: "
Arch_Sig:     .asciiz "\n********************\n*Made by Onur Vural* \n********************" 
