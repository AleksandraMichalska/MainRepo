// Store selected ingredients, category and cocktail results
let selectedIngredients = [];
let selectedCategory = null;
let allResults = [];

// Show the previous result on load ( local storage )
window.addEventListener('load', function() {
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('newSearch') === 'true') {
        localStorage.clear();
        window.location.href = "search.php";
    }
}); 


 // Function to check and scroll to the saved position
 function checkAndScrollToPosition() {
    const savedScrollPosition = localStorage.getItem('scrollPosition');
    const pageHeight = Math.max(document.body.scrollHeight, document.documentElement.scrollHeight);

    // Ensure savedScrollPosition is a number and check against page height
    if (savedScrollPosition !== null) {
        const scrollPosition = parseInt(savedScrollPosition, 10)
        const windowHeight = parseInt(window.innerHeight, 10)
        console.log('Page Height:', pageHeight);
        console.log('Current Scroll Position:', scrollPosition);
        console.log('Current Window Height:', windowHeight);
        console.log('SUM:', scrollPosition + windowHeight);
        if (scrollPosition + windowHeight <= pageHeight) {
            // Scroll to the saved position smoothly
            window.scrollTo({
                top: scrollPosition,
                behavior: 'smooth'
            });
            clearInterval(checkInterval); // Stop checking once scrolled
        }
    }
    console.log('Saved Scroll Position:', savedScrollPosition);
}

// Check every 200 ms
const checkInterval = setInterval(checkAndScrollToPosition, 200);


// Some debugging ( show informations such as window height and scroll position when any key pressed )
/* window.addEventListener('keydown', () => {
    // Get the current scroll position
    const scrollPosition = window.scrollY || document.documentElement.scrollTop;
    
    // Log the scroll position to the console
    console.log('Current Scroll Position:', scrollPosition);
    console.log('Current Window Height:', window.innerHeight);
    console.log('SUM:', scrollPosition + window.innerHeight);
}); */


window.addEventListener('scroll', () => {
    const scrollPosition = window.scrollY; // get the vertical scroll position
    localStorage.setItem('scrollPosition', scrollPosition);
    //console.log(localStorage.getItem('scrollPosition'));
});

// Store the search state in localStorage
function saveSearchState() {
    const filterType = document.getElementById('filterSelect').value;
    const searchTerm = document.getElementById('searchInput').value;
    let sortType = "";
    

    if(sortByButton.innerText.includes("Popularity"))
    {
        sortType = "Popularity";
    }
    else if (sortByButton.innerText.includes("abc"))
    {
        sortType = "abc";
    }
    else if (sortByButton.innerText.includes("zyx"))
    {
        sortType = "zyx";
    }



    const searchState = {
        filterType: filterType,
        searchTerm: searchTerm,
        sortType: sortType,
        selectedIngredients: selectedIngredients,
        selectedCategory: selectedCategory
    };

    localStorage.setItem('searchState', JSON.stringify(searchState));
}

// Load the search state from localStorage
function loadSearchState() {
    const savedState = JSON.parse(localStorage.getItem('searchState'));

    if (savedState) {
        const filterSelect = document.getElementById('filterSelect');
        filterSelect.value = savedState.filterType;

        const sortTypeValue = savedState.sortType;
        changeSortByButtonForSearchState(sortTypeValue);
        updateSearchUI();

        const searchInput = document.getElementById('searchInput');
        searchInput.value = savedState.searchTerm;

        selectedIngredients = savedState.selectedIngredients || [];
        selectedCategory = savedState.selectedCategory;

        // Display selected ingredients
        displaySelectedIngredients();

        // Trigger the saved search
        if (savedState.filterType === 'ingredient') {
            searchCocktailsByIngredients();
        } else if (savedState.filterType === 'category' && selectedCategory) {
            searchCocktailsByCategory(selectedCategory);
        } else {
            handleSearch();
        }
    }
}

// Call loadSearchState() on page load to restore previous search state
window.addEventListener('load', loadSearchState);

// Add click behavior to the search button
document.getElementById('searchBtn').addEventListener('click', function() {
    const filterType = document.getElementById('filterSelect').value;

    /* const tutorialBox = document.getElementById('slideshow-container');
    tutorialBox.style.display = 'none'; */

    if (filterType === 'ingredient') {
        searchCocktailsByIngredients();
    } else if (filterType === 'category') {
        searchCocktailsByCategory(selectedCategory);
    } else {
        handleSearch();  // For name search
    }
});

