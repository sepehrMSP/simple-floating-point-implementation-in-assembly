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
This way of display has a benefit. Because we are reading numbers from a file character by character, and string conversion is hardcoded (at least for 8086), this conversion will be easier than the case of showing a full floating-point number in a line by point( like 2.34 instead of 234 and 2).
For producing numbers I've written a Java program which is attached in `randomGenerator` folders. The Java program for 8086 is a bit different due to the constraints we have in storing large numbers. Therefore I used a smaller range of numbers for it. 

### Section 2: MIPS


### Section 3: 8086
