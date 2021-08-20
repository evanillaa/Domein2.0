-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server versie:                10.4.20-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Versie:              11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Databasestructuur van hetdomein2.0 wordt geschreven
CREATE DATABASE IF NOT EXISTS `hetdomein2.0` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `hetdomein2.0`;

-- Structuur van  tabel hetdomein2.0.player_accounts wordt geschreven
CREATE TABLE IF NOT EXISTS `player_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `bankid` varchar(50) DEFAULT NULL,
  `balance` int(20) DEFAULT 0,
  `authorized` varchar(500) DEFAULT NULL,
  `transactions` varchar(60000) DEFAULT '{}',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=126 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel hetdomein2.0.player_accounts: 0 rows
/*!40000 ALTER TABLE `player_accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_accounts` ENABLE KEYS */;

-- Structuur van  tabel hetdomein2.0.player_bans wordt geschreven
CREATE TABLE IF NOT EXISTS `player_bans` (
  `id` int(11) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `steam` varchar(50) DEFAULT NULL,
  `license` varchar(50) DEFAULT NULL,
  `discord` varchar(50) DEFAULT NULL,
  `ip` varchar(50) DEFAULT NULL,
  `reason` varchar(50) DEFAULT NULL,
  `expire` int(11) DEFAULT NULL,
  `bannedby` varchar(255) NOT NULL DEFAULT 'Banhammer'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumpen data van tabel hetdomein2.0.player_bans: ~0 rows (ongeveer)
/*!40000 ALTER TABLE `player_bans` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_bans` ENABLE KEYS */;

-- Structuur van  tabel hetdomein2.0.player_bills wordt geschreven
CREATE TABLE IF NOT EXISTS `player_bills` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `invoiceid` varchar(50) DEFAULT NULL,
  `sender` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=174 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel hetdomein2.0.player_bills: 0 rows
/*!40000 ALTER TABLE `player_bills` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_bills` ENABLE KEYS */;

-- Structuur van  tabel hetdomein2.0.player_bindings wordt geschreven
CREATE TABLE IF NOT EXISTS `player_bindings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `key` text DEFAULT NULL,
  `command` text DEFAULT NULL,
  `argument` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Dumpen data van tabel hetdomein2.0.player_bindings: 0 rows
/*!40000 ALTER TABLE `player_bindings` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_bindings` ENABLE KEYS */;

-- Structuur van  tabel hetdomein2.0.player_contacts wordt geschreven
CREATE TABLE IF NOT EXISTS `player_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `number` varchar(50) DEFAULT NULL,
  `iban` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1112 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel hetdomein2.0.player_contacts: 0 rows
/*!40000 ALTER TABLE `player_contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_contacts` ENABLE KEYS */;

-- Structuur van  tabel hetdomein2.0.player_current wordt geschreven
CREATE TABLE IF NOT EXISTS `player_current` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` longtext DEFAULT NULL,
  `model` longtext DEFAULT NULL,
  `drawables` longtext DEFAULT NULL,
  `props` longtext DEFAULT NULL,
  `drawtextures` longtext DEFAULT NULL,
  `proptextures` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- Dumpen data van tabel hetdomein2.0.player_current: ~1 rows (ongeveer)
/*!40000 ALTER TABLE `player_current` DISABLE KEYS */;
INSERT INTO `player_current` (`id`, `citizenid`, `model`, `drawables`, `props`, `drawtextures`, `proptextures`) VALUES
	(1, 'OPK47724', '-20018299', '{"1":["masks",0],"2":["hair",1],"3":["torsos",1],"4":["legs",1],"5":["bags",-1],"6":["shoes",1],"7":["neck",-1],"8":["undershirts",0],"9":["vest",-1],"10":["decals",-1],"11":["jackets",-1],"0":["face",0]}', '{"1":["glasses",-1],"2":["earrings",-1],"3":["mouth",-1],"4":["lhand",-1],"5":["rhand",-1],"6":["watches",-1],"7":["braclets",-1],"0":["hats",-1]}', '[["face",1],["masks",0],["hair",0],["torsos",0],["legs",0],["bags",0],["shoes",0],["neck",0],["undershirts",0],["vest",0],["decals",0],["jackets",0]]', '[["hats",-1],["glasses",-1],["earrings",-1],["mouth",-1],["lhand",-1],["rhand",-1],["watches",-1],["braclets",-1]]');
