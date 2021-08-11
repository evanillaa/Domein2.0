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
) ENGINE=MyISAM AUTO_INCREMENT=54 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel hetdomein2.0.player_houses: 0 rows
/*!40000 ALTER TABLE `player_houses` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_houses` ENABLE KEYS */;

-- Structuur van  tabel hetdomein2.0.player_inventory-stash wordt geschreven
CREATE TABLE IF NOT EXISTS `player_inventory-stash` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stash` varchar(50) NOT NULL,
  `items` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1818 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel hetdomein2.0.player_inventory-stash: 0 rows
/*!40000 ALTER TABLE `player_inventory-stash` DISABLE KEYS */;
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
) ENGINE=MyISAM AUTO_INCREMENT=237 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel hetdomein2.0.player_mails: 0 rows
/*!40000 ALTER TABLE `player_mails` DISABLE KEYS */;
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
) ENGINE=MyISAM AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel hetdomein2.0.player_metadata: 0 rows
/*!40000 ALTER TABLE `player_metadata` DISABLE KEYS */;
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
) ENGINE=MyISAM AUTO_INCREMENT=3510 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel hetdomein2.0.player_skins: 0 rows
/*!40000 ALTER TABLE `player_skins` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_skins` ENABLE KEYS */;

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
) ENGINE=MyISAM AUTO_INCREMENT=242 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel hetdomein2.0.player_vehicles: 0 rows
/*!40000 ALTER TABLE `player_vehicles` DISABLE KEYS */;
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
