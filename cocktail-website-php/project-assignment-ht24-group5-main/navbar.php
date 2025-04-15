<?php 
    if (session_status() == PHP_SESSION_NONE) {
        session_start();
    }
    $idUser = "";
    $isLoggedIn = false; // Variable to track login status
    if (isset($_SESSION["idUser"])) {
        $idUser = $_SESSION["idUser"];
        $isLoggedIn = true; // Mark as logged in
    }
?>

<head>
    <link rel="stylesheet" href="navbar.css">
    <link rel="stylesheet" href="aglobal.css">
</head>

<nav class="navbar">
    <!--<?php echo $idUser; // Display user ID or empty string if not logged in ?>-->
    <img src="Logo.png" alt="Logo" class="logo">

    <ul class="nav-links">
        <li><a href="homePage.php">Home</a></li>
        <li><a href="search.php?newSearch=true">Search</a></li>
        <li><a href="profile.php">Profile</a></li>
    </ul>

    <!-- display Log In or Log Out button -->
    <?php if ($isLoggedIn): ?>
        <!-- Log Out button if logged in -->
        <a href="logout.php">
            <button class="login-btn">Log Out</button>
        </a>
    <?php else: ?>
        <!-- Log In button if not logged in -->
        <a href="login.php">
            <button class="login-btn">Log In</button>
        </a>
    <?php endif; ?>
</nav>