package com.cedeczko.app.errors;

public class WrongPostalCodeError extends RuntimeException {
    public WrongPostalCodeError(String errorMessage) {
        super(errorMessage);
    }
}