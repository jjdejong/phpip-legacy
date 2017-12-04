# ************************************************************
# phpIP test data
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Affichage de la table actor
# ------------------------------------------------------------

LOCK TABLES `actor` WRITE;
/*!40000 ALTER TABLE `actor` DISABLE KEYS */;

INSERT INTO `actor` (`ID`, `name`, `first_name`, `display_name`, `login`, `password`, `password_salt`, `last_login`, `default_role`, `function`, `parent_ID`, `company_ID`, `site_ID`, `phy_person`, `nationality`, `small_entity`, `address`, `country`, `address_mailing`, `country_mailing`, `address_billing`, `country_billing`, `email`, `phone`, `phone2`, `fax`, `warn`, `notes`, `VAT_number`, `creator`, `updated`, `updater`)
VALUES
	(120,'phpIP User',NULL,NULL,'phpipuser','26320dbc247a9f2aec0afc69b5d82d72','salt','2017-12-04 09:28:29',NULL,NULL,NULL,NULL,NULL,1,NULL,0,'',NULL,'',NULL,'',NULL,'root@localhost',NULL,NULL,NULL,0,NULL,NULL,'root','2017-12-04 09:28:29','phpip'),
	(124,'Tesla Motors Inc.',NULL,'Tesla',NULL,NULL,NULL,NULL,'CLI',NULL,NULL,NULL,NULL,0,NULL,0,'',NULL,'',NULL,'',NULL,NULL,NULL,NULL,NULL,0,'TEST DATA',NULL,'phpipuser','2017-12-03 16:45:57','phpipuser'),
	(125,'BAGLINO Andrew D.',NULL,NULL,NULL,NULL,NULL,NULL,'INV',NULL,NULL,124,NULL,1,NULL,0,'','US','',NULL,'',NULL,NULL,NULL,NULL,NULL,0,'TEST DATA',NULL,'phpipuser','2017-12-03 16:45:48','phpipuser'),
	(126,'HAYER Thorsten',NULL,NULL,NULL,NULL,NULL,NULL,'INV',NULL,NULL,124,NULL,1,NULL,0,'',NULL,'',NULL,'',NULL,NULL,NULL,NULL,NULL,0,'TEST DATA',NULL,'phpipuser','2017-12-03 16:45:37','phpipuser'),
	(127,'BOBLETT Brennan',NULL,NULL,NULL,NULL,NULL,NULL,'INV',NULL,NULL,124,NULL,1,NULL,0,'','US','',NULL,'',NULL,NULL,NULL,NULL,NULL,0,'TEST DATA',NULL,'phpipuser','2017-12-03 16:45:23',NULL),
	(128,'Boehmert & Boehmert',NULL,'Boehmert',NULL,NULL,NULL,NULL,'AGT',NULL,NULL,NULL,NULL,1,'DE',0,'','DE','',NULL,'',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'phpipuser','2017-12-03 17:40:13','phpipuser'),
	(129,'SODERBERG Richard',NULL,NULL,NULL,NULL,NULL,NULL,'AGT',NULL,NULL,NULL,NULL,1,NULL,0,'','US','',NULL,'',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'phpipuser','2017-12-03 17:33:37',NULL),
	(130,'Texas Patents',NULL,NULL,NULL,NULL,NULL,NULL,'AGT',NULL,NULL,NULL,NULL,1,NULL,0,'','US','',NULL,'',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'phpipuser','2017-12-03 17:37:19',NULL);

/*!40000 ALTER TABLE `actor` ENABLE KEYS */;
UNLOCK TABLES;


# Affichage de la table actor_role
# ------------------------------------------------------------

LOCK TABLES `actor_role` WRITE;
/*!40000 ALTER TABLE `actor_role` DISABLE KEYS */;

INSERT INTO `actor_role` (`code`, `name`, `display_order`, `shareable`, `show_ref`, `show_company`, `show_rate`, `show_date`, `box`, `box_color`, `notes`, `creator`, `updated`, `updater`)
VALUES
	('AGT','Primary Agent',20,0,1,0,0,0,3,NULL,NULL,'root','2016-03-16 16:49:49','root'),
	('AGT2','Secondary Agent',22,0,1,0,0,0,3,NULL,'Usually the primary agent\'s agent','root','2011-05-05 11:17:57','root@localhost'),
	('ANN','Annuity Agent',21,0,1,0,0,0,3,NULL,'Agent in charge of renewals. \"Client handled\" is a special agent who, when added, will delete any renewals in the matter','root','2016-03-16 16:49:49','root'),
	('APP','Applicant',3,1,1,0,0,0,1,NULL,'Assignee in the US, i.e. the owner upon filing','root','2016-03-16 16:49:49','root'),
	('CLI','Client',1,1,1,0,1,0,1,NULL,'The client we take instructions from and who we invoice. DO NOT CHANGE OR DELETE: this is also a database user role','root','2016-04-03 15:56:28','root'),
	('CNT','Contact',30,1,1,1,0,0,4,NULL,'Client\'s contact person','root','2011-05-05 11:19:26','root@localhost'),
	('DEL','Delegate',31,1,0,0,0,0,4,NULL,'Another user allowed to manage the case','root','2016-03-16 16:49:50','root'),
	('FAGT','Former Agent',23,0,1,0,0,0,127,'#000000',NULL,'root','2012-08-06 11:03:14','root'),
	('FOWN','Former Owner',5,0,0,0,0,1,1,NULL,'To keep track of ownership history','root','2016-03-16 16:49:50','root'),
	('INV','Inventor',10,1,0,1,0,0,2,NULL,NULL,'root','2016-03-16 16:49:50','root'),
	('LCN','Licensee',127,0,0,0,0,0,0,NULL,NULL,'root','2016-03-16 16:49:50','root'),
	('OFF','Patent Office',127,0,0,0,0,0,0,NULL,NULL,'root','2016-03-16 16:49:50','root'),
	('OPP','Opposing Party',127,0,0,0,0,0,0,NULL,NULL,'root','2016-03-16 16:49:50','root'),
	('OWN','Owner',4,0,1,0,1,1,1,'NULL','Use if different than applicant','root','2012-12-20 11:13:50','root'),
	('PAY','Payor',2,1,0,0,1,0,1,'#000000','The actor who pays','root','2011-09-27 12:18:42','root'),
	('PTNR','Partner',127,1,0,0,0,0,0,NULL,NULL,'root','2016-03-16 16:49:50','root'),
	('TRA','Translator',127,0,0,0,0,1,127,'#000000',NULL,'root','2013-12-16 12:47:04',NULL),
	('WRI','Writer',127,1,0,0,0,0,0,NULL,'Person who follows the case','root','2016-03-16 16:49:50','root');

/*!40000 ALTER TABLE `actor_role` ENABLE KEYS */;
UNLOCK TABLES;


# Affichage de la table classifier
# ------------------------------------------------------------

LOCK TABLES `classifier` WRITE;
/*!40000 ALTER TABLE `classifier` DISABLE KEYS */;

INSERT INTO `classifier` (`ID`, `matter_ID`, `type_code`, `value`, `url`, `value_ID`, `display_order`, `lnk_matter_ID`, `creator`, `updated`, `updater`)
VALUES
	(4,4,'TITOF','Trip planning with energy constraint',NULL,NULL,1,NULL,'phpipuser','2017-12-03 16:34:12',NULL),
	(5,4,'TIT','Trip Planning with Energy Constraint',NULL,NULL,1,NULL,'phpipuser','2017-12-04 09:29:59','phpipuser');

/*!40000 ALTER TABLE `classifier` ENABLE KEYS */;
UNLOCK TABLES;


# Affichage de la table classifier_type
# ------------------------------------------------------------

