.data
Array: .space 4096
SizeMessage: .asciiz "Please, Enter the size of your array \n"
EnterMessage: .asciiz "Please, enter the numbers separated by returns. \n"
Min: .asciiz "The Minimum Number is :"
Max: .asciiz "\nThe Maximum number is :"
.text

li $v0, 4	# the code 4 for printing a string
la $a0, SizeMessage 	
syscall


li $v0,5 #takes integer input from user
syscall
move $t0, $v0 # stores the input in $t0 to be used later


li $t1, 1 # This acts as a counter in the input loop
la $t2, Array   # Puts address of the first byte of the Array in $t2 to point where to input 

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
 
 
li $t1, 1 # This acts as a counter in the input loop
la $t2, Array   # Puts address of the first byte of the Array in $t2 to point where to input 
lw $t3,($t2)   #Minimum Value
lw $t4,($t2)     #Maximum Value


Search:    #loops over the Array to Search for the Maximum and Minimum
lw $t5, ($t2) # sets the register to the first value in the array to compare it to others
ble $t5, $t3, AssignMin 	# checks if the number we are comparing to is less than the already minimum; if so, it goes to assign it to the new minimum
ble $t4, $t5, AssignMax		# checks if the number that is already the maximum is still larger than the number we are comparing to; if not, it goes to assign a new max
BTS: # Back To Search, is used to go back to search if its not finished but needed to update a value
add $t1,$t1,1	#increments the loop counter by 1
add $t2,$t2,4	#increments adress by 1 word
ble $t1,$t0, Search 	# this is used to loop and get out once the array is wholy checked
j Exit # gets out with the correct maximum and minimum values to print

AssignMin:
move $t3, $t5 #puts the new minimum in the maximum register
j BTS

AssignMax:
move $t4, $t5 # puts the new maximum in the maximum register
j BTS

Exit:

# Prints the minimum message
li $v0, 4
la $a0,Min
syscall
# Prints the minimum number
li $v0, 1
move $a0, $t3
syscall

# Prints the maximum message
li $v0, 4
la $a0,Max
syscall
# Prints the maximum number
li $v0, 1
move $a0, $t4
syscall

li $v0,10
syscall
