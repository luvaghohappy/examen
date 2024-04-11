<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: *");
// Inclusion du fichier connect.php qui contient la connexion à la base de données
include('conn.php');

// Vérifier si une date a été envoyée depuis le client
if(isset($_GET['R_date'])) {
    // Récupérer la date envoyée depuis le client
    $date = $_GET['R_date'];

    // Requête SQL pour sélectionner les données de la table "caisse" pour la date spécifiée
    $rqt_caisse = "SELECT * FROM caisse WHERE DateCaisse = '$date'";

    // Requête SQL pour sélectionner le MontantTotal de la date spécifique dans la table "rapportcaisse"
    $rqt_rapport = "SELECT MontantTotal FROM rapportcaisse WHERE Dates = '$date'";

    // Exécution de la requête SQL pour la table "caisse"
    $rqt_caisse_result = mysqli_query($connect, $rqt_caisse) OR die("Erreur d'exécution de la requête : " . mysqli_error($connect));

    // Exécution de la requête SQL pour la table "rapportcaisse"
    $rqt_rapport_result = mysqli_query($connect, $rqt_rapport) OR die("Erreur d'exécution de la requête : " . mysqli_error($connect));

    // Vérifier si des données ont été trouvées dans la table "caisse" pour la date spécifiée
    if(mysqli_num_rows($rqt_caisse_result) > 0) {
        // Récupérer les données de la table "caisse"
        $caisse_data = mysqli_fetch_assoc($rqt_caisse_result);

        // Vérifier si des données ont été trouvées pour le MontantTotal de la date spécifique dans la table "rapportcaisse"
        if(mysqli_num_rows($rqt_rapport_result) > 0) {
            // Récupérer le MontantTotal de la date spécifique dans la table "rapportcaisse"
            $rapport_data = mysqli_fetch_assoc($rqt_rapport_result);

            // Calcul du solde en soustrayant le MontantTotal de la table "rapportcaisse" du MontantTotal de la table "caisse"
            $solde = $caisse_data['MontantTotal'] - $rapport_data['MontantTotal'];

            // Création d'un tableau contenant les résultats
            $result = array(
                'MontantTotalCaisse' => $caisse_data['MontantTotal'],
                'MontantTotalRapport' => $rapport_data['MontantTotal'],
                'Solde' => $solde
            );

            // Conversion du tableau en format JSON et affichage
            echo json_encode($result);
        } else {
            echo "Aucune donnée trouvée pour le MontantTotal de la date spécifique dans la table 'rapportcaisse'.";
        }
    } else {
        echo "Aucune donnée trouvée dans la table 'caisse' pour la date spécifiée.";
    }
} else {
    echo "Veuillez spécifier une date.";
}
?>