LOCK TABLES `classifier_type` WRITE;
/*!40000 ALTER TABLE `classifier_type` DISABLE KEYS */;

INSERT INTO `classifier_type` (`code`, `type`, `main_display`, `for_category`, `display_order`, `notes`, `creator`, `updated`, `updater`)
VALUES
	('ABS','Abstract',0,NULL,127,NULL,'root','2011-06-18 17:30:36','root@localhost'),
	('AGR','Agreement',0,NULL,127,NULL,'root','2011-06-18 17:30:39','root@localhost'),
	('BU','Business Unit',0,NULL,127,NULL,'root','2011-06-18 17:30:43','root@localhost'),
	('DESC','Description',1,NULL,1,NULL,'root','2011-09-28 09:15:14','root'),
	('EVAL','Evaluation',0,NULL,127,NULL,'root','2011-06-18 17:30:46','root@localhost'),
	('IPC','IPC',0,NULL,127,NULL,'root','2011-09-28 09:04:43','root'),
	('KW','Keyword',0,NULL,127,NULL,'root','2011-09-28 15:22:46','root'),
	('LNK','Link',0,NULL,1,NULL,'root','2011-09-28 15:22:41','root'),
	('LOC','Location',0,NULL,127,NULL,'root','2013-03-25 17:20:22','root'),
	('ORG','Organization',0,NULL,127,NULL,'root','2011-06-18 17:30:57','root@localhost'),
	('PA','Prior Art',0,NULL,127,NULL,'root','2011-09-28 15:24:11','root'),
	('PROD','Product',0,NULL,127,NULL,'root','2011-06-18 17:30:59','root@localhost'),
	('PROJ','Project',0,NULL,127,NULL,'root','2011-06-18 17:31:02','root@localhost'),
	('TECH','Technology',0,NULL,127,NULL,'root','2011-06-18 17:31:05','root@localhost'),
	('TIT','Title',1,NULL,1,NULL,'root','2011-09-28 09:15:28','root'),
	('TITAL','Alt. Title',1,'PAT',4,NULL,'root','2011-10-08 18:36:28','root'),
	('TITEN','English Title',1,'PAT',3,NULL,'root','2011-06-18 18:14:38','root@localhost'),
	('TITOF','Official Title',1,'PAT',2,NULL,'root','2011-06-18 18:14:42','root@localhost'),
	('TM','Trademark',1,'TM',1,NULL,'root','2011-09-28 15:20:24','root'),
	('TMCL','Class (TM)',0,'TM',2,NULL,'root','2012-06-18 19:25:26','root'),
	('TMTYP','Type (TM)',0,'TM',3,NULL,'root','2012-06-18 19:25:34','root');

/*!40000 ALTER TABLE `classifier_type` ENABLE KEYS */;
UNLOCK TABLES;


# Affichage de la table classifier_value
# ------------------------------------------------------------



# Affichage de la table country
# ------------------------------------------------------------

LOCK TABLES `country` WRITE;
/*!40000 ALTER TABLE `country` DISABLE KEYS */;

INSERT INTO `country` (`numcode`, `iso`, `iso3`, `name_DE`, `name`, `name_FR`, `ep`, `wo`, `em`, `oa`)
VALUES
	(20,'AD','AND','Andorra','Andorra','Andorre',0,0,0,0),
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


# Affichage de la table default_actor
# ------------------------------------------------------------



# Affichage de la table event
# ------------------------------------------------------------

LOCK TABLES `event` WRITE;
/*!40000 ALTER TABLE `event` DISABLE KEYS */;

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

/*!40000 ALTER TABLE `event` ENABLE KEYS */;
UNLOCK TABLES;


# Affichage de la table event_name
# ------------------------------------------------------------

LOCK TABLES `event_name` WRITE;
/*!40000 ALTER TABLE `event_name` DISABLE KEYS */;