// Search when Enter key pressed
document.getElementById('searchInput').addEventListener('keydown', function(event) {
    if (event.key === 'Enter') {
        const filterType = document.getElementById('filterSelect').value;

        /* const tutorialBox = document.getElementById('slideshow-container');
        tutorialBox.style.display = 'none'; */

        if (filterType === 'ingredient') {
            searchCocktailsByIngredients();
        } else if (filterType === 'category') {
            searchCocktailsByCategory(selectedCategory);
        } else {
            handleSearch();  // For name search
        }
    }
});

// Update search user interface when the filter dropdown is changed
document.getElementById('filterSelect').addEventListener('change', function() {
    updateSearchUI();
});

// Sort behaviour
document.getElementById('sortByButton').addEventListener('click', function() {
    changeSortByButton();
    displayCocktails(allResults);
});

// Display the actual sorting and update when clicked
async function changeSortByButton() {
    sortByButton = document.getElementById('sortByButton');
    if(sortByButton.innerText.includes("Popularity"))
    {
        sortByButton.innerHTML = '<i id="sortIcon" class="fas fa-arrow-up"></i><i id="sortIcon" class="fas fa-arrow-down"></i> abc';
    }
    else if (sortByButton.innerText.includes("abc"))
    {
        sortByButton.innerHTML = '<i id="sortIcon" class="fas fa-arrow-up"></i><i id="sortIcon" class="fas fa-arrow-down"></i> zyx';
    }
    else if (sortByButton.innerText.includes("zyx"))
    {
        sortByButton.innerHTML = '<i id="sortIcon" class="fas fa-arrow-up"></i><i id="sortIcon" class="fas fa-arrow-down"></i> Popularity';
    }
}

// Update the page according to the local storage
async function changeSortByButtonForSearchState(savedSortType) {
    sortByButton = document.getElementById('sortByButton');
    if(savedSortType==="abc")
    {
        sortByButton.innerHTML = '<i id="sortIcon" class="fas fa-arrow-up"></i><i id="sortIcon" class="fas fa-arrow-down"></i> abc';
    }
    else if (savedSortType==="zyx")
    {
        sortByButton.innerHTML = '<i id="sortIcon" class="fas fa-arrow-up"></i><i id="sortIcon" class="fas fa-arrow-down"></i> zyx';
    }
    else if (savedSortType==="Popularity")
    {
        sortByButton.innerHTML = '<i id="sortIcon" class="fas fa-arrow-up"></i><i id="sortIcon" class="fas fa-arrow-down"></i> Popularity';
    }
}

// Function to update user interface (UI) based on the selected filter
function updateSearchUI() {
    const cocktailGrid = document.getElementById('cocktailGrid');
    cocktailGrid.innerHTML = '';

    const filterType = document.getElementById('filterSelect').value;
    const searchInput = document.getElementById('searchInput');
    const ingredientButtons = document.getElementById('ingredientButtons');
    const categoryButtons = document.getElementById('categoryButtons');
    const searchBtn = document.getElementById('searchBtn');
    /* const tutorialBox = document.getElementById('slideshow-container'); */

    /* tutorialBox.style.display = 'block'; */
    searchInput.value = "";
    // Show/hide elements based on filter type
    searchInput.style.display = !(filterType === 'category') ? 'block' : 'none';
    ingredientButtons.style.display = (filterType === 'ingredient') ? 'block' : 'none';
    searchInput.placeholder = (filterType === 'ingredient') ? "Search for an ingredient" : "Search for a cocktail";
    categoryButtons.style.display = (filterType === 'category') ? 'flex' : 'none';
    searchBtn.style.display = !(filterType === 'category') ? 'block' : 'none';
}


const searchInput = document.getElementById('searchInput');
const ingredientSearch = document.getElementById('ingredientSearch');

searchInput.addEventListener('focus', function() {
    // Show the recommendations when input is focused
    const filterType = document.getElementById('filterSelect').value;
    if(filterType === 'ingredient')
    {
        ingredientSearch.style.display = 'block';
    }
});

searchInput.addEventListener('blur', function() {
    // Hide the recommendations when input loses focus
    setTimeout(() => {
        ingredientSearch.style.display = 'none';
    }, 200); // Delay to allow click events on the recommendations
});



