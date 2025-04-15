<?php
session_start();
header("Content-Type: application/json");

// Initialize the response
$response = ["success" => false];

include 'db_connection.php';
error_log("Database connection successful.");

// Check if the request is POST and the necessary parameters are received
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["comment"]) && isset($_POST["idComment"])) {
    // Capture the comment data and its ID
    $comment = $_POST["comment"];
    $idComment = $_POST["idComment"];

    // Log received data for verification
    error_log("Data received for update: comment = $comment, idComment = $idComment");

    // Prepare the SQL statement to update the comment
    $sql = "UPDATE comments SET Content = ? WHERE idComment = ?";
    $stmt = $conn->prepare($sql);

    if ($stmt === false) {
        error_log("Error preparing statement: " . $conn->error);
        echo json_encode(["success" => false, "error" => "Database error: " . $conn->error]);
        exit;
    }

    // Bind the parameters (s = string, i = integer)
    $stmt->bind_param("si", $comment, $idComment);

    // Execute the statement and check if it was successful
    if ($stmt->execute()) {
        $response["success"] = true; // Update successful
        $response["idUser"] = $_SESSION['idUser']; //validation 
    } else {
        error_log("Error executing statement: " . $stmt->error);
        $response["error"] = "Error executing statement: " . $stmt->error;
    }

    // Close the statement
    $stmt->close();
} else {
    error_log("Invalid request. POST data not set.");
    $response["error"] = "Invalid request. POST data not set.";
}

// Return the response in JSON format
echo json_encode($response);

// Close the database connection
$conn->close();

