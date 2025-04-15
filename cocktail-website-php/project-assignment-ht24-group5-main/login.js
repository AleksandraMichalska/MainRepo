document.getElementById('showSignup').addEventListener('click', function() {
    // Hide login form and show signup form
    document.querySelector('.login-form').classList.add('hidden');
    document.getElementById('signupForm').classList.remove('hidden');
});
