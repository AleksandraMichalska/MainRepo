package com.cedeczko.app.data;

import com.cedeczko.app.logic.Film;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;


public class MovieCache {
    static public Map<String, Film> films = new HashMap<>();
    static public Set<String> genres = new HashSet<>();

    public static void addFilm(Film film) {
        films.put(film.getId(), film);
    }
    
    public static void removeFilm(String filmId) {
      films.remove(filmId);
    }

    public static void addGenre(String genre) {
        genres.add(genre);
    }

    public static Film getFilm(String filmId) {
        return films.get(filmId);
    }

    public static Film getFilm(String title, String director) {
        String id = title.toLowerCase().replace(" ", "") + "_" + director.toLowerCase().replace(" ", "");
        return getFilm(id);
    }
}
