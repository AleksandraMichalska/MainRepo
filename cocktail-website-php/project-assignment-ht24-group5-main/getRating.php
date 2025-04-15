<?php
header('Content-Type: application/json');
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Database connection
$db = new mysqli("localhost", "root", null, "project_db");

if ($db->connect_error) {
    echo json_encode(["success" => false, "error" => "Database connection failed: " . $db->connect_error]);
    exit;
}

if (isset($_GET['idDrink'])) {
    $idDrink = intval($_GET['idDrink']);

    // Query to fetch the drinks average rating
    $stmt = $db->prepare("
        SELECT 
            CASE 
                WHEN AVG(r.rating) = ROUND(AVG(r.rating), 0) THEN CAST(AVG(r.rating) AS UNSIGNED)
                ELSE FORMAT(AVG(r.rating), 1)
            END AS avgRating
        FROM 
            ratings r
        WHERE 
            idDrink = ?
    ");
    $stmt->bind_param("i", $idDrink);
    $stmt->execute();
    $result = $stmt->get_result();
    
    // Fetch the result and return as JSON
    if ($row = $result->fetch_assoc()) {
        echo json_encode([
            "success" => true,
            "idDrink" => $idDrink,
            "avgRating" => $row['avgRating']
        ]);
    } else {
        echo json_encode([
            "success" => false,
            "error" => "No ratings found for this drink."
        ]);
    }
    
    $stmt->close();
    $db->close();
} else {
    echo json_encode(["success" => false, "error" => "idDrink parameter is missing."]);
}
?>
