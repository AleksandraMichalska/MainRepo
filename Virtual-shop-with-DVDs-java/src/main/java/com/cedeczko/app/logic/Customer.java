package com.cedeczko.app.logic;

import com.cedeczko.app.errors.WrongEmailError;
import com.cedeczko.app.errors.EmptyStringError;
import com.cedeczko.app.errors.NegativeValueError;
import com.cedeczko.app.errors.WrongPostalCodeError;

import java.util.regex.Pattern;

public class Customer {
    private String name;
    private String surname;
    private String street;
    private String building; //może lepiej int ale czasem jest ulica 19c czy coś
    private int flat;
    private String postal_code;
    private String city;
    private String email;

    public Customer(String given_name, String given_surname, String given_street, String given_building, int given_flat, String given_postal_code, String given_city, String given_email) {
        setName(given_name);
        setSurname(given_surname);
        setStreet(given_street);
        setBuilding(given_building);
        setFlat(given_flat);
        setPostalCode(given_postal_code);
        setCity(given_city);
        setEmail(given_email);
    }

    private boolean checkPostalCode(String given_postal_code) {
        Pattern postalCodePattern = Pattern.compile("^\\d\\d-\\d\\d\\d$");
        return postalCodePattern.matcher(given_postal_code).find();
    }

    private boolean checkEmail(String given_email) {
        Pattern emailPattern = Pattern.compile("^[\\w-.]+@([\\w-]+.)+\\.[A-Za-z]{2,4}$");
        return emailPattern.matcher(given_email).find();
    }

    public String getName(){
        return this.name;
    }
    
    public String getSurname(){
        return this.surname;
    }
    
    public String getStreet(){
        return this.street;
    }

    public String getBuilding(){
        return this.building;
    }

    public int getFlat(){
        return this.flat;
    }

    public String getPostalCode(){
        return this.postal_code;
    }

    public String getCity(){
        return this.city;
    }

    public String getEmail(){
        return this.email;
    }

    public void setName(String new_name){
        if (new_name.isEmpty()) {
            throw new EmptyStringError("Name cannot be empty.");
        }
        this.name = new_name;
    }
    
    public void setSurname(String new_surname){
        if (new_surname.isEmpty()) {
              throw new EmptyStringError("Surname cannot be empty.");
        }
        this.surname = new_surname;
    }
    
    public void setStreet(String new_street){
        if (new_street.isEmpty()) {
              throw new EmptyStringError("Street cannot be empty.");
        }
        this.street = new_street;
    }

    public void setBuilding(String new_building){
        if (new_building.isEmpty()) {
              throw new EmptyStringError("Building cannot be empty.");
        }
        this.building = new_building;
    }

    public void setFlat(int new_flat){
        if (new_flat <= 0) {
              throw new NegativeValueError("Flat number has to be positive.");
        }
        this.flat = new_flat;
    }

    public void setPostalCode(String new_postal_code){
        if (!checkPostalCode(new_postal_code)) {
            throw new WrongPostalCodeError("Postal code has to have XX-XXX format (X - integer)");
        }
        this.postal_code = new_postal_code;
    }

    public void setCity(String new_city){
        if (new_city.isEmpty()) {
              throw new EmptyStringError("Building cannot be empty.");
        }
        this.city = new_city;
    }

    public void setEmail(String new_email){
        if (!checkEmail(new_email)) {
            throw new WrongEmailError("Email has to have @");
        }
        this.email = new_email;
    }
}