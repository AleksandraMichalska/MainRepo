package com.cedeczko.app.windows;

import com.cedeczko.app.logic.Basket;
import com.cedeczko.app.windows.MovieSearchWindow.MovieSearchWindow;

import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.GridBagLayout;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.Dimension;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.util.*;

public class BasketWindow extends JFrame {
    private Basket basket = Basket.getInstance();

    private DefaultTableModel model;
    private JTable products_table;

    public BasketWindow() {
        initialize();
    }

    public BasketWindow(JFrame previous_window) {
        initialize();
        previous_window.dispose();
    }

    public void initialize() {
        int wide = 900;
        int high = 800;
        int upper_high = 50;
        setTitle("Koszyk");
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setSize(wide, high);
        setLocationRelativeTo(null);
        setResizable(false);
        setVisible(true);

        // góra ekranu
        JPanel up_panel = new JPanel();
        up_panel.setLayout(new FlowLayout(FlowLayout.CENTER, 10, 5));
        up_panel.setPreferredSize(new Dimension(wide, upper_high));
        // przycisk powrót
        JButton return_button = new JButton("<--- Powrót");
        return_button.addActionListener(e -> new MovieSearchWindow(this));
        up_panel.add(return_button);

        add(up_panel, BorderLayout.NORTH);

        // prawa część ekranu
        JPanel right_panel = new JPanel();
        right_panel.add(Box.createRigidArea(new Dimension(0, (high - upper_high) / 3)));
        right_panel.setLayout(new BoxLayout(right_panel, BoxLayout.PAGE_AXIS));
        right_panel.setPreferredSize(new Dimension(3 * wide / 10, (high - upper_high) / 2));
        JLabel r1label = new JLabel("PODSUMOWANIE");
        JLabel r2label = new JLabel("Liczba produktów: " + basket.getProductsNumber());
        JLabel r3label = new JLabel("Łączna kwota do zapłaty: " + basket.getValue() + "zł");
        JButton pay_button = new JButton("Przejdź do kasy");
        JLabel warning = new JLabel("");
        pay_button.addActionListener(e -> {
          if (basket.getValue() != 0) {
            new PaymentWindow(this);
          } else {
            warning.setText("Twój koszyk jest pusty!");
          }
        });
        right_panel.add(r1label);
        right_panel.add(r2label);
        right_panel.add(r3label);
        right_panel.add(pay_button);
        right_panel.add(warning);
        
        add(right_panel, BorderLayout.EAST);

        // lewa część ekranu
        JPanel left_panel = new JPanel(new GridBagLayout());
        left_panel.setPreferredSize(new Dimension((6 * wide / 10), high - upper_high));
        left_panel.setLayout(new BoxLayout(left_panel, BoxLayout.PAGE_AXIS));
        JLabel llabel = new JLabel("Lista zakupów:");

        model = new DefaultTableModel() {
            @Override
            public boolean isCellEditable(int row, int column) {
              return false;
            }
        };

        model.addColumn("Nazwa produktu");
        model.addColumn("Cena (zł)");
        model.addColumn("");

        products_table = new JTable(model);
        List<String[]> products = basket.getProducts();
        for (String[] film : products) {
          products_table.getColumnModel().getColumn(0).setPreferredWidth(4 * wide / 10);
          Object[] product = {film[0] + " (" + film[3] + ")", film[4], "Usuń produkt"};
          model.addRow(product);
        }

        products_table.addMouseListener(new MouseAdapter() {
          @Override
          public void mouseClicked(MouseEvent e) {
              int column = products_table.columnAtPoint(e.getPoint());
              int row = products_table.rowAtPoint(e.getPoint());

              if (column == model.findColumn("") && row != -1) {
                  String title_date = model.getValueAt(row, 0).toString().replaceAll("[()]", " ");
                  String[] title_and_date = title_date.split("  ");
                  float price = Float.parseFloat(model.getValueAt(row, 1).toString());
                  basket.removeProduct(title_and_date[0], title_and_date[1].replaceAll("[ ]", ""), price);
                  model.removeRow(row);
                  r2label.setText("Liczba produktów: " + basket.getProductsNumber());
                  r3label.setText("Łączna kwota do zapłaty: " + basket.getValue());
              }
          }
        });

        JScrollPane scrollPane = new JScrollPane(products_table);
        scrollPane.setPreferredSize(new Dimension(6 * wide / 10, high - upper_high));
        scrollPane.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        left_panel.add(scrollPane);

        left_panel.add(llabel);

        left_panel.add(scrollPane);

        add(left_panel, BorderLayout.WEST);
        
        setVisible(true);
    }
}