INSERT INTO `event_name` (`code`, `name`, `category`, `country`, `is_task`, `status_event`, `default_responsible`, `use_matter_resp`, `unique`, `uqtrigger`, `killer`, `notes`, `creator`, `updated`, `updater`)
VALUES
	('ABA','Abandoned',NULL,NULL,0,1,NULL,0,1,0,1,NULL,'root',NULL,NULL),
	('ABO','Abandon Original','PAT','EP',1,0,NULL,0,1,0,0,'Abandon the originating patent that was re-designated in EP','root','2011-04-23 22:43:27','root@localhost'),
	('ADV','Advisory Action','PAT','US',0,0,NULL,0,0,0,0,NULL,'root',NULL,NULL),
	('ALL','Allowance','PAT',NULL,0,1,NULL,0,0,0,0,'Use also for R71.3 in EP','root','2011-03-20 17:15:45','root@localhost'),
	('APL','Appeal',NULL,NULL,0,1,NULL,1,0,0,0,'Appeal or other remedy filed','root','2017-05-24 10:32:29','root'),
	('CAN','Cancelled','TM',NULL,0,1,NULL,0,0,0,1,NULL,'root','2014-10-09 10:54:39',NULL),
	('CLO','Closed','LTG',NULL,0,1,NULL,0,0,0,1,NULL,'root','2015-11-25 14:07:23',NULL),
	('COM','Communication',NULL,NULL,0,0,NULL,0,0,0,0,'Communication regarding administrative or formal matters (missing parts, irregularities...)','root','2011-04-26 16:47:36','root@localhost'),
	('CRE','Created',NULL,NULL,0,0,NULL,0,1,0,0,'Creation date of matter - for attaching tasks necessary before anything else','root','2011-10-09 21:41:17',NULL),
	('DAPL','Decision on Appeal',NULL,NULL,0,0,NULL,0,0,0,0,'State outcome in detail field','root','2017-02-28 16:17:46','root'),
	('DBY','Draft By','PAT',NULL,1,0,NULL,1,0,0,0,NULL,'root','2011-09-22 10:55:07','root'),
	('DEX','Deadline Extended',NULL,NULL,0,0,NULL,0,0,0,0,'Deadline extension requested','root','2011-04-26 16:48:02','root@localhost'),
	('DPAPL','Decision on Pre-Appeal','PAT','US',0,0,NULL,0,0,0,0,NULL,'root','2017-02-28 16:13:43',NULL),
	('DRA','Drafted','PAT',NULL,0,1,NULL,0,0,0,0,NULL,'root',NULL,NULL),
	('DW','Deemed withrawn',NULL,NULL,0,1,NULL,0,0,0,0,'Decision needing a reply, such as further processing','root','2014-05-05 15:53:33','root'),
	('EHK','Extend to Hong Kong','PAT','CN',1,0,NULL,0,1,0,0,NULL,'root','2011-03-22 08:52:06',NULL),
	('ENT','Entered','PAT',NULL,0,0,NULL,0,1,0,0,'National entry date from PCT phase','root','2011-10-12 12:19:29','root'),
	('EOP','End of Procedure','PAT',NULL,0,1,NULL,0,1,0,1,'Indicates end of international phase for PCT','root','2014-07-07 16:01:03','root'),
	('EXA','Examiner Action',NULL,NULL,0,0,NULL,0,0,0,0,'AKA Office Action, i.e. anything related to substantive examination','root','2011-03-20 18:03:46','root@localhost'),
	('EXAF','Examiner Action (Final)','PAT','US',0,0,NULL,0,0,0,0,NULL,'root','2013-10-10 18:09:24','root'),
	('EXP','Expiry',NULL,NULL,0,1,NULL,0,1,0,1,'Do not use nor change - present for internal functionality','root','2017-01-17 14:43:06','root'),
	('FAP','File Notice of Appeal',NULL,NULL,1,0,NULL,1,0,0,0,NULL,'root','2016-01-30 12:46:54','root'),
	('FBY','File by',NULL,NULL,1,0,NULL,0,1,0,0,NULL,'root','2012-01-18 07:50:04','root'),
	('FDIV','File Divisional','PAT',NULL,1,0,NULL,0,1,0,0,NULL,'root','2011-04-23 22:44:30','root@localhost'),
	('FIL','Filed',NULL,NULL,0,1,NULL,0,1,0,0,NULL,'root','2011-04-26 16:20:23','root@localhost'),
	('FOP','File Opposition','OP','EP',1,0,NULL,1,1,0,0,NULL,'root','2011-09-22 10:56:06','root'),
	('FPR','Further Processing','PAT',NULL,1,0,NULL,1,0,0,0,NULL,'root','2011-10-10 00:29:42','root'),
	('FRCE','File RCE','PAT','US',1,0,NULL,0,0,0,0,NULL,'root','2013-09-24 18:09:36',NULL),
	('GRT','Granted','PAT',NULL,0,1,NULL,0,1,0,0,NULL,'root',NULL,NULL),
	('INV','Invalidated','TM','US',0,1,NULL,0,0,0,1,NULL,'root','2014-11-14 15:05:44','root'),
	('LAP','Lapsed',NULL,NULL,0,1,NULL,0,1,0,1,NULL,'root','2011-03-16 11:42:48',NULL),
	('NPH','National Phase','PAT','WO',1,0,NULL,0,1,1,0,NULL,'root','2012-09-18 15:14:14','root'),
	('OPP','Opposition',NULL,'EP',0,1,NULL,0,0,0,0,NULL,'root','2011-03-23 08:32:55','root@localhost'),
	('OPR','Oral Proceedings','PAT','EP',1,0,NULL,1,0,0,0,NULL,'root','2014-05-07 09:10:37','root'),
	('ORE','Opposition rejected','PAT','EP',0,1,NULL,0,0,0,0,NULL,'root','2015-01-09 10:02:05',NULL),
	('PAY','Pay',NULL,NULL,1,0,NULL,0,0,0,0,'Use for any fees to be paid','root','2011-04-07 08:18:59','root@localhost'),
	('PDES','Post designation','TM','WO',0,1,NULL,0,0,0,0,NULL,'root','2014-07-01 14:48:03',NULL),
	('PFIL','Parent Filed','PAT',NULL,0,1,NULL,0,1,0,0,'Filing date of the parent (use only when the matter type is defined). Use as link to the parent matter.','root','2011-06-07 10:53:24','root@localhost'),
	('PR','Publication of Reg.','TM',NULL,0,1,NULL,0,0,0,0,NULL,'root','2012-06-20 16:03:41','root'),
	('PREP','Prepare',NULL,NULL,1,0,NULL,1,0,0,0,'Any further action to be done by the responsible (comments, pre-handling, ...)','root','2017-05-22 12:04:24','root'),
	('PRI','Priority Claim',NULL,NULL,0,1,NULL,0,0,0,0,'Use as link to the priority matter','root','2011-06-07 10:54:06','root@localhost'),
	('PRID','Priority Deadline',NULL,NULL,1,0,NULL,0,1,0,0,NULL,'root','2011-11-23 19:38:13','root'),
	('PROD','Produce',NULL,NULL,1,0,NULL,0,0,0,0,'Any further documents to be filed (inventor designation, priority document, missing parts...)','root','2017-04-25 15:07:37','root'),
	('PSR','Publication of SR','PAT','EP',0,0,NULL,0,1,0,0,'A3 publication','root','2012-04-24 15:17:31','root'),
	('PUB','Published',NULL,NULL,0,1,NULL,0,0,0,0,'For EP, this means publication WITH the search report (A1 publ.)','root','2011-03-20 17:09:08','root@localhost'),
	('RCE','Request Continued Examination','PAT','US',0,1,NULL,0,0,0,0,NULL,'root',NULL,NULL),
	('REC','Received',NULL,NULL,0,1,NULL,0,1,0,0,'Date the case was received from the client','root','2013-06-20 17:36:35','root'),
	('REF','Refused',NULL,NULL,0,1,NULL,0,0,0,0,'This is the final decision, that can only be appealed - do not mistake with an exam report','root','2013-09-19 12:27:58','root'),
	('REG','Registration','TM',NULL,0,1,NULL,0,0,0,0,NULL,'root','2012-06-19 11:54:42',NULL),
	('REM','Reminder',NULL,NULL,1,0,NULL,0,0,0,0,NULL,'root','2011-05-09 19:11:17',NULL),
	('REN','Renewal',NULL,NULL,1,0,NULL,0,0,1,0,'AKA Annuity','root','2017-12-03 15:23:46','root'),
	('REP','Respond',NULL,NULL,1,0,NULL,1,0,0,0,'Use for any response','root','2011-09-22 13:40:57','root'),
	('REQ','Request Examination',NULL,NULL,1,0,NULL,0,1,0,0,NULL,'root',NULL,NULL),
	('RSTR','Restriction Req.','PAT','US',0,0,NULL,0,0,0,0,NULL,'root','2011-11-03 16:53:39','root'),
	('SOL','Sold',NULL,NULL,0,1,NULL,0,0,0,1,NULL,'root','2014-01-24 15:38:50','root'),
	('SOP','Summons to Oral Proc.',NULL,NULL,0,0,NULL,0,0,0,0,NULL,'root','2017-05-24 11:54:03','root'),
	('SR','Search Report',NULL,NULL,0,0,NULL,0,0,0,0,NULL,'root',NULL,NULL),
	('SUS','Suspended',NULL,NULL,0,1,NULL,0,0,0,0,NULL,'root','2017-05-22 12:05:12','root'),
	('TRF','Transferred',NULL,NULL,0,1,NULL,0,1,0,1,'Case no longer followed','root','2011-03-20 18:09:21','root@localhost'),
	('VAL','Validate','PAT','EP',1,0,NULL,0,1,0,0,'Validate granted EP in designated countries','root','2011-03-22 11:22:17','root@localhost'),
	('WAT','Watch',NULL,NULL,1,0,NULL,1,0,0,0,NULL,'root','2012-08-09 12:18:53','root'),
	('WIT','Withdrawal','PAT',NULL,0,1,NULL,0,0,0,1,NULL,'root','2012-08-09 12:24:10','root');

/*!40000 ALTER TABLE `event_name` ENABLE KEYS */;
UNLOCK TABLES;


# Affichage de la table matter
# ------------------------------------------------------------

LOCK TABLES `matter` WRITE;
/*!40000 ALTER TABLE `matter` DISABLE KEYS */;

INSERT INTO `matter` (`ID`, `category_code`, `caseref`, `country`, `origin`, `type_code`, `idx`, `parent_ID`, `container_ID`, `responsible`, `dead`, `notes`, `expire_date`, `term_adjust`, `creator`, `updated`, `updater`)
VALUES
	(4,'PRO','TEST001','US',NULL,NULL,NULL,NULL,NULL,'phpipuser',0,NULL,'2015-04-04',0,'phpipuser','2017-12-04 18:30:26','root'),
	(5,'PAT','TEST001','WO',NULL,NULL,NULL,NULL,4,'phpipuser',1,NULL,'2016-11-04',0,'phpipuser','2017-12-04 18:30:26','root'),
	(6,'PAT','TEST001','CN','WO',NULL,NULL,5,4,'phpipuser',0,NULL,'2035-03-19',0,'phpipuser','2017-12-04 18:30:26','root'),
	(7,'PAT','TEST001','EP','WO',NULL,NULL,5,4,'phpipuser',0,NULL,'2035-03-19',0,'phpipuser','2017-12-04 18:30:26','root'),
	(8,'PAT','TEST001','JP','WO',NULL,NULL,5,4,'phpipuser',0,NULL,'2035-03-19',0,'phpipuser','2017-12-04 18:30:26','root'),
	(9,'PAT','TEST001','KR','WO',NULL,NULL,5,4,'phpipuser',0,NULL,'2035-03-19',0,'phpipuser','2017-12-04 18:30:26','root'),
	(10,'PAT','TEST001','US','WO',NULL,NULL,5,4,'phpipuser',0,NULL,'2035-03-19',0,'phpipuser','2017-12-04 18:30:26','root');