/*!40000 ALTER TABLE `player_current` ENABLE KEYS */;

-- Structuur van  tabel hetdomein2.0.player_face wordt geschreven
CREATE TABLE IF NOT EXISTS `player_face` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` longtext DEFAULT NULL,
  `hairColor` longtext DEFAULT NULL,
  `headBlend` longtext DEFAULT NULL,
  `headOverlay` longtext DEFAULT NULL,
  `headStructure` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumpen data van tabel hetdomein2.0.player_face: ~0 rows (ongeveer)
/*!40000 ALTER TABLE `player_face` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_face` ENABLE KEYS */;

-- Structuur van  tabel hetdomein2.0.player_houseplants wordt geschreven
CREATE TABLE IF NOT EXISTS `player_houseplants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `houseid` varchar(50) DEFAULT '11111',
  `plants` varchar(65000) DEFAULT '[]',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Dumpen data van tabel hetdomein2.0.player_houseplants: 0 rows
/*!40000 ALTER TABLE `player_houseplants` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_houseplants` ENABLE KEYS */;

-- Structuur van  tabel hetdomein2.0.player_houses wordt geschreven
CREATE TABLE IF NOT EXISTS `player_houses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT '[]',
  `name` varchar(50) DEFAULT NULL,
  `label` varchar(50) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `tier` int(11) DEFAULT NULL,
  `owned` varchar(50) DEFAULT NULL,
  `coords` text DEFAULT NULL,
  `keyholders` text DEFAULT NULL,
  `decorations` longtext DEFAULT NULL,
  `stash` text DEFAULT NULL,
  `outfit` text DEFAULT NULL,
  `logout` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=55 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel hetdomein2.0.player_houses: 1 rows
/*!40000 ALTER TABLE `player_houses` DISABLE KEYS */;
INSERT INTO `player_houses` (`id`, `citizenid`, `name`, `label`, `price`, `tier`, `owned`, `coords`, `keyholders`, `decorations`, `stash`, `outfit`, `logout`) VALUES
	(54, 'FHB26658', 'elysian fields fwy1', 'Elysian Fields Fwy 1', 1, 11, 'true', '{"Enter":{"X":1141.3887939453126,"H":226.2925262451172,"Y":-1657.327392578125,"Z":36.41383361816406},"Cam":{"X":1141.3887939453126,"Y":-1657.327392578125,"Z":36.41383361816406,"Yaw":-10.0,"H":226.2925262451172}}', '["FHB26658"]', NULL, NULL, NULL, NULL);
/*!40000 ALTER TABLE `player_houses` ENABLE KEYS */;

-- Structuur van  tabel hetdomein2.0.player_inventory-stash wordt geschreven
CREATE TABLE IF NOT EXISTS `player_inventory-stash` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stash` varchar(50) NOT NULL,
  `items` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1823 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel hetdomein2.0.player_inventory-stash: 5 rows
/*!40000 ALTER TABLE `player_inventory-stash` DISABLE KEYS */;
INSERT INTO `player_inventory-stash` (`id`, `stash`, `items`) VALUES
	(1819, 'warmtebak', '[]'),
	(1820, 'Container | 5188 | 3680 |', '[]'),
	(1821, 'personalsafe_FHB26658', '[]'),
	(1822, 'evidencestash_dafke', '[]'),
	(1818, 'foodtray1', '[]');
/*!40000 ALTER TABLE `player_inventory-stash` ENABLE KEYS */;

-- Structuur van  tabel hetdomein2.0.player_inventory-vehicle wordt geschreven
CREATE TABLE IF NOT EXISTS `player_inventory-vehicle` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plate` varchar(50) NOT NULL,
  `trunkitems` longtext DEFAULT NULL,
  `gloveboxitems` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=154 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel hetdomein2.0.player_inventory-vehicle: 0 rows
/*!40000 ALTER TABLE `player_inventory-vehicle` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_inventory-vehicle` ENABLE KEYS */;