// Categories array
const categories = [
    'Cocktail',
    'Ordinary Drink',
    'Punch / Party Drink',
    'Shake',
    'Other / Unknown',
    'Cocoa',
    'Shot',
    'Coffee / Tea',
    'Homemade Liqueur',
    'Beer',
    'Soft Drink'
];

// Dynamically create category buttons
function createCategoryButtons() {
    const categoryButtonsDiv = document.getElementById('categoryButtons');
    categoryButtonsDiv.innerHTML = '';

    categories.forEach(category => {
        const button = document.createElement('button');
        button.textContent = category;
        button.classList.add('category-btn');
        button.addEventListener('click', function() {
            selectedCategory = category;
            searchCocktailsByCategory(category);
        });
        categoryButtonsDiv.appendChild(button);
    });
}

// Call this function to populate the category buttons
createCategoryButtons();


const categoryButtons = document.querySelectorAll('.category-btn');

categoryButtons.forEach(button => {
    button.addEventListener('click', function() {
        categoryButtons.forEach(btn => btn.classList.remove('active'));

        this.classList.add('active');
        // Store the active button's text content in local storage
        localStorage.setItem('activeCategory', this.textContent.trim());
    });
});

window.addEventListener('DOMContentLoaded', () => {
    // Retrieve the stored active button text content from local storage
    const activeCategory = localStorage.getItem('activeCategory');

    if (activeCategory) {
        // Find the button with matching text content and set it as active
        categoryButtons.forEach(button => {
            if (button.textContent.trim() === activeCategory) {
                button.classList.add('active');
            }
        });
    }
});




// Search function by category
async function searchCocktailsByCategory(category) {
    const apiUrl = `https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=${category}`;
    const dbResults = await searchDbByCategory(category); // Fetch results from the database

    /* const tutorialBox = document.getElementById('slideshow-container');
    tutorialBox.style.display = 'none'; */

    try {
        const response = await fetch(apiUrl);
        const data = await response.json();

        let apiCocktails = data.drinks || []; // Empty array if no drinks found

        // Combine and display results from both sources
        allResults = [...dbResults, ...apiCocktails];

        if (allResults.length > 0) {
            displayCocktails(allResults);
        } else {
            displayNoResults();
        }
    } catch (error) {
        console.error('Error fetching cocktails by category:', error);
    }
}

// Function to search the database by category
async function searchDbByCategory(category) {
    const response = await fetch("search.php", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({ type: "searchDbByCategory", category: category }),
    });

    const json = await response.json();

    if (json.status !== "empty"  && json.cocktails.length > 0) {
        return json.cocktails; // Return cocktails from the database
    }

    return []; // Return empty array if no results
}






// Search function by ingredients
async function searchCocktailsByIngredients() {
    if (selectedIngredients.length === 0) {
        alert('Please select at least one ingredient.');
        return;
    }

    const drinksMatrix = []; // Initialize a 2D array to hold drinks for each ingredient

    // Fetch results from the database
    const dbResults = await searchDbByIngredients(selectedIngredients);

    for (const ingredient of selectedIngredients) {
        const apiUrl = `https://www.thecocktaildb.com/api/json/v1/1/filter.php?i=${ingredient}`;

        try {
            const response = await fetch(apiUrl);
            const data = await response.json();

            if (Array.isArray(data.drinks)) { // Check if drinks is an array
                drinksMatrix.push(data.drinks); // Add the drinks to the matrix
            } else {
                console.warn(`No drinks found for ${ingredient}`);
                drinksMatrix.push([]); // If no drinks, push an empty array
            }
        } catch (error) {
            console.error(`Error fetching cocktails with ${ingredient}:`, error);
            drinksMatrix.push([]); // Push an empty array in case of error
        }
    }

    // Find drinks that are present in every row (ingredient)
    const commonDrinks = [];

    if (drinksMatrix.length > 0 && drinksMatrix[0].length > 0) {
        const firstRow = drinksMatrix[0];

        for (const drink of firstRow) {
            // Check if the drink is present in every other row
            const isCommon = drinksMatrix.every(row => row.some(d => d.idDrink === drink.idDrink));
            if (isCommon) {
                commonDrinks.push(drink); // Add to common drinks if present in all rows
            }
        }
    }

    // Combine database results with common API results
    allResults = [...dbResults, ...commonDrinks];

    if (allResults.length > 0) {
        displayCocktails(allResults);
    } else {
        displayNoResults();
    }
}




