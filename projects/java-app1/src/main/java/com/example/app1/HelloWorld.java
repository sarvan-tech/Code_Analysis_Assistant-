package com.example.app1;

import java.util.Date;

public class HelloWorld {
    public static void main(String[] args) {
        Date date = new Date(2020, 12, 31); // Deprecated API
        try {
            int result = 10 / 0; // Runtime exception
        } catch (Exception e) {
            System.out.println("Error occurred"); // Poor logging
        }
        System.out.println("Hello, World! " + date);
    }
}
