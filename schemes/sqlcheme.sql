CREATE TABLE `players` (
  `id` int(11) NOT NULL COMMENT 'Id unique de l''utilisateur',
  `lastInGameId` int(11) NOT NULL COMMENT 'Dernier id utilisé en jeu',
  `license` varchar(80) NOT NULL COMMENT 'Licence RockStar associée au compte',
  `rank` varchar(80) NOT NULL COMMENT 'Le rang du joueur',
  `name` text NOT NULL COMMENT 'Pseudo du joueur (Steam ou PC)',
  `body` text NOT NULL COMMENT 'Informations textures du joueur (tête, visage et corps), ceci exclu les tenues et autres accessoires de ped.',
  `outfits` text NOT NULL COMMENT 'Tenues du joueurs',
  `selectedOutfit` int(11) NOT NULL COMMENT 'Tenue actuelle du joueur',
  `identity` text NOT NULL COMMENT 'Identité du joueur (Prénom, Nom, Age)',
  `cash` int(11) NOT NULL COMMENT 'Argent (liquide) du joueur',
  `position` text NOT NULL COMMENT 'La dernière position du joueur'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `ranks` (
  `id` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `color` varchar(10) NOT NULL,
  `permissions` text NOT NULL
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

ALTER TABLE `players`
  ADD PRIMARY KEY (`license`),
  ADD UNIQUE KEY `id` (`id`);

ALTER TABLE `ranks`
  ADD PRIMARY KEY (`id`);
COMMIT;
