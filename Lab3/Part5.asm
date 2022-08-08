# Program to duplicate a linked list by a recursive subprogram

.text
#----------------------------------------------------------------------
main:	la	$a0, origList
	li	$v0, 4
	syscall
	# Create linked list & print infromation
	li	$a0, 10	#create a linked list with 10 nodes
	jal	createLinkedList
	move	$t0, $v0 # EXTRACT THE RETURN VALUE
	
	move	$a0, $t0 # PREPARE THE ARGUMENT
	jal	printLinkedList
	
	# TEST THE SUBPROGRAM
	la	$a0, newListMsg
	li	$v0, 4
	syscall
	# Linked list is pointed by $v0
	move	$a0, $t0 # PREPARE THE ARGUMENT - Pass the linked list address in $a0
	jal 	DuplicateListRecursive
	
	move	$t1, $v0 # EXTRACT THE RETURN VALUE
	move	$a0, $t1 # PREPARE THE ARGUMENT
	jal	printLinkedList
	
#----------------------------------------------------------------------
exit:   # end program
	li	$v0, 4
	la	$a0, Arch_Sig
	syscall
			
	li 	$v0, 10
	syscall
#=================================================================
# DuplicateListRecursive: sub-program to duplicate a linked list recursively and return the head pointer of the new list
# @param   $a0: The head of linked list
# @return  $v0: The head of duplicated linked list
DuplicateListRecursive:
	# Allocate Memory
	addi 	$sp, $sp, -24
	sw  	$s3, 20($sp) 
	sw  	$s2, 16($sp) 
	sw  	$s1, 12($sp) 
	sw  	$s0, 8($sp)
	sw  	$a0, 4($sp) # store dividend
	sw   	$ra, 0($sp) # store $ra
#-------------------------------------------------------------------------------------------------------
	# 1) BASE CASE: return when we reach empty node
	move	$s1, $a0
bne	$a0, $zero, else
	move	$s2, $zero
	#sw	$s2, 0($v0)
	#add	$v0, $zero, $zero # NULL
	addi 	$sp, $sp, 24
	jr	$ra # return
#-------------------------------------------------------------------------------------------------------	
else:   # 2) Create node & copy value of orignal
	li	$a0, 8 # Node with 8 byte size
	li	$v0, 9
	syscall
	
	move	$s3, $v0
	move	$a0, $s1 # get original value of address pointer after inserting 8 to call sys
	# new->data = old->data
	lw	$s0, 4($a0)
	sw	$s0, 4($v0)
 
	# 3) RECURSIVE CASE: Call for node->next essentially
	# newNode->next = copyList(head->next); 
	
	lw	$a0, 0($a0) # pass to next node
	
	jal	DuplicateListRecursive #+++++++++++++++REC->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	
	move	$v0, $s3
	
	sw	$s2, 0($v0) # Link the node to the next by inserting its address
		
	
	 
	# Deallocate memory
	lw   	$ra, 0($sp) # restore $ra
	lw  	$a0, 4($sp) # restore $a0
	lw  	$s0, 8($sp) # restore $s0
	lw  	$s1, 12($sp)# restore $s1
	lw  	$s2, 16($sp)# restore $s2
	lw  	$s3, 20($sp)
	addi 	$sp, $sp, 24
	
	la	$s2, ($v0)
	
	# add	$v0, $s2, $zero
	
#-----------------------------------------------------------------------------------------------------------		
	
#-----------------------------------------------------------------------------------------------------------	
	jr	$ra # return to main
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
#=================================================================
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
numbie: .word
origList:
	.asciiz "\n----------------The CREATED linked list----------------"
newListMsg:
	.asciiz "\n----------------The DUPLICATED linked list---------------- "
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