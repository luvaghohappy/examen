<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: *");
// Inclusion du fichier connect.php qui contient la connexion à la base de données
include('conn.php');

// Point de terminaison pour récupérer les données de la table paiement et les insérer dans la table caisse
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // Requête SQL pour sélectionner les champs 'matricule', 'montant' et 'DatePaiement' de la table 'paiement'
    $select_query = "SELECT matricule, montant, DatePaiement FROM paiement";

    // Exécution de la requête SQL
    $select_result = mysqli_query($connect, $select_query) or die("Erreur d'exécution de la requête : " . mysqli_error($connect));

    // Initialisation d'un tableau pour stocker les résultats de la requête
    $result = array();

    // Parcours des résultats de la requête et insertion dans le tableau résultat
    while ($row = mysqli_fetch_assoc($select_result)) {
        // Récupération des données de chaque ligne
        $matricule = $row['matricule'];
        $montant = $row['montant'];
        $datePaiement = $row['DatePaiement'];

        // Ajouter les données au tableau résultat
        $result[] = array(
            'matricule' => $matricule,
            'montant' => $montant,
            'DatePaiement' => $datePaiement 
        );
    }

    // Conversion du tableau en format JSON et affichage
    echo json_encode($result);
}
?>