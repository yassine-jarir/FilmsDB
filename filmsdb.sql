-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : mar. 10 déc. 2024 à 11:09
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `filmsdb`
--

-- --------------------------------------------------------

--
-- Structure de la table `movies`
--

CREATE TABLE `movies` (WS
  `MovieID` int(11) NOT NULL,
  `Title` varchar(100) DEFAULT NULL,
  `Genre` varchar(100) DEFAULT NULL,
  `ReleaseYear` int(11) DEFAULT NULL,
  `Duration` int(11) DEFAULT NULL,
  `Rating` varchar(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `review`
--

CREATE TABLE `review` (
  `ReviewID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `MovieID` int(11) NOT NULL,
  `Rating` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `subscription`
--

CREATE TABLE `subscription` (
  `SubscriptionID` int(11) NOT NULL,
  `SubscriptionType` varchar(20) DEFAULT NULL CHECK (`SubscriptionType` in ('Basic','Standard','Premium')),
  `MonthlyFree` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `userID` int(11) NOT NULL,
  `firstName` varchar(100) DEFAULT NULL,
  `lastName` varchar(100) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `RegistrationDate` date DEFAULT NULL,
  `SubscriptionID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `watchhistory`
--

CREATE TABLE `watchhistory` (
  `WatchHistoryID` int(11) NOT NULL,
  `UserID` int(11) DEFAULT NULL,
  `MovieID` int(11) DEFAULT NULL,
  `WatchDate` date NOT NULL,
  `CompletionPercentage` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `movies`
--
ALTER TABLE `movies`
  ADD PRIMARY KEY (`MovieID`);

--
-- Index pour la table `review`
--
ALTER TABLE `review`
  ADD PRIMARY KEY (`ReviewID`),
  ADD KEY `UserID` (`UserID`),
  ADD KEY `MovieID` (`MovieID`);

--
-- Index pour la table `subscription`
--
ALTER TABLE `subscription`
  ADD PRIMARY KEY (`SubscriptionID`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`userID`),
  ADD KEY `SubscriptionID` (`SubscriptionID`);

--
-- Index pour la table `watchhistory`
--
ALTER TABLE `watchhistory`
  ADD PRIMARY KEY (`WatchHistoryID`),
  ADD KEY `UserID` (`UserID`),
  ADD KEY `MovieID` (`MovieID`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `movies`
--
ALTER TABLE `movies`
  MODIFY `MovieID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `review`
--
ALTER TABLE `review`
  MODIFY `ReviewID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `subscription`
--
ALTER TABLE `subscription`
  MODIFY `SubscriptionID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `userID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `watchhistory`
--
ALTER TABLE `watchhistory`
  MODIFY `WatchHistoryID` int(11) NOT NULL AUTO_INCREMENT;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `review`
--
ALTER TABLE `review`
  ADD CONSTRAINT `review_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`userID`),
  ADD CONSTRAINT `review_ibfk_2` FOREIGN KEY (`MovieID`) REFERENCES `movies` (`MovieID`);

--
-- Contraintes pour la table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`SubscriptionID`) REFERENCES `subscription` (`SubscriptionID`);

--
-- Contraintes pour la table `watchhistory`
--
ALTER TABLE `watchhistory`
  ADD CONSTRAINT `watchhistory_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`userID`),
  ADD CONSTRAINT `watchhistory_ibfk_2` FOREIGN KEY (`MovieID`) REFERENCES `movies` (`MovieID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- 

-- 1- Insérer un film : Ajouter un nouveau film intitulé Data Science Adventures dans le genre "Documentary".
INSERT INTO movies (title, Genre) VALUES ("Data Science Adventures", "Documentary");

-- 2- Rechercher des films : Lister tous les films du genre "Comedy" sortis après 2020

SELECT * FROM movies WHERE Genre = 'Comedy' AND ReleaseYear > 2020;

-- 3- Mise à jour des abonnements : Passer tous les utilisateurs de "Basic" à "Premium"..
UPDATE users u
JOIN subscription s_basic ON u.SubscriptionID = s_basic.SubscriptionID
JOIN subscription s_premium ON s_premium.SubscriptionType = 'Premium'
SET u.SubscriptionID = s_premium.SubscriptionID
WHERE s_basic.SubscriptionType = 'Basic';

-- 4 - Afficher les abonnements : Joindre les utilisateurs à leurs types d'abonnements.
SELECT u.firstName, u.lastName, s.SubscriptionType
FROM users u
JOIN subscription s ON u.SubscriptionID = s.SubscriptionID;

-- 5 - Filtrer les visionnages : Trouver tous les utilisateurs ayant terminé de regarder un film.
SELECT u.firstName, u.lastName, w.CompletionPercentage FROM users u JOIN watchhistory w ON u.userID = w.UserID WHERE CompletionPercentage = 100;

-- 6 - Trier et limiter : Afficher les 5 films les plus longs, triés par durée.
SELECT Title, Duration FROM movies ORDER BY Duration LIMIT 5;

-- 7 - Agrégation : Calculer le pourcentage moyen de complétion pour chaque film.

SELECT MovieID, 
AVG(CompletionPercentage) 
AS AverageCompletionPercentage
FROM watchhistory
GROUP BY MovieID;

-- 8- Sous-requête (Bonus): Trouver les films ayant une note moyenne supérieure à 4.
SELECT m.MovieID, m.Title
FROM movies m
WHERE (
    SELECT AVG(r.Rating)
    FROM review r
    WHERE r.MovieID = m.MovieID
) > 4;
