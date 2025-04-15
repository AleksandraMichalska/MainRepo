package com.cedeczko.app.windows;

import javax.swing.SwingUtilities;

public class PaymentWindowRunner {
    public static void main(String[] args) {
        SwingUtilities.invokeLater(new Runnable() {
            @Override
            public void run() {
                PaymentWindow payment_window = new PaymentWindow();
            }
        });
    }
}