-- Structuur van  tabel hetdomein2.0.player_mails wordt geschreven
CREATE TABLE IF NOT EXISTS `player_mails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `sender` varchar(50) DEFAULT NULL,
  `subject` varchar(50) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `read` tinytext DEFAULT NULL,
  `mailid` int(11) DEFAULT NULL,
  `date` timestamp NULL DEFAULT current_timestamp(),
  `button` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=238 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel hetdomein2.0.player_mails: 1 rows
/*!40000 ALTER TABLE `player_mails` DISABLE KEYS */;
INSERT INTO `player_mails` (`id`, `citizenid`, `sender`, `subject`, `message`, `read`, `mailid`, `date`, `button`) VALUES
	(237, 'OPK47724', 'Pillbox', 'Ziekenhuis Kosten', 'Beste mevrouw daf,<br /><br />Hierbij ontvangt u een e-mail met de kosten van het laatste ziekenhuis bezoek.<br />De uiteindelijke kosten zijn geworden: <strong>€500</strong><br /><br />Nog veel beterschap gewenst!', '0', 700412, '2021-08-17 14:12:13', '[]');
/*!40000 ALTER TABLE `player_mails` ENABLE KEYS */;

-- Structuur van  tabel hetdomein2.0.player_messages wordt geschreven
CREATE TABLE IF NOT EXISTS `player_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `number` varchar(50) DEFAULT NULL,
  `messages` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=259 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel hetdomein2.0.player_messages: 0 rows
/*!40000 ALTER TABLE `player_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_messages` ENABLE KEYS */;

