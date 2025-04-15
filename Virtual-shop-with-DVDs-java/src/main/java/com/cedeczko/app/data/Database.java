package com.cedeczko.app.data;

import com.cedeczko.app.logic.Film;

import java.util.*;
import java.sql.SQLException;

public interface Database {
    ArrayList<Film> getFilms() throws SQLException;
    ArrayList<String> getGenres() throws SQLException;
    void deleteFilm(String[] filmInformation);
    int addClientsData(String name, String surname, String street, String building, int flat, String postalCode, String city, String email);
    void addReceipt(int customerId, String dateTime, float price, List<String[]> products);
}
