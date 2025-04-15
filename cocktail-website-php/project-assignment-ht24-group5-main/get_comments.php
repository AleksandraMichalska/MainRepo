<?php
session_start();
header("Content-Type: application/json");

include 'db_connection.php';

$response = ["comments" => []];

if (isset($_GET["idDrink"])) {
    $idDrink = $_GET["idDrink"];

    // Get comments from the database, including idComment and idUser
    $sql = "SELECT c.idComment, c.Content, c.Date, u.username, c.idUser 
            FROM comments c 
            JOIN users u ON c.idUser = u.idUser 
            WHERE c.idDrink = ?";
    $stmt = $conn->prepare($sql);

    if ($stmt === false) {
        echo json_encode(["success" => false, "error" => "Database error: " . $conn->error]);
        exit;
    }

    $stmt->bind_param("i", $idDrink);
    $stmt->execute();
    $result = $stmt->get_result();

    while ($row = $result->fetch_assoc()) {
        // format the date
        $formattedDate = date('Y-m-d H:i', strtotime($row["Date"])); 

        $response["comments"][] = [
            "idComment" => $row["idComment"], 
            "username" => $row["username"],
            "text" => $row["Content"],
            "date" => $formattedDate, // change of format
            "userId" => $row["idUser"] // idUser 
        ];
    }

    $stmt->close();
} else {
    $response["error"] = "No idDrink specified.";
}

echo json_encode($response);
$conn->close();

