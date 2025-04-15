package com.cedeczko.app;

import ch.randelshofer.quaqua.QuaquaLookAndFeel;
import com.cedeczko.app.windows.BasketWindow;
import com.cedeczko.app.windows.LoaderWindow.LoaderWindow;
import com.cedeczko.app.windows.MainWindow;
import com.cedeczko.app.windows.MovieSearchWindow.MovieSearchWindow;
import mdlaf.MaterialLookAndFeel;

import javax.swing.*;
import javax.swing.plaf.metal.*;
import java.awt.*;

public class App {
    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            LoaderWindow loaderWindow = new LoaderWindow();
            try {
                UIManager.setLookAndFeel(new QuaquaLookAndFeel());
            } catch (UnsupportedLookAndFeelException e) {
                throw new RuntimeException(e);
            }
            MovieSearchWindow movieSearchWindow = new MovieSearchWindow(loaderWindow);
//            MainWindow mainWindow = new MainWindow(basketWindow);
        });
    }
}
