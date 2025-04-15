package com.cedeczko.app.logic;


import com.cedeczko.app.errors.EmptyStringError;
import com.cedeczko.app.errors.NoGenresError;
import com.cedeczko.app.errors.WrongPriceError;
import com.cedeczko.app.errors.WrongReleaseYearError;
import org.junit.Test;
import java.util.Arrays;
import java.util.List;
import javax.sql.rowset.serial.SerialBlob;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;


public class TestFilm {

    @Test
    public void testConstructorAndGetters() {
        List<String> genres = Arrays.asList("Drama", "Romance");

        Film film = new Film("The Title", "The Director", 2022, 100, genres, "Description", null);

        assertEquals("The Title", film.getTitle());
        assertEquals("The Director", film.getDirector());
        assertEquals(2022, film.getYear());
        assertEquals(100, film.getPrice());
        assertEquals(genres, film.getGenres());
        assertEquals("Description", film.getDescription());
        assertNull(film.getPoster());
    }

    @Test
    public void testPosterSetter() {
        Film film = new Film("Original Title", "Original Director", 2022, 100, List.of("Action"), "Original Description", null);

        SerialBlob newPoster = null;
        try {
            newPoster = new SerialBlob(new byte[] { 0x11, 0x22, 0x33 });
        } catch(Exception e) {
            System.out.println(e.getMessage());
        }
        film.setPoster(newPoster);
        assertEquals(newPoster, film.getPoster());
    }

    @Test
    public void testPriceSetter() {
        Film film = new Film("Original Title", "Original Director", 2022, 100, List.of("Action"), "Original Description", null);

        film.setPrice(150);
        assertEquals(150, film.getPrice());
    }

    @Test
    public void testDescriptionSetter() {
        Film film = new Film("Original Title", "Original Director", 2022, 100, List.of("Action"), "Original Description", null);

        film.setDescription("New Description");
        assertEquals("New Description", film.getDescription());
    }
    @Test(expected = WrongPriceError.class)
    public void testSetPriceWithNegativeValue() {
        Film film = new Film("Title", "Director", 2022, 100, List.of("Action"), "Description", null);

        film.setPrice(-50);
        assertEquals(100, film.getPrice());
    }

    @Test(expected = EmptyStringError.class)
    public void testEmptyTitleConstructor() {
        new Film("", "Director", 2022, 100, List.of("Action"), "Description", null);
    }

    @Test(expected = EmptyStringError.class)
    public void testEmptyDirectorConstructor() {
        new Film("Title", "", 2022, 100, List.of("Action"), "Description", null);
    }

    @Test(expected = WrongReleaseYearError.class)
    public void testInvalidYearConstructor() {
        new Film("Title", "Director", 1888, 100, List.of("Action"), "Description", null);
    }

    @Test(expected = WrongPriceError.class)
    public void testNegativePriceConstructor() {
        new Film("Title", "Director", 2022, -50, List.of("Action"), "Description", null);
    }

    @Test(expected = NoGenresError.class)
    public void testNoGenresConstructor() {
        new Film("Title", "Director", 2022, 100, List.of(), "Description", null);
    }
}

