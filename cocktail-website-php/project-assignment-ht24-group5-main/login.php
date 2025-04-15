<?php 
    session_start();

    // Initialize variables for error and success messages
    $loginError = $loginSuccess = $signupError = $signupSuccess = null;
    $showSignupForm = false; // Variable to control form display

    // Connect to the database
    $db = new mysqli("localhost", "root", null, "project_db");
    if ($db->connect_error) {
        die("Connection failed: " . $db->connect_error);
    }

    // Handle Login
    if (isset($_POST['signin'])) { 
        $username = $_POST['username'];
        $password = hash("sha3-256", $_POST["password"]);
        $connected = false;

        // Query to get the user details including idUser
        $usersTable = $db->query("SELECT idUser, password FROM users WHERE username = '$username';");

        while($row = $usersTable->fetch_assoc()) {
            if($row["password"] === $password) {
                $connected = true;
                $idUser = $row["idUser"]; // Get the user ID
            }
        }
        $db->close();

        if ($connected === true) {
            // Store the user ID in the session along with signed_in status
            $_SESSION['signed_in'] = true;
            $_SESSION['idUser'] = $idUser; // Store idUser in session

            $loginSuccess = "Login successful! Redirecting...";
            echo "<script>window.location.href = 'homePage.php';</script>";
            exit();
        } else {
            $loginError = "Wrong Username or Password. Please try again.";
        }
    }

    // Handle Sign Up
    if (isset($_POST['signup'])) { 
        $usernameIn = $_POST['signup-username'];
        $passwordIn = $_POST['signup-password'];
        $confirmPassword = $_POST['signup-confirm-password'];

        // Check if the username already exists
        $stmtCheck = $db->prepare("SELECT idUser FROM users WHERE username = ?");
        $stmtCheck->bind_param("s", $usernameIn);
        $stmtCheck->execute();
        $stmtCheck->store_result();

        if ($stmtCheck->num_rows > 0) {
            $signupError = "This username already exists. Please choose another one.";
            $showSignupForm = true;
        }
        else if ($passwordIn === $confirmPassword) {
            $passwordHash = hash("sha3-256", $passwordIn);

            $stmtIn = $db->prepare("INSERT INTO `users`(`username`, `password`) VALUES (?,?)");
            $stmtIn->bind_param("ss", $usernameIn, $passwordHash);

            if ($stmtIn->execute()) {
                $signupSuccess = "Account created successfully! You can now log in.";
            } else {
                $signupError = "Error creating account. Please try again.";
            }
            $stmtIn->close();
        } else {
            $signupError = "Passwords do not match. Please try again.";
            $showSignupForm = true;
        }

        $db->close();
    }
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Login</title>
    <link rel="stylesheet" href="login.css">
    <link rel="stylesheet" href="aglobal.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body class="g_gradient">


    <a href="homePage.php">
        <button class="home-button">
            <i class="fas fa-home"></i> Home
        </button>
    </a>


    <div class="login-signup-container">
        <!-- Login Form -->
        <div class="login-form" id="loginForm">
            <h2>Login</h2>
            <form method="POST" action="">
                <div class="form-group">
                    <label for="login-username">Username</label>
                    <input type="text" id="login-username" class="login-input" name="username" placeholder="Username" required>
                </div>
                <div class="form-group">
                    <label for="login-password">Password</label>
                    <input type="password" id="login-password" class="login-input" name="password" placeholder="Password" required>
                </div>
                <!-- Error/Success message for login -->
                <?php if ($loginError) { ?>
                    <p style="color: red;"><?php echo $loginError; ?></p>
                <?php } elseif ($loginSuccess) { ?>
                    <p style="color: green;"><?php echo $loginSuccess; ?></p>
                <?php } ?>
                <button type="submit" class="login-btn" name="signin">Log In</button>
            </form>
            <p class="signup-text">Don't have an account? <span id="showSignup">Sign Up</span></p>
        </div>

        <!-- Sign-Up Form -->
        <div class="signup-form hidden" id="signupForm">
            <h2>Create Account</h2>
            <form method="POST" action="">
                <div class="form-group">
                    <label for="signup-username">Username</label>
                    <input type="text" id="signup-username" class="login-input" name="signup-username" placeholder="Create username" required>
                </div>
                <div class="form-group">
                    <label for="signup-password">Password</label>
                    <input type="password" id="signup-password" class="login-input" name="signup-password" placeholder="Create password" required>
                </div>
                <div class="form-group">
                    <label for="signup-confirm-password">Confirm Password</label>
                    <input type="password" id="signup-confirm-password" class="login-input" name="signup-confirm-password" placeholder="Confirm password" required>
                </div>
                <!-- Error/Success message for sign up -->
                <?php if ($signupError) { ?>
                    <p style="color: red;"><?php echo $signupError; ?></p>
                <?php } elseif ($signupSuccess) { ?>
                    <p style="color: green;"><?php echo $signupSuccess; ?></p>
                <?php } ?>
                <button type="submit" class="signup-btn" name="signup">Sign Up</button>
            </form>
        </div>
    </div>
    <script src="login.js"></script>
    <script>
        // Check if signup form should be shown
        <?php if ($showSignupForm) { ?>
            document.getElementById('signupForm').classList.remove('hidden');
            document.getElementById('loginForm').classList.add('hidden');
        <?php } ?>

        // Toggle between login and signup forms
        document.getElementById("showSignup").addEventListener("click", function() {
            document.getElementById("signupForm").classList.remove("hidden");
            document.getElementById("loginForm").classList.add("hidden");
        });
    </script>
</body>
</html>
