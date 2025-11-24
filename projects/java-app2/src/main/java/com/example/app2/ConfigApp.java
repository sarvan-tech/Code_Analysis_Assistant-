package com.example.app2;

public class ConfigApp {
    public static void main(String[] args) {
        String dbUrl = "jdbc:mysql://localhost:3306/test"; // Hardcoded config
        for (int i = 0; i < 1000000; i++) {
            System.out.println("Processing " + i); // Inefficient logging
        }
    }
}