-- Structuur van  tabel hetdomein2.0.player_metadata wordt geschreven
CREATE TABLE IF NOT EXISTS `player_metadata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `cid` int(11) DEFAULT NULL,
  `steam` varchar(50) DEFAULT NULL,
  `license` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `money` text DEFAULT NULL,
  `charinfo` text DEFAULT NULL,
  `job` tinytext DEFAULT NULL,
  `gang` tinytext DEFAULT NULL,
  `position` text DEFAULT NULL,
  `globals` text DEFAULT NULL,
  `inventory` varchar(65000) DEFAULT '[]',
  `ammo` text DEFAULT NULL,
  `licenses` text DEFAULT NULL,
  `skill` varchar(50) DEFAULT NULL,
  `addiction` varchar(50) DEFAULT NULL,
  `crafting_level` int(11) DEFAULT 0,
  `tattoos` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=MyISAM AUTO_INCREMENT=24 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel hetdomein2.0.player_metadata: 1 rows
/*!40000 ALTER TABLE `player_metadata` DISABLE KEYS */;
INSERT INTO `player_metadata` (`id`, `citizenid`, `cid`, `steam`, `license`, `name`, `money`, `charinfo`, `job`, `gang`, `position`, `globals`, `inventory`, `ammo`, `licenses`, `skill`, `addiction`, `crafting_level`, `tattoos`) VALUES
	(23, 'FHB26658', 1, 'steam:1100001377b6fdc', 'license:d0053e1b679f700179bbc79a8ffc38ed1616bb65', 'dafkeduck', '{"cash":1936.0,"bank":103998,"crypto":0}', '{"birthdate":"1988-03-30","account":"NL060376922846783","phone":"0639662000","firstname":"daf","gender":1,"nationality":"test","lastname":"test"}', '{"onduty":true,"plate":"none","name":"realestate","isboss":true,"serial":"GN758wEF878Sd345","grade":{"name":"Baas","level":1},"payment":100,"label":"Dynasty 8"}', 'null', '{"y":-1063.3946533203126,"z":29.39355278015136,"a":270.04010009765627,"x":346.8475036621094}', '{"tracker":false,"commandbinds":[],"bloodtype":"B-","duty-vehicles":{"Motor":false,"Unmarked":false,"Standard":false,"Audi":true,"Heli":false},"fingerprint":"FrCM030D94LHM3974","callsign":"NO CALLSIGN","favofrequentie":0,"craftingrep":0,"geduldrep":0,"jailtime":0,"gang":"none","leidinggevende":false,"thirst":100,"dealerrep":0,"medicalstate":false,"appartment-tier":1,"hackrep":0,"scraprep":0,"licences":{"driver":true},"armor":0,"health":200,"alcohol":0,"dienstnummer":"10-30","haircode":"Hvl598Zlf36FvY1774","ovrep":0,"adrenaline":0,"visrep":0,"plantagerep":0,"ishandcuffed":false,"stress":0,"lockpickrep":0,"stamina":100,"hunger":100,"inventorydisabled":false,"attachmentcraftingrep":0,"ishighcommand":true,"isdead":false,"appartment-data":{"Name":"apartment5","Id":"nE99AppartmentXQ48"},"jailitems":[],"phone":[],"slimecode":"SeP792by56eLR7853"}', '[{"slot":1,"amount":4,"type":"item","name":"red-card","info":[]},{"slot":2,"amount":4,"type":"item","name":"thermite","info":[]},{"slot":3,"amount":38,"type":"item","name":"lockpick","info":[]},{"slot":4,"amount":3,"type":"item","name":"purple-card","info":[]},{"slot":5,"amount":1,"type":"weapon","name":"weapon_bat","info":{"quality":100.0,"serie":"37qdQ9la984lfTg"}},{"slot":6,"amount":1,"type":"item","name":"radio","info":[]},{"slot":7,"amount":4,"type":"item","name":"blue-card","info":[]},{"slot":8,"amount":1,"type":"item","name":"note","info":{"label":"Kluis code: 8347"}},{"slot":9,"amount":8,"type":"item","name":"joint","info":[]},{"slot":10,"amount":2,"type":"item","name":"electronickit","info":[]},{"slot":11,"amount":1,"type":"item","name":"id-card","info":{"birthdate":"1988-03-30","lastname":"test","nationality":"test","gender":1,"firstname":"daf","citizenid":"FHB26658"}},{"slot":12,"amount":3,"type":"item","name":"gold-bar","info":""},{"slot":13,"amount":21,"type":"item","name":"gold-necklace","info":""},{"slot":14,"amount":1,"type":"item","name":"phone","info":[]},{"slot":15,"amount":3,"type":"item","name":"sandwich","info":[]},{"slot":16,"amount":1,"type":"item","name":"drill","info":[]},{"slot":17,"amount":1,"type":"item","name":"advancedlockpick","info":""},{"slot":18,"amount":1,"type":"item","name":"lockpick","info":[]},{"slot":19,"amount":1,"type":"item","name":"toolkit","info":[]},{"slot":20,"amount":3,"type":"item","name":"water","info":[]},{"slot":21,"amount":8,"type":"item","name":"gold-rolex","info":""},{"slot":22,"amount":1,"type":"item","name":"repairkit","info":[]},{"slot":23,"amount":2,"type":"item","name":"cleaningkit","info":[]},{"slot":25,"amount":1,"type":"item","name":"watertje","info":[]}]', NULL, NULL, NULL, NULL, 0, NULL);
/*!40000 ALTER TABLE `player_metadata` ENABLE KEYS */;

-- Structuur van  tabel hetdomein2.0.player_outfits wordt geschreven
CREATE TABLE IF NOT EXISTS `player_outfits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `outfitname` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `skin` text DEFAULT NULL,
  `outfitId` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=874 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel hetdomein2.0.player_outfits: 0 rows
/*!40000 ALTER TABLE `player_outfits` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_outfits` ENABLE KEYS */;

-- Structuur van  tabel hetdomein2.0.player_reputations wordt geschreven
CREATE TABLE IF NOT EXISTS `player_reputations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `job` text DEFAULT NULL,
  `dealer` text DEFAULT NULL,
  `crafting` text DEFAULT NULL,
  `handweaponcrafting` text DEFAULT NULL,
  `weaponcrafting` text DEFAULT NULL,
  `attachmentcrafting` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Dumpen data van tabel hetdomein2.0.player_reputations: 0 rows
/*!40000 ALTER TABLE `player_reputations` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_reputations` ENABLE KEYS */;

