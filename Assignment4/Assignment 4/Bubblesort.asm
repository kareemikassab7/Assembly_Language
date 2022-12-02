.data
.align 4
Arr: .space 100
SizeMessage: .asciiz "Please, Enter the size of the Array that you want to sort: "
EnterMessage: .asciiz "Please, Enter the Numbers in the array separated by returns"
separation: .asciiz "  ,  "
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
la $t2, Arr   # Puts address of the first byte of the Array in $t2 to point where to input
#take input from user
InputLoop:
li $v0,5 	# code 5 is used to take an integer from the user
syscall
sw $v0, ($t2) 	# stores the inputted value in $t2 to be used late as $v0 is used by default as an input location
add $t1,$t1,1 	#increment the loop counter by 1 to approach its end ( so it isnt infinite)
add $t2,$t2,4	# increments the adress so the user doesnt overwrite anything and the integer is put in its suitable place
ble $t1, $t0, InputLoop   #keeps looping until the couter reaches the desired size
la $t2, Arr   # Puts address of the first byte of the Array in $t2 to point where to input 
add $a0, $t0, $zero
add $a2, $t2, $zero

addiu $sp, $sp, -12
sw $ra, 8($sp)
sw $a0, 4($sp)
sw $a2, 0($sp)

jal BubbleSorting

la $t2, Arr   # Puts address of the first byte of the Array in $t2 to point where to input 
li $t1,1
li $a0, 0
PrintLoop:
li $v0, 1
lw $s6, ($t2)
add $a0, $zero, $s6
syscall
li $v0, 4 # Code for Printing a string
la $a0, separation
syscall
add $t2,$t2, 4
add $t1, $t1, 1
ble $t1, $t0, PrintLoop

#add $sp, $sp, 12
li $v0, 10
syscall

BubbleSort:
#base case
sw $ra, 8($sp)
BubbleSorting:
beq $a0 , 1, SortDone
lw $a0, 4($sp)
lw $a2, 0($sp)

add $s5, $a0, -1
add $s0, $a2, 0
add $s1, $s0, 4
li $t3, 1
Sort:
beq $t3, $a0, Recaller
lw $s2, ($s0)
lw $s3, ($s1)
ble $s2, $s3, continue
sw $s2, ($s1)
sw $s3, ($s0)
add $s0, $s0, 4
add $s1, $s1,4
add $t3, $t3, 1
ble $t3, $s5, Sort
continue:
add $s0, $s0, 4
add $s1, $s1, 4
add $t3, $t3, 1
ble $t3, $s5, Sort

Recaller:
sub $a0, $a0, 1
addi $sp, $sp, -12
sw $ra , 8($sp)
sw $a0, 4($sp)
sw $a2, 0($sp)
jal BubbleSorting

SortDone:
addiu $sp, $sp, 12
lw $ra, 8($sp)
jr $ra
