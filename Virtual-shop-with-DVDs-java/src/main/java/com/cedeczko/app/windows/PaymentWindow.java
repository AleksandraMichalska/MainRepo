package com.cedeczko.app.windows;
import com.cedeczko.app.data.Database;
import com.cedeczko.app.data.DatabaseConnector;
import com.cedeczko.app.logic.Basket;

import java.awt.BorderLayout;
import java.awt.GridLayout;
import java.awt.FlowLayout;
import javax.swing.*;

import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.Dimension;

public class PaymentWindow extends JFrame {
    private Basket basket = Basket.getInstance();
    static Database db = new DatabaseConnector();

    public PaymentWindow() {
        initialize();
    }

    public PaymentWindow(JFrame previous_window) {
        initialize();
        previous_window.dispose();
    }

    public void initialize() {
        int wide = 900;
        int high = 800;
        int upper_high = 50;
        setTitle("Płatność");
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setSize(wide, high);
        setLocationRelativeTo(null);
        setResizable(false);
        setVisible(true);

        // góra ekranu
        JPanel up_panel = new JPanel();
        up_panel.setLayout(new FlowLayout(FlowLayout.CENTER, 20, 20));
        up_panel.setPreferredSize(new Dimension(wide, upper_high));
        // przycisk powrót
        JButton return_button = new JButton("<--- Powrót");
        return_button.addActionListener(e -> new BasketWindow(this));
        up_panel.add(return_button);
        add(up_panel, BorderLayout.NORTH);

        //dolna część ekranu
        JPanel bottom_panel = new JPanel();
        bottom_panel.setLayout(new FlowLayout(FlowLayout.CENTER, 20, 20));
        bottom_panel.setPreferredSize(new Dimension(wide, upper_high));
        JCheckBox rodo = new JCheckBox("Zezwalam na wykorzystanie moich danych w celu zrealizowania zamówienia");
        bottom_panel.add(rodo);

        add(bottom_panel, BorderLayout.SOUTH);

        // lewa część ekranu
        JPanel left_panel = new JPanel(new GridLayout(0, 2, 0, 5));
        left_panel.setPreferredSize(new Dimension(6 * wide / 10, (high - 2 * upper_high) / 2));
        left_panel.add(Box.createRigidArea(new Dimension(2 * wide / 10, 0)));
        left_panel.add(new JLabel("DANE KLIENTA"));
        left_panel.add(new JLabel("Imię:"));
        JTextField name_field = new JTextField();
        left_panel.add(name_field);
        left_panel.add(new JLabel("Nazwisko:"));
        JTextField surname_field = new JTextField();
        left_panel.add(surname_field);
        left_panel.add(new JLabel("E-mail:"));
        JTextField email_field = new JTextField();
        left_panel.add(email_field);
        left_panel.add(new JLabel("Numer telefonu:"));
        JTextField phone_no_field = new JTextField();
        left_panel.add(phone_no_field);
        left_panel.add(Box.createRigidArea(new Dimension(2 * wide / 10, 0)));
        left_panel.add(new JLabel("ADRES"));
        left_panel.add(new JLabel("Ulica:"));
        JTextField street_field = new JTextField();
        left_panel.add(street_field);
        left_panel.add(new JLabel("Numer domu:"));
        JTextField building_no_field = new JTextField();
        left_panel.add(building_no_field);
        left_panel.add(new JLabel("Numer mieszkania:"));
        JTextField local_no_field = new JTextField();
        left_panel.add(local_no_field);
        left_panel.add(new JLabel("Miasto:"));
        JTextField town_field = new JTextField();
        left_panel.add(town_field);
        left_panel.add(new JLabel("Kod pocztowy:"));
        JTextField post_code_field = new JTextField();
        left_panel.add(post_code_field);
        left_panel.add(new JLabel("Kraj:"));
        left_panel.add(new JLabel("Polska"));
        left_panel.add(Box.createRigidArea(new Dimension(2 * wide / 10, 0)));
        left_panel.add(new JLabel("DANE DO PŁATNOŚCI"));
        left_panel.add(new JLabel("Numer karty:"));
        JTextField card_no_field = new JTextField();
        left_panel.add(card_no_field);
        left_panel.add(new JLabel("Data ważności (MM/RR):"));
        JTextField expiration_date_field = new JTextField();
        left_panel.add(expiration_date_field);
        left_panel.add(new JLabel("Kod bezpieczeństwa (CVV/CVC):"));
        JTextField verification_code_field = new JTextField();
        left_panel.add(verification_code_field);
        
        add(left_panel, BorderLayout.WEST);

        // prawa część ekranu
        JPanel right_panel = new JPanel();
        right_panel.add(Box.createRigidArea(new Dimension(0, (high - 2 * upper_high) / 3)));
        right_panel.setLayout(new BoxLayout(right_panel, BoxLayout.PAGE_AXIS));
        right_panel.setPreferredSize(new Dimension(3 * wide / 10, (high - 2 * upper_high) / 2));
        JLabel r1label = new JLabel("PODSUMOWANIE");
        JLabel r2label = new JLabel("Liczba produktów: " + basket.getProductsNumber());
        JLabel r3label = new JLabel("Łączna kwota do zapłaty: " + basket.getValue() + "zł");
        JLabel warning = new JLabel("");
        JButton pay_button = new JButton("Zapłać");

        pay_button.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String name = name_field.getText();
                String surname = surname_field.getText();
                String email = email_field.getText();
                String phone_no = phone_no_field.getText();
                String street = street_field.getText();
                String building = building_no_field.getText();
                String flat = local_no_field.getText();
                String city = town_field.getText();
                String post_code = post_code_field.getText();
                String card_no = card_no_field.getText();
                String expiration_date = expiration_date_field.getText();
                String verification_code = verification_code_field.getText();
                if (!check_string(name)) {
                    warning.setText("Wpisz poprawne imię.");
                } else if (!check_string(surname)) {
                    warning.setText("Wpisz poprawne nazwisko.");
                } else if (!check_email(email)) {
                    warning.setText("Email musi zawierać '@'.");
                } else if (!check_phone(phone_no)) {
                    warning.setText("Telefon musi mieć 9 cyfr.");
                } else if (street.isEmpty()) {
                    warning.setText("Uzupełnij ulicę.");
                } else if (building.isEmpty()) {
                    warning.setText("Uzupełnij numer budynku.");
                } else if (!check_flat(flat)) {
                    warning.setText("Mieszkanie musi być liczbą dodatnią.");
                } else if (!check_string(city)) {
                    warning.setText("Wpisz poprawne miasto");
                } else if (!check_post_code(post_code)) {
                    warning.setText("Kod pocztowy musi mieć format XX-XXX.");
                } else if (!check_card_no(card_no)) {
                    warning.setText("Numer karty musi mieć 16 cyfr.");
                } else if (!check_expiration_date(expiration_date)) {
                    warning.setText("Data ważności karty musi być prawidłowa.");
                } else if (!check_verification_code(verification_code)) {
                    warning.setText("Kod CVV/CVC musi mieć 3 cyfry");
                } else if (!rodo.isSelected()){
                    warning.setText("Musisz zezwolić na wykozystanie danych.");
                } else {
                    int customerId = db.addClientsData(name, surname, street, building, Integer.parseInt(flat), post_code, city, email);
                    new SuccessfulWindow(PaymentWindow.this, customerId);
                }
            }
        });
        right_panel.add(r1label);
        right_panel.add(r2label);
        right_panel.add(r3label);
        right_panel.add(pay_button);
        right_panel.add(warning);
        
        add(right_panel, BorderLayout.EAST);
        
        setVisible(true);
    }

    private boolean check_string(String given_string) {
        boolean ok = true;
        if (given_string.isEmpty()){
           ok = false;
        }
        for (int i = 0; i < given_string.length(); i++) {
            if ((!Character.isLetter(given_string.charAt(i))) && (!Character.isSpaceChar(given_string.charAt(i)))) {
                ok = false;
            }
        }
        return ok;
    }

    private boolean check_email(String given_email) {
        boolean has_dot_at = false;
        if (given_email.length() >= 5){
            for (int i = 1; i < given_email.length() - 3; i++) {
                if (given_email.charAt(i) == '@') {
                    for (int j = i + 2; j < given_email.length() - 1; j++) {
                        if (given_email.charAt(j) == '.') {
                            has_dot_at = true;
                        }
                    }
                }
            }
        }
        return has_dot_at;
    }

    private boolean check_phone(String given_phone){
        boolean isok = true;
        if (given_phone.length() != 9) {
            isok = false;
        }
        for (int i = 0; i < given_phone.length(); i++) {
            if (!Character.isDigit(given_phone.charAt(i))) {
                isok = false;
            }
        }
        return isok;
    }

    private boolean check_flat(String given_flat){
        boolean isok = true;
        if (given_flat.isEmpty()) {
            isok = false;
        }
        for (int i = 0; i < given_flat.length(); i++) {
            if (!Character.isDigit(given_flat.charAt(i))) {
                isok = false;
            }
        }
        return isok;
    }

    private boolean check_post_code(String given_post_code){
        boolean ok = true;
        if (given_post_code.length() == 6) {
            if (given_post_code.charAt(2) != '-') {
                ok = false;
            } else {
                for (int i = 0; i < 6; i++) {
                    if ((i != 2) && (!Character.isDigit(given_post_code.charAt(i)))) {
                        ok = false;
                    }
                }
            }
        } else {
            ok = false;
        }
        return ok;
    }

    private boolean check_card_no(String given_card_no) {
        boolean isok = true;
        if (given_card_no.length() != 16) {
            isok = false;
        }
        for (int i = 0; i < given_card_no.length(); i++) {
            if (!Character.isDigit(given_card_no.charAt(i))) {
                isok = false;
            }
        }
        return isok;
    }

    private boolean check_expiration_date(String given_expiration_date) {
        boolean ok = true;
        if (given_expiration_date.length() == 5){
            if (given_expiration_date.charAt(2) != '/'){
                ok = false;
            } else {
                for (int i = 0; i < 5; i++) {
                    if ((i != 2) && (!Character.isDigit(given_expiration_date.charAt(i)))) {
                        ok = false;
                    }
                }
                String first_two = given_expiration_date.substring(0, 2);
                String last_two = given_expiration_date.substring(3, 5);
                if ((Integer.parseInt(first_two) > 12) || (Integer.parseInt(last_two) <= 23)) {
                    ok = false;
                }
            }
        } else {
            ok = false;
        }
        return ok;
    }

    private boolean check_verification_code(String given_verification_code) {
        boolean isok = true;
        if (given_verification_code.length() != 3) {
            isok = false;
        }
        for (int i = 0; i < given_verification_code.length(); i++) {
            if (!Character.isDigit(given_verification_code.charAt(i))) {
                isok = false;
            }
        }
        return isok;
    }
}
