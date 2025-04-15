// Function to fetch ingredients based on the user's search input
document.getElementById('ingredient-search-box').addEventListener('input', function () {
    const query = this.value.trim().toLowerCase();
    const resultsDiv = document.getElementById('search-results');
    resultsDiv.innerHTML = ''; // Clear previous results

    // If the query is empty, return early
    if (query.length < 1) {
        return;
    }

    // Fetch filtered ingredients from the database based on the user's query
    fetch(`getIngredients.php?query=${encodeURIComponent(query)}`)
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            console.log('Fetched filtered ingredients:', data); // Debug line to check data format

            // Display filtered results
            if (data.length > 0) {
                data.forEach(ingredient => {
                    const ingredientItem = document.createElement('div');
                    ingredientItem.className = 'ingredient-search-item';
                    ingredientItem.innerHTML = `
                        ${ingredient.strIngredient} 
                        <button class="add-ingredient-button" data-ingredient-id="${ingredient.idIngredient}">Add</button>`;
                    // Add click event to the button
                    ingredientItem.querySelector('.add-ingredient-button').addEventListener('click', function () {
                        addIngredient(ingredient.idIngredient, ingredient.strIngredient);
                    });

                    resultsDiv.appendChild(ingredientItem);
                });
            } else {
                resultsDiv.innerHTML = 'No ingredients found.';
            }
        })
        .catch(error => {
            console.error('Error fetching ingredient list:', error);
        });
});

// Function to add an ingredient to the user's favorites
function addIngredient(idIngredient, strIngredient) {
    fetch('addIngredient.php', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ idIngredient, strIngredient }),
    })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            if (data.success) {
                // Dynamically add the ingredient to the ingredients section
                updateIngredientSection({ idIngredient, strIngredient });
            } else {
                console.error('Error adding ingredient:', data.error);
            }
        })
        .catch(error => {
            console.error('Error adding ingredient:', error);
        });
}

// Function to dynamically update the ingredient section
function updateIngredientSection(ingredient) {
    const ingredientContainer = document.querySelector('.ingredients-row');

    // Create ingredient element
    const ingredientItem = document.createElement('div');
    ingredientItem.className = 'ingredient-item g_addRoundedCorners';
    ingredientItem.innerHTML = `
        ${ingredient.strIngredient}
        <button id="remove-ingredient-${ingredient.idIngredient}" 
                class="remove-ingredient-button" 
                data-ingredient-id="${ingredient.idIngredient}">X</button>
    `;

    // Add click event to remove button
    ingredientItem.querySelector('.remove-ingredient-button').addEventListener('click', function () {
        removeIngredient(ingredient.idIngredient);
    });

    ingredientContainer.appendChild(ingredientItem);
}

// Function to remove an ingredient from the user's favorites
function removeIngredient(idIngredient) {
    fetch('removeIngredient.php', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ idIngredient }),
    })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            if (data.success) {
                // Dynamically remove the ingredient from the ingredients section
                removeIngredientFromDOM(idIngredient);
            } else {
                console.error('Error removing ingredient:', data.error);
            }
        })
        .catch(error => {
            console.error('Error removing ingredient:', error);
        });
}

// Function to remove ingredient from the DOM
function removeIngredientFromDOM(idIngredient) {
    const button = document.querySelector(`#remove-ingredient-${idIngredient}`);
    if (button) {
        const ingredientItem = button.parentElement;
        ingredientItem.remove();
    }
}

// Add event listeners to all remove buttons
document.querySelectorAll('.remove-ingredient-button').forEach(button => {
    button.addEventListener('click', function () {
        const idIngredient = this.getAttribute('data-ingredient-id');
        console.log(`Remove button clicked for ingredient ID: ${idIngredient}`); // Debug log
        removeIngredient(idIngredient); // Call the remove function
    });
});

// Load time optimization
document.addEventListener('DOMContentLoaded', function () {
    const drinkElements = document.querySelectorAll('.drink-id');
    const drinkIds = Array.from(drinkElements).map(el => ({
        id: el.dataset.id,
        avgRating: el.dataset.avgRating
    }));

    if (drinkIds.length > 0) {
        fetchDrinksData(drinkIds); // Pass the drink ID and avgRating for API drinks
    }
});

function fetchDrinksData(drinkData) {
    const requests = drinkData.map(drink => {
        return fetch(`https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=${drink.id}`)
            .then(response => {
                if (!response.ok) {
                    throw new Error(`API error for ID ${drink.id}: ${response.statusText}`);
                }
                return response.json();
            })
            .then(data => ({ data, avgRating: drink.avgRating }));
    });

    Promise.all(requests)
        .then(drinkDataArray => {
            drinkDataArray.forEach(({ data, avgRating }) => {
                if (data && data.drinks && data.drinks.length > 0) {
                    const drink = data.drinks[0];
                    const drinkElement = document.querySelector(`.drink-id[data-id='${drink.idDrink}']`).parentElement;

                    const imgSrc = drink.strDrinkThumb;
                    const drinkName = drink.strDrink;

                    drinkElement.innerHTML = `
                        <img class="image" src="${imgSrc}" alt="Drink Image">
                        <div class="g_cocktail-name-overlay">
                            <div>${drinkName}</div>
                            <div class="ratings">
                                <p class="avgRating">
                                    ${avgRating ? `<icons class="bi-star-fill star"></icons> ${avgRating}/5` : 'Not Rated'}
                                </p>
                            </div>
                        </div>
                    `;
                } else {
                    console.error('No drink information found for ID:', drink.idDrink);
                }
            });
        })
        .catch(error => {
            console.error('Error fetching drink data:', error);
        });
}