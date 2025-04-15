<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recipespage</title>
    <link rel="stylesheet" href="recipes.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="aglobal.css">
</head>
<body>
<!--------------------   NavBar   --------------------------------->
<?php include 'navbar.php'; ?>
<?php
require_once 'db_connection.php';  // check the connection

// catch the idDrink from the URL
$idDrink = isset($_GET['idDrink']) ? intval($_GET['idDrink']) : 0;

// Variables per default If the cocktail is not found
$cocktailName = "Name not available";
$cocktailImg = "default.jpg";
$cocktailIngredients = "Ingredients not available";
$cocktailInstructions = "Instructions not available";

if ($idDrink >= 1000000) {
    // If the idDrink is greater than 1,000,000, search the database
    $sqlDrink = "SELECT strDrink, strDrinkThumb, strInstructions FROM drinks WHERE idDrink = ?";
    
    if ($stmtDrink = $conn->prepare($sqlDrink)) {
        $stmtDrink->bind_param("i", $idDrink);
        $stmtDrink->execute();
        $resultDrink = $stmtDrink->get_result();
        
        if ($resultDrink->num_rows > 0) {
            // If the drink is found, we get the data
            $drinkData = $resultDrink->fetch_assoc();
            $cocktailName = $drinkData['strDrink'];
            $cocktailImg = $drinkData['strDrinkThumb'];
            $cocktailInstructions = $drinkData['strInstructions'];

           // Get ingredients from the 'recipes' table
    $sqlRecipes = "SELECT r.strMeasure, i.strIngredient 
    FROM recipes r 
    JOIN ingredients i ON r.idIngredient = i.idIngredient 
    WHERE r.idDrink = ?";
    if ($stmtRecipes = $conn->prepare($sqlRecipes)) {
        $stmtRecipes->bind_param("i", $idDrink);
        $stmtRecipes->execute();
        $resultRecipes = $stmtRecipes->get_result();

        $ingredients = [];
        while ($row = $resultRecipes->fetch_assoc()) {
            // Concatenate the measurement and the ingredient
            $ingredients[] = $row['strMeasure'] . ' ' . $row['strIngredient'];
        }
        // Combine all ingredients into one string
        $cocktailIngredients = implode(', ', $ingredients);
        $stmtRecipes->close();  // Cerrar el statement
    } else {
        echo "Error in ingredient query: " . $conn->error;
    }

            } else {
                echo "No data found for idDrink = " . $idDrink;
            }
            $stmtDrink->close();  // Close the statement
        } else {
            echo "Error in beverage query: " . $conn->error;
        }
    } else {
    // If the idDrink is less than or equal to 1,000,000, search the API
    $apiUrl = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=" . $idDrink;
    $response = file_get_contents($apiUrl);
    $data = json_decode($response, true);
    
    if (isset($data['drinks'][0])) {
        $drink = $data['drinks'][0];
        $cocktailName = $drink['strDrink'];
        $cocktailImg = $drink['strDrinkThumb'];
        
        // Prepare ingredients and measurements
        $cocktailIngredients = [];
        for ($i = 1; $i <= 15; $i++) {
            $ingredient = $drink['strIngredient' . $i];
            $measure = $drink['strMeasure' . $i];
            if ($ingredient) {
                $cocktailIngredients[] = trim($measure . ' ' . $ingredient);
            }
        }
        $cocktailIngredients = implode(', ', $cocktailIngredients);
        $cocktailInstructions = $drink['strInstructions'];
    } else {
        echo "No data found for idDrink = " . $idDrink;
    }
}

// Check if the cocktail is already in favorites
$sqlFavorite = "SELECT * FROM favoritedcocktails WHERE idUser = ? AND idDrink = ?";
if ($stmtFavorite = $conn->prepare($sqlFavorite)) {
    $stmtFavorite->bind_param("ii", $idUser, $idDrink);
    $stmtFavorite->execute();
    $resultFavorite = $stmtFavorite->get_result();

    // If the cocktail is in favorites
    if ($resultFavorite->num_rows > 0) {
        $isFavorited = true;
    }
    $stmtFavorite->close();
}