// Function Search by ingredients
async function searchDbByIngredients(ingredients) {
    try {
        const response = await fetch("search.php", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({ type: "searchDbByIngredients", ingredients }),
        });

        const text = await response.text(); 
        //console.log("Response:", text);

        const json = JSON.parse(text);
        //console.log("Parsed JSON:", json);

        if (json.status !== "empty" && Array.isArray(json.cocktails)) { // Check if cocktails is an array
            return json.cocktails;
        } else {
            console.warn('No cocktails found in database response');
        }
    } catch (error) {
        console.error('Error parsing JSON:', error);
    }
    
    return [];
}

// Search function to get cocktails from the API by name
async function handleApiSearch(searchTerm) {
    const url = `https://www.thecocktaildb.com/api/json/v1/1/search.php?s=${searchTerm}`;

    try {
        const response = await fetch(url);
        const data = await response.json();

        if (data.drinks) {
            return data.drinks; // Return the cocktails if found
        } else {
            return []; // Return an empty array if no cocktails found
        }
    } catch (error) {
        console.error('Error fetching cocktails from API:', error);
        return []; // Return an empty array on error
    }
}

// Handle the search for API and Database
async function handleSearch() {
    const searchTerm = document.getElementById('searchInput').value;

    // Search from the database
    const dbResults = await searchDbByName(searchTerm);
    // Fetch results from API as well
    const apiResults = await handleApiSearch(searchTerm); // Ensure this function is implemented similarly

    // Merge results and display
    allResults = [...dbResults, ...apiResults]; // Merge results from both sources


    if (allResults.length > 0) {
        displayCocktails(allResults);
    } else {
        displayNoResults();
    }
}


// Function to search cocktails by name
async function searchDbByName(query) {
    const response = await fetch("search.php", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({ type: "searchDbByName", search: query }),
    });

    const json = await response.json();
    
    if (json.status !== "empty"  && json.cocktails.length > 0) {
        return json.cocktails; // Return cocktails from the database
    }

    return []; // Return empty array if no results
}


// Function to display all cocktails (and sort them)
async function displayCocktails(cocktails) {

    saveSearchState();

    const cocktailGrid = document.getElementById('cocktailGrid');
    cocktailGrid.innerHTML = '';


    sortByButton = document.getElementById('sortByButton');

    if(sortByButton.innerText.includes("abc"))
    {
        // Sort the results alphabetically by cocktail name
        cocktails.sort((a, b) => {
            const nameA = a.strDrink.toLowerCase();
            const nameB = b.strDrink.toLowerCase();
            return nameA.localeCompare(nameB);
        });
    }
    else if(sortByButton.innerText.includes("zyx"))
    {
        cocktails.sort((a, b) => {
            const nameA = a.strDrink.toLowerCase();
            const nameB = b.strDrink.toLowerCase();
            return nameB.localeCompare(nameA);
        });
    }
    else if(sortByButton.innerText.includes("Popularity"))
    {
        // Here we have to get every grade and sort by grade
        let ratings = [];
        for (const cocktail of cocktails) {
            const cocktailData = await fetchCocktailData(cocktail.idDrink);
            let avgRating = cocktailData ? cocktailData.avgRating : null;
            ratings.push(avgRating);
        }

        // Combine cocktails with their ratings
        let cocktailsWithRatings = cocktails.map((cocktail, index) => ({
            cocktail,
            rating: ratings[index]
        }));

        // Sort by average rating (null values will come last)
        cocktailsWithRatings.sort((a, b) => {
            // Handle null ratings
            if (a.rating === null) return 1;
            if (b.rating === null) return -1; 
            return b.rating - a.rating; // Sort in descending order
        });

        // Extract sorted cocktails
        cocktails = cocktailsWithRatings.map(item => item.cocktail);
    }




    for (const cocktail of cocktails) {
        //console.log(cocktail);

        const div = document.createElement('div');
        div.classList.add('g_grid-item');

        // Fetch the average rating for this specific cocktail
        const cocktailData = await fetchCocktailData(cocktail.idDrink);
        let avgRating = cocktailData ? cocktailData.avgRating : null;

        // Display drink
        div.innerHTML = `
            <a href="recipes.php?idDrink=${encodeURIComponent(cocktail.idDrink)}">
                <img src="${cocktail.strDrinkThumb}" alt="${cocktail.strDrink}">
                <div class="g_cocktail-name-overlay">
                    <span>${cocktail.strDrink}</span>
                    <div class="ratings">
                        ${avgRating !== null ? `<p><icons class="bi-star-fill star"></icons> <p class="avgRating">${avgRating} / 5</p></p>` : `<p>Not Rated</p>`}
                    </div>
                </div>
            </a>
        `;

        cocktailGrid.appendChild(div); // Add the cocktail to the grid
    }
}

