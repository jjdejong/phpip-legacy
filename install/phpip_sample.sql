SET AUTOCOMMIT = 0;
SET FOREIGN_KEY_CHECKS=0;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `phpip` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `phpip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actor` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT 'Family name or company name',
  `first_name` varchar(60) DEFAULT NULL COMMENT 'plus middle names, if required',
  `display_name` varchar(30) DEFAULT NULL COMMENT 'The name displayed in the interface, if not null',
  `login` char(16) DEFAULT NULL COMMENT 'Database user login if not null.',
  `password` varchar(60) DEFAULT NULL,
  `password_salt` varchar(32) DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `default_role` char(5) DEFAULT NULL COMMENT 'Link to actor_role table. A same actor can have different roles - this is the default role of the actor. CAUTION: for database users, this sets the user ACLs.',
  `function` varchar(45) DEFAULT NULL,
  `parent_ID` int(11) DEFAULT NULL COMMENT 'Parent company of this company (another actor), where applicable. Useful for linking several companies owned by a same corporation',
  `company_ID` int(11) DEFAULT NULL COMMENT 'Mainly for inventors and contacts. ID of the actor''s company or employer (another record in the actors table)',
  `site_ID` int(11) DEFAULT NULL COMMENT 'Mainly for inventors and contacts. ID of the actor''s company site (another record in the actors table), if the company has several sites that we want to differentiate',
  `phy_person` tinyint(1) DEFAULT '1' COMMENT 'Physical person or not',
  `nationality` char(2) DEFAULT NULL,
  `small_entity` tinyint(1) DEFAULT '0' COMMENT 'Small entity status used in a few countries (FR, US)',
  `address` varchar(256) NOT NULL DEFAULT '' COMMENT 'Main address: street, zip and city',
  `country` char(2) DEFAULT NULL COMMENT 'Country in address',
  `address_mailing` varchar(256) NOT NULL DEFAULT '' COMMENT 'Mailing address: street, zip and city',
  `country_mailing` char(2) DEFAULT NULL,
  `address_billing` varchar(256) NOT NULL DEFAULT '' COMMENT 'Billing address: street, zip and city',
  `country_billing` char(2) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `phone2` varchar(20) DEFAULT NULL,
  `fax` varchar(20) DEFAULT NULL,
  `warn` tinyint(1) DEFAULT '0' COMMENT 'The actor will be displayed in red in the matter view when set',
  `notes` text,
  `VAT_number` varchar(45) DEFAULT NULL,
  `creator` char(16) DEFAULT NULL,
  `updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updater` char(16) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uqdisplay_name` (`display_name`) USING BTREE,
  UNIQUE KEY `uqlogin` (`login`) USING HASH,
  KEY `name` (`name`) USING BTREE,
  KEY `default_role` (`default_role`) USING HASH,
  KEY `company` (`company_ID`) USING HASH,
  KEY `site` (`site_ID`) USING HASH,
  KEY `parent` (`parent_ID`) USING HASH,
  KEY `nationality` (`nationality`) USING HASH,
  KEY `country_billing` (`country_billing`) USING HASH,
  KEY `country_mailing` (`country_mailing`) USING HASH,
  KEY `country` (`country`) USING HASH,
  CONSTRAINT `fk_actor_company` FOREIGN KEY (`company_ID`) REFERENCES `actor` (`ID`) ON UPDATE CASCADE,
  CONSTRAINT `fk_actor_country` FOREIGN KEY (`country`) REFERENCES `country` (`iso`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_actor_countryb` FOREIGN KEY (`country_billing`) REFERENCES `country` (`iso`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_actor_countrym` FOREIGN KEY (`country_mailing`) REFERENCES `country` (`iso`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_actor_nationality` FOREIGN KEY (`nationality`) REFERENCES `country` (`iso`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_actor_parent` FOREIGN KEY (`parent_ID`) REFERENCES `actor` (`ID`) ON UPDATE CASCADE,
  CONSTRAINT `fk_actor_role` FOREIGN KEY (`default_role`) REFERENCES `actor_role` (`code`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_actor_site` FOREIGN KEY (`site_ID`) REFERENCES `actor` (`ID`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='All actors involved in a patent';
/*!40101 SET character_set_client = @saved_cs_client */;
INSERT INTO `actor` (`ID`, `name`, `first_name`, `display_name`, `login`, `password`, `password_salt`, `last_login`, `default_role`, `function`, `parent_ID`, `company_ID`, `site_ID`, `phy_person`, `nationality`, `small_entity`, `address`, `country`, `address_mailing`, `country_mailing`, `address_billing`, `country_billing`, `email`, `phone`, `phone2`, `fax`, `warn`, `notes`, `VAT_number`, `creator`, `updated`, `updater`)
VALUES
	(1,'Client handled',NULL,'CLIENT',NULL,NULL,NULL,NULL,'ANN','',NULL,NULL,NULL,0,NULL,0,'',NULL,'',NULL,'',NULL,NULL,NULL,NULL,NULL,0,'DO NOT DELETE - Special actor used for removing renewal tasks that are handled by the client',NULL,NULL,'2016-06-18 07:21:41',NULL),
	(120,'phpIP User',NULL,NULL,'phpipuser','26320dbc247a9f2aec0afc69b5d82d72','salt','2017-12-04 09:28:29',NULL,NULL,NULL,NULL,NULL,1,NULL,0,'',NULL,'',NULL,'',NULL,'root@localhost',NULL,NULL,NULL,0,NULL,NULL,'root','2017-12-04 09:28:29','phpip'),
	(124,'Tesla Motors Inc.',NULL,'Tesla',NULL,NULL,NULL,NULL,'CLI',NULL,NULL,NULL,NULL,0,NULL,0,'',NULL,'',NULL,'',NULL,NULL,NULL,NULL,NULL,0,'TEST DATA',NULL,'phpipuser','2017-12-03 16:45:57','phpipuser'),
	(125,'BAGLINO Andrew D.',NULL,NULL,NULL,NULL,NULL,NULL,'INV',NULL,NULL,124,NULL,1,NULL,0,'','US','',NULL,'',NULL,NULL,NULL,NULL,NULL,0,'TEST DATA',NULL,'phpipuser','2017-12-03 16:45:48','phpipuser'),
	(126,'HAYER Thorsten',NULL,NULL,NULL,NULL,NULL,NULL,'INV',NULL,NULL,124,NULL,1,NULL,0,'',NULL,'',NULL,'',NULL,NULL,NULL,NULL,NULL,0,'TEST DATA',NULL,'phpipuser','2017-12-03 16:45:37','phpipuser'),
	(127,'BOBLETT Brennan',NULL,NULL,NULL,NULL,NULL,NULL,'INV',NULL,NULL,124,NULL,1,NULL,0,'','US','',NULL,'',NULL,NULL,NULL,NULL,NULL,0,'TEST DATA',NULL,'phpipuser','2017-12-03 16:45:23',NULL),
	(128,'Boehmert & Boehmert',NULL,'Boehmert',NULL,NULL,NULL,NULL,'AGT',NULL,NULL,NULL,NULL,1,'DE',0,'','DE','',NULL,'',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'phpipuser','2017-12-03 17:40:13','phpipuser'),
	(129,'SODERBERG Richard',NULL,NULL,NULL,NULL,NULL,NULL,'AGT',NULL,NULL,NULL,NULL,1,NULL,0,'','US','',NULL,'',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'phpipuser','2017-12-03 17:33:37',NULL),
	(130,'Texas Patents',NULL,NULL,NULL,NULL,NULL,NULL,'AGT',NULL,NULL,NULL,NULL,1,NULL,0,'','US','',NULL,'',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'phpipuser','2017-12-03 17:37:19',NULL);
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `actor_creator_log` BEFORE INSERT ON `actor` FOR EACH ROW set new.creator=SUBSTRING_INDEX(USER(),'@',1) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `actor_updater_log` BEFORE UPDATE ON `actor` FOR EACH ROW set new.updater=SUBSTRING_INDEX(USER(),'@',1) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actor_role` (
  `code` char(5) NOT NULL,
  `name` varchar(45) NOT NULL,
  `display_order` tinyint(4) DEFAULT '127' COMMENT 'Order of display in interface',
  `shareable` tinyint(1) DEFAULT '0' COMMENT 'Indicates whether actors listed with this role are shareable for all matters of the same family',
  `show_ref` tinyint(1) DEFAULT '0',
  `show_company` tinyint(1) DEFAULT '0',
  `show_rate` tinyint(1) DEFAULT '0',
  `show_date` tinyint(1) DEFAULT '0',
  `box` tinyint(4) DEFAULT '127' COMMENT 'Number of a box in which several roles will be displayed',
  `box_color` varchar(7) DEFAULT '#000000' COMMENT 'Color of background',
  `notes` varchar(160) DEFAULT NULL,
  `creator` varchar(20) DEFAULT NULL,
  `updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updater` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`code`),
  KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='All types of actors for use in patent_actor_lnk';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `arole_create_log` BEFORE INSERT ON `actor_role` FOR EACH ROW set new.creator=SUBSTRING_INDEX(USER(),'@',1) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `arole_modify_log` BEFORE UPDATE ON `actor_role` FOR EACH ROW set new.updater=SUBSTRING_INDEX(USER(),'@',1) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `classifier` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `matter_ID` int(11) NOT NULL,
  `type_code` char(5) NOT NULL COMMENT 'Link to ''classifier_types''',
  `value` text COMMENT 'A free-text value used when classifier_values has no record linked to the classifier_types record',
  `url` varchar(256) DEFAULT NULL COMMENT 'Display value as a link to the URL defined here',
  `value_ID` int(11) DEFAULT NULL COMMENT 'Links to the classifier_values table if it has a link to classifier_types',
  `display_order` tinyint(4) NOT NULL DEFAULT '1',
  `lnk_matter_ID` int(11) DEFAULT NULL COMMENT 'Matter this case is linked to',
  `creator` varchar(20) DEFAULT NULL,
  `updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updater` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ID`,`matter_ID`),
  UNIQUE KEY `uqlnk` (`matter_ID`,`type_code`,`lnk_matter_ID`) USING BTREE,
  UNIQUE KEY `uqvalue_id` (`matter_ID`,`type_code`,`value_ID`) USING BTREE,
  UNIQUE KEY `uqvalue` (`matter_ID`,`type_code`,`value`(10)),
  KEY `value` (`value`(20)) USING BTREE,
  KEY `type` (`type_code`) USING HASH,
  KEY `value_id` (`value_ID`) USING HASH,
  KEY `lnk_matter` (`lnk_matter_ID`) USING HASH,
  CONSTRAINT `fk_lnkmatter` FOREIGN KEY (`lnk_matter_ID`) REFERENCES `matter` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_matter` FOREIGN KEY (`matter_ID`) REFERENCES `matter` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_type` FOREIGN KEY (`type_code`) REFERENCES `classifier_type` (`code`) ON UPDATE CASCADE,
  CONSTRAINT `fk_value` FOREIGN KEY (`value_ID`) REFERENCES `classifier_value` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
INSERT INTO `classifier` (`ID`, `matter_ID`, `type_code`, `value`, `url`, `value_ID`, `display_order`, `lnk_matter_ID`, `creator`, `updated`, `updater`)
VALUES
	(4,4,'TITOF','Trip planning with energy constraint',NULL,NULL,1,NULL,'phpipuser','2017-12-03 16:34:12',NULL),
	(5,4,'TIT','Trip Planning with Energy Constraint',NULL,NULL,1,NULL,'phpipuser','2017-12-04 09:29:59','phpipuser');
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `classifier_BEFORE_INSERT` BEFORE INSERT ON `classifier` FOR EACH ROW 
BEGIN
	SET NEW.creator=SUBSTRING_INDEX(USER(),'@',1);
    IF NEW.type_code = 'TITEN' THEN
		SET NEW.value=tcase(NEW.value);
	ELSEIF NEW.type_code IN ('TIT', 'TITOF', 'TITAL') THEN
		SET NEW.value=CONCAT(UCASE(SUBSTR(NEW.value, 1, 1)),LCASE(SUBSTR(NEW.value FROM 2)));
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `classifier_updater_log` BEFORE UPDATE ON `classifier` FOR EACH ROW set new.updater=SUBSTRING_INDEX(USER(),'@',1) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `classifier_type` (
  `code` char(5) NOT NULL,
  `type` varchar(45) NOT NULL,
  `main_display` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Indicates whether to display as main information',
  `for_category` char(5) DEFAULT NULL COMMENT 'For showing in the pick-lists of only the selected category',
  `display_order` tinyint(4) DEFAULT '127',
  `notes` varchar(160) DEFAULT NULL,
  `creator` varchar(20) DEFAULT NULL,
  `updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updater` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`code`),
  UNIQUE KEY `for_category` (`for_category`,`code`) USING BTREE,
  CONSTRAINT `fk_forcategory` FOREIGN KEY (`for_category`) REFERENCES `matter_category` (`code`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ctype_creator_log` BEFORE INSERT ON `classifier_type` FOR EACH ROW set new.creator=SUBSTRING_INDEX(USER(),'@',1) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ctype_updater_log` BEFORE UPDATE ON `classifier_type` FOR EACH ROW set new.updater=SUBSTRING_INDEX(USER(),'@',1) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `classifier_value` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `value` varchar(160) NOT NULL,
  `type_code` char(5) DEFAULT NULL COMMENT 'Restrict this classifier name to the classifier type identified here',
  `notes` varchar(255) DEFAULT NULL,
  `creator` varchar(20) DEFAULT NULL,
  `updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updater` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uqclvalue` (`value`,`type_code`) USING BTREE,
  KEY `value_type` (`type_code`) USING HASH,
  CONSTRAINT `fk_value_type` FOREIGN KEY (`type_code`) REFERENCES `classifier_type` (`code`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cvalue_creator_log` BEFORE INSERT ON `classifier_value` FOR EACH ROW set new.creator=user() */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cvalue_updater_log` BEFORE UPDATE ON `classifier_value` FOR EACH ROW set new.updater=user() */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `country` (
  `numcode` smallint(6) DEFAULT NULL,
  `iso` char(2) NOT NULL,
  `iso3` char(3) DEFAULT NULL,
  `name_DE` varchar(80) DEFAULT NULL,
  `name` varchar(80) NOT NULL,
  `name_FR` varchar(80) DEFAULT NULL,
  `ep` tinyint(1) DEFAULT '0' COMMENT 'Flag default countries for EP ratifications',
  `wo` tinyint(1) DEFAULT '0' COMMENT 'Flag default countries for PCT national phase',
  `em` tinyint(1) DEFAULT '0' COMMENT 'Flag default countries for EU trade mark',
  `oa` tinyint(1) DEFAULT '0' COMMENT 'Flag default countries for OA national phase',
  PRIMARY KEY (`iso`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `default_actor` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `actor_id` int(11) NOT NULL,
  `role` char(5) NOT NULL,
  `for_category` char(5) DEFAULT NULL,
  `for_country` char(2) DEFAULT NULL,
  `for_client` int(11) DEFAULT NULL,
  `shared` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `role` (`role`),
  KEY `for_country` (`for_country`),
  KEY `for_client` (`for_client`),
  KEY `actor_id` (`actor_id`) USING BTREE,
  CONSTRAINT `fk_dfltactor` FOREIGN KEY (`actor_id`) REFERENCES `actor` (`ID`) ON UPDATE CASCADE,
  CONSTRAINT `fk_dfltactor_client` FOREIGN KEY (`for_client`) REFERENCES `actor` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_dfltactor_country` FOREIGN KEY (`for_country`) REFERENCES `country` (`iso`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_dfltactor_role` FOREIGN KEY (`role`) REFERENCES `actor_role` (`code`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Indicate which actors should be systematically added to new ';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `code` char(5) NOT NULL COMMENT 'Link to event_names table',
  `matter_ID` int(11) NOT NULL,
  `event_date` date NOT NULL,
  `alt_matter_ID` int(11) DEFAULT NULL COMMENT 'Essentially for priority claims. ID of prior patent this event refers to',
  `detail` varchar(45) DEFAULT NULL COMMENT 'Numbers or short comments',
  `notes` varchar(150) DEFAULT NULL,
  `creator` char(16) DEFAULT NULL,
  `updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updater` char(16) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uqevent` (`matter_ID`,`code`,`event_date`,`alt_matter_ID`) USING BTREE,
  KEY `code` (`code`) USING HASH,
  KEY `date` (`event_date`) USING BTREE,
  KEY `number` (`detail`) USING BTREE,
  KEY `alt_matter` (`alt_matter_ID`),
  CONSTRAINT `fk_event_altmatter` FOREIGN KEY (`alt_matter_ID`) REFERENCES `matter` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_event_matter` FOREIGN KEY (`matter_ID`) REFERENCES `matter` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_event_name` FOREIGN KEY (`code`) REFERENCES `event_name` (`code`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
INSERT INTO `event` (`ID`, `code`, `matter_ID`, `event_date`, `alt_matter_ID`, `detail`, `notes`, `creator`, `updated`, `updater`)
VALUES
	(26,'FIL',4,'2014-04-04',NULL,'61/975,534',NULL,'phpipuser','2017-12-03 16:41:31','phpipuser'),
	(27,'CRE',5,'2017-12-03',NULL,NULL,NULL,'phpipuser','2017-12-03 16:48:17',NULL),
	(28,'PRI',5,'2014-04-04',4,NULL,NULL,'phpipuser','2017-12-03 16:48:17',NULL),
	(29,'FIL',5,'2015-03-19',NULL,'2015US21556',NULL,'phpipuser','2017-12-03 16:49:29',NULL),
	(30,'PUB',5,'2015-10-08',NULL,'2015153140',NULL,'phpipuser','2017-12-03 16:50:31',NULL),
	(31,'CRE',6,'2017-12-03',NULL,NULL,NULL,'phpipuser','2017-12-03 16:58:16',NULL),
	(32,'PRI',6,'2014-04-04',4,NULL,NULL,'phpipuser','2017-12-03 16:58:16',NULL),
	(33,'FIL',6,'2015-03-19',NULL,'2015818677',NULL,'phpipuser','2017-12-03 17:11:00','phpipuser'),
	(34,'PUB',6,'2016-11-23',NULL,'106163862',NULL,'phpipuser','2017-12-03 17:14:07','phpipuser'),
	(36,'ENT',6,'2017-12-03',NULL,NULL,NULL,'phpipuser','2017-12-03 16:58:16',NULL),
	(37,'CRE',7,'2017-12-03',NULL,NULL,NULL,'phpipuser','2017-12-03 16:58:16',NULL),
	(38,'PRI',7,'2014-04-04',4,NULL,NULL,'phpipuser','2017-12-03 16:58:16',NULL),
	(39,'FIL',7,'2015-03-19',NULL,'15772400.6',NULL,'phpipuser','2017-12-03 17:00:01','phpipuser'),
	(40,'PUB',7,'2017-02-08',NULL,'3126183',NULL,'phpipuser','2017-12-03 17:13:24','phpipuser'),
	(42,'ENT',7,'2016-09-27',NULL,NULL,NULL,'phpipuser','2017-12-03 17:26:35','phpipuser'),
	(43,'CRE',8,'2017-12-03',NULL,NULL,NULL,'phpipuser','2017-12-03 16:58:16',NULL),
	(44,'PRI',8,'2014-04-04',4,NULL,NULL,'phpipuser','2017-12-03 16:58:16',NULL),
	(45,'FIL',8,'2015-03-19',NULL,'20160560723',NULL,'phpipuser','2017-12-03 17:11:53','phpipuser'),
	(46,'PUB',8,'2017-05-25',NULL,'2017513006',NULL,'phpipuser','2017-12-03 17:12:33','phpipuser'),
	(48,'ENT',8,'2016-10-03',NULL,NULL,NULL,'phpipuser','2017-12-03 17:26:19','phpipuser'),
	(49,'CRE',9,'2017-12-03',NULL,NULL,NULL,'phpipuser','2017-12-03 16:58:16',NULL),
	(50,'PRI',9,'2014-04-04',4,NULL,NULL,'phpipuser','2017-12-03 16:58:16',NULL),
	(51,'FIL',9,'2015-03-19',NULL,'20167028374',NULL,'phpipuser','2017-12-03 17:14:44','phpipuser'),
	(52,'PUB',9,'2016-11-28',NULL,'20160135753',NULL,'phpipuser','2017-12-03 17:15:08','phpipuser'),
	(54,'ENT',9,'2016-10-12',NULL,NULL,NULL,'phpipuser','2017-12-03 17:25:57','phpipuser'),
	(55,'CRE',10,'2017-12-03',NULL,NULL,NULL,'phpipuser','2017-12-03 16:58:16',NULL),
	(56,'PRI',10,'2014-04-04',4,NULL,NULL,'phpipuser','2017-12-03 16:58:16',NULL),
	(57,'FIL',10,'2015-03-19',NULL,'20151530173',NULL,'phpipuser','2017-12-03 17:17:17','phpipuser'),
	(58,'PUB',10,'2017-02-02',NULL,'2017030728',NULL,'phpipuser','2017-12-03 17:17:34','phpipuser'),
	(60,'ENT',10,'2016-10-04',NULL,NULL,NULL,'phpipuser','2017-12-03 17:25:29','phpipuser'),
	(67,'EXA',10,'2017-07-28',NULL,NULL,NULL,'phpipuser','2017-12-03 17:18:50',NULL);
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `event_before_insert` BEFORE INSERT ON `event` FOR EACH ROW BEGIN
	DECLARE vdate DATE DEFAULT NULL;

	SET new.creator = SUBSTRING_INDEX(USER(),'@',1);
	
	
	IF NEW.alt_matter_id IS NOT NULL THEN
		IF EXISTS (SELECT 1 FROM event WHERE code='FIL' AND NEW.alt_matter_id=matter_id AND event_date IS NOT NULL) THEN
			SELECT event_date INTO vdate FROM event WHERE code='FIL' AND NEW.alt_matter_id=matter_id;
			SET NEW.event_date = vdate;
		ELSE
			SET NEW.event_date = Now();
		END IF;
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `event_after_insert` AFTER INSERT ON `event` FOR EACH ROW trig: BEGIN
  DECLARE vdue_date, vbase_date, vexpiry, tmp_date DATE DEFAULT NULL;
  DECLARE vcontainer_id, vid_uqtask, vrule_id, vdays, vmonths, vyears, vpta, vid, vcli_ann_agt INT DEFAULT NULL;
  DECLARE vtask, vtype, vcurrency CHAR(5) DEFAULT NULL;
  DECLARE vdetail, vresponsible VARCHAR(160) DEFAULT NULL;
  DECLARE done, vclear_task, vdelete_task, vend_of_month, vunique, vrecurring, vuse_parent, vuse_priority, vdead BOOLEAN DEFAULT 0;
  DECLARE vcost, vfee DECIMAL(6,2) DEFAULT null;

  
  DECLARE cur_rule CURSOR FOR 
    SELECT task_rules.id, task, clear_task, delete_task, detail, days, months, years, recurring, end_of_month, use_parent, use_priority, cost, fee, currency, task_rules.responsible, event_name.`unique`
    FROM task_rules, event_name, matter
    WHERE NEW.matter_id=matter.id
    AND event_name.code=task
    AND NEW.code=trigger_event
    AND (for_category, ifnull(for_country, matter.country), ifnull(for_origin, matter.origin), ifnull(for_type, matter.type_code))<=>(matter.category_code, matter.country, matter.origin, matter.type_code)
	AND (uqtrigger=0 
		OR (uqtrigger=1 AND NOT EXISTS (SELECT 1 FROM task_rules tr 
		WHERE (tr.task, tr.for_category, tr.for_country)=(task_rules.task, matter.category_code, matter.country) AND tr.trigger_event!=task_rules.trigger_event)))
    AND NOT EXISTS (SELECT 1 FROM event WHERE matter_id=NEW.matter_id AND code=abort_on)
    AND (condition_event IS null OR EXISTS (SELECT 1 FROM event WHERE matter_id=NEW.matter_id AND code=condition_event))
    AND (NEW.event_date < use_before OR use_before IS null)
    AND (NEW.event_date > use_after OR use_after IS null)
    AND active=1;

  
  DECLARE cur_linked CURSOR FOR
	SELECT matter_id FROM event WHERE alt_matter_id=NEW.matter_id; 

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT container_id, type_code, dead, expire_date, term_adjust INTO vcontainer_id, vtype, vdead, vexpiry, vpta FROM matter WHERE matter.id=NEW.matter_id;
  SELECT id INTO vcli_ann_agt FROM actor WHERE display_name='CLIENT';
  
  -- Do not change anything in dead cases
  IF (vdead) THEN
    LEAVE trig;
  END IF;
  
  -- Set matter to "dead" if the expire date has been reached
  IF (!vdead AND Now() > vexpiry) THEN
	UPDATE matter SET dead = 1 WHERE matter.id=NEW.matter_id;
    LEAVE trig;
  END IF;

  OPEN cur_rule;
  create_tasks: LOOP
	
	SET vid_uqtask=0;
	SET vbase_date = NEW.event_date;

    FETCH cur_rule INTO vrule_id, vtask, vclear_task, vdelete_task, vdetail, vdays, vmonths, vyears, vrecurring, vend_of_month, vuse_parent, vuse_priority, vcost, vfee, vcurrency, vresponsible, vunique;
    IF done THEN 
      LEAVE create_tasks; 
    END IF;

	-- Skip renewal tasks if the client is the annuity agent
	IF (vtask='REN' AND EXISTS (SELECT 1 FROM matter_actor_lnk lnk WHERE lnk.role='ANN' AND lnk.actor_id=vcli_ann_agt AND lnk.matter_id=NEW.matter_id)) THEN
		ITERATE create_tasks;
	END IF;

	IF vuse_parent THEN
	-- Use parent filing date for task deadline calculation, if PFIL event exists
		SELECT CAST(IFNULL(min(event_date), NEW.event_date) AS DATE) INTO vbase_date FROM event_lnk_list WHERE code='PFIL' AND matter_id=NEW.matter_id;
	END IF;

	IF vuse_priority THEN
	-- Use earliest priority date for task deadline calculation, if a PRI event exists
		SELECT CAST(IFNULL(min(event_date), NEW.event_date) AS DATE) INTO vbase_date FROM event_lnk_list WHERE code='PRI' AND matter_id=NEW.matter_id;
	END IF;

    IF vclear_task THEN
    -- Clear the task identified by the rule (do not create anything)
      UPDATE task, event SET task.done=1, task.done_date=NEW.event_date WHERE task.trigger_id=event.id AND task.code=vtask AND matter_id=NEW.matter_id AND done=0;
      ITERATE create_tasks;
    END IF;

    IF (vdelete_task AND vcontainer_id IS NOT NULL) THEN
    -- Delete the task identified by the rule, only if the matter is a new family member (do not create anything)
      DELETE task FROM event INNER JOIN task WHERE task.trigger_id=event.id AND task.code=vtask AND matter_id=NEW.matter_id;
      ITERATE create_tasks;
    END IF;

    -- If the new event is unique or the event is a priority claim, retrieve a similar event if it already exists 
	IF (vunique OR NEW.code='PRI') THEN 
		IF EXISTS (SELECT 1 FROM task JOIN event ON event.id=task.trigger_id WHERE event.matter_id=NEW.matter_id AND task.rule_used=vrule_id) THEN
			SELECT task.id INTO vid_uqtask FROM task JOIN event ON event.id=task.trigger_id WHERE event.matter_id=NEW.matter_id AND task.rule_used=vrule_id;
		END IF;
	END IF;

	-- If the unique event or a priority claim already exists and its date is earlier than the new date, do nothing. If its date is later than the new date, proceed with the new date
    IF (!vuse_parent AND !vuse_priority AND (vunique OR NEW.code='PRI') AND vid_uqtask > 0) THEN
      SELECT min(event_date) INTO vbase_date FROM event_lnk_list WHERE matter_id=NEW.matter_id AND code=NEW.code;
      IF vbase_date < NEW.event_date THEN	
        ITERATE create_tasks;
      END IF;
    END IF;

	-- Calculate the deadline
    SET vdue_date = vbase_date + INTERVAL vdays DAY + INTERVAL vmonths MONTH + INTERVAL vyears YEAR;
    IF vend_of_month THEN
      SET vdue_date=LAST_DAY(vdue_date);
    END IF;

	-- Deadline for renewals that have become due in a parent case when filing a divisional (EP 4-months rule)
	IF (vtask = 'REN' AND EXISTS (SELECT 1 FROM event WHERE code='PFIL' AND matter_id=NEW.matter_id) AND vdue_date < NEW.event_date) THEN
		SET vdue_date = NEW.event_date + INTERVAL 4 MONTH;
	END IF;

	-- Skip creating tasks having a deadline in the past, except if the event is the expiry
    IF (vdue_date < Now() AND vtask NOT IN ('EXP', 'REN')) OR (vdue_date < (Now() - INTERVAL 7 MONTH) AND vtask = 'REN') THEN
      ITERATE create_tasks;
    END IF;

	-- Handle the expiry task (no task created). Otherwise replace an existing unique task with the current (unique) task, or insert the new (non-unique) task
    IF vtask='EXP' THEN
		UPDATE matter SET expire_date = vdue_date + INTERVAL vpta DAY WHERE matter.id=NEW.matter_id;
	ELSEIF vid_uqtask > 0 THEN
		UPDATE task SET trigger_id=NEW.id, due_date=vdue_date WHERE id=vid_uqtask;
	ELSE
		INSERT INTO task (trigger_id,code,due_date,detail,rule_used,cost,fee,currency,assigned_to) values (NEW.id,vtask,vdue_date,vdetail,vrule_id,vcost,vfee,vcurrency,vresponsible);
	END IF;

  END LOOP create_tasks;
  CLOSE cur_rule;

  SET done = 0;

  -- If the event is a filing, update the tasks of the matters linked by event (typically the tasks based on the priority date)
  IF NEW.code = 'FIL' THEN
	OPEN cur_linked;
	recalc_linked: LOOP
		FETCH cur_linked INTO vid;
		IF done THEN 
			LEAVE recalc_linked; 
		END IF;
		CALL recalculate_tasks(vid, 'FIL');
	END LOOP recalc_linked;
	CLOSE cur_linked;
  END IF;

  -- Recalculate tasks based on the priority date or a parent case upon inserting a new priority claim or a parent filed event
  IF NEW.code IN ('PRI', 'PFIL') THEN
    CALL recalculate_tasks(NEW.matter_id, 'FIL');
  END IF;

  -- Set matter to dead upon inserting a killer event
  SELECT killer INTO vdead FROM event_name WHERE NEW.code=event_name.code;
  IF vdead THEN
    UPDATE matter SET dead = 1 WHERE matter.id=NEW.matter_id;
  END IF;
  
  -- Ensure that we are not in a nested trigger before updating the matter change time
  IF NEW.code != 'CRE' THEN
	UPDATE matter SET updated = Now(), updater = SUBSTRING_INDEX(USER(),'@',1) WHERE matter.id=NEW.matter_id;
  END IF;

END trig */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `event_before_update` BEFORE UPDATE ON `event` FOR EACH ROW BEGIN
	DECLARE vdate DATE DEFAULT NULL;
	
	SET new.updater=SUBSTRING_INDEX(USER(),'@',1);
	-- Date taken from Filed event in linked matter
	IF NEW.alt_matter_id IS NOT NULL THEN
		SELECT event_date INTO vdate FROM event WHERE code='FIL' AND NEW.alt_matter_id=matter_id;
		SET NEW.event_date = vdate;
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `event_after_update` AFTER UPDATE ON `event` FOR EACH ROW trig: BEGIN

  DECLARE vdue_date, vbase_date DATE DEFAULT NULL;
  DECLARE vtask_id, vdays, vmonths, vyears, vrecurring, vpta, vid INT DEFAULT NULL;
  DECLARE done, vend_of_month, vunique, vuse_parent, vuse_priority BOOLEAN DEFAULT 0;
  DECLARE vcategory, vcountry CHAR(5) DEFAULT NULL;

  
  DECLARE cur_rule CURSOR FOR 
    SELECT task.id, days, months, years, recurring, end_of_month, use_parent, use_priority
    FROM task_rules, task
    WHERE task.rule_used=task_rules.id
	AND task.trigger_id=NEW.id;

  
  DECLARE cur_linked CURSOR FOR
	SELECT matter_id FROM event WHERE alt_matter_id=NEW.matter_id;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  
  IF (OLD.event_date = NEW.event_date AND NEW.alt_matter_id <=> OLD.alt_matter_id) THEN
    LEAVE trig;
  END IF;

  SET vbase_date=NEW.event_date;

  OPEN cur_rule;
  
  update_tasks: LOOP
    FETCH cur_rule INTO vtask_id, vdays, vmonths, vyears, vrecurring, vend_of_month, vuse_parent, vuse_priority;
    IF done THEN 
      LEAVE update_tasks; 
    END IF;
	
	
	IF vuse_parent THEN
		SELECT CAST(IFNULL(min(event_date), NEW.event_date) AS DATE) INTO vbase_date FROM event_lnk_list WHERE code='PFIL' AND matter_id=NEW.matter_id;
	END IF;
	
	
	IF vuse_priority THEN
		SELECT CAST(IFNULL(min(event_date), NEW.event_date) AS DATE) INTO vbase_date FROM event_lnk_list WHERE code='PRI' AND matter_id=NEW.matter_id;
	END IF;

	
    SET vdue_date = vbase_date + INTERVAL vdays DAY + INTERVAL vmonths MONTH + INTERVAL vyears YEAR;
    IF vend_of_month THEN
      SET vdue_date=LAST_DAY(vdue_date);
    END IF;

    UPDATE task set due_date=vdue_date WHERE id=vtask_id;

  END LOOP update_tasks;
  CLOSE cur_rule;

  SET done = 0;
 
  
  IF NEW.code = 'FIL' THEN
	  OPEN cur_linked;
	  recalc_linked: LOOP
		FETCH cur_linked INTO vid;
		IF done THEN 
		  LEAVE recalc_linked; 
		END IF;
		CALL recalculate_tasks(vid, 'FIL');
		CALL recalculate_tasks(vid, 'PRI');
	  END LOOP recalc_linked;
	  CLOSE cur_linked;
  END IF;

  
  IF NEW.code IN ('PRI', 'PFIL') THEN  
    CALL recalculate_tasks(NEW.matter_id, 'FIL');
  END IF;

  IF NEW.code IN ('FIL', 'PFIL') THEN  
	
    SELECT category_code, term_adjust, country INTO vcategory, vpta, vcountry FROM matter WHERE matter.id=NEW.matter_id;
    SELECT months, years INTO vmonths, vyears FROM task_rules 
		WHERE task='EXP' 
		AND for_category=vcategory 
		AND (for_country=vcountry OR (for_country IS NULL AND NOT EXISTS (SELECT 1 FROM task_rules tr WHERE task_rules.task=tr.task AND for_country=vcountry)));
    SELECT IFNULL(min(event_date), NEW.event_date) INTO vbase_date FROM event_lnk_list WHERE code='PFIL' AND matter_id=NEW.matter_id;
    SET vdue_date = vbase_date + INTERVAL vpta DAY + INTERVAL vmonths MONTH + INTERVAL vyears YEAR;
    UPDATE matter SET expire_date=vdue_date WHERE matter.id=NEW.matter_id;
  END IF;
  
  UPDATE matter SET updated = Now(), updater = SUBSTRING_INDEX(USER(),'@',1) WHERE matter.id=NEW.matter_id;

END trig */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `event_after_delete` AFTER DELETE ON `event` FOR EACH ROW BEGIN
	IF OLD.code IN ('PRI','PFIL') THEN
		CALL recalculate_tasks(OLD.matter_id, 'FIL');
	END IF;

	IF OLD.code='FIL' THEN
		UPDATE matter SET expire_date=NULL WHERE matter.id=OLD.matter_id;
	END IF;

	UPDATE matter, event_name SET matter.dead=0 WHERE matter.id=OLD.matter_id AND OLD.code=event_name.code AND event_name.killer=1 
		AND (matter.expire_date > Now() OR matter.expire_date IS NULL)
		AND NOT EXISTS (SELECT 1 FROM event, event_name ename WHERE event.matter_id=OLD.matter_id AND event.code=ename.code AND ename.killer=1);
        
	UPDATE matter SET updated = Now(), updater = SUBSTRING_INDEX(USER(),'@',1) WHERE matter.id=OLD.matter_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event_name` (
  `code` char(5) NOT NULL,
  `name` varchar(45) NOT NULL,
  `category` char(5) DEFAULT NULL COMMENT 'Category to which this event is specific',
  `country` char(2) DEFAULT NULL COMMENT 'Country to which the event is specific. If NULL, any country may use the event',
  `is_task` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Indicates whether the event is a task',
  `status_event` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Indicates whether the event should be displayed as a status',
  `default_responsible` char(16) DEFAULT NULL COMMENT 'Login of the user who is systematically responsible for this type of task',
  `use_matter_resp` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Set if the matter responsible should also be set as responsible for the task. Overridden if default_responsible is set',
  `unique` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Only one such event can exist',
  `uqtrigger` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Can only be triggered by one event',
  `killer` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Indicates whether this event kills the patent (set patent.dead to 1)',
  `notes` varchar(160) DEFAULT NULL,
  `creator` char(16) DEFAULT NULL,
  `updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updater` char(16) DEFAULT NULL,
  PRIMARY KEY (`code`),
  KEY `fk_responsible` (`default_responsible`),
  CONSTRAINT `fk_dflt_responsible` FOREIGN KEY (`default_responsible`) REFERENCES `actor` (`login`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Event and task names';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ename_before_insert` BEFORE INSERT ON `event_name` FOR EACH ROW set new.creator=SUBSTRING_INDEX(USER(),'@',1) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ename_before_update` BEFORE UPDATE ON `event_name` FOR EACH ROW set new.updater=SUBSTRING_INDEX(USER(),'@',1) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ename_after_update` AFTER UPDATE ON `event_name` FOR EACH ROW BEGIN

	IF IFNULL(NEW.default_responsible,0) != IFNULL(OLD.default_responsible,0) THEN
		UPDATE task SET assigned_to=NEW.default_responsible
		WHERE code=NEW.code AND assigned_to <=> OLD.default_responsible;
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `matter` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `category_code` char(5) NOT NULL,
  `caseref` varchar(30) NOT NULL COMMENT 'Case reference for the database user. The references for the other actors (client, agent, etc.) are in the actor link table.',
  `country` char(2) NOT NULL COMMENT 'Country where the patent is filed',
  `origin` char(2) DEFAULT NULL COMMENT 'Code of the regional system the patent originates from (mainly EP or WO)',
  `type_code` char(5) DEFAULT NULL,
  `idx` tinyint(4) DEFAULT NULL COMMENT 'Increment this to differentiate multiple patents filed in the same country in the same family',
  `parent_ID` int(11) DEFAULT NULL COMMENT 'Link to parent patent. Used to create a hierarchy',
  `container_ID` int(11) DEFAULT NULL COMMENT 'Identifies the container matter from which this matter gathers its shared data. If null, this matter is a container',
  `responsible` char(16) NOT NULL COMMENT 'Database user responsible for the patent',
  `dead` tinyint(1) DEFAULT '0' COMMENT 'Indicates whether the case is removed from the watch system',
  `notes` text,
  `expire_date` date DEFAULT NULL,
  `term_adjust` smallint(6) NOT NULL DEFAULT '0' COMMENT 'Patent term adjustment in days. Essentially for US patents.',
  `creator` char(16) DEFAULT NULL COMMENT 'ID of the user who created the record',
  `updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Record modification date',
  `updater` char(16) DEFAULT NULL COMMENT 'ID of the user who last modified the record',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UID` (`caseref`,`origin`,`country`,`type_code`,`idx`),
  KEY `country` (`country`) USING HASH,
  KEY `type` (`type_code`) USING HASH,
  KEY `origin` (`origin`) USING HASH,
  KEY `container` (`container_ID`) USING HASH,
  KEY `parent` (`parent_ID`) USING HASH,
  KEY `category` (`category_code`) USING HASH,
  KEY `responsible` (`responsible`) USING HASH,
  KEY `sort` (`caseref`,`container_ID`,`origin`,`country`,`type_code`,`idx`),
  CONSTRAINT `fk_matter_category` FOREIGN KEY (`category_code`) REFERENCES `matter_category` (`code`) ON UPDATE CASCADE,
  CONSTRAINT `fk_matter_container` FOREIGN KEY (`container_ID`) REFERENCES `matter` (`ID`) ON UPDATE CASCADE,
  CONSTRAINT `fk_matter_country` FOREIGN KEY (`country`) REFERENCES `country` (`iso`) ON UPDATE CASCADE,
  CONSTRAINT `fk_matter_origin` FOREIGN KEY (`origin`) REFERENCES `country` (`iso`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_matter_parent` FOREIGN KEY (`parent_ID`) REFERENCES `matter` (`ID`) ON UPDATE CASCADE,
  CONSTRAINT `fk_matter_responsible` FOREIGN KEY (`responsible`) REFERENCES `actor` (`login`) ON UPDATE CASCADE,
  CONSTRAINT `fk_matter_type` FOREIGN KEY (`type_code`) REFERENCES `matter_type` (`code`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
INSERT INTO `matter` (`ID`, `category_code`, `caseref`, `country`, `origin`, `type_code`, `idx`, `parent_ID`, `container_ID`, `responsible`, `dead`, `notes`, `expire_date`, `term_adjust`, `creator`, `updated`, `updater`)
VALUES
	(4,'PRO','PAT001','US',NULL,NULL,NULL,NULL,NULL,'phpipuser',0,NULL,'2015-04-04',0,'phpipuser','2017-12-04 18:30:26','root'),
	(5,'PAT','PAT001','WO',NULL,NULL,NULL,NULL,4,'phpipuser',1,NULL,'2016-11-04',0,'phpipuser','2017-12-04 18:30:26','root'),
	(6,'PAT','PAT001','CN','WO',NULL,NULL,5,4,'phpipuser',0,NULL,'2035-03-19',0,'phpipuser','2017-12-04 18:30:26','root'),
	(7,'PAT','PAT001','EP','WO',NULL,NULL,5,4,'phpipuser',0,NULL,'2035-03-19',0,'phpipuser','2017-12-04 18:30:26','root'),
	(8,'PAT','PAT001','JP','WO',NULL,NULL,5,4,'phpipuser',0,NULL,'2035-03-19',0,'phpipuser','2017-12-04 18:30:26','root'),
	(9,'PAT','PAT001','KR','WO',NULL,NULL,5,4,'phpipuser',0,NULL,'2035-03-19',0,'phpipuser','2017-12-04 18:30:26','root'),
	(10,'PAT','PAT001','US','WO',NULL,NULL,5,4,'phpipuser',0,NULL,'2035-03-19',0,'phpipuser','2017-12-04 18:30:26','root');
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `matter_before_insert` BEFORE INSERT ON `matter` FOR EACH ROW set new.creator=SUBSTRING_INDEX(USER(),'@',1) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `matter_after_insert` AFTER INSERT ON `matter` FOR EACH ROW BEGIN
	DECLARE vactorid, vshared INT DEFAULT NULL;
	DECLARE vrole CHAR(5) DEFAULT NULL;

	
	INSERT INTO event (code, matter_id, event_date) VALUES ('CRE', NEW.id, now());
	
	
	SELECT actor_id, role, shared INTO vactorid, vrole, vshared FROM default_actor
	WHERE for_client IS NULL
	AND (for_country=NEW.country OR (for_country IS null AND NOT EXISTS (SELECT 1 FROM default_actor da WHERE da.for_country=NEW.country AND for_category=NEW.category_code)))
	AND for_category=NEW.category_code;

	
	IF (vactorid is NOT NULL AND (vshared=0 OR (vshared=1 AND NEW.container_id IS NULL))) THEN
		INSERT INTO matter_actor_lnk (matter_id, actor_id, role, shared) VALUES (NEW.id, vactorid, vrole, vshared);
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `matter_before_update` BEFORE UPDATE ON `matter` FOR EACH ROW BEGIN

set new.updater=SUBSTRING_INDEX(USER(),'@',1);


IF NEW.term_adjust != OLD.term_adjust THEN
	SET NEW.expire_date = OLD.expire_date + INTERVAL (NEW.term_adjust - OLD.term_adjust) DAY;
END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `matter_after_update` AFTER UPDATE ON `matter` FOR EACH ROW BEGIN


IF NEW.responsible != OLD.responsible THEN
	UPDATE task JOIN event ON (task.trigger_id=event.id AND event.matter_id=NEW.id) SET task.assigned_to=NEW.responsible
	WHERE task.done=0 AND task.assigned_to=OLD.responsible;
END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `matter_actor_lnk` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `matter_ID` int(11) NOT NULL,
  `actor_ID` int(11) NOT NULL,
  `display_order` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Order in which the actor should be displayed in a list of same type actors',
  `role` char(5) NOT NULL COMMENT 'Link to ''actor_types''',
  `shared` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Copied from the actor_role.shareable field. Indicates that this information, stored in the "container", is shared among members of the same family',
  `actor_ref` varchar(45) DEFAULT NULL COMMENT 'Actor''s reference',
  `company_ID` int(11) DEFAULT NULL COMMENT 'A copy of the actor''s company ID, if applicable, at the time the link was created.',
  `rate` decimal(5,2) DEFAULT '100.00' COMMENT 'For co-owners - rate of ownership, or inventors',
  `date` date DEFAULT NULL COMMENT 'A date field that can, for instance, contain the date of ownership change',
  `creator` char(16) DEFAULT NULL,
  `updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updater` char(16) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uqactor_role` (`matter_ID`,`role`,`actor_ID`) USING BTREE,
  KEY `actor_ref` (`actor_ref`) USING BTREE,
  KEY `actor_lnk` (`actor_ID`) USING HASH,
  KEY `role_lnk` (`role`) USING HASH,
  KEY `company_lnk` (`company_ID`) USING HASH,
  CONSTRAINT `fk_lnk_actor` FOREIGN KEY (`actor_ID`) REFERENCES `actor` (`ID`) ON UPDATE CASCADE,
  CONSTRAINT `fk_lnk_company` FOREIGN KEY (`company_ID`) REFERENCES `actor` (`ID`) ON UPDATE CASCADE,
  CONSTRAINT `fk_lnk_matter` FOREIGN KEY (`matter_ID`) REFERENCES `matter` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_lnk_role` FOREIGN KEY (`role`) REFERENCES `actor_role` (`code`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
INSERT INTO `matter_actor_lnk` (`ID`, `matter_ID`, `actor_ID`, `display_order`, `role`, `shared`, `actor_ref`, `company_ID`, `rate`, `date`, `creator`, `updated`, `updater`)
VALUES
	(5,4,124,1,'CLI',1,'',NULL,100.00,'2017-12-03','phpipuser','2017-12-03 16:35:36',NULL),
	(6,4,124,1,'APP',1,'',NULL,100.00,'2017-12-03','phpipuser','2017-12-03 16:36:39',NULL),
	(7,4,125,1,'INV',1,'',124,100.00,'2017-12-03','phpipuser','2017-12-03 16:37:44',NULL),
	(8,4,126,2,'INV',1,'',124,100.00,'2017-12-03','phpipuser','2017-12-03 16:38:34',NULL),
	(9,4,127,3,'INV',1,'',124,100.00,'2017-12-03','phpipuser','2017-12-03 16:45:26',NULL),
	(10,7,128,1,'AGT',0,'AKUB30001',NULL,100.00,'2017-12-03','phpipuser','2017-12-03 17:39:40','phpipuser'),
	(11,5,129,1,'AGT',0,'',NULL,100.00,'2017-12-03','phpipuser','2017-12-03 17:33:39',NULL),
	(12,10,130,1,'AGT',0,'P0653-2NUS',NULL,100.00,'2017-12-03','phpipuser','2017-12-03 17:38:25','phpipuser');
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `malnk_before_insert` BEFORE INSERT ON `matter_actor_lnk` FOR EACH ROW set new.creator=SUBSTRING_INDEX(USER(),'@',1) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `malnk_after_insert` AFTER INSERT ON `matter_actor_lnk` FOR EACH ROW BEGIN
	DECLARE vcli_ann_agt INT DEFAULT NULL;

	-- Delete renewal tasks when the special actor "CLIENT" is set as the annuity agent
	IF NEW.role='ANN' THEN
		SELECT id INTO vcli_ann_agt FROM actor WHERE display_name='CLIENT';
		IF NEW.actor_id=vcli_ann_agt THEN
			DELETE task FROM event INNER JOIN task ON task.trigger_id=event.id
			WHERE task.code='REN' AND event.matter_id=NEW.matter_id;
		END IF;
	END IF;

	-- Check that we are not in a nested trigger before updating the matter change time
	IF (SELECT count(1) FROM default_actor WHERE NEW.actor_id = actor_id) = 0 THEN
		UPDATE matter SET updated = Now(), updater = SUBSTRING_INDEX(USER(),'@',1) WHERE matter.id=NEW.matter_id;
	END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `malnk_before_update` BEFORE UPDATE ON `matter_actor_lnk` FOR EACH ROW set new.updater=SUBSTRING_INDEX(USER(),'@',1) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `matter_actor_lnk_AFTER_UPDATE` AFTER UPDATE ON `matter_actor_lnk` FOR EACH ROW
BEGIN

	UPDATE matter SET updated = Now(), updater = SUBSTRING_INDEX(USER(),'@',1) WHERE matter.id=NEW.matter_id;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `matter_actor_lnk_AFTER_DELETE` AFTER DELETE ON `matter_actor_lnk` FOR EACH ROW
BEGIN

	UPDATE matter SET updated = Now(), updater = SUBSTRING_INDEX(USER(),'@',1) WHERE matter.id=OLD.matter_id;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `matter_category` (
  `code` char(5) NOT NULL,
  `ref_prefix` varchar(5) DEFAULT NULL COMMENT 'Used to build the case reference',
  `category` varchar(45) NOT NULL,
  `display_with` char(5) NOT NULL DEFAULT '''PAT''' COMMENT 'Display with the indicated category in the interface',
  `creator` char(16) DEFAULT NULL,
  `updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updater` char(16) DEFAULT NULL,
  PRIMARY KEY (`code`),
  KEY `display_with` (`display_with`) USING HASH,
  CONSTRAINT `fk_displaywith` FOREIGN KEY (`display_with`) REFERENCES `matter_category` (`code`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `mcateg_creator_log` BEFORE INSERT ON `matter_category` FOR EACH ROW set new.creator=SUBSTRING_INDEX(USER(),'@',1) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `mcateg_updater_log` BEFORE UPDATE ON `matter_category` FOR EACH ROW set new.updater=SUBSTRING_INDEX(USER(),'@',1) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `matter_type` (
  `code` char(5) NOT NULL,
  `type` varchar(45) NOT NULL,
  `creator` varchar(20) DEFAULT NULL,
  `updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updater` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `mtype_creator_log` BEFORE INSERT ON `matter_type` FOR EACH ROW set new.creator=SUBSTRING_INDEX(USER(),'@',1) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `mtype_updater_log` BEFORE UPDATE ON `matter_type` FOR EACH ROW set new.updater=SUBSTRING_INDEX(USER(),'@',1) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `trigger_ID` int(11) unsigned NOT NULL COMMENT 'Link to generating event',
  `code` char(5) NOT NULL COMMENT 'Task code. Link to event_names table',
  `due_date` date NOT NULL,
  `assigned_to` char(16) DEFAULT NULL COMMENT 'User responsible for the task (if not the user responsible for the case)',
  `detail` varchar(45) DEFAULT NULL COMMENT 'Numbers or short comments',
  `done` tinyint(1) DEFAULT '0' COMMENT 'Set to 1 when task done',
  `done_date` date DEFAULT NULL COMMENT 'Optional task completion date',
  `rule_used` int(11) DEFAULT NULL COMMENT 'ID of the rule that was used to set this task',
  `time_spent` time DEFAULT NULL COMMENT 'Time spent by attorney on task',
  `notes` varchar(150) DEFAULT NULL,
  `cost` decimal(6,2) DEFAULT NULL COMMENT 'The estimated or invoiced fee amount',
  `fee` decimal(6,2) DEFAULT NULL,
  `currency` char(3) DEFAULT 'EUR',
  `creator` char(16) DEFAULT NULL,
  `updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updater` char(16) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `code` (`code`) USING HASH,
  KEY `responsible` (`assigned_to`) USING HASH,
  KEY `task_rule` (`rule_used`) USING HASH,
  KEY `due_date` (`due_date`) USING BTREE,
  KEY `detail` (`detail`),
  KEY `trigger_id` (`trigger_ID`),
  CONSTRAINT `fk_assigned_to` FOREIGN KEY (`assigned_to`) REFERENCES `actor` (`login`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_task_code` FOREIGN KEY (`code`) REFERENCES `event_name` (`code`) ON UPDATE CASCADE,
  CONSTRAINT `fk_task_rule` FOREIGN KEY (`rule_used`) REFERENCES `task_rules` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_trigger_id` FOREIGN KEY (`trigger_ID`) REFERENCES `event` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tasks triggered by events from country law information';
/*!40101 SET character_set_client = @saved_cs_client */;
INSERT INTO `task` (`ID`, `trigger_ID`, `code`, `due_date`, `assigned_to`, `detail`, `done`, `done_date`, `rule_used`, `time_spent`, `notes`, `cost`, `fee`, `currency`, `creator`, `updated`, `updater`)
VALUES
	(122,26,'PRID','2015-04-04',NULL,NULL,1,'2015-03-19',NULL,NULL,NULL,NULL,NULL,'EUR','phpipuser','2017-12-03 16:42:58','phpipuser'),
	(123,29,'NPH','2016-10-04',NULL,NULL,1,'2016-10-04',NULL,NULL,NULL,NULL,NULL,'EUR','phpipuser','2017-12-03 16:55:13','phpipuser'),
	(124,39,'REN','2018-03-31',NULL,'4',0,NULL,204,NULL,NULL,580.00,NULL,'EUR','phpipuser','2017-12-03 16:58:16',NULL),
	(125,39,'REN','2019-03-31',NULL,'5',0,NULL,205,NULL,NULL,810.00,NULL,'EUR','phpipuser','2017-12-03 16:58:16',NULL),
	(126,39,'REN','2020-03-31',NULL,'6',0,NULL,206,NULL,NULL,1040.00,NULL,'EUR','phpipuser','2017-12-03 16:58:16',NULL),
	(127,39,'REN','2021-03-31',NULL,'7',0,NULL,207,NULL,NULL,1155.00,NULL,'EUR','phpipuser','2017-12-03 16:58:16',NULL),
	(128,39,'REN','2022-03-31',NULL,'8',0,NULL,208,NULL,NULL,1265.00,NULL,'EUR','phpipuser','2017-12-03 16:58:16',NULL),
	(129,39,'REN','2023-03-31',NULL,'9',0,NULL,209,NULL,NULL,1380.00,NULL,'EUR','phpipuser','2017-12-03 16:58:16',NULL),
	(130,39,'REN','2024-03-31',NULL,'10',0,NULL,210,NULL,NULL,1560.00,NULL,'EUR','phpipuser','2017-12-03 16:58:16',NULL),
	(131,39,'REN','2025-03-31',NULL,'11',0,NULL,211,NULL,NULL,1560.00,NULL,'EUR','phpipuser','2017-12-03 16:58:16',NULL),
	(132,39,'REN','2026-03-31',NULL,'12',0,NULL,212,NULL,NULL,1560.00,NULL,'EUR','phpipuser','2017-12-03 16:58:16',NULL),
	(133,39,'REN','2027-03-31',NULL,'13',0,NULL,213,NULL,NULL,1560.00,NULL,'EUR','phpipuser','2017-12-03 16:58:16',NULL),
	(134,39,'REN','2028-03-31',NULL,'14',0,NULL,214,NULL,NULL,1560.00,NULL,'EUR','phpipuser','2017-12-03 16:58:16',NULL),
	(135,39,'REN','2029-03-31',NULL,'15',0,NULL,215,NULL,NULL,1560.00,NULL,'EUR','phpipuser','2017-12-03 16:58:16',NULL),
	(136,39,'REN','2030-03-31',NULL,'16',0,NULL,216,NULL,NULL,1560.00,NULL,'EUR','phpipuser','2017-12-03 16:58:16',NULL),
	(137,39,'REN','2031-03-31',NULL,'17',0,NULL,217,NULL,NULL,1560.00,NULL,'EUR','phpipuser','2017-12-03 16:58:16',NULL),
	(138,39,'REN','2032-03-31',NULL,'18',0,NULL,218,NULL,NULL,1560.00,NULL,'EUR','phpipuser','2017-12-03 16:58:16',NULL),
	(139,39,'REN','2033-03-31',NULL,'19',0,NULL,219,NULL,NULL,1560.00,NULL,'EUR','phpipuser','2017-12-03 16:58:16',NULL),
	(140,39,'REN','2034-03-31',NULL,'20',0,NULL,220,NULL,NULL,1560.00,NULL,'EUR','phpipuser','2017-12-03 16:58:16',NULL),
	(141,45,'REQ','2018-03-19',NULL,NULL,0,NULL,6,NULL,NULL,NULL,NULL,'EUR','phpipuser','2017-12-03 16:58:16',NULL),
	(142,51,'REQ','2018-03-19',NULL,NULL,0,NULL,53,NULL,NULL,NULL,NULL,'EUR','phpipuser','2017-12-03 16:58:16',NULL),
	(160,39,'REN','2017-03-31',NULL,'3',1,'2017-03-31',NULL,NULL,NULL,NULL,NULL,'EUR','phpipuser','2017-12-03 17:08:01','phpipuser'),
	(161,67,'REP','2017-10-28','phpipuser',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,'EUR','phpipuser','2017-12-03 17:19:25',NULL);
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `task_before_insert` BEFORE INSERT ON task FOR EACH ROW

BEGIN

	DECLARE vflag BOOLEAN;
	DECLARE vresp CHAR(16);

	SET NEW.creator = SUBSTRING_INDEX(USER(),'@',1);

	SELECT use_matter_resp INTO vflag FROM event_name WHERE event_name.code=NEW.code;
	SELECT responsible INTO vresp FROM matter, event WHERE event.id=NEW.trigger_id AND matter.id=event.matter_id;

	IF NEW.assigned_to IS NULL THEN
		IF vflag = 0 THEN
			SET NEW.assigned_to = (SELECT default_responsible FROM event_name WHERE event_name.code=NEW.code);	
		ELSE
			SET NEW.assigned_to = (SELECT ifnull(default_responsible, vresp) FROM event_name WHERE event_name.code=NEW.code);
		END IF;
	ELSEIF NEW.assigned_to = '0' THEN
		SET NEW.assigned_to = vresp;
	END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `task_before_update` BEFORE UPDATE ON `task` FOR EACH ROW
BEGIN
	SET NEW.updater=SUBSTRING_INDEX(USER(),'@',1);
	IF NEW.done_date IS NOT NULL AND OLD.done_date IS NULL AND OLD.done = 0 THEN
		SET NEW.done = 1;
	END IF;
	IF NEW.done_date IS NULL AND OLD.done_date IS NOT NULL AND OLD.done = 1 THEN
		SET NEW.done = 0;
	END IF;
	IF NEW.done = 1 AND OLD.done = 0 AND OLD.done_date IS NULL THEN
		SET NEW.done_date = Least(OLD.due_date, Now());
	END IF;
	IF NEW.done = 0 AND OLD.done = 1 AND OLD.done_date IS NOT NULL THEN
		SET NEW.done_date = NULL;
	END IF;
	/*IF NEW.due_date != OLD.due_date AND old.rule_used IS NOT NULL THEN
		SET NEW.rule_used = NULL;
	END IF;*/
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task_rules` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `active` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Indicates whether the rule should be used',
  `task` char(5) NOT NULL COMMENT 'Code of task that is created (or cleared)',
  `trigger_event` char(5) NOT NULL COMMENT 'Event that generates this task',
  `clear_task` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Identifies an open task in the matter that is cleared when this one is created',
  `delete_task` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Identifies a task type to be deleted from the matter when this one is created',
  `for_category` char(5) NOT NULL DEFAULT 'PAT' COMMENT 'Category to which this rule applies.',
  `for_country` char(2) DEFAULT NULL COMMENT 'Country where rule is applicable. If NULL, applies to all countries',
  `for_origin` char(5) DEFAULT NULL,
  `for_type` char(5) DEFAULT NULL COMMENT 'Type to which rule is applicable. If null, rule applies to all types',
  `detail` varchar(45) DEFAULT NULL COMMENT 'Additional information on task',
  `days` int(11) NOT NULL DEFAULT '0' COMMENT 'For task deadline calculation',
  `months` int(11) NOT NULL DEFAULT '0' COMMENT 'For task deadline calculation',
  `years` int(11) NOT NULL DEFAULT '0' COMMENT 'For task deadline calculation',
  `recurring` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'If non zero, indicates the recurring period in months. Mainly for annuities',
  `end_of_month` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'The deadline is at the end of the month. Mainly for annuities',
  `abort_on` char(5) DEFAULT NULL COMMENT 'Task won''t be created if this event exists',
  `condition_event` char(5) DEFAULT NULL COMMENT 'Task will only be created if this event exists',
  `use_parent` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'The due date is calculated from the same event in the top parent (eg. for calculating annuities for a divisional)',
  `use_priority` tinyint(1) NOT NULL DEFAULT '0',
  `use_before` date DEFAULT NULL COMMENT 'Task will be created only if the base event is before this date',
  `use_after` date DEFAULT NULL COMMENT 'Task will be created only if the base event is after this date',
  `cost` decimal(6,2) DEFAULT NULL,
  `fee` decimal(6,2) DEFAULT NULL,
  `currency` char(3) DEFAULT 'EUR',
  `responsible` char(16) DEFAULT NULL COMMENT 'The person (login) responsible for this task. If 0, insert the matter responsible.',
  `notes` text,
  `creator` char(16) DEFAULT NULL,
  `updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updater` char(16) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `task` (`task`) USING HASH,
  KEY `abort_on` (`abort_on`) USING HASH,
  KEY `condition` (`condition_event`) USING HASH,
  KEY `for_country` (`for_country`),
  KEY `trigger_event` (`trigger_event`,`for_country`) USING BTREE,
  KEY `for_origin` (`for_origin`),
  KEY `fk_category` (`for_category`),
  CONSTRAINT `fk_abort_on` FOREIGN KEY (`abort_on`) REFERENCES `event_name` (`code`) ON UPDATE CASCADE,
  CONSTRAINT `fk_category` FOREIGN KEY (`for_category`) REFERENCES `matter_category` (`code`) ON UPDATE CASCADE,
  CONSTRAINT `fk_condition` FOREIGN KEY (`condition_event`) REFERENCES `event_name` (`code`) ON UPDATE CASCADE,
  CONSTRAINT `fk_country` FOREIGN KEY (`for_country`) REFERENCES `country` (`iso`) ON UPDATE CASCADE,
  CONSTRAINT `fk_name` FOREIGN KEY (`task`) REFERENCES `event_name` (`code`) ON UPDATE CASCADE,
  CONSTRAINT `fk_origin` FOREIGN KEY (`for_origin`) REFERENCES `country` (`iso`) ON UPDATE CASCADE,
  CONSTRAINT `fk_trigger` FOREIGN KEY (`trigger_event`) REFERENCES `event_name` (`code`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Rules for calculating tasks from events';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trules_before_insert` BEFORE INSERT ON `task_rules` FOR EACH ROW set new.creator=SUBSTRING_INDEX(USER(),'@',1) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trules_before_update` BEFORE UPDATE ON `task_rules` FOR EACH ROW set new.updater=SUBSTRING_INDEX(USER(),'@',1) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trules_after_update` AFTER UPDATE ON `task_rules` FOR EACH ROW BEGIN	
	IF (NEW.fee != OLD.fee OR NEW.cost != OLD.cost) THEN
		UPDATE task SET fee=NEW.fee, cost=NEW.cost WHERE rule_used=NEW.id AND done=0;
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `task_list` AS SELECT 
 1 AS `id`,
 1 AS `code`,
 1 AS `name`,
 1 AS `detail`,
 1 AS `due_date`,
 1 AS `done`,
 1 AS `done_date`,
 1 AS `matter_id`,
 1 AS `cost`,
 1 AS `fee`,
 1 AS `trigger_id`,
 1 AS `category`,
 1 AS `caseref`,
 1 AS `country`,
 1 AS `origin`,
 1 AS `type_code`,
 1 AS `idx`,
 1 AS `responsible`,
 1 AS `delegate`,
 1 AS `rule_used`,
 1 AS `dead`*/;
SET character_set_client = @saved_cs_client;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `event_lnk_list` AS SELECT 
 1 AS `id`,
 1 AS `code`,
 1 AS `matter_id`,
 1 AS `event_date`,
 1 AS `detail`,
 1 AS `country`*/;
SET character_set_client = @saved_cs_client;
/*!50001 DROP VIEW IF EXISTS `task_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `task_list` AS select `task`.`ID` AS `id`,`task`.`code` AS `code`,`event_name`.`name` AS `name`,`task`.`detail` AS `detail`,`task`.`due_date` AS `due_date`,`task`.`done` AS `done`,`task`.`done_date` AS `done_date`,`event`.`matter_ID` AS `matter_id`,`task`.`cost` AS `cost`,`task`.`fee` AS `fee`,`task`.`trigger_ID` AS `trigger_id`,`matter`.`category_code` AS `category`,`matter`.`caseref` AS `caseref`,`matter`.`country` AS `country`,`matter`.`origin` AS `origin`,`matter`.`type_code` AS `type_code`,`matter`.`idx` AS `idx`,ifnull(`task`.`assigned_to`,`matter`.`responsible`) AS `responsible`,`actor`.`login` AS `delegate`,`task`.`rule_used` AS `rule_used`,`matter`.`dead` AS `dead` from (((((`matter` left join `matter_actor_lnk` on(((ifnull(`matter`.`container_ID`,`matter`.`ID`) = `matter_actor_lnk`.`matter_ID`) and (`matter_actor_lnk`.`role` = 'DEL')))) left join `actor` on((`actor`.`ID` = `matter_actor_lnk`.`actor_ID`))) join `event` on((`matter`.`ID` = `event`.`matter_ID`))) join `task` on((`task`.`trigger_ID` = `event`.`ID`))) join `event_name` on((`task`.`code` = `event_name`.`code`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `event_lnk_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `event_lnk_list` AS select `event`.`ID` AS `id`,`event`.`code` AS `code`,`event`.`matter_ID` AS `matter_id`,if(isnull(`event`.`alt_matter_ID`),`event`.`event_date`,`lnk`.`event_date`) AS `event_date`,if(isnull(`event`.`alt_matter_ID`),`event`.`detail`,`lnk`.`detail`) AS `detail`,`matter`.`country` AS `country` from ((`event` left join `event` `lnk` on(((`event`.`alt_matter_ID` = `lnk`.`matter_ID`) and (`lnk`.`code` = 'FIL')))) left join `matter` on((`event`.`alt_matter_ID` = `matter`.`ID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `kill_expired` ON SCHEDULE EVERY 1 WEEK STARTS '2017-01-31 20:23:25' ON COMPLETION PRESERVE DISABLE ON SLAVE COMMENT 'Updates the expired status of matters' DO insert ignore into `event` (code, matter_id, event_date) select 'EXP', matter.id, matter.expire_date from matter where expire_date < Now() and dead=0 */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `actor_list`(mid INT, arole TEXT) RETURNS text CHARSET utf8
    DETERMINISTIC
BEGIN
	DECLARE alist TEXT;
    
    SELECT GROUP_CONCAT(actor.name ORDER BY mal.display_order) INTO alist FROM matter_actor_lnk mal
    JOIN actor ON actor.ID = mal.actor_ID
    WHERE mal.matter_ID = mid AND mal.role = arole;

	RETURN alist;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `lowerword`( str TEXT, word VARCHAR(5) ) RETURNS text CHARSET utf8
    DETERMINISTIC
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE loc INT;

  SET loc = LOCATE(CONCAT(word,' '), str, 2);
  IF loc > 1 THEN
    WHILE i <= LENGTH (str) AND loc <> 0 DO
      SET str = INSERT(str,loc,LENGTH(word),LCASE(word));
      SET i = loc+LENGTH(word);
      SET loc = LOCATE(CONCAT(word,' '), str, i);
    END WHILE;
  END IF;
  RETURN str;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `matter_status`(mid INT) RETURNS text CHARSET utf8
    DETERMINISTIC
BEGIN
	DECLARE mstatus TEXT;
    SELECT CONCAT_WS(': ', event_name.name, status.event_date) INTO mstatus FROM `event` status
	JOIN event_name ON mid=status.matter_ID AND event_name.code=status.code AND event_name.status_event=1
	LEFT JOIN (event e2, event_name en2) ON e2.code=en2.code AND en2.status_event=1 AND mid=e2.matter_id AND status.event_date < e2.event_date
	WHERE e2.matter_id IS NULL;

	RETURN mstatus;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `tcase`( str TEXT) RETURNS text CHARSET utf8
    DETERMINISTIC
BEGIN 
  DECLARE c CHAR(1); 
  DECLARE s TEXT; 
  DECLARE i INT DEFAULT 1; 
  DECLARE bool INT DEFAULT 1; 
  DECLARE punct CHAR(17) DEFAULT ' ()[]{},.-_!@;:?/'; 
  SET s = LCASE( str ); 
  WHILE i <= LENGTH( str ) DO
	SET c = SUBSTRING( s, i, 1 ); 
	IF LOCATE( c, punct ) > 0 THEN 
		SET bool = 1; 
	ELSEIF bool=1 THEN  
          IF c >= 'a' AND c <= 'z' THEN  
              SET s = CONCAT(LEFT(s,i-1),UCASE(c),SUBSTRING(s,i+1)); 
              SET bool = 0; 
          ELSEIF c >= '0' AND c <= '9' THEN 
            SET bool = 0; 
          END IF; 
	END IF; 
		SET i = i+1; 
  END WHILE;

  SET s = lowerword(s, 'A');
  SET s = lowerword(s, 'An');
  SET s = lowerword(s, 'And');
  SET s = lowerword(s, 'As');
  SET s = lowerword(s, 'At');
  SET s = lowerword(s, 'But');
  SET s = lowerword(s, 'By');
  SET s = lowerword(s, 'For');
  SET s = lowerword(s, 'If');
  SET s = lowerword(s, 'In');
  SET s = lowerword(s, 'Of');
  SET s = lowerword(s, 'On');
  SET s = lowerword(s, 'Or');
  SET s = lowerword(s, 'The');
  SET s = lowerword(s, 'To');
  SET s = lowerword(s, 'Via');

  RETURN s; 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `recalculate_tasks`(IN Pmatter_id int, IN Ptrig_code char(5))
proc: BEGIN
	DECLARE vtrigevent_date, vdue_date, vbase_date DATE DEFAULT NULL;
	DECLARE vtask_id, vtrigevent_id, vdays, vmonths, vyears, vrecurring, vpta INT DEFAULT NULL;
	DECLARE done, vend_of_month, vunique, vuse_parent, vuse_priority BOOLEAN DEFAULT 0;
	DECLARE vcategory, vcountry CHAR(5) DEFAULT NULL;

	DECLARE cur_rule CURSOR FOR 
		SELECT task.id, days, months, years, recurring, end_of_month, use_parent, use_priority
		FROM task_rules, task
		WHERE task.rule_used=task_rules.id
		AND task.trigger_id=vtrigevent_id;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	IF EXISTS (SELECT 1 FROM event_lnk_list WHERE matter_id=Pmatter_id AND code=Ptrig_code) THEN
		SELECT id, event_date INTO vtrigevent_id, vtrigevent_date FROM event_lnk_list WHERE matter_id=Pmatter_id AND code=Ptrig_code ORDER BY event_date LIMIT 1;
	ELSE
		
		LEAVE proc;
	END IF;

	OPEN cur_rule;
	update_tasks: LOOP
		FETCH cur_rule INTO vtask_id, vdays, vmonths, vyears, vrecurring, vend_of_month, vuse_parent, vuse_priority;
		IF done THEN 
			LEAVE update_tasks; 
		END IF;

		
		IF vuse_parent THEN
			SELECT CAST(IFNULL(min(event_date), vtrigevent_date) AS DATE) INTO vbase_date FROM event_lnk_list WHERE code='PFIL' AND matter_id=Pmatter_id;
		ELSE
			SET vbase_date=vtrigevent_date;
		END IF;

		
		IF vuse_priority THEN
			SELECT CAST(IFNULL(min(event_date), vtrigevent_date) AS DATE) INTO vbase_date FROM event_lnk_list WHERE code='PRI' AND matter_id=Pmatter_id;
		END IF;

		SET vdue_date = vbase_date + INTERVAL vdays DAY + INTERVAL vmonths MONTH + INTERVAL vyears YEAR;
		IF vend_of_month THEN
			SET vdue_date=LAST_DAY(vdue_date);
		END IF;

		UPDATE task set due_date=vdue_date WHERE task.id=vtask_id;
		
	END LOOP update_tasks;
	CLOSE cur_rule;
  
	
	IF Ptrig_code = 'FIL' THEN
		SELECT category_code, term_adjust, country INTO vcategory, vpta, vcountry FROM matter WHERE matter.id=Pmatter_id;
		SELECT months, years INTO vmonths, vyears FROM task_rules 
			WHERE task='EXP' 
			AND for_category=vcategory 
			AND (for_country=vcountry OR (for_country IS NULL AND NOT EXISTS (SELECT 1 FROM task_rules tr WHERE task_rules.task=tr.task AND for_country=vcountry)));
		SELECT CAST(IFNULL(min(event_date), vtrigevent_date) AS DATE) INTO vbase_date FROM event_lnk_list WHERE code='PFIL' AND matter_id=Pmatter_id;
		SET vdue_date = vbase_date + INTERVAL vpta DAY + INTERVAL vmonths MONTH + INTERVAL vyears YEAR;
		UPDATE matter SET expire_date=vdue_date WHERE matter.id=Pmatter_id AND IFNULL(expire_date, '0000-00-00') != vdue_date;
	END IF;

END proc ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `recreate_tasks`(IN Ptrigger_id INT)
proc: BEGIN
  DECLARE vevent_date, vdue_date, vbase_date, vexpiry, tmp_date DATE DEFAULT NULL;
  DECLARE vmatter_id, vid_uqtask, vrule_id, vdays, vmonths, vyears, vpta, vid, vcli_ann_agt INT DEFAULT NULL;
  DECLARE vevent, vtask, vtype, vcurrency CHAR(5) DEFAULT NULL;
  DECLARE vdetail, vresponsible VARCHAR(160) DEFAULT NULL;
  DECLARE done, vclear_task, vdelete_task, vend_of_month, vunique, vrecurring, vuse_parent, vuse_priority, vdead BOOLEAN DEFAULT 0;
  DECLARE vcost, vfee DECIMAL(6,2) DEFAULT null;

  
  DECLARE cur_rule CURSOR FOR 
    SELECT task_rules.id, task, clear_task, delete_task, detail, days, months, years, recurring, end_of_month, use_parent, use_priority, cost, fee, currency, task_rules.responsible, event_name.unique
    FROM task_rules, event_name, matter
    WHERE vmatter_id=matter.id
    AND event_name.code=task
    AND vevent=trigger_event
    AND (for_category, ifnull(for_country, matter.country), ifnull(for_origin, matter.origin), ifnull(for_type, matter.type_code))<=>(matter.category_code, matter.country, matter.origin, matter.type_code)
	AND (uqtrigger=0 
		OR (uqtrigger=1 AND NOT EXISTS (SELECT 1 FROM task_rules tr 
		WHERE (tr.task, tr.for_category, tr.for_country)=(task_rules.task, matter.category_code, matter.country) AND tr.trigger_event!=task_rules.trigger_event)))
    AND NOT EXISTS (SELECT 1 FROM event WHERE matter_id=vmatter_id AND code=abort_on)
    AND (condition_event IS null OR EXISTS (SELECT 1 FROM event WHERE matter_id=vmatter_id AND code=condition_event))
    AND (vevent_date < use_before OR use_before IS null)
    AND (vevent_date > use_after OR use_after IS null)
    AND active=1;

  
  DECLARE cur_linked CURSOR FOR
	SELECT matter_id FROM event WHERE alt_matter_id=vmatter_id; 

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  DELETE from task where trigger_id = Ptrigger_id;

  SELECT matter_id, event_date, code INTO vmatter_id, vevent_date, vevent FROM event WHERE id = Ptrigger_id;
  SELECT type_code, dead, expire_date, term_adjust INTO vtype, vdead, vexpiry, vpta FROM matter WHERE matter.id=vmatter_id;
  SELECT id INTO vcli_ann_agt FROM actor WHERE display_name='CLIENT';
  
  
  IF (vdead OR Now() > vexpiry) THEN
    LEAVE proc;
  END IF;

  OPEN cur_rule;
  create_tasks: LOOP
	
	SET vid_uqtask=0;
	SET vbase_date = vevent_date;

    FETCH cur_rule INTO vrule_id, vtask, vclear_task, vdelete_task, vdetail, vdays, vmonths, vyears, vrecurring, vend_of_month, vuse_parent, vuse_priority, vcost, vfee, vcurrency, vresponsible, vunique;
    IF done THEN 
      LEAVE create_tasks; 
    END IF;

	
	IF (vtask='REN' AND EXISTS (SELECT 1 FROM matter_actor_lnk lnk WHERE lnk.role='ANN' AND lnk.actor_id=vcli_ann_agt AND lnk.matter_id=vmatter_id)) THEN
		ITERATE create_tasks;
	END IF;

	
	IF vuse_parent THEN
		SELECT CAST(IFNULL(min(event_date), vevent_date) AS DATE) INTO vbase_date FROM event_lnk_list WHERE code='PFIL' AND matter_id=vmatter_id;
	END IF;

	
	IF vuse_priority THEN
		SELECT CAST(IFNULL(min(event_date), vevent_date) AS DATE) INTO vbase_date FROM event_lnk_list WHERE code='PRI' AND matter_id=vmatter_id;
	END IF;

    
    IF vclear_task THEN
      UPDATE task, event SET task.done=1, task.done_date=vevent_date WHERE task.trigger_id=event.id AND task.code=vtask AND matter_id=vmatter_id AND done=0;
      ITERATE create_tasks;
    END IF;

    
    IF vdelete_task THEN
      DELETE task FROM event INNER JOIN task WHERE task.trigger_id=event.id AND task.code=vtask AND matter_id=vmatter_id;
      ITERATE create_tasks;
    END IF;

    
	IF (vunique OR vevent='PRI') THEN 
		IF EXISTS (SELECT 1 FROM task, event WHERE event.id=task.trigger_id AND event.matter_id=vmatter_id AND task.rule_used=vrule_id) THEN
			SELECT task.id INTO vid_uqtask FROM task, event WHERE event.id=task.trigger_id AND event.matter_id=vmatter_id AND task.rule_used=vrule_id;
		END IF;
	END IF;

	
    IF (!vuse_parent AND !vuse_priority AND (vunique OR vevent='PRI') AND vid_uqtask > 0) THEN
      SELECT min(event_date) INTO vbase_date FROM event_lnk_list WHERE matter_id=vmatter_id AND code=vevent;
      IF vbase_date < vevent_date THEN
		
        ITERATE create_tasks;
      END IF;
    END IF;

    SET vdue_date = vbase_date + INTERVAL vdays DAY + INTERVAL vmonths MONTH + INTERVAL vyears YEAR;
    IF vend_of_month THEN
      SET vdue_date=LAST_DAY(vdue_date);
    END IF;

	
	IF (vtask = 'REN' AND EXISTS (SELECT 1 FROM event WHERE code='PFIL' AND matter_id=vmatter_id) AND vdue_date < vevent_date) THEN
		SET vdue_date = vevent_date + INTERVAL 4 MONTH;
	END IF;

	
    IF (vdue_date < Now() AND vtask NOT IN ('EXP', 'REN')) OR (vdue_date < (Now() - INTERVAL 7 MONTH) AND vtask = 'REN') THEN
      ITERATE create_tasks;
    END IF;

    IF vtask='EXP' THEN
		UPDATE matter SET expire_date = vdue_date + INTERVAL vpta DAY WHERE matter.id=vmatter_id;
	ELSEIF vid_uqtask > 0 THEN
		UPDATE task SET trigger_id=Ptrigger_id, due_date=vdue_date WHERE id=vid_uqtask;
	ELSE
		
		INSERT INTO task (trigger_id,code,due_date,detail,rule_used,cost,fee,currency,assigned_to) values (Ptrigger_id,vtask,vdue_date,vdetail,vrule_id,vcost,vfee,vcurrency,vresponsible);
	END IF;

  END LOOP create_tasks;
  CLOSE cur_rule;

  SET done = 0;

  IF vevent = 'FIL' THEN
	OPEN cur_linked;
	recalc_linked: LOOP
		FETCH cur_linked INTO vid;
		IF done THEN 
			LEAVE recalc_linked; 
		END IF;
		CALL recalculate_tasks(vid, 'FIL');
	END LOOP recalc_linked;
	CLOSE cur_linked;
  END IF;

  
  IF vevent IN ('PRI', 'PFIL') THEN
    CALL recalculate_tasks(vmatter_id, 'FIL');
  END IF;

  
  SELECT killer INTO vdead FROM event_name WHERE vevent=event_name.code;
  IF vdead THEN
    UPDATE matter SET dead=1 WHERE matter.id=vmatter_id;
  END IF;

END proc ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
-- MySQL dump 10.13  Distrib 5.7.18, for Linux (x86_64)
--
-- Host: localhost    Database: phpip
-- ------------------------------------------------------
-- Server version	5.7.18-0ubuntu0.16.04.1-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `actor_role`
--

LOCK TABLES `actor_role` WRITE;
/*!40000 ALTER TABLE `actor_role` DISABLE KEYS */;
INSERT INTO `actor_role` VALUES ('AGT','Primary Agent',20,0,1,0,0,0,3,NULL,NULL,NULL,'2016-03-16 15:49:49',NULL),
('AGT2','Secondary Agent',22,0,1,0,0,0,3,NULL,'Usually the primary agent\'s agent',NULL,'2011-05-05 09:17:57',NULL),
('ANN','Annuity Agent',21,0,1,0,0,0,3,NULL,'Agent in charge of renewals. \"Client handled\" is a special agent who, when added, will delete any renewals in the matter',NULL,'2016-03-16 15:49:49',NULL),
('APP','Applicant',3,1,1,0,0,0,1,NULL,'Assignee in the US, i.e. the owner upon filing',NULL,'2016-03-16 15:49:49',NULL),
('CLI','Client',1,1,1,0,1,0,1,NULL,'The client we take instructions from and who we invoice. DO NOT CHANGE OR DELETE: this is also a database user role',NULL,'2016-04-03 13:56:28',NULL),
('CNT','Contact',30,1,1,1,0,0,4,NULL,'Client\'s contact person',NULL,'2011-05-05 09:19:26',NULL),
('DEL','Delegate',31,1,0,0,0,0,4,NULL,'Another user allowed to manage the case',NULL,'2016-03-16 15:49:50',NULL),
('FAGT','Former Agent',23,0,1,0,0,0,127,'#000000',NULL,NULL,'2012-08-06 09:03:14',NULL),
('FOWN','Former Owner',5,0,0,0,0,1,1,NULL,'To keep track of ownership history',NULL,'2016-03-16 15:49:50',NULL),
('INV','Inventor',10,1,0,1,0,0,2,NULL,NULL,NULL,'2016-03-16 15:49:50',NULL),
('LCN','Licensee',127,0,0,0,0,0,0,NULL,NULL,NULL,'2016-03-16 15:49:50',NULL),
('OFF','Patent Office',127,0,0,0,0,0,0,NULL,NULL,NULL,'2016-03-16 15:49:50',NULL),
('OPP','Opposing Party',127,0,0,0,0,0,0,NULL,NULL,NULL,'2016-03-16 15:49:50',NULL),
('OWN','Owner',4,0,1,0,1,1,1,'NULL','Use if different than applicant',NULL,'2012-12-20 10:13:50',NULL),
('PAY','Payor',2,1,0,0,1,0,1,'#000000','The actor who pays',NULL,'2011-09-27 10:18:42',NULL),
('PTNR','Partner',127,1,0,0,0,0,0,NULL,NULL,NULL,'2016-03-16 15:49:50',NULL),
('TRA','Translator',127,0,0,0,0,1,127,'#000000',NULL,NULL,'2013-12-16 11:47:04',NULL),
('WRI','Writer',127,1,0,0,0,0,0,NULL,'Person who follows the case',NULL,'2016-03-16 15:49:50',NULL);
/*!40000 ALTER TABLE `actor_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `classifier_type`
--

LOCK TABLES `classifier_type` WRITE;
/*!40000 ALTER TABLE `classifier_type` DISABLE KEYS */;
INSERT INTO `classifier_type` VALUES ('ABS','Abstract',0,NULL,127,NULL,NULL,'2011-06-18 15:30:36',NULL),
('AGR','Agreement',0,NULL,127,NULL,NULL,'2011-06-18 15:30:39',NULL),
('BU','Business Unit',0,NULL,127,NULL,NULL,'2011-06-18 15:30:43',NULL),
('DESC','Description',1,NULL,1,NULL,NULL,'2011-09-28 07:15:14',NULL),
('EVAL','Evaluation',0,NULL,127,NULL,NULL,'2011-06-18 15:30:46',NULL),
('IPC','IPC',0,NULL,127,NULL,NULL,'2011-09-28 07:04:43',NULL),
('KW','Keyword',0,NULL,127,NULL,NULL,'2011-09-28 13:22:46',NULL),
('LNK','Link',0,NULL,1,NULL,NULL,'2011-09-28 13:22:41',NULL),
('LOC','Location',0,NULL,127,NULL,NULL,'2013-03-25 16:20:22',NULL),
('ORG','Organization',0,NULL,127,NULL,NULL,'2011-06-18 15:30:57',NULL),
('PA','Prior Art',0,NULL,127,NULL,NULL,'2011-09-28 13:24:11',NULL),
('PROD','Product',0,NULL,127,NULL,NULL,'2011-06-18 15:30:59',NULL),
('PROJ','Project',0,NULL,127,NULL,NULL,'2011-06-18 15:31:02',NULL),
('TECH','Technology',0,NULL,127,NULL,NULL,'2011-06-18 15:31:05',NULL),
('TIT','Title',1,NULL,1,NULL,NULL,'2011-09-28 07:15:28',NULL),
('TITAL','Alt. Title',1,'PAT',4,NULL,NULL,'2011-10-08 16:36:28',NULL),
('TITEN','English Title',1,'PAT',3,NULL,NULL,'2011-06-18 16:14:38',NULL),
('TITOF','Official Title',1,'PAT',2,NULL,NULL,'2011-06-18 16:14:42',NULL),
('TM','Trademark',1,'TM',1,NULL,NULL,'2011-09-28 13:20:24',NULL),
('TMCL','Class (TM)',0,'TM',2,NULL,NULL,'2012-06-18 17:25:26',NULL),
('TMTYP','Type (TM)',0,'TM',3,NULL,NULL,'2012-06-18 17:25:34',NULL);
/*!40000 ALTER TABLE `classifier_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `country`
--

LOCK TABLES `country` WRITE;
/*!40000 ALTER TABLE `country` DISABLE KEYS */;
INSERT INTO `country` VALUES (20,'AD','AND','Andorra','Andorra','Andorre',0,0,0,0),
(784,'AE','ARE','Vereinigte Arabische Emirate','United Arab Emirates','Émirats Arabes Unis',0,0,0,0),
(4,'AF','AFG','Afghanistan','Afghanistan','Afghanistan',0,0,0,0),
(28,'AG','ATG','Antigua und Barbuda','Antigua and Barbuda','Antigua-et-Barbuda',0,0,0,0),
(660,'AI','AIA','Anguilla','Anguilla','Anguilla',0,0,0,0),
(8,'AL','ALB','Albanien','Albania','Albanie',0,0,0,0),
(51,'AM','ARM','Armenien','Armenia','Arménie',0,0,0,0),
(530,'AN','ANT','Niederländische Antillen','Netherlands Antilles','Antilles Néerlandaises',0,0,0,0),
(24,'AO','AGO','Angola','Angola','Angola',0,0,0,0),
(10,'AQ','ATA','Antarktis','Antarctica','Antarctique',0,0,0,0),
(32,'AR','ARG','Argentinien','Argentina','Argentine',0,0,0,0),
(16,'AS','ASM','Amerikanisch-Samoa','American Samoa','Samoa Américaines',0,0,0,0),
(40,'AT','AUT','Österreich','Austria','Autriche',0,0,0,0),
(36,'AU','AUS','Australien','Australia','Australie',0,0,0,0),
(533,'AW','ABW','Aruba','Aruba','Aruba',0,0,0,0),
(248,'AX','ALA','Åland-Inseln','Åland Islands','Îles Åland',0,0,0,0),
(31,'AZ','AZE','Aserbaidschan','Azerbaijan','Azerbaïdjan',0,0,0,0),
(70,'BA','BIH','Bosnien und Herzegowina','Bosnia and Herzegovina','Bosnie-Herzégovine',0,0,0,0),
(52,'BB','BRB','Barbados','Barbados','Barbade',0,0,0,0),
(50,'BD','BGD','Bangladesch','Bangladesh','Bangladesh',0,0,0,0),
(56,'BE','BEL','Belgien','Belgium','Belgique',0,0,0,0),
(854,'BF','BFA','Burkina Faso','Burkina Faso','Burkina Faso',0,0,0,0),
(100,'BG','BGR','Bulgarien','Bulgaria','Bulgarie',0,0,0,0),
(48,'BH','BHR','Bahrain','Bahrain','Bahreïn',0,0,0,0),
(108,'BI','BDI','Burundi','Burundi','Burundi',0,0,0,0),
(204,'BJ','BEN','Benin','Benin','Bénin',0,0,0,0),
(60,'BM','BMU','Bermuda','Bermuda','Bermudes',0,0,0,0),
(96,'BN','BRN','Brunei Darussalam','Brunei Darussalam','Brunéi Darussalam',0,0,0,0),
(68,'BO','BOL','Bolivien','Bolivia','Bolivie',0,0,0,0),
(76,'BR','BRA','Brasilien','Brazil','Brésil',0,0,0,0),
(44,'BS','BHS','Bahamas','Bahamas','Bahamas',0,0,0,0),
(64,'BT','BTN','Bhutan','Bhutan','Bhoutan',0,0,0,0),
(74,'BV','BVT','Bouvetinsel','Bouvet Island','Île Bouvet',0,0,0,0),
(72,'BW','BWA','Botswana','Botswana','Botswana',0,0,0,0),
(0,'BX','BLX','Benelux','Benelux','Bénélux',0,0,0,0),
(112,'BY','BLR','Belarus','Belarus','Bélarus',0,0,0,0),
(84,'BZ','BLZ','Belize','Belize','Belize',0,0,0,0),
(124,'CA','CAN','Kanada','Canada','Canada',0,0,0,0),
(166,'CC','CCK','Kokosinseln','Cocos (Keeling) Islands','Îles Cocos (Keeling)',0,0,0,0),
(180,'CD','COD','Demokratische Republik Kongo','The Democratic Republic Of The Congo','République Démocratique du Congo',0,0,0,0),
(140,'CF','CAF','Zentralafrikanische Republik','Central African','République Centrafricaine',0,0,0,0),
(178,'CG','COG','Republik Kongo','Republic of the Congo','République du Congo',0,0,0,0),
(756,'CH','CHE','Schweiz','Switzerland','Suisse',0,0,0,0),
(384,'CI','CIV','Cote d\'Ivoire','Cote d\'Ivoire','Cote d\'Ivoire',0,0,0,0),
(184,'CK','COK','Cookinseln','Cook Islands','Îles Cook',0,0,0,0),
(152,'CL','CHL','Chile','Chile','Chili',0,0,0,0),
(120,'CM','CMR','Kamerun','Cameroon','Cameroun',0,0,0,0),
(156,'CN','CHN','China','China','Chine',0,1,0,0),
(170,'CO','COL','Kolumbien','Colombia','Colombie',0,0,0,0),
(188,'CR','CRI','Costa Rica','Costa Rica','Costa Rica',0,0,0,0),
(891,'CS','SCG','Serbien und Montenegro','Serbia and Montenegro','Serbie-et-Monténégro',0,0,0,0),
(192,'CU','CUB','Kuba','Cuba','Cuba',0,0,0,0),
(132,'CV','CPV','Kap Verde','Cape Verde','Cap-vert',0,0,0,0),
(162,'CX','CXR','Weihnachtsinsel','Christmas Island','Île Christmas',0,0,0,0),
(196,'CY','CYP','Zypern','Cyprus','Chypre',0,0,0,0),
(203,'CZ','CZE','Tschechische Republik','Czech Republic','République Tchèque',0,0,0,0),
(276,'DE','DEU','Deutschland','Germany','Allemagne',1,0,0,0),
(262,'DJ','DJI','Dschibuti','Djibouti','Djibouti',0,0,0,0),
(208,'DK','DNK','Dänemark','Denmark','Danemark',0,0,0,0),
(212,'DM','DMA','Dominica','Dominica','Dominique',0,0,0,0),
(214,'DO','DOM','Dominikanische Republik','Dominican Republic','République Dominicaine',0,0,0,0),
(12,'DZ','DZA','Algerien','Algeria','Algérie',0,0,0,0),
(218,'EC','ECU','Ecuador','Ecuador','Équateur',0,0,0,0),
(233,'EE','EST','Estland','Estonia','Estonie',0,0,0,0),
(818,'EG','EGY','Ägypten','Egypt','Égypte',0,0,0,0),
(732,'EH','ESH','Westsahara','Western Sahara','Sahara Occidental',0,0,0,0),
(0,'EM','EMA','EUIPO','EUIPO','Office de l’Union européenne pour la propriété intellectuelle',0,0,0,0),
(0,'EP','EPO','Europäische Patentorganisation','European Patent Organization','Organisation du Brevet Européen',0,1,0,0),
(232,'ER','ERI','Eritrea','Eritrea','Érythrée',0,0,0,0),
(724,'ES','ESP','Spanien','Spain','Espagne',0,0,0,0),
(231,'ET','ETH','Äthiopien','Ethiopia','Éthiopie',0,0,0,0),
(246,'FI','FIN','Finnland','Finland','Finlande',0,0,0,0),
(242,'FJ','FJI','Fidschi','Fiji','Fidji',0,0,0,0),
(238,'FK','FLK','Falklandinseln','Falkland Islands','Îles (malvinas) Falkland',0,0,0,0),
(583,'FM','FSM','Mikronesien','Federated States of Micronesia','États Fédérés de Micronésie',0,0,0,0),
(234,'FO','FRO','Färöer','Faroe Islands','Îles Féroé',0,0,0,0),
(250,'FR','FRA','Frankreich','France','France',1,0,0,0),
(266,'GA','GAB','Gabun','Gabon','Gabon',0,0,0,0),
(826,'GB','GBR','Vereinigtes Königreich von Großbritannien und Nordirland','United Kingdom','Royaume-Uni',1,0,0,0),
(308,'GD','GRD','Grenada','Grenada','Grenade',0,0,0,0),
(268,'GE','GEO','Georgien','Georgia','Géorgie',0,0,0,0),
(254,'GF','GUF','Französisch-Guayana','French Guiana','Guyane Française',0,0,0,0),
(288,'GH','GHA','Ghana','Ghana','Ghana',0,0,0,0),
(292,'GI','GIB','Gibraltar','Gibraltar','Gibraltar',0,0,0,0),
(304,'GL','GRL','Grönland','Greenland','Groenland',0,0,0,0),
(270,'GM','GMB','Gambia','Gambia','Gambie',0,0,0,0),
(324,'GN','GIN','Guinea','Guinea','Guinée',0,0,0,0),
(312,'GP','GLP','Guadeloupe','Guadeloupe','Guadeloupe',0,0,0,0),
(226,'GQ','GNQ','Äquatorialguinea','Equatorial Guinea','Guinée Équatoriale',0,0,0,0),
(300,'GR','GRC','Griechenland','Greece','Grèce',0,0,0,0),
(239,'GS','SGS','Südgeorgien und die Südlichen Sandwichinseln','South Georgia and the South Sandwich Islands','Géorgie du Sud et les Îles Sandwich du Sud',0,0,0,0),
(320,'GT','GTM','Guatemala','Guatemala','Guatemala',0,0,0,0),
(316,'GU','GUM','Guam','Guam','Guam',0,0,0,0),
(624,'GW','GNB','Guinea-Bissau','Guinea-Bissau','Guinée-Bissau',0,0,0,0),
(328,'GY','GUY','Guyana','Guyana','Guyana',0,0,0,0),
(344,'HK','HKG','Hongkong','Hong Kong','Hong-Kong',0,0,0,0),
(334,'HM','HMD','Heard und McDonaldinseln','Heard Island and McDonald Islands','Îles Heard et Mcdonald',0,0,0,0),
(340,'HN','HND','Honduras','Honduras','Honduras',0,0,0,0),
(191,'HR','HRV','Kroatien','Croatia','Croatie',0,0,0,0),
(332,'HT','HTI','Haiti','Haiti','Haïti',0,0,0,0),
(348,'HU','HUN','Ungarn','Hungary','Hongrie',0,0,0,0),
(0,'IB','IBU','NULL','International Bureau','Bureau International',0,0,0,0),
(360,'ID','IDN','Indonesien','Indonesia','Indonésie',0,0,0,0),
(372,'IE','IRL','Irland','Ireland','Irlande',0,0,0,0),
(376,'IL','ISR','Israel','Israel','Israël',0,0,0,0),
(833,'IM','IMN','Insel Man','Isle of Man','Île de Man',0,0,0,0),
(356,'IN','IND','Indien','India','Inde',0,1,0,0),
(86,'IO','IOT','Britisches Territorium im Indischen Ozean','British Indian Ocean Territory','Territoire Britannique de l\'Océan Indien',0,0,0,0),
(368,'IQ','IRQ','Irak','Iraq','Iraq',0,0,0,0),
(364,'IR','IRN','Islamische Republik Iran','Islamic Republic of Iran','République Islamique d\'Iran',0,0,0,0),
(352,'IS','ISL','Island','Iceland','Islande',0,0,0,0),
(380,'IT','ITA','Italien','Italy','Italie',1,0,0,0),
(388,'JM','JAM','Jamaika','Jamaica','Jamaïque',0,0,0,0),
(400,'JO','JOR','Jordanien','Jordan','Jordanie',0,0,0,0),
(392,'JP','JPN','Japan','Japan','Japon',0,1,0,0),
(404,'KE','KEN','Kenia','Kenya','Kenya',0,0,0,0),
(417,'KG','KGZ','Kirgisistan','Kyrgyzstan','Kirghizistan',0,0,0,0),
(116,'KH','KHM','Kambodscha','Cambodia','Cambodge',0,0,0,0),
(296,'KI','KIR','Kiribati','Kiribati','Kiribati',0,0,0,0),
(174,'KM','COM','Komoren','Comoros','Comores',0,0,0,0),
(659,'KN','KNA','St. Kitts und Nevis','Saint Kitts and Nevis','Saint-Kitts-et-Nevis',0,0,0,0),
(408,'KP','PRK','Demokratische Volksrepublik Korea','Democratic People\'s Republic of Korea','République Populaire Démocratique de Corée',0,0,0,0),
(410,'KR','KOR','Republik Korea','Republic of Korea','République de Corée',0,1,0,0),
(414,'KW','KWT','Kuwait','Kuwait','Koweït',0,0,0,0),
(136,'KY','CYM','Kaimaninseln','Cayman Islands','Îles Caïmanes',0,0,0,0),
(398,'KZ','KAZ','Kasachstan','Kazakhstan','Kazakhstan',0,0,0,0),
(418,'LA','LAO','Demokratische Volksrepublik Laos','Lao People\'s Democratic Republic','République Démocratique Populaire Lao',0,0,0,0),
(422,'LB','LBN','Libanon','Lebanon','Liban',0,0,0,0),
(662,'LC','LCA','St. Lucia','Saint Lucia','Sainte-Lucie',0,0,0,0),
(438,'LI','LIE','Liechtenstein','Liechtenstein','Liechtenstein',0,0,0,0),
(144,'LK','LKA','Sri Lanka','Sri Lanka','Sri Lanka',0,0,0,0),
(430,'LR','LBR','Liberia','Liberia','Libéria',0,0,0,0),
(426,'LS','LSO','Lesotho','Lesotho','Lesotho',0,0,0,0),
(440,'LT','LTU','Litauen','Lithuania','Lituanie',0,0,0,0),
(442,'LU','LUX','Luxemburg','Luxembourg','Luxembourg',0,0,0,0),
(428,'LV','LVA','Lettland','Latvia','Lettonie',0,0,0,0),
(434,'LY','LBY','Libysch-Arabische Dschamahirija','Libyan Arab Jamahiriya','Jamahiriya Arabe Libyenne',0,0,0,0),
(504,'MA','MAR','Marokko','Morocco','Maroc',0,0,0,0),
(492,'MC','MCO','Monaco','Monaco','Monaco',0,0,0,0),
(498,'MD','MDA','Moldawien','Republic of Moldova','République de Moldova',0,0,0,0),
(450,'MG','MDG','Madagaskar','Madagascar','Madagascar',0,0,0,0),
(584,'MH','MHL','Marshallinseln','Marshall Islands','Îles Marshall',0,0,0,0),
(807,'MK','MKD','Ehem. jugoslawische Republik Mazedonien','The Former Yugoslav Republic of Macedonia','L\'ex-République Yougoslave de Macédoine',0,0,0,0),
(466,'ML','MLI','Mali','Mali','Mali',0,0,0,0),
(104,'MM','MMR','Myanmar','Myanmar','Myanmar',0,0,0,0),
(496,'MN','MNG','Mongolei','Mongolia','Mongolie',0,0,0,0),
(446,'MO','MAC','Macao','Macao','Macao',0,0,0,0),
(580,'MP','MNP','Nördliche Marianen','Northern Mariana Islands','Îles Mariannes du Nord',0,0,0,0),
(474,'MQ','MTQ','Martinique','Martinique','Martinique',0,0,0,0),
(478,'MR','MRT','Mauretanien','Mauritania','Mauritanie',0,0,0,0),
(500,'MS','MSR','Montserrat','Montserrat','Montserrat',0,0,0,0),
(470,'MT','MLT','Malta','Malta','Malte',0,0,0,0),
(480,'MU','MUS','Mauritius','Mauritius','Maurice',0,0,0,0),
(462,'MV','MDV','Malediven','Maldives','Maldives',0,0,0,0),
(454,'MW','MWI','Malawi','Malawi','Malawi',0,0,0,0),
(484,'MX','MEX','Mexiko','Mexico','Mexique',0,0,0,0),
(458,'MY','MYS','Malaysia','Malaysia','Malaisie',0,0,0,0),
(508,'MZ','MOZ','Mosambik','Mozambique','Mozambique',0,0,0,0),
(516,'NA','NAM','Namibia','Namibia','Namibie',0,0,0,0),
(540,'NC','NCL','Neukaledonien','New Caledonia','Nouvelle-Calédonie',0,0,0,0),
(562,'NE','NER','Niger','Niger','Niger',0,0,0,0),
(574,'NF','NFK','Norfolkinsel','Norfolk Island','Île Norfolk',0,0,0,0),
(566,'NG','NGA','Nigeria','Nigeria','Nigéria',0,0,0,0),
(558,'NI','NIC','Nicaragua','Nicaragua','Nicaragua',0,0,0,0),
(528,'NL','NLD','Niederlande','Netherlands','Pays-Bas',0,0,0,0),
(578,'NO','NOR','Norwegen','Norway','Norvège',0,0,0,0),
(524,'NP','NPL','Nepal','Nepal','Népal',0,0,0,0),
(520,'NR','NRU','Nauru','Nauru','Nauru',0,0,0,0),
(570,'NU','NIU','Niue','Niue','Niué',0,0,0,0),
(554,'NZ','NZL','Neuseeland','New Zealand','Nouvelle-Zélande',0,0,0,0),
(0,'OA','AIP','Afrikanische Organisation für geistiges Eigentum','African Intellectual Property Organization','Organisation Africaine de la Propriété Intellectuelle',0,0,0,0),
(512,'OM','OMN','Oman','Oman','Oman',0,0,0,0),
(591,'PA','PAN','Panama','Panama','Panama',0,0,0,0),
(604,'PE','PER','Peru','Peru','Pérou',0,0,0,0),
(258,'PF','PYF','Französisch-Polynesien','French Polynesia','Polynésie Française',0,0,0,0),
(598,'PG','PNG','Papua-Neuguinea','Papua New Guinea','Papouasie-Nouvelle-Guinée',0,0,0,0),
(608,'PH','PHL','Philippinen','Philippines','Philippines',0,0,0,0),
(586,'PK','PAK','Pakistan','Pakistan','Pakistan',0,0,0,0),
(616,'PL','POL','Polen','Poland','Pologne',0,0,0,0),
(666,'PM','SPM','St. Pierre und Miquelon','Saint-Pierre and Miquelon','Saint-Pierre-et-Miquelon',0,0,0,0),
(612,'PN','PCN','Pitcairninseln','Pitcairn','Pitcairn',0,0,0,0),
(630,'PR','PRI','Puerto Rico','Puerto Rico','Porto Rico',0,0,0,0),
(275,'PS','PSE','Palästinensische Autonomiegebiete','Occupied Palestinian Territory','Territoire Palestinien Occupé',0,0,0,0),
(620,'PT','PRT','Portugal','Portugal','Portugal',0,0,0,0),
(585,'PW','PLW','Palau','Palau','Palaos',0,0,0,0),
(600,'PY','PRY','Paraguay','Paraguay','Paraguay',0,0,0,0),
(634,'QA','QAT','Katar','Qatar','Qatar',0,0,0,0),
(638,'RE','REU','Réunion','Réunion','Réunion',0,0,0,0),
(642,'RO','ROU','Rumänien','Romania','Roumanie',0,0,0,0),
(643,'RU','RUS','Russische Föderation','Russian Federation','Fédération de Russie',0,0,0,0),
(646,'RW','RWA','Ruanda','Rwanda','Rwanda',0,0,0,0),
(682,'SA','SAU','Saudi-Arabien','Saudi Arabia','Arabie Saoudite',0,0,0,0),
(90,'SB','SLB','Salomonen','Solomon Islands','Îles Salomon',0,0,0,0),
(690,'SC','SYC','Seychellen','Seychelles','Seychelles',0,0,0,0),
(736,'SD','SDN','Sudan','Sudan','Soudan',0,0,0,0),
(752,'SE','SWE','Schweden','Sweden','Suède',0,0,0,0),
(702,'SG','SGP','Singapur','Singapore','Singapour',0,0,0,0),
(654,'SH','SHN','St. Helena','Saint Helena','Sainte-Hélène',0,0,0,0),
(705,'SI','SVN','Slowenien','Slovenia','Slovénie',0,0,0,0),
(744,'SJ','SJM','Svalbard and Jan Mayen','Svalbard and Jan Mayen','Svalbard et Île Jan Mayen',0,0,0,0),
(703,'SK','SVK','Slowakei','Slovakia','Slovaquie',0,0,0,0),
(694,'SL','SLE','Sierra Leone','Sierra Leone','Sierra Leone',0,0,0,0),
(674,'SM','SMR','San Marino','San Marino','Saint-Marin',0,0,0,0),
(686,'SN','SEN','Senegal','Senegal','Sénégal',0,0,0,0),
(706,'SO','SOM','Somalia','Somalia','Somalie',0,0,0,0),
(740,'SR','SUR','Suriname','Suriname','Suriname',0,0,0,0),
(678,'ST','STP','São Tomé und Príncipe','Sao Tome and Principe','Sao Tomé-et-Principe',0,0,0,0),
(222,'SV','SLV','El Salvador','El Salvador','El Salvador',0,0,0,0),
(760,'SY','SYR','Arabische Republik Syrien','Syrian Arab Republic','République Arabe Syrienne',0,0,0,0),
(748,'SZ','SWZ','Swasiland','Swaziland','Swaziland',0,0,0,0),
(796,'TC','TCA','Turks- und Caicosinseln','Turks and Caicos Islands','Îles Turks et Caïques',0,0,0,0),
(148,'TD','TCD','Tschad','Chad','Tchad',0,0,0,0),
(260,'TF','ATF','Französische Süd- und Antarktisgebiete','French Southern Territories','Terres Australes Françaises',0,0,0,0),
(768,'TG','TGO','Togo','Togo','Togo',0,0,0,0),
(764,'TH','THA','Thailand','Thailand','Thaïlande',0,0,0,0),
(762,'TJ','TJK','Tadschikistan','Tajikistan','Tadjikistan',0,0,0,0),
(772,'TK','TKL','Tokelau','Tokelau','Tokelau',0,0,0,0),
(626,'TL','TLS','Timor-Leste','Timor-Leste','Timor-Leste',0,0,0,0),
(795,'TM','TKM','Turkmenistan','Turkmenistan','Turkménistan',0,0,0,0),
(788,'TN','TUN','Tunesien','Tunisia','Tunisie',0,0,0,0),
(776,'TO','TON','Tonga','Tonga','Tonga',0,0,0,0),
(792,'TR','TUR','Türkei','Turkey','Turquie',0,0,0,0),
(780,'TT','TTO','Trinidad und Tobago','Trinidad and Tobago','Trinité-et-Tobago',0,0,0,0),
(798,'TV','TUV','Tuvalu','Tuvalu','Tuvalu',0,0,0,0),
(158,'TW','TWN','Taiwan','Taiwan','Taïwan',0,0,0,0),
(834,'TZ','TZA','Vereinigte Republik Tansania','United Republic Of Tanzania','République-Unie de Tanzanie',0,0,0,0),
(804,'UA','UKR','Ukraine','Ukraine','Ukraine',0,0,0,0),
(800,'UG','UGA','Uganda','Uganda','Ouganda',0,0,0,0),
(581,'UM','UMI','Amerikanisch-Ozeanien','United States Minor Outlying Islands','Îles Mineures Éloignées des États-Unis',0,0,0,0),
(840,'US','USA','Vereinigte Staaten von Amerika','United States','États-Unis',0,1,0,0),
(858,'UY','URY','Uruguay','Uruguay','Uruguay',0,0,0,0),
(860,'UZ','UZB','Usbekistan','Uzbekistan','Ouzbékistan',0,0,0,0),
(336,'VA','VAT','Vatikanstadt','Vatican City State','Saint-Siège (état de la Cité du Vatican)',0,0,0,0),
(670,'VC','VCT','St. Vincent und die Grenadinen','Saint Vincent and the Grenadines','Saint-Vincent-et-les Grenadines',0,0,0,0),
(862,'VE','VEN','Venezuela','Venezuela','Venezuela',0,0,0,0),
(92,'VG','VGB','Britische Jungferninseln','British Virgin Islands','Îles Vierges Britanniques',0,0,0,0),
(850,'VI','VIR','Amerikanische Jungferninseln','U.S. Virgin Islands','Îles Vierges des États-Unis',0,0,0,0),
(704,'VN','VNM','Vietnam','Vietnam','Viet Nam',0,0,0,0),
(548,'VU','VUT','Vanuatu','Vanuatu','Vanuatu',0,0,0,0),
(876,'WF','WLF','Wallis und Futuna','Wallis and Futuna','Wallis et Futuna',0,0,0,0),
(0,'WO','PCT','Weltorganisation für geistiges Eigentum','World Intellectual Property Organization','Organisation Mondiale de la Propriété Intellectuelle',0,0,0,0),
(882,'WS','WSM','Samoa','Samoa','Samoa',0,0,0,0),
(887,'YE','YEM','Jemen','Yemen','Yémen',0,0,0,0),
(175,'YT','MYT','Mayotte','Mayotte','Mayotte',0,0,0,0),
(710,'ZA','ZAF','Südafrika','South Africa','Afrique du Sud',0,0,0,0),
(894,'ZM','ZMB','Sambia','Zambia','Zambie',0,0,0,0),
(716,'ZW','ZWE','Simbabwe','Zimbabwe','Zimbabwe',0,0,0,0);
/*!40000 ALTER TABLE `country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `event_name`
--

LOCK TABLES `event_name` WRITE;
/*!40000 ALTER TABLE `event_name` DISABLE KEYS */;
INSERT INTO `event_name` VALUES ('ABA','Abandoned',NULL,NULL,0,1,NULL,0,1,0,1,NULL,NULL,NULL,NULL),
('ABO','Abandon Original','PAT','EP',1,0,NULL,0,1,0,0,'Abandon the originating patent that was re-designated in EP',NULL,'2011-04-23 20:43:27',NULL),
('ADV','Advisory Action','PAT','US',0,0,NULL,0,0,0,0,NULL,NULL,NULL,NULL),
('ALL','Allowance','PAT',NULL,0,1,NULL,0,0,0,0,'Use also for R71.3 in EP',NULL,'2011-03-20 16:15:45',NULL),
('APL','Appeal',NULL,NULL,0,1,NULL,1,0,0,0,'Appeal or other remedy filed',NULL,'2017-05-24 08:32:29',NULL),
('CAN','Cancelled','TM',NULL,0,1,NULL,0,0,0,1,NULL,NULL,'2014-10-09 08:54:39',NULL),
('CLO','Closed','LTG',NULL,0,1,NULL,0,0,0,1,NULL,NULL,'2015-11-25 13:07:23',NULL),
('COM','Communication',NULL,NULL,0,0,NULL,0,0,0,0,'Communication regarding administrative or formal matters (missing parts, irregularities...)',NULL,'2011-04-26 14:47:36',NULL),
('CRE','Created',NULL,NULL,0,0,NULL,0,1,0,0,'Creation date of matter - for attaching tasks necessary before anything else',NULL,'2011-10-09 19:41:17',NULL),
('DAPL','Decision on Appeal',NULL,NULL,0,0,NULL,0,0,0,0,'State outcome in detail field',NULL,'2017-02-28 15:17:46',NULL),
('DBY','Draft By','PAT',NULL,1,0,NULL,1,0,0,0,NULL,NULL,'2011-09-22 08:55:07',NULL),
('DEX','Deadline Extended',NULL,NULL,0,0,NULL,0,0,0,0,'Deadline extension requested',NULL,'2011-04-26 14:48:02',NULL),
('DPAPL','Decision on Pre-Appeal','PAT','US',0,0,NULL,0,0,0,0,NULL,NULL,'2017-02-28 15:13:43',NULL),
('DRA','Drafted','PAT',NULL,0,1,NULL,0,0,0,0,NULL,NULL,NULL,NULL),
('DW','Deemed withrawn',NULL,NULL,0,1,NULL,0,0,0,0,'Decision needing a reply, such as further processing',NULL,'2014-05-05 13:53:33',NULL),
('EHK','Extend to Hong Kong','PAT','CN',1,0,NULL,0,1,0,0,NULL,NULL,'2011-03-22 07:52:06',NULL),
('ENT','Entered','PAT',NULL,0,0,NULL,0,1,0,0,'National entry date from PCT phase',NULL,'2011-10-12 10:19:29',NULL),
('EOP','End of Procedure','PAT',NULL,0,1,NULL,0,1,0,1,'Indicates end of international phase for PCT',NULL,'2014-07-07 14:01:03',NULL),
('EXA','Examiner Action',NULL,NULL,0,0,NULL,0,0,0,0,'AKA Office Action, i.e. anything related to substantive examination',NULL,'2011-03-20 17:03:46',NULL),
('EXAF','Examiner Action (Final)','PAT','US',0,0,NULL,0,0,0,0,NULL,NULL,'2013-10-10 16:09:24',NULL),
('EXP','Expiry',NULL,NULL,0,1,NULL,0,1,0,1,'Do not use nor change - present for internal functionality',NULL,'2017-01-17 13:43:06',NULL),
('FAP','File Notice of Appeal',NULL,NULL,1,0,NULL,1,0,0,0,NULL,NULL,'2016-01-30 11:46:54',NULL),
('FBY','File by',NULL,NULL,1,0,NULL,0,1,0,0,NULL,NULL,'2012-01-18 06:50:04',NULL),
('FDIV','File Divisional','PAT',NULL,1,0,NULL,0,1,0,0,NULL,NULL,'2011-04-23 20:44:30',NULL),
('FIL','Filed',NULL,NULL,0,1,NULL,0,1,0,0,NULL,NULL,'2011-04-26 14:20:23',NULL),
('FOP','File Opposition','OP','EP',1,0,NULL,1,1,0,0,NULL,NULL,'2011-09-22 08:56:06',NULL),
('FPR','Further Processing','PAT',NULL,1,0,NULL,1,0,0,0,NULL,NULL,'2011-10-09 22:29:42',NULL),
('FRCE','File RCE','PAT','US',1,0,NULL,0,0,0,0,NULL,NULL,'2013-09-24 16:09:36',NULL),
('GRT','Granted','PAT',NULL,0,1,NULL,0,1,0,0,NULL,NULL,NULL,NULL),
('INV','Invalidated','TM','US',0,1,NULL,0,0,0,1,NULL,NULL,'2014-11-14 14:05:44',NULL),
('LAP','Lapsed',NULL,NULL,0,1,NULL,0,1,0,1,NULL,NULL,'2011-03-16 10:42:48',NULL),
('NPH','National Phase','PAT','WO',1,0,NULL,0,1,1,0,NULL,NULL,'2012-09-18 13:14:14',NULL),
('OPP','Opposition',NULL,'EP',0,1,NULL,0,0,0,0,NULL,NULL,'2011-03-23 07:32:55',NULL),
('OPR','Oral Proceedings','PAT','EP',1,0,NULL,1,0,0,0,NULL,NULL,'2014-05-07 07:10:37',NULL),
('ORE','Opposition rejected','PAT','EP',0,1,NULL,0,0,0,0,NULL,NULL,'2015-01-09 09:02:05',NULL),
('PAY','Pay',NULL,NULL,1,0,NULL,0,0,0,0,'Use for any fees to be paid',NULL,'2011-04-07 06:18:59',NULL),
('PDES','Post designation','TM','WO',0,1,NULL,0,0,0,0,NULL,NULL,'2014-07-01 12:48:03',NULL),
('PFIL','Parent Filed','PAT',NULL,0,1,NULL,0,1,0,0,'Filing date of the parent (use only when the matter type is defined). Use as link to the parent matter.',NULL,'2011-06-07 08:53:24',NULL),
('PR','Publication of Reg.','TM',NULL,0,1,NULL,0,0,0,0,NULL,NULL,'2012-06-20 14:03:41',NULL),
('PREP','Prepare',NULL,NULL,1,0,NULL,1,0,0,0,'Any further action to be done by the responsible (comments, pre-handling, ...)',NULL,'2017-05-22 10:04:24',NULL),
('PRI','Priority Claim',NULL,NULL,0,1,NULL,0,0,0,0,'Use as link to the priority matter',NULL,'2011-06-07 08:54:06',NULL),
('PRID','Priority Deadline',NULL,NULL,1,0,NULL,0,1,0,0,NULL,NULL,'2011-11-23 18:38:13',NULL),
('PROD','Produce',NULL,NULL,1,0,NULL,0,0,0,0,'Any further documents to be filed (inventor designation, priority document, missing parts...)',NULL,'2017-04-25 13:07:37',NULL),
('PSR','Publication of SR','PAT','EP',0,0,NULL,0,1,0,0,'A3 publication',NULL,'2012-04-24 13:17:31',NULL),
('PUB','Published',NULL,NULL,0,1,NULL,0,0,0,0,'For EP, this means publication WITH the search report (A1 publ.)',NULL,'2011-03-20 16:09:08',NULL),
('RCE','Request Continued Examination','PAT','US',0,1,NULL,0,0,0,0,NULL,NULL,NULL,NULL),
('REC','Received',NULL,NULL,0,1,NULL,0,1,0,0,'Date the case was received from the client',NULL,'2013-06-20 15:36:35',NULL),
('REF','Refused',NULL,NULL,0,1,NULL,0,0,0,0,'This is the final decision, that can only be appealed - do not mistake with an exam report',NULL,'2013-09-19 10:27:58',NULL),
('REG','Registration','TM',NULL,0,1,NULL,0,0,0,0,NULL,NULL,'2012-06-19 09:54:42',NULL),
('REM','Reminder',NULL,NULL,1,0,NULL,0,0,0,0,NULL,NULL,'2011-05-09 17:11:17',NULL),
('REN','Renewal',NULL,NULL,1,0,NULL,0,0,1,0,'AKA Annuity',NULL,'2013-05-16 13:24:28',NULL),
('REP','Respond',NULL,NULL,1,0,NULL,1,0,0,0,'Use for any response',NULL,'2011-09-22 11:40:57',NULL),
('REQ','Request Examination',NULL,NULL,1,0,NULL,0,1,0,0,NULL,NULL,NULL,NULL),
('RSTR','Restriction Req.','PAT','US',0,0,NULL,0,0,0,0,NULL,NULL,'2011-11-03 15:53:39',NULL),
('SOL','Sold',NULL,NULL,0,1,NULL,0,0,0,1,NULL,NULL,'2014-01-24 14:38:50',NULL),
('SOP','Summons to Oral Proc.',NULL,NULL,0,0,NULL,0,0,0,0,NULL,NULL,'2017-05-24 09:54:03',NULL),
('SR','Search Report',NULL,NULL,0,0,NULL,0,0,0,0,NULL,NULL,NULL,NULL),
('SUS','Suspended',NULL,NULL,0,1,NULL,0,0,0,0,NULL,NULL,'2017-05-22 10:05:12',NULL),
('TRF','Transferred',NULL,NULL,0,1,NULL,0,1,0,1,'Case no longer followed',NULL,'2011-03-20 17:09:21',NULL),
('VAL','Validate','PAT','EP',1,0,NULL,0,1,0,0,'Validate granted EP in designated countries',NULL,'2011-03-22 10:22:17',NULL),
('WAT','Watch',NULL,NULL,1,0,NULL,1,0,0,0,NULL,NULL,'2012-08-09 10:18:53',NULL),
('WIT','Withdrawal','PAT',NULL,0,1,NULL,0,0,0,1,NULL,NULL,'2012-08-09 10:24:10',NULL);
/*!40000 ALTER TABLE `event_name` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `matter_category`
--

LOCK TABLES `matter_category` WRITE;
/*!40000 ALTER TABLE `matter_category` DISABLE KEYS */;
INSERT INTO `matter_category` VALUES ('AGR','AGR','Agreement','OTH',NULL,'2011-09-27 15:52:36',NULL),
('DSG','DSG','Design','TM',NULL,'2012-06-18 13:11:56',NULL),
('FTO','OPI','Freedom to Operate','LTG',NULL,'2014-10-14 08:06:33',NULL),
('LTG','LTG','Litigation','LTG',NULL,'2011-10-13 16:18:28',NULL),
('OP','OPP','Opposition (patent)','LTG',NULL,'2016-11-15 13:10:12',NULL),
('OPI','OPI','Opinion','LTG',NULL,'2014-10-14 08:22:29',NULL),
('OTH','OTH','Others','OTH',NULL,'2011-10-13 16:18:36',NULL),
('PAT','PAT','Patent','PAT',NULL,'2016-10-05 11:33:25',NULL),
('PRO','PAT','Provisional Application','PAT',NULL,'2011-10-13 16:19:03',NULL),
('SO','PAT','Soleau Envelop','PAT',NULL,'2011-09-27 15:26:20',NULL),
('SR','SR-','Search','LTG',NULL,'2011-10-20 16:28:52',NULL),
('TM','TM-','Trade Mark','TM',NULL,'2012-06-18 13:11:44',NULL),
('TMOP','TOP','Opposition (TM)','TM',NULL,'2012-06-18 13:12:55',NULL),
('TS','TS-','Trade Secret','PAT',NULL,'2012-01-22 17:34:19',NULL),
('UC','PAT','Utility Certificate','PAT',NULL,'2011-10-13 16:18:58',NULL),
('UM','PAT','Utility Model','PAT',NULL,'2011-11-23 14:47:55',NULL),
('WAT','WAT','Watch','TM',NULL,'2012-06-21 21:10:44',NULL);
/*!40000 ALTER TABLE `matter_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `matter_type`
--

LOCK TABLES `matter_type` WRITE;
/*!40000 ALTER TABLE `matter_type` DISABLE KEYS */;
INSERT INTO `matter_type` VALUES ('CIP','Continuation in Part',NULL,'0000-00-00 00:00:00',NULL),
('CNT','Continuation',NULL,'0000-00-00 00:00:00',NULL),
('DIV','Divisional',NULL,'0000-00-00 00:00:00',NULL),
('REI','Reissue',NULL,'0000-00-00 00:00:00',NULL),
('REX','Re-examination',NULL,'2016-01-30 11:40:39',NULL);
/*!40000 ALTER TABLE `matter_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `task_rules`
--

LOCK TABLES `task_rules` WRITE;
/*!40000 ALTER TABLE `task_rules` DISABLE KEYS */;
INSERT INTO `task_rules` VALUES (1,1,'PRID','FIL',0,0,'PAT',NULL,NULL,NULL,NULL,0,12,0,0,0,'PRI',NULL,1,1,NULL,NULL,NULL,NULL,NULL,NULL,'Priority deadline is inserted only if no priority event exists',NULL,'2017-05-24 13:26:40',NULL),
(2,1,'PRID','FIL',0,0,'TM',NULL,NULL,NULL,NULL,0,6,0,0,0,'PRI',NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,'Priority deadline is inserted only if no priority event exists',NULL,'2011-11-04 08:03:27',NULL),
(3,1,'FBY','FIL',1,0,'PAT',NULL,NULL,NULL,NULL,0,0,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,'Clear \"File by\" task when \"Filed\" event is created',NULL,'2011-11-04 07:23:08',NULL),
(4,1,'PRID','FIL',0,0,'PRO',NULL,NULL,NULL,NULL,0,12,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2011-09-02 14:13:42',NULL),
(5,1,'DBY','DRA',1,0,'PAT',NULL,NULL,NULL,NULL,0,0,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,'Clear \"Draft by\" task when \"Drafted\" event is created',NULL,'2011-11-04 07:23:01',NULL),
(6,1,'REQ','FIL',0,0,'PAT','JP',NULL,NULL,NULL,0,0,3,0,0,'EXA',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2011-09-02 14:13:42',NULL),
(7,1,'REQ','PUB',0,0,'PAT','EP',NULL,NULL,NULL,0,6,0,0,0,'EXA',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2011-09-02 14:13:42',NULL),
(8,1,'EXP','FIL',0,0,'PRO',NULL,NULL,NULL,NULL,0,12,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2011-09-02 14:13:42',NULL),
(9,1,'REP','SR',0,0,'PAT','FR',NULL,NULL,'Search Report',0,3,0,0,0,'GRT',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2011-03-22 21:00:57',NULL),
(10,1,'REP','EXA',0,0,'PAT','US',NULL,NULL,'Exam Report',0,3,0,0,0,'GRT',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2012-10-05 13:26:12',NULL),
(11,1,'REP','EXA',0,0,'PAT','EP',NULL,NULL,'Exam Report',0,4,0,0,0,'GRT',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2011-03-20 11:17:37',NULL),
(12,1,'EXP','FIL',0,0,'PAT',NULL,NULL,NULL,NULL,0,0,20,0,0,NULL,NULL,1,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2017-05-05 09:41:35',NULL),
(13,1,'REP','ALL',0,0,'PAT','EP',NULL,NULL,'R71(3)',0,4,0,0,0,'GRT',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2011-12-05 13:07:47',NULL),
(14,1,'PAY','ALL',0,0,'PAT','EP',NULL,NULL,'Grant Fee',0,4,0,0,0,'GRT',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2017-02-28 16:15:55',NULL),
(15,1,'PROD','ALL',0,0,'PAT','EP',NULL,NULL,'Claim Translation',0,4,0,0,0,'GRT',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2011-03-20 11:18:32',NULL),
(16,1,'VAL','GRT',0,0,'PAT','EP',NULL,NULL,'Translate where necessary',0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2011-12-05 15:58:17',NULL),
(18,1,'REP','PUB',0,0,'PAT','EP',NULL,NULL,'Written Opinion',0,6,0,0,0,'EXA',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2011-03-20 15:34:56',NULL),
(19,1,'PAY','PUB',0,0,'PAT','EP',NULL,NULL,'Designation Fees',0,6,0,0,0,'EXA',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2011-03-20 15:34:58',NULL),
(20,1,'PROD','PRI',0,0,'PAT','US',NULL,NULL,'Decl. and Assignment',0,12,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2011-12-05 13:08:15',NULL),
(21,1,'FBY','PRI',0,0,'PAT',NULL,NULL,NULL,'Priority Deadline',0,12,0,0,0,'FIL',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2011-11-10 10:22:11',NULL),
(22,1,'NPH','FIL',0,0,'PAT','WO',NULL,NULL,NULL,0,30,0,0,0,NULL,NULL,0,1,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2011-09-02 14:13:42',NULL),
(23,1,'REQ','FIL',0,0,'PAT','WO',NULL,NULL,NULL,0,22,0,0,0,'EXA',NULL,0,1,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2015-12-17 10:54:10',NULL),
(24,1,'DBY','REC',0,0,'PAT',NULL,NULL,NULL,NULL,0,2,0,0,0,'PRI',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2011-10-21 07:33:15',NULL),
(25,1,'PRID','PRI',0,1,'PAT',NULL,NULL,NULL,NULL,0,0,0,0,0,NULL,'FIL',0,0,NULL,NULL,NULL,NULL,'EUR',NULL,'Deletes priority deadline when a priority event is inserted',NULL,'2011-11-04 08:03:27',NULL),
(26,1,'EHK','PUB',0,0,'PAT','CN',NULL,NULL,NULL,0,6,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2011-09-02 14:13:42',NULL),
(27,1,'FOP','GRT',0,0,'OP','EP',NULL,NULL,NULL,0,9,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2016-11-15 13:24:01',NULL),
(29,1,'DBY','FIL',1,0,'PAT',NULL,NULL,NULL,NULL,0,0,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2011-09-02 14:13:42',NULL),
(30,1,'PROD','FIL',0,0,'PAT','US',NULL,NULL,'IDS',0,2,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2011-03-22 20:09:57',NULL),
(32,1,'REP','EXA',0,0,'PAT','WO',NULL,NULL,NULL,0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2011-09-02 14:13:42',NULL),
(33,1,'EXP','FIL',0,0,'PAT','WO',NULL,NULL,NULL,0,31,0,0,0,NULL,NULL,0,1,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2011-09-02 14:13:42',NULL),
(34,1,'REM','FIL',0,0,'PAT','WO',NULL,NULL,'National Phase',0,27,0,0,0,NULL,NULL,0,1,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2011-05-09 17:11:57',NULL),
(35,1,'PROD','FIL',0,0,'PAT','FR',NULL,NULL,'Small Entity',0,1,0,0,0,'PRI',NULL,1,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2011-10-05 19:56:19',NULL),
(36,1,'PAY','GRT',0,0,'PAT','CN',NULL,NULL,'HK Grant Fee',0,6,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2011-03-22 22:59:22',NULL),
(37,1,'REP','COM',0,0,'PAT',NULL,NULL,NULL,'Communication',0,2,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-06-19 10:06:23',NULL),
(38,1,'FOP','OPP',1,0,'OP','EP',NULL,NULL,NULL,0,0,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,'Clear \"File Opposition\" task when \"Opposition\" event is created',NULL,'2016-11-15 13:24:01',NULL),
(39,1,'PAY','ALL',0,0,'PAT','JP',NULL,NULL,'Grant Fee',0,1,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2017-02-28 16:16:00',NULL),
(40,1,'FPR','DW',0,0,'PAT','EP',NULL,NULL,NULL,0,2,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2011-10-09 22:41:20',NULL),
(41,1,'REP','PSR',0,0,'PAT','EP',NULL,NULL,'R70(2)',0,6,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-01-11 14:54:08',NULL),
(42,1,'NPH','PRI',0,0,'PAT',NULL,'WO',NULL,NULL,0,30,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2011-10-14 07:20:28',NULL),
(43,1,'PAY','FIL',0,0,'PAT','FR',NULL,NULL,'Filing Fee',0,1,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2017-02-28 16:16:15',NULL),
(44,1,'PAY','FIL',0,0,'PAT','EP',NULL,NULL,'Filing Fee',0,1,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2017-02-28 16:16:22',NULL),
(45,1,'VAL','GRT',0,0,'PAT',NULL,'EP',NULL,NULL,0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2011-10-17 13:42:58',NULL),
(46,1,'REP','RSTR',0,0,'PAT','US',NULL,NULL,'Restriction Req.',0,1,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2011-11-03 15:58:40',NULL),
(47,1,'REP','COM',0,0,'PAT','EP',NULL,NULL,'R161',0,6,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2011-10-19 08:23:13',NULL),
(48,1,'FAP','REF',0,0,'PAT',NULL,NULL,NULL,NULL,0,2,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2017-05-24 08:35:27',NULL),
(49,1,'PROD','APL',0,0,'PAT',NULL,NULL,NULL,'Appeal Brief',0,2,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2017-02-28 16:13:16',NULL),
(52,1,'REP','COM',0,0,'OP','EP',NULL,NULL,'Observations',0,4,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2016-11-15 13:24:01',NULL),
(53,1,'REQ','FIL',0,0,'PAT','KR',NULL,NULL,NULL,0,0,3,0,0,'EXA',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2017-02-28 13:07:32',NULL),
(54,1,'REQ','FIL',0,0,'PAT','CA',NULL,NULL,NULL,0,0,5,0,0,'EXA',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2015-12-17 10:54:11',NULL),
(55,1,'REQ','FIL',0,0,'PAT','CN',NULL,NULL,NULL,0,0,3,0,0,'EXA',NULL,0,1,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2015-12-17 10:54:11',NULL),
(56,1,'PAY','ALL',0,0,'PAT','CA',NULL,NULL,'Grant Fee',0,6,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2017-02-28 16:14:43',NULL),
(57,1,'PROD','PRI',0,0,'PAT',NULL,NULL,NULL,'Priority Docs',0,16,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2011-12-13 13:38:12',NULL),
(58,1,'PAY','FIL',0,0,'PAT','WO',NULL,NULL,'Filing Fee',0,1,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2017-02-28 16:16:26',NULL),
(60,1,'REM','ALL',0,0,'PAT','US',NULL,NULL,'File divisional',0,1,0,0,0,NULL,'RSTR',0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2012-01-19 09:50:59',NULL),
(61,1,'REP','EXA',0,0,'PAT','CN',NULL,NULL,'Exam Report',0,4,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2016-04-18 15:17:15',NULL),
(62,1,'REP','EXA',0,0,'PAT','CA',NULL,NULL,'Exam Report',0,6,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2012-01-19 09:51:51',NULL),
(63,1,'REM','SR',0,0,'PAT','FR',NULL,NULL,'Request extension',0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2012-01-19 09:52:04',NULL),
(64,1,'REM','EXA',0,0,'PAT','EP',NULL,NULL,'Request extension',0,4,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2012-01-19 09:52:16',NULL),
(65,1,'FBY','REC',0,0,'PAT',NULL,NULL,NULL,NULL,0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2012-01-19 09:52:27',NULL),
(66,1,'PAY','ALL',0,0,'PAT','FR',NULL,NULL,'Grant Fee',0,2,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2017-02-28 16:15:00',NULL),
(67,1,'REQ','PSR',0,0,'PAT','EP',NULL,NULL,NULL,0,6,0,0,0,'EXA',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2012-04-24 13:37:41',NULL),
(68,1,'PAY','PSR',0,0,'PAT','EP',NULL,NULL,'Designation Fees',0,6,0,0,0,'EXA',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2012-04-24 13:37:49',NULL),
(69,1,'REP','PSR',0,0,'PAT','EP',NULL,NULL,'Written Opinion',0,6,0,0,0,'EXA',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2012-04-24 13:36:45',NULL),
(70,1,'REQ','PRI',0,0,'PAT','IN',NULL,NULL,NULL,0,48,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2012-06-30 16:54:01',NULL),
(102,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'2',0,0,1,0,1,NULL,NULL,1,0,NULL,NULL,38.00,NULL,'EUR',NULL,NULL,NULL,'2015-07-01 12:53:10',NULL),
(103,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'3',0,0,2,0,1,NULL,NULL,1,0,NULL,NULL,38.00,NULL,'EUR',NULL,NULL,NULL,'2015-07-01 12:53:15',NULL),
(104,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'4',0,0,3,0,1,NULL,NULL,1,0,NULL,NULL,38.00,NULL,'EUR',NULL,NULL,NULL,'2015-07-01 12:53:19',NULL),
(105,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'5',0,0,4,0,1,NULL,NULL,1,0,NULL,NULL,38.00,NULL,'EUR',NULL,NULL,NULL,'2015-07-01 12:53:23',NULL),
(106,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'6',0,0,5,0,1,NULL,NULL,1,0,NULL,NULL,76.00,NULL,'EUR',NULL,NULL,NULL,'2015-07-01 12:53:27',NULL),
(107,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'7',0,0,6,0,1,NULL,NULL,1,0,NULL,NULL,96.00,NULL,'EUR',NULL,NULL,NULL,'2015-07-01 12:53:31',NULL),
(108,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'8',0,0,7,0,1,NULL,NULL,1,0,NULL,NULL,136.00,NULL,'EUR',NULL,NULL,NULL,'2015-07-01 12:53:36',NULL),
(109,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'9',0,0,8,0,1,NULL,NULL,1,0,NULL,NULL,180.00,NULL,'EUR',NULL,NULL,NULL,'2015-07-01 12:53:41',NULL),
(110,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'10',0,0,9,0,1,NULL,NULL,1,0,NULL,NULL,220.00,NULL,'EUR',NULL,NULL,NULL,'2015-07-01 12:53:46',NULL),
(111,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'11',0,0,10,0,1,NULL,NULL,1,0,NULL,NULL,260.00,NULL,'EUR',NULL,NULL,NULL,'2015-07-01 12:53:53',NULL),
(112,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'12',0,0,11,0,1,NULL,NULL,1,0,NULL,NULL,300.00,NULL,'EUR',NULL,NULL,NULL,'2015-07-01 12:53:58',NULL),
(113,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'13',0,0,12,0,1,NULL,NULL,1,0,NULL,NULL,350.00,NULL,'EUR',NULL,NULL,NULL,'2015-07-01 12:54:02',NULL),
(114,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'14',0,0,13,0,1,NULL,NULL,1,0,NULL,NULL,400.00,NULL,'EUR',NULL,NULL,NULL,'2015-07-01 12:54:08',NULL),
(115,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'15',0,0,14,0,1,NULL,NULL,1,0,NULL,NULL,450.00,NULL,'EUR',NULL,NULL,NULL,'2015-07-01 12:54:13',NULL),
(116,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'16',0,0,15,0,1,NULL,NULL,1,0,NULL,NULL,510.00,NULL,'EUR',NULL,NULL,NULL,'2015-07-01 12:54:19',NULL),
(117,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'17',0,0,16,0,1,NULL,NULL,1,0,NULL,NULL,570.00,NULL,'EUR',NULL,NULL,NULL,'2015-07-01 12:54:24',NULL),
(118,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'18',0,0,17,0,1,NULL,NULL,1,0,NULL,NULL,640.00,NULL,'EUR',NULL,NULL,NULL,'2015-07-01 12:54:29',NULL),
(119,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'19',0,0,18,0,1,NULL,NULL,1,0,NULL,NULL,720.00,NULL,'EUR',NULL,NULL,NULL,'2015-07-01 12:54:33',NULL),
(120,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'20',0,0,19,0,1,NULL,NULL,1,0,NULL,NULL,790.00,NULL,'EUR',NULL,NULL,NULL,'2015-07-01 12:54:43',NULL),
(203,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'3',0,0,2,0,1,NULL,NULL,1,0,NULL,NULL,465.00,NULL,'EUR',NULL,NULL,NULL,'2014-03-18 15:44:01',NULL),
(204,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'4',0,0,3,0,1,NULL,NULL,1,0,NULL,NULL,580.00,NULL,'EUR',NULL,NULL,NULL,'2014-03-18 15:44:06',NULL),
(205,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'5',0,0,4,0,1,NULL,NULL,1,0,NULL,NULL,810.00,NULL,'EUR',NULL,NULL,NULL,'2014-03-18 15:44:10',NULL),
(206,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'6',0,0,5,0,1,NULL,NULL,1,0,NULL,NULL,1040.00,NULL,'EUR',NULL,NULL,NULL,'2014-03-18 15:44:14',NULL),
(207,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'7',0,0,6,0,1,NULL,NULL,1,0,NULL,NULL,1155.00,NULL,'EUR',NULL,NULL,NULL,'2014-03-18 15:44:18',NULL),
(208,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'8',0,0,7,0,1,NULL,NULL,1,0,NULL,NULL,1265.00,NULL,'EUR',NULL,NULL,NULL,'2014-03-18 15:44:22',NULL),
(209,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'9',0,0,8,0,1,NULL,NULL,1,0,NULL,NULL,1380.00,NULL,'EUR',NULL,NULL,NULL,'2014-03-18 15:44:25',NULL),
(210,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'10',0,0,9,0,1,NULL,NULL,1,0,NULL,NULL,1560.00,NULL,'EUR',NULL,NULL,NULL,'2014-03-18 15:44:29',NULL),
(211,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'11',0,0,10,0,1,NULL,NULL,1,0,NULL,NULL,1560.00,NULL,'EUR',NULL,NULL,NULL,'2014-03-18 15:44:32',NULL),
(212,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'12',0,0,11,0,1,NULL,NULL,1,0,NULL,NULL,1560.00,NULL,'EUR',NULL,NULL,NULL,'2014-03-18 15:44:35',NULL),
(213,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'13',0,0,12,0,1,NULL,NULL,1,0,NULL,NULL,1560.00,NULL,'EUR',NULL,NULL,NULL,'2014-03-18 15:44:36',NULL),
(214,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'14',0,0,13,0,1,NULL,NULL,1,0,NULL,NULL,1560.00,NULL,'EUR',NULL,NULL,NULL,'2014-03-18 15:44:37',NULL),
(215,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'15',0,0,14,0,1,NULL,NULL,1,0,NULL,NULL,1560.00,NULL,'EUR',NULL,NULL,NULL,'2014-03-18 15:44:39',NULL),
(216,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'16',0,0,15,0,1,NULL,NULL,1,0,NULL,NULL,1560.00,NULL,'EUR',NULL,NULL,NULL,'2014-03-18 15:44:40',NULL),
(217,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'17',0,0,16,0,1,NULL,NULL,1,0,NULL,NULL,1560.00,NULL,'EUR',NULL,NULL,NULL,'2014-03-18 15:44:46',NULL),
(218,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'18',0,0,17,0,1,NULL,NULL,1,0,NULL,NULL,1560.00,NULL,'EUR',NULL,NULL,NULL,'2014-03-18 15:44:47',NULL),
(219,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'19',0,0,18,0,1,NULL,NULL,1,0,NULL,NULL,1560.00,NULL,'EUR',NULL,NULL,NULL,'2014-03-18 15:44:48',NULL),
(220,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'20',0,0,19,0,1,NULL,NULL,1,0,NULL,NULL,1560.00,NULL,'EUR',NULL,NULL,NULL,'2014-03-18 15:44:51',NULL),
(234,1,'PAY','ALL',0,0,'PAT','CN',NULL,NULL,'Grant Fee',76,0,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2017-02-28 16:15:41',NULL),
(235,1,'REP','SR',0,0,'PAT','WO',NULL,NULL,'Written Opinion',0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-03-07 16:32:14',NULL),
(236,1,'PAY','ALL',0,0,'PAT','US',NULL,NULL,'Grant Fee',0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2017-02-28 16:15:48',NULL),
(237,1,'PROD','GRT',0,0,'PAT','IN',NULL,NULL,'Working Report',0,2,0,0,1,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,'Change date to end of March',NULL,'2012-05-22 07:14:03',NULL),
(238,1,'WAT','PUB',0,0,'TM','FR',NULL,NULL,'Opposition deadline',0,2,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2012-06-19 09:48:26',NULL),
(239,1,'WAT','PUB',0,0,'TM','EM',NULL,NULL,'Opposition deadline',0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2012-06-19 09:49:18',NULL),
(240,1,'WAT','PUB',0,0,'TM','US',NULL,NULL,'Opposition deadline',30,0,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2012-06-19 09:50:06',NULL),
(242,1,'PROD','REG',0,0,'TM','US',NULL,NULL,'Declaration of use',0,66,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,'délai à 5 ans et demi',NULL,'2013-10-15 11:01:57',NULL),
(1001,1,'REN','FIL',0,0,'TM',NULL,NULL,NULL,'10',0,0,10,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:09:20',NULL),
(1002,1,'REN','FIL',0,0,'TM',NULL,NULL,NULL,'20',0,0,20,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:09:21',NULL),
(1003,1,'REN','FIL',0,0,'TM',NULL,NULL,NULL,'30',0,0,30,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:09:22',NULL),
(1004,1,'REN','FIL',0,0,'TM',NULL,NULL,NULL,'40',0,0,40,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:09:24',NULL),
(1005,1,'REN','FIL',0,0,'TM',NULL,NULL,NULL,'50',0,0,50,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:09:25',NULL),
(1011,1,'REN','REG',0,0,'TM','CA',NULL,NULL,'15',0,0,15,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:09:27',NULL),
(1012,1,'REN','REG',0,0,'TM','CA',NULL,NULL,'30',0,0,30,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:09:29',NULL),
(1013,1,'REN','REG',0,0,'TM','CA',NULL,NULL,'45',0,0,45,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:09:31',NULL),
(1081,1,'REN','REG',0,0,'TM','US',NULL,NULL,'10',0,0,10,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:07:59',NULL),
(1082,1,'REN','REG',0,0,'TM','US',NULL,NULL,'20',0,0,20,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:16',NULL),
(1083,1,'REN','REG',0,0,'TM','US',NULL,NULL,'30',0,0,30,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:19',NULL),
(1084,1,'REN','REG',0,0,'TM','US',NULL,NULL,'40',0,0,40,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:21',NULL),
(1085,1,'REN','REG',0,0,'TM','US',NULL,NULL,'50',0,0,50,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:22',NULL),
(1091,1,'REN','REG',0,0,'TM','JP',NULL,NULL,'10',0,0,10,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:24',NULL),
(1092,1,'REN','REG',0,0,'TM','JP',NULL,NULL,'20',0,0,20,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:25',NULL),
(1093,1,'REN','REG',0,0,'TM','JP',NULL,NULL,'30',0,0,30,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:26',NULL),
(1094,1,'REN','REG',0,0,'TM','JP',NULL,NULL,'40',0,0,40,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:29',NULL),
(1101,1,'REN','REG',0,0,'TM','KR',NULL,NULL,'10',0,0,10,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:27',NULL),
(1102,1,'REN','REG',0,0,'TM','KR',NULL,NULL,'20',0,0,20,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:30',NULL),
(1103,1,'REN','REG',0,0,'TM','KR',NULL,NULL,'30',0,0,30,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:31',NULL),
(1104,1,'REN','REG',0,0,'TM','KR',NULL,NULL,'40',0,0,40,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:33',NULL),
(1121,1,'REN','REG',0,0,'TM','BR',NULL,NULL,'10',0,0,10,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:34',NULL),
(1122,1,'REN','REG',0,0,'TM','BR',NULL,NULL,'20',0,0,20,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:35',NULL),
(1123,1,'REN','REG',0,0,'TM','BR',NULL,NULL,'30',0,0,30,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:36',NULL),
(1124,1,'REN','REG',0,0,'TM','BR',NULL,NULL,'40',0,0,40,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:37',NULL),
(1131,1,'REN','REG',0,0,'TM','CN',NULL,NULL,'10',0,0,10,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:38',NULL),
(1132,1,'REN','REG',0,0,'TM','CN',NULL,NULL,'20',0,0,20,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:39',NULL),
(1133,1,'REN','REG',0,0,'TM','CN',NULL,NULL,'30',0,0,30,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:40',NULL),
(1134,1,'REN','REG',0,0,'TM','CN',NULL,NULL,'40',0,0,40,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:41',NULL),
(1181,1,'PROD','FIL',0,0,'PAT','IN',NULL,NULL,'Annexure to Form 3',0,0,2,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-10-29 15:06:33',NULL),
(1182,1,'PROD','FIL',0,0,'PAT','IN',NULL,NULL,'Declaration',0,0,2,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2016-10-25 13:40:06',NULL),
(1183,1,'PROD','FIL',0,0,'PAT','IN',NULL,NULL,'Power',0,0,2,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-10-29 15:06:45',NULL),
(1184,1,'PAY','ALL',0,0,'PAT','KR',NULL,NULL,'Grant Fee',0,3,0,0,0,'GRT',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2017-02-28 16:16:08',NULL),
(1185,1,'PAY','ALL',0,0,'PAT','TW',NULL,NULL,'Grant Fee',0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2017-02-28 16:15:12',NULL),
(1186,1,'REP','EXA',0,0,'PAT','AU',NULL,NULL,'Exam Report',0,12,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-02-20 09:07:08',NULL),
(1187,1,'REP','EXA',0,0,'PAT','IN',NULL,NULL,'Exam Report',0,6,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-03-04 14:26:35',NULL),
(1188,1,'REP','EXA',0,0,'PAT','KR',NULL,NULL,'Exam Report',0,2,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-03-26 11:07:07',NULL),
(1189,1,'REN','FIL',0,0,'DSG','FR',NULL,NULL,'1',0,0,5,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-05-16 13:19:27',NULL),
(1190,1,'REN','FIL',0,0,'DSG','FR',NULL,NULL,'2',0,0,10,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-05-16 13:19:28',NULL),
(1191,1,'REN','FIL',0,0,'DSG','FR',NULL,NULL,'3',0,0,15,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-05-16 13:19:29',NULL),
(1192,1,'REN','FIL',0,0,'DSG','FR',NULL,NULL,'4',0,0,20,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-05-16 13:19:30',NULL),
(1193,1,'REN','FIL',0,0,'DSG','FR',NULL,NULL,'5',0,0,25,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-05-16 13:19:31',NULL),
(1194,1,'REN','FIL',0,0,'DSG','EM',NULL,NULL,'1',0,0,5,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-05-16 13:19:32',NULL),
(1195,1,'REN','FIL',0,0,'DSG','EM',NULL,NULL,'2',0,0,10,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-05-16 13:19:33',NULL),
(1196,1,'REN','FIL',0,0,'DSG','EM',NULL,NULL,'3',0,0,15,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-05-16 13:19:34',NULL),
(1197,1,'REN','FIL',0,0,'DSG','EM',NULL,NULL,'4',0,0,20,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-05-16 13:19:35',NULL),
(1198,1,'REN','FIL',0,0,'DSG','EM',NULL,NULL,'5',0,0,25,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-05-16 13:19:36',NULL),
(1211,1,'REN','REG',0,0,'TM','DK',NULL,NULL,'10',0,0,10,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:42',NULL),
(1212,1,'REN','REG',0,0,'TM','DK',NULL,NULL,'20',0,0,20,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:43',NULL),
(1213,1,'REN','REG',0,0,'TM','DK',NULL,NULL,'30',0,0,30,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:44',NULL),
(1214,1,'REN','REG',0,0,'TM','DK',NULL,NULL,'40',0,0,40,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:45',NULL),
(1215,1,'REN','REG',0,0,'TM','DK',NULL,NULL,'50',0,0,50,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:47',NULL),
(1216,1,'REN','REG',0,0,'TM','NO',NULL,NULL,'10',0,0,10,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:48',NULL),
(1217,1,'REN','REG',0,0,'TM','NO',NULL,NULL,'20',0,0,20,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:49',NULL),
(1218,1,'REN','REG',0,0,'TM','NO',NULL,NULL,'30',0,0,30,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:51',NULL),
(1219,1,'REN','REG',0,0,'TM','NO',NULL,NULL,'40',0,0,40,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:52',NULL),
(1220,1,'REN','REG',0,0,'TM','NO',NULL,NULL,'50',0,0,50,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:53',NULL),
(1221,1,'REN','REG',0,0,'TM','FI',NULL,NULL,'10',0,0,10,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:54',NULL),
(1222,1,'REN','REG',0,0,'TM','FI',NULL,NULL,'20',0,0,20,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:55',NULL),
(1223,1,'REN','REG',0,0,'TM','FI',NULL,NULL,'30',0,0,30,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:56',NULL),
(1224,1,'REN','REG',0,0,'TM','FI',NULL,NULL,'40',0,0,40,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:08:59',NULL),
(1225,1,'REN','REG',0,0,'TM','FI',NULL,NULL,'50',0,0,50,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:09:07',NULL),
(1228,1,'REP','EXA',0,0,'PAT','TW',NULL,NULL,'Exam Report',0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-07-25 12:28:59',NULL),
(1230,1,'REN','PR',0,0,'TM','TW',NULL,NULL,'10',0,11,9,0,1,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:09:09',NULL),
(1231,1,'REN','PR',0,0,'TM','TW',NULL,NULL,'20',0,11,19,0,1,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:09:11',NULL),
(1232,1,'REN','PR',0,0,'TM','TW',NULL,NULL,'30',0,11,29,0,1,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:09:12',NULL),
(1233,1,'REN','PR',0,0,'TM','TW',NULL,NULL,'40',0,11,39,0,1,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:09:14',NULL),
(1234,1,'REN','PR',0,0,'TM','TW',NULL,NULL,'50',0,11,49,0,1,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:09:15',NULL),
(1235,1,'REN','FIL',0,0,'TM','SA',NULL,NULL,'10',0,8,9,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,'10 ans Hegira',NULL,'2014-11-12 10:09:17',NULL),
(1236,1,'REP','EXA',0,0,'PAT','JP',NULL,NULL,'Exam Report',0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-07-25 12:29:23',NULL),
(1237,1,'REP','EXA',0,0,'TM','US',NULL,NULL,'Exam Report',0,6,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-07-31 16:36:26',NULL),
(1238,1,'REP','EXA',0,0,'TM','KR',NULL,NULL,'Exam Report',0,2,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-08-07 09:34:45',NULL),
(1239,1,'REP','COM',0,0,'TM','EM',NULL,NULL,'Irregularity',0,2,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-08-20 16:22:03',NULL),
(1240,1,'REP','EXA',0,0,'TM','CN',NULL,NULL,'Exam Report',0,1,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-08-27 07:56:38',NULL),
(1241,1,'PAY','ALL',0,0,'TM','CA',NULL,NULL,'Grant Fee',0,6,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2017-02-28 16:15:30',NULL),
(1242,1,'PROD','ALL',0,0,'TM','CA',NULL,NULL,'Declaration of use',0,6,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-11-20 10:14:24',NULL),
(1243,1,'WAT','PUB',0,0,'TM','BR',NULL,NULL,'Opposition deadline',60,0,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-09-09 09:07:42',NULL),
(1244,1,'PROD','OPP',0,0,'TM','FR',NULL,NULL,'Observations',0,2,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-09-09 09:20:14',NULL),
(1245,1,'PROD','ALL',0,0,'TM','US',NULL,NULL,'Statement of use',0,6,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-09-09 09:50:58',NULL),
(1246,1,'REP','EXA',0,0,'TM','IL',NULL,NULL,'Exam Report',0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-09-09 10:10:07',NULL),
(1247,1,'PROD','EXA',0,0,'TM','US',NULL,NULL,'POA',0,6,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-09-17 14:03:24',NULL),
(1248,1,'PROD','EXA',0,0,'TM','KR',NULL,NULL,'POA',0,2,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-09-17 14:03:44',NULL),
(1249,1,'PROD','EXA',0,0,'TM','CN',NULL,NULL,'POA',0,1,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-09-17 14:04:03',NULL),
(1250,1,'PROD','EXA',0,0,'TM','IL',NULL,NULL,'POA',0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-09-17 14:04:22',NULL),
(1251,1,'PROD','REF',0,0,'TM',NULL,NULL,NULL,'Appeal Brief',45,0,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2017-02-28 16:13:47',NULL),
(1252,1,'PROD','REF',0,0,'TM',NULL,NULL,NULL,'POA',45,0,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:09:19',NULL),
(1253,1,'REP','EXA',0,0,'TM','CA',NULL,NULL,'Exam Report',0,6,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-09-20 11:10:30',NULL),
(1254,1,'REP','EXA',0,0,'TM','TH',NULL,NULL,'Exam Report',0,2,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-09-20 13:43:06',NULL),
(1258,1,'REP','EXAF',0,0,'PAT','US',NULL,NULL,'Final OA',0,2,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-10-04 12:23:02',NULL),
(1259,1,'PROD','REG',0,0,'TM','US',NULL,NULL,'Declaration of use',0,114,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,'délai à 9 ans et demi',NULL,'2013-10-15 11:02:03',NULL),
(1260,1,'REP','COM',0,0,'TM','WO',NULL,NULL,'Irregularity',0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2013-11-06 14:43:17',NULL),
(1262,1,'PROD','APL',0,0,'TM','EM',NULL,NULL,'Appeal Brief',0,4,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2017-03-01 09:47:37',NULL),
(1263,1,'REN','PRI',0,0,'TM','NZ',NULL,NULL,'10',0,0,10,0,0,NULL,'ALL',0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:09:26',NULL),
(1267,1,'REN','PRI',0,0,'TM','NZ',NULL,NULL,'20',0,0,20,0,0,NULL,'ALL',0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:09:28',NULL),
(1268,1,'REN','PRI',0,0,'TM','NZ',NULL,NULL,'30',0,0,30,0,0,NULL,'ALL',0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:09:30',NULL),
(1269,1,'REN','PRI',0,0,'TM','NZ',NULL,NULL,'40',0,0,40,0,0,NULL,'ALL',0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:09:32',NULL),
(1270,1,'REN','PRI',0,0,'TM','NZ',NULL,NULL,'50',0,0,50,0,0,NULL,'ALL',0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:09:33',NULL),
(1271,1,'REP','COM',0,0,'TM','FR',NULL,NULL,'Irregularity',0,1,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-02-03 10:44:48',NULL),
(1272,1,'REN','REG',0,0,'TM','LB',NULL,NULL,'15',0,0,15,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:09:34',NULL),
(1273,1,'REN','PRI',0,0,'TM','RU',NULL,NULL,'10',0,0,10,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:09:35',NULL),
(1274,1,'REN','PRI',0,0,'TM','RU',NULL,NULL,'20',0,0,20,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:09:37',NULL),
(1275,1,'REN','PRI',0,0,'TM','RU',NULL,NULL,'30',0,0,30,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:09:38',NULL),
(1277,1,'REN','PRI',0,0,'TM','RU',NULL,NULL,'40',0,0,40,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:09:39',NULL),
(1278,1,'REN','PRI',0,0,'TM','RU',NULL,NULL,'50',0,0,50,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-12 10:09:43',NULL),
(1280,1,'PROD','SOP',0,0,'PAT','EP',NULL,NULL,'Observations',10,4,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2017-05-24 09:55:39',NULL),
(1281,1,'OPR','SOP',0,0,'PAT','EP',NULL,NULL,NULL,10,5,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-05-07 07:10:52',NULL),
(1282,1,'PAY','ALL',0,0,'TM','JP',NULL,NULL,'2nd part of individual fee',0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-05 16:13:42',NULL),
(1290,1,'REN','FIL',0,0,'SO','FR',NULL,NULL,'Soleau',0,0,5,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-09-10 08:12:28',NULL),
(1291,1,'WAT','FIL',0,0,'SO','FR',NULL,NULL,'End of protection',0,114,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-09-10 08:14:53',NULL),
(1292,1,'EXP','FIL',0,0,'SO','FR',NULL,NULL,NULL,0,0,10,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-09-10 08:14:24',NULL),
(1299,1,'OPR','SOP',0,0,'OP',NULL,NULL,NULL,NULL,0,6,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2016-11-15 13:24:01',NULL),
(1300,1,'PROD','SOP',0,0,'OP',NULL,NULL,NULL,'Observations',0,4,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2016-11-15 13:24:01',NULL),
(1301,1,'PROD','PRI',0,0,'PAT','US','WO',NULL,'Decl. and Assignment',0,30,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2014-11-14 13:00:44',NULL),
(1302,1,'REQ','FIL',0,0,'PAT','BR',NULL,NULL,NULL,0,0,3,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2015-01-05 16:39:05',NULL),
(1303,1,'FAP','ORE',0,0,'OP','EP',NULL,NULL,NULL,0,2,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2017-05-24 09:20:47',NULL),
(1305,1,'PRID','FIL',0,0,'DSG',NULL,NULL,NULL,NULL,0,6,0,0,0,'PRI',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,'Priority deadline is inserted only if no priority event exists',NULL,'2015-12-17 08:37:47',NULL),
(1306,1,'PRID','PRI',0,1,'DSG',NULL,NULL,NULL,NULL,0,0,0,0,0,NULL,'FIL',0,0,NULL,NULL,NULL,NULL,'EUR',NULL,'Deletes priority deadline when a priority event is inserted',NULL,'2015-12-17 10:41:57',NULL),
(1307,1,'PRID','PRI',0,1,'TM',NULL,NULL,NULL,NULL,0,0,0,0,0,NULL,'FIL',0,0,NULL,NULL,NULL,NULL,'EUR',NULL,'Deletes priority deadline when a priority event is inserted',NULL,'2015-12-17 10:43:44',NULL),
(1308,1,'REN','FIL',0,0,'DSG','WO',NULL,NULL,'1',0,0,5,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2015-12-17 13:35:47',NULL),
(1309,1,'REN','FIL',0,0,'DSG','WO',NULL,NULL,'2',0,0,10,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2015-12-17 13:36:12',NULL),
(1310,1,'PROD','REC',0,0,'OPI',NULL,NULL,NULL,'Opinion',0,1,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2016-02-26 14:26:26',NULL),
(1311,1,'PROD','REC',0,0,'SR',NULL,NULL,NULL,'Report',0,1,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2016-02-26 14:26:26',NULL),
(1314,1,'PROD','FIL',0,0,'PAT','IN',NULL,NULL,'Verification of translation',0,0,2,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2016-06-16 09:18:11',NULL),
(1315,1,'REP','EXA',0,0,'TM','JP',NULL,NULL,'Exam Report',0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2016-10-12 14:44:28',NULL),
(1316,1,'PROD','EXA',0,0,'TM','JP',NULL,NULL,'POA',0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2016-10-12 14:44:32',NULL),
(1317,1,'PROD','FIL',0,0,'PAT','IN','WO',NULL,'Verification of translation',0,0,2,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2016-10-25 13:42:13',NULL),
(1318,1,'PROD','FIL',0,0,'PAT','IN','WO',NULL,'Annexure to Form 3',0,0,2,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2016-10-25 13:42:42',NULL),
(1319,1,'PROD','FIL',0,0,'PAT','IN','WO',NULL,'Declaration',0,0,2,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2016-10-25 13:43:04',NULL),
(1320,1,'PROD','FIL',0,0,'PAT','IN','WO',NULL,'Power',0,0,2,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2016-10-25 13:43:24',NULL),
(1321,1,'PROD','SR',0,0,'PAT','EP',NULL,NULL,'Analysis of SR',0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2016-12-22 15:45:21',NULL),
(1322,1,'PROD','DPAPL',0,0,'PAT','US',NULL,NULL,'Appeal Brief',0,1,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2017-02-28 15:16:05',NULL),
(1323,1,'FRCE','EXAF',0,0,'PAT','US',NULL,NULL,NULL,0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2017-02-28 16:27:42',NULL),
(1326,1,'FAP','EXAF',0,0,'PAT','US',NULL,NULL,NULL,0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2017-02-28 16:32:58',NULL),
(1327,1,'FAP','APL',1,0,'PAT',NULL,NULL,NULL,NULL,0,0,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2017-02-28 17:54:34',NULL),
(1328,1,'PROD','REC',0,0,'TM',NULL,NULL,NULL,'Analyse CompuMark',15,0,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2017-03-02 08:47:19',NULL),
(1329,1,'PROD','REC',0,0,'TM',NULL,NULL,NULL,'Libellé P/S',0,1,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2017-03-02 08:47:43',NULL),
(1330,1,'PROD','EXA',0,0,'PAT',NULL,NULL,NULL,'Preliminary Comments',40,0,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,NULL,'2017-05-24 09:57:42',NULL);
/*!40000 ALTER TABLE `task_rules` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-05-26 10:57:46

SET FOREIGN_KEY_CHECKS = 1;
COMMIT;
SET AUTOCOMMIT = 1;
-- User creation
CREATE USER 'phpip'@'localhost' IDENTIFIED BY 'changeme'; 
GRANT SELECT ON phpip.* TO 'phpip'@'localhost'; 
GRANT UPDATE (last_login) ON TABLE actor TO 'phpip'@'localhost';
CREATE USER 'phpipuser'@'%' IDENTIFIED BY 'changeme'; 
GRANT ALL ON phpip.* TO 'phpipuser'@'%';
