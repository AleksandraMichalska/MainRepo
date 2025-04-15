<?php
header('Content-Type: application/json');
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Database connection
$db = new mysqli("localhost", "root", null, "project_db");

if ($db->connect_error) {
    echo json_encode(["error" => "Database connection failed: " . $db->connect_error]);
    exit;
}

// Check if a search query is provided
$searchQuery = isset($_GET['query']) ? $db->real_escape_string($_GET['query']) : '';

// If a search query is provided, filter the query
if (!empty($searchQuery)) {
    $query = "SELECT idIngredient, strIngredient FROM ingredients WHERE LOWER(strIngredient) LIKE '%$searchQuery%'";
} else {
    $query = "SELECT idIngredient, strIngredient FROM ingredients";
}

$result = $db->query($query);

if (!$result) {
    echo json_encode(["error" => "Database query failed: " . $db->error]);
    exit;
}

$ingredients = [];

while ($row = $result->fetch_assoc()) {
    $ingredients[] = $row;
}

echo json_encode($ingredients);
?>