<?php
    $db = new mysqli("localhost", "root", null, "project_db");
    if ($db->connect_errno) {
        die("Could not connect: " . mysqli_connect_error());
    }
    if (isset($_GET['drink'])) {
        $drinkID = $_GET['drink'];
        $edit = true;
        $scriptLink = "editDrinkDatabase.php";
        // Prepare the SQL statement
        $stmt = $db->prepare("SELECT idDrink, strDrink, strInstructions, strDrinkThumb, strCategory FROM drinks WHERE idDrink=?");
        // Bind the parameter
        $stmt->bind_param("i", $drinkID);
        $stmt->execute();
        // Get the result
        $result = $stmt->get_result();
        if ($row = $result->fetch_assoc()) {
            $drinkName = $row['strDrink'];
            $drinkInstructions = $row['strInstructions'];
            $drinkThumbnail = $row['strDrinkThumb'];
            $drinkCategory = $row['strCategory'];
            $drinkIngredientsIds = array();
            $drinkIngredientsStrs = array();
            $drinkIngredientsMeasures = array();
            $stmt2 = $db->prepare("SELECT recipes.idDrink, recipes.idIngredient, recipes.strMeasure, ingredients.strIngredient FROM recipes INNER JOIN ingredients on recipes.idIngredient=ingredients.idIngredient WHERE recipes.idDrink=?");
            $stmt2->bind_param("i", $drinkID);
            $stmt2->execute();
            $result2 = $stmt2->get_result();
            while ($row2 = $result2->fetch_assoc()) {
                array_push($drinkIngredientsIds, $row2['idIngredient']);
                array_push($drinkIngredientsStrs, $row2['strIngredient']);
                array_push($drinkIngredientsMeasures, $row2['strMeasure']);
            }
        }
    } else {
        $edit = false;
        $drinkID = -1;
        $scriptLink = "addDrinkDatabase.php";
        // set variables to avoid problems
        $drinkName = '';
        $drinkInstructions = '';
        $drinkThumbnail = '';
        $drinkCategory = '';
        $drinkIngredientsIds = array();
        $drinkIngredientsStrs = array();
        $drinkIngredientsMeasures = array();
       
    }
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recipe editor</title>
    <link rel="stylesheet" href="editor.css" type="text/css">
