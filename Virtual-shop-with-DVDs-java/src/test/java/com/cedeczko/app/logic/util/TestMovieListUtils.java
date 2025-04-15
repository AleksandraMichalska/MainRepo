package com.cedeczko.app.logic.util;

import org.junit.Test;

import java.util.ArrayList;
import java.util.stream.IntStream;

import static org.junit.Assert.*;

class HelperClass {
    static public boolean areStringArraysSame(String[] first, String[] second) {
        if(first.length != second.length) return false;
        return IntStream.range(0, first.length).allMatch(i -> first[i].equals(second[i]));
    }
    static public boolean areArrayListsSame(ArrayList<String[]> first, ArrayList<String[]> second) {
        if(first.size() != second.size()) return false;
        return IntStream.range(0, first.size()).allMatch(i -> HelperClass.areStringArraysSame(first.get(i), second.get(i)));
    }
}
public class TestMovieListUtils {
    @Test
    public void testStandardInput() {
        SearchParams searchParams = new SearchParams(3);
        searchParams.set(0, "a");
        searchParams.set(1, "b");
        searchParams.set(2, "c");
        ArrayList<String[]> values = new ArrayList<>();
        values.add(new String[]{"aaab", "cccc", "cddc"});
        values.add(new String[]{"aaaab", "bbbbbc", "ccccd"});

        ArrayList<String[]> answer = new ArrayList<>();
        answer.add(new String[]{"aaaab", "bbbbbc", "ccccd"});

        ArrayList<String[]> filteredValues = MovieListUtils.limitTableData(searchParams, values);

        assertTrue(HelperClass.areArrayListsSame(filteredValues, answer));
    }
    @Test
    public void testEmptyFilter() {
        SearchParams searchParams = new SearchParams(3);
        ArrayList<String[]> values = new ArrayList<>();
        values.add(new String[]{"aaab", "cccc", "cddc"});
        values.add(new String[]{"aaaab", "bbbbbc", "ccccd"});

        ArrayList<String[]> filteredValues = MovieListUtils.limitTableData(searchParams, values);

        assertTrue(HelperClass.areArrayListsSame(values, filteredValues));
    }

    @Test
    public void testGetFields() {
        String[] expectedAns = new String[]{"Tytuł", "Reżyser", "Gatunek", "Rok"};

        assertArrayEquals(expectedAns, MovieListUtils.getFields());
    }

    @Test
    public void testGetGenresWithDb() {
        ArrayList<String> genres = MovieListUtils.getGenres();

        assertEquals("Action", genres.get(1));
        assertEquals("Biography", genres.get(2));

        assertEquals("Horror", genres.get(15));
        assertEquals("Adventure", genres.get(16));
    }

    @Test
    public void testGetDataWithDb() {
        ArrayList<String[]> movies = MovieListUtils.getData();

        assertEquals("The Shawshank Redemption", movies.get(0)[0]);
        assertEquals("Frank Darabont", movies.get(0)[1]);
    }
}
