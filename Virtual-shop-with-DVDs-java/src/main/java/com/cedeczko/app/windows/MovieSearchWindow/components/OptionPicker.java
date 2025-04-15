package com.cedeczko.app.windows.MovieSearchWindow.components;

import com.cedeczko.app.logic.util.Pair;

import javax.swing.*;
import java.awt.*;
import java.awt.event.FocusEvent;
import java.awt.event.FocusListener;
import java.util.ArrayList;

public class OptionPicker extends JComboBox<String> {
    StateChangeListener listener;
    int fieldNo;
    public OptionPicker(ArrayList<String> options, StateChangeListener listener, int fieldNo) {
        this.listener = listener;
        this.fieldNo = fieldNo;

        addOptions(options);
        setSelectedIndex(-1);
        addActionListener(e -> {
            listener.onStateChange(new Pair< Integer, String >(fieldNo, (String)getSelectedItem()));
        });
    }
    public void updateStateChangeListener(StateChangeListener listener) {
        this.listener = listener;
        addActionListener(e -> {
            listener.onStateChange(new Pair< Integer, String >(fieldNo, (String)getSelectedItem()));
        });
    }


    void addOptions(ArrayList<String> options) {
        for (var option : options)
            addItem(option);
    }
}
