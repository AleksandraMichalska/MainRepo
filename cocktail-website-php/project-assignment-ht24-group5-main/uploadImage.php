<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Check, if the file was uploaded
    if (isset($_FILES['image'])) {
        $target_dir = "cocktailPictures/";
        $original_file_name = pathinfo($_FILES["image"]["name"], PATHINFO_FILENAME);
        $imageFileType = strtolower(pathinfo($_FILES["image"]["name"], PATHINFO_EXTENSION));
        $uploadOk = 1;

        //find a unique file name if necessary
        $i = 1;
        $new_file_name = $original_file_name;
        while (file_exists($target_dir . $new_file_name . "." . $imageFileType)) {
            $new_file_name = $original_file_name . "_" . $i;
            $i++;
        }
        $target_file = $target_dir . $new_file_name . "." . $imageFileType;

        // Check, whether the file is an image
        $check = getimagesize($_FILES["image"]["tmp_name"]);
        if($check !== false) {
            if($imageFileType != "jpg" && $imageFileType != "png" && $imageFileType != "jpeg" && $imageFileType != "gif" ) {
                echo "ERROR: Only files with JPG, JPEG, PNG and GIF are allowed.";
                $uploadOk = 0;
            }

            // If everything is ok, save the file
            if ($uploadOk && move_uploaded_file($_FILES["image"]["tmp_name"], $target_file)) {
                echo $target_file;
                // saveImagePathToDatabase($target_file);
            } else {
                echo "ERROR: An error occured while uploading the image.";
            }
        } else {
            echo "ERROR: File is not an image.";
        }
    } else {
        echo "ERROR: No uploaded image.";
    }

    function findUniqueFileName($dir, $file_name, $extension) {
        $i = 1;
        $new_file_name = $file_name;
        
        while (file_exists($dir . $new_file_name . "." . $extension)) {
            $new_file_name = $file_name . "_" . $i;
            $i++;
        }
        
        return $dir . $new_file_name . "." . $extension;
    }
}
?>