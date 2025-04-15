<?php
session_start();
header("Content-Type: application/json");

$response = ["success" => false];

include 'db_connection.php';

// Check if the request is POST and the necessary parameter is received
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["idComment"])) {
    $idComment = $_POST["idComment"];

    // Delete the comment from the database
    $sql = "DELETE FROM comments WHERE idComment = ?";
    $stmt = $conn->prepare($sql);

    if ($stmt === false) {
        echo json_encode(["success" => false, "error" => "Database error: " . $conn->error]);
        exit;
    }

    $stmt->bind_param("i", $idComment);

    // Execute the statement and check if it was successful
    if ($stmt->execute()) {
        $response["success"] = true;
    } else {
        $response["error"] = "Error executing query: " . $stmt->error;
    }

    // Close the statement
    $stmt->close();
} else {
    $response["error"] = "Invalid request. POST data not set.";
}

// Return the response in JSON format
echo json_encode($response);

// Close the database connection
$conn->close();