/*!40000 ALTER TABLE `matter` ENABLE KEYS */;
UNLOCK TABLES;


# Affichage de la table matter_actor_lnk
# ------------------------------------------------------------

LOCK TABLES `matter_actor_lnk` WRITE;
/*!40000 ALTER TABLE `matter_actor_lnk` DISABLE KEYS */;

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

/*!40000 ALTER TABLE `matter_actor_lnk` ENABLE KEYS */;
UNLOCK TABLES;


# Affichage de la table matter_category
# ------------------------------------------------------------

LOCK TABLES `matter_category` WRITE;
/*!40000 ALTER TABLE `matter_category` DISABLE KEYS */;

INSERT INTO `matter_category` (`code`, `ref_prefix`, `category`, `display_with`, `creator`, `updated`, `updater`)
VALUES
	('AGR',NULL,'Agreement','OTH','root','2011-09-27 17:52:36','root'),
	('DSG','DSG','Design','TM','root','2017-12-03 15:52:22','root'),
	('FTO',NULL,'Freedom to Operate','LTG','root','2014-10-14 10:06:33',NULL),
	('IN',NULL,'Register Change','OTH','root','2011-09-27 17:52:04','root'),
	('ISS','300','Issue','LTG','root','2011-10-20 18:15:34',NULL),
	('LTG','300','Litigation','LTG','root','2011-10-13 18:18:28','root'),
	('OP','300','Opposition (patent)','LTG','root','2016-11-15 14:10:12','root'),
	('OPI','OPI','Opinion','LTG','root','2017-12-03 15:52:08','root'),
	('OTH','300','Others','OTH','root','2011-10-13 18:18:36','root'),
	('PAT','PAT','Patent','PAT','root','2017-12-03 15:51:38','root'),
	('PRO','PAT','Provisional Application','PAT','root','2017-12-03 15:51:44','root'),
	('SL',NULL,'Commercial Slogan','TM','root','2012-06-17 01:56:19',NULL),
	('SO',NULL,'Soleau Envelop','PAT','root','2011-09-27 17:26:20','root'),
	('SR','300','Search','LTG','root','2011-10-20 18:28:52',NULL),
	('TM','TM','Trade Mark','TM','root','2017-12-03 15:51:50','root'),
	('TMOP','400','Opposition (TM)','TM','root','2012-06-18 15:12:55','root'),
	('TR','300','Transfer','OTH','root','2012-07-13 16:13:02',NULL),
	('TS','TS-','Trade Secret','PAT','root','2012-01-22 18:34:19','root'),
	('UC','100','Utility Certificate','PAT','root','2011-10-13 18:18:58','root'),
	('UM',NULL,'Utility Model','PAT','root','2011-11-23 15:47:55',NULL),
	('WAT','500','Watch','TM','root','2012-06-21 23:10:44','root');

/*!40000 ALTER TABLE `matter_category` ENABLE KEYS */;
UNLOCK TABLES;


# Affichage de la table matter_type
# ------------------------------------------------------------

LOCK TABLES `matter_type` WRITE;
/*!40000 ALTER TABLE `matter_type` DISABLE KEYS */;

INSERT INTO `matter_type` (`code`, `type`, `creator`, `updated`, `updater`)
VALUES
	('CIP','Continuation in Part','root','0000-00-00 00:00:00','root'),
	('CNT','Continuation','root','0000-00-00 00:00:00','root'),
	('DIV','Divisional','root','0000-00-00 00:00:00','root'),
	('REI','Reissue','root','0000-00-00 00:00:00','root'),
	('REX','Re-examination','root','2016-01-30 12:40:39','root');

/*!40000 ALTER TABLE `matter_type` ENABLE KEYS */;
UNLOCK TABLES;


# Affichage de la table task
# ------------------------------------------------------------

LOCK TABLES `task` WRITE;
/*!40000 ALTER TABLE `task` DISABLE KEYS */;

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

/*!40000 ALTER TABLE `task` ENABLE KEYS */;
UNLOCK TABLES;


# Affichage de la table task_rules
# ------------------------------------------------------------

LOCK TABLES `task_rules` WRITE;
/*!40000 ALTER TABLE `task_rules` DISABLE KEYS */;

