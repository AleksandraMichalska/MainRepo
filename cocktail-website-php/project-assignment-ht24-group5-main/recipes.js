 //------------------ Butoms -----------------------//
 function addFunction() {
    alert("Add button clicked");
}

function editFunction() {
    alert("Edit button clicked");
}

function deleteFunction() {
    alert("Delete button clicked");
}


//------------------starts effects-----------------------//
const stars = document.querySelectorAll('.star');
let currentRating = 0; 

// Events for each star for the left-to-right hover effect
stars.forEach((star, index) => {
    // Event when mouse enters
    star.addEventListener('mouseenter', () => {
        for (let i = 0; i <= index; i++) {
            stars[i].classList.add('hovered');
        }
    });

    // Event when mouse leaves
    star.addEventListener('mouseleave', () => {
        stars.forEach(star => star.classList.remove('hovered'));
    });
});


stars.forEach(function(star, index) {
    star.addEventListener('click', function() {
        // Check if the user is logged in
        if (isLoggedIn === false) { // Use the actual boolean value, not a string
            alert("You need to log in.");

            // Remove the 'checked' class from all stars if the user is not logged in
            stars.forEach(star => {
                star.classList.remove('checked');
            });

            return; // If not logged in, do nothing else
        }

        // If the user is logged in, proceed with star rating change
        if (index === 0) {
            if (currentRating === 1) {
                // If star #1 was already marked as 1, uncheck it
                star.classList.remove('checked');
                sendRating(0); // Send 0 to clear the rating
                currentRating = 0; // Reset current rating
            } else {
                // If star #1 wasn't checked, check it
                star.classList.add('checked');
                sendRating(1); // Send 1 when clicking on star #1
                currentRating = 1; // Update current rating
            }
        } else {
            // For stars greater than the first
            if (star.classList.contains('checked')) {
                // If clicking on a star already selected, uncheck the following stars
                for (let i = index + 1; i < stars.length; i++) {
                    stars[i].classList.remove('checked');
                }
            } else {
                // Check the clicked star and all previous stars
                for (let i = 0; i <= index; i++) {
                    stars[i].classList.add('checked');
                }
            }
            // Update current rating and send it
            currentRating = document.querySelectorAll('.star.checked').length;
            sendRating(currentRating);
        }
    });
});

// Function to send the rating to the database
function sendRating(rating) {
    fetch('store_rating.php', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            idDrink: idDrink,
            idUser: idUser,
            rating: rating
        })
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            console.log('Rating stored successfully');
            updateStarDisplay(rating); // Update star display
        } else {
            console.error('Error storing the rating');
        }
    })
    .catch(error => {
        console.error('Request error:', error);
    });
}

// Function to update the star display
function updateStarDisplay(rating) {
    stars.forEach((star, index) => {
        if (index < rating) {
            star.classList.add('checked'); 
        } else {
            star.classList.remove('checked'); 
        }
    });
}

//------------------ Comments effects with buttons -----------------------//
let selectedComment = null;
let isAdding = false;
let selectedCommentId = null;
let isEditing = false;
let editingComment = null;

