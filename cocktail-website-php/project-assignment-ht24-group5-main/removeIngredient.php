<?php
header('Content-Type: application/json');
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

session_start();
if (isset($_SESSION["idUser"]))
{
    $idUser=$_SESSION["idUser"];
} else {
    header('Location: login.php');
    exit;
}

// Database connection
$db = new mysqli("localhost", "root", null, "project_db");

if ($db->connect_error) {
    echo json_encode(["success" => false, "error" => "Database connection failed: " . $db->connect_error]);
    exit;
}

$data = json_decode(file_get_contents('php://input'), true);

if (!isset($data['idIngredient'])) {
    echo json_encode(["success" => false, "error" => "ID Ingredient not set"]);
    exit;
}

$user_id = $idUser; // Replace with actual user ID from session IMPORTANT!
$idIngredient = $data['idIngredient'];

// Prepare the SQL statement to delete the ingredient
$stmt = $db->prepare("DELETE FROM favoritedingredients WHERE idUser = ? AND idIngredient = ?");
$stmt->bind_param("ii", $user_id, $idIngredient);

if ($stmt->execute()) {
    echo json_encode(["success" => true]);
} else {
    echo json_encode(["success" => false, "error" => "Database delete failed: " . $stmt->error]);
}

$stmt->close();
$db->close();