-- Structuur van  tabel hetdomein2.0.player_skins wordt geschreven
CREATE TABLE IF NOT EXISTS `player_skins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) NOT NULL DEFAULT '',
  `model` varchar(50) NOT NULL DEFAULT '0',
  `skin` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3512 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel hetdomein2.0.player_skins: 2 rows
/*!40000 ALTER TABLE `player_skins` DISABLE KEYS */;
INSERT INTO `player_skins` (`id`, `citizenid`, `model`, `skin`) VALUES
	(3511, 'FHB26658', '1520708641', '{"torso2":{"texture":0,"defaultTexture":0,"defaultItem":0,"item":0},"face":{"texture":0,"defaultTexture":0,"defaultItem":0,"item":0},"ear":{"texture":0,"defaultTexture":0,"defaultItem":-1,"item":-1},"lipstick":{"texture":1,"defaultTexture":1,"defaultItem":-1,"item":-1},"watch":{"texture":0,"defaultTexture":0,"defaultItem":-1,"item":-1},"ageing":{"texture":0,"defaultTexture":0,"defaultItem":-1,"item":-1},"eyebrows":{"texture":1,"defaultTexture":1,"defaultItem":-1,"item":-1},"makeup":{"texture":1,"defaultTexture":1,"defaultItem":-1,"item":-1},"hair":{"texture":0,"defaultTexture":0,"defaultItem":0,"item":0},"beard":{"texture":1,"defaultTexture":1,"defaultItem":-1,"item":-1},"decals":{"texture":0,"defaultTexture":0,"defaultItem":0,"item":0},"hat":{"texture":0,"defaultTexture":0,"defaultItem":-1,"item":-1},"bracelet":{"texture":0,"defaultTexture":0,"defaultItem":-1,"item":-1},"pants":{"texture":0,"defaultTexture":0,"defaultItem":0,"item":0},"arms":{"texture":0,"defaultTexture":0,"defaultItem":0,"item":0},"glass":{"texture":0,"defaultTexture":0,"defaultItem":0,"item":0},"shoes":{"texture":0,"defaultTexture":0,"defaultItem":1,"item":1},"accessory":{"texture":0,"defaultTexture":0,"defaultItem":0,"item":0},"bag":{"texture":0,"defaultTexture":0,"defaultItem":0,"item":0},"mask":{"texture":0,"defaultTexture":0,"defaultItem":0,"item":0},"vest":{"texture":0,"defaultTexture":0,"defaultItem":0,"item":0},"blush":{"texture":1,"defaultTexture":1,"defaultItem":-1,"item":-1},"t-shirt":{"texture":0,"defaultTexture":0,"defaultItem":1,"item":1}}'),
	(3510, 'OPK47724', '1520708641', '{"makeup":{"defaultTexture":1,"defaultItem":-1,"item":-1,"texture":1},"beard":{"defaultTexture":1,"defaultItem":-1,"item":-1,"texture":1},"lipstick":{"defaultTexture":1,"defaultItem":-1,"item":-1,"texture":1},"pants":{"defaultTexture":0,"defaultItem":0,"item":0,"texture":0},"t-shirt":{"defaultTexture":0,"defaultItem":1,"item":1,"texture":0},"bag":{"defaultTexture":0,"defaultItem":0,"item":0,"texture":0},"shoes":{"defaultTexture":0,"defaultItem":1,"item":1,"texture":0},"watch":{"defaultTexture":0,"defaultItem":-1,"item":-1,"texture":0},"blush":{"defaultTexture":1,"defaultItem":-1,"item":-1,"texture":1},"decals":{"defaultTexture":0,"defaultItem":0,"item":0,"texture":0},"mask":{"defaultTexture":0,"defaultItem":0,"item":0,"texture":0},"torso2":{"defaultTexture":0,"defaultItem":0,"item":0,"texture":0},"face":{"defaultTexture":0,"defaultItem":0,"item":0,"texture":0},"hair":{"defaultTexture":0,"defaultItem":0,"item":0,"texture":0},"ageing":{"defaultTexture":0,"defaultItem":-1,"item":-1,"texture":0},"vest":{"defaultTexture":0,"defaultItem":0,"item":0,"texture":0},"hat":{"defaultTexture":0,"defaultItem":-1,"item":-1,"texture":0},"accessory":{"defaultTexture":0,"defaultItem":0,"item":0,"texture":0},"bracelet":{"defaultTexture":0,"defaultItem":-1,"item":-1,"texture":0},"ear":{"defaultTexture":0,"defaultItem":-1,"item":-1,"texture":0},"glass":{"defaultTexture":0,"defaultItem":0,"item":0,"texture":0},"arms":{"defaultTexture":0,"defaultItem":0,"item":0,"texture":0},"eyebrows":{"defaultTexture":1,"defaultItem":-1,"item":-1,"texture":1}}');
/*!40000 ALTER TABLE `player_skins` ENABLE KEYS */;

-- Structuur van  tabel hetdomein2.0.player_tattoos wordt geschreven
CREATE TABLE IF NOT EXISTS `player_tattoos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` longtext NOT NULL DEFAULT '0',
  `tattoos` longtext NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;

-- Dumpen data van tabel hetdomein2.0.player_tattoos: ~1 rows (ongeveer)
/*!40000 ALTER TABLE `player_tattoos` DISABLE KEYS */;
INSERT INTO `player_tattoos` (`id`, `citizenid`, `tattoos`) VALUES
	(9, 'OPK47724', '{}');
/*!40000 ALTER TABLE `player_tattoos` ENABLE KEYS */;

-- Structuur van  tabel hetdomein2.0.player_vehicles wordt geschreven
CREATE TABLE IF NOT EXISTS `player_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `vehicle` varchar(50) DEFAULT NULL,
  `plate` varchar(50) DEFAULT NULL,
  `garage` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `mods` text DEFAULT NULL,
  `metadata` mediumtext DEFAULT NULL,
  `forSale` int(11) DEFAULT 0,
  `salePrice` int(11) DEFAULT 0,
  `depotprice` int(11) DEFAULT 100,
  `drivingdistance` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=243 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel hetdomein2.0.player_vehicles: 1 rows
