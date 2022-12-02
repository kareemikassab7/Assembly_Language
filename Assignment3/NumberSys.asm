.data 
Number: .space 128
BinaryNum: .space 128
BinaryTemp: .space 128
OctalNum: .space 128
OctalTemp: .space 128
HexaDecimalNum: .space 128
HexaDecimalTemp: .space 128
Prefix: .space 4
target1:.space 4
SizeMessage: .asciiz "Greeting; Please, enter the length of the Number \n Put in mind to count the length after the prefix: "
EnterMessage: .asciiz "Please, enter the Number with its proper (exact prefix) to work correctly \n 0b for binary, oO for octal, 0X for hexadecimal\n "
ErrorMessage: .asciiz "Sorry, There is a Problem in the data that you entered\n"

BinaryForm: .asciiz "\n in Binary the Number is: "
DecimalForm: .asciiz "\n in Decimal the number is : "
OctalFormat: .asciiz "\n in Octal the number  is : "
HexadecimalForm: .asciiz "\n in HexaDecimal the number is: "
target:"what number system you want. Type bin(Binary), dec(Decimal), oct(Octal), or hex(HexaDecimal) \n"
	

.text	
	li $v0,4 # a welcome message to the user and gets the size of the string
	la $a0,SizeMessage
	syscall
	
	li $v0,5			 #inputs an integer that represents the size
	syscall
	move $s0,$v0		#stores the input to be used later
	
	li $v0,4		#a guide on how to input to the program
	la $a0,EnterMessage
	syscall
			
	li $v0,8		# lets the user input the string, which is, to me, the prefix which indicates the type that I will convert from
	la $a0,Prefix	
	li $a1,3		# the maximum number of characters that can be put one for the 0 one for the identifying letter and one for the null char
	syscall
	
	lw $s5,Prefix		
	
	
	li $v0,8		#The code to input a string
   	la $a0, Number   # indicates where the input begins
 	li $a1, 32		# The maximum that can be entered
	syscall
	
	li $v0,4		
	la $a0,target
	syscall
	
	li $v0,8		# lets the user input the string, which is, to me, the prefix which indicates the type that I will convert from
	la $a0,target1	
	li $a1,4		# the maximum number of characters that can be put one for the 0 one for the identifying letter and one for the null char
	syscall
	
	lw $t5,target1
	
	
	li $s2,1 		# this is used in conversion; it holds the weight of the place that is going to be multiplied
	li $s3,0 		# stores the value of the number= the sum of the multiplication of the weight and the number thats in the weighted slot
	la $a1,Number  		# a pointer to the first number in the number string
	add $a1,$a1,$s0		# points to the last digit which has the least weight
	add $a1,$a1,-1		# decrements the pointer to a more significant slot
	
	li $t3, 1
	
	beq $s5,25136,Binary 		# compares the decimal ascii value of 0b to be used to branch to the proper section
	beq $s5,20272,Octal		# compares the decimal ascii value of 0O to be used to branch to the proper section
	beq $s5,22576 ,HexaDecimal 	# compares the decimal ascii value of 0X to be used to branch to the proper section
	
	
	Decimal:
		li $s1,10     # the suitable base of the number system
		lbu $a0,($a1)   
		blt $a0,48,Error	# branches to the error handling part if the number is less than 0
		bgt $a0,57,Error	# branches to the error handling part if the number is more than 9
		sub $a0,$a0,48		# decreases the ascii value so that it is equivalent to its integer value in the decimal system
	
		mult $s2,$a0 		# multiplies the number by its weight
		mflo $s4		# stores the result to be used into the addition to the value of the number string
		add $s3,$s3,$s4  	# sums the values of the digits* their weights to get the real value of the number string
		
		subu $a1,$a1,1   	#decrements the pointer to go to the next more wighted digit
	
		add $s0,$s0, -1  	 
			
		mult $s2,$s1   		 # Multiplies the weight holder by the base to get the next right weight to be multiplied by the digit in the next slot
		mflo $s2
		
		ble $t3,$s0, Decimal	# loops
		b Conversion

	Binary:
		
		li $s1,2		# the suitable base of the number system
		lbu $a0,($a1)		# loads the value pointed to by a1 in a0
		blt $a0,48,Error	# branches to the error handling part if the number is less than 0
		bgt $a0,49,Error	# branches to the error handling part if the number is more than 1
		sub $a0,$a0,48		# decreases the ascii value so that it is equivalent to its integer value in the binary system
			
		mult $s2,$a0		# multiplies the number by its weight
		mflo $s4		# stores the result to be used into the addition to the value of the number string
		add $s3,$s3,$s4		# sums the values of the digits* their weights to get the real value of the number string
		subu $a1,$a1,1		#decrements the pointer to go to the next more wighted digit
		sub $s0,$s0,1		#decrements the number for looping
		
		mult $s2,$s1		# multiplies the weight holder by the base to get the weight of the next slot
		mflo $s2		# stores the vlaue of multiplication to be used in the next weight multiplication
		
		ble $t3, $s0,Binary	#loops
		b Conversion		#goes to the conversion part when the loop is over
		

	Octal:
		li $s1,8		# the suitable base of the number system
		lbu $a0,($a1)		# loads the value pointed to by a1 in a0
		blt $a0,48,Error	# branches to the error handling part if the number is less than 0
		bgt $a0,56,Error	# branches to the error handling part if the number is more than 8
		sub $a0,$a0,48		# decreases the ascii value so that it is equivalent to its integer value in the octal system

		mult $s2,$a0		# multiplies the number by its weight
		mflo $s4		# stores the result to be used into the addition to the value of the number string
		add $s3,$s3,$s4		# sums the values of the digits* their weights to get the real value of the number string
		subu $a1,$a1,1		#decrements the pointer to go to the next more wighted digit
		
		sub $s0,$s0,1		#decrements the number for looping
		
		mult $s2,$s1		# multiplies the weight holder by the base to get the weight of the next slot
		mflo $s2		# stores the vlaue of multiplication to be used in the next weight multiplication
		
		ble $t3, $s0,Octal	#loops
		b Conversion		#goes to the conversion part when the loop is over

	HexaDecimal:
		li $s1,16		# the suitable base of the number system
		lbu $a0,($a1)		# loads the value pointed to by a1 in a0
		blt $a0,48,Error	# branches to the error handling part if the number is less than 0
		bgt $a0,70,Error	# branches to the error handling part if the number is more than capital F
		blt $a0,58,HexNum	# checks that the number is less than 10 (the required range of 0 to 9)
		bgt $a0,64,HexLetter	# checks that the number is more than A (the required range of A to F)
		b Error
		
	HexNum: 
		sub $a0,$a0,48		# decreases the number by 48 if its between 0-9
		b HexNumWeight
	HexLetter:
		sub $a0,$a0,55 		#decreases the number by 55 if its between A-F
		
		
	HexNumWeight:
		mult $s2,$a0		# multiplies the number by its weight
		mflo $s4		# stores the result to be used into the addition to the value of the number string
		add $s3,$s3,$s4		# sums the values of the digits* their weights to get the real value of the number string
		subu $a1,$a1,1		#decrements the pointer to go to the next more wighted digit
		
		sub $s0,$s0,1		#decrements the number for looping
		
		mult $s2,$s1		# multiplies the weight holder by the base to get the weight of the next slot
		mflo $s2		# stores the vlaue of multiplication to be used in the next weight multiplication
		
		ble $t3, $s0,HexaDecimal
		b Conversion
					
