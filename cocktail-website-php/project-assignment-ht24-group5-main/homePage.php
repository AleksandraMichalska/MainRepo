<?php

// Connecting to the database
$db = new mysqli("localhost", "root", null, "project_db");
if ($db->connect_error) {
    die("Connection failed: " . $db->connect_error);
}

// Create session if it is not already done
if (session_status() == PHP_SESSION_NONE) {
    session_start();
}
if (isset($_SESSION["idUser"])) {
    $idUser = $_SESSION["idUser"];
    
    // Fetch favorited ingredients
    $favoritedIngredients = [];
    $stmt = $db->prepare("SELECT idIngredient FROM favoritedingredients WHERE idUser = ?");
    $stmt->bind_param("i", $idUser);
    $stmt->execute();
    $result = $stmt->get_result();

    while ($row = $result->fetch_assoc()) {
        $favoritedIngredients[] = $row['idIngredient'];
    }

    // If there are favorited ingredients, search for doable cocktails
    $doableCocktails = [];
    if (!empty($favoritedIngredients)) {
        // Get the total count of ingredients for each cocktail
        $ingredientCountsSql = "
            SELECT idDrink, COUNT(idIngredient) AS totalIngredients
            FROM recipes
            GROUP BY idDrink
        ";
        $ingredientCountsStmt = $db->prepare($ingredientCountsSql);
        $ingredientCountsStmt->execute();
        $ingredientCountsResult = $ingredientCountsStmt->get_result();

        // Store the total ingredients per drink
        $totalIngredients = [];
        while ($row = $ingredientCountsResult->fetch_assoc()) {
            $totalIngredients[$row['idDrink']] = $row['totalIngredients'];
        }

        // Check which cocktails can be made with the favorited ingredients
        foreach ($totalIngredients as $idDrink => $total) {
            $ingredientCheckSql = "
                SELECT COUNT(idIngredient) AS ingredientCount
                FROM recipes
                WHERE idDrink = ? AND idIngredient IN (" . implode(",", $favoritedIngredients) . ")
            ";
            $ingredientCheckStmt = $db->prepare($ingredientCheckSql);
            $ingredientCheckStmt->bind_param("i", $idDrink);
            $ingredientCheckStmt->execute();
            $ingredientCheckResult = $ingredientCheckStmt->get_result();

            if ($ingredientCheckResult) {
                $checkRow = $ingredientCheckResult->fetch_assoc();
                if ($checkRow['ingredientCount'] == $total) {
                    $doableCocktails[] = $idDrink;
                }
            }
        }

        // Fetch cocktail details for each doable cocktail
        $cocktailDetails = [];
        if (!empty($doableCocktails)) {
            // Placeholders for the IN clause
            $placeholders = implode(",", array_fill(0, count($doableCocktails), '?'));
            $types = str_repeat("i", count($doableCocktails));

            $stmt = $db->prepare("
                SELECT 
                    d.idDrink, 
                    d.strDrink, 
                    d.strDrinkThumb, 
                    CASE 
                        WHEN AVG(r.rating) = ROUND(AVG(r.rating), 0) THEN CAST(AVG(r.rating) AS UNSIGNED)
                        ELSE FORMAT(AVG(r.rating), 1)
                    END AS avgRating
                FROM 
                    drinks d
                LEFT JOIN 
                    ratings r ON d.idDrink = r.idDrink
                WHERE 
                    d.idDrink IN ($placeholders)
                GROUP BY 
                    d.idDrink, d.strDrink, d.strDrinkThumb
            ");

            $stmt->bind_param($types, ...$doableCocktails);
            $stmt->execute();
            $result = $stmt->get_result();

            while ($row = $result->fetch_assoc()) {
                $cocktailDetails[] = $row;
            }
        }
    }
}

    
// Query to fetch recently added cocktails with ratings
// Use one decimal when necessary
$stmt = $db->prepare("
SELECT 
    d.idDrink, 
    d.strDrink, 
    d.strDrinkThumb, 
    CASE 
        WHEN AVG(r.rating) = ROUND(AVG(r.rating), 0) THEN CAST(AVG(r.rating) AS UNSIGNED)
        ELSE FORMAT(AVG(r.rating), 1)
    END AS avgRating
FROM 
    drinks d
LEFT OUTER JOIN 
    ratings r ON d.idDrink = r.idDrink
GROUP BY 
    d.idDrink, d.strDrink, d.strDrinkThumb
ORDER BY 
    Posted DESC 
LIMIT 6
");
$stmt->execute();
$result = $stmt->get_result();

$cocktails = [];

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $cocktails[] = $row;
    }
} else {
    echo "0 results";
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Carousel Cocktails</title>
    <link rel="stylesheet" href="homepage.css">
    <link rel="stylesheet" href="aglobal.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="g_background">
    <?php include 'navbar.php'; ?>

    <!-- Random cocktails -->
    <h2 class="header">Random Cocktails</h2>

    <div class="carousel-container"> 
        <div class="carousel">
            <!-- This is where the cocktail grid items will be dynamically inserted -->
        </div>
    </div>
    
    <!-- Recently added drinks in the database -->
    <h2 class="header center-header">Recent Cocktails</h2>

    <div class="g_grid-container"> 
        <?php foreach ($cocktails as $cocktail): ?>
            <div class="g_grid-item">
                <a href="recipes.php?idDrink=<?php echo $cocktail['idDrink']; ?>">
                    <img src="<?php echo $cocktail['strDrinkThumb']; ?>" alt="<?php echo $cocktail['strDrink']; ?>">
                </a>
                <div class="g_cocktail-name-overlay">
                    <span><?php echo $cocktail['strDrink']; ?></span>
                    <?php if (isset($cocktail['avgRating'])) {
                        echo '<div class="ratings">';
                            echo '<p> <icons class="bi-star-fill star" </icons>' . '<p class="avgRating">'. $cocktail['avgRating']. '/5 </p></p>';
                        echo '</div>';
                    } else {
                        echo '<p>Not Rated</p>';
                    } ?>
                </div>
            </div>
        <?php endforeach; ?>
    </div>

    <?php if(isset($_SESSION["idUser"])) { // The section below will only be displayed if you are logged in ?>
        <?php if (!empty($cocktailDetails)) { ?>
            <h2 class="header center-header">Community Created Cocktails You Can Make With Your Ingredients</h2>
            <div class="g_grid-container center">
                <?php foreach ($cocktailDetails as $cocktail): ?>
                    <div class="grid-item">
                        <a href="recipes.php?idDrink=<?php echo $cocktail['idDrink']; ?>">
                            <img src="<?php echo $cocktail['strDrinkThumb']; ?>" alt="<?php echo $cocktail['strDrink']; ?>">
                        </a>
                        <div class="g_cocktail-name-overlay">
                            <span><?php echo $cocktail['strDrink']; ?></span>
                            <?php if (isset($cocktail['avgRating'])) {
                                echo '<div class="ratings">';
                                    echo '<p> <icons class="bi-star-fill star" </icons>' . '<p class="avgRating">'. $cocktail['avgRating']. '/5 </p></p>';
                                echo '</div>';
                            } else {
                                echo '<p>Not Rated</p>';
                            } ?>
                        </div>
                    </div>
                <?php endforeach; ?>
            </div>
        <?php } else { ?>
            <h2 class="header center-header bottom-header">You Can Not Make Any Community Created Cocktails With Your Ingredients</h2>
        <?php } ?>
    <?php }?>
    <script src="home.js"></script>
</body>
</html>
