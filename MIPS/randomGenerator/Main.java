package com.company;

import java.io.*;
import java.util.Random;

public class Main {

    public static void main(String[] args) {
        final long shift = (long) Math.abs(Math.pow(10, 8));
        Random r1 = new Random();
        Random r2 = new Random();
        for (int i = 0; i < 1000; i++) {
            int x = r1.nextInt();
            int y = r2.nextInt();
            x = x % 1000;
            y = y % 1000;
            y = Math.abs(y);
            x = Math.abs(x);
            long firstNumber = Math.abs(x * x * x);
//            System.out.println(firstNumber);
            firstNumber = (long) getFirstNumber(shift, firstNumber);
            firstNumber += Math.abs(2 * x + x * x * 5 + x * x * x);
            firstNumber = (long) getFirstNumber(shift, firstNumber);
            long secondNumber = (long) (Math.abs(Math.pow(y, 4) + 2 * y) % 5);
            try (FileWriter first = new FileWriter("yourFile.txt", true);
                 BufferedWriter second = new BufferedWriter(first);) {
                PrintWriter out = new PrintWriter(second);
                out.println(firstNumber + "\n");
                out.println(secondNumber + "\n");
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    private static double getFirstNumber(long shift, double firstNumber) {
        while (firstNumber >= shift)
            firstNumber -= shift;
        return firstNumber;
    }
}