# this part prints an error message and terminates if there is an error					
	Error: 

		li $v0,4		#Code for printing Error message
		la $a0,ErrorMessage	#puts the adress of the message in a0
		syscall
		li $v1, 0
		li $v0,10		# terminates the program
		syscall

	Conversion:
	

#This part Converts the Number to its binary form the prints it
		move $s7,$s3		# movres the real value ( the sum of multiplications of weights and slots) into s7
		la $a0,BinaryNum
		li $t7,0
		ConvertBinary:
			li $s0,2			
			div $s7,$s0			# divides the number by 2
			mfhi $s6			# gets the remainder of the division
			
			add $s6,$s6,48			# returns the number back to its ascii value
			sb $s6,($a0)			# stores the calue
			add $a0,$a0,1
			
			mflo $s7			# gets the result of the divison
			add $t7,$t7,1
			bnez $s7,ConvertBinary		
		la $s5, BinaryNum
		
		la $s1, BinaryTemp
		add $s5,$s5,$t7
		sub $s5,$s5,1
		FlipBinary:
			sub $t7,$t7,1		# subtracts 1 from t7
			
			lb $t8,($s5)		# loads the byte of s5 into t8
			sb $t8,($s1)		# loads the byte back into memory
			
			add $s1,$s1,1
			sub $s5,$s5,1
			
			bnez $t7,FlipBinary
		
	bne 	$t5,	7235938, DecPart			
														
		li $v0,4			# this Prints the result message on screen
		la $a0,BinaryForm	
		syscall
		
		li $v0,4			# this Prints the result itself on screen
		la $a0,BinaryTemp
		syscall	
	
	
