package com.cedeczko.app.windows.MovieSearchWindow.components;

import com.cedeczko.app.logic.util.Pair;

import javax.swing.*;
import java.awt.*;
import java.awt.event.FocusEvent;
import java.awt.event.FocusListener;

public class SearchBox extends JTextField {
    String searchBoxValue;
    StateChangeListener listener;
    int fieldNo;
    boolean initialFocus = true;
    public SearchBox(String defaultText, String tooltip, int columns, StateChangeListener listener, int fieldNo) {
        searchBoxValue = "";
        this.listener = listener;
        this.fieldNo = fieldNo;

        setColumns(columns);
        setText(defaultText);
        setForeground(Color.LIGHT_GRAY);

        setToolTipText(tooltip);
        addActionListener(e -> {
            searchBoxValue = getText();
            listener.onStateChange(new Pair<Integer, String>(fieldNo, searchBoxValue));
        });
        addFocusListener(new FocusListener() {
            @Override
            public void focusGained(FocusEvent e) {
                if(initialFocus) {
                    setText("");
                    setForeground(Color.BLACK);
                    initialFocus = false;
                }
            }
            @Override
            public void focusLost(FocusEvent e) {
                //nothing
            }
        });
    }

    public void updateStateChangeListener(StateChangeListener listener) {
        this.listener = listener;
        addActionListener(e -> {
            searchBoxValue = getText();
            listener.onStateChange(new Pair<Integer, String>(fieldNo, searchBoxValue));
        });
    }
}
