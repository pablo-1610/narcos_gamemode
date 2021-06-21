-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : lun. 21 juin 2021 à 04:22
-- Version du serveur :  10.4.18-MariaDB
-- Version de PHP : 8.0.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `narcos`
--

-- --------------------------------------------------------

--
-- Structure de la table `inventories`
--

CREATE TABLE `inventories` (
  `identifier` varchar(80) NOT NULL COMMENT 'Identifiant unique de l''inventaire',
  `label` varchar(80) NOT NULL COMMENT 'Nom d''affichage de l''inventaire',
  `capacity` float NOT NULL COMMENT 'Capacité totale de l''inventaire',
  `type` int(11) NOT NULL COMMENT 'Type de l''inventaire',
  `content` text NOT NULL COMMENT 'Contenu de l''inventaire'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `items`
--

CREATE TABLE `items` (
  `name` varchar(80) NOT NULL COMMENT 'Identifiant unique de l''item',
  `label` varchar(80) NOT NULL COMMENT 'Nom d''affichage de l''item',
  `weight` float NOT NULL COMMENT 'Poids de l''item'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `items`
--

INSERT INTO `items` (`name`, `label`, `weight`) VALUES
('bread', 'Pain', 0.2),
('water', 'Bouteille d\'eau', 0.45);

-- --------------------------------------------------------

--
-- Structure de la table `players`
--

CREATE TABLE `players` (
  `id` int(11) NOT NULL COMMENT 'Id unique du joueur (utilisé pour la boutique)',
  `lastInGameId` int(11) NOT NULL COMMENT 'Dernier id utilisé en jeu',
  `license` varchar(80) NOT NULL COMMENT 'Licence RockStar du joueur',
  `rank` varchar(80) NOT NULL COMMENT 'Le rang du joueur',
  `name` text NOT NULL COMMENT 'Pseudo du joueur (Steam ou PC)',
  `body` text NOT NULL COMMENT 'Informations textures du joueur (tête, visage et corps), ceci exclu les tenues et autres accessoires de ped.',
  `outfits` text NOT NULL COMMENT 'Tenues du joueurs',
  `selectedOutfit` varchar(80) NOT NULL COMMENT 'Tenue actuelle du joueur',
  `identity` text NOT NULL COMMENT 'Identité du joueur (Prénom, Nom, Age)',
  `cityInfos` text NOT NULL COMMENT 'Les informations RP du joueurs (job et orga)',
  `cash` int(11) NOT NULL COMMENT 'Argent (liquide) du joueur',
  `position` text NOT NULL COMMENT 'La dernière position du joueur',
  `vip` int(11) NOT NULL COMMENT 'Statut vip du joueur',
  `vip_time` int(11) NOT NULL COMMENT 'Temps d''échéance du vip',
  `loadout` text NOT NULL COMMENT 'Armes du joueur'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure de la table `ranks`
--

CREATE TABLE `ranks` (
  `id` varchar(50) NOT NULL COMMENT 'Id unique du grade',
  `label` varchar(50) NOT NULL COMMENT 'Label (affichage) du grade',
  `color` varchar(10) NOT NULL COMMENT 'Couleur du grade',
  `permissions` text NOT NULL COMMENT 'Permissions du grade'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `ranks`
--

INSERT INTO `ranks` (`id`, `label`, `color`, `permissions`) VALUES
('admin', 'Admin', '^1', '[]'),
('default', 'Joueur', '^7', '[]'),
('helper', 'Assistant', '^7', '[]'),
('moderator', 'Modérateur', '^7', '[]'),
('moderator+', 'Modérateur+', '^7', '[]'),
('owner', 'Propriétaire', '^7', '[]'),
('vip', 'VIP', '^7', '[]'),
('vip+', 'VIP+', '^7', '[]');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `inventories`
--
ALTER TABLE `inventories`
  ADD PRIMARY KEY (`identifier`);

--
-- Index pour la table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`name`);

--
-- Index pour la table `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `ranks`
--
ALTER TABLE `ranks`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `players`
--
ALTER TABLE `players`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id unique du joueur (utilisé pour la boutique)', AUTO_INCREMENT=20;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
