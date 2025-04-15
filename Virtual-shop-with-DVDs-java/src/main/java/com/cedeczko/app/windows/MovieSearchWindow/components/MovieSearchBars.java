package com.cedeczko.app.windows.MovieSearchWindow.components;

import javax.swing.*;
import java.awt.*;
import java.util.ArrayList;

import com.cedeczko.app.logic.util.MovieListUtils;
import com.cedeczko.app.logic.util.Pair;

public class MovieSearchBars {
    private JPanel panel;
    private SearchBox movieNameTextField;
    private SearchBox movieAuthorTextField;
    private OptionPicker movieGenrePicker;
    private SearchBox movieYearTextField;
    private StateChangeListener listener = new StateChangeListener() {@Override public void onStateChange(Pair<Integer, String> newState) {}};

    public MovieSearchBars() {
        panel = new JPanel();

        movieNameTextField = createNameTextField();
        movieAuthorTextField = createAuthorTextField();
        movieGenrePicker = createMovieGenrePicker();
        movieYearTextField = createYearTextField();

        panel.add(BorderLayout.NORTH, movieNameTextField);
        panel.add(BorderLayout.NORTH, movieAuthorTextField);
        panel.add(BorderLayout.NORTH, movieGenrePicker);
        panel.add(BorderLayout.NORTH, movieYearTextField);
    }

    public void addStateChangeListener(StateChangeListener listener) {
        this.listener = listener;

        movieNameTextField.updateStateChangeListener(listener);
        movieAuthorTextField.updateStateChangeListener(listener);
        movieGenrePicker.updateStateChangeListener(listener);
        movieYearTextField.updateStateChangeListener(listener);
    }

    private SearchBox createNameTextField() {
        return new SearchBox("Tytuł...", "Wyszukaj film po tytule", 15, listener, 0);
    }
    private SearchBox createAuthorTextField() {
        return new SearchBox("Reżyser...", "Wyszukaj film po autorze", 15, listener, 1);

    }
    private OptionPicker createMovieGenrePicker() {
        ArrayList<String> genres = MovieListUtils.getGenres();
        return new OptionPicker(genres, listener, 2);

    }
    private SearchBox createYearTextField() {
        return new SearchBox("Rok...", "Wyszukaj film po roku wydania", 4, listener, 3);
    }

    public JPanel getPanel() {
        return panel;
    }
}
