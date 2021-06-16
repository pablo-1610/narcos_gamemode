CREATE TABLE `inventories` (
  `identifier` varchar(80) NOT NULL COMMENT 'Identifiant unique de l''inventaire',
  `label` varchar(80) NOT NULL COMMENT 'Nom d''affichage de l''inventaire',
  `capacity` float NOT NULL COMMENT 'Capacité totale de l''inventaire',
  `type` int(11) NOT NULL COMMENT 'Type de l''inventaire',
  `content` text NOT NULL COMMENT 'Contenu de l''inventaire'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `items` (
  `name` varchar(80) NOT NULL COMMENT 'Identifiant unique de l''item',
  `label` varchar(80) NOT NULL COMMENT 'Nom d''affichage de l''item',
  `weight` float NOT NULL COMMENT 'Poids de l''item'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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

CREATE TABLE `ranks` (
  `id` varchar(50) NOT NULL COMMENT 'Id unique du grade',
  `label` varchar(50) NOT NULL COMMENT 'Label (affichage) du grade',
  `color` varchar(10) NOT NULL COMMENT 'Couleur du grade',
  `permissions` text NOT NULL COMMENT 'Permissions du grade'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `ranks` (`id`, `label`, `color`, `permissions`) VALUES
('admin', 'Admin', '^1', '[]'),
('default', 'Joueur', '^7', '[]'),
('helper', 'Assistant', '^7', '[]'),
('moderator', 'Modérateur', '^7', '[]'),
('moderator+', 'Modérateur+', '^7', '[]'),
('owner', 'Propriétaire', '^7', '[]'),
('vip', 'VIP', '^7', '[]'),
('vip+', 'VIP+', '^7', '[]');

ALTER TABLE `items`
  ADD PRIMARY KEY (`name`);

ALTER TABLE `players`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `ranks`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `players`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id unique du joueur (utilisé pour la boutique)', AUTO_INCREMENT=14;
COMMIT;
