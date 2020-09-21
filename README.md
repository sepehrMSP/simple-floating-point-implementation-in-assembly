# Simple Floating-Point Implementation In Assembly

## Project Description

Consider a list of positive floating-point numbers stored in a file. The purpose is two write programs for MIPS-32 and 8086 assemblies to compute the percentage of numbers in which the most significant digit of them is equal to the desired digit like `d`, and print the result in the console and write out it in a file.
8086 processor doesn't support any builtin floating-point operation and software implementation of required operations must be done by yourself. You can use _IEEE754-Half-Precision_ standard. In this standard every floating-point number is saved in the following format:

![format](https://github.com/sepehrMSP/simple-floating-point-implementation-in-assembly/blob/master/images/IEEE_754r_Half_Floating_Point_Format.png)

Also, you must provide floating-point numbers by yourself. In this case, you can use any data sets or use other languages to produce this list. Your list has to contain at least 1000 numbers. 

## Description

### Section 1: preparing floating-point numbers

The way of producing numbers is to display every floating-point number in 2 lines, which the first line is an integer with at most 8 digits and the second line is a single digit between 0 and 5 so that the floating-point number is the result of dividing the first line number by power of 10 of the second line number. For better understanding see the following example :

```
> 2.34 
234
2

> 67.455
67455
3
``` 
This way of the display has a benefit. Because we are reading numbers from a file character by character, and string conversion is hardcoded (at least for 8086), this conversion will be easier than the case of showing a full floating-point number in a line by point( like 2.34 instead of 234 and 2).
For producing numbers I've written a Java program which is attached in `randomGenerator` folders. The Java program for 8086 is a bit different due to the constraints we have in storing large numbers in 8086 (numbers are 16bits). Therefore I used a smaller range of numbers for it. 

### Section 2: MIPS

Due to the built-in floating-point implementation of MIPS, First I read numbers from the file and by `MTC1` and `MFC1` instructions, convert read integers to floating-point, and save them in a 4000 bytes array. Besides, reserve registers `t0` to `t9` for digits counter. Then I start reading numbers from this array and divide them by 10 until they are greater than 10. when the number gets smaller than 10 I find its most significant digit by casing between 0 to 9 and increment the register corresponding to the digit. Finally, by using the values of registers `t0` to `t9` I've computed the percentage of asked digit `d`, among all digits, and output it in the console and file.


### Section 3: 8086

At first, let's explain my implementation of floating-point in 8086. The 10 first bits are _fraction_. The next 5 bits are _power_. and the last bit is _sign bit_ which is always 0 due to our positive numbers. Also, I've used _2's complement_ for _power_ instead of _bias notation_ and implementation is so that it doesn't have much difference with _IEEE 754_. This was mainly because of easier sum and subtract and also using 8086 comparing instructions which all work with _2's complement_.
For this section, I have read numbers from the file in a loop. Also, I've saved `0.1` in the format of floating-point in `deci`. In fact, instead of dividing by 10, I use multiply in 0.1. For saving the most significant digits I used 10 words of memory. 
A function is defined to save numbers in the format of floating-point. The functionality is so that we first shift the input number until the 11th bit equals to 1. Then save the first 10 bit as _fraction_ and _power_ is the number of shifts to left times.
Then the function of multiplying 2 floating-point numbers is defined. In this function first, I separated _power_ bits and add them. Next separated _fraction_ bits and multiplying them. Now if the result is 22 bits I add 1 to _power_. Then take most 11 significant bits of the 22 bits. Set the 11th bit to zero and take the remaining 10 bits as _fraction_ of multiplication. Now shift _power_ 10 bits to left and add with the fraction. Now the 16 bits number shows the result of the multiplication. 
Now by having floating-point multiplication and powers read from the file, we compute 0.1 * _power_ and multiply the result to the corresponding integer to obtain the floating-point number. After this, we act as the section before; means dividing floating-point by 10 (i.e multiply it by 0.1) until it is greater than 10. 
Also to compare 2 floating-point numbers, First _power_ is computed then shift it 11 bits to the left to have a correct comparison in case of negative _power_. If powers are equal then _fractions_ are compared. Finally, like the section before, using saved numbers in memory, compute the percentage of digit  `d` among all digits and output it on the console and file. 
