package com.cedeczko.app.windows.MovieSearchWindow;

import com.cedeczko.app.logic.constants.WindowConstants;
import com.cedeczko.app.windows.BasketWindow;
import com.cedeczko.app.windows.MovieSearchWindow.components.MovieList;
import com.cedeczko.app.windows.MovieSearchWindow.components.MovieSearchBars;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class MovieSearchWindow {
    private JFrame frame;

    private MovieSearchBars movieSearchBars;
    private MovieList movieList;

    private JLabel loader;

    private JButton basketButton;

    public MovieSearchWindow() {
        initialize();
    }
    public MovieSearchWindow(JFrame previousWindow) {
        initialize();
        previousWindow.dispose();
    }

    private void initialize() {
        frame = new JFrame();
//        panel.setLayout(new GridLayout(2, 1));

        frame.setTitle("Cedeczko");
        frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        frame.setSize(WindowConstants.width, WindowConstants.height);
        frame.setLocationRelativeTo(null);
        frame.setResizable(false);

        JPanel centerPanel = new JPanel();
        centerPanel.setLayout(new FlowLayout(FlowLayout.CENTER, 10, 5));

        ImageIcon icon = new ImageIcon("src/main/resources/Cedeczko_logo.png");
        loader = new JLabel(icon);
        loader.setPreferredSize(new Dimension(WindowConstants.width, 600));

        basketButton = new JButton("Koszyk");
        basketButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                new BasketWindow(getFrame());
            }
        });

        movieSearchBars = new MovieSearchBars();
        movieList = new MovieList(frame, loader, basketButton, movieSearchBars);
        movieSearchBars.addStateChangeListener(movieList);

        centerPanel.add(movieSearchBars.getPanel());
        centerPanel.add(basketButton);
        centerPanel.add(loader);
        centerPanel.add(movieList.getPanel());

        frame.add(BorderLayout.CENTER, centerPanel);
        frame.setVisible(true);
    }


    public JFrame getFrame() {
        return frame;
    }
}
