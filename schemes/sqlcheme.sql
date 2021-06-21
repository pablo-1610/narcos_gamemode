-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : lun. 21 juin 2021 à 02:41
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

--
-- Déchargement des données de la table `inventories`
--

INSERT INTO `inventories` (`identifier`, `label`, `capacity`, `type`, `content`) VALUES
('license:8fc3f9bf5017c451d19593ae7d1105989d6635e0', 'Sac de pablo_1610', 20, 1, '{\"water\":2}');

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
  `cash` int(11) NOT NULL COMMENT 'Argent (liquide) du joueur',
  `position` text NOT NULL COMMENT 'La dernière position du joueur'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `players`
--

INSERT INTO `players` (`id`, `lastInGameId`, `license`, `rank`, `name`, `body`, `outfits`, `selectedOutfit`, `identity`, `cash`, `position`) VALUES
(13, 1, 'license:8fc3f9bf5017c451d19593ae7d1105989d6635e0', 'default', 'pablo_1610', '{\"hair_color_2\":0,\"eyebrows_4\":0,\"hair_color_1\":0,\"beard_4\":0,\"hair_2\":0,\"hair_1\":0,\"beard_1\":3,\"age_1\":14,\"skin\":41,\"sex\":1,\"beard_2\":8,\"eyebrows_3\":0,\"beard_3\":0,\"face\":42,\"age_2\":7,\"eyebrows_2\":0,\"eyebrows_1\":0}', '{\"Explorateur\":{\"torso_1\":15,\"blemishes_2\":0,\"complexion_1\":0,\"glasses_2\":0,\"helmet_1\":-1,\"moles_1\":0,\"makeup_3\":0,\"blush_3\":0,\"eye_color\":0,\"sun_2\":0,\"chain_1\":0,\"bracelets_2\":0,\"glasses_1\":0,\"pants_2\":0,\"chain_2\":0,\"bags_2\":0,\"chest_3\":0,\"lipstick_3\":0,\"shoes_2\":0,\"makeup_1\":0,\"ears_2\":0,\"torso_2\":0,\"watches_2\":0,\"makeup_4\":0,\"complexion_2\":0,\"tshirt_2\":0,\"bags_1\":0,\"mask_1\":0,\"ears_1\":-1,\"bracelets_1\":-1,\"shoes_1\":5,\"lipstick_1\":0,\"arms_2\":0,\"blush_2\":0,\"sun_1\":0,\"decals_1\":0,\"chest_2\":0,\"moles_2\":0,\"bodyb_1\":0,\"pants_1\":15,\"chest_1\":0,\"helmet_2\":0,\"bproof_2\":0,\"blush_1\":0,\"watches_1\":-1,\"bodyb_2\":0,\"blemishes_1\":0,\"tshirt_1\":15,\"makeup_2\":0,\"mask_2\":0,\"arms\":15,\"decals_2\":0,\"bproof_1\":0,\"lipstick_4\":0,\"lipstick_2\":0}}', 'Explorateur', '{\"lastname\":\"Barillas\",\"firstname\":\"Pablo\",\"age\":45}', 5, '{\"heading\":176.02760314941407,\"pos\":{\"x\":-415.73114013671877,\"y\":5620.0927734375,\"z\":67.00515747070313}}');

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id unique du joueur (utilisé pour la boutique)', AUTO_INCREMENT=14;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
