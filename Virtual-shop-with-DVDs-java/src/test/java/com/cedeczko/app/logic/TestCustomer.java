package com.cedeczko.app.logic;

import com.cedeczko.app.errors.EmptyStringError;
import com.cedeczko.app.errors.NegativeValueError;
import com.cedeczko.app.errors.WrongEmailError;
import com.cedeczko.app.errors.WrongPostalCodeError;
import org.junit.Test;

import static org.junit.Assert.assertEquals;
public class TestCustomer {
    @Test
    public void testConstructorAndGetters() {
        Customer customer = new Customer("John", "Smith", "Green St.", "123", 10, "12-345", "Warsaw", "john.smith@example.com");

        assertEquals("John", customer.getName());
        assertEquals("Smith", customer.getSurname());
        assertEquals("Green St.", customer.getStreet());
        assertEquals("123", customer.getBuilding());
        assertEquals(10, customer.getFlat());
        assertEquals("12-345", customer.getPostalCode());
        assertEquals("Warsaw", customer.getCity());
        assertEquals("john.smith@example.com", customer.getEmail());
    }
    @Test
    public void testSetName() {
        Customer customer = new Customer("John", "Smith", "Green St.", "123", 10, "12-345", "Warsaw", "john@example.com");
        customer.setName("NewName");
        assertEquals("NewName", customer.getName());
    }

    @Test(expected = EmptyStringError.class)
    public void testSetNameEmpty() {
        Customer customer = new Customer("John", "Smith", "Green St.", "123", 10, "12-345", "Warsaw", "john-smith@example.com");
        customer.setName("");
    }

    @Test
    public void testSetSurname() {
        Customer customer = new Customer("John", "Smith", "Green St.", "123", 10, "12-345", "Warsaw", "john3@example.com");
        customer.setSurname("NewSurname");
        assertEquals("NewSurname", customer.getSurname());
    }

    @Test(expected = EmptyStringError.class)
    public void testSetSurnameEmpty() {
        Customer customer = new Customer("John", "Smith", "Green St.", "123", 10, "12-345", "Warsaw", "john@example.gmail.com");
        customer.setSurname("");
    }

    @Test
    public void testSetStreet() {
        Customer customer = new Customer("John", "Smith", "Green St.", "123", 10, "12-345", "Warsaw", "john@example.com");
        customer.setStreet("NewGreen St.");
        assertEquals("NewGreen St.", customer.getStreet());
    }

    @Test(expected = EmptyStringError.class)
    public void testSetStreetEmpty() {
        Customer customer = new Customer("John", "Smith", "Green St.", "123", 10, "12-345", "Warsaw", "john@example.com");
        customer.setStreet("");
    }

    @Test
    public void testSetBuilding() {
        Customer customer = new Customer("John", "Smith", "Green St.", "123", 10, "12-345", "Warsaw", "john@example.com");
        customer.setBuilding("456");
        assertEquals("456", customer.getBuilding());
    }

    @Test(expected = EmptyStringError.class)
    public void testSetBuildingEmpty() {
        Customer customer = new Customer("John", "Smith", "Green St.", "123", 10, "12-345", "Warsaw", "john@example.com");
        customer.setBuilding("");
    }

    @Test
    public void testSetFlat() {
        Customer customer = new Customer("John", "Smith", "Green St.", "123", 10, "12-345", "Warsaw", "john@example.com");
        customer.setFlat(2);
        assertEquals(2, customer.getFlat());
    }

    @Test(expected = NegativeValueError.class)
    public void testSetFlatNegative() {
        Customer customer = new Customer("John", "Smith", "Green St.", "123", 10, "12-345", "Warsaw", "john@example.com");
        customer.setFlat(-1);
    }

    @Test
    public void testSetPostalCode() {
        Customer customer = new Customer("John", "Smith", "Green St.", "123", 10, "12-345", "Warsaw", "john@example.com");
        customer.setPostalCode("11-111");
        assertEquals("11-111", customer.getPostalCode());
    }

    @Test(expected = WrongPostalCodeError.class)
    public void testSetPostalCodeInvalidLength() {
        Customer customer = new Customer("John", "Smith", "Green St.", "123", 10, "12-345", "Warsaw", "john@example.com");
        customer.setPostalCode("00000");
    }

    @Test(expected = WrongPostalCodeError.class)
    public void testSetPostalCodeInvalidFormat() {
        Customer customer = new Customer("John", "Smith", "Green St.", "123", 10, "12-345", "Warsaw", "john@example.com");
        customer.setPostalCode("000000");
    }

    @Test(expected = WrongPostalCodeError.class)
    public void testSetPostalCodeNonNumeric() {
        Customer customer = new Customer("John", "Smith", "Green St.", "123", 10, "12-345", "Warsaw", "john@example.com");
        customer.setPostalCode("00-abc");
    }
    @Test
    public void testSetWarsaw() {
        Customer customer = new Customer("John", "Smith", "Green St.", "123", 10, "12-345", "Warsaw", "john@example.com");
        customer.setCity("NewWarsaw");
        assertEquals("NewWarsaw", customer.getCity());
    }

    @Test(expected = EmptyStringError.class)
    public void testSetWarsawEmpty() {
        Customer customer = new Customer("John", "Smith", "Green St.", "123", 10, "12-345", "Warsaw", "john@example.com");
        customer.setCity("");
    }

    @Test
    public void testSetEmail() {
        Customer customer = new Customer("John", "Smith", "Green St.", "123", 10, "12-345", "Warsaw", "john@example.com");
        customer.setEmail("new.email@example.com");
        assertEquals("new.email@example.com", customer.getEmail());
    }

    @Test(expected = WrongEmailError.class)
    public void testSetEmailInvalidFormat() {
        Customer customer = new Customer("John", "Smith", "Green St.", "123", 10, "12-345", "Warsaw", "john.smith@example.com");
        customer.setEmail("invalid_email");
    }

}
