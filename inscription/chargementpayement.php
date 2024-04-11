<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: *");
// Inclusion du fichier connect.php qui contient la connexion à la base de données
include('conn.php');

// Vérification si la classe est envoyée par POST
if(isset($_POST['classe'])) {
    // Nettoyage de la classe pour éviter les injections SQL (vous pouvez utiliser mysqli_real_escape_string ou prepared statements pour une sécurité supplémentaire)
    $classe = mysqli_real_escape_string($connect, $_POST['classe']);
    
    // Requête SQL pour sélectionner les lignes de la table 'paiement' correspondant à la classe spécifiée
    $rqt = "SELECT paiement.*
            FROM paiement
            INNER JOIN classe ON paiement.classe = classe.designation
            WHERE classe.designation = '$classe'
            ORDER BY paiement.id DESC";
    
    // Exécution de la requête SQL
    $rqt2 = mysqli_query($connect, $rqt) OR die("Erreur d'exécution de la requête : " . mysqli_error($connect));
    
    // Initialisation d'un tableau pour stocker les résultats de la requête
    $result = array();
    
    // Parcours des résultats de la requête et stockage dans le tableau $result
    while ($fetchData = mysqli_fetch_assoc($rqt2)) {
        $result[] = $fetchData;
    }
    
    // Renvoi des données au format JSON
    header('Content-Type: application/json');
    echo json_encode($result);
} else {
    // Si aucune classe n'est spécifiée, renvoie une réponse JSON vide
    echo json_encode(array());
}
?>