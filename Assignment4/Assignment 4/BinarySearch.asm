# adress of array
# the value to be searched for
# the number of items in the array
.data
.align 2
Arr: .space 100
SizeMessage: .asciiz "Please, Enter the size of the Array that you want to Search in: \n"
EnterMessage: .asciiz "Please, Enter the Numbers in the array separated by returns \n"
Req: .asciiz "Please, Enter the number that you want to search for \n"
.text
li $v0, 4 # Code for Printing a string
la $a0, SizeMessage
syscall

li $v0,5 #takes integer input from user
syscall
move $t0, $v0 # stores the input in $t0 to be used later

li $v0, 4
la $a0, EnterMessage
syscall

li $t1, 1 # This acts as a counter in the input loop
la $s1, Arr   # Puts address of the first byte of the Array in $s1 to point where to input 

#take input from user
InputLoop:
li $v0,5 	# code 5 is used to take an integer from the user
syscall
sw $v0, ($s1) 	# stores the inputted value in $s1 to be used late as $v0 is used by default as an input location
add $t1,$t1,1 	#increment the loop counter by 1 to approach its end ( so it isnt infinite)
add $s1,$s1,4	# increments the adress so the user doesnt overwrite anything and the integer is put in its suitable place
ble $t1, $t0, InputLoop   #keeps looping until the couter reaches the desired size
la $s1 Arr   # Puts address of the first byte of the Array in $s1 to point where to input 

add $t7, $t0, -1
mul $t7, $t7, 4
add $s2, $s1, $t7

li $v0, 4
la $a0, Req
syscall

li $v0,5 #takes integer input from user
syscall
move $s0, $v0 # stores the input in $t0 to be used later


div $t0,$t0,2
mul $t0,$t0,4
add $s5,$s1,$t0

lw $t5, ($s5)

ble $s0, $t5, BinarySearchS
bge $s0, $t5, BinarySearchL

addiu $sp, $sp, -16
sw $ra, 12($sp)
sw $s0, 8($sp)
sw $s2, 4($sp)
sw $s1, 0($sp)
jal BinarySearch

BinarySearch:
sw $ra, 12($sp)
beq $s1, $s2, LastCheck

BinarySearchL:
BinarySearchS:

LastCheck:
lw $t7, ($s1)
beq $t7, $s0, Found
li $v0, 1
li $a0, -1
syscall

Found:
addiu $sp, $sp, 16
lw $ra, 12($sp)
jr $ra