package com.cedeczko.app.windows;

import javax.swing.SwingUtilities;

public class BasketWindowRunner {
    public static void main(String[] args) {
        SwingUtilities.invokeLater(new Runnable() {
            @Override
            public void run() {
                BasketWindow basket_window = new BasketWindow();
            }
        });
    }
}