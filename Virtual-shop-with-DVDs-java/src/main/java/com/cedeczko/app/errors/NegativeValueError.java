package com.cedeczko.app.errors;

public class NegativeValueError extends RuntimeException {
    public NegativeValueError(String errorMessage) {
        super(errorMessage);
    }
}