// Function to add a comment
document.getElementById('add-btn').addEventListener('click', function() {
    if (!isLoggedIn) {
        alert("You need to log in");
        return;
    }

    if (isAdding || isEditing) return; // Avoid conflict between adding and editing
    isAdding = true;

    // Edit and delete buttons are disabled when adding a comment
    document.getElementById('edit-btn').disabled = true;
    document.getElementById('delete-btn').disabled = true;

    let commentInput = document.createElement('textarea');
    commentInput.placeholder = "Write your comment and press Enter";
    commentInput.className = 'add-input';
    commentInput.style.width = "100%";
    commentInput.style.height = "50px";
    commentInput.style.margin = "5px";
    commentInput.style.padding = "10px";
    commentInput.style.borderRadius = "5px";
    commentInput.style.border = "1px solid #ccc";
    commentInput.style.fontSize = "2vw";
    commentInput.style.resize = "none";

    document.getElementById('coments-box2').appendChild(commentInput);
    commentInput.focus();

    // Disable selection of other comments
    disableCommentSelection(true);

    // Event to handle Enter in the comment input field
    commentInput.addEventListener('keydown', function(event) {
        if (event.key === "Enter") {
            event.preventDefault();
            let commentText = commentInput.value.trim();

            if (commentText) {
                // Send the comment to the server
                let xhr = new XMLHttpRequest();
                xhr.open("POST", "add_comment.php", true);

                let formData = new FormData();
                formData.append("comment", commentText);
                formData.append("idDrink", idDrink);
                formData.append("userId", idUser); 

                xhr.onload = function() {
                    if (xhr.status === 200) {
                        let response = JSON.parse(xhr.responseText);
                        if (response.success) {
                            // Create the comment in the frontend
                            let comment = document.createElement('div');
                            comment.className = 'comment';
                            comment.dataset.id = response.idComment; // Assign ID
                            comment.dataset.userId = response.userId; // Assign ID

                            // The effect is added when creating a comment
                            if (response.userId === idUser) {
                                comment.style.backgroundColor = "#d1e7ff"; // sky blue
                            }

                            comment.innerHTML = `\
                                <strong>${response.username}:</strong> ${commentText}\
                                <br><span class="comment-date" style="font-size: 1vw; color: #555;">Posted on: ${response.date}</span>`;
                            
                            document.getElementById('coments-box2').appendChild(comment);
                            commentInput.remove(); // Delete input field
                            isAdding = false;

                            // Restore comment selection
                            disableCommentSelection(false);
                            addClickEventToComment(comment); // Added event to allow selection

                            // Edit and delete buttons are re-enabled after adding comment
                            document.getElementById('edit-btn').disabled = false;
                            document.getElementById('delete-btn').disabled = false;
                        } else {
                            alert("Error adding comment: " + response.error);
                            isAdding = false;

                            // Edit and delete buttons are re-enabled after adding comment
                            document.getElementById('edit-btn').disabled = false;
                            document.getElementById('delete-btn').disabled = false;
                        }
                    } else {
                        alert("Error connecting to server.");
                        isAdding = false;

                        // Edit and delete buttons are re-enabled after adding comment
                        document.getElementById('edit-btn').disabled = false;
                        document.getElementById('delete-btn').disabled = false;
                    }
                };

                xhr.onerror = function() {
                    alert("Request failed. Please try again.");
                    isAdding = false;

                    // Edit and delete buttons are re-enabled after adding comment
                    document.getElementById('edit-btn').disabled = false;
                    document.getElementById('delete-btn').disabled = false;
                };

                xhr.send(formData);
            } else {
                alert("Comment cannot be empty.");
            }
        } else if (event.key === "Escape") {
            // 'ESC' to cancel the creation of any comment.
            commentInput.remove();
            isAdding = false;
            disableCommentSelection(false); // enables selection of a comment.

            // Edit and delete buttons are re-enabled after adding comment
            document.getElementById('edit-btn').disabled = false;
            document.getElementById('delete-btn').disabled = false;
        }
    });
});


// Function to disable or enable selection of comments
function disableCommentSelection(disable) {
    const comments = document.querySelectorAll('.comment');
    comments.forEach(comment => {
        if (disable) {
            comment.classList.add('disabled'); // add class to disable selection
            comment.style.pointerEvents = "none"; 
        } else {
            comment.classList.remove('disabled'); // Remove class to enable selection
            comment.style.pointerEvents = ""; 
        }
    });
}

// Function to add the click event to a comment
function addClickEventToComment(comment) {
    comment.addEventListener('click', function() {
        if (isAdding) return; // Avoid selection if adding a comment

        const commentOwnerId = comment.dataset.userId; 
        console.log("commentOwnerId:", commentOwnerId, "idUser:", idUser); 

        // Check if the logged in user is the owner of the comment
        if (String(commentOwnerId) === String(idUser)) { 
            if (selectedComment === comment) {
                comment.classList.remove('highlight'); 
                selectedComment = null; 
                selectedCommentId = null; 
            } else {
                if (selectedComment) {
                    selectedComment.classList.remove('highlight');
                }
                comment.classList.add('highlight'); 
                selectedComment = comment; 
                selectedCommentId = comment.dataset.id; 
            }
        } else {
            console.log("You cannot select this comment.");
        }
    });
}

// Function to reset selected comment variables
function resetSelectedComment() {
    if (selectedComment) {
        selectedComment.classList.remove('highlight');
    }
    selectedComment = null;
    selectedCommentId = null;
}

// function to display comments from the database.
function loadComments() {
    console.log('Loading comments for idDrink:', idDrink);
    resetSelectedComment(); 

    fetch('get_comments.php?idDrink=' + idDrink)
        .then(response => {
            if (!response.ok) {
                throw new Error('The network response was not satisfactory: ' + response.statusText);
            }
            return response.json();
        })
        .then(data => {
            console.log("Comments data:", data); 
            document.getElementById('coments-box2').innerHTML = ''; 
            if (data.comments) {
                data.comments.forEach(commentData => {
                    console.log(commentData); 
                    let comment = document.createElement('div');
                    comment.className = 'comment';
                    comment.dataset.id = commentData.idComment;
                    comment.dataset.userId = commentData.userId; 

                     // We check if the comment is from the owner
                     if (String(commentData.userId) === String(idUser)) {
                        comment.setAttribute('data-user-id', commentData.userId); // data-user-id is set if this is the owner's comment.
                        comment.style.backgroundColor = "#d1e7ff"; // sky blue
                    }

                    comment.innerHTML = `\
                        <strong>${commentData.username}:</strong> ${commentData.text}
                        <br>
                        <span class="comment-date" style="color: #555;">Posted on: ${commentData.date}</span>`;
                    
                    document.getElementById('coments-box2').appendChild(comment);
                    addClickEventToComment(comment); 
                });
            } else {
                console.error("Error loading comments:", data.error);
            }
        })
        .catch(error => console.error('Error loading comments:', error));
}


