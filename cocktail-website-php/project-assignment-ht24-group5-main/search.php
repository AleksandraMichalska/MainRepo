<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);

// Database connection
$db = new mysqli("localhost", "root", null, "project_db");
if ($db->connect_error) {
    die("Connection failed: " . $db->connect_error);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = file_get_contents("php://input");
    error_log("Received data: " . $data);

    $json = json_decode($data, true);

    // Check the type of request
    $type = $json['type'] ?? '';

    switch ($type) {
            case 'searchIngredients':
                $searchText = $json['search'];
                if($searchText == null)
                {
                    $response = [
                        "status" => "empty"
                    ];
                    echo json_encode($response);
                    exit;
                }
                $ingredients = [];
                $idIngredients = [];
                // Prepare the SQL statement
                $stmt = $db->prepare("
                SELECT strIngredient, idIngredient FROM ingredients WHERE strIngredient LIKE ? ORDER BY strIngredient ASC;
                ");
                $searchTerm = '%' . $searchText . '%';
                $stmt->bind_param("s", $searchTerm);
                $stmt->execute();
                $result = $stmt->get_result();

                while ($row = $result->fetch_assoc()) {
                    error_log("Cocktail: " . print_r($row, true));
                    $ingredients[] = $row['strIngredient'];
                    $idIngredients[] = $row['idIngredient'];
                }

                $response = [
                    "status" => "success",
                    "search_term" => $json['search'],
                    "ingredients" => $ingredients,
                    "idIngredients"=> $idIngredients,
                ];
            break;

            case 'searchDbByName':
                $searchText = $json['search'];
                $cocktails = [];
            
                if($searchText == null) {
                    $response = [
                        "status" => "empty",
                        "cocktails" => $cocktails
                    ];
                    echo json_encode($response);
                    exit;
                }
            
                // Prepare the SQL statement to retrieve cocktails and their average ratings
                $stmt = $db->prepare("
                    SELECT d.strDrink, d.idDrink, d.strDrinkThumb, 
                    IFNULL(AVG(r.Rating), 0) as averageRating, COUNT(r.idDrink) as ratingCount
                    FROM drinks d
                    LEFT JOIN ratings r ON d.idDrink = r.idDrink
                    WHERE d.strDrink LIKE ?
                    GROUP BY d.idDrink
                    ORDER BY d.strDrink ASC;

                ");
                
                $searchTerm = '%' . $searchText . '%';
                $stmt->bind_param("s", $searchTerm);
                $stmt->execute();
                $result = $stmt->get_result();
            
                while ($row = $result->fetch_assoc()) {
                    $cocktails[] = [
                        "strDrink" => $row['strDrink'],
                        "idDrink" => $row['idDrink'],
                        "strDrinkThumb" => $row['strDrinkThumb'],
                        "averageRating" => $row['averageRating'], // Add average rating to the response
                        "ratingCount" => $row['ratingCount']      // Add count of ratings (can be used for additional display)
                    ];
                }
            
                $response = [
                    "status" => "success",
                    "search_term" => $json['search'],
                    "cocktails" => $cocktails,
                ];
                break;
        


            case 'searchDbByCategory':
                $category = $json['category'];
                if ($category == null) {
                    $response = [
                        "status" => "empty"
                    ];
                    echo json_encode($response);
                    exit;
                }
                $cocktails = [];
            
                // Prepare the SQL statement
                $stmt = $db->prepare("
                    SELECT strDrink, idDrink, strDrinkThumb 
                    FROM drinks 
                    WHERE strCategory = ? 
                    ORDER BY strDrink ASC;
                ");
                // Bind the parameter
                $stmt->bind_param("s", $category);
                $stmt->execute();
                // Get the result
                $result = $stmt->get_result();
                
                while ($row = $result->fetch_assoc()) {
                    $cocktails[] = [
                        "strDrink" => $row['strDrink'],
                        "idDrink" => $row['idDrink'],
                        "strDrinkThumb" => $row['strDrinkThumb']
                    ];
                }
                    
                $response = [
                    "status" => "success",
                    "cocktails" => $cocktails, // return an array of cocktail objects
                ];
            break;




            
            case 'searchDbByIngredients':
                $ingredients = $json['ingredients'];
    
                if (empty($ingredients)) {
                    $response = [
                        "status" => "empty"
                    ];
                    echo json_encode($response);
                    exit;
                }
    
                $cocktails = [];
                // Prepare the placeholders for the ingredient names
                $placeholders = implode(',', array_fill(0, count($ingredients), '?'));
    
                // Prepare the SQL statement to fetch ingredient IDs
                $stmt = $db->prepare("SELECT idIngredient FROM ingredients WHERE strIngredient IN ($placeholders)");
    
                // Bind the ingredient names to the statement
                $stmt->bind_param(str_repeat('s', count($ingredients)), ...$ingredients);
                $stmt->execute();
    
                $result = $stmt->get_result();
                $ingredientIDs = [];
                while ($row = $result->fetch_assoc()) {
                    $ingredientIDs[] = $row['idIngredient'];
                }
    
                // If no ingredient IDs were found, return an empty response
                if (empty($ingredientIDs)) {
                    $response = [
                        "status" => "empty"
                    ];
                    echo json_encode($response);
                    exit;
                }
    
                // Prepare a placeholder for the IN clause for the cocktails query
                $placeholders = implode(',', array_fill(0, count($ingredientIDs), '?'));
    
                // Prepare the SQL statement to fetch cocktails based on ingredient IDs
                $ingredientCount = count($ingredientIDs);
                $stmt = $db->prepare("
                    SELECT r.idDrink, d.strDrink, d.strDrinkThumb, COUNT(*) as ingredient_count 
                    FROM recipes r
                    JOIN drinks d ON r.idDrink = d.idDrink 
                    WHERE r.idIngredient IN ($placeholders)
                    GROUP BY r.idDrink 
                    HAVING ingredient_count = ?
                    ORDER BY d.strDrink ASC
                ");
    
                // Create an array for the parameter types
                $types = str_repeat('i', count($ingredientIDs)) . 'i';
                $params = array_merge($ingredientIDs, [$ingredientCount]); // Merge IDs and the count into a single array
    
                // Bind the parameters
                $stmt->bind_param($types, ...$params);
                $stmt->execute();
    
                // Get the result
                $result = $stmt->get_result();
    
                // Fetch cocktails and store them in the array
                while ($row = $result->fetch_assoc()) {
                    $cocktails[] = [
                        "strDrink" => $row['strDrink'],
                        "idDrink" => $row['idDrink'],
                        "strDrinkThumb" => $row['strDrinkThumb']
                    ];
                }
    
                // Prepare the response
                $response = [
                    "status" => "success",
                    "cocktails" => $cocktails, // return an array of cocktail objects
                ];
                break;
            



        default:
            $response = [
                "status" => "error",
                "message" => "Unknown request type",
            ];
            break;
    }

    header('Content-Type: application/json');
    echo json_encode($response);

    $db->close();
    exit;
}
 
?>





<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cocktail Search</title>
    <link rel="stylesheet" href="search.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="g_background">
    <?php include 'navbar.php'; ?>

    <div class="search-container">
        <div class="search-group">
            <select id="filterSelect" class="filter-dropdown">
                <option value="name">Search by Name</option>
                <option value="ingredient">Search by Ingredient</option>
                <option value="category">Filter by Category</option>
            </select>

            <!-- Sort By Button -->
            <a id="sortByButton" class="blackButton">
                <i id="sortIcon" class="fas fa-arrow-up"></i>
                <i id="sortIcon" class="fas fa-arrow-down"></i>
                abc
            </a>

        </div>

        <!-- Search Input and Results -->
        <div>
            <!-- Search Input -->
            <input type="text" id="searchInput" class="search-input" placeholder="Search for a cocktail" style="display: block;">

            <!-- Ingredient Search Results -->
            <div id="ingredientSearch" class="ingredient-propositions slighRoundedCorners" style="display: none;"></div>
        </div>
        

        <!-- Category Buttons -->
        <div id="categoryButtons" style="display: none;" class="category-btn-container"></div>

        <!-- Search Button -->
        <button id="searchBtn" class="search-btn">
            <i class="fas fa-search"></i>
        </button>


    </div>
    
    <!-- Selected Ingredient Buttons -->
    <div id="ingredientButtons" class="center" style="display: none;"></div>
    


    <div class="g_grid-container" id="cocktailGrid">
        <!-- Cocktail results will be displayed here -->
    </div>

    <!-- Removed feature for tutorial slides -->
    <!-- <div class="slideshow-container" id="slideshow-container">
        <div class="slide active">
            <img src="tutorialPictures/tutorial1.png" alt="Tutorial 1">
        </div>
        <div class="slide">
            <img src="tutorialPictures/tutorial2.png" alt="Tutorial 2">
        </div>
        <div class="slide">
            <img src="tutorialPictures/tutorial3.png" alt="Tutorial 3">
        </div>
    </div> -->


    <script src="search.js"></script>

</body>
</html>

