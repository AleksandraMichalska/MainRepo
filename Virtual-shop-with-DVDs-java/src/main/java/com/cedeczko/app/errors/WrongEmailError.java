package com.cedeczko.app.errors;

public class WrongEmailError extends RuntimeException {
    public WrongEmailError(String errorMessage) {
        super(errorMessage);
    }
}