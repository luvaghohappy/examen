<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: *");

// Inclusion du fichier connect.php qui contient la connexion à la base de données
include('conn.php');

// Point de terminaison pour récupérer les données de la table paiement
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // Vérifier si les données sont bien passées
    if (isset($_GET['class']) && isset($_GET['amount'])) {
        $class = $_GET['class'];
        $amount = $_GET['amount'];

        // Requête SQL pour sélectionner les paiements des élèves de la classe spécifiée
        $sql = "SELECT p.nom, p.postnom, p.prenom, p.classe,p.montant, s.somme as total_solde 
                FROM paiement p
                INNER JOIN solde s ON p.matricule = s.matricule
                WHERE p.classe = '$class'";

        // Exécution de la requête SQL
        $result = mysqli_query($connect, $sql);

        // Vérification des erreurs de requête
        if (!$result) {
            http_response_code(500); // Code d'erreur HTTP 500 pour indiquer une erreur de serveur
            die("Erreur d'exécution de la requête : " . mysqli_error($connect));
        }

        // Initialisation d'un tableau pour stocker les résultats de la requête
        $studentList = array();

        // Parcours des résultats de la requête et stockage dans le tableau $studentList
        while ($row = mysqli_fetch_assoc($result)) {
            // Comparaison du total_solde avec le montant spécifié
            if ($row["total_solde"] != $amount) {
                $studentList[] = $row;
                
                // Insertion des données dans la table 'recouvrement'
                $nom = mysqli_real_escape_string($connect, $row['nom']);
                $postnom = mysqli_real_escape_string($connect, $row['postnom']);
                $prenom = mysqli_real_escape_string($connect, $row['prenom']);
                $classe = mysqli_real_escape_string($connect, $row['classe']);
                $montant = mysqli_real_escape_string($connect, $row['montant']);
                $total = mysqli_real_escape_string($connect, $row['total_solde']); // Utiliser 'total_solde' au lieu de 'montant'
                $date = date('Y-m-d'); // Date actuelle

                $insertQuery = "INSERT INTO recouvrement (nom, postnom, prenom, classe, montant,Total, DateRecouvrement) VALUES ('$nom', '$postnom', '$prenom', '$classe', '$montant','$total', '$date')";
                $insertResult = mysqli_query($connect, $insertQuery);

                // Vérification des erreurs d'insertion
                if (!$insertResult) {
                    http_response_code(500); // Code d'erreur HTTP 500 pour indiquer une erreur de serveur
                    die("Erreur d'insertion dans la table 'recouvrement' : " . mysqli_error($connect));
                }
            }
        }

        // Conversion du tableau en format JSON et affichage
        echo json_encode($studentList);
    } else {
        // Si les paramètres attendus ne sont pas présents, renvoyer un code d'erreur HTTP 400 (Requête incorrecte)
        http_response_code(400);
        echo "Requête incorrecte : les paramètres 'class' et 'amount' sont requis.";
    }
} else {
    // Si la méthode de requête n'est pas GET, renvoyer un code d'erreur HTTP 405 (Méthode non autorisée)
    http_response_code(405);
    echo "Méthode non autorisée";
}
?>