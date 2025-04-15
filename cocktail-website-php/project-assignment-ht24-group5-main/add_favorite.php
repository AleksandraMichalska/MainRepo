<?php
session_start();
if (isset($_SESSION['idUser'])) {
    $idUser = $_SESSION['idUser'];
    $idDrink = $_POST['idDrink'];

    // Database connection
    $db = new mysqli("localhost", "root", "", "project_db");
    if ($db->connect_error) {
        exit; // Exit silently if there is a connection error
    }

    // Check if the cocktail is already in favorites
    $sql = "SELECT * FROM favoritedcocktails WHERE idUser = ? AND idDrink = ?";
    $stmt = $db->prepare($sql);
    if (!$stmt) {
        exit;
    }

    $stmt->bind_param("ii", $idUser, $idDrink);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows == 0) {
        // Add the cocktail to favorites if it is not already in the list
        $sqlInsert = "INSERT INTO favoritedcocktails (idUser, idDrink, Date) VALUES (?, ?, NOW())";
        $stmtInsert = $db->prepare($sqlInsert);
        if (!$stmtInsert) {
            exit;
        }
        $stmtInsert->bind_param("ii", $idUser, $idDrink);
        $stmtInsert->execute();
        $stmtInsert->close();
    } else {
        // Remove the cocktail from favorites if it is already in the list
        $sqlDelete = "DELETE FROM favoritedcocktails WHERE idUser = ? AND idDrink = ?";
        $stmtDelete = $db->prepare($sqlDelete);
        if (!$stmtDelete) {
            exit;
        }
        $stmtDelete->bind_param("ii", $idUser, $idDrink);
        $stmtDelete->execute();
        $stmtDelete->close();
    }

    $stmt->close();
    $db->close();
    exit; // Exit without sending a response
} else {
    echo "You need to log in.";
    exit;
}


