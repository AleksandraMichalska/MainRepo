package com.cedeczko.app.logic;

import com.cedeczko.app.errors.EmptyStringError;
import com.cedeczko.app.errors.NoGenresError;
import com.cedeczko.app.errors.WrongPriceError;
import com.cedeczko.app.errors.WrongReleaseYearError;

import java.sql.Blob;
import java.util.*;
import javax.sql.rowset.serial.SerialBlob;
import java.time.LocalDate;

public class Film {
    final private String title;
    final private String director;
    final private int year;
    private int price; // w groszach
    final private List<String> genres;
    private String description;
    private Blob poster;

    public Film(String g_title, String g_director, int g_year, int g_price, List<String> g_genres, String g_description,
            Blob g_poster) {
        if (g_title.isEmpty()) {
            throw new EmptyStringError("The title canot be empty.");
        }
        this.title = g_title;
        if (g_director.isEmpty()) {
            throw new EmptyStringError("The director's name canot be empty.");
        }
        this.director = g_director;
        if (g_year > 1888 && g_year <= LocalDate.now().getYear()) {
            this.year = g_year;
        } else {
            throw new WrongReleaseYearError("The release year is either too early or later than current year.");
        }
        setPrice(g_price);
        if (g_genres.isEmpty()) {
            throw new NoGenresError("Films must belong to at least one genre.");
        }
        genres = g_genres;
        setDescription(g_description);
        setPoster(g_poster);
    } // g = given

    public String getTitle() {
        return this.title;
    }

    public String getDirector() {
        return this.director;
    }

    public int getYear() {
        return this.year;
    }

    public int getPrice() {
        return this.price;
    }

    public List<String> getGenres() {
        return this.genres;
    }

    public String getDescription() {
        return this.description;
    }

    public Blob getPoster() {
        return this.poster;
    }

    public String getId() {
        return getTitle().toLowerCase().replace(" ", "") + "_" + getDirector().toLowerCase().replace(" ", "");
    }

    // jedyne atrybuty, które mogą się zmieniać
    public void setPrice(int new_price) {
        if (new_price <= 0) {
            throw new WrongPriceError("Price must be positive.");
        }
        price = new_price;
    }

    public void setDescription(String new_description) {
        this.description = new_description;
    }

    public void setPoster(Blob new_poster) {
        this.poster = new_poster;
    }
}
