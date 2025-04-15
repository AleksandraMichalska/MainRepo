<?php
    $db = new mysqli("localhost", "root", null, "project_db");
    if ($db->connect_errno) {
        die("Could not connect: " . mysqli_connect_error());
    }

    if (session_status() == PHP_SESSION_NONE) {
        session_start();
    }
    
    if (isset($_SESSION["idUser"])) {
        $logged_user = $_SESSION["idUser"];
    } else {
        header('Location: login.php');
        exit;
    }
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My recipes</title>
    <link rel="stylesheet" href="myRecipes.css">
    <link rel="stylesheet" href="aglobal.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body>
<?php include 'navbar.php'; ?>
    <form class="header" action="editor.php">
        <label class="page-title"><h1>My recipes</h1></label>
        <button class="g_greyButton">New recipe +</button>   
    </form>
        <?php
            // Prepare the SQL statement
            $stmt = $db->prepare("SELECT idDrink, strDrink, strInstructions, strDrinkThumb, strCategory, Posted, idUser FROM drinks WHERE idUser=?");
            // Bind the parameter
            $stmt->bind_param("i", $logged_user);
            $stmt->execute();
            // Get the result
            $result = $stmt->get_result();
            if ($result->num_rows > 0) {
                echo '<div class="g_grid-container">';
                while ($row = $result->fetch_assoc()) {
                    echo "
                        <div class='g_grid-item square-img'>
                            <a href='recipes.php?idDrink=".$row["idDrink"]."'>
                                <img src='".$row["strDrinkThumb"]."' alt='".$row["strDrink"]."'>
                            </a>
                            <div class='g_cocktail-name-overlay'>
                                <span class='drinkName'>".$row["strDrink"]."</span>
                                <div>
                                    <button class='recipeButton' onclick='openEditor(".$row["idDrink"].")'> Edit </button>
                                    <button class='recipeButton' onclick='deleteRecipe(".$row["idDrink"].")'> Delete </button>
                                </div>
                            </div>
                        </div>
                    ";
                }
                echo '</div>';
            } else {
                echo "<div class='noRecipes'>You don't have any recipes yet. Start creating!</div>";
            }
        ?>
    <script>
        function openEditor(drinkID) {
            window.location.href = "editor.php?drink=" + drinkID;
        }

        function deleteRecipe(drinkID) {
            if (confirm("Do you want to delete this recipe?")) {
                var xhr = new XMLHttpRequest();
                xhr.open('GET', 'deleteDrinkDatabase.php?drink=' + encodeURIComponent(drinkID), true);
                xhr.onreadystatechange = function() {
                    if (xhr.readyState == 4 && xhr.status == 200) {
                        window.location.reload();
                    }
                };
                xhr.send();
            } else {
            txt = "You pressed Cancel!";
            }
        }
    </script>
</body>
</html>