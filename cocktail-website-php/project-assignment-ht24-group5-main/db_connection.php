<?php
// db_connection.php

$host = 'localhost';
$user = 'root';
$password = '';  // If your password is different, change it here
$database = 'project_db';  // Name of your database

// Create the connection
$conn = new mysqli($host, $user, $password, $database);

// Check if the connection was successful
if ($conn->connect_error) {
    die("Database connection error: " . $conn->connect_error);
}
