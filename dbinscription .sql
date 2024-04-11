-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : jeu. 11 avr. 2024 à 18:17
-- Version du serveur : 10.4.28-MariaDB
-- Version de PHP : 8.0.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `dbinscription`
--

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateSoldeProcedure` (IN `new_matricule` VARCHAR(255), IN `new_montant` DECIMAL(10,2), IN `new_datePaiement` DATE)   BEGIN
    DECLARE existingRecord INT;

    -- Vérifiez si un enregistrement pour le même élève existe déjà dans la table de solde
    SELECT COUNT(*) INTO existingRecord FROM solde WHERE matricule = new_matricule;

    IF existingRecord > 0 THEN
        -- Mettez à jour le montant total et la date du dernier paiement
        UPDATE solde
        SET somme = somme + new_montant,
            Datepayement = new_datePaiement
        WHERE matricule = new_matricule;
    ELSE
        -- Insérez les nouvelles données dans la table de solde
        INSERT INTO solde (matricule, somme, Datepayement) VALUES (new_matricule, new_montant, new_datePaiement);
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `caisse`
--

CREATE TABLE `caisse` (
  `id` int(11) NOT NULL,
  `matricule` varchar(100) NOT NULL,
  `montant` float NOT NULL,
  `DateCaisse` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `caisse`
--

INSERT INTO `caisse` (`id`, `matricule`, `montant`, `DateCaisse`) VALUES
(1, 'E2024-6616aef2a9839', 50, '2024-04-10'),
(2, 'E2024-6617f14c93134', 90, '2024-04-10'),
(3, 'E2024-6618038071e64', 30, '2024-04-11'),
(4, 'E2024-6616aef2a9839', 70, '2024-04-11');

--
-- Déclencheurs `caisse`
--
DELIMITER $$
CREATE TRIGGER `caissier_delete` AFTER DELETE ON `caisse` FOR EACH ROW BEGIN
    INSERT INTO operation (service, date_heure)
    VALUES ('Caissier: Suppression dans la table caisse', NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `caissier_insertion` AFTER INSERT ON `caisse` FOR EACH ROW BEGIN
    INSERT INTO operation (service, date_heure)
    VALUES ('Caissier: Insertion dans la table caisse', NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `caissier_update` AFTER UPDATE ON `caisse` FOR EACH ROW BEGIN
    INSERT INTO operation (service, date_heure)
    VALUES ('Caissier: Modification dans la table caisse', NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `calculer_rapport_caisse` AFTER INSERT ON `caisse` FOR EACH ROW BEGIN
    DECLARE total_journalier DECIMAL(10, 2);

    -- Calcul du total des montants insérés dans la table caisse pour la DateCaisse actuelle
    SELECT SUM(montant) INTO total_journalier
    FROM caisse
    WHERE DateCaisse = NEW.DateCaisse;

    -- Vérifier si la date existe déjà dans la table rapportcaisse
    IF EXISTS (SELECT 1 FROM rapportcaisse WHERE Dates = NEW.DateCaisse) THEN
        -- Mise à jour du montant pour la date existante
        UPDATE rapportcaisse SET TotalJournalier = total_journalier WHERE Dates = NEW.DateCaisse;
    ELSE
        -- Insertion du rapport dans la table RapportCaisse si la date n'existe pas encore
        INSERT INTO rapportcaisse (Dates, TotalJournalier) VALUES (NEW.DateCaisse, total_journalier);
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `classe`
--

CREATE TABLE `classe` (
  `id` int(11) NOT NULL,
  `designation` varchar(100) NOT NULL,
  `section` varchar(100) NOT NULL,
  `options` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `classe`
--

INSERT INTO `classe` (`id`, `designation`, `section`, `options`) VALUES
(1, '8ieme', 'elementaire', 'elementaire'),
(2, '7ieme', 'elementaire', 'elemenatire'),
(3, '1iere', 'technique', 'commercial');

-- --------------------------------------------------------

--
-- Structure de la table `eleve`
--

CREATE TABLE `eleve` (
  `id` int(11) NOT NULL,
  `matricule` varchar(100) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `postnom` varchar(50) NOT NULL,
  `prenom` varchar(50) NOT NULL,
  `classe` varchar(100) NOT NULL,
  `section` varchar(100) NOT NULL,
  `options` varchar(100) NOT NULL,
  `AnneScolaire` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `eleve`
--

INSERT INTO `eleve` (`id`, `matricule`, `nom`, `postnom`, `prenom`, `classe`, `section`, `options`, `AnneScolaire`) VALUES
(1, 'E2024-6616aef2a9839', 'kasoki', 'luvagho', 'furaha', '8ieme', 'elementaire', 'elementaire', '2020-2021'),
(2, 'E2024-6617f14c93134', 'moise', 'musa', 'moses', '1iere', 'technique', 'commercial', '2020-2021'),
(3, 'E2024-6618038071e64', 'bless', 'muji', 'fafa', '7ieme', 'elementaire', 'elementaire', '2021-2022');

--
-- Déclencheurs `eleve`
--
DELIMITER $$
CREATE TRIGGER `secretaire_delete` AFTER DELETE ON `eleve` FOR EACH ROW BEGIN
    INSERT INTO operation (service, date_heure)
    VALUES ('Secretaire: Suppression dans la table eleve', NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `secretaire_insertion` AFTER INSERT ON `eleve` FOR EACH ROW BEGIN
    INSERT INTO operation (service, date_heure)
    VALUES ('Secretaire : Insertion dans la table eleve', NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `secretaire_update` AFTER UPDATE ON `eleve` FOR EACH ROW BEGIN
    INSERT INTO operation (service, date_heure)
    VALUES ('Secretaire:Modification dans la table eleve', NOW());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `identification`
--

CREATE TABLE `identification` (
  `id` int(11) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `postnom` varchar(100) NOT NULL,
  `prenom` varchar(50) NOT NULL,
  `sexe` char(10) NOT NULL,
  `DateNaissance` date NOT NULL,
  `LieuNaissance` varchar(100) NOT NULL,
  `EtatCivil` varchar(50) NOT NULL,
  `Adresse` varchar(150) NOT NULL,
  `Telephone` varchar(50) NOT NULL,
  `NomPere` varchar(50) NOT NULL,
  `NomMere` varchar(50) NOT NULL,
  `ProvOrigine` varchar(100) NOT NULL,
  `Territoire` varchar(50) NOT NULL,
  `EcoleProv` varchar(100) NOT NULL,
  `Dossier` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `identification`
--

INSERT INTO `identification` (`id`, `nom`, `postnom`, `prenom`, `sexe`, `DateNaissance`, `LieuNaissance`, `EtatCivil`, `Adresse`, `Telephone`, `NomPere`, `NomMere`, `ProvOrigine`, `Territoire`, `EcoleProv`, `Dossier`) VALUES
(1, 'kasoki', 'luvagho', 'furaha', 'M', '2024-04-11', 'goma', 'celibatiare', 'majengo', '+988777766', 'mon pere', 'ma mere', 'ituri', 'lubero', 'majnego', 'bulletin');

-- --------------------------------------------------------

--
-- Structure de la table `operation`
--

CREATE TABLE `operation` (
  `id` int(11) NOT NULL,
  `service` varchar(100) NOT NULL,
  `date_heure` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `operation`
--

INSERT INTO `operation` (`id`, `service`, `date_heure`) VALUES
(1, 'Secretaire : Insertion dans la table eleve', '2024-04-10 17:23:30'),
(2, 'Comptable : Insertion dans la table paiement', '2024-04-10 17:34:02'),
(16, 'Caissier: Insertion dans la table caisse', '2024-04-11 13:10:23'),
(17, 'Caissier: Suppression dans la table caisse', '2024-04-11 13:10:44'),
(18, 'Caissier: Insertion dans la table caisse', '2024-04-11 13:11:24'),
(19, 'Caissier: Insertion dans la table caisse', '2024-04-11 14:23:20'),
(20, 'Caissier: Insertion dans la table caisse', '2024-04-11 14:27:49'),
(21, 'Caissier: Insertion dans la table caisse', '2024-04-11 14:35:49'),
(22, 'Caissier: Suppression dans la table caisse', '2024-04-11 14:36:09'),
(25, 'Secretaire : Insertion dans la table eleve', '2024-04-11 16:18:52'),
(26, 'Comptable : Insertion dans la table paiement', '2024-04-11 16:21:21'),
(30, 'Caissier: Insertion dans la table caisse', '2024-04-11 16:30:00'),
(31, 'Caissier: Insertion dans la table caisse', '2024-04-11 16:30:41'),
(32, 'Caissier: Insertion dans la table caisse', '2024-04-11 16:30:41'),
(33, 'Secretaire : Insertion dans la table eleve', '2024-04-11 17:36:32'),
(34, 'Comptable : Insertion dans la table paiement', '2024-04-11 17:38:22'),
(35, 'Comptable : Insertion dans la table paiement', '2024-04-11 17:39:24'),
(36, 'Caissier: Insertion dans la table caisse', '2024-04-11 17:53:04'),
(37, 'Caissier: Insertion dans la table caisse', '2024-04-11 17:53:04'),
(38, 'Caissier: Insertion dans la table caisse', '2024-04-11 17:53:04'),
(39, 'Caissier: Insertion dans la table caisse', '2024-04-11 17:53:04'),
(40, 'Caissier: Insertion dans la table caisse', '2024-04-11 18:00:54'),
(41, 'Caissier: Insertion dans la table caisse', '2024-04-11 18:00:54'),
(42, 'Caissier: Insertion dans la table caisse', '2024-04-11 18:00:54'),
(43, 'Caissier: Insertion dans la table caisse', '2024-04-11 18:00:54');

-- --------------------------------------------------------

--
-- Structure de la table `paiement`
--

CREATE TABLE `paiement` (
  `id` int(11) NOT NULL,
  `matricule` varchar(100) NOT NULL,
  `nom` varchar(50) NOT NULL,
  `postnom` varchar(50) NOT NULL,
  `prenom` varchar(50) NOT NULL,
  `classe` varchar(40) NOT NULL,
  `MotifPaiement` varchar(50) NOT NULL,
  `montant` float NOT NULL,
  `DatePaiement` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `paiement`
--

INSERT INTO `paiement` (`id`, `matricule`, `nom`, `postnom`, `prenom`, `classe`, `MotifPaiement`, `montant`, `DatePaiement`) VALUES
(1, 'E2024-6616aef2a9839', 'kasoki', 'luvagho', 'furaha', '8ieme', 'frais scolaire', 50, '2024-04-10'),
(2, 'E2024-6617f14c93134', 'moise', 'musa', 'moses', '1iere', 'frais inscription', 90, '2024-04-10'),
(3, 'E2024-6618038071e64', 'bless', 'muji', 'fafa', '7ieme', 'frais scolaire', 30, '2024-04-11'),
(4, 'E2024-6616aef2a9839', 'kasoki', 'luvagho', 'furaha', '8ieme', 'frais scolaire', 70, '2024-04-11');

--
-- Déclencheurs `paiement`
--
DELIMITER $$
CREATE TRIGGER `comptable_delete` AFTER DELETE ON `paiement` FOR EACH ROW BEGIN
    INSERT INTO operation (service, date_heure)
    VALUES ('Comptable :Suppression dans la table paiement', NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `comptable_update` AFTER UPDATE ON `paiement` FOR EACH ROW BEGIN
    INSERT INTO operation (service, date_heure)
    VALUES ('Comptable : Modification dans la table paiement', NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertion` AFTER INSERT ON `paiement` FOR EACH ROW BEGIN
    INSERT INTO operation (service, date_heure)
    VALUES ('Comptable : Insertion dans la table paiement', NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `updateSoldeAfterInsert` AFTER INSERT ON `paiement` FOR EACH ROW BEGIN
    -- Appeler la procédure stockée pour mettre à jour le solde
    CALL updateSoldeProcedure(NEW.matricule, NEW.montant, NEW.DatePaiement);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `rapportcaisse`
--

CREATE TABLE `rapportcaisse` (
  `id` int(11) NOT NULL,
  `Dates` date NOT NULL,
  `TotalJournalier` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `rapportcaisse`
--

INSERT INTO `rapportcaisse` (`id`, `Dates`, `TotalJournalier`) VALUES
(1, '2024-04-10', 140),
(2, '2024-04-11', 100);

-- --------------------------------------------------------

--
-- Structure de la table `recouvrement`
--

CREATE TABLE `recouvrement` (
  `id` int(11) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `postnom` varchar(100) NOT NULL,
  `prenom` varchar(50) NOT NULL,
  `classe` varchar(50) NOT NULL,
  `DatePaiement` float NOT NULL,
  `montant` float NOT NULL,
  `Total` float NOT NULL,
  `DateRecouvrement` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `recouvrement`
--

INSERT INTO `recouvrement` (`id`, `nom`, `postnom`, `prenom`, `classe`, `DatePaiement`, `montant`, `Total`, `DateRecouvrement`) VALUES
(1, 'bless', 'muji', 'fafa', '7ieme', 30, 30, 2024, '2024-04-11'),
(2, 'kasoki', 'luvagho', 'furaha', '8ieme', 50, 120, 2024, '2024-04-11'),
(3, 'kasoki', 'luvagho', 'furaha', '8ieme', 70, 120, 2024, '2024-04-11');

-- --------------------------------------------------------

--
-- Structure de la table `solde`
--

CREATE TABLE `solde` (
  `id` int(11) NOT NULL,
  `matricule` varchar(100) NOT NULL,
  `somme` float NOT NULL,
  `Datepayement` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `solde`
--

INSERT INTO `solde` (`id`, `matricule`, `somme`, `Datepayement`) VALUES
(1, 'E2024-6616aef2a9839', 120, '2024-04-11'),
(2, 'E2024-6617f14c93134', 90, '2024-04-10'),
(3, 'E2024-6618038071e64', 30, '2024-04-11');

-- --------------------------------------------------------

--
-- Structure de la table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `passwords` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `user`
--

INSERT INTO `user` (`id`, `email`, `passwords`) VALUES
(8, 'com', 'com'),
(9, 'com', 'com'),
(10, 'sec', 'sec'),
(11, 'caisse', 'caisse'),
(12, 'a', 'a');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `caisse`
--
ALTER TABLE `caisse`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `classe`
--
ALTER TABLE `classe`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `eleve`
--
ALTER TABLE `eleve`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `identification`
--
ALTER TABLE `identification`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `operation`
--
ALTER TABLE `operation`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `paiement`
--
ALTER TABLE `paiement`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `rapportcaisse`
--
ALTER TABLE `rapportcaisse`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `recouvrement`
--
ALTER TABLE `recouvrement`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `solde`
--
ALTER TABLE `solde`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `caisse`
--
ALTER TABLE `caisse`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `classe`
--
ALTER TABLE `classe`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `eleve`
--
ALTER TABLE `eleve`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `identification`
--
ALTER TABLE `identification`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `operation`
--
ALTER TABLE `operation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT pour la table `paiement`
--
ALTER TABLE `paiement`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `rapportcaisse`
--
ALTER TABLE `rapportcaisse`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `recouvrement`
--
ALTER TABLE `recouvrement`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `solde`
--
ALTER TABLE `solde`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
