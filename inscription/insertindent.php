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

    
    // Requête SQL pour insérer les données dans la table 'identification' avec l'image
    $sql = "INSERT INTO identification (nom, postnom, prenom, sexe, DateNaissance, LieuNaissance, EtatCivil, Adresse, Telephone, NomPere, NomMere, ProvOrigine, Territoire, EcoleProv, Dossier) 
    VALUES ('$nom', '$postnom', '$prenom', '$sexe', '$datenaiss', '$LieuNaiss', '$etat', '$adresse', '$numero', '$nompere', '$nommere', '$prov', '$terri', '$ecoleprov', '$dossier')";

    if(mysqli_query($connect, $sql)){
        echo json_encode("success");
    }else{
        echo json_encode("failed");
    }

?>