#Printing the Decimal number automatically because we got the real value ind ecimal already because of the previous functions	
DecPart:
	
bne $t5,6514020, OctPart
		#Printing the Decimal number
		
		li $v0,4
		la $a0,DecimalForm
		syscall
		
		li $v0,1
		add $a0,$s3,$zero
		syscall
	
OctPart:
# Converts to the Octal system and prints the result on screen	
		add $s7,$s3,$zero
		la $a0,OctalNum
		li $t7,0
		ConvertOctal:
			li $s0,8
			div $s7,$s0
			mfhi $s6
			
			add $s6,$s6,48			
			sb $s6,($a0)
			add $a0,$a0,1
			
			mflo $s7
			add $t7,$t7,1
			bnez $s7,ConvertOctal		
		la $s5, OctalNum
		
		la $s1, OctalTemp
		add $s5,$s5,$t7
		sub $s5,$s5,1
		FlipOctal: #This Number that we got from the previous part is reversed since the remainder from the first divison is the most significant bit
			sub $t7,$t7,1
			#sub $s5,$s5,1
			
			lb $t8,($s5)
			sb $t8,($s1)
			
			add $s1,$s1,1
			sub $s5,$s5,1
			
			bnez $t7,FlipOctal
			
			
		bne $t5,7627631,HexPart	
			
			
		li $v0,4
		la $a0,OctalFormat
		syscall
		
		li $v0,4
		la $a0,OctalTemp
		syscall

HexPart:
# convets to the hexadecimal system and prints the vlaue on screen
add $s7,$s3,$zero
la $a0,HexaDecimalNum
li $t7,0
ConvertHexaDecimal:
			li $s0,16
			div $s7,$s0
			mfhi $s6
			
			bgt $s6,9,add_55
			
		add_48: add $s6,$s6,48	
			j after_add
		add_55: add $s6,$s6,55	
			j after_add
		after_add: 
			sb $s6,($a0)
			add $a0,$a0,1
			
			mflo $s7
			add $t7,$t7,1
			bnez $s7,ConvertHexaDecimal		
		la $s5, HexaDecimalNum
		
		la $s1, HexaDecimalTemp
		add $s5,$s5,$t7
		sub $s5,$s5,1
		FlipHexaDecimal:
			sub $t7,$t7,1
			
			lb $t8,($s5)
			sb $t8,($s1)
			
	add $s1,$s1,1
	sub $s5,$s5,1
			
			bnez $t7,FlipHexaDecimal
							# this prints the result message on the screen
							
				beq $t5,7890820, end			
													
	li $v0,4			
	la $a0,HexadecimalForm
	syscall
# prints the message with the Hexadecimal result
li $v0,4
la $a0,HexaDecimalTemp
syscall

end:
li $v0,10
syscall
