<?php
$db = new mysqli("localhost", "root", null, "project_db");
if ($db->connect_error) {
    die("Connection failed: " . $db->connect_error);
}

if (session_status() == PHP_SESSION_NONE) {
    session_start();
}

if (isset($_SESSION["idUser"])) {
    $idUser = $_SESSION["idUser"];
} else {
    header('Location: login.php');
    exit;
}

// Query to fetch user's favorited cocktails with average ratings when available
// Use one decimal when necessary
$stmt = $db->prepare("
    SELECT 
        f.idDrink, 
        d.strDrink, 
        d.strDrinkThumb, 
        CASE 
            WHEN AVG(r.rating) = ROUND(AVG(r.rating), 0) THEN CAST(AVG(r.rating) AS UNSIGNED)
            ELSE FORMAT(AVG(r.rating), 1)
        END AS avgRating
    FROM 
        favoritedcocktails f
    LEFT OUTER JOIN 
        drinks d ON f.idDrink = d.idDrink
    LEFT JOIN 
        ratings r ON f.idDrink = r.idDrink
    WHERE 
        f.idUser = ?
    GROUP BY 
        f.idDrink, d.strDrink, d.strDrinkThumb
    ORDER BY 
        f.Date
");
$stmt->bind_param("i", $idUser);
$stmt->execute();
$result = $stmt->get_result();

// Query to fetch user's favorited ingredients
$ingredient_stmt = $db->prepare("
    SELECT 
        i.idIngredient AS idIngredient, 
        i.strIngredient AS strIngredient
    FROM 
        favoritedingredients fi
    JOIN 
        ingredients i ON fi.idIngredient = i.idIngredient
    WHERE 
        fi.idUser = ?
");
$ingredient_stmt->bind_param("i", $idUser);
$ingredient_stmt->execute();
$ingredient_result = $ingredient_stmt->get_result();

$db->close();
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Profile</title>
    <link rel="stylesheet" href="aglobal.css">
    <link rel="stylesheet" href="profile.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="g_background">

    <!-- Nav section -->
    <?php include 'navbar.php'; ?>

    <!-- Ingredients Section -->
    <div class="ingredients-container">
        <div class="ingredients-section">
            <h2>Your Ingredients</h2>
            <div class="ingredients-row">
                <?php
                if ($ingredient_result->num_rows > 0) {
                    while ($ingredient_row = $ingredient_result->fetch_assoc()) {
                        echo '<div class="ingredient-item g_addRoundedCorners">';
                        echo htmlspecialchars($ingredient_row['strIngredient']);
                        echo '<button id="remove-ingredient-' . htmlspecialchars($ingredient_row['idIngredient']) . '" class="remove-ingredient-button" data-ingredient-id="' . htmlspecialchars($ingredient_row['idIngredient']) . '">X</button>';
                        echo '</div>';
                    }
                } else {
                    echo '<p>No ingredients found in your favorites.</p>';
                }
                ?>
            </div>
        </div>

        <!-- Search Section for Ingredients -->
        <div class="ingredient-search-section g_addRoundedCorners g_shadow">
            <h2>Add Ingredient</h2>
            <input type="text" id="ingredient-search-box" placeholder="Search for ingredients..." class="ingredient-search-box g_addRoundedCorners">
            <div id="search-results" class="search-results"></div>
        </div>
    </div>

    <!-- Link to My Recipes -->
    <div class="middle-nav">
        <div class="middle-button">
            <a class="g_shadow" href="myRecipes.php">My Recipes &#8594;</a>
        </div>
    </div>

    <!-- Favorites Section -->
    <h2 class="favorites-header">Favorite Cocktails</h2>
    <div class="center-favorites">
        <div class="g_grid-container">
            <?php
            while ($row = $result->fetch_assoc()) {
                echo '<a class="g_grid-item" href="recipes.php?idDrink=' . htmlspecialchars($row['idDrink']) . '">';
                    // If not from API handle differently
                    if (htmlspecialchars($row['idDrink']) >= 1000000) {
                        echo '<img class="image" src="' . htmlspecialchars($row['strDrinkThumb']) . '" alt="Drink Image">';
                        echo '<div class="g_cocktail-name-overlay">';
                            echo '<div>' . htmlspecialchars($row['strDrink']) . '</div>';
                            echo '<div class="ratings">';
                                if (isset($row['avgRating'])) {
                                    echo '<div class="ratings">';
                                        echo '<p> <icons class="bi-star-fill star" </icons>' . '<p class="avgRating">'. $row['avgRating']. '/5 </p></p>';
                                    echo '</div>';
                                } else {
                                    echo '<p>Not Rated</p>';
                                }
                            echo'</div>';
                        echo '</div>';
                    } else { // If drink is from the API
                        echo '<div class="drink-id" data-id="' . htmlspecialchars($row['idDrink']) . '" data-avg-rating="' . $row['avgRating'] . '"></div>';
                    }
                echo '</a>';
            }
            ?>
        </div>
    </div>
    <script src="profile.js"></script>
</body>
</html>