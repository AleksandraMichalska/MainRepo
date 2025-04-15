<?php
// Database connection settings
$db = new mysqli("localhost", "root", "", "project_db");
if ($db->connect_error) {
    die("Connection failed: " . $db->connect_error);
}

// Path to the JSON file
$jsonFilePath = "C:\Users\ahlen\Downloads\ingredientsById.json";

// Read the JSON file
$jsonData = file_get_contents($jsonFilePath);
if ($jsonData === false) {
    die("Error reading the JSON file.");
}

// Decode the JSON data into a PHP array
$ingredients = json_decode($jsonData, true);
if ($ingredients === null) {
    die("Error decoding the JSON data.");
}

// Loop through each ingredient and insert it into the ingredients table
foreach ($ingredients as $ingredient) {
    $id = $ingredient['id'];
    $name = $ingredient['name'];

    // Prepare the SQL statement
    $stmt = $db->prepare("INSERT INTO ingredients (idIngredient, strIngredient) VALUES (?, ?)");
    if ($stmt === false) {
        die("Error preparing the statement: " . $db->error);
    }

    // Bind the parameters
    $stmt->bind_param("is", $id, $name);

    // Execute the statement
    if (!$stmt->execute()) {
        echo "Error inserting ingredient with ID $id: " . $stmt->error . "<br>";
    } else {
        echo "Successfully inserted ingredient: $name (ID: $id)<br>";
    }

    // Close the statement
    $stmt->close();
}

// Close the database connection
$db->close();
?>
