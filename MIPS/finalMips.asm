.data
	file1: .asciiz "file2.txt" #file name for out put
	input1: .asciiz "input1.txt" #file name for input	
	newline: .asciiz "\n"
	buffer: .space 800000
	file2: .asciiz "file2.txt" #file name for out put
	input2: .asciiz "input2.txt" #file name for input	
	
	fileDescriptor: .space 10000
	
	#defining const floats
	const_float1 : .float 1
	const_float2 : .float 2
	const_float3: .float 3
	const_float4: .float 4
	const_float5: .float 5
	const_float6: .float 6
	const_float7: .float 7
	const_float8 : .float 8
	const_float9: .float 9
	const_float10 : .float 10
	const_float11: .float 0.1
	
	number : .space 16
	
	k : .asciiz "\r"
.text
	#open file for input
	li $v0, 13
    	la $a0, input1
   	li $a1, 0
       	li $a2, 0
        syscall 
        
        move $s0 , $v0 #move file descriptor to $s0
        la $v0 , fileDescriptor
        sw $s0 , 0($v0)
        
        #read from file 
	li $v0 , 14
	move $a0 , $s0
	la $a1 , buffer
	li $a2 , 100000
	syscall
	move $s1 , $v0 #save length of string
	
	#close the file 
	li $v0 , 16
	move $a0 , $s0 #move file descriptor
	syscall
	
	#creating array for ints
	li $a0 ,1000 
	mul $a0 , $a0 , 4
	li $v0 , 9
	syscall	
	move $s4 , $v0 #adress of first array for numbers
	
	#creating array for powers
	li $a0 , 1000
	mul $a0 , $a0 , 4
	li $v0 , 9
	syscall
	move $s5 , $v0 #address of second array for powers

	li $t0 , 0 #loop counter
	li $t1 , 1000 #size of loop	
	li $t2 , 0 #counter for buffer
	li $t4 , 0 #for the reading the first number from file
	
	#storing the address of arrays 
	addi $sp , $sp , -8
	sw $s4,  4($sp)
	sw $s5 , 0($sp)
#start parsing numbers from file
loop:
	beq $t0 , $t1 , exit
	
	lb $t3, buffer($t2)
	beq $t3, 0, exit #check for null end of the string
	beq $t3 , 10 , nextLine
	
	sub $t3 , $t3 , '0'
	mul $t4 , $t4 , 10
	add $t4 , $t4  , $t3
	
	addi $t2 , $t2 , 1 #counter ++
	j loop
	nextLine:
	mul $t9 , $t0 , 4
	add $s6 , $s4 , $t9 #setting the address for the first array
	add $s7 , $s5 , $t9 #setting the address for the second array
	
	sw $t4 , 0($s6) # storing the i th number in i th element of first array
	
	addi $t2 , $t2 , 3#counter = 2 for next line 
	lb $t3 ,buffer($t2) 
	sub $t3 , $t3 , '0'
	sw $t3 , 0($s7) #storing the i th power in the i th element of second array
	li $t4 , 0 #set $t4 (the register used for getting the number from file)
	addi $t0 , $t0 , 1 #loop counter ++
	addi $t2 , $t2 , 4 #counter += 2 (not ++ cause next char is '\n' )
	j loop
exit:	
	#restoring address of arrays 
	lw $s5, 0($sp)
	lw $s4 ,4($sp)
	addi $sp , $sp , 8
	
	li $a0 , 1000
	mul $a0 , $a0 , 4
	li $v0 , 9
	syscall
	move $s6 , $v0 #address of third array for 10 ^ powers

	li $t0 , 0 #counter
	li $t1 , 1000 #loop size
loop_set_power:
	beq $t0 , $t1 , end_loop_set_power
	mul $t9 , $t0 , 4
	add $s7 , $s5, $t9
	lw $a0 , 0($s7)
	
	addi $sp , $sp , -4
	sw $t0 , 0($sp)
	jal power
	lw $t0 , 0($sp)
	addi $sp , $sp , 4
	
	add $s7 , $s6 , $t9
	sw $v0 , 0($s7)
	
	addi $t0 , $t0 , 1
	j loop_set_power
end_loop_set_power:
				
	li $t0  ,0 #counter
	li $t1 , 1000 #loop size
	
	li $a0 , 1000
	mul $a0 , $a0 , 4
	li $v0 , 9
	syscall
	move $s7 , $v0 #address of array for restoring floats
	
	
