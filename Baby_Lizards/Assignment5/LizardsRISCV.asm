.data
array : .space 1024
separation: .asciz "  | "
SizeMessage: .asciz "Please, Enter the number of rows or columns (they are equal): "
HMTrees: .asciz "How many trees do you want to insert? "
RowInd: .asciz "what is the row of the tree?"
ColInd: .asciz "what is the column of the tree?"
NewLine: .asciz "\n----------------------------------------\n"
space: .asciz " "
.text
#ASSMPTIONS:
# 0 is nothing
# 1 is a lizard
# 2 is a tree
# 3 is an unsafe location (used in operations then replaced by 0's in the end)
#######################
#Register Usage:
# a1 row index (used in traversing)
# a2 column index (used in traversing)
#t0 number of rows
#t1 counters
#t2 points to array
#t3 number of trees
#t4 total size cols*rows
#t5 holds the adress of the slot we are iterating on
#t6 the size multiplied by 4
#s9 loads and holds the element while iterating to see its value and decide what to do
#s8 used in calculating indices (intitally has the adress of the slot we are in)
#t9 free
# s0 = 0
# s1 = 1 
# s2 = 2
# s3 = 3
# s4 = 4
#
######################## These Will be used in Calculations  ######################
li s0, 0
li s1, 1 
li s2, 2
li s3, 3
li s4, 4
li s10, 0x10010000
mul t6, t0, s4 #t6 = n * 4
############################Takes the length or width (size), then takes the number of trees to be inputted##########################################

li a7, 4 # Code for Printing a string
la a0, SizeMessage
ecall

li a7,5 #takes integer input from user
ecall
add t0, a0, zero # stores the input in t0 to be used later

mul t4, t0, t0
li a7, 4 # Code for Printing a string
la a0, HMTrees
ecall


li a7,5 #takes integer input from user
ecall
add t3, a0, zero # stores the input in t0 to be used later
###################################################################################################################################################
#################################################### takes the input trees from the user###########################################################
li t1, 1 # This acts as a counter in the input loop
la t2, array   # Puts address of the first byte of the arrayay in t2 to point where to input
InputLoop:
li a7, 4 # Code for Printing a string: The row message
la a0, RowInd
ecall
li a7,5 #takes integer input from user
ecall
add t5, a0, zero # stores the input in t0 to be used later
li a7, 4 # Code for Printing a string
la a0, ColInd
ecall
li a7,5 #takes integer input from user
ecall
add t6, a0, zero # stores the input in t6 to be used later


mul t5, t5, t0 # Multiplies the number if rows by n(number of columns)
add t5, t5, t6 # adds the number of slots above us to the number of slots to the left of us
mul t5, t5, s4  # multiplies the number of slots by 4 to increment the size

add t2, t2, t5 # increments our adress by the amount


sw s2, (t2)  	# stores 2 (our code for the tree)
add t1,t1,s1 	#increment the loop counter by 1 to approach its end ( so it isnt infinite)
la t2, array

ble t1, t3, InputLoop   #keeps looping until the couter reaches the desired size

#######################################################################################
mul t6, t0, s4 #t6 = n * 4
#Loop throught the array element by element coloumnly
la t2, array
add t5, t2, zero # puts the pointer to the array in t5 too cuzz it will be changed
add t1, t0, zero #t1 = size
add s5, t0, zero 
##################################### Iterates over each slot to place a lizard or go to next depending on safety###############################
SlotIteration:
lw s9, (t5) 	     # loads the number in the current slot to be compared
beq s9, zero, Free # if the number is zero, it is ok to place a lizard
beq s9, s2, Tree   # if the number is 2 then this is a tree
beq s9, s3, UnSafe # if the number is 3 then this is a Unsafe a.k.a under attack
Free:
sw s1, (t5) # loads a one (puts a lizard)	
########################################## Updates the safety (Marks the unsafe places after putting a lizard)###############################
SafetyUpdate:
 #CmpInd: # This function computes the index to know how much slot to traverse in each direction
