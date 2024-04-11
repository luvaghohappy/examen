<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: *");
include('conn.php');

// Récupération des données du formulaire, en les protégeant contre les attaques XSS
$design = htmlspecialchars($_POST["designation"]);
$section = htmlspecialchars($_POST["section"]);
$options = htmlspecialchars($_POST["options"]);


// Requête SQL pour insérer les données dans la table 'classe'
$sql = "INSERT INTO classe (designation,section,options) VALUES ('$design','$section','$options')";

if(mysqli_query($connect, $sql)){
    echo json_encode("success");
}else{
    echo json_encode("failed");
}
// Exécution de la requête SQL

?>