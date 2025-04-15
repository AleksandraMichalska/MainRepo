package com.cedeczko.app.logic.util;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class TestPair {
    @Test
    public void testConstructorAndGetters() {
        // Arrange
        String key = "TestKey";
        Integer value = 42;

        // Act
        Pair<String, Integer> pair = new Pair<>(key, value);

        // Assert
        assertEquals(key, pair.getKey());
        assertEquals(value, pair.getValue());
    }

    @Test
    public void testKeySetter() {
        Pair<String, Integer> pair = new Pair<>("InitialKey", 123);

        pair.setKey("UpdatedKey");

        assertEquals("UpdatedKey", pair.getKey());
    }

    @Test
    public void testValueSetter() {
        Pair<String, Integer> pair = new Pair<>("Key", 456);

        pair.setValue(789);

        assertEquals(789, (int) pair.getValue());
    }
}