</head>
<body>
    <?php include 'navbar.php'; ?>
    <form class="header" action="myRecipes.php">
        <label class="page-title"><h1>Recipe editor</h1></label>
        <button class="g_greyButton"> Back to 'My recipes' </button>
    </form>
    <h4 class="errorMessage" id="errorMessage"></h4>
    <div class="recipe-window">
        <div class="image-section">
            <input type="file" id="image-upload" accept="image/*" class="fileInput">
            <div id="image-preview" class="imagePreview">
                <?php
                if($edit) {
                    echo '<img src="'.$drinkThumbnail.'" alt="Image preview" class="image">';
                }
                else {
                    echo  '<br>
                    No uploaded image';
                }
                ?>
           </div>
        </div>
        <div class="information-section">
            <div class="information-header">
                <div>
                    <?php 
                    if($edit) {
                        echo  '<input class="g_textInput" type="text" placeholder="Name" style="width:10cm;" id="cocktailName" value="'.$drinkName.'">';
                    }
                    else {
                        echo  '<input class="g_textInput" type="text" placeholder="Name" style="width:10cm;" id="cocktailName">';
                    }
                    ?>
                
                    <select id="categoryChoice" class="g_dropdown" autofocus>
                        <option value="undecided">Choose category</option>
                        <?php
                        $categories = array('Cocktail', 'Ordinary Drink', 'Punch / Party Drink', 'Shake', 'Other / Unknown', 'Cocoa', 'Shot', 'Coffee / Tea', 'Homemade Liqueur', 'Beer', 'Soft Drink'); 
                        foreach ($categories as $cat) {
                            if($edit) {
                                if($cat === $drinkCategory) {
                                    echo '<option value='.$cat.' selected>'.$cat.'</option>';
                                } else {
                                    echo '<option value='.$cat.'>'.$cat.'</option>';
                                }
                            } else {
                                echo '<option value='.$cat.'>'.$cat.'</option>';
                            }
                        }
                        ?>
                    </select>
                </div>
                <button class="g_greyButton" onclick="confirmChanges()">Confirm changes</button>
            </div>
            <div class="ingredients-section">
                <div class="ingredients-header">
                    <label>Ingredients</label>
                    <div class="search-section">
                        <input type="text" class="search-ingredients" id="searchIngredients" placeholder="Search for ingredients" style="display: block;">            
                        <div id="searchResults" class="searchResultsContainer"></div>
                    </div>
                </div>
                <ul class="ingredients-list" id="ingredientsList"></ul>
            </div>
            <?php 
            if($edit) {
                echo  '<textarea class="instructions-field" id="instructions-field" wrap="soft" placeholder="Instructions">'.$drinkInstructions.'</textarea>';
            }
            else {
                echo  '<textarea class="instructions-field" id="instructions-field" wrap="soft" placeholder="Instructions"></textarea>';
            }
            ?>
            
        </div>
    </div>
    <script>
    let chosenIngredientsIds = [];
    let chosenIngredientsStrs = new Map();
    const imageUpload = document.getElementById('image-upload');
    const imagePreview = document.getElementById('image-preview');

    window.onload = function() {
        let isEdit = <?php echo json_encode($edit); ?>;
        if(isEdit) {
            chosenIngredientsIds = <?php echo json_encode($drinkIngredientsIds); ?>; // overwrite the js list of ingredient ids with the php list of ids 
            let ingredientsStrsIndexed = <?php echo json_encode($drinkIngredientsStrs); ?>; //chosenIngredientStrs is a map, so we cannot simply overwrite it with indexed list $drinkIngredientsStrs
            let ingredientsMeasuresIndexed = <?php echo json_encode($drinkIngredientsMeasures); ?>;
            const ingredientsList = document.getElementById('ingredientsList');
            let newHTML = '';
            //start filling the ingredients list with ingredients from the database
            for (let i = 0; i < chosenIngredientsIds.length; i++) {
                let ingredientID = chosenIngredientsIds[i];
                let ingredientName = ingredientsStrsIndexed[i];
                let ingredientMeasure = ingredientsMeasuresIndexed[i];
                chosenIngredientsStrs.set(ingredientID, ingredientName); 
                newHTML = newHTML +
                '<li>' +
                    '<input id="measurement'+ ingredientID + '" placeholder="Measure" class="measurement-input" type="text" value="' + ingredientMeasure + '">' +
                    '<label class="ingredient-label">' + ingredientName + '</label>' +
                    '<button class="x-button" onclick="deleteIngredient(' + ingredientID + ')">X</button>' +
                '</li>';
            }
            ingredientsList.innerHTML = newHTML;
        }
    };

    imageUpload.addEventListener('change', function(event) {
        const file = event.target.files[0];

        if (file) {
            const reader = new FileReader();

            reader.onload = function(e) {
                imagePreview.innerHTML = `<img src="${e.target.result}" alt="Image preview" class="image">`;
            }

            reader.readAsDataURL(file);
        } else {
            imagePreview.innerHTML = 'No uploaded image';
        }
    });

    document.getElementById('searchIngredients').addEventListener('input', function() {
        var query = this.value;
        var xhr = new XMLHttpRequest();
        xhr.open('GET', 'editorSearch.php?query=' + encodeURIComponent(query), true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState == 4 && xhr.status == 200) {
                document.getElementById('searchResults').innerHTML = xhr.responseText;
            }
        };
            xhr.send();
        });
    
    function addIngredient(ingredient_id, ingredient_str) { 
        index = chosenIngredientsIds.indexOf(ingredient_id); 
        if(index == -1) {
            chosenIngredientsIds.push(ingredient_id);
            chosenIngredientsStrs.set(ingredient_id, ingredient_str);
            refreshIngredients();
        } 
    }

    function deleteIngredient(ingredient_id) {
        index = chosenIngredientsIds.indexOf(ingredient_id);
        chosenIngredientsIds.splice(index, 1);
        chosenIngredientsStrs.delete(ingredient_id);
        refreshIngredients();
    }

    function refreshIngredients() {
        const ingredientsList = document.getElementById('ingredientsList');
        let newHTML = '';
        let i = 0;
        while (i < chosenIngredientsIds.length) {
            ingredientId = chosenIngredientsIds[i];
            ingredientName = chosenIngredientsStrs.get(ingredientId);
            measurementField = document.getElementById('measurement'+ingredientId);
            if (measurementField == null) {
                ingredientMeasure = "";
            } else {
                ingredientMeasure = measurementField.value; //check, what measurement value is written here right now and copy it to the new code
            }
            newHTML = newHTML +
            '<li>' +
                '<input id="measurement'+ ingredientId + '" placeholder="Measure" class="measurement-input" type="text" value="' + ingredientMeasure + '">' +
                '<label class="ingredient-label">' + ingredientName + '</label>' +
                '<button class="x-button" onclick="deleteIngredient(' + ingredientId + ')">X</button>' +
            '</li>';
            i++;     
        }
        ingredientsList.innerHTML = newHTML; //overwrite the list of ingredients
    }

    const searchInput = document.getElementById('searchIngredients');
    const ingredientSearch = document.getElementById('searchResults');

    searchInput.addEventListener('focus', function() {
        // Show the recommendations when input is focused
        ingredientSearch.style.display = 'block';
    });

    searchInput.addEventListener('blur', function() {
        // Hide the recommendations when input loses focus
        setTimeout(() => {
            ingredientSearch.style.display = 'none';
        }, 200); // Delay to allow click events on the recommendations
    });

    function confirmChanges() {
    
    errorField = document.getElementById('errorMessage');

    //check if the name has a correct length
    const cocktailName = document.getElementById('cocktailName').value;
    if (cocktailName.length > 50) {
        errorField.innerText = "ERROR: Cocktail's name should be maximum 50 characters.";
        return;
    }
    if (cocktailName.length < 3) {
        errorField.innerText = "ERROR: Cocktail's name should be at least 3 characters.";
        return;
    }

    //Check if category is selected
    var categoryField = document.getElementById("categoryChoice");
    var category = categoryField.options[categoryField.selectedIndex].text;
    if(category === 'Choose category') {
        errorField.innerText = "ERROR: Please select a category.";
        return;
    }

    //check if ingredients are selected
    if(chosenIngredientsIds.length < 1) {
        errorField.innerText = "ERROR: Please choose at least one ingredient.";
        return;
    }

    // check if all ingredients have measures. Collect all ingredients measures
    chosenIngredientsMeasures = new Map();
    let i = 0;
    while (i < chosenIngredientsIds.length) {
        ingredientId = chosenIngredientsIds[i];
        measurementField = document.getElementById('measurement'+ingredientId);
        ingredientMeasure = measurementField.value;
        if(ingredientMeasure === '') {
            errorField.innerText = "ERROR: All ingredients should have measures.";
            return;
        }
        chosenIngredientsMeasures.set(ingredientId, ingredientMeasure);;
        i++;
    }

    //check if there are enough (or not too much) instructions written
    const instructions = document.getElementById('instructions-field').value;
    if (instructions.length > 1000) {
        errorField.innerText = "ERROR: Instructions should be maximum 1000 characters.";
        return;
    }
    if (instructions.length < 50) {
        errorField.innerText = "ERROR: Instructions should be at least 50 characters.";
        return;
    }

    //Check if everything is ok with the image. Then upload image to folder and remember the path
    const image = document.getElementById('image-upload').files[0];
    var pathToImage = '';
    var drinkId = <?php echo $drinkID;?>;

    let isDatabaseImage = false;
    if (!image) {
        let isEdit = <?php echo json_encode($edit); ?>;
        if(isEdit) { //new image might not have been chosen, but if this is an edit mode, we already have an image
            pathToImage = <?php echo '"'.$drinkThumbnail.'"'; ?>;
            isDatabaseImage = true;
        }
        else {
            errorField.innerText = "ERROR: No image file chosen.";
            return;
        }
    }

    // we don't have to upload the image to our catalog again if no new image was chosen
    // the link used already leads to an image from our catalog
    if(!isDatabaseImage) { 
        let formData = new FormData();
        formData.append('image', image);

        fetch('uploadImage.php', {
        method: 'POST',
        body: formData
        })
        .then(response => response.text())
        .then(data => {
            if(data.startsWith("ERROR:")) {
                errorField.innerText = data;
                return;
            }
            pathToImage = data;
            //data is ready. Time to send to the database
            sendToDatabase(drinkId, cocktailName, category, instructions, pathToImage, chosenIngredientsIds, chosenIngredientsMeasures);
        })
        .catch(error => {
            console.error('Error:', error);
            errorField.innerText = 'ERROR: An error occured while sending the image.';
            return;
        });
    }
    else {
        sendToDatabase(drinkId, cocktailName, category, instructions, pathToImage, chosenIngredientsIds, chosenIngredientsMeasures);
    }

    }
    function sendToDatabase(drinkId, cocktailName, category, instructions, pathToImage, chosenIngredientsIds, chosenIngredientsMeasures) {
            
            var xhr = new XMLHttpRequest();
            <?php echo 'xhr.open("POST", "'.$scriptLink.'", true);';?>
            xhr.setRequestHeader("Content-Type", "application/json");
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    window.location.href = "myRecipes.php";
                }
            };
            var objIngredientsMeasures = Object.fromEntries(chosenIngredientsMeasures);
            var dataToSend = {
            k_id: drinkId,
            k_name: cocktailName,
            k_category: category,
            k_instructions: instructions,
            k_thumbnail: pathToImage,
            k_ingredient_ids: chosenIngredientsIds,
            k_ingredient_meas: objIngredientsMeasures
            };
            xhr.send(JSON.stringify(dataToSend));

        }

</script>
</body>
</html>