###################################call The traveersing functions in our 8 directions#######################################
# Compute index and traverse to the right direction
jal CompInd
jal TraverseRight
# Compute index and traverse to the Left direction
jal CompInd
jal TraverseLeft
# Compute index and traverse to the upward direction
jal CompInd			
jal TraverseUp	
# Compute index and traverse to the downward direction
jal CompInd
jal TraverseDown
# Compute index and traverse to the right upward Diagonal direction
jal CompInd						
jal TraverseRightUp
# Compute index and traverse to the right downward diagonal direction
jal CompInd			
jal TraverseRightDown
# Compute index and traverse to the left upward diagonal direction
jal CompInd
jal TraverseLeftUp
# Compute index and traverse to the left downward diagonal direction
jal CompInd			
jal TraverseLeftDown
			
b NextSlot # moves to the next slot to check and put a lizard or pass
#####################################################################################			
Tree:	# if the number is 2 a tree ya3ne, it skips it as we cant put a lizard
b NextSlot
#####################################################################################	
UnSafe: # if the number is 3, we cannot put i t as it is unsafe, so we skip it too.
		b NextSlot
#####################################################################################	
NextSlot: # This loop loops top-down, right to left, so we increase the adress by n*4. 4 is the size of one int
add t5, t5, t6 # moves tot he element bleow us
sub t1, t1, s1
beq t1, zero, NextColumn #loops over the whole size of the array
b SlotIteration
	
NextColumn: # This loops switches between the columns every n slots
add t1, t0, zero # puts n in t1
add t2, t2, s4 # moves to the lement to the right of us
add t5, t2, zero   # this is the new adress that we'll iterate with
sub s5, s5, s1
beqz s5, PrintPresets    # if we're done, we print
b SlotIteration

############################################### Calculate the index used to know the limits of traversing in each direction ###############################################
CompInd: # This loop comptes the index
add s8, t5, zero #address of  the slot we are traversing from
sub a1, s8, s10 # This is the adrss of the first slot in the array
div a1, a1, t6        # we divide by length or width (same) * 4 to get the row index we are in
sub a3, s8, s10 # This is the difference between the adress we are on and the first one (total slots*4)
mul a2, a1, t6        # we multiply thr number of rows *n*4 (all slots above us). recall n*4 =t6
sub a2, a3, a2	# we subtract slots above us from all slots to get space beside us
div a2, a2, s4		# we divide space beside us to get the column index
jr ra
################################################## These functions travers (wihtin limits) in all 8 directions ###########################################
# This function Traverses in the Right Direction
TraverseRight:
add a2, a2, s1		# the column moves to right while row constant
blt a2, t0, TraverseRightValid	# as long as were within width its ok
b TraverseRightFinished			#if not we are done traversing
TraverseRightValid:
add s8, s8, s4		# we move to the slot to the right
lw s6, (s8)			# we cload it
beq s6, s2, TraverseRightFinished	# we compare it
sw s3, (s8)			# we put 3 (unsafe until we hit a tree)
b TraverseRight
TraverseRightFinished:
		jr ra # goes back to traverse to the next direction
		
# This function Traverses in the Left Direction
TraverseLeft:
sub a2, a2, s1 # the column moves to left while row constant
bge a2, zero, TraverseLeftValid	# as long as were within width its ok
b TraverseLeftFinished 	#if not we are done traversing
TraverseLeftValid:
sub s8, s8, s4	# we move to the slot to the left
lw s6, (s8)	# we cload it
beq s6, s2, TraverseLeftFinished	# we compare it
sw s3, (s8)	# we put 3 (unsafe until we hit a tree)
b TraverseLeft #loops
TraverseLeftFinished:
jr ra		# goes back to traverse to the next direction

# This function Traverses in the Upward Direction		
TraverseUp:
sub a1, a1, s1		# the row moves to up while column constant
bge a1, zero, TraverseUpValid	# as long as were within height its ok
b TraverseUpFinished		#if not we are done traversing
TraverseUpValid:
sub s8, s8, t6    #go to element above us
lw s6, (s8)
beq s6, s2, TraverseUpFinished #check if it is tree or not
sw s3, (s8)
b TraverseUp
TraverseUpFinished:
jr ra

