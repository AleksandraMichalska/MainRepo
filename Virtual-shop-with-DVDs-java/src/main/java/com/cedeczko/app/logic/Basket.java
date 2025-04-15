package com.cedeczko.app.logic;

import java.util.*;

public class Basket {
    private static Basket instance;
    private List<String[]> products;
    int productsNumber;
    float value;

    private Basket() {
      this.products = new ArrayList<String[]>();
      this.productsNumber = 0;
      this.value = 0;
    }

    public static synchronized Basket getInstance() {
      if (instance == null) {
          instance = new Basket();
      }
      return instance;
    }

    public void setProducts(List<String[]> newProducts) {
        products.clear();
        products.addAll(newProducts);
        productsNumber = newProducts.size();
        value = 0;
        for (String[] product : products) {
          value += Float.parseFloat(product[4]);
        }
    }

    public List<String[]> getProducts(){
        return this.products;
    }

    public int getProductsNumber(){
        return this.productsNumber;
    }

    public float getValue(){
        return this.value;
    }

    public void addProduct(String[] product) {
        products.add(product);
        productsNumber += 1;
        value += Float.parseFloat(product[4]);
    }

    public void removeProduct(String title, String date, float price) {
        String[] productToRemove = null;
        for (String[] product : products) {
          if (product[0].equals(title) && product[3].equals(date) && Float.parseFloat(product[4]) == price) {
            productToRemove = product;
            break;
          }
        }

        if (productToRemove != null) {
          products.remove(productToRemove);
          productsNumber -= 1;
          value -= Float.parseFloat(productToRemove[4]);
        }
    }

    public void removeAllProducts() {
        products.clear();
        productsNumber = 0;
        value = 0;
    }
}