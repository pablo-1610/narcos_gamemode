CREATE TABLE `cards` (
  `id` int(11) NOT NULL,
  `owner` varchar(80) NOT NULL,
  `number` varchar(19) NOT NULL,
  `pin` int(4) NOT NULL,
  `balance` int(11) NOT NULL,
  `history` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
  `weight` float NOT NULL COMMENT 'Poids de l''item',
  `vip` int(11) NOT NULL DEFAULT 0 COMMENT 'Détermine si l''objet est reservé aux VIPs'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `jobs` (
  `name` varchar(80) NOT NULL,
  `label` varchar(80) NOT NULL,
  `money` int(11) NOT NULL,
  `ranks` text NOT NULL,
  `positions` text NOT NULL,
  `type` int(11) NOT NULL
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
  `cityInfos` text NOT NULL COMMENT 'Les informations RP du joueurs (job et orga)',
  `cash` int(11) NOT NULL COMMENT 'Argent (liquide) du joueur',
  `position` text NOT NULL COMMENT 'La dernière position du joueur',
  `vip` int(11) NOT NULL COMMENT 'Statut vip du joueur',
  `vip_time` int(11) NOT NULL COMMENT 'Temps d''échéance du vip',
  `loadout` text NOT NULL COMMENT 'Armes du joueur',
  `params` text NOT NULL COMMENT 'Paramètres du joueur'
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
('owner', 'Propriétaire', '^7', '{\"commands.setjob\"}'),
('vip', 'VIP', '^7', '[]'),
('vip+', 'VIP+', '^7', '[]');

ALTER TABLE `cards`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `inventories`
  ADD PRIMARY KEY (`identifier`);

ALTER TABLE `items`
  ADD PRIMARY KEY (`name`);

ALTER TABLE `jobs`
  ADD PRIMARY KEY (`name`);

ALTER TABLE `players`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `ranks`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `cards`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

ALTER TABLE `players`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id unique du joueur (utilisé pour la boutique)', AUTO_INCREMENT=26;
COMMIT;

