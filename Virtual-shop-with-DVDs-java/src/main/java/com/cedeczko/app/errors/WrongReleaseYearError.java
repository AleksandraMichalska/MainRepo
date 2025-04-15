package com.cedeczko.app.errors;

public class WrongReleaseYearError extends RuntimeException {
    public WrongReleaseYearError(String errorMessage) {
        super(errorMessage);
    }
}
