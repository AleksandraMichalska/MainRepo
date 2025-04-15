package com.cedeczko.app.windows;

import com.cedeczko.app.data.Database;
import com.cedeczko.app.data.DatabaseConnector;
import com.cedeczko.app.logic.Basket;
import com.cedeczko.app.windows.MovieSearchWindow.MovieSearchWindow;

import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import javax.swing.*;
import java.awt.Dimension;
import java.awt.Component;

public class SuccessfulWindow extends JFrame {
    private Basket basket = Basket.getInstance();
    static Database db = new DatabaseConnector();

    public SuccessfulWindow(JFrame previous_window, int customerId) {
        initialize(customerId);
        previous_window.dispose();
        for (String[] product : basket.getProducts()) {
            db.deleteFilm(product);
        }
        basket.removeAllProducts();
    }

    public void initialize(int customerId) {
        int wide = 900;
        int high = 800;
        int upper_high = 50;
        setTitle("Transakcja udana");
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setSize(wide, high);
        setLocationRelativeTo(null);
        setResizable(false);
        setVisible(true);

        JPanel main_panel = new JPanel();
        main_panel.setLayout(new BorderLayout());
        main_panel.setPreferredSize(new Dimension(wide, high / 4));

        // góra ekranu
        JPanel up_panel = new JPanel();
        up_panel.setLayout(new FlowLayout(FlowLayout.CENTER, 20, 20));
        up_panel.setPreferredSize(new Dimension(wide, upper_high));
        // przycisk powrót
        JButton return_button = new JButton("<--- Powrót");
        return_button.addActionListener(e -> new MovieSearchWindow(this));
        up_panel.add(return_button);

        main_panel.add(up_panel, BorderLayout.NORTH);

        // środkowa część ekranu
        JPanel central_panel = new JPanel();
        central_panel.setLayout(new BoxLayout(central_panel, BoxLayout.PAGE_AXIS));
        central_panel.add(Box.createRigidArea(new Dimension(0, high / 4 - upper_high)));
        JLabel label1 = new JLabel("PŁATNOŚĆ PRZEBIEGŁA POMYŚLNIE!");
        label1.setAlignmentX(Component.CENTER_ALIGNMENT);
        central_panel.add(label1);
        JLabel label2 = new JLabel("Na maila przesłałyśmy potwierdzenie zamówienia.");
        label2.setAlignmentX(Component.CENTER_ALIGNMENT);
        central_panel.add(label2);
        JLabel label3 = new JLabel("Dziękujemy za skorzystanie z naszych usług.");
        label3.setAlignmentX(Component.CENTER_ALIGNMENT);
        central_panel.add(label3);
        JLabel label4 = new JLabel("Zapraszamy ponownie!");
        label4.setAlignmentX(Component.CENTER_ALIGNMENT);
        central_panel.add(label4);
        main_panel.add(central_panel, BorderLayout.SOUTH);
        
        add(main_panel, BorderLayout.NORTH);

        JPanel bottom_panel = new JPanel();
        bottom_panel.setPreferredSize(new Dimension(wide / 2, 3 * high / 4));
        bottom_panel.setLayout(new FlowLayout(FlowLayout.CENTER, 20, 20));
        LocalDate currentDate = LocalDate.now();
        LocalTime currentTime = LocalTime.now();
        String formattedDate = currentDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        String formattedTime = currentTime.format(DateTimeFormatter.ofPattern("HH:mm:ss"));
        String receipt = getReceipt(formattedDate, formattedTime);
        JTextArea receiptTextArea = new JTextArea(receipt);
        receiptTextArea.setEditable(false);
        JScrollPane scrollPane = new JScrollPane(receiptTextArea);
        scrollPane.setPreferredSize(new Dimension(3 * wide / 7, 2 * high / 3));
        scrollPane.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        String dateTime = "";
        dateTime += formattedDate + " " + formattedTime;
        db.addReceipt(customerId, dateTime, basket.getValue(), basket.getProducts());
        bottom_panel.add(scrollPane);
        add(bottom_panel, BorderLayout.CENTER);
        
        setVisible(true);
    }

    private String getReceipt(String date, String time) {
      String receipt = "";
      receipt += " ".repeat(44);
      receipt += "Sklep Cedeczko\n";
      receipt += " ".repeat(41);
      receipt += "04-935  Warszawa\n";
      receipt += " ".repeat(47);
      receipt += "Filmowa  1\n";
      receipt += " ".repeat(40);
      receipt += "NIP: 012-345-67-89\n\n";
      receipt += date;
      receipt += " ".repeat(75);
      receipt += time;
      receipt += "\n";
      receipt += " ".repeat(36);
      receipt += "PARAGON FISKALNY\n";
      List<String[]> products = basket.getProducts();
      for (String[] film : products) {
        receipt += film[0];
        receipt += " (";
        receipt += film[3];
        receipt += ")    -    ";
        receipt += String.format("%.2f", Float.parseFloat(film[4]));
        receipt += " zł\n";
      }
      receipt += "--------------------------------------------------------------------------------------\n";
      receipt += "Kwota opodatkowania: ";
      receipt += String.format("%.2f", basket.getValue());
      receipt += " zł\nKwota PTU A 23%: ";
      receipt += String.format("%.2f", 0.23 * basket.getValue());
      receipt += " zł\nRAZEM PTU: ";
      receipt += String.format("%.2f", 0.23 * basket.getValue());
      receipt += " zł\n--------------------------------------------------------------------------------------\n";
      receipt += "SUMA PLN: ";
      receipt += String.format("%.2f", basket.getValue());
      receipt += " zł\n";

      return receipt;
    }
  }