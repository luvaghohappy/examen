<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: *");
include('conn.php');

// Fonction pour générer un matricule unique
function generateMatricule() {
    $annee = date("Y");
    $identifiant_unique = uniqid();
    $matricule = "E" . $annee . "-" . $identifiant_unique;
    return $matricule;
}

// Récupération des données du formulaire, en les protégeant contre les attaques XSS
$nom = htmlspecialchars($_POST["nom"]);
$postnom = htmlspecialchars($_POST["postnom"]);
$prenom = htmlspecialchars($_POST["prenom"]);
$classe = htmlspecialchars($_POST["classe"]);
$section = htmlspecialchars($_POST["section"]);
$option = htmlspecialchars($_POST["options"]);
$annee = htmlspecialchars($_POST["AnneScolaire"]);

// Générer le matricule
$matricule = generateMatricule();

// Vérification du nombre d'occurrences de l'élève dans la base de données pour une année scolaire donnée
$sql_check = "SELECT COUNT(*) AS count FROM eleve WHERE matricule = '$matricule' AND AnneScolaire = '$annee'";
$result_check = mysqli_query($connect, $sql_check);
$row_check = mysqli_fetch_assoc($result_check);
$count = $row_check['count'];

if ($count >= 2) {
    // L'élève existe déjà deux fois dans la même année scolaire, donc l'insertion est interdite
    echo json_encode("Insertion interdite : l'élève existe déjà deux fois dans la même année scolaire.");
} else {
    // L'élève n'existe pas deux fois dans la même année scolaire, donc l'insertion est autorisée
    // Requête SQL pour insérer les données dans la table 'eleve'
    $sql = "INSERT INTO eleve (matricule,nom,postnom,prenom,classe,section,options,AnneScolaire) 
    VALUES ('$matricule','$nom','$postnom','$prenom','$classe','$section','$option','$annee')";

    if(mysqli_query($connect, $sql)){
        echo json_encode("success");
    } else {
        echo json_encode("failed");
    }
}
?>