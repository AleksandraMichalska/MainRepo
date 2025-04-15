package com.cedeczko.app.logic;

import org.junit.Test;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static org.junit.Assert.assertEquals;

public class TestBasket {

    @Test
    public void testGetInstance() {
        Basket instance1 = Basket.getInstance();
        Basket instance2 = Basket.getInstance();

        assertEquals(instance1.getProducts(), instance2.getProducts());
    }

    @Test
    public void testSetProducts() {
        Basket basket = Basket.getInstance();

        List<String[]> newProducts = Arrays.asList(
                new String[]{"Inception", "Christopher Nolan", "Action, Adventure, Sci-Fi", "2010", "57.0", "A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O."},
                new String[]{"The Shawshank Redemption", "Frank Darabont", "Drama", "1994", "50.0", "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency."}
        );

        basket.setProducts(newProducts);

        assertEquals(newProducts, basket.getProducts());
        assertEquals(newProducts.size(), basket.getProductsNumber());
        assertEquals(107.0, basket.getValue(), 0.001);

        basket.removeAllProducts();
    }

    @Test
    public void testAddProduct() {
        Basket basket = Basket.getInstance();

        String[] product = {"The Godfather", "Francis Ford Coppola", "Crime, Drama", "1972", "55.0", "The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son."};

        basket.addProduct(product);

        assertEquals(1, basket.getProductsNumber());
        assertEquals(55.0, basket.getValue(), 0.001);

        basket.removeAllProducts();
    }

    @Test
    public void testRemoveProduct() {
        Basket basket = Basket.getInstance();

        List<String[]> products = Arrays.asList(
                new String[]{"Inception", "Christopher Nolan", "Action, Adventure, Sci-Fi", "2010", "57.0", "A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O."},
                new String[]{"The Shawshank Redemption", "Frank Darabont", "Drama", "1994", "50.0", "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency."}
        );

        basket.setProducts(products);

        String[] productToRemove = {"Inception", "Christopher Nolan", "Action, Adventure, Sci-Fi", "2010", "57.0", "A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O."};

        basket.removeProduct(productToRemove[0], productToRemove[3], Float.parseFloat(productToRemove[4]));

        assertEquals(1, basket.getProductsNumber());
        assertEquals(50.0, basket.getValue(), 0.001);

        basket.removeAllProducts();
    }

    @Test
    public void testRemoveAllProducts() {
        Basket basket = Basket.getInstance();

        List<String[]> products = Arrays.asList(
                new String[]{"Inception", "Christopher Nolan", "Action, Adventure, Sci-Fi", "2010", "57.0", "A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O."},
                new String[]{"The Shawshank Redemption", "Frank Darabont", "Drama", "1994", "50.0", "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency."}
        );

        basket.setProducts(products);

        basket.removeAllProducts();

        assertEquals(0, basket.getProductsNumber());
        assertEquals(0.0, basket.getValue(), 0.001);
    }
}