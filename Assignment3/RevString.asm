.data
Arr1: .space 20
Arr2: .space 20
SizeMessage: .asciiz "Hello, Please, Enter the size of your array \n"
InputMessage: .asciiz "Please, enter the string that you want to revert.\n"
Result: .asciiz "\n The new string is: "
.text

li $v0,4
la $a0, SizeMessage
syscall

li $v0,5 #takes integer input from user
syscall
move $t0, $v0 # stores the input in $t0 to be used later

li $v0, 4
la $a0, InputMessage
syscall

# lets the user input a string starting at adress of $a0 and havemax characters in $a1
li $v0, 8 
la $a0, Arr1
add $a1, $t0, 1
syscall

li $t1, 1 #This acts as a counter in the input loop
la $t2, Arr1   #Puts address of the first byte of the Array in $t2 to point where to input 
la $t3, Arr2   #Puts address of the first byte of the Array in $t3 to point where to input 
add $t2, $t2, $t0 # makes the t2 poiunt to the last letter of the string
sub $t2, $t2, 1 # makes the register point to the last letter of the string (moves it before the null character)

# Reverts the string into a new array
RevertLoop:
lbu $t4, ($t2) # loads the value pointed to by t2 into $t4
sb $t4, ($t3)  # stores whats in $t4 into the memory location pointed to by $t3
sub $t2, $t2, 1 # makes the pointer point to the earlier character
add $t3, $t3, 1 # makers the pointer point tot he later character
add $t1, $t1, 1 # increments the loop counter
ble $t1,$t0, RevertLoop

# prints the messsage
li $v0, 4
la $a0, Result
syscall
# prints the new string and terminates
li $v0, 4
la $a0, Arr2
syscall
