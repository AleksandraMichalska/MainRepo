let currentIndex = 0;
const totalItems = 6;
const visibleItems = 4;
let animationInterval;

// Function to show the current slide
function showSlide(index) {
    const carousel = document.querySelector('.carousel');;
    const offset = -index * 22;
    carousel.style.transform = `translateX(${offset}%)`;
}

// Function to animate the carousel
function startCarouselAnimation() {
    animationInterval = setInterval(() => {
        if (currentIndex < totalItems - visibleItems) {
            currentIndex++;
        } else {
            currentIndex = 0; // Loop back
        }
        showSlide(currentIndex);
    }, 3000); // Speed of animation
}

// Start animation when page loads
window.onload = function () {
    fetchCocktails(); // Make sure this fetches and loads items
    showSlide(currentIndex); // Initially show the first slide
    // Set up the animation after the items are fetched and appended
};

const carouselContainer = document.querySelector('.carousel');

// Function to get 6 unique random cocktails from the API
async function fetchCocktails() {
    try {
        // Clear existing cocktails to avoid duplicates
        carouselContainer.innerHTML = '';

        const cocktails = [];
        const drinkIds = new Set();

        // Loop to get 6 unique random cocktails
        while (cocktails.length < 6) {
            const response = await fetch('https://www.thecocktaildb.com/api/json/v1/1/random.php');
            const data = await response.json();
            const cocktail = data.drinks[0];

            // Ensure no duplicate drinks
            if (!drinkIds.has(cocktail.idDrink)) {
                drinkIds.add(cocktail.idDrink);
                cocktails.push(cocktail);
            }
        }

        // Generate the carousel items
        for (const cocktail of cocktails) {
            // Fetch the average rating for this specific cocktail
            const cocktailData = await fetchCocktailData(cocktail.idDrink);
            let avgRating = cocktailData ? cocktailData.avgRating : null;

            const cocktailElement = document.createElement('div');
            cocktailElement.classList.add('grid-item');

            cocktailElement.innerHTML = `
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
            carouselContainer.appendChild(cocktailElement);
        }

        // Start the animation after the items are loaded
        startCarouselAnimation();

    } catch (error) {
        console.error("Error fetching cocktails: ", error);
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