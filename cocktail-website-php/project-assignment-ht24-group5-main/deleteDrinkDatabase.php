<?php
$db = new mysqli("localhost", "root", null, "project_db");
if ($db->connect_error) {
    die("Connection failed: " . $db->connect_error);
}
function delete_record($sql) {
        if (mysqli_query($GLOBALS['db'], $sql)) {  
            echo "Record deleted successfully.";  
        } else {  
            echo "Could not delete record: " . mysqli_error($GLOBALS['db']) . "<br>";  
        } 
}

if (isset($_GET['drink'])) {
    $cocktailId = $_GET['drink'];
    delete_record("DELETE FROM recipes WHERE idDrink=$cocktailId");
    delete_record("DELETE FROM drinks WHERE idDrink=$cocktailId");
}

?>
