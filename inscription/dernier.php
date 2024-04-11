<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: *");
include('conn.php');

// Récupérer le dernier enregistrement de la table 'identification'
$sql = "SELECT * FROM identification ORDER BY id DESC LIMIT 1";
$result = mysqli_query($connect, $sql);

if(mysqli_num_rows($result) > 0){
    // Convertir le résultat en un tableau associatif
    $row = mysqli_fetch_assoc($result);
    // Envoyer les données JSON en réponse
    echo json_encode($row);
} else {
    echo json_encode("Aucun enregistrement trouvé");
}
?>