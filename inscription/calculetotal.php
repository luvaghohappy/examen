<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: *");
// Inclusion du fichier connect.php qui contient la connexion à la base de données
include('conn.php');

// Requête SQL pour sélectionner toutes les lignes de la table 'user'
$rqt = "SELECT montant FROM caisse";

// Exécution de la requête SQL
$rqt2 = mysqli_query($connect, $rqt) OR die("Erreur d'exécution de la requête : " . mysqli_error($connect));

// Initialisation d'une variable pour stocker le total des montants
$totalMontant = 0;

// Parcours des résultats de la requête et calcul du total des montants
while ($fetchData = $rqt2->fetch_assoc()) {
    $totalMontant += $fetchData['montant'];
}

// Affichage du total des montants au format JSON
echo json_encode(['total' => $totalMontant]);
?>