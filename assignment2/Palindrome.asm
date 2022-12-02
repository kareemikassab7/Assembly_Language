.data

Array: .space 4096
SizeMessage:.asciiz "Please, Enter the size of the word that you want to check: \n"
EnterMessage: .asciiz "Please, Enter the word"
IsPalindrome: .asciiz "\n Yes, This word is a Palindrome"
NotPalindrome: .asciiz "\n No, This word is not a palindrome \n"
Modified: .asciiz "Its modified palindrome would be : "
.text

li $v0, 4
la $a0, SizeMessage
syscall

li $v0,5 #let user input an integer
syscall
move $t0, $v0 #Storing the size in register $t0 to be used later
add $t0,$t0,1 #adding 1 to the size inputted by the user to account for the null character (This caused a lot of trouble)

li $v0,8 #lets user input strings
move $a1,$t0
la $a0,Array
syscall

la $t1,Array    #startpointer
sub $t2,$t0,2  #endpointer
add $t3,$t1,$t2  #endpointer


li $t4,0 # a counter for the loop to loop over the whole array of characters

CheckPalindrome:
lbu $t5,($t1) # the first character to be compared (from beggining), this will be incremented
lbu $t6,($t3) # the second character to be compared (from the end), this will be decremented
bne $t5,$t6, NeedChange
add $t1,$t1,1 #increment the first character pointer
sub $t3,$t3,1 # decrement the last character pointer
add $t4,$t4,1 #increments the loop counter
bge $t0, $t4 , CheckPalindrome

# prints that the word is a palindrome and exits the program
li $v0, 4
la $a0, IsPalindrome
syscall
li $v0, 10
syscall

NeedChange:
bne $t5,$t6, MakePalindrome #jumps to the function that does the changes if the 2 compared characters arent the same

j KeepChange

MakePalindrome:
# stores the modified bytes from end to beginning (based on the sample, to make abeba not amema from ameba)
sb $t6, ($t1)
sb $t6, ($t3)

KeepChange:
add $t1,$t1,1	# increments the first character pointer (the earlier one going from begin to end)
sub $t3,$t3,1	# decrements the last character pointer (that goes from end to beggning)
lbu $t5,($t1)	# changes the character to what is stored in $t1
lbu $t6,($t3)	# changes the character to what is stored in $t3
add $t4,$t4,1	# increments the loop counter
bge $t0, $t4 , NeedChange #keeps the loop going until the word is over

#Prints the message
li $v0, 4
la $a0, NotPalindrome
syscall
# Prints the message before the new word version
li $v0, 4
la $a0,Modified
syscall
# prints the word
li $v0, 4
la $a0,Array
syscall
# terminates the program
li $v0, 10
syscall


