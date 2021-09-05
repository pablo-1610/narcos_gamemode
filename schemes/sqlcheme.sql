-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : dim. 05 sep. 2021 à 03:24
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
-- Structure de la table `cards`
--

CREATE TABLE `cards` (
  `id` int(11) NOT NULL,
  `owner` varchar(80) NOT NULL,
  `number` varchar(19) NOT NULL,
  `pin` int(4) NOT NULL,
  `balance` int(11) NOT NULL,
  `history` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
('job:ems', 'Entrepôt Ambulance', 100, 2, '[]'),
('job:police', 'Entrepôt Policia', 100, 2, '[]'),
('job:test', 'Entrepôt Test', 100, 2, '[]'),
('job:unemployed', 'Entrepôt Explorateur', 100, 2, '[]'),
('license:8fc3f9bf5017c451d19593ae7d1105989d6635e0', 'Sac de pablo_1610', 20, 1, '{\"bread\":10,\"water\":10}'),
('license:8fc3f9bf5017c451d19593ae7d1105989d6635e0a', 'Sac de pablo_1610', 20, 1, '{\"water\":10}');

-- --------------------------------------------------------

--
-- Structure de la table `items`
--

CREATE TABLE `items` (
  `name` varchar(80) NOT NULL COMMENT 'Identifiant unique de l''item',
  `label` varchar(80) NOT NULL COMMENT 'Nom d''affichage de l''item',
  `weight` float NOT NULL COMMENT 'Poids de l''item',
  `vip` int(11) NOT NULL DEFAULT 0 COMMENT 'Détermine si l''objet est reservé aux VIPs'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `items`
--

INSERT INTO `items` (`name`, `label`, `weight`, `vip`) VALUES
('bread', 'Pain', 0.2, 0),
('water', 'Bouteille d\'eau', 0.45, 0);

-- --------------------------------------------------------

--
-- Structure de la table `jobs`
--

CREATE TABLE `jobs` (
  `name` varchar(80) NOT NULL,
  `label` varchar(80) NOT NULL,
  `money` int(11) NOT NULL,
  `history` text NOT NULL,
  `ranks` text NOT NULL,
  `positions` text NOT NULL,
  `type` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `jobs`
--

INSERT INTO `jobs` (`name`, `label`, `money`, `history`, `ranks`, `positions`, `type`) VALUES
('police', 'Police', 5000, '[]', '[{\"outfit\":[],\"id\":1,\"label\":\"Patron\",\"permissions\":{\"MANAGE\":true,\"SAFE\":true,\"FIRE\":true,\"BANK\":true,\"GARAGE\":true,\"RECRUIT\":true,\"CLOAKROOM\":true,\"DEMOTE\":true,\"PROMOTE\":true},\"salary\":1500},{\"outfit\":[],\"id\":2,\"label\":\"Associé\",\"permissions\":{\"MANAGE\":true,\"SAFE\":false,\"FIRE\":false,\"BANK\":false,\"GARAGE\":false,\"RECRUIT\":false,\"CLOAKROOM\":true,\"DEMOTE\":false,\"PROMOTE\":false},\"salary\":1500},{\"outfit\":[],\"id\":3,\"label\":\"Débutant\",\"permissions\":{\"MANAGE\":true,\"SAFE\":false,\"FIRE\":true,\"BANK\":false,\"GARAGE\":false,\"RECRUIT\":true,\"ROLES\":false,\"PROMOTE\":false,\"PINGALL\":false,\"CLOAKROOM\":true,\"DEMOTE\":false},\"salary\":1500}]', '{\"SAFE\":{\"desc\":\"le coffre\",\"blip\":{\"color\":36,\"active\":true,\"sprite\":478},\"perm\":\"SAFE\",\"location\":{\"x\":441.4153747558594,\"y\":-995.2483520507813,\"z\":30.6783447265625},\"label\":\"Stockage de l\'entreprise\"},\"CLOAKROOM\":{\"desc\":\"le vestiaire\",\"blip\":{\"color\":36,\"active\":true,\"sprite\":73},\"perm\":\"CLOAKROOM\",\"location\":{\"x\":450.6725158691406,\"y\":-992.3340454101563,\"z\":30.6783447265625},\"label\":\"Vestiaires de l\'entreprise\"},\"MANAGER\":{\"desc\":\"l\'ordinateur\",\"blip\":{\"color\":36,\"active\":true,\"sprite\":521},\"perm\":\"MANAGE\",\"location\":{\"x\":449.5780334472656,\"y\":-974.5054931640625,\"z\":30.6783447265625},\"label\":\"Gestion de l\'entreprise\"},\"GARAGE\":{\"desc\":\"le garage\",\"blip\":{\"color\":36,\"active\":true,\"sprite\":50},\"perm\":\"GARAGE\",\"location\":{\"x\":458.6109924316406,\"y\":-1008.06591796875,\"z\":28.2689208984375},\"label\":\"Garage de l\'entreprise\"}}', 3),
('unemployed', 'Explorateur', 0, '[]', '[{\"permissions\":{\"FIRE\":true,\"GARAGE\":true,\"BANK\":true,\"DEMOTE\":true,\"SAFE\":true,\"MANAGE\":true,\"RECRUIT\":true,\"PROMOTE\":true,\"CLOAKROOM\":true},\"outfit\":[],\"label\":\"Novice\"}]', '[]', 3);

-- --------------------------------------------------------

--
-- Structure de la table `job_employees`
--

CREATE TABLE `job_employees` (
  `identifier` varchar(80) NOT NULL,
  `job_id` varchar(80) NOT NULL,
  `rank` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `job_employees`
--

INSERT INTO `job_employees` (`identifier`, `job_id`, `rank`) VALUES
('license:8fc3f9bf5017c451d19593ae7d1105989d6635e0', 'police', 1),
('license:8fc3f9bf5017c451d19593ae7d1105989d6635e0a', 'police', 1);

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
  `loadout` text NOT NULL COMMENT 'Armes du joueur',
  `params` text NOT NULL COMMENT 'Paramètres du joueur'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `players`
--

INSERT INTO `players` (`id`, `lastInGameId`, `license`, `rank`, `name`, `body`, `outfits`, `selectedOutfit`, `identity`, `cityInfos`, `cash`, `position`, `vip`, `vip_time`, `loadout`, `params`) VALUES
(31, 0, 'license:8fc3f9bf5017c451d19593ae7d1105989d6635e0a', 'owner', 'pablo_1610', '{\"eyebrows_3\":0,\"hair_1\":0,\"hair_color_1\":0,\"hair_color_2\":0,\"eyebrows_2\":0,\"beard_3\":0,\"eyebrows_1\":0,\"face\":9,\"beard_2\":10,\"skin\":9,\"age_2\":5,\"beard_4\":0,\"hair_2\":0,\"age_1\":8,\"eyebrows_4\":0,\"sex\":1,\"beard_1\":9}', '{\"Explorateur\":{\"tshirt_1\":15,\"ears_2\":0,\"moles_1\":0,\"lipstick_3\":0,\"bproof_1\":0,\"helmet_2\":0,\"mask_1\":0,\"bodyb_2\":0,\"torso_1\":15,\"makeup_3\":0,\"arms\":15,\"lipstick_2\":0,\"complexion_2\":0,\"makeup_1\":0,\"ears_1\":-1,\"sun_2\":0,\"mask_2\":0,\"blemishes_1\":0,\"bproof_2\":0,\"arms_2\":0,\"pants_1\":15,\"chest_2\":0,\"chest_1\":0,\"decals_2\":0,\"makeup_4\":0,\"decals_1\":0,\"sun_1\":0,\"lipstick_4\":0,\"blush_2\":0,\"eye_color\":0,\"pants_2\":0,\"blush_3\":0,\"shoes_1\":5,\"glasses_1\":0,\"blush_1\":0,\"shoes_2\":0,\"torso_2\":0,\"chest_3\":0,\"blemishes_2\":0,\"bags_2\":0,\"bracelets_1\":-1,\"tshirt_2\":0,\"chain_1\":0,\"helmet_1\":-1,\"bodyb_1\":0,\"moles_2\":0,\"bracelets_2\":0,\"bags_1\":0,\"watches_1\":-1,\"watches_2\":0,\"lipstick_1\":0,\"complexion_1\":0,\"glasses_2\":0,\"chain_2\":0,\"makeup_2\":0}}', 'Explorateur', '{\"firstname\":\"Pablo\",\"lastname\":\"Barillas\",\"age\":18}', '{\"org\":{\"rank\":3,\"id\":\"unemployed\"},\"job\":{\"rank\":1,\"id\":\"police\"}}', 420, '{\"heading\":338.11572265625,\"pos\":{\"x\":446.5173645019531,\"y\":-977.7626342773438,\"z\":30.68959617614746}}', 0, 0, '[]', '[]'),
(32, 0, 'license:8fc3f9bf5017c451d19593ae7d1105989d6635e0', 'owner', 'pablo_1610', '{\"skin\":35,\"sex\":1,\"beard_1\":9,\"eyebrows_4\":0,\"hair_color_2\":0,\"hair_2\":0,\"age_2\":10,\"face\":42,\"beard_4\":0,\"eyebrows_1\":8,\"eyebrows_3\":0,\"hair_1\":0,\"age_1\":8,\"beard_2\":10,\"beard_3\":0,\"eyebrows_2\":9,\"hair_color_1\":0}', '{\"Explorateur\":{\"bracelets_1\":-1,\"blemishes_2\":0,\"lipstick_4\":0,\"ears_1\":-1,\"blush_1\":0,\"lipstick_3\":0,\"arms_2\":0,\"lipstick_2\":0,\"mask_2\":0,\"bproof_1\":0,\"bodyb_2\":0,\"bracelets_2\":0,\"glasses_2\":0,\"blush_3\":0,\"complexion_2\":0,\"lipstick_1\":0,\"pants_2\":0,\"chest_1\":0,\"arms\":15,\"tshirt_1\":15,\"moles_2\":0,\"bproof_2\":0,\"chain_2\":0,\"bodyb_1\":0,\"blush_2\":0,\"decals_1\":0,\"bags_1\":0,\"watches_1\":-1,\"watches_2\":0,\"complexion_1\":0,\"pants_1\":15,\"chest_2\":0,\"blemishes_1\":0,\"torso_2\":0,\"makeup_2\":0,\"shoes_1\":5,\"chain_1\":0,\"tshirt_2\":0,\"mask_1\":0,\"sun_2\":0,\"helmet_2\":0,\"shoes_2\":0,\"helmet_1\":-1,\"bags_2\":0,\"ears_2\":0,\"decals_2\":0,\"glasses_1\":0,\"torso_1\":15,\"makeup_3\":0,\"chest_3\":0,\"moles_1\":0,\"sun_1\":0,\"makeup_4\":0,\"makeup_1\":0,\"eye_color\":0}}', 'Explorateur', '{\"lastname\":\"Pesto\",\"firstname\":\"Fernando\",\"age\":45}', '{\"org\":{\"id\":\"unemployed\",\"rank\":1},\"job\":{\"id\":\"police\",\"rank\":1}}', 500, '{\"heading\":25.77920341491699,\"pos\":{\"x\":448.977783203125,\"y\":-974.950439453125,\"z\":30.85721397399902}}', 0, 0, '[]', '[]');

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
('owner', 'Propriétaire', '^7', '{\"commands.announce\", \"commands.setjobpos\", \"commands.setjob\",\"commands.car\", \"commands.giveitem\", \"commands.giveweapon\", \"commands.clearloadout\", \"commands.givemoney\", \"commands.setgroup\", \"commands.clearinventory\", \"menu.noclip\"}'),
('vip', 'VIP', '^7', '[]'),
('vip+', 'VIP+', '^7', '[]');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `cards`
--
ALTER TABLE `cards`
  ADD PRIMARY KEY (`id`);

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
-- Index pour la table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`name`);

--
-- Index pour la table `job_employees`
--
ALTER TABLE `job_employees`
  ADD PRIMARY KEY (`identifier`);

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
-- AUTO_INCREMENT pour la table `cards`
--
ALTER TABLE `cards`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT pour la table `players`
--
ALTER TABLE `players`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id unique du joueur (utilisé pour la boutique)', AUTO_INCREMENT=33;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
