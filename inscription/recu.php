<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: *");
include('conn.php'); // Inclusion de la connexion à la base de données

// Vérifier si les clés 'matricule' et 'DatePaiement' sont définies dans la requête
if(isset($_GET['matricule']) && isset($_GET['DatePaiement'])){
    // Si les clés sont définies, les récupérer
    $studentMatricule = $_GET['matricule'];
    $paymentDate = $_GET['DatePaiement'];

    // Requête SQL pour récupérer les informations sur le paiement effectué par l'étudiant spécifié à la date spécifiée
    $sql = "SELECT 
                paiement.matricule,
                paiement.nom,
                paiement.postnom,
                paiement.prenom,
                paiement.classe,
                paiement.MotifPaiement,
                paiement.montant,
                paiement.DatePaiement,
                classe.options,
                classe.section,
                solde.somme
            FROM 
                paiement
            INNER JOIN 
                classe
            ON 
                paiement.classe = classe.designation
            INNER JOIN 
                solde
            ON 
                paiement.matricule = solde.matricule
            WHERE
                paiement.matricule = '$studentMatricule'
            AND
                paiement.DatePaiement = '$paymentDate'
            ORDER BY
                paiement.DatePaiement ASC
            LIMIT 1";

    $result = mysqli_query($connect, $sql); // Exécuter la requête

    if ($result === false) {
        // Si une erreur survient dans la requête, retourner un objet JSON vide avec le message d'erreur
        http_response_code(500); // Internal Server Error
        echo json_encode(["error" => "Database query failed: " . mysqli_error($connect)]);
    } else {
        if (mysqli_num_rows($result) > 0) {
            $response = mysqli_fetch_assoc($result);
            echo json_encode($response); // Encapsulez la réponse dans un tableau
        } else {
            echo json_encode([]); // Retournez une liste vide si aucune donnée n'est trouvée
        }
    }
    
    mysqli_free_result($result); // Libérer le résultat de la requête
    mysqli_close($connect); // Fermer la connexion à la base de données
} else {
    // Matricule ou DatePaiement est manquant
    http_response_code(400); // Bad Request
    echo json_encode(["error" => "Matricule or DatePaiement parameter is missing"]);
}
?>