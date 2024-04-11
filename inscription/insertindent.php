<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: *");
include('conn.php');

// Récupération des données du formulaire, en les protégeant contre les attaques XSS
$nom = htmlspecialchars($_POST["nom"]);
$postnom = htmlspecialchars($_POST["postnom"]);
$prenom = htmlspecialchars($_POST["prenom"]);
$sexe = htmlspecialchars($_POST["sexe"]);
$datenaiss = htmlspecialchars($_POST["DateNaissance"]);
$LieuNaiss = htmlspecialchars($_POST["LieuNaissance"]);
$etat = htmlspecialchars($_POST["EtatCivil"]);
$adresse = htmlspecialchars($_POST["Adresse"]);
$numero = htmlspecialchars($_POST["Telephone"]);
$nompere = htmlspecialchars($_POST["NomPere"]);
$nommere = htmlspecialchars($_POST["NomMere"]);
$prov = htmlspecialchars($_POST["ProvOrigine"]);
$terri = htmlspecialchars($_POST["Territoire"]);
$ecoleprov = htmlspecialchars($_POST["EcoleProv"]);
$dossier = htmlspecialchars($_POST["Dossier"]);

// Vérification s'il y a une image envoyée
// if(isset($_FILES['profil'])) {
//     // Récupération des données de l'image
//     $image = $_FILES['profil'];
    
//     // Nom temporaire de l'image
//     $tmpName = $image['tmp_name'];
    
//     // Lecture des données binaires de l'image
//     $imageData = file_get_contents($tmpName);
    
//     // Encodage des données binaires de l'image en base64
//     $base64Image = base64_encode($imageData);
    
    // Requête SQL pour insérer les données dans la table 'identification' avec l'image
    $sql = "INSERT INTO identification (nom, postnom, prenom, sexe, DateNaissance, LieuNaissance, EtatCivil, Adresse, Telephone, NomPere, NomMere, ProvOrigine, Territoire, EcoleProv, Dossier, profil) 
    VALUES ('$nom', '$postnom', '$prenom', '$sexe', '$datenaiss', '$LieuNaiss', '$etat', '$adresse', '$numero', '$nompere', '$nommere', '$prov', '$terri', '$ecoleprov', '$dossier', '$base64Image')";

    if(mysqli_query($connect, $sql)){
        echo json_encode("success");
    }else{
        echo json_encode("failed");
    }
// } else {
//     // Si aucune image n'est envoyée, renvoyer une réponse d'erreur
//     echo json_encode("Aucune image envoyée");
// }
?>