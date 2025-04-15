package com.cedeczko.app.windows;
import com.cedeczko.app.data.MovieCache;
import com.cedeczko.app.logic.Film;
import com.cedeczko.app.windows.MovieSearchWindow.MovieSearchWindow;
import com.cedeczko.app.logic.Basket;

import java.awt.*;
import javax.imageio.ImageIO;
import javax.swing.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Arrays;

public class ProductWindow extends JFrame {
    private Basket basket = Basket.getInstance();

    public ProductWindow() {
        String[] emptyList = { "", "", "", "", "", "" };
        initialize(emptyList);
    }

    public ProductWindow(JFrame previous_window, String[] filmInformation) {
        initialize(filmInformation);
        previous_window.dispose();
    }

    public void initialize(String[] filmInformation) {
        int wide = 900;
        int high = 800;
        int bottom_high = 75;
        int upper_high = 50;
        setTitle("Informacje o produkcie");
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
        // przycisk koszyk
        JButton basket_button = new JButton("Twój koszyk");
        basket_button.addActionListener(e -> new BasketWindow(this));
        up_panel.add(basket_button);

        add(up_panel, BorderLayout.NORTH);

        // lewa połowa ekranu
        JPanel left_panel = new JPanel(new GridBagLayout());
        left_panel.setLayout(new FlowLayout(FlowLayout.LEFT, 20, 5));
        left_panel.setPreferredSize(new Dimension(wide / 2, high - bottom_high - upper_high));
        // pole tekstowe z informacją o filmie
        String information_text = "Tytuł: " + filmInformation[0] + "\n Autor: " + filmInformation[1]
                + "\n Rok wydania: " + filmInformation[3] + "\n Gatunki: " + filmInformation[2] + "\n Opis: "
                + filmInformation[5] + "\n";
        JTextArea filmInformationField = new JTextArea(information_text, 35, 25);
        filmInformationField.setLineWrap(true);
        filmInformationField.setWrapStyleWord(true);
        filmInformationField.setEditable(false);
        JScrollPane scroll_text = new JScrollPane(filmInformationField);
        left_panel.add(scroll_text);

        add(left_panel, BorderLayout.WEST);

        // prawa połowa ekranu
        JPanel right_panel = new JPanel();
        right_panel.setLayout(new FlowLayout(FlowLayout.RIGHT, 10, 5));
        right_panel.setPreferredSize(new Dimension(wide / 2, high - bottom_high - upper_high));
        // plakat filmu

        Film film = MovieCache.getFilm(filmInformation[0], filmInformation[1]);
        BufferedImage picture = null;
        try {
            byte[] imageBytes = film.getPoster().getBytes(1L, (int) film.getPoster().length());
            ByteArrayInputStream bis = new ByteArrayInputStream(imageBytes);
            picture = ImageIO.read(bis);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        JLabel poster = new JLabel(new ImageIcon(picture.getScaledInstance(wide/2, high - bottom_high - upper_high, 1)));
        right_panel.add(poster);
        add(right_panel, BorderLayout.EAST);

        // dół ekranu
        JPanel down_panel = new JPanel();
        down_panel.setLayout(new BorderLayout());
        down_panel.setPreferredSize(new Dimension(wide, bottom_high));
        JPanel upperdown_panel = new JPanel();
        upperdown_panel.setLayout(new FlowLayout(FlowLayout.CENTER, 10, 5));
        upperdown_panel.setPreferredSize(new Dimension(wide, bottom_high/2));
        JPanel bottomdown_panel = new JPanel();
        bottomdown_panel.setLayout(new FlowLayout(FlowLayout.CENTER, 10, 5));
        bottomdown_panel.setPreferredSize(new Dimension(wide, bottom_high/2));
        // Cena
        JTextField price_field = new JTextField("Cena: " + filmInformation[4] + " zł", 10);
        price_field.setEditable(false);
        upperdown_panel.add(price_field);
        // przycisk dodaj do koszyka
        JButton add_basket_button = new JButton("Dodaj do koszyka");
        JLabel warning = new JLabel("");
        add_basket_button.addActionListener(e -> {
          boolean available = true;
          for (String[] product : basket.getProducts()) {
              if (Arrays.equals(product, filmInformation)) {
                  available = false;
                  break;
              }
          }
          if (available) {
            basket.addProduct(filmInformation);
            new MovieSearchWindow(this);
          } else {
            warning.setText("Ten produkt znajduje się już w Twoim koszyku!");
          }
        });
        upperdown_panel.add(add_basket_button);
        bottomdown_panel.add(warning);
        down_panel.add(upperdown_panel, BorderLayout.NORTH);
        down_panel.add(bottomdown_panel, BorderLayout.SOUTH);
        add(down_panel, BorderLayout.SOUTH);
        setVisible(true);
    }
}
