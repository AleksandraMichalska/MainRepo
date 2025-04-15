package com.cedeczko.app.data;

import com.cedeczko.app.logic.Film;
import org.junit.Test;

import java.sql.SQLException;
import java.util.ArrayList;

import static org.junit.Assert.assertEquals;

public class TestDatabaseConnector {
    @Test
    public void testValidConnection() {
        DatabaseConnector db = new DatabaseConnector();

        try {
            ArrayList<Film> films = db.getFilms();
            assertEquals("The Shawshank Redemption", films.get(0).getTitle());
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

    }
}
