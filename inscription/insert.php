<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: *");
include('conn.php');

// Récupération des données du formulaire, en les protégeant contre les attaques XSS
$email = htmlspecialchars($_POST["email"]);
$password = htmlspecialchars($_POST["passwords"]);


// Requête SQL pour insérer les données dans la table 'user'
$sql = "INSERT INTO user (email,passwords) VALUES ('$email','$password')";

if(mysqli_query($connect, $sql)){
    echo json_encode("success");
}else{
    echo json_encode("failed");
}
// Exécution de la requête SQL

?>