#####################################################################
# Letter Frequency Table		Programmer: DemonAxe
# Due Date: 3-24-23	
# Last Modified: 03-24-2023
#####################################################################
# Functional Description:
#	This code asks the user for an input of string, then  
#	The program removed all characters except of letters.
#	Then it counts how many times each character has been used 
#	and prints the results
#
#####################################################################
# Pseudocode:
#
#	Prompt the user for a string of text	
#	take the user input and add it to a string array
#	check if the current character of the array is a letter
#	if it is not a letter then skip it and loop back if it is then jump to add the character to the integer array at the characters spot
#	once the character is added as an instance of the letter and 1 is added to the already existing number we loop back to the next character at loop
#	Once we are done with all the characters we jump to a section of the code that will loop through the integer array and print each with a space in between
#	After we print all of the array letter and how many they are, we prompt the user to run the program again
#	if the user says yes then we clear all the registers and arrays and ask them for the string array again
#	If the user does not want then we print a thank you msg and end the program
#		
######################################################################
# Register Usage:
# $a0: system call argument
# $a1: string limit argument			
# $t2: holds the character from the sting
# $t3: hold the character from the string for manipulation to add to the int array
# $t6: saves the integer amount from the array for printing 
# $t7: used as a counter when printing the int array
# $s1: Used as the position in the integer array when pulling and saving the number
# $s2: used to hold the value of the integer when manipulating it
# $t4: the address of the array when clearing it
# $v0: Just used to hold values for print 
######################################################################

.data
	
	prompt: 	.asciiz "Enter a string (less than 100 chars): "	#this is used to prompt the user with what to do.
	output_prompt:	.asciiz "\nYour string with only letters is: "		#This is used to let the user know what the output is
	compressed: .space 100								#this reserves space in memory for the compressed string
	output_string: .space 100							#this is to store the output string 
	count_array:	.word	0:27							#Creating a 26 integer array
	space_char:	.asciiz " "							#string for space
	new_line:	.asciiz "\n"							#string for new character
	continue_prompt:	.asciiz "\nWould you like to try a new string(type 1 to go again(ONLY INTEGERS)): "		#This is used to let the user know what the output is
	end_prompt:	.asciiz "\nThank you for using the program! See you next time."		#This is used to let the user know what the output is
	freq_prompt: .asciiz "\nLetter Frequency Table:\n"
	hello_prompt: .asciiz "String Letter Counting Program!\nEnter a line of string and the program will count how many times any letters were repeated!\n\n" 
	
.text
main:
	li $v0, 4		#system call for print string
	la $a0, hello_prompt	#load address for the hello prompt
	syscall
start:
	########################################
	#This section sets all the register that are used in the program to 0
	li $t0, 0					
	li $t2, 0
	li $t3, 0
	li $t6, 0
	li $t7, 0
	li $s1, 0
	li $s2, 0
	li $t4, 0
	li $v0, 0	
	li $t9, 0
	########################################
	li	$v0, 4					#System call for printing string
	la 	$a0, prompt				#load the address of the prompt string
	syscall
	
	li	$v0, 8					#system call for reading string
	la	$a0, compressed				#load the address of the compressed string
	li	$a1, 100				#set a max of 100 characters to reading
	syscall
	#start of the loop and the code to check the characters.
	#This part is also used to store the string in compressed string to memory
	
#loop is used to get the position of the character in the string and the checking if it is a letter or not
loop:
		lb 	$t2, ($a0)			#Loads the current character from the compressed string
		beq 	$t2, 0, freq_prompt_print		#Test to see if the string has ended if it did then go to done:
		addi	$a0, $a0, 1			#add 1 to a0 so when we loop around we can grab the next character
		blt	$t2, 'A', loop			#if the character is less than 'A' then it is not a character and we can skip
		bgt	$t2, 'z', loop			#if the character is greater than 'z' then it is not a character and we skip
	#This part is used to remove the few punctuation things in between lower case and upper case characters in ascii
		ble	$t2, 'Z', turn_non_caps	#This checks if the letter is less than 'Z'
		bge	$t2, 'a', is_a_letter		#THis checks if the letter is more than 'a'
		j	loop				#this is used to jump to skip if the input is not a letter

turn_non_caps:
		addi $t2, $t2, 31			#Make caps letter non caps

#if it is a letter then we save the character to the new string and jump back to loop		
is_a_letter:
		sb 	$t2, output_string($t0)	#This will store the letter in output_string
		addi	$t0, $t0, 1			#add 1 to t1 so it can address the next character
		
		move	$t3, $t2			#move the character to t3 to be used in the character array
		addi	$t3, $t3, -97			#subtract 97 from the character to give us a 0-25 int
		
		sll $t3, $t3, 2				#Multiplies the number of the character by 4 so it can help find the position in the array
		add $s1, $zero, $t3			#Set the position of the array to s0
		lw $s2, count_array($s1)		#load the integer in that array position
		addi $s2, $s2, 1			#add 1 to the integer in the array for the new number of the character
		sb $s2, count_array($s1)		#Save that integer back into the array
		
		j 	loop				#Jump to loop so we can check the next character#Jumpt to loop since this character we can skip
freq_prompt_print:
		li $v0, 4
		la $a0, freq_prompt
		syscall
		
number_counter:				#count the numbers of the string to add them to the array
		li $t6, 0				#setting t6 to equal 0 for later use
		lw $t6, count_array($t4)		#using t4 to access a specific spot in the integer array
		addi $t4, $t4, 4			#add 4 to t4 so we can access the next spot in the array
		li $v0, 1				#system call for printing integers
		move $a0, $t6				#accessing the position on the integer in memory
		syscall
		
		li $v0, 4				#system cal for print string
		la $a0, space_char			#print space character to separate the results of the array
		syscall
		
		addi $t7, $t7, 1			#adding 1 to t7 since that acts as out counter
		beq $t7, 13, new_line_add		#if the loop runs 13 times jump to new_line_add to print a new line
		beq $t7, 26, continue			#once 26 characters are printed branch to continue
		
		j number_counter			#jump back to counter is non of the branches work so we can loop this part

new_line_add:
	li $v0, 4					#system call for print string
	la $a0, new_line				# address grab of the new line character
	syscall
	j number_counter				#once a new line is printed jump back to number_counter
	
clear_array:
	sb $t5, count_array($t4)			#This places 0 that is in t5 into the position on count array t4
	addi $t4, $t4, 4				#add 4 to t4 so it will let us access the next position in the array
	beq $t4, 104, start				#once we loop this part 26 times we jump back to main
	j clear_array					#else loop clear array again

continue:
	li $t4, 0					#make t4 equal 0 for later use
	li $v0, 4					#system call for print text
	la $a0, continue_prompt			#address gather for printing the continue_prompt
	syscall
	li $v0, 5					#system call to read integer
	syscall
	beq $v0, 1, clear_array			#if the user enters 1 then jump to clear array else keep moving down the code to done

#The next part of the code is just printing out the final string and ending the program
done:
		li $v0, 4				#system call to print string
		la $a0, end_prompt			#Calling the address for the end prompt
		syscall
		li $v0, 10				#system call to end program
		syscall
