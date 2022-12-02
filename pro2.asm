.data

Array: .space 1024   #reserving space for the array
Input_Size: .asciiz "Input number of elements \n"
INPUTU: .asciiz "\n Input your array \n"
space: .asciiz "  "
target:.asciiz "enter number to find"
index: .asciiz "/n INDEX: "
.text

#printing Input_Size message
li $v0, 4
la $a0, Input_Size
syscall

#Storing array size in register 
li $v0,5
syscall
move $s7, $v0

la $s0, Array #Setting the array pointer
li $t2, 0   # setting loop counter

#asking yser to input his array
li $v0, 4
la $a0, INPUTU
syscall

#take input from user
Loop_Input:
li $v0,5
syscall
sw $v0, ($s0)
add $s0,$s0,4
add $t2,$t2,1
blt $t2, $s7, Loop_Input
add $a2,$s0,$zero
sub $a2,$a2,4 

li $v0, 4
la $a0, target
syscall

li $v0,5
syscall
move $a0,$v0

la      $a1, Array


jal find



li $v0,10
syscall

find:
sw $ra , 4($sp)
add $sp,$sp,-4
sub $t9,$a2,$a1
bnez $t9,search

move    $v0, $a1
lw      $t9, ($v0) 
beq     $a0, $t9, return
li      $v1, -1
b       return

search:
sra    $t9, $t9, 3
sll     $t9, $t9, 2
addu    $v1, $a1, $t9
lw      $t9, ($v1)
beq     $a0, $t9, return
blt     $a0, $t9, smaller

bigger:
addu    $a1, $v1, 4
jal     find
b       return 

smaller:
move $a2, $v1
jal     find 

return:
lw      $ra, 4($sp)
addu    $sp, $sp, 4

sub $t1, $v1, 268500992
divu $t1,$t1,4

li $v0, 4
la $a0, index
syscall

li $v0,1
move $a0, $t1
syscall


jalr  $ra




