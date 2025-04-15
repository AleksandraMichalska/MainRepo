<?php
session_start();
header("Content-Type: application/json");

$response = ["success" => false];

// Check if the user is logged in 
if (!isset($_SESSION["idUser"])) {
    echo json_encode(["success" => false, "error" => "User not logged in"]);
    exit;
}

include 'db_connection.php';

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["comment"]) && isset($_POST["idDrink"])) {
    $comment = $_POST["comment"];
    $idDrink = $_POST["idDrink"];
    $idUser = $_SESSION["idUser"];
    $currentDateTime = date('Y-m-d H:i');// Here is the change for the date format.

    // Insert the comment into the database
    $sql = "INSERT INTO comments (idDrink, idUser, Content, Date) VALUES (?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);

    if ($stmt === false) {
        echo json_encode(["success" => false, "error" => "Database error: " . $conn->error]);
        exit;
    }

    $stmt->bind_param("iiss", $idDrink, $idUser, $comment, $currentDateTime);

    if ($stmt->execute()) {
        // Get the last inserted ID
        $idComment = $stmt->insert_id;

        // Get the username
        $sqlUser = "SELECT username FROM users WHERE idUser = ?";
        $stmtUser = $conn->prepare($sqlUser);

        if ($stmtUser === false) {
            echo json_encode(["success" => false, "error" => "Database error: " . $conn->error]);
            exit;
        }

        $stmtUser->bind_param("i", $idUser);
        $stmtUser->execute();
        $resultUser = $stmtUser->get_result();
        $user = $resultUser->fetch_assoc();

        // Respond with necessary data to display the comment
        $response = [
            "success" => true,
            "username" => $user["username"],
            "date" => $currentDateTime,
            "idComment" => $idComment, //Add the ID 
            "userId" => $idUser // ID of the user
        ];
    } else {
        $response["error"] = "Error executing query: " . $stmt->error;
    }

    $stmt->close();
} else {
    $response["error"] = "Invalid request. POST data or session not set.";
}

echo json_encode($response);
$conn->close();





