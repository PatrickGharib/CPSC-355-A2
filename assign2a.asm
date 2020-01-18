//File: assign2a
//Author: Patrick Abou Gharib
//StudentID: 10137116
//Date: October 13, 2017
//description: create assembly code with the same functionality as c code that was provided

string1:	.string "multiplier = 0x%08x (%d) multiplicand = 0x%08x (%d)\n\n"
string2:	.string "product = 0x%08x multiplier = 0x%08x\n"
string3:	.string "64-bit result = 0x%016lx (%ld)\n"

	define(multiplier, w19)                             	//set macro for 32-bit regester
	define(multiplicand, w20)                           	//set macro for 32-bit regester  
	define(product, w21)                                	//set macro for 32-bit regester 
                                            
	define(i, w22)                                      	//set macro for 32-bit regester
	
	define(long_product, x23)                           	//set macro for 64-bit regester
	define(long_multiplier, x24)                        	//set macro for 64-bit regester
	define(result, x25)                                 	//set macro for 64-bit regester
	define(negative, w26)                               	//set macro for 32-bit regester
	define(temp1, x27)                                  	//set macro for 64-bit regester
	define(temp2, x28)                                 	//set macro for 64-bit regester
	
	

	.balign 4                                          	//ensure the following instruction is divisible by 4
	.global main                                       	//ensure the compiler see main 
	
main:
	stp     x29, x30, [sp, -16]!                       	//save FP and LR to the stack 
	mov     x29, sp                                     	//save FP and LR to the stack

	mov     multiplicand, -8192                         	//store -8192 in register w20
	mov     multiplier, 99                              	//store 99 in register w19
	mov     product, 0                                  	//store 0 in product

	adrp    x0, string1                                	//set x0 pointer to addr. of 1st char of string1  
	add     x0, x0, :lo12:string1                      	//put contents of string1 in x0      
	mov     w1, multiplier                             	//set arg2 to w19
	mov     w2, multiplier                              	//set arg3 to w19
	mov     w3, multiplicand                            	//set arg4 to w20
	mov     w4, multiplicand                            	//set arg5 to w20
	bl      printf                                      	//print string1
        
	mov     i, 0                                        	//set index counter to 1
    

	cmp multiplier, 0                                   	//compare multiplier to zero                  
	b.ge loop
	mov negative, 1 

    
loop:                                                   	//begin for loop
        							//check first if statement which is:
	ands    wzr, multiplier, 0x1                        	//bit AND comparison of multiplier and 0x1 
	b.eq    second_if                                  	//branch if the ANDS operation results in zero
	add     product, product, multiplicand              	//product = product + multiplicand
        							//w21 = w21 + w20
    
second_if:                                              	//check second if-else statement
	asr     multiplier, multiplier, 1                  	//arthimatic shift to the right by a shift count of one bit 
	ands    wzr, product, 0x1                           	//bitwise ands of product and 0x1, z flag set
	b.eq    else                                        	//if ands results zero branch to else case
	orr     multiplier, multiplier, 0x80000000          	//bitwise or on multiplier
	b       increment                                   	//branch to end of loop that increments the counter 
    
else:   
	and     multiplier, multiplier, 0x7FFFFFFF          	//bitwise and of multiplier 
            
increment:                                      
	asr     product, product, 1                         	//arithmatic shift to the right by a shift count of one bit
	add     i, i, 1                                     	//increment the loop counter by one bit

test:                                           
	cmp     i, 32                                       	//checks loop counter 
	b.lt   loop                                         	//if i less than 32 
    

product_adjust:                                 
	cmp     negative, 1                                 	//check negative boolean
	b.ne    print                                       	//if false branch straight to print
	sub     product, product, multiplicand              	//product = product - multiplicand

print:                                          
	adrp    x0, string2                                 	//set x0 pointer to addr. of 1st char of string2
	add     x0, x0, :lo12:string2                       	//put contents of string2 in x0 
	mov     w1, product                                 	//set arg2 to w20
	mov     w2, multiplier                              	//set arg3 to w19 
	bl      printf                                      	//print string2


res:
	sxtw    long_product, product                       	//change product from int to long int(32-bit to 64-bit)
	lsl     long_product, long_product, 32              	//logical shift to the left by a shift count of 32 bits 
	sxtw    long_multiplier, multiplier                 	//change long multiplier from int to long int(32-bit to 64)
	and     long_multiplier, long_multiplier, 0xFFFFFFFF	//bitwise and of long multiplier and 0xfffffffff
	add     result, long_product, long_multiplier       	//result = long_product + long_multiplier

done:  
	adrp    x0, string3                                 	//set x0 pointer to addr. of 1st char of string3  
	add     x0, x0, :lo12:string3                       	//put contents of string3 in x0
	mov     x1, result                                  	//set arg2 to result
	mov     x2, result                                  	//set arg3 to result 
	bl      printf                                      	//print string3
                
	
	ldp	    x29, x30, [sp], 16                          //restore the stack
	ret                                                 	//return to os
