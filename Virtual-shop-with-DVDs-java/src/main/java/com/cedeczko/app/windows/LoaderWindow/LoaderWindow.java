package com.cedeczko.app.windows.LoaderWindow;

import com.cedeczko.app.logic.constants.WindowConstants;

import javax.swing.*;
import java.awt.*;

public class LoaderWindow extends JFrame {
    public LoaderWindow() {
        initialize();
    }

    private void initialize() {
        setTitle("Loading...");
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setSize(com.cedeczko.app.logic.constants.WindowConstants.width, WindowConstants.height);
        setLocationRelativeTo(null);
        setResizable(false);
        setVisible(true);

//        ImageIcon loader = new ImageIcon("src/main/resources/loader.gif");
        Button loader = new Button("testestste");
        JPanel panel = new JPanel();
        panel.setLayout(new FlowLayout(FlowLayout.CENTER, 10, 5));
        panel.add(loader);

        add(panel);
    }
}
