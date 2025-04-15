package com.cedeczko.app.windows;

import javax.swing.*;

public class MainWindowRunner {
    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            MainWindow mainWindow = new MainWindow();
        });
    }
}
