<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: *");
include('conn.php'); // Inclure la connexion à la base de données

// Récupérer le matricule de l'élève envoyé depuis l'application Flutter
$studentMatricule = $_GET['matricule'];

// Requête SQL pour sélectionner toutes les colonnes de la table eleve pour un élève spécifique
$sql = "SELECT * FROM eleve WHERE matricule = '$studentMatricule'";

$result = mysqli_query($connect, $sql); // Exécuter la requête

if ($result === false) {
    // En cas d'erreur dans la requête, retourner le message d'erreur
    echo json_encode("Erreur: " . mysqli_error($connect));
} else {
    if (mysqli_num_rows($result) > 0) {
        // S'il y a des lignes retournées, récupérer les données et les retourner au format JSON
        $response = mysqli_fetch_assoc($result);
        echo json_encode($response);
    } else {
        // Si aucune donnée n'est trouvée pour l'élève spécifié, retourner un message indiquant cela
        echo json_encode("Aucune donnée trouvée");
    }
}

mysqli_close($connect); // Fermer la connexion à la base de données
?>