<?php
    if (session_status() == PHP_SESSION_NONE) {
        session_start();
    }
    
    if (isset($_SESSION["idUser"])) {
        $idUser = $_SESSION["idUser"];
    } else {
        header('Location: login.php');
        exit;
    }

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
    function generateID($primary_key, $table): int {
        $query = "SELECT MAX($primary_key) AS max_id FROM $table";
        $result = $GLOBALS['db']->query($query);
    
        if ($result) {
            $row = $result->fetch_assoc();
            $max_id = $row['max_id'];
            if ($max_id === NULL) {
                return 1000000;
            } else {
                return $max_id + 1;
            }
        } else {
            echo "Error while generating ID: " . $GLOBALS['db']->error;
            return -1;
        }
    }
    //THIS IS THE 'NEW RECIPE' MODE
    $drinkID = generateID("idDrink", "drinks");
    $data = file_get_contents("php://input");
    $dataArray = json_decode($data, true);
    
    $intUser = intval($idUser);
    $cocktailName = $dataArray['k_name'] ?? '';
    $category = $dataArray['k_category'] ?? '';
    $instructions = $dataArray['k_instructions'] ?? '';
    $thumbnail = $dataArray['k_thumbnail'] ?? '';
    $ingredientIds = $dataArray['k_ingredient_ids'] ?? [];
    $ingredientMeasures = $dataArray['k_ingredient_meas'] ?? [];
    $dateTime = new DateTime();
    $currentDateTime = $dateTime->format('Y-m-d H:i:s.u'); 
    insert_record("INSERT INTO drinks(idDrink, strDrink, strInstructions, strDrinkThumb, strCategory, Posted, idUser) VALUES ($drinkID, '$cocktailName', '$instructions', '$thumbnail', '$category', '$currentDateTime', $intUser)");

    foreach($ingredientIds as $ingredientId) {
        $measure = $ingredientMeasures[$ingredientId];
        insert_record("INSERT INTO recipes(idDrink, idIngredient, strMeasure) VALUES ($drinkID, $ingredientId, '$measure')");
    }
?>