loop2:
	beq $t0 , $t1 , end_part1
	
	mul $t9 , $t0 ,4
	add $s1 , $s4 ,$t9
	add $s0 , $s6 , $t9
	add $s2  , $s7 , $t9

	lw $a0 , 0($s1)
	lw $a1 , 0($s0)
	
	mtc1 $a0 , $f0
	mtc1 $a1 , $f1
	
	cvt.s.w $f0 , $f0
	cvt.s.w $f1 , $f1
	
	div.s $f12 , $f0 , $f1
	swc1  $f12 , 0($s2) # save the i th float number in i th element of float array
	
	
	#print parts
	li $v0  , 2
	syscall
	
	li $v0 ,4
	la $a0 , newline
	syscall
	
	move $a0 , $a1
	li $v0, 1
	syscall
	
	li $v0 ,4
	la $a0 , newline
	syscall
	
	addi $t0 , $t0 , 1
	j loop2
	
end_part1 :
	#the only thing that is important from part one is register #s7 which has address of floats
	
	#start loadining const floats in FP registers
	l.s $f1 , const_float1
	l.s $f2 , const_float2
	l.s $f3 , const_float3
	l.s $f4 , const_float4
	l.s $f5 , const_float5
	l.s $f6 , const_float6
	l.s $f7 , const_float7
	l.s $f8 , const_float8
	l.s $f9 , const_float9
	
	l.s $f11  ,const_float11 
	l.s $f10 , const_float10
	
	#reset temp and arg registers and some save registers
	li $v0 , 0
	li $v1 , 0
	li $t0 , 0
	li $t1 , 0
	li $t2 , 0
	li $t3 , 0
	li $t4 , 0
	li $t5 , 0
	li $t6 , 0
	li $t7 , 0
	li $t8 , 0
	li $t9 , 0
	li $a0 , 0
	li $a1 , 0
	li $a2 , 0
	li $a3 , 0
	##########
	
	li $v0 , 5
	syscall
	move $v1 , $v0 #getting input from user for number "D"
	
	#open file
	li $v0, 13
    	la $a0, file2
   	li $a1, 1
       	li $a2, 0
        syscall 
	
	move $s0 , $v0 #moving file descriptor to reg $s0        
	addi $sp , $sp , -4
	sw $s0 , 0($sp)
	
	la $v0 , fileDescriptor
	sw $s0 , 0($v0)
	
        la $s1 , number 
        li $s2 , 1000 # number of inputs
        li $s3, 0 #counter ###################################################################must changed
        
        li $t0 , 0
        li $t1 , 0        
        li $t2 , 0        
        li $t3 , 0        
        li $t4 , 0        
        li $t5 , 0        
        li $t6 , 0        
        li $t7 , 0        
        li $t8 , 0        
        li $t9 , 0 
        
mainloop:
	beq $s3, $s2 , end
	
	mul $s4 , $s3 , 4
	add $s4 , $s4 , $s7 # getting address of i th element
	l.s $f0 , 0($s4)
	
	c.lt.s $f0 , $f10
	bc1t print_digit
	#every time divide by 10
	forloop:
		mul.s $f0 , $f11 , $f0 
		c.lt.s $f0 , $f10
		bc1t print_digit
		j forloop
	#checking the left most digit	
	print_digit:
		c.lt.s $f0 , $f1
		bc1t result0
		c.lt.s $f0 , $f2
		bc1t result1
		c.lt.s $f0 , $f3
		bc1t result2
		c.lt.s $f0 , $f4
		bc1t result3
		c.lt.s $f0 , $f5
		bc1t result4
		c.lt.s $f0 , $f6
		bc1t result5
		c.lt.s $f0 , $f7
		bc1t result6
		c.lt.s $f0 , $f8
		bc1t result7
		c.lt.s $f0 , $f9
		bc1t result8
		c.lt.s $f0 , $f10
		bc1t result9
	result0:
		li $v0 , 1
		li $a0 ,0
		syscall
		li $a3 , '0'
		jal write_result_on_file	
		addi $t0 , $t0 , 1
		j mainloop	
	result1:
		li $v0 , 1
		li $a0 , 1
		syscall 
		li $a3 , '1'
		jal write_result_on_file	
		addi $t1 , $t1 , 1
		j mainloop
	result2:
		li $v0 , 1
		li $a0 , 2
		syscall 
		li $a3 , '2'
		addi $t2 , $t2 , 1
		jal write_result_on_file	
		j mainloop
	result3:
		li $v0 , 1
		li $a0 , 3
		syscall 
		li $a3 , '3'
		addi $t3 , $t3 , 1
		jal write_result_on_file	
		j mainloop
	result4:
		li $v0 , 1
		li $a0 , 4
		syscall 
		li $a3 , '4'
		addi $t4 , $t4 , 1
		jal write_result_on_file		
	
		j mainloop
	result5: 
		li $v0 , 1
		li $a0 , 5
		syscall 
		li $a3 , '5'
		addi $t5 , $t5 , 1
		jal write_result_on_file	

		j mainloop
	result6:
		li $v0 , 1
		li $a0 , 6
		syscall 
		li $a3 , '6'
		addi $t6 , $t6 , 1
		jal write_result_on_file	

		j mainloop
	result7:
		li $v0 , 1
		li $a0 , 7
		syscall 
		li $a3 , '7'
		addi $t7 , $t7 , 1
		jal write_result_on_file	
		j mainloop
	result8:
		li $v0 , 1
		li $a0 , 8
		syscall 
		
		li $a3 , '8'
		jal write_result_on_file	
		addi $t8 , $t8 , 1
		j mainloop
	result9:
		li $v0 , 1
		li $a0 , 9
		syscall 
		
		li $a3 , '9'
		jal write_result_on_file
		addi $t9 , $t9 , 1
		j mainloop	