// Load comments on start
loadComments();

// Function to reset the state of the events and variables
function resetCommentInputListeners() {
    console.log("Resetting comment input listeners"); // Log for tracking
    isAdding = false;
    isEditing = false;
    selectedComment = null;
    selectedCommentId = null;
}

// Event for the edit button
document.getElementById('edit-btn').addEventListener('click', function() {
    if (!isLoggedIn) { // Check if the user is logged in
        alert("You need to log in");
        return;
    }

    if (selectedComment && selectedCommentId && !isAdding) {
        if (isEditing) return; // Avoid multiple simultaneous edits
        isEditing = true;

        // Delete button is disabled during editing
        document.getElementById('delete-btn').disabled = true;

        let originalCommentText = selectedComment.querySelector('strong').nextSibling ? 
            selectedComment.querySelector('strong').nextSibling.textContent.trim() : '';
        
        let commentDate = selectedComment.querySelector('.comment-date') ? 
            selectedComment.querySelector('.comment-date').innerHTML : '';

        // Create text area for editing
        let editInput = document.createElement('textarea');
        editInput.value = originalCommentText;
        editInput.className = 'edit-input';
        editInput.style.width = "100%";
        editInput.style.height = "50px";
        editInput.style.margin = "5px";
        editInput.style.padding = "10px";
        editInput.style.borderRadius = "5px";
        editInput.style.border = "1px solid #ccc";
        editInput.style.fontSize = "2vw";
        editInput.style.resize = "none";

        selectedComment.parentNode.replaceChild(editInput, selectedComment); 
        editInput.focus();

        // Disable selection of other comments
        disableCommentSelection(true);

        // Event to confirm with Enter
        editInput.addEventListener('keydown', function(event) {
            if (event.key === "Enter") {
                event.preventDefault();

                let newCommentText = editInput.value.trim();
                if (newCommentText) {
                    // Send the edited comment to the server
                    fetch('edit_comment.php', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: `comment=${encodeURIComponent(newCommentText)}&idComment=${encodeURIComponent(selectedCommentId)}`
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            // Update the comment on the frontend
                            const updatedComment = document.createElement('div');
                            updatedComment.className = 'comment';
                            updatedComment.dataset.id = selectedCommentId;
                            updatedComment.dataset.userId = data.idUser;
                            
                            updatedComment.innerHTML = `<strong>${selectedComment.querySelector('strong').textContent}</strong> ${newCommentText}
                            <br><span class="comment-date" style="color: #555;">${commentDate}</span>`;

                            // effect on edited comments
                            updatedComment.style.backgroundColor = "#d1e7ff"; // sky blue for edited comment

                            editInput.parentNode.replaceChild(updatedComment, editInput);

                            // Restore selection of comments and events
                            disableCommentSelection(false);
                            addClickEventToComment(updatedComment);
                            isEditing = false;

                            // Enable the delete button after editing
                            document.getElementById('delete-btn').disabled = false;
                        } else {
                            console.error("Error in the backend when editing comment:", data.error);
                            isEditing = false;
                            document.getElementById('delete-btn').disabled = false;
                        }
                    })
                    .catch(error => {
                        console.error('Error sending comment update to backend:', error);
                        isEditing = false;
                        document.getElementById('delete-btn').disabled = false;
                    });
                } else {
                    alert("Comment cannot be empty.");
                }
            }
        });

        // Event to cancel with Escape
        editInput.addEventListener('keydown', function(event) {
            if (event.key === "Escape") {
                // Restore original comment
                editInput.parentNode.replaceChild(selectedComment, editInput);
                disableCommentSelection(false); 
                isEditing = false;

                // Delete button is enabled after cancel
                document.getElementById('delete-btn').disabled = false;
            }
        });

        // Accidental closure is prevented if clicked on the outside
        editInput.addEventListener('blur', function() {
            setTimeout(() => {
                if (isEditing) {
                    // Do not close or print errors if clicked outside
                    editInput.focus();
                }
            }, 0);
        });
    } else {
        alert("Select a comment to edit.");
    }
});



// Function to delete comments
document.getElementById('delete-btn').addEventListener('click', function() {
    if (!isLoggedIn) { // Check if the user is logged in
        alert("You need to log in");
        return;
    }

    if (selectedComment) {
        const idComment = selectedComment.dataset.id; // Get the idComment of the selected comment

        // Confirm deletion
        if (confirm("Are you sure you want to delete it?")) {
            fetch('delet_comment.php', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `idComment=${encodeURIComponent(idComment)}` // Send idComment to the server
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    selectedComment.remove(); // Remove the comment from the frontend
                    selectedComment = null; // Reset selection
                } else {
                    alert("Error deleting comment: " + data.error);
                }
            })
            .catch(error => console.error('Error deleting comment:', error));
        }
    } else {
        alert("Select a comment to delete.");
    }
});





    
