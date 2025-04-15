package com.cedeczko.app.logic.util;

import com.cedeczko.app.data.Database;
import com.cedeczko.app.data.DatabaseConnector;
import com.cedeczko.app.data.MovieCache;
import com.cedeczko.app.logic.Film;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class MovieListUtils {
    static Database db = new DatabaseConnector();

    public static ArrayList<String[]> getData() {
        var filmCache = MovieCache.films;
        ArrayList<Film> films = new ArrayList<>();
        var data = new ArrayList<String[]>();
        if (!filmCache.isEmpty()) {
            films = new ArrayList<>(filmCache.values());
        } else {
            try {
                films = db.getFilms();
                for (var film : films)
                    MovieCache.addFilm(film);
            } catch (Exception e) {
                System.out.println(e.getMessage());
                String[] genres = new String[] { "Action", "Horror", "Thriller", "Comedy" };
                for (int i = 0; i < 30; i++) {
                    data.add(new String[] { "a" + i, "b" + (i % 10), genres[i % 4], "c" + i });
                }
            }
        }
        for (var film : films) {
            String title = film.getTitle();
            String director = film.getDirector();
            String genres = film.getGenres().toString();
            genres = genres.substring(1, genres.length() - 1);
            String year = Integer.toString(film.getYear());
            int price_int = film.getPrice();
            float price_float = price_int / 100;
            String price = Float.toString(price_float);
            String description = film.getDescription();
            data.add(new String[] { title, director, genres, year, price, description });
        }

        return data;
    }

    public static ArrayList<String> getGenres() {
        ArrayList<String> genres;
        var genreCache = MovieCache.genres;
        if (!genreCache.isEmpty()) {
            return new ArrayList<>(genreCache);
        }
        try {
            genres = db.getGenres();
            genres.add(0, "");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            genres = new ArrayList<>(List.of(new String[] { "Action", "Horror", "Thriller", "Comedy" }));
        }
        for (var genre : genres) {
            MovieCache.addGenre(genre);
        }

        return genres;
    }

    public static String[] getFields() {
        return new String[] { "Tytuł", "Reżyser", "Gatunek", "Rok" };
    }

    public static ArrayList<String[]> limitTableData(SearchParams searchParams, ArrayList<String[]> data) {
        return (ArrayList<String[]>) data.stream()
                .filter(searchParams::listIncludesParams)
                .collect(Collectors.toList());
    }
}
