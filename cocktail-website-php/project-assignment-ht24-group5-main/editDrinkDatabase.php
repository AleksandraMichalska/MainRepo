<?php

    $db = new mysqli("localhost", "root", null, "project_db");
    if ($db->connect_error) {
        die("Connection failed: " . $db->connect_error);
    }
    function insert_record($sql) {
        if (mysqli_query($GLOBALS['db'], $sql)) {  
            echo "Record inserted successfully.";  
        } else {  
            echo "Could not insert record: " . mysqli_error($GLOBALS['db']) . "<br>";  
        } 
    }
    function edit_record($sql) {
        if (mysqli_query($GLOBALS['db'], $sql)) {  
            echo "Record edited successfully.";  
        } else {  
            echo "Could not edit record: " . mysqli_error($GLOBALS['db']) . "<br>";  
        } 
    }

    function delete_record($sql) {
        if (mysqli_query($GLOBALS['db'], $sql)) {  
            echo "Record deleted successfully.";  
        } else {  
            echo "Could not delete record: " . mysqli_error($GLOBALS['db']) . "<br>";  
        } 
    }

    //THIS IS THE 'EDIT RECIPE' MODE
    $data = file_get_contents("php://input");
    $dataArray = json_decode($data, true);
    
    $cocktailId = $dataArray['k_id'];
    $cocktailName = $dataArray['k_name'] ?? '';
    $category = $dataArray['k_category'] ?? '';
    $instructions = $dataArray['k_instructions'] ?? '';
    $thumbnail = $dataArray['k_thumbnail'] ?? '';
    $ingredientIds = $dataArray['k_ingredient_ids'] ?? [];
    $ingredientMeasures = $dataArray['k_ingredient_meas'] ?? [];

    edit_record("UPDATE drinks SET strDrink='$cocktailName', strInstructions='$instructions', strDrinkThumb='$thumbnail', strCategory='$category' WHERE idDrink=$cocktailId");
    
    //delete all previous ingredients from this table and start from scratch
    delete_record("DELETE FROM recipes WHERE idDrink=$cocktailId");
    foreach($ingredientIds as $ingredientId) {
        $measure = $ingredientMeasures[$ingredientId];
        insert_record("INSERT INTO recipes(idDrink, idIngredient, strMeasure) VALUES ($cocktailId, $ingredientId, '$measure')");
    }
?>