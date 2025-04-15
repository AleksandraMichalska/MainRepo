package com.cedeczko.app.logic.util;

import org.junit.Test;

import static org.junit.Assert.*;

public class TestSearchParams {

    @Test
    public void testConstructorAndGetSearchParams() {
        SearchParams searchParams = new SearchParams(3);

        assertArrayEquals(new String[]{"", "", ""}, searchParams.getSearchParams());
    }

    @Test
    public void testSetAndGet() {
        SearchParams searchParams = new SearchParams(4);

        searchParams.set(0, "param1");
        searchParams.set(1, "param2");
        searchParams.set(2, "param3");
        searchParams.set(3, "param4");

        assertEquals("param1", searchParams.get(0));
        assertEquals("param2", searchParams.get(1));
        assertEquals("param3", searchParams.get(2));
        assertEquals("param4", searchParams.get(3));
    }

    @Test
    public void testListIncludesParams() {
        SearchParams searchParams = new SearchParams(3);
        searchParams.set(0, "param1");
        searchParams.set(1, "param2");
        searchParams.set(2, "param3");

        assertTrue(searchParams.listIncludesParams(new String[]{"searchparam1", "searchparam2", "searchparam3"}));
        assertFalse(searchParams.listIncludesParams(new String[]{"searchparam1", "searchparam3", "searchparam2"}));
    }
}