end:

	li $v0 ,4
	la $a0 , newline
	syscall
	
        jal calculate_percent
        
        li $v1 , 10
	div  $a0 , $v1
	
	mflo $a0
	addi $a0 , $a0 , '0'
	sb $a0 , number
	
	lw $s0 , 0($sp)
	addi $sp , $sp , 4
	
	#print the result on the file
	li $v0 , 15
	move $a0 , $s0
	la $a1 , number
	li $a2 , 1
	syscall
	
	mfhi $a0
	addi $a0 , $a0 ,'0'
	sb $a0 , number
	
	#print the result on the file
	li $v0 , 15
	move $a0 , $s0
	la $a1 , number
	li $a2 , 1
	syscall
	
	
	
	
	#close the file 
    	li $v0 , 16
    	syscall
	
	#terminate the programm
	li $v0 , 10
	syscall
        
	
################################################################# subroutins
power:
li $t0 , 0 #counter
li $v0 , 1
powerLoop:
	beq $t0 , $a0 , endPower
	mul $v0 , $v0 , 10
	addi $t0 , $t0 , 1
	j powerLoop
endPower:
	jr $ra	
								
write_result_on_file:	
	add $a0 , $0 , $a3
	sb $a0 , number #store the result in string number
	#write on file 
#	li $v0 , 15
#	move $a0 , $s0
#	la $a1 , number
#	li $a2 , 1
#	syscall
	#print space
#	addi $a0 , $0 , ' '
#	sb $a0 , number
	
#	li $v0 , 15
#	move $a0 , $s0
#	la $a1 , number
#	li $a2 , 1
#	syscall
	
	addi $s3 ,$s3 , 1
	jr $ra

calculate_percent:
	addi $sp , $sp , -4
	sw $ra , 0($sp)
	
	move $s0 , $v1 # s0 contain number "D"
	add $v1 , $0, $t0
	add $v1 , $v1 , $t1
	add $v1 , $v1, $t2
	add $v1 , $v1, $t3
	add $v1 , $v1, $t4
	add $v1 , $v1, $t5
	add $v1 , $v1, $t6
	add $v1 , $v1, $t7
	add $v1 , $v1, $t8
	add $v1 , $v1, $t9
	
	jal get_t_register #after this we have number  of desire number "D" in $v0
	li $t0 , 100
	mul $v0 , $v0 , $t0
	div $v0 , $v0 , $v1
	
	#print the result
	move $a0 , $v0
	li $v0 , 1
	syscall
	lw $ra , 0($sp)
	addi $sp , $sp , 4
	jr $ra
									
get_t_register:
	li $a0 ,0
	beq $s0  , $a0 , t0
	li $a0 ,1
	beq $s0  , $a0 , t1
	li $a0 ,2
	beq $s0  , $a0 , t2
	li $a0 ,3
	beq $s0  , $a0 , t3
	li $a0 ,4
	beq $s0  , $a0 , t4
	li $a0 ,5
	beq $s0  , $a0 , t5
	li $a0 , 6
	beq $s0  , $a0 , t6
	li $a0 ,7
	beq $s0  , $a0 , t7
	li $a0 ,8
	beq $s0  , $a0 , t8
	li $a0 ,9
	beq $s0  , $a0 , t9
	t0:
		move $v0 , $t0
		j end_t_register
	t1:
		move $v0 , $t1	
		j end_t_register
	t2:
		move $v0 , $t2	
		j end_t_register
	t3:
		move $v0 , $t3
		j end_t_register
	t4:
		move $v0 , $t4	
		j end_t_register
	t5:
		move $v0 , $t5
		j end_t_register
	t6:
		move $v0 , $t6
		j end_t_register
	t7:
		move $v0 , $t7
		j end_t_register
	t8:
		move $v0 , $t8	
		j end_t_register			
	t9:
		move $v0 , $t9	
		j end_t_register				
	end_t_register:
	jr $ra	
									
											
