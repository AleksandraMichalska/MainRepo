package com.cedeczko.app.windows;

import javax.swing.SwingUtilities;

public class ProductWindowRunner {
    public static void main(String[] args) {
        SwingUtilities.invokeLater(new Runnable() {
            @Override
            public void run() {
                ProductWindow product_window = new ProductWindow();
            }
        });
    }
}