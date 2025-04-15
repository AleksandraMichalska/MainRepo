<?php
$db = new mysqli("localhost", "root", null, "project_db");
if ($db->connect_errno) {
    die("Could not connect: " . mysqli_connect_error());
}

$query = isset($_GET['query']) ? trim($db->real_escape_string($_GET['query'])) : '';

if ($query) {
    $sql = "SELECT idIngredient, strIngredient FROM ingredients WHERE strIngredient LIKE '%$query%'";
    $result = $db->query($sql);
    
    if ($result->num_rows > 0) {
        echo "<ul>";
        
        while ($row = $result->fetch_assoc()) {
            $ingredient_name = htmlspecialchars($row['strIngredient']);
            
            // Function to highlight matching letters
            $highlightedName = highlightQuery($ingredient_name, $query);

            echo "<li><button style='background:none; border:none;' onclick='addIngredient(". $row['idIngredient'] .",\"" .$ingredient_name."\")'>" . $highlightedName .  "</button></li>";
        }
        echo "</ul>";
    } else {
        echo "<p>No results found</p>";
    }
}

function highlightQuery($name, $query) {
    $query = preg_quote($query, '/'); // Escape any special characters in the query
    return preg_replace('/(' . $query . ')/i', '<span class="highlight">$1</span>', $name); // Highlight the matched part
}
?>
