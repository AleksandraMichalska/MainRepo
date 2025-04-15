package com.cedeczko.app.windows.MovieSearchWindow.components;

import com.cedeczko.app.logic.util.MovieListUtils;
import com.cedeczko.app.logic.util.Pair;
import com.cedeczko.app.logic.util.SearchParams;
import com.cedeczko.app.windows.ProductWindow;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.ArrayList;

public class MovieList implements StateChangeListener {

    JLabel loader;
    JPanel panel;
    DefaultTableModel tableModel;
    JTable movieTable;
    JScrollPane scrollPane;

    SearchParams searchParams;

    ArrayList<String[]> fullTableData = new ArrayList<>();
    ArrayList<String[]> displayedTableData = new ArrayList<>();
    JFrame parentFrame;

    public MovieList(JFrame frame, JLabel loader, JButton button, MovieSearchBars bars) {
        panel = new JPanel();
        this.loader = loader;
        Thread.startVirtualThread(() -> {
            getPanel().setVisible(false);
            button.setVisible(false);
            bars.getPanel().setVisible(false);

            fullTableData = MovieListUtils.getData();
            displayedTableData = fullTableData;
            addDataToTable(displayedTableData);

            getPanel().setVisible(true);
            loader.setVisible(false);
            button.setVisible(true);
            bars.getPanel().setVisible(true);
        });
        this.searchParams = new SearchParams(4);
        parentFrame = frame;

        movieTable = createMoviePanel();
        scrollPane = createScrollPane();
        // scrollPane.add(movieTable);

        panel.add(BorderLayout.CENTER, scrollPane);
    }

    private JTable createMoviePanel() {

        tableModel = createTableModel();
        addDataToTable(fullTableData);

        movieTable = new JTable(tableModel);

        movieTable.getColumnModel().getColumn(0).setPreferredWidth(4 * 800 / 10);
        movieTable.getColumnModel().getColumn(1).setPreferredWidth(4 * 800 / 10);
        movieTable.getColumnModel().getColumn(2).setPreferredWidth(4 * 800 / 10);
        movieTable.getColumnModel().getColumn(3).setPreferredWidth(2 * 800 / 20);
        movieTable.getSelectionModel().addListSelectionListener(e -> {
            if (!e.getValueIsAdjusting()) {
                int selectedRow = movieTable.getSelectedRow();
                if (selectedRow != -1) // jest zaznaczony wiersz
                {
                    new ProductWindow(parentFrame, displayedTableData.get(selectedRow));
                }
            }
        });
        return movieTable;
    }

    private void limitTableData() {
        displayedTableData = MovieListUtils.limitTableData(searchParams, fullTableData);
        clearTable();
        addDataToTable(displayedTableData);
    }

    private void addDataToTable(ArrayList<String[]> tableData) {
        for (var row : tableData)
            tableModel.addRow(row);
    }

    private void clearTable() {
        while (tableModel.getRowCount() > 0)
            tableModel.removeRow(0);
    }

    private DefaultTableModel createTableModel() {
        String[] fields = MovieListUtils.getFields();
        tableModel = new DefaultTableModel() {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false;
            }
        };

        for (var field : fields)
            tableModel.addColumn(field);

        return tableModel;

    }

    private JScrollPane createScrollPane() {
        return new JScrollPane(movieTable);
    }

    public JPanel getPanel() {
        return panel;
    }

    @Override
    public void onStateChange(Pair<Integer, String> newState) {
        int index = newState.getKey();
        String value = newState.getValue();
        searchParams.set(index, value);

        limitTableData();
    }
}
