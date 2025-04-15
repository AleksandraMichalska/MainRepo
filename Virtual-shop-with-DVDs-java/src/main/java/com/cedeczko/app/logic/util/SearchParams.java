package com.cedeczko.app.logic.util;

import java.util.Arrays;
import java.util.stream.IntStream;

public class SearchParams {

    final private String[] searchParams;

    public SearchParams(int size) {
        searchParams = new String[size];
        Arrays.fill(searchParams, "");
    }

    public void set(int index, String val) {
        searchParams[index] = val;
    }

    public String get(int index) {
        return searchParams[index];
    }

    public boolean listIncludesParams(String[] list) {
//        if (list.length != searchParams.length) throw new IllegalArgumentException("Searched list must have the same number of elements as the number of parameters.");

        return IntStream.range(0, searchParams.length).allMatch(i -> list[i].contains(searchParams[i]));
    }

    public String[] getSearchParams() {
        return searchParams;
    }
}