INSERT INTO `task_rules` (`ID`, `active`, `task`, `trigger_event`, `clear_task`, `delete_task`, `for_category`, `for_country`, `for_origin`, `for_type`, `detail`, `days`, `months`, `years`, `recurring`, `end_of_month`, `abort_on`, `condition_event`, `use_parent`, `use_priority`, `use_before`, `use_after`, `cost`, `fee`, `currency`, `responsible`, `notes`, `creator`, `updated`, `updater`)
VALUES
	(1,1,'PRID','FIL',0,0,'PAT',NULL,NULL,NULL,NULL,0,12,0,0,0,'PRI',NULL,1,1,NULL,NULL,NULL,NULL,NULL,NULL,'Priority deadline is inserted only if no priority event exists','root','2017-05-24 15:26:40','root'),
	(2,1,'PRID','FIL',0,0,'TM',NULL,NULL,NULL,NULL,0,6,0,0,0,'PRI',NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,'Priority deadline is inserted only if no priority event exists','root','2011-11-04 09:03:27','root'),
	(3,1,'FBY','FIL',1,0,'PAT',NULL,NULL,NULL,NULL,0,0,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,'Clear \"File by\" task when \"Filed\" event is created','root','2011-11-04 08:23:08','root'),
	(4,1,'PRID','FIL',0,0,'PRO',NULL,NULL,NULL,NULL,0,12,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'root','2011-09-02 16:13:42','root'),
	(5,1,'DBY','DRA',1,0,'PAT',NULL,NULL,NULL,NULL,0,0,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,'Clear \"Draft by\" task when \"Drafted\" event is created','root','2011-11-04 08:23:01','root'),
	(6,1,'REQ','FIL',0,0,'PAT','JP',NULL,NULL,NULL,0,0,3,0,0,'EXA',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2011-09-02 16:13:42','root'),
	(7,1,'REQ','PUB',0,0,'PAT','EP',NULL,NULL,NULL,0,6,0,0,0,'EXA',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2011-09-02 16:13:42','root'),
	(8,1,'EXP','FIL',0,0,'PRO',NULL,NULL,NULL,NULL,0,12,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2011-09-02 16:13:42','root'),
	(9,1,'REP','SR',0,0,'PAT','FR',NULL,NULL,'Search Report',0,3,0,0,0,'GRT',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(10,1,'REP','EXA',0,0,'PAT','US',NULL,NULL,'Exam Report',0,3,0,0,0,'GRT',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2012-10-05 15:26:12','root'),
	(11,1,'REP','EXA',0,0,'PAT','EP',NULL,NULL,'Exam Report',0,4,0,0,0,'GRT',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(12,1,'EXP','FIL',0,0,'PAT',NULL,NULL,NULL,NULL,0,0,20,0,0,NULL,NULL,1,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(13,1,'REP','ALL',0,0,'PAT','EP',NULL,NULL,'R71(3)',0,4,0,0,0,'GRT',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2011-12-05 14:07:47','root'),
	(14,1,'PAY','ALL',0,0,'PAT','EP',NULL,NULL,'Grant Fee',0,4,0,0,0,'GRT',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-02-28 17:15:55','root'),
	(15,1,'PROD','ALL',0,0,'PAT','EP',NULL,NULL,'Claim Translation',0,4,0,0,0,'GRT',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(16,1,'VAL','GRT',0,0,'PAT','EP',NULL,NULL,'Translate where necessary',0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2011-12-05 16:58:17','root'),
	(18,1,'REP','PUB',0,0,'PAT','EP',NULL,NULL,'Written Opinion',0,6,0,0,0,'EXA',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(19,1,'PAY','PUB',0,0,'PAT','EP',NULL,NULL,'Designation Fees',0,6,0,0,0,'EXA',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(20,1,'PROD','PRI',0,0,'PAT','US',NULL,NULL,'Decl. and Assignment',0,12,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2011-12-05 14:08:15','root'),
	(21,1,'FBY','PRI',0,0,'PAT',NULL,NULL,NULL,'Priority Deadline',0,12,0,0,0,'FIL',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2011-11-10 11:22:11','root'),
	(22,1,'NPH','FIL',0,0,'PAT','WO',NULL,NULL,NULL,0,30,0,0,0,NULL,NULL,0,1,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2011-09-02 16:13:42','root'),
	(23,1,'REQ','FIL',0,0,'PAT','WO',NULL,NULL,NULL,0,22,0,0,0,'EXA',NULL,0,1,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2015-12-17 11:54:10','root'),
	(24,1,'DBY','REC',0,0,'PAT',NULL,NULL,NULL,NULL,0,2,0,0,0,'PRI',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2011-10-21 09:33:15','root'),
	(25,1,'PRID','PRI',0,1,'PAT',NULL,NULL,NULL,NULL,0,0,0,0,0,NULL,'FIL',0,0,NULL,NULL,NULL,NULL,'EUR',NULL,'Deletes priority deadline when a priority event is inserted','root','2011-11-04 09:03:27','root'),
	(26,1,'EHK','PUB',0,0,'PAT','CN',NULL,NULL,NULL,0,6,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2011-09-02 16:13:42','root'),
	(27,1,'FOP','GRT',0,0,'OP','EP',NULL,NULL,NULL,0,9,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2016-11-15 14:24:01','root'),
	(29,1,'DBY','FIL',1,0,'PAT',NULL,NULL,NULL,NULL,0,0,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2011-09-02 16:13:42','root'),
	(30,1,'PROD','FIL',0,0,'PAT','US',NULL,NULL,'IDS',0,2,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(32,1,'REP','EXA',0,0,'PAT','WO',NULL,NULL,NULL,0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2011-09-02 16:13:42','root'),
	(33,1,'EXP','FIL',0,0,'PAT','WO',NULL,NULL,NULL,0,31,0,0,0,NULL,NULL,0,1,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2011-09-02 16:13:42','root'),
	(34,1,'REM','FIL',0,0,'PAT','WO',NULL,NULL,'National Phase',0,27,0,0,0,NULL,NULL,0,1,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(35,1,'PROD','FIL',0,0,'PAT','FR',NULL,NULL,'Small Entity',0,1,0,0,0,'PRI',NULL,1,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2011-10-05 21:56:19','root'),
	(36,1,'PAY','GRT',0,0,'PAT','CN',NULL,NULL,'HK Grant Fee',0,6,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(37,1,'REP','COM',0,0,'PAT',NULL,NULL,NULL,'Communication',0,2,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2013-06-19 12:06:23','root'),
	(38,1,'FOP','OPP',1,0,'OP','EP',NULL,NULL,NULL,0,0,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,'Clear \"File Opposition\" task when \"Opposition\" event is created','root','2016-11-15 14:24:01','root'),
	(39,1,'PAY','ALL',0,0,'PAT','JP',NULL,NULL,'Grant Fee',0,1,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-02-28 17:16:00','root'),
	(40,1,'FPR','DW',0,0,'PAT','EP',NULL,NULL,NULL,0,2,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2011-10-10 00:41:20','root'),
	(41,1,'REP','PSR',0,0,'PAT','EP',NULL,NULL,'R70(2)',0,6,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2013-01-11 15:54:08','root'),
	(42,1,'NPH','PRI',0,0,'PAT',NULL,'WO',NULL,NULL,0,30,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(43,1,'PAY','FIL',0,0,'PAT','FR',NULL,NULL,'Filing Fee',0,1,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(44,1,'PAY','FIL',0,0,'PAT','EP',NULL,NULL,'Filing Fee',0,1,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(45,1,'VAL','GRT',0,0,'PAT',NULL,'EP',NULL,NULL,0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(46,1,'REP','RSTR',0,0,'PAT','US',NULL,NULL,'Restriction Req.',0,1,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(47,1,'REP','COM',0,0,'PAT','EP',NULL,NULL,'R161',0,6,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2011-10-19 10:23:13','root'),
	(48,1,'FAP','REF',0,0,'PAT',NULL,NULL,NULL,NULL,0,2,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-05-24 10:35:27','root'),
	(49,1,'PROD','APL',0,0,'PAT',NULL,NULL,NULL,'Appeal Brief',0,2,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-02-28 17:13:16','root'),
	(52,1,'REP','COM',0,0,'OP','EP',NULL,NULL,'Observations',0,4,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2016-11-15 14:24:01','root'),
	(53,1,'REQ','FIL',0,0,'PAT','KR',NULL,NULL,NULL,0,0,3,0,0,'EXA',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-02-28 14:07:32','root'),
	(54,1,'REQ','FIL',0,0,'PAT','CA',NULL,NULL,NULL,0,0,5,0,0,'EXA',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2015-12-17 11:54:11','root'),
	(55,1,'REQ','FIL',0,0,'PAT','CN',NULL,NULL,NULL,0,0,3,0,0,'EXA',NULL,0,1,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2015-12-17 11:54:11','root'),
	(56,1,'PAY','ALL',0,0,'PAT','CA',NULL,NULL,'Grant Fee',0,6,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-02-28 17:14:43','root'),
	(57,1,'PROD','PRI',0,0,'PAT',NULL,NULL,NULL,'Priority Docs',0,16,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2011-12-13 14:38:12','root'),
	(58,1,'PAY','FIL',0,0,'PAT','WO',NULL,NULL,'Filing Fee',0,1,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-02-28 17:16:26','root'),
	(60,1,'REM','ALL',0,0,'PAT','US',NULL,NULL,'File divisional',0,1,0,0,0,NULL,'RSTR',0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(61,1,'REP','EXA',0,0,'PAT','CN',NULL,NULL,'Exam Report',0,4,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2016-04-18 17:17:15','root'),
	(62,1,'REP','EXA',0,0,'PAT','CA',NULL,NULL,'Exam Report',0,6,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2012-01-19 10:51:51','root'),
	(63,1,'REM','SR',0,0,'PAT','FR',NULL,NULL,'Request extension',0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2012-01-19 10:52:04','root'),
	(64,1,'REM','EXA',0,0,'PAT','EP',NULL,NULL,'Request extension',0,4,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2012-01-19 10:52:16','root'),
	(65,1,'FBY','REC',0,0,'PAT',NULL,NULL,NULL,NULL,0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2012-01-19 10:52:27','root'),
	(66,1,'PAY','ALL',0,0,'PAT','FR',NULL,NULL,'Grant Fee',0,2,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-02-28 17:15:00','root'),
	(67,1,'REQ','PSR',0,0,'PAT','EP',NULL,NULL,NULL,0,6,0,0,0,'EXA',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2012-04-24 15:37:41','root'),
	(68,1,'PAY','PSR',0,0,'PAT','EP',NULL,NULL,'Designation Fees',0,6,0,0,0,'EXA',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2012-04-24 15:37:49','root'),
	(69,1,'REP','PSR',0,0,'PAT','EP',NULL,NULL,'Written Opinion',0,6,0,0,0,'EXA',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(70,1,'REQ','PRI',0,0,'PAT','IN',NULL,NULL,NULL,0,48,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2012-06-30 18:54:01','root'),
	(102,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'2',0,0,1,0,1,NULL,NULL,1,0,NULL,NULL,38.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(103,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'3',0,0,2,0,1,NULL,NULL,1,0,NULL,NULL,38.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(104,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'4',0,0,3,0,1,NULL,NULL,1,0,NULL,NULL,38.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(105,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'5',0,0,4,0,1,NULL,NULL,1,0,NULL,NULL,38.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(106,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'6',0,0,5,0,1,NULL,NULL,1,0,NULL,NULL,76.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(107,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'7',0,0,6,0,1,NULL,NULL,1,0,NULL,NULL,96.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(108,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'8',0,0,7,0,1,NULL,NULL,1,0,NULL,NULL,136.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(109,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'9',0,0,8,0,1,NULL,NULL,1,0,NULL,NULL,180.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(110,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'10',0,0,9,0,1,NULL,NULL,1,0,NULL,NULL,220.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(111,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'11',0,0,10,0,1,NULL,NULL,1,0,NULL,NULL,260.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(112,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'12',0,0,11,0,1,NULL,NULL,1,0,NULL,NULL,300.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(113,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'13',0,0,12,0,1,NULL,NULL,1,0,NULL,NULL,350.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(114,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'14',0,0,13,0,1,NULL,NULL,1,0,NULL,NULL,400.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(115,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'15',0,0,14,0,1,NULL,NULL,1,0,NULL,NULL,450.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(116,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'16',0,0,15,0,1,NULL,NULL,1,0,NULL,NULL,510.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(117,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'17',0,0,16,0,1,NULL,NULL,1,0,NULL,NULL,570.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(118,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'18',0,0,17,0,1,NULL,NULL,1,0,NULL,NULL,640.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(119,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'19',0,0,18,0,1,NULL,NULL,1,0,NULL,NULL,720.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(120,1,'REN','FIL',0,0,'PAT','FR',NULL,NULL,'20',0,0,19,0,1,NULL,NULL,1,0,NULL,NULL,790.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(203,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'3',0,0,2,0,1,NULL,NULL,1,0,NULL,NULL,465.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(204,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'4',0,0,3,0,1,NULL,NULL,1,0,NULL,NULL,580.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(205,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'5',0,0,4,0,1,NULL,NULL,1,0,NULL,NULL,810.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(206,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'6',0,0,5,0,1,NULL,NULL,1,0,NULL,NULL,1040.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(207,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'7',0,0,6,0,1,NULL,NULL,1,0,NULL,NULL,1155.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(208,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'8',0,0,7,0,1,NULL,NULL,1,0,NULL,NULL,1265.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(209,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'9',0,0,8,0,1,NULL,NULL,1,0,NULL,NULL,1380.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(210,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'10',0,0,9,0,1,NULL,NULL,1,0,NULL,NULL,1560.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(211,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'11',0,0,10,0,1,NULL,NULL,1,0,NULL,NULL,1560.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(212,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'12',0,0,11,0,1,NULL,NULL,1,0,NULL,NULL,1560.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(213,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'13',0,0,12,0,1,NULL,NULL,1,0,NULL,NULL,1560.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(214,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'14',0,0,13,0,1,NULL,NULL,1,0,NULL,NULL,1560.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(215,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'15',0,0,14,0,1,NULL,NULL,1,0,NULL,NULL,1560.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(216,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'16',0,0,15,0,1,NULL,NULL,1,0,NULL,NULL,1560.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(217,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'17',0,0,16,0,1,NULL,NULL,1,0,NULL,NULL,1560.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(218,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'18',0,0,17,0,1,NULL,NULL,1,0,NULL,NULL,1560.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(219,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'19',0,0,18,0,1,NULL,NULL,1,0,NULL,NULL,1560.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(220,1,'REN','FIL',0,0,'PAT','EP',NULL,NULL,'20',0,0,19,0,1,NULL,NULL,1,0,NULL,NULL,1560.00,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(234,1,'PAY','ALL',0,0,'PAT','CN',NULL,NULL,'Grant Fee',76,0,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-02-28 17:15:41','root'),
	(235,1,'REP','SR',0,0,'PAT','WO',NULL,NULL,'Written Opinion',0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2013-03-07 17:32:14','root'),
	(236,1,'PAY','ALL',0,0,'PAT','US',NULL,NULL,'Grant Fee',0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-02-28 17:15:48','root'),
	(237,1,'PROD','GRT',0,0,'PAT','IN',NULL,NULL,'Working Report',0,2,0,0,1,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,'Change date to end of March','root','2017-12-03 15:50:17','root'),
	(238,1,'WAT','PUB',0,0,'TM','FR',NULL,NULL,'Opposition deadline',0,2,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(239,1,'WAT','PUB',0,0,'TM','EM',NULL,NULL,'Opposition deadline',0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(240,1,'WAT','PUB',0,0,'TM','US',NULL,NULL,'Opposition deadline',30,0,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(242,1,'PROD','REG',0,0,'TM','US',NULL,NULL,'Declaration of use',0,66,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,'délai à 5 ans et demi','root','2013-10-15 13:01:57','root'),
	(1001,1,'REN','FIL',0,0,'TM',NULL,NULL,NULL,'10',0,0,10,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1002,1,'REN','FIL',0,0,'TM',NULL,NULL,NULL,'20',0,0,20,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1003,1,'REN','FIL',0,0,'TM',NULL,NULL,NULL,'30',0,0,30,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1004,1,'REN','FIL',0,0,'TM',NULL,NULL,NULL,'40',0,0,40,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1005,1,'REN','FIL',0,0,'TM',NULL,NULL,NULL,'50',0,0,50,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1011,1,'REN','REG',0,0,'TM','CA',NULL,NULL,'15',0,0,15,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1012,1,'REN','REG',0,0,'TM','CA',NULL,NULL,'30',0,0,30,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1013,1,'REN','REG',0,0,'TM','CA',NULL,NULL,'45',0,0,45,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1081,1,'REN','REG',0,0,'TM','US',NULL,NULL,'10',0,0,10,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1082,1,'REN','REG',0,0,'TM','US',NULL,NULL,'20',0,0,20,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1083,1,'REN','REG',0,0,'TM','US',NULL,NULL,'30',0,0,30,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1084,1,'REN','REG',0,0,'TM','US',NULL,NULL,'40',0,0,40,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1085,1,'REN','REG',0,0,'TM','US',NULL,NULL,'50',0,0,50,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1091,1,'REN','REG',0,0,'TM','JP',NULL,NULL,'10',0,0,10,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1092,1,'REN','REG',0,0,'TM','JP',NULL,NULL,'20',0,0,20,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1093,1,'REN','REG',0,0,'TM','JP',NULL,NULL,'30',0,0,30,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1094,1,'REN','REG',0,0,'TM','JP',NULL,NULL,'40',0,0,40,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1101,1,'REN','REG',0,0,'TM','KR',NULL,NULL,'10',0,0,10,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1102,1,'REN','REG',0,0,'TM','KR',NULL,NULL,'20',0,0,20,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1103,1,'REN','REG',0,0,'TM','KR',NULL,NULL,'30',0,0,30,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1104,1,'REN','REG',0,0,'TM','KR',NULL,NULL,'40',0,0,40,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1121,1,'REN','REG',0,0,'TM','BR',NULL,NULL,'10',0,0,10,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1122,1,'REN','REG',0,0,'TM','BR',NULL,NULL,'20',0,0,20,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1123,1,'REN','REG',0,0,'TM','BR',NULL,NULL,'30',0,0,30,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1124,1,'REN','REG',0,0,'TM','BR',NULL,NULL,'40',0,0,40,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1131,1,'REN','REG',0,0,'TM','CN',NULL,NULL,'10',0,0,10,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1132,1,'REN','REG',0,0,'TM','CN',NULL,NULL,'20',0,0,20,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1133,1,'REN','REG',0,0,'TM','CN',NULL,NULL,'30',0,0,30,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1134,1,'REN','REG',0,0,'TM','CN',NULL,NULL,'40',0,0,40,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1181,1,'PROD','FIL',0,0,'PAT','IN',NULL,NULL,'Annexure to Form 3',0,0,2,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2013-10-29 16:06:33','root'),
	(1182,1,'PROD','FIL',0,0,'PAT','IN',NULL,NULL,'Declaration',0,0,2,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2016-10-25 15:40:06','root'),
	(1183,1,'PROD','FIL',0,0,'PAT','IN',NULL,NULL,'Power',0,0,2,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2013-10-29 16:06:45','root'),
	(1184,1,'PAY','ALL',0,0,'PAT','KR',NULL,NULL,'Grant Fee',0,3,0,0,0,'GRT',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-02-28 17:16:08','root'),
	(1185,1,'PAY','ALL',0,0,'PAT','TW',NULL,NULL,'Grant Fee',0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-02-28 17:15:12','root'),
	(1186,1,'REP','EXA',0,0,'PAT','AU',NULL,NULL,'Exam Report',0,12,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2013-02-20 10:07:08','root'),
	(1187,1,'REP','EXA',0,0,'PAT','IN',NULL,NULL,'Exam Report',0,6,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(1188,1,'REP','EXA',0,0,'PAT','KR',NULL,NULL,'Exam Report',0,2,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(1189,1,'REN','FIL',0,0,'DSG','FR',NULL,NULL,'1',0,0,5,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2013-05-16 15:19:27','root'),
	(1190,1,'REN','FIL',0,0,'DSG','FR',NULL,NULL,'2',0,0,10,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2013-05-16 15:19:28','root'),
	(1191,1,'REN','FIL',0,0,'DSG','FR',NULL,NULL,'3',0,0,15,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2013-05-16 15:19:29','root'),
	(1192,1,'REN','FIL',0,0,'DSG','FR',NULL,NULL,'4',0,0,20,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2013-05-16 15:19:30','root'),
	(1193,1,'REN','FIL',0,0,'DSG','FR',NULL,NULL,'5',0,0,25,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2013-05-16 15:19:31','root'),
	(1194,1,'REN','FIL',0,0,'DSG','EM',NULL,NULL,'1',0,0,5,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2013-05-16 15:19:32','root'),
	(1195,1,'REN','FIL',0,0,'DSG','EM',NULL,NULL,'2',0,0,10,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2013-05-16 15:19:33','root'),
	(1196,1,'REN','FIL',0,0,'DSG','EM',NULL,NULL,'3',0,0,15,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2013-05-16 15:19:34','root'),
	(1197,1,'REN','FIL',0,0,'DSG','EM',NULL,NULL,'4',0,0,20,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2013-05-16 15:19:35','root'),
	(1198,1,'REN','FIL',0,0,'DSG','EM',NULL,NULL,'5',0,0,25,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2013-05-16 15:19:36','root'),
	(1211,1,'REN','REG',0,0,'TM','DK',NULL,NULL,'10',0,0,10,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1212,1,'REN','REG',0,0,'TM','DK',NULL,NULL,'20',0,0,20,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1213,1,'REN','REG',0,0,'TM','DK',NULL,NULL,'30',0,0,30,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1214,1,'REN','REG',0,0,'TM','DK',NULL,NULL,'40',0,0,40,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1215,1,'REN','REG',0,0,'TM','DK',NULL,NULL,'50',0,0,50,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1216,1,'REN','REG',0,0,'TM','NO',NULL,NULL,'10',0,0,10,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1217,1,'REN','REG',0,0,'TM','NO',NULL,NULL,'20',0,0,20,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1218,1,'REN','REG',0,0,'TM','NO',NULL,NULL,'30',0,0,30,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1219,1,'REN','REG',0,0,'TM','NO',NULL,NULL,'40',0,0,40,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1220,1,'REN','REG',0,0,'TM','NO',NULL,NULL,'50',0,0,50,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1221,1,'REN','REG',0,0,'TM','FI',NULL,NULL,'10',0,0,10,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1222,1,'REN','REG',0,0,'TM','FI',NULL,NULL,'20',0,0,20,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1223,1,'REN','REG',0,0,'TM','FI',NULL,NULL,'30',0,0,30,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1224,1,'REN','REG',0,0,'TM','FI',NULL,NULL,'40',0,0,40,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1225,1,'REN','REG',0,0,'TM','FI',NULL,NULL,'50',0,0,50,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1228,1,'REP','EXA',0,0,'PAT','TW',NULL,NULL,'Exam Report',0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2013-07-25 14:28:59','root'),
	(1230,1,'REN','PR',0,0,'TM','TW',NULL,NULL,'10',0,11,9,0,1,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1231,1,'REN','PR',0,0,'TM','TW',NULL,NULL,'20',0,11,19,0,1,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1232,1,'REN','PR',0,0,'TM','TW',NULL,NULL,'30',0,11,29,0,1,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1233,1,'REN','PR',0,0,'TM','TW',NULL,NULL,'40',0,11,39,0,1,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1234,1,'REN','PR',0,0,'TM','TW',NULL,NULL,'50',0,11,49,0,1,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1235,1,'REN','FIL',0,0,'TM','SA',NULL,NULL,'10',0,8,9,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,'10 ans Hegira','root','2017-12-03 12:40:07','root'),
	(1236,1,'REP','EXA',0,0,'PAT','JP',NULL,NULL,'Exam Report',0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2013-07-25 14:29:23','root'),
	(1237,1,'REP','EXA',0,0,'TM','US',NULL,NULL,'Exam Report',0,6,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(1238,1,'REP','EXA',0,0,'TM','KR',NULL,NULL,'Exam Report',0,2,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(1239,1,'REP','COM',0,0,'TM','EM',NULL,NULL,'Irregularity',0,2,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(1240,1,'REP','EXA',0,0,'TM','CN',NULL,NULL,'Exam Report',0,1,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(1241,1,'PAY','ALL',0,0,'TM','CA',NULL,NULL,'Grant Fee',0,6,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-02-28 17:15:30','root'),
	(1242,1,'PROD','ALL',0,0,'TM','CA',NULL,NULL,'Declaration of use',0,6,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2013-11-20 11:14:24','root'),
	(1243,1,'WAT','PUB',0,0,'TM','BR',NULL,NULL,'Opposition deadline',60,0,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(1244,1,'PROD','OPP',0,0,'TM','FR',NULL,NULL,'Observations',0,2,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(1245,1,'PROD','ALL',0,0,'TM','US',NULL,NULL,'Statement of use',0,6,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(1246,1,'REP','EXA',0,0,'TM','IL',NULL,NULL,'Exam Report',0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(1247,1,'PROD','EXA',0,0,'TM','US',NULL,NULL,'POA',0,6,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(1248,1,'PROD','EXA',0,0,'TM','KR',NULL,NULL,'POA',0,2,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(1249,1,'PROD','EXA',0,0,'TM','CN',NULL,NULL,'POA',0,1,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(1250,1,'PROD','EXA',0,0,'TM','IL',NULL,NULL,'POA',0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(1251,1,'PROD','REF',0,0,'TM',NULL,NULL,NULL,'Appeal Brief',45,0,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1252,1,'PROD','REF',0,0,'TM',NULL,NULL,NULL,'POA',45,0,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1253,1,'REP','EXA',0,0,'TM','CA',NULL,NULL,'Exam Report',0,6,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2013-09-20 13:10:30','root'),
	(1254,1,'REP','EXA',0,0,'TM','TH',NULL,NULL,'Exam Report',0,2,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2013-09-20 15:43:06','root'),
	(1258,1,'REP','EXAF',0,0,'PAT','US',NULL,NULL,'Final OA',0,2,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(1259,1,'PROD','REG',0,0,'TM','US',NULL,NULL,'Declaration of use',0,114,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,'délai à 9 ans et demi','root','2013-10-15 13:02:03','root'),
	(1260,1,'REP','COM',0,0,'TM','WO',NULL,NULL,'Irregularity',0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(1262,1,'PROD','APL',0,0,'TM','EM',NULL,NULL,'Appeal Brief',0,4,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(1263,1,'REN','PRI',0,0,'TM','NZ',NULL,NULL,'10',0,0,10,0,0,NULL,'ALL',0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1267,1,'REN','PRI',0,0,'TM','NZ',NULL,NULL,'20',0,0,20,0,0,NULL,'ALL',0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1268,1,'REN','PRI',0,0,'TM','NZ',NULL,NULL,'30',0,0,30,0,0,NULL,'ALL',0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1269,1,'REN','PRI',0,0,'TM','NZ',NULL,NULL,'40',0,0,40,0,0,NULL,'ALL',0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1270,1,'REN','PRI',0,0,'TM','NZ',NULL,NULL,'50',0,0,50,0,0,NULL,'ALL',0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1271,1,'REP','COM',0,0,'TM','FR',NULL,NULL,'Irregularity',0,1,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(1272,1,'REN','REG',0,0,'TM','LB',NULL,NULL,'15',0,0,15,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1273,1,'REN','PRI',0,0,'TM','RU',NULL,NULL,'10',0,0,10,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1274,1,'REN','PRI',0,0,'TM','RU',NULL,NULL,'20',0,0,20,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1275,1,'REN','PRI',0,0,'TM','RU',NULL,NULL,'30',0,0,30,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1277,1,'REN','PRI',0,0,'TM','RU',NULL,NULL,'40',0,0,40,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1278,1,'REN','PRI',0,0,'TM','RU',NULL,NULL,'50',0,0,50,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 12:40:07','root'),
	(1280,1,'PROD','SOP',0,0,'PAT','EP',NULL,NULL,'Observations',10,4,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-05-24 11:55:39','root'),
	(1281,1,'OPR','SOP',0,0,'PAT','EP',NULL,NULL,NULL,10,5,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2014-05-07 09:10:52','root'),
	(1282,1,'PAY','ALL',0,0,'TM','JP',NULL,NULL,'2nd part of individual fee',0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2014-11-05 17:13:42','root'),
	(1290,1,'REN','FIL',0,0,'SO','FR',NULL,NULL,'Soleau',0,0,5,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(1291,1,'WAT','FIL',0,0,'SO','FR',NULL,NULL,'End of protection',0,114,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2014-09-10 10:14:53','root'),
	(1292,1,'EXP','FIL',0,0,'SO','FR',NULL,NULL,NULL,0,0,10,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(1299,1,'OPR','SOP',0,0,'OP',NULL,NULL,NULL,NULL,0,6,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2016-11-15 14:24:01','root'),
	(1300,1,'PROD','SOP',0,0,'OP',NULL,NULL,NULL,'Observations',0,4,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2016-11-15 14:24:01','root'),
	(1301,1,'PROD','PRI',0,0,'PAT','US','WO',NULL,'Decl. and Assignment',0,30,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2014-11-14 14:00:44','root'),
	(1302,1,'REQ','FIL',0,0,'PAT','BR',NULL,NULL,NULL,0,0,3,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(1303,1,'FAP','ORE',0,0,'OP','EP',NULL,NULL,NULL,0,2,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-05-24 11:20:47','root'),
	(1305,1,'PRID','FIL',0,0,'DSG',NULL,NULL,NULL,NULL,0,6,0,0,0,'PRI',NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,'Priority deadline is inserted only if no priority event exists','root','2017-12-03 15:50:17','root'),
	(1306,1,'PRID','PRI',0,1,'DSG',NULL,NULL,NULL,NULL,0,0,0,0,0,NULL,'FIL',0,0,NULL,NULL,NULL,NULL,'EUR',NULL,'Deletes priority deadline when a priority event is inserted','root','2017-12-03 15:50:17','root'),
	(1307,1,'PRID','PRI',0,1,'TM',NULL,NULL,NULL,NULL,0,0,0,0,0,NULL,'FIL',0,0,NULL,NULL,NULL,NULL,'EUR',NULL,'Deletes priority deadline when a priority event is inserted','root','2017-12-03 15:50:17','root'),
	(1308,1,'REN','FIL',0,0,'DSG','WO',NULL,NULL,'1',0,0,5,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2015-12-17 14:35:47','root'),
	(1309,1,'REN','FIL',0,0,'DSG','WO',NULL,NULL,'2',0,0,10,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2015-12-17 14:36:12','root'),
	(1310,1,'PROD','REC',0,0,'OPI',NULL,NULL,NULL,'Opinion',0,1,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2016-02-26 15:26:26','root'),
	(1311,1,'PROD','REC',0,0,'SR',NULL,NULL,NULL,'Report',0,1,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2016-02-26 15:26:26','root'),
	(1314,1,'PROD','FIL',0,0,'PAT','IN',NULL,NULL,'Verification of translation',0,0,2,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(1315,1,'REP','EXA',0,0,'TM','JP',NULL,NULL,'Exam Report',0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2016-10-12 16:44:28','root'),
	(1316,1,'PROD','EXA',0,0,'TM','JP',NULL,NULL,'POA',0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2016-10-12 16:44:32','root'),
	(1317,1,'PROD','FIL',0,0,'PAT','IN','WO',NULL,'Verification of translation',0,0,2,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2016-10-25 15:42:13','root'),
	(1318,1,'PROD','FIL',0,0,'PAT','IN','WO',NULL,'Annexure to Form 3',0,0,2,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2016-10-25 15:42:42','root'),
	(1319,1,'PROD','FIL',0,0,'PAT','IN','WO',NULL,'Declaration',0,0,2,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2016-10-25 15:43:04','root'),
	(1320,1,'PROD','FIL',0,0,'PAT','IN','WO',NULL,'Power',0,0,2,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(1321,1,'PROD','SR',0,0,'PAT','EP',NULL,NULL,'Analysis of SR',0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(1322,1,'PROD','DPAPL',0,0,'PAT','US',NULL,NULL,'Appeal Brief',0,1,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(1323,1,'FRCE','EXAF',0,0,'PAT','US',NULL,NULL,NULL,0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(1326,1,'FAP','EXAF',0,0,'PAT','US',NULL,NULL,NULL,0,3,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(1327,1,'FAP','APL',1,0,'PAT',NULL,NULL,NULL,NULL,0,0,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(1328,1,'PROD','REC',0,0,'TM',NULL,NULL,NULL,'Analyse CompuMark',15,0,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(1329,1,'PROD','REC',0,0,'TM',NULL,NULL,NULL,'Libellé P/S',0,1,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-12-03 15:50:17','root'),
	(1330,1,'PROD','EXA',0,0,'PAT',NULL,NULL,NULL,'Preliminary Comments',40,0,0,0,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,'EUR',NULL,NULL,'root','2017-05-24 11:57:42','root');

/*!40000 ALTER TABLE `task_rules` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
