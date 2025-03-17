/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

DROP DATABASE IF EXISTS `database`;
CREATE DATABASE IF NOT EXISTS `database` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;
USE `database`;

DROP TABLE IF EXISTS `accounts`;
CREATE TABLE IF NOT EXISTS `accounts` (
  `id` int(10) unsigned NOT NULL,
  `label` varchar(50) NOT NULL,
  `owner` int(10) unsigned DEFAULT NULL,
  `group` varchar(20) DEFAULT NULL,
  `balance` int(11) NOT NULL DEFAULT 0,
  `isDefault` tinyint(1) NOT NULL DEFAULT 0,
  `type` enum('personal','shared','group','inactive') NOT NULL DEFAULT 'personal',
  PRIMARY KEY (`id`),
  KEY `accounts_group_fk` (`group`),
  KEY `accounts_owner_fk` (`owner`),
  FULLTEXT KEY `accounts_label_index` (`label`),
  CONSTRAINT `accounts_group_fk` FOREIGN KEY (`group`) REFERENCES `ox_groups` (`name`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `accounts_owner_fk` FOREIGN KEY (`owner`) REFERENCES `characters` (`charId`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `accounts_access`;
CREATE TABLE IF NOT EXISTS `accounts_access` (
  `accountId` int(10) unsigned NOT NULL,
  `charId` int(10) unsigned NOT NULL,
  `role` varchar(50) NOT NULL DEFAULT 'viewer',
  PRIMARY KEY (`accountId`,`charId`),
  KEY `accounts_access_charId_fk` (`charId`),
  KEY `FK_accounts_access_account_roles` (`role`),
  CONSTRAINT `FK_accounts_access_account_roles` FOREIGN KEY (`role`) REFERENCES `account_roles` (`name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `accounts_access_accountId_fk` FOREIGN KEY (`accountId`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `accounts_access_charId_fk` FOREIGN KEY (`charId`) REFERENCES `characters` (`charId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `accounts_invoices`;
CREATE TABLE IF NOT EXISTS `accounts_invoices` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `actorId` int(10) unsigned DEFAULT NULL,
  `payerId` int(10) unsigned DEFAULT NULL,
  `fromAccount` int(10) unsigned NOT NULL,
  `toAccount` int(10) unsigned NOT NULL,
  `amount` int(10) unsigned NOT NULL,
  `message` varchar(255) DEFAULT NULL,
  `sentAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `dueDate` timestamp NOT NULL,
  `paidAt` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `accounts_invoices_accounts_id_fk` (`fromAccount`),
  KEY `accounts_invoices_accounts_id_fk_2` (`toAccount`),
  KEY `accounts_invoices_characters_charId_fk` (`payerId`),
  KEY `accounts_invoices_characters_charId_fk_2` (`actorId`),
  FULLTEXT KEY `idx_message_fulltext` (`message`),
  CONSTRAINT `accounts_invoices_accounts_id_fk` FOREIGN KEY (`fromAccount`) REFERENCES `accounts` (`id`),
  CONSTRAINT `accounts_invoices_accounts_id_fk_2` FOREIGN KEY (`toAccount`) REFERENCES `accounts` (`id`),
  CONSTRAINT `accounts_invoices_characters_charId_fk` FOREIGN KEY (`payerId`) REFERENCES `characters` (`charId`),
  CONSTRAINT `accounts_invoices_characters_charId_fk_2` FOREIGN KEY (`actorId`) REFERENCES `characters` (`charId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `accounts_transactions`;
CREATE TABLE IF NOT EXISTS `accounts_transactions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `actorId` int(10) unsigned DEFAULT NULL,
  `fromId` int(10) unsigned DEFAULT NULL,
  `toId` int(10) unsigned DEFAULT NULL,
  `amount` int(11) NOT NULL,
  `message` varchar(255) NOT NULL,
  `note` varchar(255) DEFAULT NULL,
  `fromBalance` int(11) DEFAULT NULL,
  `toBalance` int(11) DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `accounts_transactions_actorId_fk` (`actorId`),
  KEY `accounts_transactions_fromId_fk` (`fromId`),
  KEY `accounts_transactions_toId_fk` (`toId`),
  FULLTEXT KEY `accounts_transactions_message_index` (`message`),
  CONSTRAINT `accounts_transactions_actorId_fk` FOREIGN KEY (`actorId`) REFERENCES `characters` (`charId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `accounts_transactions_fromId_fk` FOREIGN KEY (`fromId`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `accounts_transactions_toId_fk` FOREIGN KEY (`toId`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `account_roles`;
CREATE TABLE IF NOT EXISTS `account_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `deposit` tinyint(1) NOT NULL DEFAULT 0,
  `withdraw` tinyint(1) NOT NULL DEFAULT 0,
  `addUser` tinyint(1) NOT NULL DEFAULT 0,
  `removeUser` tinyint(1) NOT NULL DEFAULT 0,
  `manageUser` tinyint(1) NOT NULL DEFAULT 0,
  `transferOwnership` tinyint(1) NOT NULL DEFAULT 0,
  `viewHistory` tinyint(1) NOT NULL DEFAULT 0,
  `manageAccount` tinyint(1) NOT NULL DEFAULT 0,
  `closeAccount` tinyint(1) NOT NULL DEFAULT 0,
  `sendInvoice` tinyint(1) NOT NULL DEFAULT 0,
  `payInvoice` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `account_roles` (`id`, `name`, `deposit`, `withdraw`, `addUser`, `removeUser`, `manageUser`, `transferOwnership`, `viewHistory`, `manageAccount`, `closeAccount`, `sendInvoice`, `payInvoice`) VALUES
	(1, 'viewer', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(2, 'contributor', 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(3, 'manager', 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1),
	(4, 'owner', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);

DROP TABLE IF EXISTS `characters`;
CREATE TABLE IF NOT EXISTS `characters` (
  `charId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `userId` int(10) unsigned NOT NULL,
  `stateId` varchar(7) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `fullName` varchar(101) GENERATED ALWAYS AS (concat(`firstName`,' ',`lastName`)) STORED,
  `gender` varchar(10) NOT NULL,
  `dateOfBirth` date NOT NULL,
  `phoneNumber` varchar(20) DEFAULT NULL,
  `lastPlayed` datetime NOT NULL DEFAULT current_timestamp(),
  `isDead` tinyint(1) NOT NULL DEFAULT 0,
  `x` float DEFAULT NULL,
  `y` float DEFAULT NULL,
  `z` float DEFAULT NULL,
  `heading` float DEFAULT NULL,
  `health` tinyint(3) unsigned DEFAULT NULL,
  `armour` tinyint(3) unsigned DEFAULT NULL,
  `statuses` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT json_object() CHECK (json_valid(`statuses`)),
  `deleted` date DEFAULT NULL,
  PRIMARY KEY (`charId`),
  UNIQUE KEY `characters_stateId_unique` (`stateId`),
  KEY `characters_userId_key` (`userId`),
  FULLTEXT KEY `characters_fullName_index` (`fullName`),
  CONSTRAINT `characters_userId_fk` FOREIGN KEY (`userId`) REFERENCES `users` (`userId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `character_groups`;
CREATE TABLE IF NOT EXISTS `character_groups` (
  `charId` int(10) unsigned NOT NULL,
  `name` varchar(20) NOT NULL,
  `grade` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `isActive` tinyint(1) NOT NULL DEFAULT 0,
  UNIQUE KEY `name` (`name`,`charId`),
  KEY `character_groups_charId_key` (`charId`),
  CONSTRAINT `character_groups_charId_fk` FOREIGN KEY (`charId`) REFERENCES `characters` (`charId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `character_groups_name_fk` FOREIGN KEY (`name`) REFERENCES `ox_groups` (`name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `character_inventory`;
CREATE TABLE IF NOT EXISTS `character_inventory` (
  `charId` int(10) unsigned NOT NULL,
  `inventory` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`inventory`)),
  PRIMARY KEY (`charId`),
  KEY `character_inventory_charId_key` (`charId`),
  CONSTRAINT `character_inventory_charId_fk` FOREIGN KEY (`charId`) REFERENCES `characters` (`charId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `character_licenses`;
CREATE TABLE IF NOT EXISTS `character_licenses` (
  `charId` int(10) unsigned NOT NULL,
  `name` varchar(20) DEFAULT NULL,
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT json_object() CHECK (json_valid(`data`)),
  UNIQUE KEY `name` (`name`,`charId`),
  KEY `character_licenses_charId_key` (`charId`),
  CONSTRAINT `character_licenses_charId_fk` FOREIGN KEY (`charId`) REFERENCES `characters` (`charId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `management_outfits`;
CREATE TABLE IF NOT EXISTS `management_outfits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job_name` varchar(50) NOT NULL,
  `type` varchar(50) NOT NULL,
  `minrank` int(11) NOT NULL DEFAULT 0,
  `name` varchar(50) NOT NULL DEFAULT 'Cool Outfit',
  `gender` varchar(50) NOT NULL DEFAULT 'male',
  `model` varchar(50) DEFAULT NULL,
  `props` varchar(1000) DEFAULT NULL,
  `components` varchar(1500) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `npwd_calls`;
CREATE TABLE IF NOT EXISTS `npwd_calls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `transmitter` varchar(255) NOT NULL,
  `receiver` varchar(255) NOT NULL,
  `is_accepted` tinyint(4) DEFAULT 0,
  `isAnonymous` tinyint(4) NOT NULL DEFAULT 0,
  `start` varchar(255) DEFAULT NULL,
  `end` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `npwd_darkchat_channels`;
CREATE TABLE IF NOT EXISTS `npwd_darkchat_channels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `channel_identifier` varchar(191) NOT NULL,
  `label` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `darkchat_channels_channel_identifier_uindex` (`channel_identifier`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `npwd_darkchat_channel_members`;
CREATE TABLE IF NOT EXISTS `npwd_darkchat_channel_members` (
  `channel_id` int(11) NOT NULL,
  `user_identifier` varchar(255) NOT NULL,
  `is_owner` tinyint(4) NOT NULL DEFAULT 0,
  KEY `npwd_darkchat_channel_members_npwd_darkchat_channels_id_fk` (`channel_id`) USING BTREE,
  CONSTRAINT `npwd_darkchat_channel_members_npwd_darkchat_channels_id_fk` FOREIGN KEY (`channel_id`) REFERENCES `npwd_darkchat_channels` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `npwd_darkchat_messages`;
CREATE TABLE IF NOT EXISTS `npwd_darkchat_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `channel_id` int(11) NOT NULL,
  `message` varchar(255) NOT NULL,
  `user_identifier` varchar(255) NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_image` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `darkchat_messages_darkchat_channels_id_fk` (`channel_id`) USING BTREE,
  CONSTRAINT `darkchat_messages_darkchat_channels_id_fk` FOREIGN KEY (`channel_id`) REFERENCES `npwd_darkchat_channels` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `npwd_marketplace_listings`;
CREATE TABLE IF NOT EXISTS `npwd_marketplace_listings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `number` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `description` varchar(255) NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `reported` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `npwd_match_profiles`;
CREATE TABLE IF NOT EXISTS `npwd_match_profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(90) NOT NULL,
  `image` varchar(255) NOT NULL,
  `bio` varchar(512) DEFAULT NULL,
  `location` varchar(45) DEFAULT NULL,
  `job` varchar(45) DEFAULT NULL,
  `tags` varchar(255) NOT NULL DEFAULT '',
  `voiceMessage` varchar(512) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `identifier_UNIQUE` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `npwd_match_views`;
CREATE TABLE IF NOT EXISTS `npwd_match_views` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `profile` int(11) NOT NULL,
  `liked` tinyint(4) DEFAULT 0,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `match_profile_idx` (`profile`),
  KEY `identifier` (`identifier`),
  CONSTRAINT `match_profile` FOREIGN KEY (`profile`) REFERENCES `npwd_match_profiles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `npwd_messages`;
CREATE TABLE IF NOT EXISTS `npwd_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `user_identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `conversation_id` varchar(512) NOT NULL,
  `isRead` tinyint(4) NOT NULL DEFAULT 0,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `visible` tinyint(4) NOT NULL DEFAULT 1,
  `author` varchar(255) NOT NULL,
  `is_embed` tinyint(4) NOT NULL DEFAULT 0,
  `embed` varchar(512) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `user_identifier` (`user_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `npwd_messages_conversations`;
CREATE TABLE IF NOT EXISTS `npwd_messages_conversations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `conversation_list` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `label` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '',
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_message_id` int(11) DEFAULT NULL,
  `is_group_chat` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `npwd_messages_participants`;
CREATE TABLE IF NOT EXISTS `npwd_messages_participants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `conversation_id` int(11) NOT NULL,
  `participant` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `unread_count` int(11) DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `message_participants_npwd_messages_conversations_id_fk` (`conversation_id`) USING BTREE,
  CONSTRAINT `message_participants_npwd_messages_conversations_id_fk` FOREIGN KEY (`conversation_id`) REFERENCES `npwd_messages_conversations` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `npwd_notes`;
CREATE TABLE IF NOT EXISTS `npwd_notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `npwd_phone_contacts`;
CREATE TABLE IF NOT EXISTS `npwd_phone_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `number` varchar(20) DEFAULT NULL,
  `display` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `npwd_phone_gallery`;
CREATE TABLE IF NOT EXISTS `npwd_phone_gallery` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `image` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `npwd_twitter_likes`;
CREATE TABLE IF NOT EXISTS `npwd_twitter_likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) NOT NULL,
  `tweet_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_combination` (`profile_id`,`tweet_id`),
  KEY `profile_idx` (`profile_id`),
  KEY `tweet_idx` (`tweet_id`),
  CONSTRAINT `profile` FOREIGN KEY (`profile_id`) REFERENCES `npwd_twitter_profiles` (`id`),
  CONSTRAINT `tweet` FOREIGN KEY (`tweet_id`) REFERENCES `npwd_twitter_tweets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `npwd_twitter_profiles`;
CREATE TABLE IF NOT EXISTS `npwd_twitter_profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_name` varchar(90) NOT NULL,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `avatar_url` varchar(255) DEFAULT 'https://i.fivemanage.com/images/3ClWwmpwkFhL.png',
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `profile_name_UNIQUE` (`profile_name`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `npwd_twitter_reports`;
CREATE TABLE IF NOT EXISTS `npwd_twitter_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) NOT NULL,
  `tweet_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_combination` (`profile_id`,`tweet_id`),
  KEY `profile_idx` (`profile_id`),
  KEY `tweet_idx` (`tweet_id`),
  CONSTRAINT `report_profile` FOREIGN KEY (`profile_id`) REFERENCES `npwd_twitter_profiles` (`id`),
  CONSTRAINT `report_tweet` FOREIGN KEY (`tweet_id`) REFERENCES `npwd_twitter_tweets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `npwd_twitter_tweets`;
CREATE TABLE IF NOT EXISTS `npwd_twitter_tweets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `likes` int(11) NOT NULL DEFAULT 0,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `visible` tinyint(4) NOT NULL DEFAULT 1,
  `images` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '',
  `retweet` int(11) DEFAULT NULL,
  `profile_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `npwd_twitter_tweets_npwd_twitter_profiles_id_fk` (`profile_id`) USING BTREE,
  CONSTRAINT `npwd_twitter_tweets_npwd_twitter_profiles_id_fk` FOREIGN KEY (`profile_id`) REFERENCES `npwd_twitter_profiles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `ox_doorlock`;
CREATE TABLE IF NOT EXISTS `ox_doorlock` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `data` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `ox_doorlock` (`id`, `name`, `data`) VALUES
	(1, 'mrpd locker rooms', '{"maxDistance":2,"heading":90,"coords":{"x":450.1041259765625,"y":-985.7384033203125,"z":30.83930206298828},"groups":{"police":0},"state":1,"model":1557126584,"hideUi":false}'),
	(2, 'mrpd cells/briefing', '{"maxDistance":2,"coords":{"x":444.7078552246094,"y":-989.4454345703125,"z":30.83930206298828},"doors":[{"model":185711165,"coords":{"x":446.0079345703125,"y":-989.4454345703125,"z":30.83930206298828},"heading":0},{"model":185711165,"coords":{"x":443.40777587890627,"y":-989.4454345703125,"z":30.83930206298828},"heading":180}],"groups":{"police":0},"state":1,"hideUi":false}'),
	(3, 'mrpd cell 3', '{"maxDistance":2,"heading":90,"coords":{"x":461.8065185546875,"y":-1001.9515380859375,"z":25.06442832946777},"lockSound":"metal-locker","groups":{"police":0},"state":1,"unlockSound":"metallic-creak","model":631614199,"hideUi":false}'),
	(4, 'mrpd back entrance', '{"maxDistance":2,"coords":{"x":468.6697692871094,"y":-1014.4520263671875,"z":26.5362319946289},"doors":[{"model":-2023754432,"coords":{"x":467.37164306640627,"y":-1014.4520263671875,"z":26.5362319946289},"heading":0},{"model":-2023754432,"coords":{"x":469.9678955078125,"y":-1014.4520263671875,"z":26.5362319946289},"heading":180}],"groups":{"police":0},"state":1,"hideUi":false}'),
	(5, 'mrpd cells security door', '{"maxDistance":2,"heading":0,"coords":{"x":464.1282958984375,"y":-1003.5386962890625,"z":25.00598907470703},"autolock":5,"groups":{"police":0},"state":1,"model":-1033001619,"hideUi":false}'),
	(6, 'mrpd cell 2', '{"maxDistance":2,"heading":90,"coords":{"x":461.8064880371094,"y":-998.3082885742188,"z":25.06442832946777},"lockSound":"metal-locker","groups":{"police":0},"state":1,"unlockSound":"metallic-creak","model":631614199,"hideUi":false}'),
	(7, 'mrpd captain\'s office', '{"maxDistance":2,"heading":180,"coords":{"x":446.57281494140627,"y":-980.0105590820313,"z":30.83930206298828},"groups":{"police":0},"state":1,"model":-1320876379,"hideUi":false}'),
	(8, 'mrpd gate', '{"maxDistance":6,"heading":90,"coords":{"x":488.894775390625,"y":-1017.2102661132813,"z":27.14714050292968},"groups":{"police":0},"auto":true,"state":1,"model":-1603817716,"hideUi":false}'),
	(9, 'mrpd cell 1', '{"maxDistance":2,"heading":270,"coords":{"x":461.8065185546875,"y":-993.7586059570313,"z":25.06442832946777},"lockSound":"metal-locker","groups":{"police":0},"state":1,"unlockSound":"metallic-creak","model":631614199,"hideUi":false}'),
	(10, 'mrpd cells main', '{"maxDistance":2,"heading":360,"coords":{"x":463.92010498046877,"y":-992.6640625,"z":25.06442832946777},"lockSound":"metal-locker","groups":{"police":0},"state":1,"unlockSound":"metallic-creak","model":631614199,"hideUi":false}'),
	(11, 'mrpd armoury', '{"maxDistance":2,"heading":270,"coords":{"x":453.08428955078127,"y":-982.5794677734375,"z":30.81926536560058},"autolock":5,"groups":{"police":0},"state":1,"model":749848321,"hideUi":false}');

DROP TABLE IF EXISTS `ox_groups`;
CREATE TABLE IF NOT EXISTS `ox_groups` (
  `name` varchar(20) NOT NULL,
  `label` varchar(50) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `colour` tinyint(3) unsigned DEFAULT NULL,
  `hasAccount` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `ox_group_grades`;
CREATE TABLE IF NOT EXISTS `ox_group_grades` (
  `group` varchar(20) NOT NULL,
  `grade` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `label` varchar(50) NOT NULL,
  `accountRole` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`group`,`grade`),
  KEY `FK_ox_group_grades_account_roles` (`accountRole`),
  CONSTRAINT `FK_ox_group_grades_account_roles` FOREIGN KEY (`accountRole`) REFERENCES `account_roles` (`name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ox_group_grades_group_fk` FOREIGN KEY (`group`) REFERENCES `ox_groups` (`name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `ox_inventory`;
CREATE TABLE IF NOT EXISTS `ox_inventory` (
  `owner` varchar(60) DEFAULT NULL,
  `name` varchar(60) NOT NULL,
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`data`)),
  `lastupdated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  UNIQUE KEY `owner` (`owner`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `ox_licenses`;
CREATE TABLE IF NOT EXISTS `ox_licenses` (
  `name` varchar(20) NOT NULL,
  `label` varchar(50) NOT NULL,
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `ox_licenses` (`name`, `label`) VALUES
	('driver', 'Driver\'s License'),
	('weapon', 'Weapon License');

DROP TABLE IF EXISTS `ox_mdt_announcements`;
CREATE TABLE IF NOT EXISTS `ox_mdt_announcements` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `creator` varchar(7) NOT NULL,
  `contents` text NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT curtime(),
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK_ox_mdt_announcements_characters` (`creator`) USING BTREE,
  CONSTRAINT `FK_ox_mdt_announcements_characters` FOREIGN KEY (`creator`) REFERENCES `characters` (`stateId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `ox_mdt_bolos`;
CREATE TABLE IF NOT EXISTS `ox_mdt_bolos` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `creator` varchar(7) NOT NULL,
  `contents` text DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT curtime(),
  PRIMARY KEY (`id`),
  KEY `ox_mdt_bolos_ox_mdt_profiles_stateid_fk` (`creator`),
  CONSTRAINT `ox_mdt_bolos_ox_mdt_profiles_stateid_fk` FOREIGN KEY (`creator`) REFERENCES `ox_mdt_profiles` (`stateid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `ox_mdt_bolos_images`;
CREATE TABLE IF NOT EXISTS `ox_mdt_bolos_images` (
  `boloId` int(10) unsigned NOT NULL,
  `image` varchar(90) DEFAULT NULL,
  KEY `ox_mdt_bolos_images_ox_mdt_bolos_id_fk` (`boloId`),
  CONSTRAINT `ox_mdt_bolos_images_ox_mdt_bolos_id_fk` FOREIGN KEY (`boloId`) REFERENCES `ox_mdt_bolos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `ox_mdt_offenses`;
CREATE TABLE IF NOT EXISTS `ox_mdt_offenses` (
  `label` varchar(100) NOT NULL,
  `type` enum('misdemeanor','felony','infraction') NOT NULL,
  `category` enum('OFFENSES AGAINST PERSONS','OFFENSES INVOLVING THEFT','OFFENSES INVOLVING FRAUD','OFFENSES INVOLVING DAMAGE TO PROPERTY','OFFENSES AGAINST PUBLIC ADMINISTRATION','OFFENSES AGAINST PUBLIC ORDER','OFFENSES AGAINST HEALTH AND MORALS','OFFENSES AGAINST PUBLIC SAFETY','OFFENSES INVOLVING THE OPERATION OF A VEHICLE','OFFENSES INVOLVING THE WELL-BEING OF WILDLIFE') NOT NULL,
  `description` varchar(250) NOT NULL,
  `time` int(10) unsigned NOT NULL DEFAULT 0,
  `fine` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`label`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `ox_mdt_offenses` (`label`, `type`, `category`, `description`, `time`, `fine`) VALUES
	('Accessory to Armed Robbery', 'felony', 'OFFENSES INVOLVING THEFT', 'Person who is present at the scene of an armed robbery and aids or abets the robbery', 15, 1500),
	('Accessory to First Degree Murder', 'felony', 'OFFENSES AGAINST PERSONS', 'One who, before or during the commission of a murder, aids or abets the murderer in the planning or commission of the crime.', 75, 10000),
	('Accessory to Hostage Taking', 'felony', 'OFFENSES AGAINST PERSONS', 'One who, after a hostage taking has been committed, assists the hostage taker in avoiding or escaping punishment.', 10, 600),
	('Accessory to Jailbreak', 'felony', 'OFFENSES AGAINST PUBLIC ADMINISTRATION', 'Assisting in the escape of a prisoner from custody.', 25, 2000),
	('Accessory to Kidnapping', 'felony', 'OFFENSES AGAINST PERSONS', 'One who, after a kidnapping has been committed, assists the kidnapper in avoiding or escaping punishment.', 7, 450),
	('Accessory to Robbery', 'felony', 'OFFENSES INVOLVING THEFT', 'Person who is present at the scene of a robbery and aids or abets the robbery', 12, 1000),
	('Accessory to Second Degree Murder', 'felony', 'OFFENSES AGAINST PERSONS', 'One who, after a murder has been committed, assists the murderer in avoiding or escaping punishment.', 50, 5000),
	('Accessory to the Murder of a Public Servant or Peace Officer', 'felony', 'OFFENSES AGAINST PERSONS', 'One who, after the murder of a public servant or peace officer, assists the murderer in avoiding or escaping punishment.', 75, 10000),
	('Aggravated Assault', 'felony', 'OFFENSES AGAINST PERSONS', 'The unlawful intentional application of force to the person of another, with the intent to cause serious bodily injury or death.', 20, 1250),
	('Aiding and Abetting', 'misdemeanor', 'OFFENSES AGAINST PUBLIC ORDER', 'Assisting or encouraging another person to commit a crime.', 15, 450),
	('Animal Cruelty', 'misdemeanor', 'OFFENSES INVOLVING THE WELL-BEING OF WILDLIFE', 'Willfully and intentionally causing pain, suffering, or death to an animal.', 0, 450),
	('Anti-Mask Law', 'infraction', 'OFFENSES AGAINST PUBLIC ADMINISTRATION', 'Failing to wear a mask in a public place, as required by law.', 0, 750),
	('Armed Robbery', 'felony', 'OFFENSES INVOLVING THEFT', 'Robbery with a dangerous weapon', 30, 3000),
	('Arson', 'felony', 'OFFENSES INVOLVING DAMAGE TO PROPERTY', 'Intentionally setting fire to property, with the intent to destroy or damage it.', 15, 1500),
	('Assault', 'misdemeanor', 'OFFENSES AGAINST PERSONS', 'The unlawful intentional application of force to the person of another, without his or her consent, that causes significant injury.', 15, 850),
	('Assault with a Deadly Weapon', 'felony', 'OFFENSES AGAINST PERSONS', 'The unlawful intentional application of force to the person of another, with the use of a deadly weapon.', 30, 3750),
	('Attempted Armed Robbery', 'felony', 'OFFENSES INVOLVING THEFT', 'Attempted robbery with a dangerous weapon', 25, 1500),
	('Attempted Jailbreak', 'felony', 'OFFENSES AGAINST PUBLIC ADMINISTRATION', 'The unsuccessful attempt to escape from a prison or other secure facility.', 20, 1500),
	('Attempted Kidnapping', 'felony', 'OFFENSES AGAINST PERSONS', 'An intentional, but unsuccessful, act to kidnap another person.', 10, 450),
	('Attempted Murder of a Civilian', 'felony', 'OFFENSES AGAINST PERSONS', 'An intentional, but unsuccessful, act to kill another person.', 50, 7500),
	('Attempted Murder of a Public Servant or Peace Officer', 'felony', 'OFFENSES AGAINST PERSONS', 'An intentional, but unsuccessful, act to kill a public servant or peace officer, while such person is engaged in the performance of his or her official duties.', 65, 10000),
	('Attempted Robbery', 'felony', 'OFFENSES INVOLVING THEFT', 'Attempted robbery', 20, 1000),
	('Brandishing a Weapon', 'misdemeanor', 'OFFENSES AGAINST PUBLIC SAFETY', 'Exposing a weapon in a threatening manner, such as by drawing it in public or waving it around.', 0, 500),
	('Bribery of a Government Official', 'felony', 'OFFENSES AGAINST PUBLIC ADMINISTRATION', 'Offering or giving something of value to a government official in exchange for official action.', 20, 3500),
	('Burglary', 'misdemeanor', 'OFFENSES INVOLVING THEFT', 'Theft of property from a building', 10, 500),
	('Cannibalism', 'felony', 'OFFENSES AGAINST PERSONS', 'The intentional killing and consumption of the flesh of another human being.', 180, 30000),
	('Carjacking', 'felony', 'OFFENSES INVOLVING THEFT', 'Theft of a motor vehicle by force or violence', 30, 2000),
	('Conspiracy', 'misdemeanor', 'OFFENSES AGAINST PUBLIC ADMINISTRATION', 'The agreement between two or more people to commit a crime.', 10, 450),
	('Contempt of Court', 'felony', 'OFFENSES AGAINST PUBLIC ADMINISTRATION', 'Willfully disobeying a court order or disrupting a court proceeding.', 40, 3000),
	('Criminal Possession of Stolen Property', 'misdemeanor', 'OFFENSES AGAINST PUBLIC ADMINISTRATION', 'Knowingly possessing property that has been stolen.', 10, 500),
	('Criminal Possession of Weapon Class A', 'felony', 'OFFENSES AGAINST PUBLIC SAFETY', 'Possession of a Class A weapon, such as a machine gun, assault rifle, or destructive device.', 0, 500),
	('Criminal Possession of Weapon Class B', 'felony', 'OFFENSES AGAINST PUBLIC SAFETY', 'Possession of a Class B weapon, such as a sawed-off shotgun, handgun, or large-capacity magazine.', 0, 1000),
	('Criminal Possession of Weapon Class C', 'felony', 'OFFENSES AGAINST PUBLIC SAFETY', 'Possession of a Class C weapon, such as a rifle, shotgun, or ammunition.', 0, 3500),
	('Criminal Possession of Weapon Class D', 'felony', 'OFFENSES AGAINST PUBLIC SAFETY', 'Possession of a Class D weapon, such as a knife, club, or brass knuckles.', 0, 1500),
	('Criminal Sale of Weapon Class A', 'felony', 'OFFENSES AGAINST PUBLIC SAFETY', 'Sale of a Class A weapon to a prohibited person.', 0, 1000),
	('Criminal Sale of Weapon Class B', 'felony', 'OFFENSES AGAINST PUBLIC SAFETY', 'Sale of a Class B weapon to a prohibited person.', 0, 2000),
	('Criminal Sale of Weapon Class C', 'felony', 'OFFENSES AGAINST PUBLIC SAFETY', 'Sale of a Class C weapon to a prohibited person.', 0, 7000),
	('Criminal Sale of Weapon Class D', 'felony', 'OFFENSES AGAINST PUBLIC SAFETY', 'Sale of a Class D weapon to a prohibited person.', 0, 3000),
	('Criminal Threats', 'misdemeanor', 'OFFENSES AGAINST PERSONS', 'The intentional or reckless communication of a threat to cause death or serious bodily harm to another person.', 5, 500),
	('Criminal Use of Explosives', 'felony', 'OFFENSES AGAINST PUBLIC SAFETY', 'Use of explosives in a dangerous or threatening manner, such as by setting off a bomb or throwing a firecracker at someone.', 0, 2500),
	('Criminal Use of Weapon', 'misdemeanor', 'OFFENSES AGAINST PUBLIC SAFETY', 'Use of a weapon in a threatening or dangerous manner, such as pointing it at another person or brandishing it in public.', 0, 450),
	('Cultivation of Marijuana A', 'misdemeanor', 'OFFENSES AGAINST HEALTH AND MORALS', 'Cultivation of less than 6 plants of marijuana.', 0, 750),
	('Cultivation of Marijuana B', 'felony', 'OFFENSES AGAINST HEALTH AND MORALS', 'Cultivation of more than 6 plants of marijuana.', 0, 1500),
	('Desecration of a Human Corpse', 'felony', 'OFFENSES AGAINST HEALTH AND MORALS', 'The desecration of a human corpse, such as mutilation or defilement.', 0, 1500),
	('Disobeying a Peace Officer', 'infraction', 'OFFENSES AGAINST PUBLIC ORDER', 'Willfully disobeying a peace officer\'s order, even if the order is unreasonable or unlawful.', 0, 750),
	('Disorderly Conduct', 'infraction', 'OFFENSES AGAINST PUBLIC ORDER', 'Publicly behaving in a disorderly or disruptive manner, such that it is likely to disturb the peace or endanger the safety of others.', 0, 250),
	('Disturbing the Peace', 'infraction', 'OFFENSES AGAINST PUBLIC ORDER', 'Creating a disturbance that unreasonably interferes with the peace or quiet of others.', 0, 350),
	('Driving While Intoxicated', 'misdemeanor', 'OFFENSES INVOLVING THE OPERATION OF A VEHICLE', 'Operating a motor vehicle while under the influence of alcohol or drugs.', 0, 300),
	('Drug Trafficking', 'felony', 'OFFENSES AGAINST HEALTH AND MORALS', 'The transportation of a controlled substance across state lines.', 45, 15000),
	('Embezzlement', 'felony', 'OFFENSES AGAINST PUBLIC ADMINISTRATION', 'The theft of money or property by someone who has been entrusted with it.', 45, 10000),
	('Escaping', 'felony', 'OFFENSES AGAINST PUBLIC ADMINISTRATION', 'Unauthorized departure from a prison or other secure facility.', 10, 450),
	('Evading', 'misdemeanor', 'OFFENSES INVOLVING THE OPERATION OF A VEHICLE', 'Failing to stop for a police officer or fleeing from a traffic stop.', 0, 400),
	('Evidence Tampering', 'felony', 'OFFENSES AGAINST PUBLIC ORDER', 'Willfully tampering with or destroying evidence in a legal proceeding.', 20, 1000),
	('Extortion', 'felony', 'OFFENSES INVOLVING FRAUD', 'Obtaining something, such as money or property, from another person through the use of coercion or threats.', 20, 900),
	('Failure to Appear', 'misdemeanor', 'OFFENSES AGAINST PUBLIC ADMINISTRATION', 'Failing to appear in court as required.', 20, 8000),
	('Failure to Obey Traffic Control Device', 'infraction', 'OFFENSES INVOLVING THE OPERATION OF A VEHICLE', 'Failing to obey a traffic control device, such as a stop sign or traffic light.', 0, 150),
	('Failure to Provide Identification', 'misdemeanor', 'OFFENSES AGAINST PUBLIC ORDER', 'Willfully refusing to provide identification to a peace officer.', 15, 1500),
	('Failure to Yield to Emergency Vehicle', 'infraction', 'OFFENSES INVOLVING THE OPERATION OF A VEHICLE', 'Failing to yield the right of way to an emergency vehicle, such as a fire truck or ambulance.', 0, 600),
	('False Reporting', 'misdemeanor', 'OFFENSES AGAINST PUBLIC ORDER', 'Willfully making a false or misleading report to a peace officer or other public official.', 10, 750),
	('Felony Obstruction of Justice', 'felony', 'OFFENSES AGAINST PUBLIC ORDER', 'Willfully obstructing or interfering with an investigation or legal proceeding, resulting in serious injury or damage.', 15, 900),
	('Felony Possession of Cocaine', 'felony', 'OFFENSES AGAINST HEALTH AND MORALS', 'Possession of more than 2.5 grams of cocaine.', 0, 1500),
	('Felony Possession of Lean', 'felony', 'OFFENSES AGAINST HEALTH AND MORALS', 'Possession of more than 4 ounces of codeine cough syrup.', 0, 1500),
	('Felony Possession of Marijuana', 'felony', 'OFFENSES AGAINST HEALTH AND MORALS', 'Possession of more than 28.5 grams of marijuana.', 0, 1000),
	('Felony Possession of Methamphetamine', 'felony', 'OFFENSES AGAINST HEALTH AND MORALS', 'Possession of more than 2 grams of methamphetamine.', 0, 1500),
	('Felony Possession of Oxy / Vicodin', 'felony', 'OFFENSES AGAINST HEALTH AND MORALS', 'Possession of more than 4 grams of oxycodone or hydrocodone.', 0, 1500),
	('Felony Possession of Oxy / Vicodin with Intent to Distribute', 'felony', 'OFFENSES AGAINST HEALTH AND MORALS', 'Possession of oxycodone or hydrocodone with the intent to sell or distribute.', 0, 4500),
	('Felony Possession of Shrooms', 'felony', 'OFFENSES AGAINST HEALTH AND MORALS', 'Possession of more than 2 grams of psilocybin mushrooms.', 0, 1500),
	('Felony Trespassing', 'felony', 'OFFENSES INVOLVING DAMAGE TO PROPERTY', 'Entering or remaining on someone else\'s property without permission, when the property is a school, government building, or other protected location.', 15, 1500),
	('First Degree Murder', 'felony', 'OFFENSES AGAINST PERSONS', 'The unlawful killing of another human being with malice aforethought, and with premeditation.', 150, 20000),
	('First Degree Speeding', 'infraction', 'OFFENSES INVOLVING THE OPERATION OF A VEHICLE', 'Driving over the speed limit by 26-35 mph.', 0, 750),
	('Flying into Restricted Airspace', 'felony', 'OFFENSES AGAINST PUBLIC SAFETY', 'Flying an aircraft into restricted airspace, such as an airport or military base.', 0, 1500),
	('Forgery', 'misdemeanor', 'OFFENSES INVOLVING FRAUD', 'Making or altering a document with the intent to deceive another person.', 15, 750),
	('Fraud', 'misdemeanor', 'OFFENSES INVOLVING FRAUD', 'Intentionally deceiving another person in order to gain something, such as money or property.', 10, 450),
	('Gang Related Shooting', 'felony', 'OFFENSES AGAINST PERSONS', 'The discharge of a firearm in a public place, or at another person, with the intent to cause death or serious bodily harm, and the act is committed in association with a criminal street gang.', 30, 2500),
	('Government Corruption', 'felony', 'OFFENSES AGAINST PUBLIC ORDER', 'Using one\'s position in government to enrich oneself or others.', 60, 17500),
	('Grand Larceny', 'felony', 'OFFENSES INVOLVING THEFT', 'Theft of property valued at least $7500', 45, 7500),
	('Grand Theft', 'misdemeanor', 'OFFENSES INVOLVING THEFT', 'Theft of property valued at least $950 but less than $2500', 10, 600),
	('Grand Theft Auto A', 'felony', 'OFFENSES INVOLVING THEFT', 'Theft of a motor vehicle valued at least $2500 but less than $5000', 15, 900),
	('Grand Theft Auto B', 'felony', 'OFFENSES INVOLVING THEFT', 'Theft of a motor vehicle valued at least $5000', 35, 3500),
	('Harassment', 'misdemeanor', 'OFFENSES AGAINST PUBLIC ORDER', 'Engaging in a course of conduct that is intended to annoy, alarm, or frighten another person.', 10, 500),
	('Harboring a Fugitive', 'misdemeanor', 'OFFENSES AGAINST PUBLIC ORDER', 'Knowingly helping a fugitive to avoid arrest or prosecution.', 10, 1000),
	('Hostage Taking', 'felony', 'OFFENSES AGAINST PERSONS', 'The unlawful seizure or detention of a person as a hostage, with the intent to force a third party to do or refrain from doing something.', 20, 1200),
	('Hunting in Restricted Areas', 'infraction', 'OFFENSES INVOLVING THE WELL-BEING OF WILDLIFE', 'Hunting in an area that is closed to hunting, such as a wildlife refuge or national park.', 0, 450),
	('Hunting outside of hunting hours', 'infraction', 'OFFENSES INVOLVING THE WELL-BEING OF WILDLIFE', 'Hunting during a time period when hunting is not allowed, such as during closed season or at night.', 0, 750),
	('Hunting with a Non-Hunting Weapon', 'misdemeanor', 'OFFENSES INVOLVING THE WELL-BEING OF WILDLIFE', 'Hunting with a weapon that is not designed for hunting, such as a bow and arrow or a spear.', 0, 750),
	('Illegal Passing', 'infraction', 'OFFENSES INVOLVING THE OPERATION OF A VEHICLE', 'Passing another vehicle in a prohibited area, such as on a solid yellow line.', 0, 300),
	('Illegal U-Turn', 'infraction', 'OFFENSES INVOLVING THE OPERATION OF A VEHICLE', 'Making an illegal U-turn, such as in the middle of an intersection.', 0, 75),
	('Impersonating', 'misdemeanor', 'OFFENSES INVOLVING FRAUD', 'Falsely representing oneself as another person in order to gain something, such as money or property.', 15, 1250),
	('Impersonating a Judge', 'felony', 'OFFENSES INVOLVING FRAUD', 'Falsely claiming to be a judge in order to influence the outcome of a legal proceeding.', 120, 15000),
	('Impersonating a Peace Officer or Public Servant', 'felony', 'OFFENSES INVOLVING FRAUD', 'Deliberately pretending to be a law enforcement officer or other government official in order to deceive or intimidate others.', 25, 2750),
	('Inciting a Riot', 'felony', 'OFFENSES AGAINST PUBLIC ORDER', 'Soliciting or inciting others to engage in a riot.', 25, 1000),
	('Insurrection', 'felony', 'OFFENSES AGAINST PUBLIC SAFETY', 'The act of violently overthrowing or attempting to overthrow the government, such as by taking up arms against it.', 20, 3500),
	('Involuntary Manslaughter', 'felony', 'OFFENSES AGAINST PERSONS', 'Involuntary manslaughter is a criminal charge that is brought against someone who unintentionally causes the death of another person. It is a less serious crime than murder, but it can still result in significant penalties, including jail time.', 60, 7500),
	('Jailbreak', 'felony', 'OFFENSES AGAINST PUBLIC ADMINISTRATION', 'The unlawful release of a prisoner from custody.', 30, 2500),
	('Jaywalking', 'infraction', 'OFFENSES AGAINST PUBLIC SAFETY', 'Crossing a street illegally, such as by not using a crosswalk or by jaywalking in the middle of the street.', 0, 150),
	('Kidnapping', 'felony', 'OFFENSES AGAINST PERSONS', 'The unlawful taking and carrying away of another person by force or fraud, with the intent to secretly confine or imprison him or her.', 15, 900),
	('Leaving Without Paying', 'infraction', 'OFFENSES INVOLVING THEFT', 'Leaving a restaurant or retail establishment without paying for food or merchandise', 0, 500),
	('Littering', 'infraction', 'OFFENSES INVOLVING DAMAGE TO PROPERTY', 'Disposing of trash or other unwanted materials in a public place.', 0, 200),
	('Loitering on Government Properties', 'infraction', 'OFFENSES AGAINST PUBLIC ORDER', 'Loitering on government property without a legitimate purpose.', 0, 500),
	('Misdemeanor Obstruction of Justice', 'misdemeanor', 'OFFENSES AGAINST PUBLIC ORDER', 'Willfully obstructing or interfering with an investigation or legal proceeding.', 10, 500),
	('Misdemeanor Possession of Cocaine', 'misdemeanor', 'OFFENSES AGAINST HEALTH AND MORALS', 'Possession of less than 2.5 grams of cocaine.', 0, 500),
	('Misdemeanor Possession of Lean', 'misdemeanor', 'OFFENSES AGAINST HEALTH AND MORALS', 'Possession of less than 4 ounces of codeine cough syrup.', 0, 500),
	('Misdemeanor Possession of Marijuana', 'misdemeanor', 'OFFENSES AGAINST HEALTH AND MORALS', 'Possession of less than 28.5 grams of marijuana.', 0, 250),
	('Misdemeanor Possession of Methamphetamine', 'misdemeanor', 'OFFENSES AGAINST HEALTH AND MORALS', 'Possession of less than 2 grams of methamphetamine.', 0, 500),
	('Misdemeanor Possession of Oxy / Vicodin', 'felony', 'OFFENSES AGAINST HEALTH AND MORALS', 'Possession of less than 4 grams of oxycodone or hydrocodone.', 0, 500),
	('Misdemeanor Possession of Shrooms', 'misdemeanor', 'OFFENSES AGAINST HEALTH AND MORALS', 'Possession of less than 2 grams of psilocybin mushrooms.', 0, 500),
	('Misuse of Emergency Systems', 'infraction', 'OFFENSES AGAINST PUBLIC ADMINISTRATION', 'Intentionally making a false or misleading report to an emergency service.', 0, 600),
	('Money Laundering', 'felony', 'OFFENSES INVOLVING FRAUD', 'Concealing or disguising the origins of illegally obtained money in order to make it appear to have been obtained legally.', 80, 7500),
	('Murder of a Public Servant or Peace Officer', 'felony', 'OFFENSES AGAINST PERSONS', 'The unlawful killing of a public servant or peace officer, while such person is engaged in the performance of his or her official duties.', 150, 20000),
	('Negligent Driving', 'infraction', 'OFFENSES INVOLVING THE OPERATION OF A VEHICLE', 'Operating a motor vehicle in a careless or reckless manner that could cause an accident.', 0, 300),
	('Nonfunctional Vehicle', 'infraction', 'OFFENSES INVOLVING THE OPERATION OF A VEHICLE', 'Operating a vehicle that is not in safe working condition.', 0, 75),
	('Overhunting', 'misdemeanor', 'OFFENSES INVOLVING THE WELL-BEING OF WILDLIFE', 'Hunting more animals than is allowed by law.', 0, 1000),
	('Perjury', 'felony', 'OFFENSES AGAINST PUBLIC ADMINISTRATION', 'Giving false testimony under oath in a legal proceeding.', 100, 20000),
	('Petty Theft', 'infraction', 'OFFENSES INVOLVING THEFT', 'Theft of property valued less than $950', 0, 250),
	('Poaching', 'felony', 'OFFENSES INVOLVING THE WELL-BEING OF WILDLIFE', 'Hunting or trapping wildlife illegally, such as without a license or in a closed area.', 0, 1250),
	('Possession of Cocaine with Intent to Distribute', 'felony', 'OFFENSES AGAINST HEALTH AND MORALS', 'Possession of cocaine with the intent to sell or distribute.', 0, 4500),
	('Possession of Contraband in a Government Facility', 'felony', 'OFFENSES AGAINST PUBLIC ADMINISTRATION', 'Bringing prohibited items into a government facility, such as a prison or courthouse.', 25, 1000),
	('Possession of Government-Issued Items', 'misdemeanor', 'OFFENSES INVOLVING THEFT', 'Possession of government-issued identification cards or other items without authorization', 15, 1000),
	('Possession of Illegal Firearm Modifications', 'misdemeanor', 'OFFENSES AGAINST PUBLIC SAFETY', 'Possession of illegal modifications to a firearm, such as a silencer or a bump stock, that make it more dangerous.', 0, 300),
	('Possession of Items Used in the Commission of a Crime', 'misdemeanor', 'OFFENSES INVOLVING THEFT', 'Possession of tools or other items used in the commission of a crime', 10, 500),
	('Possession of Lean with Intent to Distribute', 'felony', 'OFFENSES AGAINST HEALTH AND MORALS', 'Possession of codeine cough syrup with the intent to sell or distribute.', 0, 4500),
	('Possession of Marijuana with Intent to Distribute', 'felony', 'OFFENSES AGAINST HEALTH AND MORALS', 'Possession of marijuana with the intent to sell or distribute.', 0, 3000),
	('Possession of Methamphetamine with Intent to Distribute', 'felony', 'OFFENSES AGAINST HEALTH AND MORALS', 'Possession of methamphetamine with the intent to sell or distribute.', 0, 4500),
	('Possession of Nonlegal Currency', 'misdemeanor', 'OFFENSES INVOLVING THEFT', 'Possession of counterfeit currency', 10, 750),
	('Possession of Shrooms with Intent to Distribute', 'felony', 'OFFENSES AGAINST HEALTH AND MORALS', 'Possession of psilocybin mushrooms with the intent to sell or distribute.', 0, 4500),
	('Possession of Stolen Government Identification', 'misdemeanor', 'OFFENSES INVOLVING FRAUD', 'Having in one\'s possession government identification that was stolen from another person, such as a driver\'s license or passport.', 20, 2000),
	('Possession of Stolen Identification', 'misdemeanor', 'OFFENSES INVOLVING FRAUD', 'Having in one\'s possession identification that was stolen from another person.', 10, 750),
	('Public Indecency', 'misdemeanor', 'OFFENSES AGAINST HEALTH AND MORALS', 'Engaging in indecent or lewd behavior in public.', 0, 750),
	('Public Intoxication', 'infraction', 'OFFENSES AGAINST HEALTH AND MORALS', 'Being intoxicated in public in a way that is disruptive or dangerous.', 0, 500),
	('Reckless Driving', 'misdemeanor', 'OFFENSES INVOLVING THE OPERATION OF A VEHICLE', 'Operating a motor vehicle in a wanton or willful manner that could cause an accident.', 0, 750),
	('Reckless Endangerment', 'misdemeanor', 'OFFENSES AGAINST PERSONS', 'The creation of a substantial risk of death or serious bodily harm to another person by the commission of a reckless act.', 10, 1000),
	('Reckless Evading', 'felony', 'OFFENSES INVOLVING THE OPERATION OF A VEHICLE', 'Evading a police officer in a reckless manner, such as driving at high speeds or driving on the wrong side of the road.', 0, 800),
	('Resisting Arrest', 'misdemeanor', 'OFFENSES AGAINST PUBLIC ADMINISTRATION', 'Willfully obstructing or interfering with an arrest.', 5, 300),
	('Robbery', 'felony', 'OFFENSES INVOLVING THEFT', 'Theft of property from a person by force or threat of force', 25, 2000),
	('Sale of a controlled substance', 'misdemeanor', 'OFFENSES AGAINST HEALTH AND MORALS', 'Sale of a controlled substance without a license.', 0, 1000),
	('Sale of Items Used in the Commission of a Crime', 'felony', 'OFFENSES INVOLVING THEFT', 'Sale of tools or other items used in the commission of a crime', 15, 1000),
	('Second Degree Murder', 'felony', 'OFFENSES AGAINST PERSONS', 'The unlawful killing of another human being with malice aforethought, but not premeditated.', 100, 15000),
	('Second Degree Speeding', 'infraction', 'OFFENSES INVOLVING THE OPERATION OF A VEHICLE', 'Driving over the speed limit by 16-25 mph.', 0, 450),
	('Simple Assault', 'misdemeanor', 'OFFENSES AGAINST PERSONS', 'The unlawful intentional application of force to the person of another, without his or her consent, and without causing significant injury.', 7, 500),
	('Stalking', 'felony', 'OFFENSES AGAINST PUBLIC ORDER', 'Repeatedly following or harassing another person.', 40, 1500),
	('Tampering', 'misdemeanor', 'OFFENSES AGAINST PUBLIC ORDER', 'Willfully tampering with or destroying property.', 10, 500),
	('Theft of an Aircraft', 'felony', 'OFFENSES INVOLVING THEFT', 'Theft of an aircraft', 20, 1000),
	('Third Degree Speeding', 'infraction', 'OFFENSES INVOLVING THE OPERATION OF A VEHICLE', 'Driving over the speed limit by 1-15 mph.', 0, 225),
	('Torture', 'felony', 'OFFENSES AGAINST PERSONS', 'The intentional infliction of severe pain or suffering on another person, for the purpose of obtaining information or a confession, or for the purpose of punishment, revenge, or sadism.', 40, 4500),
	('Trespassing', 'misdemeanor', 'OFFENSES INVOLVING DAMAGE TO PROPERTY', 'Entering or remaining on someone else\'s property without permission.', 10, 450),
	('Unlawful Imprisonment', 'misdemeanor', 'OFFENSES AGAINST PERSONS', 'The unlawful detention or confinement of another person without his or her consent.', 10, 600),
	('Unlawful Imprisonment of a Public Servant or Peace Officer.', 'felony', 'OFFENSES AGAINST PERSONS', 'The unlawful detention or confinement of a public servant or peace officer without his consent', 25, 4000),
	('Unlawful Practice', 'felony', 'OFFENSES AGAINST PUBLIC ADMINISTRATION', 'Engaging in a profession or occupation without the proper license or authorization.', 15, 1500),
	('Unlicensed Hunting', 'infraction', 'OFFENSES INVOLVING THE WELL-BEING OF WILDLIFE', 'Hunting without a valid hunting license.', 0, 450),
	('Unlicensed Operation of Vehicle', 'infraction', 'OFFENSES INVOLVING THE OPERATION OF A VEHICLE', 'Operating a motor vehicle without a valid driver\'s license.', 0, 500),
	('Vandalism', 'infraction', 'OFFENSES INVOLVING DAMAGE TO PROPERTY', 'Willfully damaging or destroying someone else\'s property.', 0, 300),
	('Vandalism of Government Property', 'felony', 'OFFENSES INVOLVING DAMAGE TO PROPERTY', 'Willfully damaging or destroying government property.', 20, 1500),
	('Vehicle Tampering', 'misdemeanor', 'OFFENSES AGAINST PUBLIC ORDER', 'Willfully tampering with or destroying a vehicle.', 15, 750),
	('Vehicular Manslaughter', 'felony', 'OFFENSES AGAINST PERSONS', 'The unlawful killing of a human being by the act of another, but without malice aforethought.', 75, 7500),
	('Vigilantism', 'felony', 'OFFENSES AGAINST PUBLIC ORDER', 'Taking the law into one\'s own hands and apprehending or punishing a suspected criminal.', 30, 1500),
	('Violating a Court Order', 'misdemeanor', 'OFFENSES AGAINST PUBLIC ADMINISTRATION', 'Willfully disobeying a court order.', 30, 13000),
	('Violation of a Restraining Order', 'felony', 'OFFENSES AGAINST PUBLIC ADMINISTRATION', 'Willfully violating the terms of a restraining order.', 20, 2250),
	('Weapon Trafficking', 'felony', 'OFFENSES AGAINST PUBLIC SAFETY', 'The transportation of weapons across state lines without the proper permits.', 30, 10000),
	('Witness Tampering', 'felony', 'OFFENSES AGAINST PUBLIC ORDER', 'Willfully tampering with or threatening a witness in a legal proceeding.', 25, 9000);

DROP TABLE IF EXISTS `ox_mdt_profiles`;
CREATE TABLE IF NOT EXISTS `ox_mdt_profiles` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `stateid` varchar(7) NOT NULL,
  `image` varchar(90) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `callsign` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ox_mdt_profiles_pk2` (`stateid`),
  UNIQUE KEY `ox_mdt_profiles_pk` (`callsign`),
  CONSTRAINT `ox_mdt_profiles_characters_stateId_fk` FOREIGN KEY (`stateid`) REFERENCES `characters` (`stateId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `ox_mdt_reports`;
CREATE TABLE IF NOT EXISTS `ox_mdt_reports` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `author` varchar(50) DEFAULT NULL,
  `date` datetime DEFAULT curtime(),
  PRIMARY KEY (`id`) USING BTREE,
  FULLTEXT KEY `title_desc_author` (`title`,`description`,`author`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `ox_mdt_reports_charges`;
CREATE TABLE IF NOT EXISTS `ox_mdt_reports_charges` (
  `reportid` int(10) unsigned NOT NULL,
  `stateid` varchar(7) NOT NULL,
  `charge` varchar(100) DEFAULT NULL,
  `count` int(10) unsigned NOT NULL DEFAULT 1,
  `time` int(10) unsigned DEFAULT NULL,
  `fine` int(10) unsigned DEFAULT NULL,
  KEY `FK_ox_mdt_reports_charges_ox_mdt_reports_criminals` (`reportid`),
  KEY `FK_ox_mdt_reports_charges_ox_mdt_reports_criminals_2` (`stateid`),
  KEY `FK_ox_mdt_reports_charges_ox_mdt_offenses` (`charge`),
  CONSTRAINT `FK_ox_mdt_reports_charges_ox_mdt_offenses` FOREIGN KEY (`charge`) REFERENCES `ox_mdt_offenses` (`label`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_ox_mdt_reports_charges_ox_mdt_reports_criminals` FOREIGN KEY (`reportid`) REFERENCES `ox_mdt_reports_criminals` (`reportid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_ox_mdt_reports_charges_ox_mdt_reports_criminals_2` FOREIGN KEY (`stateid`) REFERENCES `ox_mdt_reports_criminals` (`stateid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `ox_mdt_reports_criminals`;
CREATE TABLE IF NOT EXISTS `ox_mdt_reports_criminals` (
  `reportid` int(10) unsigned NOT NULL,
  `stateid` varchar(7) NOT NULL,
  `reduction` tinyint(3) unsigned DEFAULT NULL,
  `warrantExpiry` date DEFAULT NULL,
  `processed` tinyint(1) DEFAULT NULL,
  `pleadedGuilty` tinyint(1) DEFAULT NULL,
  KEY `reportid` (`reportid`) USING BTREE,
  KEY `FK_ox_mdt_reports_reports_characters` (`stateid`) USING BTREE,
  CONSTRAINT `ox_mdt_reports_criminals_ibfk_1` FOREIGN KEY (`stateid`) REFERENCES `characters` (`stateId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ox_mdt_reports_criminals_ibfk_2` FOREIGN KEY (`reportid`) REFERENCES `ox_mdt_reports` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `ox_mdt_reports_evidence`;
CREATE TABLE IF NOT EXISTS `ox_mdt_reports_evidence` (
  `reportid` int(10) unsigned NOT NULL,
  `label` varchar(50) NOT NULL DEFAULT '',
  `image` varchar(90) NOT NULL DEFAULT '',
  KEY `reportid` (`reportid`) USING BTREE,
  CONSTRAINT `FK__ox_mdt_reports` FOREIGN KEY (`reportid`) REFERENCES `ox_mdt_reports` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `ox_mdt_reports_officers`;
CREATE TABLE IF NOT EXISTS `ox_mdt_reports_officers` (
  `reportid` int(10) unsigned NOT NULL,
  `stateid` varchar(7) NOT NULL,
  KEY `FK_ox_mdt_reports_officers_characters` (`stateid`) USING BTREE,
  KEY `reportid` (`reportid`) USING BTREE,
  CONSTRAINT `FK_ox_mdt_reports_officers_characters` FOREIGN KEY (`stateid`) REFERENCES `characters` (`stateId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_ox_mdt_reports_officers_ox_mdt_reports` FOREIGN KEY (`reportid`) REFERENCES `ox_mdt_reports` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `ox_mdt_warrants`;
CREATE TABLE IF NOT EXISTS `ox_mdt_warrants` (
  `reportid` int(10) unsigned NOT NULL,
  `stateid` varchar(7) NOT NULL,
  `expiresAt` datetime NOT NULL,
  KEY `ox_mdt_warrants_characters_stateid_fk` (`stateid`),
  KEY `ox_mdt_warrants_ox_mdt_reports_id_fk` (`reportid`),
  CONSTRAINT `ox_mdt_warrants_characters_stateid_fk` FOREIGN KEY (`stateid`) REFERENCES `characters` (`stateId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ox_mdt_warrants_ox_mdt_reports_id_fk` FOREIGN KEY (`reportid`) REFERENCES `ox_mdt_reports` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `ox_statuses`;
CREATE TABLE IF NOT EXISTS `ox_statuses` (
  `name` varchar(20) NOT NULL,
  `default` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `onTick` decimal(8,7) DEFAULT 0.0000000
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `ox_statuses` (`name`, `default`, `onTick`) VALUES
	('hunger', 0, 0.0200000),
	('thirst', 0, 0.0500000),
	('stress', 0, -0.1000000);

DROP TABLE IF EXISTS `playerskins`;
CREATE TABLE IF NOT EXISTS `playerskins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(255) NOT NULL,
  `model` varchar(255) NOT NULL,
  `skin` text NOT NULL,
  `active` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `active` (`active`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;


DROP TABLE IF EXISTS `player_outfits`;
CREATE TABLE IF NOT EXISTS `player_outfits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `outfitname` varchar(50) NOT NULL DEFAULT '0',
  `model` varchar(50) DEFAULT NULL,
  `props` varchar(1000) DEFAULT NULL,
  `components` varchar(1500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `citizenid_outfitname_model` (`citizenid`,`outfitname`,`model`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `player_outfit_codes`;
CREATE TABLE IF NOT EXISTS `player_outfit_codes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `outfitid` int(11) NOT NULL,
  `code` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `FK_player_outfit_codes_player_outfits` (`outfitid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `userId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT NULL,
  `license2` varchar(50) DEFAULT NULL,
  `steam` varchar(20) DEFAULT NULL,
  `fivem` varchar(10) DEFAULT NULL,
  `discord` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `vehicles`;
CREATE TABLE IF NOT EXISTS `vehicles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `plate` char(8) NOT NULL DEFAULT '',
  `vin` char(17) NOT NULL,
  `owner` int(10) unsigned DEFAULT NULL,
  `group` varchar(20) DEFAULT NULL,
  `model` varchar(20) NOT NULL,
  `class` tinyint(3) unsigned DEFAULT NULL,
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`data`)),
  `trunk` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`trunk`)),
  `glovebox` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`glovebox`)),
  `stored` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `plate` (`plate`),
  UNIQUE KEY `vin` (`vin`),
  KEY `vehicles_owner_key` (`owner`),
  KEY `vehicles_group_fk` (`group`),
  CONSTRAINT `vehicles_group_fk` FOREIGN KEY (`group`) REFERENCES `ox_groups` (`name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `vehicles_owner_fk` FOREIGN KEY (`owner`) REFERENCES `characters` (`charId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