// Check the user's rating for the drink
$rating = 0; // Default value if there is no rating
if ($idUser) {
    $query = "SELECT Rating FROM ratings WHERE idUser = ? AND idDrink = ?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param('ii', $idUser, $idDrink);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $rating = $row['Rating']; // catch the points
    }
}

?>

<!--------------------    Squars with img   --------------------------------->
    <div class="squar">
    <div class="squar-title"> <?php echo htmlspecialchars($cocktailName); ?> </div>
        <div class="squar1 g_addRoundedCorners">

        <div class="favorite-icon">
        <i class="bi bi-heart-fill heart-icon <?php echo $isFavorited ? 'active' : ''; ?>" 
            data-id="<?php echo $idDrink; ?>"
            onclick="toggleFavorite(<?php echo $idDrink; ?>)"></i>
        </div>
         <script>
            function toggleFavorite(idDrink) {
            // Check if user is logged in by checking a session variable
            <?php if (!isset($_SESSION['idUser'])) { ?>
                alert("You need to log in.");
                return; // Prevent further action if not logged in
            <?php } ?>

            // Create an AJAX request to add/remove favorites
            const xhr = new XMLHttpRequest();
            xhr.open("POST", "add_favorite.php", true);
            xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    const heartIcon = document.querySelector(`.heart-icon[data-id='${idDrink}']`);

                    if (xhr.responseText.trim() === "You need to log in.") {
                        alert("You need to log in.");
                        heartIcon.classList.remove('active'); // Ensure the icon is not active
                    } else {
                        // Toggle the visual state of the heart only if the user is logged in
                        heartIcon.classList.toggle('active');
                    }
                }
            };

            xhr.send("idDrink=" + idDrink);
        }
        </script>

        </script>
        </div>


        <div class="squar2 g_addRoundedCorners">                                                       <!--- Proportion of the img inside of the container  'object-fit: cover(better)/contain(original);' -->
            <img src="<?php echo htmlspecialchars($cocktailImg); ?>" alt="<?php echo htmlspecialchars($cocktailName); ?>" style="width: 100%; height: 100%; object-fit: cover;">
        </div>
        

        <div class="rating-img">
            <div class="rating">
                <?php for ($i = 1; $i <= 5; $i++): ?>
                    <i class="bi bi-star-fill star <?php echo $i <= $rating ? 'checked' : ''; ?>"></i>
                <?php endfor; ?>
            </div>
        </div>
        

        <script>
            const idDrink = <?php echo $idDrink; ?>;
            const idUser = '<?php echo $idUser; ?>';
            const isLoggedIn = <?php echo isset($_SESSION['idUser']) && $_SESSION['idUser'] ? 'true' : 'false'; ?>;
            console.log("idDrink:", idDrink, "idUser:", idUser, "isLoggedIn:", isLoggedIn);
        </script>

    <!---- Recipe Description  --->  
    <div class="Descriptions">
        <div class="Instructions">Instructions</div>
            <div class="Lorem-shadow">
            <div class="lorem">
               <?php echo htmlspecialchars($cocktailInstructions); ?>
            </div>
            </div>
    </div>
              
<!--------------------    Column recipe   --------------------------------->
    <div class="recipe-colum">
    <div class="columtitle"> Ingredients</div>
    <div class="ingredients-list">
        <ul>
            <?php
            $ingredientsArray = explode(', ', $cocktailIngredients);
            foreach ($ingredientsArray as $ingredient) {
                echo "<li>" . htmlspecialchars($ingredient) . "</li>";
            }
            ?>
        </ul>
    </div>
</div>
    </div>    
    </div> 
<!--------------------   ComentsBox    --------------------------------->

<div class="coments">
    <div class="coments-box"></div>
    <div class="comentarios">Comments</div>
    <div class="coments-box2" id="coments-box2">
    </div>
    <div class="butoms">
        <button class="add" id="add-btn">Add</button>
        <button class="edit" id="edit-btn">Edit</button>
        <button class="delete"id="delete-btn">Delete</button>
    </div>
</div>
   
        
<!--------------------    --------------------------------->
    <script src="recipes.js"></script>
</body>
</html>