# This function Traverses in the Downward Direction
TraverseDown:
add a1, a1, s1		#increments row index while column is constant
blt a1, t0, TraverseDownValid
b TraverseDownFinished
TraverseDownValid:
add s8, s8, t6   #move to element below us
lw s6, (s8)
beq s6, s2, TraverseDownFinished #check if it is tree or not
sw s3, (s8)
b TraverseDown
TraverseDownFinished:
jr ra
	
# This function Traverses in the Right Upward Diagonal Direction
TraverseRightUp:
sub a1, a1, s1      # the row moves up
add a2, a2, s1		#the column moves down
blt a1, zero, TraverseRightUpFinished # if height is touched we are done
bge a2, t0, TraverseRightUpFinished # if width is touched we are done
TraverseRightUpValid:
sub s8, s8, t6 	#goes up a row
add s8, s8, s4		# goes right one slot
lw s6, (s8)		# load slot to be compared
beq s6, s2, TraverseRightUpFinished
sw s3, (s8)		# stores 3 to mark unsafe 
b TraverseRightUp
TraverseRightUpFinished:
jr ra

# This function Traverses in the Right Downward Diagonal Direction	
TraverseRightDown:
add a1, a1, s1 # row increases downward
add a2, a2, s1	#column increases to right
bge a1, t0, TraverseRightDownFinished	# if depth is touched we are done
bge a2, t0, TraverseRightDownFinished	# if width is touched we are done
TraverseRightDownValid:
add s8, s8, t6	#goes down a row
add s8, s8, s4		#goes right one slot 
lw s6, (s8)		# load slot to be compared
beq s6, s2, TraverseRightDownFinished # check if there is a tree
sw s3, (s8)		# puts 3 to mark unsafe
b TraverseRightDown
TraverseRightDownFinished:
jr ra

# This function Traverses in the Left Upward Diagonal Direction
TraverseLeftUp:
	sub a1, a1, s1	 # the row moves up
	sub a2, a2, s1	 # the column moves left
	blt a1, zero, TraverseLeftUpFinished	# if height is touched we are done
	blt a2, zero, TraverseLeftUpFinished	# if width is touched we are done
	TraverseLeftUpValid:
sub s8, s8, t6	#goes up a row
sub s8, s8, s4		#goes left one slot
lw s6, (s8)	# load slot to be compared
beq s6, s2, TraverseLeftUpFinished	# checks if thats a tree
sw s3, (s8)		#puts 3 to mark unsafe
b TraverseLeftUp
TraverseLeftUpFinished:
jr ra

# This function Traverses in the Left Downward Diagonal Direction	
TraverseLeftDown:
add a1, a1, s1 	# the row moves down
sub a2, a2, s1		# the column moves right
bge a1, t0, TraverseLeftDownFinished # if depth is touched we are done
blt a2, zero, TraverseLeftDownFinished	# if width is touched we are done	
TraverseLeftDownValid:
sub s8, s8, t6	# goes up 1 row
sub s8, s8, s4		# goes left one slot
lw s6, (s8)		#loads to compare
beq s6, s2, TraverseLeftDownFinished 	#checks if this is a tree
sw s3, (s8)			# stores 3 to mark unsafe
b TraverseLeftDown
TraverseLeftDownFinished:
jr ra	# goes back to get the next slot

#################################################################### Printing part ######################################################################
PrintPresets:
la t2, array   # Puts address of the first byte of the arrayay in t2 to point where to input 
li t1,1
PrintLoop:
li a7, 1 # the code for printing an int
lw s6, (t2) # loads the number to be compared
beq s6, s3, Modify  # if the number is three we convert it back to 0 for correct display
b DontModify
Modify:
add s6, s0, zero # we put zero in place
DontModify:
add a0, zero, s6 # the number to be prined
ecall
li a7, 4 # Code for Printing a string
la a0, separation # this is just for shapes
ecall
add t2,t2, s4 
rem t6, t1, t0 

bnez t6, continue
li a7, 4 # Code for Printing a string
la a0, NewLine
ecall
continue:
add t1, t1, s1
ble t1, t4, PrintLoop #loops over printing loop
li a7, 10
ecall