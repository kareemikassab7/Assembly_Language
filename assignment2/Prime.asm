.data

EnterMessage: .asciiz "Enter the Integer, Please\n"
IsPrime: .asciiz "The Integer is a Prime Number\n"
IsNotPrime: .asciiz "This Integer is not a Prime Number\n"
IsEven: .asciiz "This Interger is Even"
IsOdd: .asciiz "This Interger is Odd"
TheTwo: .asciiz "You have Chosen the Integer 2, It it Both Even and Prime!"
.text

# a Welcome Message
li $v0, 4          # Loads 4, the code for string printing
la $a0, EnterMessage
syscall

# Reads the required Integer to work on
li, $v0, 5
syscall

#Store Value to be used later
move $t0, $v0
add $t1,$zero,2
Divisionloop:    	#loops and keeps dividing and incrementing the counter until it reaches the desired integer
beq $t0,1,notprime
beq $t0,$zero,notprime
beq $t1, $t0, Exit
div $t0, $t1
mfhi $t2 #get remainder from hi register and store it in t1
beq $t2,$zero, notprime
addi $t1,$t1,1 #a counter from 0 to number itself
beq $t1,$t0, Exit
j Divisionloop     #jumps back into the loop

notprime:
li $t4,2  #puts 2 in $t4 to be used in division to check if the number is even or odd
li $v0,4
la $a0,IsNotPrime      #puts the adress of the first character in the message in $a0 to be printed
syscall
div $t0,$t4
mfhi $t3              #moves the division process remainder to $t3 from its default location the HI register
beqz $t3,PrintEven
la $a0,IsOdd      	#puts the adress of the next message into the default register $a0 to be printed by the next command
li $v0, 4
syscall
li $v0,10        	#the code 10 is used for termination
syscall

PrintEven:   #prints wa message that the number is even
la $a0,IsEven		
li $v0,4
syscall
li $v0,10     #the code 10 is used to terminate the program
syscall

Exit:
li $v0,4  # Loads 4, the code for string printing
la $a0,IsPrime
syscall
li $t4, 2
div $t0,$t4      #divides Value in $t0 by $t4
mfhi $t3    #moves the division process remainder to $t3 from its default location the HI register
beqz $t3,PrintEven    #branches to the Print Even if the remainder of divison is 0
li $v0,4  # Loads 4, the code for string printing
la $a0,IsOdd     #prints that the number is odd if its not even
syscall
