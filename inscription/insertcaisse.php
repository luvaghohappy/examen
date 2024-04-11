<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");
// Inclusion du fichier connect.php qui contient la connexion à la base de données
include('conn.php');

// Vérifier si la méthode de la requête est POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Récupérer les données envoyées depuis l'application Flutter
    $data = json_decode(file_get_contents("php://input"), true);
    $matricule = $data['matricule'];
    $montant = $data['montant'];
    $date = $data['DatePaiement']; // Assurez-vous que le nom correspond à celui envoyé depuis Flutter

    // Requête SQL pour insérer les données dans la table 'caisse'
    $insert_query = "INSERT INTO caisse (matricule, montant, DateCaisse) VALUES ('$matricule','$montant', '$date')";

    // Exécution de la requête SQL d'insertion
    $insert_result = mysqli_query($connect, $insert_query);

    // Vérifier si l'insertion s'est bien déroulée
    if ($insert_result) {
        echo json_encode(array("message" => "Données insérées avec succès dans la table caisse"));
    } else {
        echo json_encode(array("message" => "Erreur lors de l'insertion des données dans la table caisse: " . mysqli_error($connect)));
    }
    exit(); // arrêter l'exécution du script après le traitement des données
} else {
    // Si la méthode de la requête n'est pas POST, renvoyer une erreur
    echo json_encode(array("message" => "Méthode non autorisée. Utilisez la méthode POST."));
    exit();
}
?>