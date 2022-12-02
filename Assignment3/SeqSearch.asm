.data
SizeMessage: .asciiz "Please, Enter the size of the Array that you are going to search in: "
EnterMessage: .asciiz "Please, Enter the Numbers in the array separated by returns"
RequiredNum: .asciiz "What is the number that you want to search for ? "
NotFound: .asciiz "Sorry, I could not find the number that you wanted to search for \n"
IsFound: .asciiz "I found the number at index "
.align 4
Arr: .space 4096
.text

li $v0, 4 # Code for Printing a string
la $a0, SizeMessage
syscall

li $v0,5 #takes integer input from user
syscall
move $t0, $v0 # stores the input in $t0 to be used later

li $t1, 1 # This acts as a counter in the input loop
la $t2, Arr   # Puts address of the first byte of the Array in $t2 to point where to input 

li $v0, 4
la $a0, EnterMessage
syscall

#take input from user
InputLoop:
li $v0,5 	# code 5 is used to take an integer from the user
syscall
sw $v0, ($t2) 	# stores the inputted value in $t2 to be used late as $v0 is used by default as an input location
add $t1,$t1,1 	#increment the loop counter by 1 to approach its end ( so it isnt infinite)
add $t2,$t2,4	# increments the adress so the user doesnt overwrite anything and the integer is put in its suitable place
ble $t1, $t0, InputLoop   #keeps looping until the couter reaches the desired size

li $v0, 4
la $a0, RequiredNum
syscall

#Takes the required number to be searched for and stores it in $t3
li $v0, 5
syscall
move $t3, $v0 #stores the required

la $t2, Arr  #return the pointer to the first word so we can search from the beggining
li $t1, 0 # this is a loop counter
SearchLoop:
lw $t4, ($t2)
beq $t3,$t4,Found 
add $t1,$t1,1 	#increment the loop counter by 1 to approach its end ( so it isnt infinite)
add $t2,$t2,4	# increments the adress so the user doesnt overwrite anything and the integer is put in its suitable place
blt $t1, $t0, SearchLoop  #keeps looping until the couter reaches the desired size

# Prints a not found message and terminates the Program
li $v0, 4
la $a0, NotFound
syscall
li $v0, 1 # returns an integer which is -1
li $a0, -1
syscall
li $v0, 10 # terminates the program
syscall
# Prints the found message and the index
Found:
li $v0, 4
la $a0, IsFound
syscall

add $a0, $t1, $zero #puts the value of the counter which is equivalent to the index in $ a0 to be returned
li $v0, 1 
syscall