// Function to fetch cocktail data
function fetchCocktailData(idDrink) {
    return fetch(`getRating.php?idDrink=${encodeURIComponent(idDrink)}`)
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                return {
                    idDrink: data.idDrink,
                    avgRating: data.avgRating
                };
            } else {
                console.error('Error fetching rating:', data.error);
                return null;
            }
        })
        .catch(error => {
            console.error('Error fetching data:', error);
        });
}


// Function to display no results message
function displayNoResults() {
    const cocktailGrid = document.getElementById('cocktailGrid');
    cocktailGrid.innerHTML = '<p>No results found.</p>';
}



// Dynamically create ingredient buttons based on search input
document.getElementById('searchInput').addEventListener('input', async function() {
    const filterType = document.getElementById('filterSelect').value;

    if (filterType === 'ingredient') {
        const query = this.value.trim();
        if (query.length > 0) {
            await searchIngredients(query);
        } else {
            document.getElementById('ingredientSearch').innerHTML = '';
        }
    }
});

// AJAX function to search ingredients
async function searchIngredients(query) {
    fetch("search.php", {
    method: "POST",
    headers: {
    "Content-Type": "application/json"
    },
    body: JSON.stringify({ type: "searchIngredients", search: query }),
    })
    .then(response => response.json())
    .then(json => {
        const searchTerm = json.search_term;
        if(json.status != "empty" && json.ingredients.length>0)
        {
            let ingredientList = [];  // Initialize an empty array

            for (let i = 0; i < json.ingredients.length; i++) {
                let ingredient = json.ingredients[i];
                ingredientList.push(ingredient);  // Add each ingredient to the array
            }
            displayIngredientResults(ingredientList || []);
        }
        else
        {
            document.getElementById('ingredientSearch').innerHTML = "No Result ...";
        }
    })
    .catch(error => console.error("There was an error:", error));
} 


// Show the ingredients
function displayIngredientResults(ingredients) {
    const ingredientSearchDiv = document.getElementById('ingredientSearch');
    ingredientSearchDiv.innerHTML = '';  // Clear the previous results

    ingredients.forEach(ingredient => {
        const div = document.createElement('div');
        div.classList.add('ingredient-item');
        div.textContent = ingredient;  // Since ingredients is an array of strings

        // Add a click event to select the ingredient
        div.addEventListener('click', function() {
            addSelectedIngredient(ingredient);  // Use ingredient directly since it's a string
        });

        // Append the ingredient to the ingredientSearchDiv
        ingredientSearchDiv.appendChild(div);
    });
}


// Add selected ingredient to list
function addSelectedIngredient(ingredient) {
    if (!selectedIngredients.includes(ingredient)) {
        selectedIngredients.push(ingredient);
        displaySelectedIngredients();
    }
}

// Display selected ingredients with a remove button
function displaySelectedIngredients() {
    const ingredientButtonsDiv = document.getElementById('ingredientButtons');
    ingredientButtonsDiv.innerHTML = '';

    selectedIngredients.forEach(ingredient => {
        const button = document.createElement('button');
        button.classList.add("category-btn");
        button.textContent = ingredient;

        button.addEventListener('click', function() {
            selectedIngredients = selectedIngredients.filter(i => i !== ingredient);
            displaySelectedIngredients();
        });

        ingredientButtonsDiv.appendChild(button);
    });
}

// Removed feature for slide tutorials
/* let slideIndex = 0;

        function showSlides() {
            const slides = document.getElementsByClassName("slide");
            for (let i = 0; i < slides.length; i++) {
                slides[i].classList.remove('active');
            }
            slideIndex++;

            // If the slideIndex exceeds the number of slides, reset it to the first slide
            if (slideIndex >= slides.length) {
                slideIndex = 0;
            }
            slides[slideIndex].classList.add('active');
            setTimeout(showSlides, 4000); // 4000 milliseconds = 4 seconds
        }

        // Call the function to start the slideshow
        showSlides(); */