/*!40000 ALTER TABLE `player_vehicles` DISABLE KEYS */;
INSERT INTO `player_vehicles` (`id`, `citizenid`, `vehicle`, `plate`, `garage`, `state`, `mods`, `metadata`, `forSale`, `salePrice`, `depotprice`, `drivingdistance`) VALUES
	(242, 'OPK47724', 'stryder', '7UB783YO', 'Legion Parking', 'in', '{}', '{"Fuel":87,"Engine":1000.0,"Body":1000.0}', 0, 0, 100, 0);
/*!40000 ALTER TABLE `player_vehicles` ENABLE KEYS */;

-- Structuur van  tabel hetdomein2.0.server_bans wordt geschreven
CREATE TABLE IF NOT EXISTS `server_bans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `steam` varchar(50) DEFAULT NULL,
  `license` varchar(50) DEFAULT NULL,
  `reason` varchar(100) DEFAULT NULL,
  `bannedby` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=48 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel hetdomein2.0.server_bans: 0 rows
/*!40000 ALTER TABLE `server_bans` DISABLE KEYS */;
/*!40000 ALTER TABLE `server_bans` ENABLE KEYS */;

-- Structuur van  tabel hetdomein2.0.server_extra wordt geschreven
CREATE TABLE IF NOT EXISTS `server_extra` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `steam` varchar(50) DEFAULT NULL,
  `license` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `permission` varchar(50) DEFAULT 'user',
  `priority` int(11) DEFAULT 2,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=28 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel hetdomein2.0.server_extra: 1 rows
/*!40000 ALTER TABLE `server_extra` DISABLE KEYS */;
INSERT INTO `server_extra` (`id`, `steam`, `license`, `name`, `permission`, `priority`) VALUES
	(1, 'steam:1100001377b6fdc', 'license:d0053e1b679f700179bbc79a8ffc38ed1616bb65', 'dafkeduck', 'god', 100);
/*!40000 ALTER TABLE `server_extra` ENABLE KEYS */;

-- Structuur van  tabel hetdomein2.0.server_lapraces wordt geschreven
CREATE TABLE IF NOT EXISTS `server_lapraces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `checkpoints` text DEFAULT NULL,
  `records` text DEFAULT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `distance` int(11) DEFAULT NULL,
  `raceid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4;

-- Dumpen data van tabel hetdomein2.0.server_lapraces: ~0 rows (ongeveer)
/*!40000 ALTER TABLE `server_lapraces` DISABLE KEYS */;
/*!40000 ALTER TABLE `server_lapraces` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
