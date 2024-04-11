<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: *");
include('conn.php');

// Récupération des données du formulaire, en les protégeant contre les attaques XSS
$nom = htmlspecialchars($_POST["nom"]);
$postnom = htmlspecialchars($_POST["postnom"]);
$prenom = htmlspecialchars($_POST["prenom"]);
$classe = htmlspecialchars($_POST["classe"]);
$motif = htmlspecialchars($_POST["MotifPaiement"]);
$montant = htmlspecialchars($_POST["montant"]);
$date = htmlspecialchars($_POST["DatePaiement"]);

// Requête SQL pour récupérer le matricule de l'élève en fonction des autres informations
$sql_matricule = "SELECT matricule FROM eleve WHERE nom='$nom' AND postnom='$postnom' AND prenom='$prenom' AND classe='$classe'";

$result_matricule = mysqli_query($connect, $sql_matricule);

if (mysqli_num_rows($result_matricule) > 0) {
    // Si un matricule correspondant est trouvé, insérer les données dans la table paiement
    $row = mysqli_fetch_assoc($result_matricule);
    $matricule = $row["matricule"];

    $sql_insert = "INSERT INTO paiement (matricule, nom, postnom, prenom, classe, MotifPaiement, montant, DatePaiement) 
    VALUES ('$matricule', '$nom', '$postnom', '$prenom', '$classe', '$motif', '$montant', '$date')";

    if (mysqli_query($connect, $sql_insert)) {
        echo json_encode("success");
    } else {
        echo json_encode("failed");
    }
} else {
    // Si aucun matricule correspondant n'est trouvé, renvoyer une erreur
    echo json_encode("No matching matricule found for the provided information");
}

?>