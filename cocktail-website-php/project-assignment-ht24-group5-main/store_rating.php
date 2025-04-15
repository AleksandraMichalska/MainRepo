<?php
require_once 'db_connection.php'; 


$data = json_decode(file_get_contents("php://input"), true);
$idUser = $data['idUser'];
$idDrink = $data['idDrink'];
$rating = $data['rating'];


if ($rating === 0) {
    $query = "DELETE FROM ratings WHERE idUser = ? AND idDrink = ?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param('ii', $idUser, $idDrink);
    $stmt->execute();
    $response = ['success' => true];
} else {
    
    $sql = "SELECT * FROM ratings WHERE idUser = ? AND idDrink = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ii", $idUser, $idDrink);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        
        $sql = "UPDATE ratings SET Rating = ? WHERE idUser = ? AND idDrink = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("iii", $rating, $idUser, $idDrink);
    } else {
        
        $sql = "INSERT INTO ratings (idUser, idDrink, Rating) VALUES (?, ?, ?)";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("iii", $idUser, $idDrink, $rating);
    }

    if ($stmt->execute()) {
        $response = ['success' => true];
    } else {
        $response = ['success' => false];
    }
}

echo json_encode($response);

$stmt->close();
$conn->close();
