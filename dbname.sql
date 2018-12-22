-- MySQL dump 10.13  Distrib 5.5.61, for Linux (x86_64)
--
-- Host: aa13c32dnqsn5po.csgasqvoxops.ap-southeast-1.rds.amazonaws.com    Database: ebdb
-- ------------------------------------------------------
-- Server version	5.6.40-log

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
-- Table structure for table `admins`
--

DROP TABLE IF EXISTS `admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admins` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) DEFAULT NULL,
  `last_sign_in_ip` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `roles` text,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_admins_on_email` (`email`),
  UNIQUE KEY `index_admins_on_reset_password_token` (`reset_password_token`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admins`
--

LOCK TABLES `admins` WRITE;
/*!40000 ALTER TABLE `admins` DISABLE KEYS */;
INSERT INTO `admins` VALUES (1,'admin@safetrade.ai','$2a$10$19pMxxBvMY4KGFePBsAlXOdgWybLjlQfwqm3t6ufVBoh29c3xdqTy',NULL,NULL,NULL,28,'2018-12-10 13:12:07','2018-12-08 15:32:52','72.255.53.123','94.207.92.129','2018-11-27 19:24:25','2018-12-10 13:12:07',NULL,NULL);
/*!40000 ALTER TABLE `admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `app_versions`
--

DROP TABLE IF EXISTS `app_versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `app_versions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` varchar(255) DEFAULT NULL,
  `force_upgrade` tinyint(1) DEFAULT NULL,
  `recommend_upgrade` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app_versions`
--

LOCK TABLES `app_versions` WRITE;
/*!40000 ALTER TABLE `app_versions` DISABLE KEYS */;
/*!40000 ALTER TABLE `app_versions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ar_internal_metadata`
--

DROP TABLE IF EXISTS `ar_internal_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ar_internal_metadata` (
  `key` varchar(255) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ar_internal_metadata`
--

LOCK TABLES `ar_internal_metadata` WRITE;
/*!40000 ALTER TABLE `ar_internal_metadata` DISABLE KEYS */;
INSERT INTO `ar_internal_metadata` VALUES ('environment','production','2018-11-27 16:23:48','2018-11-27 16:23:48');
/*!40000 ALTER TABLE `ar_internal_metadata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auction_rounds`
--

DROP TABLE IF EXISTS `auction_rounds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auction_rounds` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `round_no` int(11) DEFAULT NULL,
  `min_bid` float DEFAULT NULL,
  `max_bid` float DEFAULT NULL,
  `auction_id` int(11) DEFAULT NULL,
  `started_at` datetime DEFAULT NULL,
  `completed` tinyint(1) DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auction_rounds`
--

LOCK TABLES `auction_rounds` WRITE;
/*!40000 ALTER TABLE `auction_rounds` DISABLE KEYS */;
/*!40000 ALTER TABLE `auction_rounds` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auctions`
--

DROP TABLE IF EXISTS `auctions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auctions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `min_bid` float DEFAULT NULL,
  `tender_id` int(11) DEFAULT NULL,
  `round_time` int(11) DEFAULT NULL,
  `started` tinyint(1) DEFAULT '0',
  `completed` tinyint(1) DEFAULT '0',
  `loosers_per_round` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `evaluating_round_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auctions`
--

LOCK TABLES `auctions` WRITE;
/*!40000 ALTER TABLE `auctions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auctions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bid_calculations`
--

DROP TABLE IF EXISTS `bid_calculations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bid_calculations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `stone_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `responce` tinyint(1) DEFAULT NULL,
  `round` int(11) DEFAULT NULL,
  `system_price` float DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bid_calculations`
--

LOCK TABLES `bid_calculations` WRITE;
/*!40000 ALTER TABLE `bid_calculations` DISABLE KEYS */;
/*!40000 ALTER TABLE `bid_calculations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bids`
--

DROP TABLE IF EXISTS `bids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bids` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `total` float DEFAULT NULL,
  `message` text,
  `bid_date` datetime DEFAULT NULL,
  `tender_id` bigint(20) DEFAULT NULL,
  `customer_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `no_of_parcels` int(11) DEFAULT NULL,
  `stone_id` int(11) DEFAULT NULL,
  `price_per_carat` float DEFAULT NULL,
  `auction_round_id` int(11) DEFAULT NULL,
  `sight_id` int(11) DEFAULT NULL,
  `percentage_over_cost` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_bids_on_tender_id` (`tender_id`),
  KEY `index_bids_on_customer_id` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bids`
--

LOCK TABLES `bids` WRITE;
/*!40000 ALTER TABLE `bids` DISABLE KEYS */;
/*!40000 ALTER TABLE `bids` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `block_users`
--

DROP TABLE IF EXISTS `block_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `block_users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) DEFAULT NULL,
  `block_company_ids` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `block_users`
--

LOCK TABLES `block_users` WRITE;
/*!40000 ALTER TABLE `block_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `block_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `broker_invites`
--

DROP TABLE IF EXISTS `broker_invites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `broker_invites` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `broker_invites`
--

LOCK TABLES `broker_invites` WRITE;
/*!40000 ALTER TABLE `broker_invites` DISABLE KEYS */;
/*!40000 ALTER TABLE `broker_invites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `broker_requests`
--

DROP TABLE IF EXISTS `broker_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `broker_requests` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `broker_id` int(11) DEFAULT NULL,
  `seller_id` int(11) DEFAULT NULL,
  `accepted` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `broker_requests`
--

LOCK TABLES `broker_requests` WRITE;
/*!40000 ALTER TABLE `broker_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `broker_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `buyer_scores`
--

DROP TABLE IF EXISTS `buyer_scores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `buyer_scores` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) DEFAULT NULL,
  `late_payment` float NOT NULL DEFAULT '0',
  `current_risk` float NOT NULL DEFAULT '0',
  `network_diversity` float NOT NULL DEFAULT '0',
  `buyer_network` float NOT NULL DEFAULT '0',
  `due_date` float NOT NULL DEFAULT '0',
  `credit_used` float NOT NULL DEFAULT '0',
  `count_of_credit_given` float NOT NULL DEFAULT '0',
  `total` float NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `actual` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_buyer_scores_on_company_id` (`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buyer_scores`
--

LOCK TABLES `buyer_scores` WRITE;
/*!40000 ALTER TABLE `buyer_scores` DISABLE KEYS */;
INSERT INTO `buyer_scores` VALUES (1,8,0,0,0,0,0,0,0,0,'2018-12-10 13:01:14','2018-12-10 13:01:14',1);
/*!40000 ALTER TABLE `buyer_scores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `companies`
--

DROP TABLE IF EXISTS `companies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `companies` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `county` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `is_anonymous` tinyint(1) DEFAULT '0',
  `add_polished` tinyint(1) DEFAULT '0',
  `is_broker` tinyint(1) DEFAULT '0',
  `email` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `companies`
--

LOCK TABLES `companies` WRITE;
/*!40000 ALTER TABLE `companies` DISABLE KEYS */;
INSERT INTO `companies` VALUES (1,'Buyer A',NULL,'India','2018-12-02 08:04:34','2018-12-02 08:04:34',0,0,0,NULL),(2,'Buyer B',NULL,'India','2018-12-02 08:04:34','2018-12-02 08:04:34',0,0,0,NULL),(3,'Buyer C',NULL,'India','2018-12-02 08:04:34','2018-12-02 08:04:34',0,0,0,NULL),(4,'Seller A',NULL,'India','2018-12-02 08:04:34','2018-12-02 08:04:34',0,0,0,NULL),(5,'Seller B',NULL,'India','2018-12-02 08:04:34','2018-12-02 08:04:34',0,0,0,NULL),(6,'Seller C',NULL,'India','2018-12-02 08:04:34','2018-12-02 08:04:34',0,0,0,NULL),(7,'Dummy Buyer 1','','India','2018-12-06 09:12:48','2018-12-06 09:12:48',0,0,0,NULL),(8,'Dummy Seller 1','','India','2018-12-06 09:12:54','2018-12-06 09:12:54',0,0,0,NULL),(9,'Dummy Seller 2','','India','2018-12-06 09:13:00','2018-12-06 09:13:00',0,0,0,NULL),(10,'Dummy Buyer 2','','India','2018-12-06 09:13:08','2018-12-06 09:13:18',0,0,0,NULL);
/*!40000 ALTER TABLE `companies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `companies_groups`
--

DROP TABLE IF EXISTS `companies_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `companies_groups` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_name` varchar(255) DEFAULT NULL,
  `seller_id` int(11) DEFAULT NULL,
  `company_id` text,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `group_market_limit` int(11) DEFAULT NULL,
  `group_overdue_limit` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `companies_groups`
--

LOCK TABLES `companies_groups` WRITE;
/*!40000 ALTER TABLE `companies_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `companies_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact_people`
--

DROP TABLE IF EXISTS `contact_people`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contact_people` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `designation` varchar(255) NOT NULL,
  `company_id` int(11) DEFAULT NULL,
  `telephone` varchar(255) DEFAULT NULL,
  `mobile` int(11) DEFAULT NULL,
  `passport_no` varchar(255) DEFAULT NULL,
  `pio_card` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact_people`
--

LOCK TABLES `contact_people` WRITE;
/*!40000 ALTER TABLE `contact_people` DISABLE KEYS */;
/*!40000 ALTER TABLE `contact_people` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `credit_limits`
--

DROP TABLE IF EXISTS `credit_limits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `credit_limits` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `seller_id` int(11) DEFAULT NULL,
  `buyer_id` int(11) DEFAULT NULL,
  `credit_limit` decimal(10,0) DEFAULT '0',
  `market_limit` decimal(10,0) DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `star` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `credit_limits`
--

LOCK TABLES `credit_limits` WRITE;
/*!40000 ALTER TABLE `credit_limits` DISABLE KEYS */;
INSERT INTO `credit_limits` VALUES (11,1,5,316,632,'2018-12-05 15:34:46','2018-12-05 15:34:46',0),(12,5,2,20000,1,'2018-12-05 18:35:49','2018-12-10 09:10:31',0),(13,6,6,19190,0,'2018-12-06 08:15:48','2018-12-06 08:15:48',0),(14,1,1,21600,0,'2018-12-06 08:25:39','2018-12-06 08:25:39',0),(15,7,8,3300,3300,'2018-12-06 16:27:27','2018-12-06 16:27:27',0),(16,8,7,15975,3098,'2018-12-06 17:34:50','2018-12-11 08:15:12',0),(17,7,10,3400,0,'2018-12-07 10:09:14','2018-12-07 10:09:14',0),(18,4,1,57000,0,'2018-12-07 11:51:22','2018-12-11 16:18:44',0),(19,4,3,50000,50000,'2018-12-07 12:04:47','2018-12-07 12:04:47',0),(20,5,3,180000,50000,'2018-12-07 12:31:48','2018-12-10 08:43:10',0),(21,5,6,1000,0,'2018-12-07 15:19:28','2018-12-07 15:38:09',0),(22,7,9,0,0,'2018-12-08 15:40:24','2018-12-08 15:40:24',0),(23,7,1,30,0,'2018-12-08 15:40:45','2018-12-10 07:57:00',0),(24,5,4,0,0,'2018-12-09 02:24:15','2018-12-09 02:24:15',0),(25,8,3,20,0,'2018-12-10 08:47:45','2018-12-10 08:47:55',0),(26,8,10,3300,1298,'2018-12-10 14:58:11','2018-12-10 16:41:52',0),(27,9,10,19700,0,'2018-12-10 14:59:54','2018-12-11 08:19:47',0),(28,9,1,0,0,'2018-12-10 15:11:00','2018-12-10 15:11:00',0),(29,3,1,50000,0,'2018-12-11 15:58:43','2018-12-11 15:58:43',0),(30,3,3,33000,0,'2018-12-12 02:19:42','2018-12-12 02:19:42',0);
/*!40000 ALTER TABLE `credit_limits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `credit_requests`
--

DROP TABLE IF EXISTS `credit_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `credit_requests` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `customer_id` int(11) DEFAULT NULL,
  `buyer_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `limit` int(11) DEFAULT NULL,
  `approve` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `credit_requests`
--

LOCK TABLES `credit_requests` WRITE;
/*!40000 ALTER TABLE `credit_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `credit_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_comments`
--

DROP TABLE IF EXISTS `customer_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_comments` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `description` text,
  `customer_id` bigint(20) DEFAULT NULL,
  `tender_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `stone_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_customer_comments_on_customer_id` (`customer_id`),
  KEY `index_customer_comments_on_tender_id` (`tender_id`),
  KEY `index_customer_comments_on_stone_id` (`stone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_comments`
--

LOCK TABLES `customer_comments` WRITE;
/*!40000 ALTER TABLE `customer_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_notifications`
--

DROP TABLE IF EXISTS `customer_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_notifications` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `customer_id` bigint(20) DEFAULT NULL,
  `notification_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_customer_notifications_on_customer_id` (`customer_id`),
  KEY `index_customer_notifications_on_notification_id` (`notification_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_notifications`
--

LOCK TABLES `customer_notifications` WRITE;
/*!40000 ALTER TABLE `customer_notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_pictures`
--

DROP TABLE IF EXISTS `customer_pictures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_pictures` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `picture_file_name` varchar(255) DEFAULT NULL,
  `picture_content_type` varchar(255) DEFAULT NULL,
  `picture_file_size` int(11) DEFAULT NULL,
  `picture_updated_at` datetime DEFAULT NULL,
  `customer_id` bigint(20) DEFAULT NULL,
  `tender_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `stone_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_customer_pictures_on_customer_id` (`customer_id`),
  KEY `index_customer_pictures_on_tender_id` (`tender_id`),
  KEY `index_customer_pictures_on_stone_id` (`stone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_pictures`
--

LOCK TABLES `customer_pictures` WRITE;
/*!40000 ALTER TABLE `customer_pictures` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_pictures` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_ratings`
--

DROP TABLE IF EXISTS `customer_ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_ratings` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `star` int(11) DEFAULT NULL,
  `customer_id` bigint(20) DEFAULT NULL,
  `tender_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `stone_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_customer_ratings_on_customer_id` (`customer_id`),
  KEY `index_customer_ratings_on_tender_id` (`tender_id`),
  KEY `index_customer_ratings_on_stone_id` (`stone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_ratings`
--

LOCK TABLES `customer_ratings` WRITE;
/*!40000 ALTER TABLE `customer_ratings` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_ratings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_roles`
--

DROP TABLE IF EXISTS `customer_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_roles` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `customer_id` int(11) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_roles`
--

LOCK TABLES `customer_roles` WRITE;
/*!40000 ALTER TABLE `customer_roles` DISABLE KEYS */;
INSERT INTO `customer_roles` VALUES (6,4,1,'2018-12-03 07:25:32','2018-12-03 07:25:32'),(7,4,2,'2018-12-03 07:25:32','2018-12-03 07:25:32'),(8,5,1,'2018-12-03 07:45:25','2018-12-03 07:45:25'),(9,5,2,'2018-12-03 07:45:25','2018-12-03 07:45:25'),(10,6,1,'2018-12-03 07:46:58','2018-12-03 07:46:58'),(11,6,2,'2018-12-03 07:46:58','2018-12-03 07:46:58'),(12,7,1,'2018-12-03 07:54:59','2018-12-03 07:54:59'),(13,7,2,'2018-12-03 07:54:59','2018-12-03 07:54:59'),(19,10,1,'2018-12-06 07:18:29','2018-12-06 07:18:29'),(20,10,2,'2018-12-06 07:18:29','2018-12-06 07:18:29'),(21,11,1,'2018-12-06 07:19:08','2018-12-06 07:19:08'),(22,11,2,'2018-12-06 07:19:08','2018-12-06 07:19:08'),(27,14,1,'2018-12-06 09:14:01','2018-12-06 09:14:01'),(28,14,2,'2018-12-06 09:14:01','2018-12-06 09:14:01'),(29,15,1,'2018-12-06 09:14:50','2018-12-06 09:14:50'),(30,15,2,'2018-12-06 09:14:50','2018-12-06 09:14:50'),(31,16,1,'2018-12-06 09:15:40','2018-12-06 09:15:40'),(32,16,2,'2018-12-06 09:15:40','2018-12-06 09:15:40'),(33,17,1,'2018-12-06 09:16:38','2018-12-06 09:16:38'),(34,17,2,'2018-12-06 09:16:38','2018-12-06 09:16:38'),(37,19,1,'2018-12-07 06:11:10','2018-12-07 06:11:10'),(38,19,2,'2018-12-07 06:11:10','2018-12-07 06:11:10'),(39,20,1,'2018-12-07 07:04:04','2018-12-07 07:04:04'),(40,20,2,'2018-12-07 07:04:04','2018-12-07 07:04:04'),(41,21,1,'2018-12-07 15:00:20','2018-12-07 15:00:20'),(42,21,2,'2018-12-07 15:00:20','2018-12-07 15:00:20');
/*!40000 ALTER TABLE `customer_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customers` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) DEFAULT NULL,
  `last_sign_in_ip` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `postal_code` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `confirmation_token` varchar(255) DEFAULT NULL,
  `confirmed_at` datetime DEFAULT NULL,
  `confirmation_sent_at` datetime DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `company_address` text,
  `phone_2` varchar(255) DEFAULT NULL,
  `mobile_no` varchar(255) DEFAULT NULL,
  `authentication_token` varchar(255) DEFAULT NULL,
  `verified` tinyint(1) DEFAULT '0',
  `certificate_file_name` varchar(255) DEFAULT NULL,
  `certificate_content_type` varchar(255) DEFAULT NULL,
  `certificate_file_size` int(11) DEFAULT NULL,
  `certificate_updated_at` datetime DEFAULT NULL,
  `invitation_token` varchar(255) DEFAULT NULL,
  `invitation_created_at` datetime DEFAULT NULL,
  `invitation_sent_at` datetime DEFAULT NULL,
  `invitation_accepted_at` datetime DEFAULT NULL,
  `invitation_limit` int(11) DEFAULT NULL,
  `invited_by_type` varchar(255) DEFAULT NULL,
  `invited_by_id` bigint(20) DEFAULT NULL,
  `invitations_count` int(11) DEFAULT '0',
  `chat_id` varchar(255) DEFAULT '-1',
  `firebase_uid` varchar(255) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `is_requested` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_customers_on_email` (`email`),
  UNIQUE KEY `index_customers_on_reset_password_token` (`reset_password_token`),
  UNIQUE KEY `index_customers_on_invitation_token` (`invitation_token`),
  KEY `index_customers_on_invited_by_type_and_invited_by_id` (`invited_by_type`,`invited_by_id`),
  KEY `index_customers_on_invitations_count` (`invitations_count`),
  KEY `index_customers_on_invited_by_id` (`invited_by_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (4,'buyerc@getnada.com','$2a$10$IaWS0CGAzFIOSLUmSuGxdOLtqRRs8l2SgTMQy.2.wnS3wiXsPZU36',NULL,NULL,NULL,29,'2018-12-12 18:52:00','2018-12-12 18:33:31','94.207.92.129','157.51.246.130','2018-12-03 07:25:31','2018-12-12 18:52:00','he','she','','',NULL,'',NULL,'wFGFKoxQhxW9fvhEs_ik','2018-12-03 07:35:47','2018-12-03 07:25:31',3,'','','+267 5632147','pzCfJi3cdx6JxaxAWxp-',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'-1',NULL,NULL,0),(5,'sellerb@getnada.com','$2a$10$xgZL8acgm7HERmc55xP0oeKafd1KBUxCI8Xv4Gs6i7zX3VNthYggm',NULL,NULL,NULL,78,'2018-12-12 10:41:11','2018-12-12 10:39:58','94.207.92.129','114.143.92.119','2018-12-03 07:45:25','2018-12-12 10:41:11','Rehaan ','choksi','','',NULL,'',NULL,'yms1fM6Y86Cyy6zddoDx','2018-12-03 07:51:43','2018-12-03 07:45:25',5,'','','+244 5236887','Z7-4mLXTxpKX81yBLatr',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'-1',NULL,NULL,0),(6,'sellerc@getnada.com','$2a$10$L6Dpn0I1qNMvbwfsOUu1AO7GApfgWwqnx5DlKZnlCcyXVhHlFvPX.',NULL,NULL,NULL,31,'2018-12-12 16:11:37','2018-12-12 07:55:09','72.255.53.123','72.255.53.123','2018-12-03 07:46:57','2018-12-12 16:11:37','eve','adam','','',NULL,'',NULL,'HxvGqMXGogiAZMRJY-xg','2018-12-03 07:51:51','2018-12-03 07:46:57',6,'','','+1 1257746','Nm-C7oc321bCnnhszdrY',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'-1',NULL,NULL,0),(7,'sellera@getnada.com','$2a$10$gJV3L1EzbWH88OiKVW1o3OmzQ.iby5xDjE.B88qFpCH5e7qro9Rk6',NULL,NULL,NULL,30,'2018-12-12 18:32:19','2018-12-12 18:31:25','94.207.92.129','94.207.92.129','2018-12-03 07:54:55','2018-12-12 18:32:19','Seller','A','','',NULL,'',NULL,'tyU71x6ib_eiHZd6x9-P','2018-12-03 07:55:10','2018-12-03 07:54:55',4,'','','+12011235555','rJ_59S1HTxg7F-2y767F',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'-1',NULL,NULL,0),(10,'buyerb@getnada.com','$2a$10$v54zEcjyXRhc0V9vtX6FXe9yzMuZDF5JZFFm5P12uIvJSh5kMKJAi',NULL,NULL,NULL,10,'2018-12-12 10:30:16','2018-12-12 10:29:04','114.143.92.119','72.255.53.123','2018-12-06 07:18:25','2018-12-12 10:30:16','Buyer','B','','',NULL,'',NULL,'Z2Fyc5Dxkr5Ag8UXM62R','2018-12-06 07:18:39','2018-12-06 07:18:25',2,'','','+11505551111','1aXhKDi_-UN4d3mFVHuq',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'-1',NULL,NULL,0),(11,'buyera@getnada.com','$2a$10$zRHt2l8bXwJ5CpRJkHHa1uLCVmNycNm/Le6nXng2MeSeo3n1IBNIe',NULL,NULL,NULL,19,'2018-12-12 18:48:52','2018-12-12 18:10:00','94.207.92.129','94.207.92.129','2018-12-06 07:19:08','2018-12-12 18:48:52','az','za','','',NULL,'',NULL,'Wqr4CA6g554pABSMn6uE','2018-12-06 07:19:22','2018-12-06 07:19:08',1,'','','+267 852369','wEkx2xdSC2W4ynzuM5yU',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'-1',NULL,NULL,0),(14,'dummyb1@getnada.com','$2a$10$A3Snvl8UJw.BbhdaM.UHQeMWli.gp7hkZmgyX8Biqs/y.TxkjOcwe',NULL,NULL,NULL,51,'2018-12-11 14:23:57','2018-12-11 12:36:49','72.255.53.123','72.255.53.123','2018-12-06 09:14:00','2018-12-11 14:23:57','Dummy','Buyer 1',NULL,NULL,NULL,NULL,NULL,'iQE92AjLyh53NYieBZKS','2018-12-06 09:14:27','2018-12-06 09:14:00',7,NULL,NULL,'+11111234455','HVWPzD1ek5_SW-kBxJuc',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'-1',NULL,NULL,0),(15,'dummyb2@getnada.com','$2a$10$qaJq4iivEi8YKO.xUfATo.QTExTw9lHp/TP0aylH2CY86VhLb.aHO',NULL,NULL,NULL,28,'2018-12-11 14:55:51','2018-12-11 14:52:57','72.255.53.123','72.255.53.123','2018-12-06 09:14:49','2018-12-11 14:55:51','Dummy','Buyer 2',NULL,NULL,NULL,NULL,NULL,'pC1sUj5e_uBpYozEnLbB','2018-12-06 09:15:17','2018-12-06 09:14:49',10,NULL,NULL,'+11111233344','zcCCttWrynRfF-P-e89B',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'-1',NULL,NULL,0),(16,'dummys1@getnada.com','$2a$10$pj4bi28wlcWkXAx4gPSF4eZE/utxKerH8OcZm32pQLCZabhbTP6f2',NULL,NULL,NULL,53,'2018-12-12 16:10:43','2018-12-11 14:56:20','72.255.53.123','72.255.53.123','2018-12-06 09:15:40','2018-12-12 16:10:43','Dummy','Seller 1',NULL,NULL,NULL,NULL,NULL,'iWRyf-Sghsx3VM-8yDSz','2018-12-06 09:15:54','2018-12-06 09:15:40',8,NULL,NULL,'+11111232233','T8Mv1tDTrdwJmTKyS-Rh',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'-1',NULL,NULL,0),(17,'dummys2@getnada.com','$2a$10$4mFTvk6wY.A9ovPce0QYKuaaFYOe/QuDrKLFkXQ.qCDwOiOaTC.LG',NULL,NULL,NULL,25,'2018-12-11 14:57:01','2018-12-11 14:53:58','72.255.53.123','72.255.53.123','2018-12-06 09:16:36','2018-12-11 14:57:01','Dummy','Seller 2',NULL,NULL,NULL,NULL,NULL,'JeDy6rnkm526G786sT-7','2018-12-06 09:26:17','2018-12-06 09:16:36',9,NULL,NULL,'+11111231122','HKqHrD7sSYcHPDo18EFb',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'-1',NULL,NULL,0),(19,'niraj@kgirdharlala.com','$2a$10$iGHyrOBpJ98WON36PoAOIuO9cQivnXmR.g8prJfhPUnzK1JJhPZs2',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'2018-12-07 06:11:05','2018-12-07 06:11:11','niraj','patel',NULL,NULL,NULL,NULL,NULL,'jH5B6g1fDEZ-S-RsgoR-','2018-12-07 06:11:10','2018-12-07 06:11:05',7,NULL,NULL,'+91 9725040039','n8TXs4nLg9pdKDBSbMm8',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'-1',NULL,NULL,1),(20,'niraj@kgirdharlal.com','$2a$10$3wlidu4m/81XV757j.hF1OQmPE4SZZTZ0PKG3P8AUiaOVdSnGxrDW',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'2018-12-07 07:04:03','2018-12-07 07:04:04','niraj s','patel',NULL,NULL,NULL,NULL,NULL,'QrvtYUqMsc_k3d_-aDRz','2018-12-07 07:04:04','2018-12-07 07:04:03',7,NULL,NULL,'9725040039',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'-1',NULL,NULL,1),(21,'umair.raza101@gmail.com','$2a$10$g2cfaxhONHveSh2wewGdd.hzoOJFnuyVO6ituXC.4ipV7zovKkFdW',NULL,NULL,NULL,5,'2018-12-11 11:24:29','2018-12-10 14:54:27','72.255.53.123','72.255.53.123','2018-12-07 15:00:19','2018-12-11 11:24:29','Umair','Raza',NULL,NULL,NULL,NULL,NULL,'WRtW57M7zxZQg15hsTWA','2018-12-07 15:00:20','2018-12-07 15:00:19',8,NULL,NULL,'+1','XwHsMFNtQAy6aFpttQek',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'-1',NULL,NULL,0);
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers_tenders`
--

DROP TABLE IF EXISTS `customers_tenders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customers_tenders` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tender_id` bigint(20) DEFAULT NULL,
  `customer_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `confirmed` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_customers_tenders_on_tender_id` (`tender_id`),
  KEY `index_customers_tenders_on_customer_id` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers_tenders`
--

LOCK TABLES `customers_tenders` WRITE;
/*!40000 ALTER TABLE `customers_tenders` DISABLE KEYS */;
/*!40000 ALTER TABLE `customers_tenders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `days_limits`
--

DROP TABLE IF EXISTS `days_limits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `days_limits` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `seller_id` int(11) DEFAULT NULL,
  `buyer_id` int(11) DEFAULT NULL,
  `days_limit` decimal(10,0) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `days_limits`
--

LOCK TABLES `days_limits` WRITE;
/*!40000 ALTER TABLE `days_limits` DISABLE KEYS */;
INSERT INTO `days_limits` VALUES (1,4,1,40,'2018-12-03 08:10:38','2018-12-03 08:10:38'),(2,4,2,15,'2018-12-03 08:11:01','2018-12-03 08:11:01'),(3,4,3,25,'2018-12-03 08:11:21','2018-12-03 08:11:21'),(4,5,1,20,'2018-12-03 08:14:11','2018-12-09 09:32:45'),(5,5,3,25,'2018-12-03 08:14:19','2018-12-08 09:51:48'),(6,5,2,16,'2018-12-06 23:45:57','2018-12-09 06:31:05'),(7,5,6,3000,'2018-12-07 15:39:38','2018-12-07 15:39:38'),(8,5,4,31,'2018-12-08 09:07:21','2018-12-08 09:07:21'),(9,7,1,50,'2018-12-08 13:39:51','2018-12-10 09:06:53'),(10,7,9,20,'2018-12-08 15:39:25','2018-12-08 15:39:31'),(11,8,3,30,'2018-12-10 08:47:45','2018-12-10 08:48:02'),(12,9,1,50,'2018-12-10 15:11:01','2018-12-10 15:11:33'),(13,3,1,16,'2018-12-11 15:58:50','2018-12-11 15:58:50');
/*!40000 ALTER TABLE `days_limits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `delayed_jobs`
--

DROP TABLE IF EXISTS `delayed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `delayed_jobs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `priority` int(11) NOT NULL DEFAULT '0',
  `attempts` int(11) NOT NULL DEFAULT '0',
  `handler` text NOT NULL,
  `last_error` text,
  `run_at` datetime DEFAULT NULL,
  `locked_at` datetime DEFAULT NULL,
  `failed_at` datetime DEFAULT NULL,
  `locked_by` varchar(255) DEFAULT NULL,
  `queue` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `delayed_jobs_priority` (`priority`,`run_at`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delayed_jobs`
--

LOCK TABLES `delayed_jobs` WRITE;
/*!40000 ALTER TABLE `delayed_jobs` DISABLE KEYS */;
INSERT INTO `delayed_jobs` VALUES (1,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:CreditLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit_limit\n    value_before_type_cast: 4500\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 16\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 8\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: market_limit\n    value_before_type_cast: 0\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-06 17:34:50.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-08 11:59:58.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: star\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-08 11:59:58',NULL,NULL,NULL,NULL,'2018-12-08 11:59:58','2018-12-08 11:59:58'),(2,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 28\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 8\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 113\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n    value_before_type_cast: 2019-02-25 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.9E2\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 80\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-08 11:59:58.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-08 11:59:58.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.45E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: b1d41ee4c0d01644181f2c3b\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.45E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+9 SAWABLES LIGHT\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-08 11:59:58',NULL,NULL,NULL,NULL,'2018-12-08 11:59:58','2018-12-08 11:59:58'),(3,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 28\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 8\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 113\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n    value_before_type_cast: 2019-02-25 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.9E2\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 80\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-08 11:59:58.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-08 11:59:58.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.45E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: b1d41ee4c0d01644181f2c3b\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.45E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+9 SAWABLES LIGHT\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-08 11:59:58',NULL,NULL,NULL,NULL,'2018-12-08 11:59:58','2018-12-08 11:59:58'),(4,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:CreditLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit_limit\n    value_before_type_cast: 6049\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 16\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 8\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: market_limit\n    value_before_type_cast: 0\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-06 17:34:50.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-08 12:07:56.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: star\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-08 12:07:56',NULL,NULL,NULL,NULL,'2018-12-08 12:07:56','2018-12-08 12:07:56'),(5,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:CreditLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: market_limit\n    value_before_type_cast: 1549\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 16\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit_limit\n    value_before_type_cast: 6049\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 8\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-06 17:34:50.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-08 12:07:56.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: star\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-08 12:07:56',NULL,NULL,NULL,NULL,'2018-12-08 12:07:56','2018-12-08 12:07:56'),(6,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 29\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 8\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 114\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n    value_before_type_cast: 2019-11-15 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.4556E2\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 343\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-08 12:07:56.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-08 12:07:56.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.154904E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: df6584a23a08320e19a24b6a\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 36:0.154904E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+11 BLK ST LIGHT\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-08 12:07:56',NULL,NULL,NULL,NULL,'2018-12-08 12:07:56','2018-12-08 12:07:56'),(7,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 29\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 8\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 114\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n    value_before_type_cast: 2019-11-15 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.4556E2\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 343\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-08 12:07:56.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-08 12:07:56.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.154904E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: df6584a23a08320e19a24b6a\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.154904E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+11 BLK ST LIGHT\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-08 12:07:56',NULL,NULL,NULL,NULL,'2018-12-08 12:07:56','2018-12-08 12:07:56'),(8,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:CreditLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit_limit\n    value_before_type_cast: 7598\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 16\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 8\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: market_limit\n    value_before_type_cast: 1549\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-06 17:34:50.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-08 12:10:09.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: star\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-08 12:10:09',NULL,NULL,NULL,NULL,'2018-12-08 12:10:09','2018-12-08 12:10:09'),(9,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:CreditLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: market_limit\n    value_before_type_cast: 3098\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 16\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit_limit\n    value_before_type_cast: 7598\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 8\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-06 17:34:50.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-08 12:10:09.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: star\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-08 12:10:09',NULL,NULL,NULL,NULL,'2018-12-08 12:10:09','2018-12-08 12:10:09'),(10,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 30\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 8\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 115\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n    value_before_type_cast: 2019-01-10 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.4556E2\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 34\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-08 12:10:09.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-08 12:10:09.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.154904E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: 81790f2334f7a14d81b9cae0\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 36:0.154904E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+11 CLIV/MB LIGHT\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-08 12:10:09',NULL,NULL,NULL,NULL,'2018-12-08 12:10:09','2018-12-08 12:10:09'),(11,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 30\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 8\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 115\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n    value_before_type_cast: 2019-01-10 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.4556E2\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 34\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-08 12:10:09.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-08 12:10:09.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.154904E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: 81790f2334f7a14d81b9cae0\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.154904E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+11 CLIV/MB LIGHT\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-08 12:10:09',NULL,NULL,NULL,NULL,'2018-12-08 12:10:09','2018-12-08 12:10:09'),(12,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:DaysLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 9\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 1\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: days_limit\n    value_before_type_cast: 20\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-08 13:39:51.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-08 13:39:51.000000000 Z\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-08 13:39:51',NULL,NULL,NULL,NULL,'2018-12-08 13:39:51','2018-12-08 13:39:51'),(13,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:CreditLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit_limit\n    value_before_type_cast: 7624\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 16\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 8\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: market_limit\n    value_before_type_cast: 3098\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-06 17:34:50.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-08 14:22:10.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: star\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-08 14:22:10',NULL,NULL,NULL,NULL,'2018-12-08 14:22:10','2018-12-08 14:22:10'),(14,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 31\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 8\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 116\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n    value_before_type_cast: 2020-06-17 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.525E1\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 558\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-08 14:22:10.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-08 14:22:10.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.2625E2\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: f262546226688b5f64265830\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 36:0.2625E2\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+9 SAWABLES LIGHT\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-08 14:22:10',NULL,NULL,NULL,NULL,'2018-12-08 14:22:10','2018-12-08 14:22:10'),(15,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 31\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 8\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 116\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n    value_before_type_cast: 2020-06-17 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.525E1\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 558\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-08 14:22:10.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-08 14:22:10.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.2625E2\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: f262546226688b5f64265830\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.2625E2\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+9 SAWABLES LIGHT\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-08 14:22:10',NULL,NULL,NULL,NULL,'2018-12-08 14:22:10','2018-12-08 14:22:10'),(16,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:CreditLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit_limit\n    value_before_type_cast: 10924\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 16\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 8\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: market_limit\n    value_before_type_cast: 3098\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-06 17:34:50.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-08 14:30:08.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: star\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-08 14:30:08',NULL,NULL,NULL,NULL,'2018-12-08 14:30:08','2018-12-08 14:30:08'),(17,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 32\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 8\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 117\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n    value_before_type_cast: 2018-12-27 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.33E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 20\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-08 14:30:08.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-08 14:30:08.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.33E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: bfc4ae5154f688a29a4b74b8\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.33E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: Collection 5-10 ct\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-08 14:30:08',NULL,NULL,NULL,NULL,'2018-12-08 14:30:08','2018-12-08 14:30:08'),(18,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 32\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 8\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 117\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n    value_before_type_cast: 2018-12-27 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.33E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 20\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-08 14:30:08.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-08 14:30:08.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.33E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: bfc4ae5154f688a29a4b74b8\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.33E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: Collection 5-10 ct\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-08 14:30:08',NULL,NULL,NULL,NULL,'2018-12-08 14:30:08','2018-12-08 14:30:08'),(19,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:DaysLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 10\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 9\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: days_limit\n    value_before_type_cast: 15\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-08 15:39:25.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-08 15:39:25.000000000 Z\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-08 15:39:25',NULL,NULL,NULL,NULL,'2018-12-08 15:39:25','2018-12-08 15:39:25'),(20,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:DaysLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: days_limit\n    value_before_type_cast: 20\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 10\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 9\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-08 15:39:25.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-08 15:39:31.000000000 Z\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-08 15:39:31',NULL,NULL,NULL,NULL,'2018-12-08 15:39:31','2018-12-08 15:39:31'),(21,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:CreditLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 22\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 9\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit_limit\n    value_before_type_cast: 0\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: market_limit\n    value_before_type_cast: 0\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-08 15:40:24.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-08 15:40:24.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: star\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-08 15:40:24',NULL,NULL,NULL,NULL,'2018-12-08 15:40:24','2018-12-08 15:40:24'),(22,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:CreditLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 23\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 1\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit_limit\n    value_before_type_cast: 0\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: market_limit\n    value_before_type_cast: 0\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-08 15:40:45.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-08 15:40:45.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: star\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-08 15:40:45',NULL,NULL,NULL,NULL,'2018-12-08 15:40:45','2018-12-08 15:40:45'),(23,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:CreditLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 24\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit_limit\n    value_before_type_cast: 0\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: market_limit\n    value_before_type_cast: 0\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-09 02:24:15.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-09 02:24:15.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: star\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-09 02:24:15',NULL,NULL,NULL,NULL,'2018-12-09 02:24:15','2018-12-09 02:24:15'),(24,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:CreditLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 12\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit_limit\n    value_before_type_cast: 18025\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 2\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: market_limit\n    value_before_type_cast: 1\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-05 18:35:49.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-06 23:55:30.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: star\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-09 06:31:05',NULL,NULL,NULL,NULL,'2018-12-09 06:31:05','2018-12-09 06:31:05'),(25,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:DaysLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: days_limit\n    value_before_type_cast: 16\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 6\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 2\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-06 23:45:57.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-09 06:31:05.000000000 Z\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-09 06:31:05',NULL,NULL,NULL,NULL,'2018-12-09 06:31:05','2018-12-09 06:31:05'),(26,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:DaysLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: days_limit\n    value_before_type_cast: 20\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 1\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-03 08:14:11.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-09 09:32:45.000000000 Z\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-09 09:32:45',NULL,NULL,NULL,NULL,'2018-12-09 09:32:45','2018-12-09 09:32:45'),(27,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.8025E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 19\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 63\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 2\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-06 23:55:30.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n    value_before_type_cast: 2019-01-05 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.175E3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 30\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 00:27:14.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: a693665cc9bf5f27953452ba\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.18025E5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+11 CLIV/MB LIGHT\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 00:27:14',NULL,NULL,NULL,NULL,'2018-12-10 00:27:14','2018-12-10 00:27:14'),(28,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.0\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 19\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 63\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 2\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-06 23:55:30.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n    value_before_type_cast: 2019-01-05 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.175E3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 30\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 00:28:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: a693665cc9bf5f27953452ba\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.18025E5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+11 CLIV/MB LIGHT\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 00:28:00',NULL,NULL,NULL,NULL,'2018-12-10 00:28:00','2018-12-10 00:28:00'),(29,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.1189E5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 24\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 65\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-07 12:32:14.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n    value_before_type_cast: 2019-02-19 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.199E3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 75\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 00:29:59.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: 407ac1c08f8090fbfc0fb27a\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.2189E5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+11 REJECTIONS\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 00:29:59',NULL,NULL,NULL,NULL,'2018-12-10 00:29:59','2018-12-10 00:29:59'),(30,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.0\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 24\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 65\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-07 12:32:14.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n    value_before_type_cast: 2019-02-19 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.199E3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 75\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 00:31:42.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: 407ac1c08f8090fbfc0fb27a\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.2189E5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+11 REJECTIONS\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 00:31:42',NULL,NULL,NULL,NULL,'2018-12-10 00:31:42','2018-12-10 00:31:42'),(31,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.0\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 25\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 105\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-10 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n    value_before_type_cast: 2019-02-08 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.25E2\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 60\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 00:33:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n    value_before_type_cast: manual\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: 901edba26eca6f9201dee342\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.375E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+9 SAWABLES LIGHT\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 00:33:00',NULL,NULL,NULL,NULL,'2018-12-10 00:33:00','2018-12-10 00:33:00'),(32,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.15E5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 23\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 103\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-10-31 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n    value_before_type_cast: 2018-11-30 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.1E3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 30\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 00:33:49.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n    value_before_type_cast: manual\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: \'08e2a43b283a460ccefc0abf\'\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.5E5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+9 SAWABLES LIGHT\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 00:33:49',NULL,NULL,NULL,NULL,'2018-12-10 00:33:49','2018-12-10 00:33:49'),(33,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.0\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 23\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 103\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-10-31 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n    value_before_type_cast: 2018-11-30 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.1E3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 30\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 00:34:27.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n    value_before_type_cast: manual\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: \'08e2a43b283a460ccefc0abf\'\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.5E5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+9 SAWABLES LIGHT\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 00:34:27',NULL,NULL,NULL,NULL,'2018-12-10 00:34:27','2018-12-10 00:34:27'),(34,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.0\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 26\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 106\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-09-30 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n    value_before_type_cast: 2018-10-09 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.11E2\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 9\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 00:34:56.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n    value_before_type_cast: manual\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: f572036151ca387229c323db\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.1375E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+11 CLIV/MB LIGHT\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 00:34:56',NULL,NULL,NULL,NULL,'2018-12-10 00:34:56','2018-12-10 00:34:56'),(35,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 27\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 111\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2017-12-07 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n    value_before_type_cast: 2018-02-05 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.2E3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 60\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 00:37:40.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n    value_before_type_cast: manual\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.2E5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: dafc2aa2daf751b50984e3cc\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.2E5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+9 SAWABLES LIGHT\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 00:37:40',NULL,NULL,NULL,NULL,'2018-12-10 00:37:40','2018-12-10 00:37:40'),(36,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.0\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 27\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 111\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2017-12-07 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n    value_before_type_cast: 2018-02-05 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.2E3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 60\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 00:52:36.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n    value_before_type_cast: manual\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: dafc2aa2daf751b50984e3cc\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.2E5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+9 SAWABLES LIGHT\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 00:52:36',NULL,NULL,NULL,NULL,'2018-12-10 00:52:36','2018-12-10 00:52:36'),(37,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 33\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 120\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.2E3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 15\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-10-31 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 01:05:22.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n    value_before_type_cast: manual\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.1E6\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: 37d23ec82f792d71dd9e382b\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.1E6\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+9 SAWABLES LIGHT\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 01:05:22',NULL,NULL,NULL,NULL,'2018-12-10 01:05:22','2018-12-10 01:05:22'),(38,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 33\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 120\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.2E3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 15\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-10-31 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 01:05:22.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n    value_before_type_cast: manual\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.1E6\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: 37d23ec82f792d71dd9e382b\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.1E6\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+9 SAWABLES LIGHT\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 01:05:22',NULL,NULL,NULL,NULL,'2018-12-10 01:05:22','2018-12-10 01:05:22'),(39,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 33\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 120\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n    value_before_type_cast: 2018-11-15 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.2E3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 15\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-10-31 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 01:05:22.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n    value_before_type_cast: manual\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.1E6\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: 37d23ec82f792d71dd9e382b\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.1E6\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+9 SAWABLES LIGHT\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 01:05:22',NULL,NULL,NULL,NULL,'2018-12-10 01:05:22','2018-12-10 01:05:22'),(40,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:CreditLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit_limit\n    value_before_type_cast: 100000\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 20\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: market_limit\n    value_before_type_cast: 50000\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-07 12:31:48.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 01:05:22.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: star\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 01:05:22',NULL,NULL,NULL,NULL,'2018-12-10 01:05:22','2018-12-10 01:05:22'),(41,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 33\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 120\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-10-31 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n    value_before_type_cast: 2018-11-15 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.2E3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 15\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 02:13:44.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n    value_before_type_cast: manual\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.1E6\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: 349fd0501003b8f8c0ad3af9\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.1E6\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+9 SAWABLES LIGHT\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 02:13:44',NULL,NULL,NULL,NULL,'2018-12-10 02:13:44','2018-12-10 02:13:44'),(42,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:CreditLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit_limit\n    value_before_type_cast: 30\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 23\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 1\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: market_limit\n    value_before_type_cast: 0\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-08 15:40:45.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 07:56:19.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: star\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 07:56:19',NULL,NULL,NULL,NULL,'2018-12-10 07:56:19','2018-12-10 07:56:19'),(43,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:DaysLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: days_limit\n    value_before_type_cast: 30\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 9\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 1\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-08 13:39:51.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 07:56:26.000000000 Z\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 07:56:26',NULL,NULL,NULL,NULL,'2018-12-10 07:56:26','2018-12-10 07:56:26'),(44,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:CreditLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit_limit\n    value_before_type_cast: 50\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 23\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 1\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: market_limit\n    value_before_type_cast: 0\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-08 15:40:45.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 07:56:36.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: star\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 07:56:36',NULL,NULL,NULL,NULL,'2018-12-10 07:56:36','2018-12-10 07:56:36'),(45,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:DaysLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: days_limit\n    value_before_type_cast: 60\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 9\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 1\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-08 13:39:51.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 07:56:37.000000000 Z\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 07:56:37',NULL,NULL,NULL,NULL,'2018-12-10 07:56:37','2018-12-10 07:56:37'),(46,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:DaysLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: days_limit\n    value_before_type_cast: 70\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 9\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 1\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-08 13:39:51.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 07:56:47.000000000 Z\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 07:56:47',NULL,NULL,NULL,NULL,'2018-12-10 07:56:47','2018-12-10 07:56:47'),(47,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:CreditLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit_limit\n    value_before_type_cast: 30\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 23\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 1\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: market_limit\n    value_before_type_cast: 0\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-08 15:40:45.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 07:57:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: star\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 07:57:00',NULL,NULL,NULL,NULL,'2018-12-10 07:57:00','2018-12-10 07:57:00'),(48,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:DaysLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: days_limit\n    value_before_type_cast: 40\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 9\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 1\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-08 13:39:51.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 07:57:00.000000000 Z\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 07:57:00',NULL,NULL,NULL,NULL,'2018-12-10 07:57:00','2018-12-10 07:57:00'),(49,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.8E5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 33\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 120\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-10-31 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n    value_before_type_cast: 2018-11-15 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.2E3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 15\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 08:19:07.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n    value_before_type_cast: manual\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: 349fd0501003b8f8c0ad3af9\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.1E6\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+9 SAWABLES LIGHT\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 08:19:07',NULL,NULL,NULL,NULL,'2018-12-10 08:19:07','2018-12-10 08:19:07'),(50,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.15E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 28\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 113\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 8\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-08 11:59:58.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n    value_before_type_cast: 2019-02-25 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.9E2\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 80\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 08:33:40.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: b1d41ee4c0d01644181f2c3b\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.45E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+9 SAWABLES LIGHT\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 08:33:40',NULL,NULL,NULL,NULL,'2018-12-10 08:33:40','2018-12-10 08:33:40'),(51,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 34\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 125\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.1E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 30\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-09 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 08:43:10.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n    value_before_type_cast: manual\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.1E6\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: b914e358de32f334218eac09\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.1E6\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+9 SAWABLES LIGHT\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 08:43:10',NULL,NULL,NULL,NULL,'2018-12-10 08:43:10','2018-12-10 08:43:10'),(52,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 34\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 125\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.1E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 30\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-09 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 08:43:10.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n    value_before_type_cast: manual\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.1E6\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: b914e358de32f334218eac09\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.1E6\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+9 SAWABLES LIGHT\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 08:43:10',NULL,NULL,NULL,NULL,'2018-12-10 08:43:10','2018-12-10 08:43:10'),(53,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 34\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 125\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n    value_before_type_cast: 2019-01-08 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.1E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 30\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-09 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 08:43:10.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n    value_before_type_cast: manual\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.1E6\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: b914e358de32f334218eac09\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.1E6\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+9 SAWABLES LIGHT\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 08:43:10',NULL,NULL,NULL,NULL,'2018-12-10 08:43:10','2018-12-10 08:43:10'),(54,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:CreditLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit_limit\n    value_before_type_cast: 180000\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 20\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: market_limit\n    value_before_type_cast: 50000\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-07 12:31:48.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 08:43:10.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: star\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 08:43:10',NULL,NULL,NULL,NULL,'2018-12-10 08:43:10','2018-12-10 08:43:10'),(55,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 34\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 125\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-09 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n    value_before_type_cast: 2019-01-08 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.1E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 30\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 08:44:21.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n    value_before_type_cast: manual\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.1E6\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: 2c103078f8fc23268c8156f7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.1E6\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+9 SAWABLES LIGHT\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 08:44:21',NULL,NULL,NULL,NULL,'2018-12-10 08:44:21','2018-12-10 08:44:21'),(56,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:CreditLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 12\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit_limit\n    value_before_type_cast: 18025\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 2\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: market_limit\n    value_before_type_cast: 1\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-05 18:35:49.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-06 23:55:30.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: star\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 08:44:37',NULL,NULL,NULL,NULL,'2018-12-10 08:44:37','2018-12-10 08:44:37'),(57,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:CreditLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 12\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit_limit\n    value_before_type_cast: 18025\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 2\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: market_limit\n    value_before_type_cast: 1\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-05 18:35:49.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-06 23:55:30.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: star\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 08:45:12',NULL,NULL,NULL,NULL,'2018-12-10 08:45:12','2018-12-10 08:45:12'),(58,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:CreditLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 25\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 8\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit_limit\n    value_before_type_cast: 10\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: market_limit\n    value_before_type_cast: 0\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-10 08:47:45.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 08:47:45.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: star\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 08:47:45',NULL,NULL,NULL,NULL,'2018-12-10 08:47:45','2018-12-10 08:47:45'),(59,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:DaysLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 11\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 8\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: days_limit\n    value_before_type_cast: 20\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-10 08:47:45.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 08:47:45.000000000 Z\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 08:47:45',NULL,NULL,NULL,NULL,'2018-12-10 08:47:45','2018-12-10 08:47:45'),(60,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:CreditLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit_limit\n    value_before_type_cast: 20\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 25\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 8\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: market_limit\n    value_before_type_cast: 0\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-10 08:47:45.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 08:47:55.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: star\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 08:47:55',NULL,NULL,NULL,NULL,'2018-12-10 08:47:55','2018-12-10 08:47:55'),(61,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:DaysLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: days_limit\n    value_before_type_cast: 30\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 11\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 3\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 8\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-10 08:47:45.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 08:48:02.000000000 Z\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 08:48:02',NULL,NULL,NULL,NULL,'2018-12-10 08:48:02','2018-12-10 08:48:02'),(62,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.0\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 28\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 113\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 8\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-08 11:59:58.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n    value_before_type_cast: 2019-02-25 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.9E2\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 80\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 08:54:25.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: b1d41ee4c0d01644181f2c3b\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.45E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+9 SAWABLES LIGHT\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 08:54:25',NULL,NULL,NULL,NULL,'2018-12-10 08:54:25','2018-12-10 08:54:25'),(63,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.0\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 29\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 114\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 8\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-08 12:07:56.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n    value_before_type_cast: 2019-11-15 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.4556E2\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 343\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 08:55:18.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: df6584a23a08320e19a24b6a\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 36:0.154904E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+11 BLK ST LIGHT\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 08:55:18',NULL,NULL,NULL,NULL,'2018-12-10 08:55:18','2018-12-10 08:55:18'),(64,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:CreditLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 23\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit_limit\n    value_before_type_cast: 30\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 1\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: market_limit\n    value_before_type_cast: 0\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-08 15:40:45.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 07:57:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: star\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 09:06:09',NULL,NULL,NULL,NULL,'2018-12-10 09:06:09','2018-12-10 09:06:09'),(65,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:DaysLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: days_limit\n    value_before_type_cast: 50\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 9\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 1\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-08 13:39:51.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 09:06:53.000000000 Z\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 09:06:53',NULL,NULL,NULL,NULL,'2018-12-10 09:06:53','2018-12-10 09:06:53'),(66,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:CreditLimit\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit_limit\n    value_before_type_cast: 20000\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 12\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 2\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 5\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: market_limit\n    value_before_type_cast: 1\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-05 18:35:49.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 09:10:31.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: star\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 09:10:31',NULL,NULL,NULL,NULL,'2018-12-10 09:10:31','2018-12-10 09:10:31'),(67,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.0\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 20\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 85\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 10\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-07 10:09:14.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n    value_before_type_cast: 2018-12-26 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.34E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 20\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 09:17:46.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: 3ce8c24a90b802af63538300\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.34E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: \"+11 CLIV/MB LIGHT\"\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 09:17:46',NULL,NULL,NULL,NULL,'2018-12-10 09:17:46','2018-12-10 09:17:46'),(68,0,0,'--- !ruby/object:Delayed::PerformableMethod\nobject: !ruby/object:Transaction\n  concise_attributes:\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: remaining_amount\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.32E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: id\n    value_before_type_cast: 32\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: trading_parcel_id\n    value_before_type_cast: 117\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_id\n    value_before_type_cast: 7\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: seller_id\n    value_before_type_cast: 8\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: created_at\n    value_before_type_cast: 2018-12-08 14:30:08.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: due_date\n    value_before_type_cast: 2018-12-27 18:30:00.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: price\n    value_before_type_cast: !ruby/object:BigDecimal 18:0.33E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: credit\n    value_before_type_cast: 20\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: paid\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: updated_at\n    value_before_type_cast: 2018-12-10 09:24:20.000000000 Z\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_confirmed\n    value_before_type_cast: true\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_reason\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: reject_date\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_type\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: transaction_uid\n    value_before_type_cast: bfc4ae5154f688a29a4b74b8\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: diamond_type\n    value_before_type_cast: Sight\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: total_amount\n    value_before_type_cast: !ruby/object:BigDecimal 27:0.33E4\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: invoice_no\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: ready_for_buyer\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: description\n    value_before_type_cast: Collection 5-10 ct\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: buyer_reject\n  - !ruby/object:ActiveRecord::Attribute::FromDatabase\n    name: cancel\n  new_record: false\n  active_record_yaml_version: 2\nmethod_name: :secure_center\nargs: []\n',NULL,'2018-12-10 09:24:20',NULL,NULL,NULL,NULL,'2018-12-10 09:24:20','2018-12-10 09:24:20');
/*!40000 ALTER TABLE `delayed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `demand_lists`
--

DROP TABLE IF EXISTS `demand_lists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `demand_lists` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `demand_supplier_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=286 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `demand_lists`
--

LOCK TABLES `demand_lists` WRITE;
/*!40000 ALTER TABLE `demand_lists` DISABLE KEYS */;
INSERT INTO `demand_lists` VALUES (1,'Dummy 1','2018-12-02 08:05:19','2018-12-02 08:05:19',1),(2,'Dummy 2','2018-12-02 08:05:25','2018-12-02 08:05:25',1),(3,'Dummy 3','2018-12-02 08:05:28','2018-12-02 08:05:28',1),(4,'+9 SAWABLES LIGHT','2018-12-02 11:51:13','2018-12-02 11:51:13',3),(5,'+11 CLIV/MB LIGHT','2018-12-02 11:51:35','2018-12-02 11:51:35',3),(6,'+11 BLK ST LIGHT','2018-12-02 11:51:49','2018-12-02 11:51:49',3),(7,'+11 REJECTIONS','2018-12-02 11:51:57','2018-12-02 11:51:57',3),(8,'+11 SAWABLES LIGHT','2018-12-02 11:52:08','2018-12-02 11:52:08',3),(9,'Basket +14.8 ct-buffer','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(10,'Collection 5-10 ct','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(11,'Crystals 5-14.8 ct.','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(12,'Fine 5-14.8 ct','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(13,'Col\'d Fine 5-14 ct.','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(14,'Col\'d Crystals 2.5-10ct','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(15,'Coloured 2.5-14.8 ct','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(16,'Commercial 5-14.8 ct','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(17,'Col\'d Commcl 2.5-14.8 ct','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(18,'Spotted Z 5-10 ct','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(19,'Select MB 5-14.8 ct','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(20,'Misc 2.5-10 Ex 3 Col','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(21,'Misc 2.5-10 ct. 4-9 Col','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(22,'Frosted 2.5-10 ct','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(23,'Fancy 2.5-14.8 ct.','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(24,'Fancy MB 2.5-10 ct.','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(25,'Flats 2-10 ct','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(26,'Commons 2.5-10ct','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(27,'Preparers Low 2-10 ct','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(28,'Common Cliv Rej 2-10 ct','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(29,'Prep Cubes -10 ct','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(30,'Prep Cubes -10 ct 1,2,3','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(31,'Prep Cubes -10 ct 4 ,5','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(32,'Clivage H +10.8 ct','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(33,'Brown Gem 2.5-14 ct','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(34,'Common Rej -2 ct','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(35,'Col\'d Cliv/MB +3/10 ct','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(36,'Brn Rej 10ct / +5','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(37,'Collection 2.5-4 ct.','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(38,'Select MB 2.5-4 ct.','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(39,'Col\'d Fine 2.5-4 ct.','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(40,'Commercial 2.5-4','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(41,'Crystals 2.5-4','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(42,'Spotted Z 2.5-4','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(43,'Fine 2.5-4ct','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(44,'Collection Z 4-8grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(45,'Collection Z 8 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(46,'Collection Z 5-6 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(47,'Collection Z 4 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(48,'Crystals 4-8 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(49,'Crystals 8 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(50,'Crystals 5-6 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(51,'Crystals 4 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(52,'Fine Z 4-8grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(53,'Fine Z 8 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(54,'Fine Z 5-6 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(55,'Fine Z 4 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(56,'Spotted Z 4-8 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(57,'Spotted Z 8grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(58,'Spotted Z 5-6grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(59,'Spotted Z 4 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(60,'Cape 4-8 gr.s','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(61,'Cape Z 8 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(62,'Cape Z 5-6grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(63,'Cape Z 4 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(64,'Col\'d Z 4-8 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(65,'Col\'d Z 8 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(66,'Col\'d Z 5-6 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(67,'Col\'d Z 4 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(68,'Lt Brown Z 4-8 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(69,'Lt Brown Z 8 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(70,'Lt Brown Z 5-6 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(71,'Lt Brown Z 4 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(72,'Round Mb 4-8 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(73,'Round Mb 8 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(74,'Round Mb 5-6 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(75,'Round Mb 4 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(76,'Chips 4-8 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(77,'Chips 8 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(78,'Chips 5-6 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(79,'Chips 4 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(80,'Cubes 4-8 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(81,'Cubes 8 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(82,'Cubes 5-6 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(83,'Cubes 4 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(84,'Fancies 4-8 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(85,'Fancies 8 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(86,'Fancies 5-6 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(87,'Fancies 4 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(88,'Frosted Z 4-8 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(89,'Frosted Z 8 grs','2018-12-08 14:12:39','2018-12-08 14:12:39',2),(90,'Frosted Z 5-6 grs','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(91,'Frosted Z 4 grs','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(92,'Mb 4-8 grs ( Maccles)','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(93,'Mb 8 grs ( maccles )','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(94,'Mb 5-6 grs ( maccles )','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(95,'Mb 4 grs ( maccles )','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(96,'2/3 Black Mb 4-8 grs','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(97,'2/3 Black Mb 8 grs (blacks)','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(98,'2/3 Black Mb 5/6 grs (blacks)','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(99,'2/3 Black mb 4 grs (blacks)','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(100,'2/3 Blacks Shaped Mb 4-8 grs.','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(101,'2/3 Black Shaped Mb 8 grs','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(102,'2/3 Black Shaped Mb 5-6 grs','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(103,'2/3 Black Shaped Mb 4 grs','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(104,'3 Col Fancies 4-8 grs','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(105,'3 Col Fancies 8grs','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(106,'3 Col Fancies 5-6 grs','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(107,'3 Col Fancies 4grs','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(108,'1st Brown Mb 4-8 grs','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(109,'1st Brown Mb 8 grs','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(110,'1st Brown Mb 5-6 grs','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(111,'1st Brown Mb 4 grs','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(112,'Indian Clivage 4-8 grs','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(113,'Indian Clivage 8 grs','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(114,'Indian Clivage 5-6 grs','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(115,'Indian Clivage 4 grs','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(116,'1-3 Col Mxd Z 8 grs -3grs (non piq)','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(117,'1-3 COL Mxd Z 8grs ( non piq )','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(118,'1-3 COL Mxd Z 5-6 grs( non piq)','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(119,'1-3 COL Mxd Z 4 grs ( non piq)','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(120,'1-3 COL Mxd Z 3 grs ( non piq)','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(121,'Z 3 grs +7 (mele)','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(122,'Z 3 grs (mele)','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(123,'Z +11 (mele)','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(124,'Z +9 (mele)','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(125,'Z +7 (mele)','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(126,'Z -7','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(127,'Z -7+5','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(128,'Z -5+3','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(129,'Z -3','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(130,'Col\'d Z 3grs +7','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(131,'Col\'d Z 3grs','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(132,'Col\'d Z + 11','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(133,'Col\'d Z -11+9','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(134,'Col\'d Z +7','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(135,'Brown Z -3grs /+7','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(136,'Brown Z 3 grs','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(137,'Brown Z +11','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(138,'Brown Z -11+9','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(139,'Brown Z +7','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(140,'Z / Longs 3grs / +7','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(141,'Z / Longs 3 grs','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(142,'Z / Longs +11','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(143,'Z / Longs -11+9','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(144,'Z / Longs +7','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(145,'Z / Cliv -2 grs+3','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(146,'Z / Cliv +11','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(147,'Z / Cliv 11+9','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(148,'Z / Cliv +7','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(149,'Z / Cliv +5','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(150,'Z / Cliv +3','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(151,'Mb High -3grs +7','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(152,'Mb High 3grs','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(153,'Mb High +11','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(154,'Mb High -11 +9','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(155,'Mb High +7','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(156,'Mb High (-7+3)','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(157,'Mb High -7+5','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(158,'Mb High -5+3','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(159,'Mb (-7+3) Low','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(160,'Mb Low 7-5','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(161,'Mb Low 5-3','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(162,'Cubes -3grs +7','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(163,'Cubes 3 grs','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(164,'Cubes +11','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(165,'Cubes -11+9','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(166,'Cubes +7','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(167,'Indian Flats -3grs','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(168,'Indian Flats 3 grs','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(169,'Indian Flats +11','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(170,'Indian Flats -11+9','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(171,'Indian Flats+7','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(172,'Indian Longs -3grs/+5','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(173,'Indian Longs 3 grs','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(174,'Indian Longs +11','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(175,'Indian Longs -11+9','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(176,'Indian Longs +7','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(177,'Indian Longs +5','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(178,'Mb Clivage -3grs +7','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(179,'Mb Clivage 3 grs','2018-12-08 14:12:40','2018-12-08 14:12:40',2),(180,'Mb Clivage +11','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(181,'Mb Clivage +7','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(182,'Mb Clivage +5','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(183,'Brn Cliv/Mb 3-6 grs','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(184,'Brn Cliv/Mb -3 gr','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(185,'1st Col Rejn (H-L) +11/+7 - abc clivage','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(186,'1st Col Rejns (H-L)-7/+3 -abc clivage','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(187,'Grey Rej +7/3grs','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(188,'Grey Pique','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(189,'Rejn Flats','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(190,'Mixed Rejns','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(191,'Cold&brn 7/5','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(192,'Serie box +3/10cts','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(193,'Col\'d Cliv/Mb -3grs','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(194,'Col\'d Spotted 2.5-10ct','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(195,'Col\'d Select Mb 2.5-10 ct','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(196,'Fancy col\'d fine 2.5-10ct','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(197,'Brown Cliv/Mb 2-10 ct','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(198,'Yellow Brown 2-10 ct','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(199,'Col\'d Crystals 4-8 grs','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(200,'Col\'d Crystals 8 grs','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(201,'Col\'d Crystals 5-6 grs','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(202,'Col\'d Crystals 4 grs','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(203,'Boart','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(204,'Cubes -7+5','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(205,'Frosted Z 3grs / +9','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(206,'Frosted Z 3 grs','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(207,'Frosted Z -2grs /+9','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(208,'Preparers Low 3-6 grs','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(209,'Preparers low lot 1 Mb','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(210,'Preparers low lot 2 cubes','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(211,'Mxd Crystals 3 grs/+5','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(212,'Mxd Crystals 3grs','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(213,'Mxd Crystals +11','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(214,'Mxd Crystals -11+9','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(215,'Mxd Crystals -9+7','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(216,'Mxd Crystals -7+5','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(217,'3 Col Mb 4-8 grs','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(218,'3 Col Mb 8 grs','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(219,'3 Col Mb 5-6 grs','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(220,'3 Col Mb 4 grs','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(221,'3 Col Chips 4-8 grs','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(222,'3 Col Chips 8 grs','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(223,'3 Col Chips 5-6 grs','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(224,'3 Col Chips 4 grs','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(225,'Spotted Crystals 2.5-10 ct.','2018-12-08 14:12:41','2018-12-08 14:12:41',2),(226,'5-10 Cts ST & SHWHITE','2018-12-08 14:15:47','2018-12-08 14:15:47',3),(227,'5-10 Cts ST & SH BRN','2018-12-08 14:15:47','2018-12-08 14:15:47',3),(228,'5-10 Cts REJECTION WHITE','2018-12-08 14:15:47','2018-12-08 14:15:47',3),(229,'5-10 Cts REJECTION BRN','2018-12-08 14:15:47','2018-12-08 14:15:47',3),(230,'5-10 Cts MAC YELL','2018-12-08 14:15:47','2018-12-08 14:15:47',3),(231,'5-10 CTS MAC WHITE','2018-12-08 14:15:47','2018-12-08 14:15:47',3),(232,'5-10 Cts CL WHITE','2018-12-08 14:15:47','2018-12-08 14:15:47',3),(233,'5-10 Cts CL BROWN','2018-12-08 14:15:47','2018-12-08 14:15:47',3),(234,'5-10 Cts BLK MB WHITE','2018-12-08 14:15:47','2018-12-08 14:15:47',3),(235,'5-10 Cts BLK CLIV WHITE','2018-12-08 14:15:47','2018-12-08 14:15:47',3),(236,'5-10 Cts BLACK Z BRN','2018-12-08 14:15:47','2018-12-08 14:15:47',3),(237,'5-10 Cts 5/6 COL BROWN 2','2018-12-08 14:15:47','2018-12-08 14:15:47',3),(238,'5-10 Cts 4BL CLIV&MB WHITE','2018-12-08 14:15:47','2018-12-08 14:15:47',3),(239,'4-6 grs CHIPS','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(240,'4 to 6grs SAWABLES','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(241,'4 to 6grs REJECTION WHITE','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(242,'4 to 6grs MACCLES','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(243,'4 to 6grs BLK Z BRN','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(244,'4 to 6grs BLK MB WHITE','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(245,'4 to 6grs BLK MB BRN','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(246,'4 to 6grs BLK CLIV WHITE','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(247,'4 to 6grs BLACK Z WHITE','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(248,'4 to 6grs 4BL CLIV&MB WHITE','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(249,'4 Cts to 8grs ST & SH YELL','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(250,'4 Cts to 8grs ST & SH BRN','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(251,'4 Cts to 8grs REJECTION WHITE','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(252,'4 Cts to 8grs REJECTION BRN','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(253,'4 Cts to 8grs CL YELLOW','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(254,'4 Cts to 8grs CL WHITE','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(255,'4 Cts to 8grs BLK MB WHITE','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(256,'4 Cts to 8grs BLK CLIV WHITE','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(257,'4 Cts to 8grs 4BL CLIV&MB WHITE','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(258,'4 Cts to 8 grs BLACK Z WHITE','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(259,'3 grs REJECTIONS','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(260,'3 grs MAC LIGHT','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(261,'3 grs CLIV/MB LIGHT','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(262,'3 grs BLK ST LIGHT','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(263,'3 gr SAWABLES LIGHT','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(264,'2grs CLIV/MB LIGHT','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(265,'2 grs REJECTIONS','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(266,'2 grs MAC LIGHT','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(267,'2 grs CH LIGHT','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(268,'2 grs BLK ST LIGHT','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(269,'2 gr SAWABLES LIGHT','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(270,'-9+7 LIGHT I','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(271,'-9+7 LIGHT 2','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(272,'-9+7 DARK','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(273,'-7+6 LIGHT I','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(274,'-7+6 LIGHT 2','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(275,'-7+6 DARK','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(276,'-6+5 LIGHT I','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(277,'-6+5 LIGHT 2','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(278,'-6+5 DARK','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(279,'-5+4 LIGHT','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(280,'-5+4 DARK','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(281,'-4+3 LIGHT','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(282,'-4+3 DARK','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(283,'-11+9 REJECTIONS','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(284,'-11+9 CLIV/MB LIGHT','2018-12-08 14:15:48','2018-12-08 14:15:48',3),(285,'-11+9 BLK ST LIGHT','2018-12-08 14:15:48','2018-12-08 14:15:48',3);
/*!40000 ALTER TABLE `demand_lists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `demand_suppliers`
--

DROP TABLE IF EXISTS `demand_suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `demand_suppliers` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `diamond_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `demand_suppliers`
--

LOCK TABLES `demand_suppliers` WRITE;
/*!40000 ALTER TABLE `demand_suppliers` DISABLE KEYS */;
INSERT INTO `demand_suppliers` VALUES (2,'DTC','2018-12-02 11:49:29','2018-12-05 12:49:40','Sight'),(3,'RUSSIAN','2018-12-02 11:49:35','2018-12-05 12:46:45','Sight'),(4,'OUTSIDE','2018-12-02 11:49:40','2018-12-10 14:52:01','Rough'),(5,'SPECIAL','2018-12-02 11:49:49','2018-12-10 14:52:39','Rough'),(6,'POLISHED','2018-12-10 14:52:50','2018-12-10 14:52:50','Polished');
/*!40000 ALTER TABLE `demand_suppliers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `demands`
--

DROP TABLE IF EXISTS `demands`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `demands` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `weight` float DEFAULT NULL,
  `price` float DEFAULT NULL,
  `company_id` bigint(20) DEFAULT NULL,
  `diamond_type` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `demand_supplier_id` int(11) DEFAULT NULL,
  `block` tinyint(1) DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_demands_on_company_id` (`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `demands`
--

LOCK TABLES `demands` WRITE;
/*!40000 ALTER TABLE `demands` DISABLE KEYS */;
INSERT INTO `demands` VALUES (19,'+9 SAWABLES LIGHT',NULL,NULL,1,NULL,'2018-12-06 07:22:03','2018-12-06 07:22:03',3,0,0),(20,'+11 CLIV/MB LIGHT',NULL,NULL,1,NULL,'2018-12-06 07:22:03','2018-12-06 07:22:03',3,0,0),(21,'+11 BLK ST LIGHT',NULL,NULL,1,NULL,'2018-12-06 07:22:03','2018-12-06 07:22:03',3,0,0),(22,'+11 REJECTIONS',NULL,NULL,1,NULL,'2018-12-06 07:22:03','2018-12-06 07:22:03',3,0,0),(23,'+11 SAWABLES LIGHT',NULL,NULL,1,NULL,'2018-12-06 07:22:03','2018-12-06 07:22:03',3,0,0),(24,'+9 SAWABLES LIGHT',NULL,NULL,2,NULL,'2018-12-06 07:22:57','2018-12-06 07:22:57',3,0,0),(25,'+11 CLIV/MB LIGHT',NULL,NULL,2,NULL,'2018-12-06 07:22:57','2018-12-06 07:22:57',3,0,0),(26,'+11 BLK ST LIGHT',NULL,NULL,2,NULL,'2018-12-06 07:22:57','2018-12-06 07:22:57',3,0,0),(27,'+11 REJECTIONS',NULL,NULL,2,NULL,'2018-12-06 07:22:57','2018-12-06 07:22:57',3,0,0),(28,'+11 SAWABLES LIGHT',NULL,NULL,2,NULL,'2018-12-06 07:22:57','2018-12-06 07:22:57',3,0,0),(29,'+9 SAWABLES LIGHT',NULL,NULL,3,NULL,'2018-12-06 07:23:41','2018-12-06 07:23:41',3,0,0),(30,'+11 CLIV/MB LIGHT',NULL,NULL,3,NULL,'2018-12-06 07:23:41','2018-12-06 07:23:41',3,0,0),(31,'+11 BLK ST LIGHT',NULL,NULL,3,NULL,'2018-12-06 07:23:41','2018-12-06 07:23:41',3,0,0),(32,'+11 REJECTIONS',NULL,NULL,3,NULL,'2018-12-06 07:23:41','2018-12-06 07:23:41',3,0,0),(33,'+11 SAWABLES LIGHT',NULL,NULL,3,NULL,'2018-12-06 07:23:41','2018-12-06 07:23:41',3,0,0),(34,'+9 SAWABLES LIGHT',NULL,NULL,6,NULL,'2018-12-06 08:13:31','2018-12-10 02:22:27',3,0,1),(35,'+11 CLIV/MB LIGHT',NULL,NULL,6,NULL,'2018-12-06 08:13:31','2018-12-10 02:22:31',3,0,1),(36,'+11 BLK ST LIGHT',NULL,NULL,6,NULL,'2018-12-06 08:13:31','2018-12-10 02:22:34',3,0,1),(37,'+11 REJECTIONS',NULL,NULL,6,NULL,'2018-12-06 08:13:31','2018-12-10 02:22:37',3,0,1),(38,'+11 SAWABLES LIGHT',NULL,NULL,6,NULL,'2018-12-06 08:13:31','2018-12-10 02:22:40',3,0,1),(39,'+9 SAWABLES LIGHT',NULL,NULL,5,NULL,'2018-12-06 09:11:30','2018-12-06 09:12:09',3,0,1),(40,'+11 CLIV/MB LIGHT',NULL,NULL,5,NULL,'2018-12-06 09:11:30','2018-12-06 09:12:13',3,0,1),(41,'+11 BLK ST LIGHT',NULL,NULL,5,NULL,'2018-12-06 09:11:30','2018-12-06 09:12:16',3,0,1),(42,'+11 REJECTIONS',NULL,NULL,5,NULL,'2018-12-06 09:11:30','2018-12-06 09:12:21',3,0,1),(43,'+11 SAWABLES LIGHT',NULL,NULL,5,NULL,'2018-12-06 09:11:30','2018-12-06 09:12:25',3,0,1),(44,'Dummy Parcel for Demo',NULL,NULL,7,NULL,'2018-12-06 09:12:48','2018-12-06 09:12:48',2,0,0),(45,'Dummy Parcel for Demo',NULL,NULL,7,NULL,'2018-12-06 09:12:48','2018-12-06 09:12:48',3,0,0),(46,'Dummy Parcel for Demo',NULL,NULL,8,NULL,'2018-12-06 09:12:54','2018-12-06 09:12:54',2,0,0),(47,'Dummy Parcel for Demo',NULL,NULL,8,NULL,'2018-12-06 09:12:54','2018-12-06 09:12:54',3,0,0),(48,'Dummy Parcel for Demo',NULL,NULL,9,NULL,'2018-12-06 09:13:00','2018-12-06 09:13:00',2,0,0),(49,'Dummy Parcel for Demo',NULL,NULL,9,NULL,'2018-12-06 09:13:00','2018-12-06 09:13:00',3,0,0),(50,'Dummy Parcel for Demo',NULL,NULL,10,NULL,'2018-12-06 09:13:08','2018-12-06 09:13:08',2,0,0),(51,'Dummy Parcel for Demo',NULL,NULL,10,NULL,'2018-12-06 09:13:08','2018-12-06 09:13:08',3,0,0),(52,'+9 SAWABLES LIGHT',NULL,NULL,7,NULL,'2018-12-06 17:33:24','2018-12-06 17:33:24',3,0,0),(53,'+11 SAWABLES LIGHT',NULL,NULL,10,NULL,'2018-12-06 17:47:15','2018-12-06 17:47:15',3,0,0),(54,'+11 REJECTIONS',NULL,NULL,10,NULL,'2018-12-06 17:47:15','2018-12-06 17:47:15',3,0,0),(55,'+11 BLK ST LIGHT',NULL,NULL,10,NULL,'2018-12-06 17:47:15','2018-12-06 17:47:15',3,0,0),(56,'+11 CLIV/MB LIGHT',NULL,NULL,8,NULL,'2018-12-08 11:06:33','2018-12-08 11:06:33',3,0,0),(57,'Collection 5-10 ct',NULL,NULL,7,NULL,'2018-12-08 14:29:00','2018-12-08 14:29:00',2,0,0),(58,'-11+9 BLK ST LIGHT',NULL,NULL,3,NULL,'2018-12-10 02:27:13','2018-12-10 02:27:13',3,0,0),(59,'+11 REJECTIONS',NULL,NULL,8,NULL,'2018-12-10 08:20:18','2018-12-10 08:20:18',3,0,0),(60,'+11 REJECTIONS',NULL,NULL,7,NULL,'2018-12-10 08:21:26','2018-12-10 08:21:26',3,0,0),(61,'Collection 5-10 ct',NULL,NULL,8,NULL,'2018-12-10 08:24:09','2018-12-10 08:24:09',2,0,0),(62,'Fine 5-14.8 ct',NULL,NULL,7,NULL,'2018-12-10 08:25:23','2018-12-10 08:25:23',2,0,0),(63,'Col\'d Fine 5-14 ct.',NULL,NULL,7,NULL,'2018-12-10 10:15:33','2018-12-10 10:15:33',2,0,0),(64,'Coloured 2.5-14.8 ct',NULL,NULL,7,NULL,'2018-12-10 14:09:56','2018-12-10 14:09:56',2,0,0),(65,'Collection 5-10 ct',NULL,NULL,9,NULL,'2018-12-10 14:56:24','2018-12-10 14:56:24',2,0,0),(66,'Coloured 2.5-14.8 ct',NULL,NULL,10,NULL,'2018-12-10 14:58:37','2018-12-10 14:58:37',2,0,0),(67,'Fine 5-14.8 ct',NULL,NULL,10,NULL,'2018-12-10 15:23:01','2018-12-10 15:23:01',2,0,0),(68,'Select MB 5-14.8 ct',NULL,NULL,7,NULL,'2018-12-11 08:14:09','2018-12-11 08:14:09',2,0,0),(69,'Collection 5-10 ct',NULL,NULL,10,NULL,'2018-12-11 09:38:16','2018-12-11 09:38:16',2,0,0),(70,'Frosted 2.5-10 ct',NULL,NULL,10,NULL,'2018-12-11 09:42:53','2018-12-11 09:42:53',2,0,0),(71,'Collection 5-10 ct',NULL,NULL,1,NULL,'2018-12-11 11:58:52','2018-12-11 11:58:52',2,0,0);
/*!40000 ALTER TABLE `demands` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `devices`
--

DROP TABLE IF EXISTS `devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `devices` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `customer_id` int(11) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `device_type` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=344 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devices`
--

LOCK TABLES `devices` WRITE;
/*!40000 ALTER TABLE `devices` DISABLE KEYS */;
INSERT INTO `devices` VALUES (1,1,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-03 06:02:05','2018-12-03 06:02:05'),(2,1,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-03 06:02:05','2018-12-03 06:02:05'),(3,1,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-03 06:02:05','2018-12-03 06:02:05'),(4,1,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-03 06:02:05','2018-12-03 06:02:05'),(5,1,'c3DbhgWB4-s:APA91bFAunkcZG6RuR85FQTBxn3LH0Cam_g3J3BO3JkQSqS6tLKKBjy1X3rkHI-d2iDT_F_ZvCyNI2UG68BwwZ37tYp8UBIW-Dszgl5FFvLFIZJ5MKLIuvjVOYnwCsU-bPqyk15U2Z7E','ios','2018-12-03 07:54:22','2018-12-03 07:54:22'),(6,1,'c3DbhgWB4-s:APA91bFAunkcZG6RuR85FQTBxn3LH0Cam_g3J3BO3JkQSqS6tLKKBjy1X3rkHI-d2iDT_F_ZvCyNI2UG68BwwZ37tYp8UBIW-Dszgl5FFvLFIZJ5MKLIuvjVOYnwCsU-bPqyk15U2Z7E','ios','2018-12-03 07:54:22','2018-12-03 07:54:22'),(7,1,'c3DbhgWB4-s:APA91bFAunkcZG6RuR85FQTBxn3LH0Cam_g3J3BO3JkQSqS6tLKKBjy1X3rkHI-d2iDT_F_ZvCyNI2UG68BwwZ37tYp8UBIW-Dszgl5FFvLFIZJ5MKLIuvjVOYnwCsU-bPqyk15U2Z7E','ios','2018-12-03 07:54:22','2018-12-03 07:54:22'),(8,1,'c3DbhgWB4-s:APA91bFAunkcZG6RuR85FQTBxn3LH0Cam_g3J3BO3JkQSqS6tLKKBjy1X3rkHI-d2iDT_F_ZvCyNI2UG68BwwZ37tYp8UBIW-Dszgl5FFvLFIZJ5MKLIuvjVOYnwCsU-bPqyk15U2Z7E','ios','2018-12-03 07:54:22','2018-12-03 07:54:22'),(9,5,'fAgfeF4Daxc:APA91bEIx9QVSAVHX2SlU6mmckpmOEDlyBgpLEkkfHen-AtrhIzRgppnU_tJDL32ubywq83Gi4nRuXOug-7WhkzS8RNVtv-jI0h-OoBOXmU999ZkySB6jYeV5GRZ9KR1idySMuKnhS2c','android','2018-12-03 09:33:03','2018-12-03 09:33:03'),(10,5,'fAgfeF4Daxc:APA91bEIx9QVSAVHX2SlU6mmckpmOEDlyBgpLEkkfHen-AtrhIzRgppnU_tJDL32ubywq83Gi4nRuXOug-7WhkzS8RNVtv-jI0h-OoBOXmU999ZkySB6jYeV5GRZ9KR1idySMuKnhS2c','android','2018-12-03 09:33:03','2018-12-03 09:33:03'),(11,5,'fAgfeF4Daxc:APA91bEIx9QVSAVHX2SlU6mmckpmOEDlyBgpLEkkfHen-AtrhIzRgppnU_tJDL32ubywq83Gi4nRuXOug-7WhkzS8RNVtv-jI0h-OoBOXmU999ZkySB6jYeV5GRZ9KR1idySMuKnhS2c','android','2018-12-03 09:33:03','2018-12-03 09:33:03'),(12,5,'fAgfeF4Daxc:APA91bEIx9QVSAVHX2SlU6mmckpmOEDlyBgpLEkkfHen-AtrhIzRgppnU_tJDL32ubywq83Gi4nRuXOug-7WhkzS8RNVtv-jI0h-OoBOXmU999ZkySB6jYeV5GRZ9KR1idySMuKnhS2c','android','2018-12-03 09:33:04','2018-12-03 09:33:04'),(13,5,'fAgfeF4Daxc:APA91bEIx9QVSAVHX2SlU6mmckpmOEDlyBgpLEkkfHen-AtrhIzRgppnU_tJDL32ubywq83Gi4nRuXOug-7WhkzS8RNVtv-jI0h-OoBOXmU999ZkySB6jYeV5GRZ9KR1idySMuKnhS2c','android','2018-12-03 09:47:59','2018-12-03 09:47:59'),(14,5,'fAgfeF4Daxc:APA91bEIx9QVSAVHX2SlU6mmckpmOEDlyBgpLEkkfHen-AtrhIzRgppnU_tJDL32ubywq83Gi4nRuXOug-7WhkzS8RNVtv-jI0h-OoBOXmU999ZkySB6jYeV5GRZ9KR1idySMuKnhS2c','android','2018-12-03 09:47:59','2018-12-03 09:47:59'),(15,5,'fAgfeF4Daxc:APA91bEIx9QVSAVHX2SlU6mmckpmOEDlyBgpLEkkfHen-AtrhIzRgppnU_tJDL32ubywq83Gi4nRuXOug-7WhkzS8RNVtv-jI0h-OoBOXmU999ZkySB6jYeV5GRZ9KR1idySMuKnhS2c','android','2018-12-03 09:48:00','2018-12-03 09:48:00'),(16,7,'dEbDk5L9BVU:APA91bGWbH_JkdF7WnqB33k0zh2RO4cygpdTuBzgkzFba-DAsFADWl-_C8HBp7-SiNqBpvgqAVQX8LwYdYFEGUQRKNwFsMXoy8iYty6oqjpRICkpDNFoLg-0X7FeQ_ElP3PRC7Tgi7bg','android','2018-12-03 09:49:16','2018-12-03 09:49:16'),(17,7,'dEbDk5L9BVU:APA91bGWbH_JkdF7WnqB33k0zh2RO4cygpdTuBzgkzFba-DAsFADWl-_C8HBp7-SiNqBpvgqAVQX8LwYdYFEGUQRKNwFsMXoy8iYty6oqjpRICkpDNFoLg-0X7FeQ_ElP3PRC7Tgi7bg','android','2018-12-03 09:49:16','2018-12-03 09:49:16'),(18,7,'dEbDk5L9BVU:APA91bGWbH_JkdF7WnqB33k0zh2RO4cygpdTuBzgkzFba-DAsFADWl-_C8HBp7-SiNqBpvgqAVQX8LwYdYFEGUQRKNwFsMXoy8iYty6oqjpRICkpDNFoLg-0X7FeQ_ElP3PRC7Tgi7bg','android','2018-12-03 09:49:16','2018-12-03 09:49:16'),(19,7,'dEbDk5L9BVU:APA91bGWbH_JkdF7WnqB33k0zh2RO4cygpdTuBzgkzFba-DAsFADWl-_C8HBp7-SiNqBpvgqAVQX8LwYdYFEGUQRKNwFsMXoy8iYty6oqjpRICkpDNFoLg-0X7FeQ_ElP3PRC7Tgi7bg','android','2018-12-03 09:49:16','2018-12-03 09:49:16'),(20,5,'fAgfeF4Daxc:APA91bEIx9QVSAVHX2SlU6mmckpmOEDlyBgpLEkkfHen-AtrhIzRgppnU_tJDL32ubywq83Gi4nRuXOug-7WhkzS8RNVtv-jI0h-OoBOXmU999ZkySB6jYeV5GRZ9KR1idySMuKnhS2c','android','2018-12-03 09:52:11','2018-12-03 09:52:11'),(21,5,'fAgfeF4Daxc:APA91bEIx9QVSAVHX2SlU6mmckpmOEDlyBgpLEkkfHen-AtrhIzRgppnU_tJDL32ubywq83Gi4nRuXOug-7WhkzS8RNVtv-jI0h-OoBOXmU999ZkySB6jYeV5GRZ9KR1idySMuKnhS2c','android','2018-12-03 09:52:11','2018-12-03 09:52:11'),(22,5,'fAgfeF4Daxc:APA91bEIx9QVSAVHX2SlU6mmckpmOEDlyBgpLEkkfHen-AtrhIzRgppnU_tJDL32ubywq83Gi4nRuXOug-7WhkzS8RNVtv-jI0h-OoBOXmU999ZkySB6jYeV5GRZ9KR1idySMuKnhS2c','android','2018-12-03 09:52:11','2018-12-03 09:52:11'),(23,5,'d_4mnxPnU9M:APA91bHGOTbla21wdGcqYl76nOlFaDCJ7jk066F6Az6HG4TJ8PfZHjPhf29egYB1oc2RXCJNWV8GSCOEbITThmqZxjRkIf7YXShbs1cc9QFG7EkLxbjrngL9V6TJa9NxYtAMHrTlGuQv','android','2018-12-03 12:44:11','2018-12-03 12:44:11'),(24,5,'d_4mnxPnU9M:APA91bHGOTbla21wdGcqYl76nOlFaDCJ7jk066F6Az6HG4TJ8PfZHjPhf29egYB1oc2RXCJNWV8GSCOEbITThmqZxjRkIf7YXShbs1cc9QFG7EkLxbjrngL9V6TJa9NxYtAMHrTlGuQv','android','2018-12-03 12:44:11','2018-12-03 12:44:11'),(25,5,'d_4mnxPnU9M:APA91bHGOTbla21wdGcqYl76nOlFaDCJ7jk066F6Az6HG4TJ8PfZHjPhf29egYB1oc2RXCJNWV8GSCOEbITThmqZxjRkIf7YXShbs1cc9QFG7EkLxbjrngL9V6TJa9NxYtAMHrTlGuQv','android','2018-12-03 12:44:11','2018-12-03 12:44:11'),(26,5,'duOThz5P2io:APA91bFVrq1IRH9gfzCO_cQPuReFgap1YqVF240usCuq2RmOdv9T1T9LnHPNyXho2Y07tuK08oAc41J7CKwdWZQIVv3EfM5-dluaRDHeE1mVWaaJtVJhs7UuhRdFguZFYvpTB4D4G7Nf','android','2018-12-03 14:21:49','2018-12-03 14:21:49'),(27,5,'duOThz5P2io:APA91bFVrq1IRH9gfzCO_cQPuReFgap1YqVF240usCuq2RmOdv9T1T9LnHPNyXho2Y07tuK08oAc41J7CKwdWZQIVv3EfM5-dluaRDHeE1mVWaaJtVJhs7UuhRdFguZFYvpTB4D4G7Nf','android','2018-12-03 14:21:49','2018-12-03 14:21:49'),(28,5,'duOThz5P2io:APA91bFVrq1IRH9gfzCO_cQPuReFgap1YqVF240usCuq2RmOdv9T1T9LnHPNyXho2Y07tuK08oAc41J7CKwdWZQIVv3EfM5-dluaRDHeE1mVWaaJtVJhs7UuhRdFguZFYvpTB4D4G7Nf','android','2018-12-03 14:21:49','2018-12-03 14:21:49'),(29,5,'duOThz5P2io:APA91bFVrq1IRH9gfzCO_cQPuReFgap1YqVF240usCuq2RmOdv9T1T9LnHPNyXho2Y07tuK08oAc41J7CKwdWZQIVv3EfM5-dluaRDHeE1mVWaaJtVJhs7UuhRdFguZFYvpTB4D4G7Nf','android','2018-12-03 14:21:49','2018-12-03 14:21:49'),(30,5,'cIT8lf9IY6w:APA91bGPKBKumlDI8flC9mg1rtSD7GtH_I0u1GUM-aH32NyMuTAvHuczLl5knpDwDitgQAJXDM-vTDOZciR-ZREIeZjHGEz9U1dNKYD74pixLUEqje6pL5niKX8gJwV-x5viBO3b5OyU','android','2018-12-03 16:24:02','2018-12-03 16:24:02'),(31,5,'cIT8lf9IY6w:APA91bGPKBKumlDI8flC9mg1rtSD7GtH_I0u1GUM-aH32NyMuTAvHuczLl5knpDwDitgQAJXDM-vTDOZciR-ZREIeZjHGEz9U1dNKYD74pixLUEqje6pL5niKX8gJwV-x5viBO3b5OyU','android','2018-12-03 16:24:02','2018-12-03 16:24:02'),(32,5,'cIT8lf9IY6w:APA91bGPKBKumlDI8flC9mg1rtSD7GtH_I0u1GUM-aH32NyMuTAvHuczLl5knpDwDitgQAJXDM-vTDOZciR-ZREIeZjHGEz9U1dNKYD74pixLUEqje6pL5niKX8gJwV-x5viBO3b5OyU','android','2018-12-03 16:24:02','2018-12-03 16:24:02'),(33,5,'cIT8lf9IY6w:APA91bGPKBKumlDI8flC9mg1rtSD7GtH_I0u1GUM-aH32NyMuTAvHuczLl5knpDwDitgQAJXDM-vTDOZciR-ZREIeZjHGEz9U1dNKYD74pixLUEqje6pL5niKX8gJwV-x5viBO3b5OyU','android','2018-12-03 16:24:03','2018-12-03 16:24:03'),(34,5,'dAeXudDiE6E:APA91bHNwy5KWBRrqlgzAmOaOwicaq5zIfYSV7VfXUTROwEenpo2LZiYDJxQpE6HCM0Ri1KNLuYltu1dVi850KWKlUUAWkq6p9joEP2VyOU74Y629YduTiqayS0ERmS3nUUQVOvk47zp','android','2018-12-04 08:38:03','2018-12-04 08:38:03'),(35,5,'dAeXudDiE6E:APA91bHNwy5KWBRrqlgzAmOaOwicaq5zIfYSV7VfXUTROwEenpo2LZiYDJxQpE6HCM0Ri1KNLuYltu1dVi850KWKlUUAWkq6p9joEP2VyOU74Y629YduTiqayS0ERmS3nUUQVOvk47zp','android','2018-12-04 08:38:03','2018-12-04 08:38:03'),(36,5,'dAeXudDiE6E:APA91bHNwy5KWBRrqlgzAmOaOwicaq5zIfYSV7VfXUTROwEenpo2LZiYDJxQpE6HCM0Ri1KNLuYltu1dVi850KWKlUUAWkq6p9joEP2VyOU74Y629YduTiqayS0ERmS3nUUQVOvk47zp','android','2018-12-04 08:38:03','2018-12-04 08:38:03'),(37,5,'dAeXudDiE6E:APA91bHNwy5KWBRrqlgzAmOaOwicaq5zIfYSV7VfXUTROwEenpo2LZiYDJxQpE6HCM0Ri1KNLuYltu1dVi850KWKlUUAWkq6p9joEP2VyOU74Y629YduTiqayS0ERmS3nUUQVOvk47zp','android','2018-12-04 08:38:03','2018-12-04 08:38:03'),(38,6,'dEbDk5L9BVU:APA91bGWbH_JkdF7WnqB33k0zh2RO4cygpdTuBzgkzFba-DAsFADWl-_C8HBp7-SiNqBpvgqAVQX8LwYdYFEGUQRKNwFsMXoy8iYty6oqjpRICkpDNFoLg-0X7FeQ_ElP3PRC7Tgi7bg','android','2018-12-04 16:16:44','2018-12-04 16:16:44'),(39,5,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-05 06:27:22','2018-12-05 06:27:22'),(40,5,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-05 06:27:22','2018-12-05 06:27:22'),(41,5,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-05 06:27:22','2018-12-05 06:27:22'),(42,5,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-05 06:27:22','2018-12-05 06:27:22'),(43,5,'cfdXxR7wofQ:APA91bETNALrek7dJHbNIQthxDpoOUfCqiKDjE4LaqvjnPtSmnCj7QQ3xekPHr1hYIKeIns-33u9RWjsZj_erPt-yIQKvsV7lNuqfZsrtbObrDy97ANDHfIqzr5ASqABMl2NXvhNuM6i','android','2018-12-05 09:24:08','2018-12-05 09:24:08'),(44,5,'cfdXxR7wofQ:APA91bETNALrek7dJHbNIQthxDpoOUfCqiKDjE4LaqvjnPtSmnCj7QQ3xekPHr1hYIKeIns-33u9RWjsZj_erPt-yIQKvsV7lNuqfZsrtbObrDy97ANDHfIqzr5ASqABMl2NXvhNuM6i','android','2018-12-05 09:24:08','2018-12-05 09:24:08'),(45,5,'cfdXxR7wofQ:APA91bETNALrek7dJHbNIQthxDpoOUfCqiKDjE4LaqvjnPtSmnCj7QQ3xekPHr1hYIKeIns-33u9RWjsZj_erPt-yIQKvsV7lNuqfZsrtbObrDy97ANDHfIqzr5ASqABMl2NXvhNuM6i','android','2018-12-05 09:24:08','2018-12-05 09:24:08'),(46,5,'cfdXxR7wofQ:APA91bETNALrek7dJHbNIQthxDpoOUfCqiKDjE4LaqvjnPtSmnCj7QQ3xekPHr1hYIKeIns-33u9RWjsZj_erPt-yIQKvsV7lNuqfZsrtbObrDy97ANDHfIqzr5ASqABMl2NXvhNuM6i','android','2018-12-05 09:24:08','2018-12-05 09:24:08'),(47,6,'ezk3Dsy1dX0:APA91bFgmQecbkmQlGUwWRKn7qklhR3AyNQ5Xi2TqO-G2yy3GvnYCp8jJ4Taca_NhmhE3__XaMhMgI2sPrNw60-dS81HjXxseXrvbWniy6YtatWqGD6rc1LO-hnGt83DhcEZ4tHAuj66','android','2018-12-05 10:15:31','2018-12-05 10:15:31'),(48,6,'ezk3Dsy1dX0:APA91bFgmQecbkmQlGUwWRKn7qklhR3AyNQ5Xi2TqO-G2yy3GvnYCp8jJ4Taca_NhmhE3__XaMhMgI2sPrNw60-dS81HjXxseXrvbWniy6YtatWqGD6rc1LO-hnGt83DhcEZ4tHAuj66','android','2018-12-05 10:15:31','2018-12-05 10:15:31'),(49,6,'ezk3Dsy1dX0:APA91bFgmQecbkmQlGUwWRKn7qklhR3AyNQ5Xi2TqO-G2yy3GvnYCp8jJ4Taca_NhmhE3__XaMhMgI2sPrNw60-dS81HjXxseXrvbWniy6YtatWqGD6rc1LO-hnGt83DhcEZ4tHAuj66','android','2018-12-05 10:15:31','2018-12-05 10:15:31'),(50,6,'ezk3Dsy1dX0:APA91bFgmQecbkmQlGUwWRKn7qklhR3AyNQ5Xi2TqO-G2yy3GvnYCp8jJ4Taca_NhmhE3__XaMhMgI2sPrNw60-dS81HjXxseXrvbWniy6YtatWqGD6rc1LO-hnGt83DhcEZ4tHAuj66','android','2018-12-05 10:15:32','2018-12-05 10:15:32'),(51,5,'eQTVV0RflaI:APA91bGDlkvVCBBuDsJRIgYMt6DJuwo5zgq1Iaq-21xwcPrL_HRg3Q3W0C5HG0K4lGRYT1Q1qxNmd6ZY68XvYq-1jqYdavk0vfpjISJ3BHWp71bJhPVysDXYjPRJjgnNR0KhEEb9GD4w','android','2018-12-05 13:35:38','2018-12-05 13:35:38'),(52,5,'eQTVV0RflaI:APA91bGDlkvVCBBuDsJRIgYMt6DJuwo5zgq1Iaq-21xwcPrL_HRg3Q3W0C5HG0K4lGRYT1Q1qxNmd6ZY68XvYq-1jqYdavk0vfpjISJ3BHWp71bJhPVysDXYjPRJjgnNR0KhEEb9GD4w','android','2018-12-05 13:35:38','2018-12-05 13:35:38'),(53,5,'eQTVV0RflaI:APA91bGDlkvVCBBuDsJRIgYMt6DJuwo5zgq1Iaq-21xwcPrL_HRg3Q3W0C5HG0K4lGRYT1Q1qxNmd6ZY68XvYq-1jqYdavk0vfpjISJ3BHWp71bJhPVysDXYjPRJjgnNR0KhEEb9GD4w','android','2018-12-05 13:35:38','2018-12-05 13:35:38'),(54,5,'c9oti7FDVw8:APA91bGI1JtyU2mZ5UxBnl4FfF10wTQmve-bl0O_J6KE8l_-QWuOi5KZnO4aQEuPBfsSsYA52jIFxyWBdPPthLUYzGCPbZNqpL2iNUVZNBIcl5kFUIC4cxhSoVOg2_POgtj-TFbY1oB3','android','2018-12-05 14:44:35','2018-12-05 14:44:35'),(55,5,'c9oti7FDVw8:APA91bGI1JtyU2mZ5UxBnl4FfF10wTQmve-bl0O_J6KE8l_-QWuOi5KZnO4aQEuPBfsSsYA52jIFxyWBdPPthLUYzGCPbZNqpL2iNUVZNBIcl5kFUIC4cxhSoVOg2_POgtj-TFbY1oB3','android','2018-12-05 14:44:35','2018-12-05 14:44:35'),(56,5,'c9oti7FDVw8:APA91bGI1JtyU2mZ5UxBnl4FfF10wTQmve-bl0O_J6KE8l_-QWuOi5KZnO4aQEuPBfsSsYA52jIFxyWBdPPthLUYzGCPbZNqpL2iNUVZNBIcl5kFUIC4cxhSoVOg2_POgtj-TFbY1oB3','android','2018-12-05 14:44:35','2018-12-05 14:44:35'),(57,5,'c9oti7FDVw8:APA91bGI1JtyU2mZ5UxBnl4FfF10wTQmve-bl0O_J6KE8l_-QWuOi5KZnO4aQEuPBfsSsYA52jIFxyWBdPPthLUYzGCPbZNqpL2iNUVZNBIcl5kFUIC4cxhSoVOg2_POgtj-TFbY1oB3','android','2018-12-05 14:44:35','2018-12-05 14:44:35'),(58,5,'c9oti7FDVw8:APA91bGI1JtyU2mZ5UxBnl4FfF10wTQmve-bl0O_J6KE8l_-QWuOi5KZnO4aQEuPBfsSsYA52jIFxyWBdPPthLUYzGCPbZNqpL2iNUVZNBIcl5kFUIC4cxhSoVOg2_POgtj-TFbY1oB3','android','2018-12-05 14:45:28','2018-12-05 14:45:28'),(59,5,'c9oti7FDVw8:APA91bGI1JtyU2mZ5UxBnl4FfF10wTQmve-bl0O_J6KE8l_-QWuOi5KZnO4aQEuPBfsSsYA52jIFxyWBdPPthLUYzGCPbZNqpL2iNUVZNBIcl5kFUIC4cxhSoVOg2_POgtj-TFbY1oB3','android','2018-12-05 14:45:28','2018-12-05 14:45:28'),(60,5,'c9oti7FDVw8:APA91bGI1JtyU2mZ5UxBnl4FfF10wTQmve-bl0O_J6KE8l_-QWuOi5KZnO4aQEuPBfsSsYA52jIFxyWBdPPthLUYzGCPbZNqpL2iNUVZNBIcl5kFUIC4cxhSoVOg2_POgtj-TFbY1oB3','android','2018-12-05 14:45:29','2018-12-05 14:45:29'),(61,11,'cIstI0z6RQI:APA91bFdDs2MnF8_4MjHK9PDHQqDHJZhVzSR01JJnDEtY5fUCVgRJ1RsSSiln3oGZfVDNEuFxlRz5HlaYqv9miOxQHwmr78AxMiXTB42WSZ_8E28Mh7LNfdsBI9BA-L-OSsngnANR5cf','android','2018-12-06 07:51:34','2018-12-06 07:51:34'),(62,11,'cIstI0z6RQI:APA91bFdDs2MnF8_4MjHK9PDHQqDHJZhVzSR01JJnDEtY5fUCVgRJ1RsSSiln3oGZfVDNEuFxlRz5HlaYqv9miOxQHwmr78AxMiXTB42WSZ_8E28Mh7LNfdsBI9BA-L-OSsngnANR5cf','android','2018-12-06 07:51:34','2018-12-06 07:51:34'),(63,11,'cIstI0z6RQI:APA91bFdDs2MnF8_4MjHK9PDHQqDHJZhVzSR01JJnDEtY5fUCVgRJ1RsSSiln3oGZfVDNEuFxlRz5HlaYqv9miOxQHwmr78AxMiXTB42WSZ_8E28Mh7LNfdsBI9BA-L-OSsngnANR5cf','android','2018-12-06 07:51:34','2018-12-06 07:51:34'),(64,11,'cIstI0z6RQI:APA91bFdDs2MnF8_4MjHK9PDHQqDHJZhVzSR01JJnDEtY5fUCVgRJ1RsSSiln3oGZfVDNEuFxlRz5HlaYqv9miOxQHwmr78AxMiXTB42WSZ_8E28Mh7LNfdsBI9BA-L-OSsngnANR5cf','android','2018-12-06 07:51:35','2018-12-06 07:51:35'),(65,5,'fLrz5lUr2Zk:APA91bELmoQtySvgDNKxq9yY6g8Mqg_a2H4w9y-hI3BktboYWipYC8oDkyAv1gDrZS5A6RT6UOMULceEztYU7eF8LFaQP6a2orumrNWDYcCPiGjyh2YRoh1PYH2LWYOC8IcyhzDwgYic','android','2018-12-06 08:03:48','2018-12-06 08:03:48'),(66,5,'fLrz5lUr2Zk:APA91bELmoQtySvgDNKxq9yY6g8Mqg_a2H4w9y-hI3BktboYWipYC8oDkyAv1gDrZS5A6RT6UOMULceEztYU7eF8LFaQP6a2orumrNWDYcCPiGjyh2YRoh1PYH2LWYOC8IcyhzDwgYic','android','2018-12-06 08:03:48','2018-12-06 08:03:48'),(67,5,'fLrz5lUr2Zk:APA91bELmoQtySvgDNKxq9yY6g8Mqg_a2H4w9y-hI3BktboYWipYC8oDkyAv1gDrZS5A6RT6UOMULceEztYU7eF8LFaQP6a2orumrNWDYcCPiGjyh2YRoh1PYH2LWYOC8IcyhzDwgYic','android','2018-12-06 08:03:48','2018-12-06 08:03:48'),(68,5,'fLrz5lUr2Zk:APA91bELmoQtySvgDNKxq9yY6g8Mqg_a2H4w9y-hI3BktboYWipYC8oDkyAv1gDrZS5A6RT6UOMULceEztYU7eF8LFaQP6a2orumrNWDYcCPiGjyh2YRoh1PYH2LWYOC8IcyhzDwgYic','android','2018-12-06 08:03:48','2018-12-06 08:03:48'),(69,11,'cIstI0z6RQI:APA91bFdDs2MnF8_4MjHK9PDHQqDHJZhVzSR01JJnDEtY5fUCVgRJ1RsSSiln3oGZfVDNEuFxlRz5HlaYqv9miOxQHwmr78AxMiXTB42WSZ_8E28Mh7LNfdsBI9BA-L-OSsngnANR5cf','android','2018-12-06 08:06:05','2018-12-06 08:06:05'),(70,11,'cIstI0z6RQI:APA91bFdDs2MnF8_4MjHK9PDHQqDHJZhVzSR01JJnDEtY5fUCVgRJ1RsSSiln3oGZfVDNEuFxlRz5HlaYqv9miOxQHwmr78AxMiXTB42WSZ_8E28Mh7LNfdsBI9BA-L-OSsngnANR5cf','android','2018-12-06 08:06:05','2018-12-06 08:06:05'),(71,11,'cIstI0z6RQI:APA91bFdDs2MnF8_4MjHK9PDHQqDHJZhVzSR01JJnDEtY5fUCVgRJ1RsSSiln3oGZfVDNEuFxlRz5HlaYqv9miOxQHwmr78AxMiXTB42WSZ_8E28Mh7LNfdsBI9BA-L-OSsngnANR5cf','android','2018-12-06 08:06:05','2018-12-06 08:06:05'),(72,5,'fLrz5lUr2Zk:APA91bELmoQtySvgDNKxq9yY6g8Mqg_a2H4w9y-hI3BktboYWipYC8oDkyAv1gDrZS5A6RT6UOMULceEztYU7eF8LFaQP6a2orumrNWDYcCPiGjyh2YRoh1PYH2LWYOC8IcyhzDwgYic','android','2018-12-06 08:08:03','2018-12-06 08:08:03'),(73,5,'fLrz5lUr2Zk:APA91bELmoQtySvgDNKxq9yY6g8Mqg_a2H4w9y-hI3BktboYWipYC8oDkyAv1gDrZS5A6RT6UOMULceEztYU7eF8LFaQP6a2orumrNWDYcCPiGjyh2YRoh1PYH2LWYOC8IcyhzDwgYic','android','2018-12-06 08:08:04','2018-12-06 08:08:04'),(74,5,'fLrz5lUr2Zk:APA91bELmoQtySvgDNKxq9yY6g8Mqg_a2H4w9y-hI3BktboYWipYC8oDkyAv1gDrZS5A6RT6UOMULceEztYU7eF8LFaQP6a2orumrNWDYcCPiGjyh2YRoh1PYH2LWYOC8IcyhzDwgYic','android','2018-12-06 08:08:04','2018-12-06 08:08:04'),(75,5,'cIstI0z6RQI:APA91bFdDs2MnF8_4MjHK9PDHQqDHJZhVzSR01JJnDEtY5fUCVgRJ1RsSSiln3oGZfVDNEuFxlRz5HlaYqv9miOxQHwmr78AxMiXTB42WSZ_8E28Mh7LNfdsBI9BA-L-OSsngnANR5cf','android','2018-12-06 08:29:25','2018-12-06 08:29:25'),(76,5,'cIstI0z6RQI:APA91bFdDs2MnF8_4MjHK9PDHQqDHJZhVzSR01JJnDEtY5fUCVgRJ1RsSSiln3oGZfVDNEuFxlRz5HlaYqv9miOxQHwmr78AxMiXTB42WSZ_8E28Mh7LNfdsBI9BA-L-OSsngnANR5cf','android','2018-12-06 08:29:25','2018-12-06 08:29:25'),(77,5,'cIstI0z6RQI:APA91bFdDs2MnF8_4MjHK9PDHQqDHJZhVzSR01JJnDEtY5fUCVgRJ1RsSSiln3oGZfVDNEuFxlRz5HlaYqv9miOxQHwmr78AxMiXTB42WSZ_8E28Mh7LNfdsBI9BA-L-OSsngnANR5cf','android','2018-12-06 08:29:26','2018-12-06 08:29:26'),(78,5,'cIstI0z6RQI:APA91bFdDs2MnF8_4MjHK9PDHQqDHJZhVzSR01JJnDEtY5fUCVgRJ1RsSSiln3oGZfVDNEuFxlRz5HlaYqv9miOxQHwmr78AxMiXTB42WSZ_8E28Mh7LNfdsBI9BA-L-OSsngnANR5cf','android','2018-12-06 08:32:53','2018-12-06 08:32:53'),(79,5,'cIstI0z6RQI:APA91bFdDs2MnF8_4MjHK9PDHQqDHJZhVzSR01JJnDEtY5fUCVgRJ1RsSSiln3oGZfVDNEuFxlRz5HlaYqv9miOxQHwmr78AxMiXTB42WSZ_8E28Mh7LNfdsBI9BA-L-OSsngnANR5cf','android','2018-12-06 08:32:53','2018-12-06 08:32:53'),(80,5,'cIstI0z6RQI:APA91bFdDs2MnF8_4MjHK9PDHQqDHJZhVzSR01JJnDEtY5fUCVgRJ1RsSSiln3oGZfVDNEuFxlRz5HlaYqv9miOxQHwmr78AxMiXTB42WSZ_8E28Mh7LNfdsBI9BA-L-OSsngnANR5cf','android','2018-12-06 08:32:53','2018-12-06 08:32:53'),(81,12,'f_tfpFrBJAY:APA91bEagg3pMOZ0bH_y3BQdpGKHWquiSkINphKJhApLoyCrPn1ovl5qA3-bqWOU_ZwHsteGZfp5jOkJyVy_Ac7GMLiUGmgiq2EGtoCWxY0Gy_45uF-rCTOcLYcTEblkDc_ero72yiMx','android','2018-12-06 09:12:05','2018-12-06 09:12:05'),(82,12,'f_tfpFrBJAY:APA91bEagg3pMOZ0bH_y3BQdpGKHWquiSkINphKJhApLoyCrPn1ovl5qA3-bqWOU_ZwHsteGZfp5jOkJyVy_Ac7GMLiUGmgiq2EGtoCWxY0Gy_45uF-rCTOcLYcTEblkDc_ero72yiMx','android','2018-12-06 09:12:05','2018-12-06 09:12:05'),(83,12,'f_tfpFrBJAY:APA91bEagg3pMOZ0bH_y3BQdpGKHWquiSkINphKJhApLoyCrPn1ovl5qA3-bqWOU_ZwHsteGZfp5jOkJyVy_Ac7GMLiUGmgiq2EGtoCWxY0Gy_45uF-rCTOcLYcTEblkDc_ero72yiMx','android','2018-12-06 09:12:05','2018-12-06 09:12:05'),(84,12,'f_tfpFrBJAY:APA91bEagg3pMOZ0bH_y3BQdpGKHWquiSkINphKJhApLoyCrPn1ovl5qA3-bqWOU_ZwHsteGZfp5jOkJyVy_Ac7GMLiUGmgiq2EGtoCWxY0Gy_45uF-rCTOcLYcTEblkDc_ero72yiMx','android','2018-12-06 09:12:05','2018-12-06 09:12:05'),(85,5,'cIstI0z6RQI:APA91bFdDs2MnF8_4MjHK9PDHQqDHJZhVzSR01JJnDEtY5fUCVgRJ1RsSSiln3oGZfVDNEuFxlRz5HlaYqv9miOxQHwmr78AxMiXTB42WSZ_8E28Mh7LNfdsBI9BA-L-OSsngnANR5cf','android','2018-12-06 09:16:58','2018-12-06 09:16:58'),(86,5,'cIstI0z6RQI:APA91bFdDs2MnF8_4MjHK9PDHQqDHJZhVzSR01JJnDEtY5fUCVgRJ1RsSSiln3oGZfVDNEuFxlRz5HlaYqv9miOxQHwmr78AxMiXTB42WSZ_8E28Mh7LNfdsBI9BA-L-OSsngnANR5cf','android','2018-12-06 09:16:58','2018-12-06 09:16:58'),(87,5,'cIstI0z6RQI:APA91bFdDs2MnF8_4MjHK9PDHQqDHJZhVzSR01JJnDEtY5fUCVgRJ1RsSSiln3oGZfVDNEuFxlRz5HlaYqv9miOxQHwmr78AxMiXTB42WSZ_8E28Mh7LNfdsBI9BA-L-OSsngnANR5cf','android','2018-12-06 09:16:58','2018-12-06 09:16:58'),(88,14,'f_tfpFrBJAY:APA91bEagg3pMOZ0bH_y3BQdpGKHWquiSkINphKJhApLoyCrPn1ovl5qA3-bqWOU_ZwHsteGZfp5jOkJyVy_Ac7GMLiUGmgiq2EGtoCWxY0Gy_45uF-rCTOcLYcTEblkDc_ero72yiMx','android','2018-12-06 10:25:53','2018-12-06 10:25:53'),(89,14,'f_tfpFrBJAY:APA91bEagg3pMOZ0bH_y3BQdpGKHWquiSkINphKJhApLoyCrPn1ovl5qA3-bqWOU_ZwHsteGZfp5jOkJyVy_Ac7GMLiUGmgiq2EGtoCWxY0Gy_45uF-rCTOcLYcTEblkDc_ero72yiMx','android','2018-12-06 10:25:53','2018-12-06 10:25:53'),(90,14,'f_tfpFrBJAY:APA91bEagg3pMOZ0bH_y3BQdpGKHWquiSkINphKJhApLoyCrPn1ovl5qA3-bqWOU_ZwHsteGZfp5jOkJyVy_Ac7GMLiUGmgiq2EGtoCWxY0Gy_45uF-rCTOcLYcTEblkDc_ero72yiMx','android','2018-12-06 10:25:53','2018-12-06 10:25:53'),(91,14,'f_tfpFrBJAY:APA91bEagg3pMOZ0bH_y3BQdpGKHWquiSkINphKJhApLoyCrPn1ovl5qA3-bqWOU_ZwHsteGZfp5jOkJyVy_Ac7GMLiUGmgiq2EGtoCWxY0Gy_45uF-rCTOcLYcTEblkDc_ero72yiMx','android','2018-12-06 11:26:49','2018-12-06 11:26:49'),(92,14,'f_tfpFrBJAY:APA91bEagg3pMOZ0bH_y3BQdpGKHWquiSkINphKJhApLoyCrPn1ovl5qA3-bqWOU_ZwHsteGZfp5jOkJyVy_Ac7GMLiUGmgiq2EGtoCWxY0Gy_45uF-rCTOcLYcTEblkDc_ero72yiMx','android','2018-12-06 11:26:49','2018-12-06 11:26:49'),(93,14,'f_tfpFrBJAY:APA91bEagg3pMOZ0bH_y3BQdpGKHWquiSkINphKJhApLoyCrPn1ovl5qA3-bqWOU_ZwHsteGZfp5jOkJyVy_Ac7GMLiUGmgiq2EGtoCWxY0Gy_45uF-rCTOcLYcTEblkDc_ero72yiMx','android','2018-12-06 11:26:49','2018-12-06 11:26:49'),(94,14,'f_tfpFrBJAY:APA91bEagg3pMOZ0bH_y3BQdpGKHWquiSkINphKJhApLoyCrPn1ovl5qA3-bqWOU_ZwHsteGZfp5jOkJyVy_Ac7GMLiUGmgiq2EGtoCWxY0Gy_45uF-rCTOcLYcTEblkDc_ero72yiMx','android','2018-12-06 11:26:50','2018-12-06 11:26:50'),(95,14,'f_tfpFrBJAY:APA91bEagg3pMOZ0bH_y3BQdpGKHWquiSkINphKJhApLoyCrPn1ovl5qA3-bqWOU_ZwHsteGZfp5jOkJyVy_Ac7GMLiUGmgiq2EGtoCWxY0Gy_45uF-rCTOcLYcTEblkDc_ero72yiMx','android','2018-12-06 16:11:18','2018-12-06 16:11:18'),(96,14,'f_tfpFrBJAY:APA91bEagg3pMOZ0bH_y3BQdpGKHWquiSkINphKJhApLoyCrPn1ovl5qA3-bqWOU_ZwHsteGZfp5jOkJyVy_Ac7GMLiUGmgiq2EGtoCWxY0Gy_45uF-rCTOcLYcTEblkDc_ero72yiMx','android','2018-12-06 16:11:18','2018-12-06 16:11:18'),(97,14,'f_tfpFrBJAY:APA91bEagg3pMOZ0bH_y3BQdpGKHWquiSkINphKJhApLoyCrPn1ovl5qA3-bqWOU_ZwHsteGZfp5jOkJyVy_Ac7GMLiUGmgiq2EGtoCWxY0Gy_45uF-rCTOcLYcTEblkDc_ero72yiMx','android','2018-12-06 16:11:22','2018-12-06 16:11:22'),(98,14,'f_tfpFrBJAY:APA91bEagg3pMOZ0bH_y3BQdpGKHWquiSkINphKJhApLoyCrPn1ovl5qA3-bqWOU_ZwHsteGZfp5jOkJyVy_Ac7GMLiUGmgiq2EGtoCWxY0Gy_45uF-rCTOcLYcTEblkDc_ero72yiMx','android','2018-12-06 16:11:22','2018-12-06 16:11:22'),(99,14,'f_tfpFrBJAY:APA91bEagg3pMOZ0bH_y3BQdpGKHWquiSkINphKJhApLoyCrPn1ovl5qA3-bqWOU_ZwHsteGZfp5jOkJyVy_Ac7GMLiUGmgiq2EGtoCWxY0Gy_45uF-rCTOcLYcTEblkDc_ero72yiMx','android','2018-12-06 16:11:27','2018-12-06 16:11:27'),(100,14,'f_tfpFrBJAY:APA91bEagg3pMOZ0bH_y3BQdpGKHWquiSkINphKJhApLoyCrPn1ovl5qA3-bqWOU_ZwHsteGZfp5jOkJyVy_Ac7GMLiUGmgiq2EGtoCWxY0Gy_45uF-rCTOcLYcTEblkDc_ero72yiMx','android','2018-12-06 16:11:27','2018-12-06 16:11:27'),(101,14,'djjtKW11Ipg:APA91bFAKk8x742bi7p09D64bsjiyh1cECOXROqxl2aynLJxHb7pa0Wkhtl2vCqqx1ytZv3VygYiLf2c2G6NXUA-oVoshqbkdlRIIg6UuIqeAUhKVkBkt5vUrbM5oAiGgRd8hBK-Me0R','android','2018-12-06 16:16:27','2018-12-06 16:16:27'),(102,14,'djjtKW11Ipg:APA91bFAKk8x742bi7p09D64bsjiyh1cECOXROqxl2aynLJxHb7pa0Wkhtl2vCqqx1ytZv3VygYiLf2c2G6NXUA-oVoshqbkdlRIIg6UuIqeAUhKVkBkt5vUrbM5oAiGgRd8hBK-Me0R','android','2018-12-06 16:16:27','2018-12-06 16:16:27'),(103,14,'djjtKW11Ipg:APA91bFAKk8x742bi7p09D64bsjiyh1cECOXROqxl2aynLJxHb7pa0Wkhtl2vCqqx1ytZv3VygYiLf2c2G6NXUA-oVoshqbkdlRIIg6UuIqeAUhKVkBkt5vUrbM5oAiGgRd8hBK-Me0R','android','2018-12-06 16:16:27','2018-12-06 16:16:27'),(104,14,'djjtKW11Ipg:APA91bFAKk8x742bi7p09D64bsjiyh1cECOXROqxl2aynLJxHb7pa0Wkhtl2vCqqx1ytZv3VygYiLf2c2G6NXUA-oVoshqbkdlRIIg6UuIqeAUhKVkBkt5vUrbM5oAiGgRd8hBK-Me0R','android','2018-12-06 16:16:27','2018-12-06 16:16:27'),(105,5,'cIstI0z6RQI:APA91bFdDs2MnF8_4MjHK9PDHQqDHJZhVzSR01JJnDEtY5fUCVgRJ1RsSSiln3oGZfVDNEuFxlRz5HlaYqv9miOxQHwmr78AxMiXTB42WSZ_8E28Mh7LNfdsBI9BA-L-OSsngnANR5cf','android','2018-12-06 17:32:33','2018-12-06 17:32:33'),(106,5,'cIstI0z6RQI:APA91bFdDs2MnF8_4MjHK9PDHQqDHJZhVzSR01JJnDEtY5fUCVgRJ1RsSSiln3oGZfVDNEuFxlRz5HlaYqv9miOxQHwmr78AxMiXTB42WSZ_8E28Mh7LNfdsBI9BA-L-OSsngnANR5cf','android','2018-12-06 17:32:33','2018-12-06 17:32:33'),(107,5,'cIstI0z6RQI:APA91bFdDs2MnF8_4MjHK9PDHQqDHJZhVzSR01JJnDEtY5fUCVgRJ1RsSSiln3oGZfVDNEuFxlRz5HlaYqv9miOxQHwmr78AxMiXTB42WSZ_8E28Mh7LNfdsBI9BA-L-OSsngnANR5cf','android','2018-12-06 17:32:34','2018-12-06 17:32:34'),(108,14,'djjtKW11Ipg:APA91bFAKk8x742bi7p09D64bsjiyh1cECOXROqxl2aynLJxHb7pa0Wkhtl2vCqqx1ytZv3VygYiLf2c2G6NXUA-oVoshqbkdlRIIg6UuIqeAUhKVkBkt5vUrbM5oAiGgRd8hBK-Me0R','android','2018-12-06 17:32:47','2018-12-06 17:32:47'),(109,14,'djjtKW11Ipg:APA91bFAKk8x742bi7p09D64bsjiyh1cECOXROqxl2aynLJxHb7pa0Wkhtl2vCqqx1ytZv3VygYiLf2c2G6NXUA-oVoshqbkdlRIIg6UuIqeAUhKVkBkt5vUrbM5oAiGgRd8hBK-Me0R','android','2018-12-06 17:32:47','2018-12-06 17:32:47'),(110,14,'djjtKW11Ipg:APA91bFAKk8x742bi7p09D64bsjiyh1cECOXROqxl2aynLJxHb7pa0Wkhtl2vCqqx1ytZv3VygYiLf2c2G6NXUA-oVoshqbkdlRIIg6UuIqeAUhKVkBkt5vUrbM5oAiGgRd8hBK-Me0R','android','2018-12-06 17:32:47','2018-12-06 17:32:47'),(111,14,'djjtKW11Ipg:APA91bFAKk8x742bi7p09D64bsjiyh1cECOXROqxl2aynLJxHb7pa0Wkhtl2vCqqx1ytZv3VygYiLf2c2G6NXUA-oVoshqbkdlRIIg6UuIqeAUhKVkBkt5vUrbM5oAiGgRd8hBK-Me0R','android','2018-12-06 17:32:47','2018-12-06 17:32:47'),(112,15,'fMl5LiamRF8:APA91bEf--pqEbstVb8eaq-S4fqdnyRVFB7QcMq9OO_VYsdEkXPlco2CoEROAjfaLMuT96sW0AtMjpDNnkAjrNE5sTb5yleIqORStyeyd8ayrIN2KFLlNClp5pylG3WVFROgo7Px_DLp','android','2018-12-06 17:51:03','2018-12-06 17:51:03'),(113,15,'fMl5LiamRF8:APA91bEf--pqEbstVb8eaq-S4fqdnyRVFB7QcMq9OO_VYsdEkXPlco2CoEROAjfaLMuT96sW0AtMjpDNnkAjrNE5sTb5yleIqORStyeyd8ayrIN2KFLlNClp5pylG3WVFROgo7Px_DLp','android','2018-12-06 17:51:03','2018-12-06 17:51:03'),(114,15,'fMl5LiamRF8:APA91bEf--pqEbstVb8eaq-S4fqdnyRVFB7QcMq9OO_VYsdEkXPlco2CoEROAjfaLMuT96sW0AtMjpDNnkAjrNE5sTb5yleIqORStyeyd8ayrIN2KFLlNClp5pylG3WVFROgo7Px_DLp','android','2018-12-06 17:51:03','2018-12-06 17:51:03'),(115,15,'fMl5LiamRF8:APA91bEf--pqEbstVb8eaq-S4fqdnyRVFB7QcMq9OO_VYsdEkXPlco2CoEROAjfaLMuT96sW0AtMjpDNnkAjrNE5sTb5yleIqORStyeyd8ayrIN2KFLlNClp5pylG3WVFROgo7Px_DLp','android','2018-12-06 17:51:04','2018-12-06 17:51:04'),(116,14,'djjtKW11Ipg:APA91bFAKk8x742bi7p09D64bsjiyh1cECOXROqxl2aynLJxHb7pa0Wkhtl2vCqqx1ytZv3VygYiLf2c2G6NXUA-oVoshqbkdlRIIg6UuIqeAUhKVkBkt5vUrbM5oAiGgRd8hBK-Me0R','android','2018-12-06 18:32:51','2018-12-06 18:32:51'),(117,14,'djjtKW11Ipg:APA91bFAKk8x742bi7p09D64bsjiyh1cECOXROqxl2aynLJxHb7pa0Wkhtl2vCqqx1ytZv3VygYiLf2c2G6NXUA-oVoshqbkdlRIIg6UuIqeAUhKVkBkt5vUrbM5oAiGgRd8hBK-Me0R','android','2018-12-06 18:32:51','2018-12-06 18:32:51'),(118,14,'djjtKW11Ipg:APA91bFAKk8x742bi7p09D64bsjiyh1cECOXROqxl2aynLJxHb7pa0Wkhtl2vCqqx1ytZv3VygYiLf2c2G6NXUA-oVoshqbkdlRIIg6UuIqeAUhKVkBkt5vUrbM5oAiGgRd8hBK-Me0R','android','2018-12-06 18:32:52','2018-12-06 18:32:52'),(119,14,'djjtKW11Ipg:APA91bFAKk8x742bi7p09D64bsjiyh1cECOXROqxl2aynLJxHb7pa0Wkhtl2vCqqx1ytZv3VygYiLf2c2G6NXUA-oVoshqbkdlRIIg6UuIqeAUhKVkBkt5vUrbM5oAiGgRd8hBK-Me0R','android','2018-12-07 06:31:37','2018-12-07 06:31:37'),(120,14,'djjtKW11Ipg:APA91bFAKk8x742bi7p09D64bsjiyh1cECOXROqxl2aynLJxHb7pa0Wkhtl2vCqqx1ytZv3VygYiLf2c2G6NXUA-oVoshqbkdlRIIg6UuIqeAUhKVkBkt5vUrbM5oAiGgRd8hBK-Me0R','android','2018-12-07 06:31:37','2018-12-07 06:31:37'),(121,14,'djjtKW11Ipg:APA91bFAKk8x742bi7p09D64bsjiyh1cECOXROqxl2aynLJxHb7pa0Wkhtl2vCqqx1ytZv3VygYiLf2c2G6NXUA-oVoshqbkdlRIIg6UuIqeAUhKVkBkt5vUrbM5oAiGgRd8hBK-Me0R','android','2018-12-07 06:31:37','2018-12-07 06:31:37'),(122,14,'d8-HQxCJ01I:APA91bE7f1LRkpXsNbBoylPQup5vf18xr5uBbehjJxMsjfxR60XhmzxbKBJKiyQFRmxMhDyH-2q6fl2mofndxvBvE2o04h3FV_jXvNk7GeLGrk34Qow8MiaMpxH1OQrMM8H9F-2jvOdL','android','2018-12-07 06:40:24','2018-12-07 06:40:24'),(123,14,'d8-HQxCJ01I:APA91bE7f1LRkpXsNbBoylPQup5vf18xr5uBbehjJxMsjfxR60XhmzxbKBJKiyQFRmxMhDyH-2q6fl2mofndxvBvE2o04h3FV_jXvNk7GeLGrk34Qow8MiaMpxH1OQrMM8H9F-2jvOdL','android','2018-12-07 06:40:24','2018-12-07 06:40:24'),(124,14,'d8-HQxCJ01I:APA91bE7f1LRkpXsNbBoylPQup5vf18xr5uBbehjJxMsjfxR60XhmzxbKBJKiyQFRmxMhDyH-2q6fl2mofndxvBvE2o04h3FV_jXvNk7GeLGrk34Qow8MiaMpxH1OQrMM8H9F-2jvOdL','android','2018-12-07 06:40:24','2018-12-07 06:40:24'),(125,14,'d8-HQxCJ01I:APA91bE7f1LRkpXsNbBoylPQup5vf18xr5uBbehjJxMsjfxR60XhmzxbKBJKiyQFRmxMhDyH-2q6fl2mofndxvBvE2o04h3FV_jXvNk7GeLGrk34Qow8MiaMpxH1OQrMM8H9F-2jvOdL','android','2018-12-07 06:40:25','2018-12-07 06:40:25'),(126,14,'f2IVDr1RAmg:APA91bEb3fjuOfaXOXHeCOpU_wRRHRsB4ieAt1mZTMeQuyypfNherXx5rzELeOZLokfeY_jZ6pSYLyuCq5FzcmbEcjtYQkSKqsIuivQb253S4UViHA4jW73tHtbly5LFdRdjalhHZAl-','android','2018-12-07 10:07:39','2018-12-07 10:07:39'),(127,14,'f2IVDr1RAmg:APA91bEb3fjuOfaXOXHeCOpU_wRRHRsB4ieAt1mZTMeQuyypfNherXx5rzELeOZLokfeY_jZ6pSYLyuCq5FzcmbEcjtYQkSKqsIuivQb253S4UViHA4jW73tHtbly5LFdRdjalhHZAl-','android','2018-12-07 10:07:39','2018-12-07 10:07:39'),(128,14,'f2IVDr1RAmg:APA91bEb3fjuOfaXOXHeCOpU_wRRHRsB4ieAt1mZTMeQuyypfNherXx5rzELeOZLokfeY_jZ6pSYLyuCq5FzcmbEcjtYQkSKqsIuivQb253S4UViHA4jW73tHtbly5LFdRdjalhHZAl-','android','2018-12-07 10:07:39','2018-12-07 10:07:39'),(129,14,'f2IVDr1RAmg:APA91bEb3fjuOfaXOXHeCOpU_wRRHRsB4ieAt1mZTMeQuyypfNherXx5rzELeOZLokfeY_jZ6pSYLyuCq5FzcmbEcjtYQkSKqsIuivQb253S4UViHA4jW73tHtbly5LFdRdjalhHZAl-','android','2018-12-07 10:07:39','2018-12-07 10:07:39'),(130,5,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-07 10:18:06','2018-12-07 10:18:06'),(131,5,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-07 10:18:06','2018-12-07 10:18:06'),(132,5,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-07 10:18:07','2018-12-07 10:18:07'),(133,15,'fMl5LiamRF8:APA91bEf--pqEbstVb8eaq-S4fqdnyRVFB7QcMq9OO_VYsdEkXPlco2CoEROAjfaLMuT96sW0AtMjpDNnkAjrNE5sTb5yleIqORStyeyd8ayrIN2KFLlNClp5pylG3WVFROgo7Px_DLp','android','2018-12-07 12:36:09','2018-12-07 12:36:09'),(134,15,'fMl5LiamRF8:APA91bEf--pqEbstVb8eaq-S4fqdnyRVFB7QcMq9OO_VYsdEkXPlco2CoEROAjfaLMuT96sW0AtMjpDNnkAjrNE5sTb5yleIqORStyeyd8ayrIN2KFLlNClp5pylG3WVFROgo7Px_DLp','android','2018-12-07 12:36:09','2018-12-07 12:36:09'),(135,15,'fMl5LiamRF8:APA91bEf--pqEbstVb8eaq-S4fqdnyRVFB7QcMq9OO_VYsdEkXPlco2CoEROAjfaLMuT96sW0AtMjpDNnkAjrNE5sTb5yleIqORStyeyd8ayrIN2KFLlNClp5pylG3WVFROgo7Px_DLp','android','2018-12-07 12:36:09','2018-12-07 12:36:09'),(136,5,'fMl5LiamRF8:APA91bEf--pqEbstVb8eaq-S4fqdnyRVFB7QcMq9OO_VYsdEkXPlco2CoEROAjfaLMuT96sW0AtMjpDNnkAjrNE5sTb5yleIqORStyeyd8ayrIN2KFLlNClp5pylG3WVFROgo7Px_DLp','android','2018-12-07 12:43:47','2018-12-07 12:43:47'),(137,5,'fMl5LiamRF8:APA91bEf--pqEbstVb8eaq-S4fqdnyRVFB7QcMq9OO_VYsdEkXPlco2CoEROAjfaLMuT96sW0AtMjpDNnkAjrNE5sTb5yleIqORStyeyd8ayrIN2KFLlNClp5pylG3WVFROgo7Px_DLp','android','2018-12-07 12:43:48','2018-12-07 12:43:48'),(138,5,'fMl5LiamRF8:APA91bEf--pqEbstVb8eaq-S4fqdnyRVFB7QcMq9OO_VYsdEkXPlco2CoEROAjfaLMuT96sW0AtMjpDNnkAjrNE5sTb5yleIqORStyeyd8ayrIN2KFLlNClp5pylG3WVFROgo7Px_DLp','android','2018-12-07 12:43:48','2018-12-07 12:43:48'),(139,5,'f2IVDr1RAmg:APA91bEb3fjuOfaXOXHeCOpU_wRRHRsB4ieAt1mZTMeQuyypfNherXx5rzELeOZLokfeY_jZ6pSYLyuCq5FzcmbEcjtYQkSKqsIuivQb253S4UViHA4jW73tHtbly5LFdRdjalhHZAl-','android','2018-12-07 12:45:11','2018-12-07 12:45:11'),(140,5,'f2IVDr1RAmg:APA91bEb3fjuOfaXOXHeCOpU_wRRHRsB4ieAt1mZTMeQuyypfNherXx5rzELeOZLokfeY_jZ6pSYLyuCq5FzcmbEcjtYQkSKqsIuivQb253S4UViHA4jW73tHtbly5LFdRdjalhHZAl-','android','2018-12-07 12:45:11','2018-12-07 12:45:11'),(141,5,'dm9ymTSgYAQ:APA91bHic3IoQUKrS0mxPg4KuLHwcfyAvXvQbAWUgkohPNPC8340SFJD_J7hFvqH4aFrKXh3bzdTL1_QkuqaQff1rL57vC7GOYVxVu_F9IaRSBK0IEjWRcWDJ1Mp0Wmi1kD5daOfIIE8','android','2018-12-07 12:57:32','2018-12-07 12:57:32'),(142,5,'dm9ymTSgYAQ:APA91bHic3IoQUKrS0mxPg4KuLHwcfyAvXvQbAWUgkohPNPC8340SFJD_J7hFvqH4aFrKXh3bzdTL1_QkuqaQff1rL57vC7GOYVxVu_F9IaRSBK0IEjWRcWDJ1Mp0Wmi1kD5daOfIIE8','android','2018-12-07 12:57:32','2018-12-07 12:57:32'),(143,5,'dm9ymTSgYAQ:APA91bHic3IoQUKrS0mxPg4KuLHwcfyAvXvQbAWUgkohPNPC8340SFJD_J7hFvqH4aFrKXh3bzdTL1_QkuqaQff1rL57vC7GOYVxVu_F9IaRSBK0IEjWRcWDJ1Mp0Wmi1kD5daOfIIE8','android','2018-12-07 12:57:32','2018-12-07 12:57:32'),(144,5,'dm9ymTSgYAQ:APA91bHic3IoQUKrS0mxPg4KuLHwcfyAvXvQbAWUgkohPNPC8340SFJD_J7hFvqH4aFrKXh3bzdTL1_QkuqaQff1rL57vC7GOYVxVu_F9IaRSBK0IEjWRcWDJ1Mp0Wmi1kD5daOfIIE8','android','2018-12-07 12:57:32','2018-12-07 12:57:32'),(145,5,'dm9ymTSgYAQ:APA91bHic3IoQUKrS0mxPg4KuLHwcfyAvXvQbAWUgkohPNPC8340SFJD_J7hFvqH4aFrKXh3bzdTL1_QkuqaQff1rL57vC7GOYVxVu_F9IaRSBK0IEjWRcWDJ1Mp0Wmi1kD5daOfIIE8','android','2018-12-07 14:58:13','2018-12-07 14:58:13'),(146,5,'dm9ymTSgYAQ:APA91bHic3IoQUKrS0mxPg4KuLHwcfyAvXvQbAWUgkohPNPC8340SFJD_J7hFvqH4aFrKXh3bzdTL1_QkuqaQff1rL57vC7GOYVxVu_F9IaRSBK0IEjWRcWDJ1Mp0Wmi1kD5daOfIIE8','android','2018-12-07 14:58:13','2018-12-07 14:58:13'),(147,21,'cJGyrbgFHCQ:APA91bFhDwcWxRU6wDsrEr6IgIowiOGmfJi5NTOaf5MXyvDG5W3TfwNs30Fjmpxlz7HrEH7jwL_wpCsz5gai5JiEuJggHydoTiPknK_7QNlBO85kHgtIo9rl6xTaYdhRm86ese46KeIt','ios','2018-12-07 15:02:26','2018-12-07 15:02:26'),(148,21,'cJGyrbgFHCQ:APA91bFhDwcWxRU6wDsrEr6IgIowiOGmfJi5NTOaf5MXyvDG5W3TfwNs30Fjmpxlz7HrEH7jwL_wpCsz5gai5JiEuJggHydoTiPknK_7QNlBO85kHgtIo9rl6xTaYdhRm86ese46KeIt','ios','2018-12-07 15:02:26','2018-12-07 15:02:26'),(149,21,'cJGyrbgFHCQ:APA91bFhDwcWxRU6wDsrEr6IgIowiOGmfJi5NTOaf5MXyvDG5W3TfwNs30Fjmpxlz7HrEH7jwL_wpCsz5gai5JiEuJggHydoTiPknK_7QNlBO85kHgtIo9rl6xTaYdhRm86ese46KeIt','ios','2018-12-07 15:02:26','2018-12-07 15:02:26'),(150,21,'cJGyrbgFHCQ:APA91bFhDwcWxRU6wDsrEr6IgIowiOGmfJi5NTOaf5MXyvDG5W3TfwNs30Fjmpxlz7HrEH7jwL_wpCsz5gai5JiEuJggHydoTiPknK_7QNlBO85kHgtIo9rl6xTaYdhRm86ese46KeIt','ios','2018-12-07 15:02:26','2018-12-07 15:02:26'),(151,5,'dm9ymTSgYAQ:APA91bHic3IoQUKrS0mxPg4KuLHwcfyAvXvQbAWUgkohPNPC8340SFJD_J7hFvqH4aFrKXh3bzdTL1_QkuqaQff1rL57vC7GOYVxVu_F9IaRSBK0IEjWRcWDJ1Mp0Wmi1kD5daOfIIE8','android','2018-12-07 16:49:16','2018-12-07 16:49:16'),(152,5,'dm9ymTSgYAQ:APA91bHic3IoQUKrS0mxPg4KuLHwcfyAvXvQbAWUgkohPNPC8340SFJD_J7hFvqH4aFrKXh3bzdTL1_QkuqaQff1rL57vC7GOYVxVu_F9IaRSBK0IEjWRcWDJ1Mp0Wmi1kD5daOfIIE8','android','2018-12-07 16:49:16','2018-12-07 16:49:16'),(153,5,'dm9ymTSgYAQ:APA91bHic3IoQUKrS0mxPg4KuLHwcfyAvXvQbAWUgkohPNPC8340SFJD_J7hFvqH4aFrKXh3bzdTL1_QkuqaQff1rL57vC7GOYVxVu_F9IaRSBK0IEjWRcWDJ1Mp0Wmi1kD5daOfIIE8','android','2018-12-07 16:49:16','2018-12-07 16:49:16'),(154,5,'fMl5LiamRF8:APA91bEf--pqEbstVb8eaq-S4fqdnyRVFB7QcMq9OO_VYsdEkXPlco2CoEROAjfaLMuT96sW0AtMjpDNnkAjrNE5sTb5yleIqORStyeyd8ayrIN2KFLlNClp5pylG3WVFROgo7Px_DLp','android','2018-12-07 17:06:29','2018-12-07 17:06:29'),(155,5,'fMl5LiamRF8:APA91bEf--pqEbstVb8eaq-S4fqdnyRVFB7QcMq9OO_VYsdEkXPlco2CoEROAjfaLMuT96sW0AtMjpDNnkAjrNE5sTb5yleIqORStyeyd8ayrIN2KFLlNClp5pylG3WVFROgo7Px_DLp','android','2018-12-07 17:06:29','2018-12-07 17:06:29'),(156,5,'fMl5LiamRF8:APA91bEf--pqEbstVb8eaq-S4fqdnyRVFB7QcMq9OO_VYsdEkXPlco2CoEROAjfaLMuT96sW0AtMjpDNnkAjrNE5sTb5yleIqORStyeyd8ayrIN2KFLlNClp5pylG3WVFROgo7Px_DLp','android','2018-12-07 17:06:29','2018-12-07 17:06:29'),(157,5,'dm9ymTSgYAQ:APA91bHic3IoQUKrS0mxPg4KuLHwcfyAvXvQbAWUgkohPNPC8340SFJD_J7hFvqH4aFrKXh3bzdTL1_QkuqaQff1rL57vC7GOYVxVu_F9IaRSBK0IEjWRcWDJ1Mp0Wmi1kD5daOfIIE8','android','2018-12-07 17:20:10','2018-12-07 17:20:10'),(158,5,'dm9ymTSgYAQ:APA91bHic3IoQUKrS0mxPg4KuLHwcfyAvXvQbAWUgkohPNPC8340SFJD_J7hFvqH4aFrKXh3bzdTL1_QkuqaQff1rL57vC7GOYVxVu_F9IaRSBK0IEjWRcWDJ1Mp0Wmi1kD5daOfIIE8','android','2018-12-07 17:20:11','2018-12-07 17:20:11'),(159,5,'dm9ymTSgYAQ:APA91bHic3IoQUKrS0mxPg4KuLHwcfyAvXvQbAWUgkohPNPC8340SFJD_J7hFvqH4aFrKXh3bzdTL1_QkuqaQff1rL57vC7GOYVxVu_F9IaRSBK0IEjWRcWDJ1Mp0Wmi1kD5daOfIIE8','android','2018-12-07 17:20:11','2018-12-07 17:20:11'),(160,5,'dm9ymTSgYAQ:APA91bHic3IoQUKrS0mxPg4KuLHwcfyAvXvQbAWUgkohPNPC8340SFJD_J7hFvqH4aFrKXh3bzdTL1_QkuqaQff1rL57vC7GOYVxVu_F9IaRSBK0IEjWRcWDJ1Mp0Wmi1kD5daOfIIE8','android','2018-12-07 17:37:46','2018-12-07 17:37:46'),(161,5,'dm9ymTSgYAQ:APA91bHic3IoQUKrS0mxPg4KuLHwcfyAvXvQbAWUgkohPNPC8340SFJD_J7hFvqH4aFrKXh3bzdTL1_QkuqaQff1rL57vC7GOYVxVu_F9IaRSBK0IEjWRcWDJ1Mp0Wmi1kD5daOfIIE8','android','2018-12-07 17:37:46','2018-12-07 17:37:46'),(162,5,'dm9ymTSgYAQ:APA91bHic3IoQUKrS0mxPg4KuLHwcfyAvXvQbAWUgkohPNPC8340SFJD_J7hFvqH4aFrKXh3bzdTL1_QkuqaQff1rL57vC7GOYVxVu_F9IaRSBK0IEjWRcWDJ1Mp0Wmi1kD5daOfIIE8','android','2018-12-07 17:37:46','2018-12-07 17:37:46'),(163,5,'dm9ymTSgYAQ:APA91bHic3IoQUKrS0mxPg4KuLHwcfyAvXvQbAWUgkohPNPC8340SFJD_J7hFvqH4aFrKXh3bzdTL1_QkuqaQff1rL57vC7GOYVxVu_F9IaRSBK0IEjWRcWDJ1Mp0Wmi1kD5daOfIIE8','android','2018-12-08 08:00:30','2018-12-08 08:00:30'),(164,5,'dm9ymTSgYAQ:APA91bHic3IoQUKrS0mxPg4KuLHwcfyAvXvQbAWUgkohPNPC8340SFJD_J7hFvqH4aFrKXh3bzdTL1_QkuqaQff1rL57vC7GOYVxVu_F9IaRSBK0IEjWRcWDJ1Mp0Wmi1kD5daOfIIE8','android','2018-12-08 08:00:30','2018-12-08 08:00:30'),(165,5,'dm9ymTSgYAQ:APA91bHic3IoQUKrS0mxPg4KuLHwcfyAvXvQbAWUgkohPNPC8340SFJD_J7hFvqH4aFrKXh3bzdTL1_QkuqaQff1rL57vC7GOYVxVu_F9IaRSBK0IEjWRcWDJ1Mp0Wmi1kD5daOfIIE8','android','2018-12-08 08:00:34','2018-12-08 08:00:34'),(166,5,'dm9ymTSgYAQ:APA91bHic3IoQUKrS0mxPg4KuLHwcfyAvXvQbAWUgkohPNPC8340SFJD_J7hFvqH4aFrKXh3bzdTL1_QkuqaQff1rL57vC7GOYVxVu_F9IaRSBK0IEjWRcWDJ1Mp0Wmi1kD5daOfIIE8','android','2018-12-08 08:00:34','2018-12-08 08:00:34'),(167,5,'e2NwiW2NY4o:APA91bFsM8A4G0FA8E_UBuNtKl23SllRZyoVttqvZ-rhXltrJRpexykR1496J07yespnXKAyrxXwAsNB5i9B-NlPoxmkB7jA1Jfs3AdBl-Ke7eo-TpA2yT0shE2e3T6IAQkuvLtMWBNY','android','2018-12-08 08:06:28','2018-12-08 08:06:28'),(168,5,'e2NwiW2NY4o:APA91bFsM8A4G0FA8E_UBuNtKl23SllRZyoVttqvZ-rhXltrJRpexykR1496J07yespnXKAyrxXwAsNB5i9B-NlPoxmkB7jA1Jfs3AdBl-Ke7eo-TpA2yT0shE2e3T6IAQkuvLtMWBNY','android','2018-12-08 08:06:28','2018-12-08 08:06:28'),(169,5,'e2NwiW2NY4o:APA91bFsM8A4G0FA8E_UBuNtKl23SllRZyoVttqvZ-rhXltrJRpexykR1496J07yespnXKAyrxXwAsNB5i9B-NlPoxmkB7jA1Jfs3AdBl-Ke7eo-TpA2yT0shE2e3T6IAQkuvLtMWBNY','android','2018-12-08 08:06:28','2018-12-08 08:06:28'),(170,5,'fMl5LiamRF8:APA91bEf--pqEbstVb8eaq-S4fqdnyRVFB7QcMq9OO_VYsdEkXPlco2CoEROAjfaLMuT96sW0AtMjpDNnkAjrNE5sTb5yleIqORStyeyd8ayrIN2KFLlNClp5pylG3WVFROgo7Px_DLp','android','2018-12-08 08:07:28','2018-12-08 08:07:28'),(171,5,'fMl5LiamRF8:APA91bEf--pqEbstVb8eaq-S4fqdnyRVFB7QcMq9OO_VYsdEkXPlco2CoEROAjfaLMuT96sW0AtMjpDNnkAjrNE5sTb5yleIqORStyeyd8ayrIN2KFLlNClp5pylG3WVFROgo7Px_DLp','android','2018-12-08 08:07:28','2018-12-08 08:07:28'),(172,5,'fMl5LiamRF8:APA91bEf--pqEbstVb8eaq-S4fqdnyRVFB7QcMq9OO_VYsdEkXPlco2CoEROAjfaLMuT96sW0AtMjpDNnkAjrNE5sTb5yleIqORStyeyd8ayrIN2KFLlNClp5pylG3WVFROgo7Px_DLp','android','2018-12-08 08:07:29','2018-12-08 08:07:29'),(173,5,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-08 08:39:02','2018-12-08 08:39:02'),(174,5,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-08 08:39:02','2018-12-08 08:39:02'),(175,5,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-08 08:39:02','2018-12-08 08:39:02'),(176,5,'e2NwiW2NY4o:APA91bFsM8A4G0FA8E_UBuNtKl23SllRZyoVttqvZ-rhXltrJRpexykR1496J07yespnXKAyrxXwAsNB5i9B-NlPoxmkB7jA1Jfs3AdBl-Ke7eo-TpA2yT0shE2e3T6IAQkuvLtMWBNY','android','2018-12-08 09:03:11','2018-12-08 09:03:11'),(177,5,'e2NwiW2NY4o:APA91bFsM8A4G0FA8E_UBuNtKl23SllRZyoVttqvZ-rhXltrJRpexykR1496J07yespnXKAyrxXwAsNB5i9B-NlPoxmkB7jA1Jfs3AdBl-Ke7eo-TpA2yT0shE2e3T6IAQkuvLtMWBNY','android','2018-12-08 09:03:11','2018-12-08 09:03:11'),(178,5,'e2NwiW2NY4o:APA91bFsM8A4G0FA8E_UBuNtKl23SllRZyoVttqvZ-rhXltrJRpexykR1496J07yespnXKAyrxXwAsNB5i9B-NlPoxmkB7jA1Jfs3AdBl-Ke7eo-TpA2yT0shE2e3T6IAQkuvLtMWBNY','android','2018-12-08 09:03:11','2018-12-08 09:03:11'),(179,5,'e2NwiW2NY4o:APA91bFsM8A4G0FA8E_UBuNtKl23SllRZyoVttqvZ-rhXltrJRpexykR1496J07yespnXKAyrxXwAsNB5i9B-NlPoxmkB7jA1Jfs3AdBl-Ke7eo-TpA2yT0shE2e3T6IAQkuvLtMWBNY','android','2018-12-08 09:46:59','2018-12-08 09:46:59'),(180,5,'e2NwiW2NY4o:APA91bFsM8A4G0FA8E_UBuNtKl23SllRZyoVttqvZ-rhXltrJRpexykR1496J07yespnXKAyrxXwAsNB5i9B-NlPoxmkB7jA1Jfs3AdBl-Ke7eo-TpA2yT0shE2e3T6IAQkuvLtMWBNY','android','2018-12-08 09:46:59','2018-12-08 09:46:59'),(181,5,'e2NwiW2NY4o:APA91bFsM8A4G0FA8E_UBuNtKl23SllRZyoVttqvZ-rhXltrJRpexykR1496J07yespnXKAyrxXwAsNB5i9B-NlPoxmkB7jA1Jfs3AdBl-Ke7eo-TpA2yT0shE2e3T6IAQkuvLtMWBNY','android','2018-12-08 09:46:59','2018-12-08 09:46:59'),(182,5,'fSPjblR_UXQ:APA91bEzNRvhIBPEoRFW8aIR3QgRBHPYeZN8u6XMni9dW5z4F5qVQ89f8I-qOHbRfdkWiXvq9u2htAIYVy_UibrKqStJzK6BGrcr-uz085pYXN_G1K1WlyrE215cZTpRJsvbBvc01O1Z','android','2018-12-08 09:49:40','2018-12-08 09:49:40'),(183,5,'fSPjblR_UXQ:APA91bEzNRvhIBPEoRFW8aIR3QgRBHPYeZN8u6XMni9dW5z4F5qVQ89f8I-qOHbRfdkWiXvq9u2htAIYVy_UibrKqStJzK6BGrcr-uz085pYXN_G1K1WlyrE215cZTpRJsvbBvc01O1Z','android','2018-12-08 09:49:40','2018-12-08 09:49:40'),(184,5,'fSPjblR_UXQ:APA91bEzNRvhIBPEoRFW8aIR3QgRBHPYeZN8u6XMni9dW5z4F5qVQ89f8I-qOHbRfdkWiXvq9u2htAIYVy_UibrKqStJzK6BGrcr-uz085pYXN_G1K1WlyrE215cZTpRJsvbBvc01O1Z','android','2018-12-08 09:49:40','2018-12-08 09:49:40'),(185,5,'fSPjblR_UXQ:APA91bEzNRvhIBPEoRFW8aIR3QgRBHPYeZN8u6XMni9dW5z4F5qVQ89f8I-qOHbRfdkWiXvq9u2htAIYVy_UibrKqStJzK6BGrcr-uz085pYXN_G1K1WlyrE215cZTpRJsvbBvc01O1Z','android','2018-12-08 09:49:40','2018-12-08 09:49:40'),(186,5,'fMl5LiamRF8:APA91bEf--pqEbstVb8eaq-S4fqdnyRVFB7QcMq9OO_VYsdEkXPlco2CoEROAjfaLMuT96sW0AtMjpDNnkAjrNE5sTb5yleIqORStyeyd8ayrIN2KFLlNClp5pylG3WVFROgo7Px_DLp','android','2018-12-08 11:07:15','2018-12-08 11:07:15'),(187,5,'fMl5LiamRF8:APA91bEf--pqEbstVb8eaq-S4fqdnyRVFB7QcMq9OO_VYsdEkXPlco2CoEROAjfaLMuT96sW0AtMjpDNnkAjrNE5sTb5yleIqORStyeyd8ayrIN2KFLlNClp5pylG3WVFROgo7Px_DLp','android','2018-12-08 11:07:15','2018-12-08 11:07:15'),(188,5,'fMl5LiamRF8:APA91bEf--pqEbstVb8eaq-S4fqdnyRVFB7QcMq9OO_VYsdEkXPlco2CoEROAjfaLMuT96sW0AtMjpDNnkAjrNE5sTb5yleIqORStyeyd8ayrIN2KFLlNClp5pylG3WVFROgo7Px_DLp','android','2018-12-08 11:07:15','2018-12-08 11:07:15'),(189,14,'fSPjblR_UXQ:APA91bEzNRvhIBPEoRFW8aIR3QgRBHPYeZN8u6XMni9dW5z4F5qVQ89f8I-qOHbRfdkWiXvq9u2htAIYVy_UibrKqStJzK6BGrcr-uz085pYXN_G1K1WlyrE215cZTpRJsvbBvc01O1Z','android','2018-12-08 11:51:07','2018-12-08 11:51:07'),(190,14,'fSPjblR_UXQ:APA91bEzNRvhIBPEoRFW8aIR3QgRBHPYeZN8u6XMni9dW5z4F5qVQ89f8I-qOHbRfdkWiXvq9u2htAIYVy_UibrKqStJzK6BGrcr-uz085pYXN_G1K1WlyrE215cZTpRJsvbBvc01O1Z','android','2018-12-08 11:51:07','2018-12-08 11:51:07'),(191,14,'fSPjblR_UXQ:APA91bEzNRvhIBPEoRFW8aIR3QgRBHPYeZN8u6XMni9dW5z4F5qVQ89f8I-qOHbRfdkWiXvq9u2htAIYVy_UibrKqStJzK6BGrcr-uz085pYXN_G1K1WlyrE215cZTpRJsvbBvc01O1Z','android','2018-12-08 11:51:07','2018-12-08 11:51:07'),(192,14,'fSPjblR_UXQ:APA91bEzNRvhIBPEoRFW8aIR3QgRBHPYeZN8u6XMni9dW5z4F5qVQ89f8I-qOHbRfdkWiXvq9u2htAIYVy_UibrKqStJzK6BGrcr-uz085pYXN_G1K1WlyrE215cZTpRJsvbBvc01O1Z','android','2018-12-08 11:51:07','2018-12-08 11:51:07'),(193,16,'fSPjblR_UXQ:APA91bEzNRvhIBPEoRFW8aIR3QgRBHPYeZN8u6XMni9dW5z4F5qVQ89f8I-qOHbRfdkWiXvq9u2htAIYVy_UibrKqStJzK6BGrcr-uz085pYXN_G1K1WlyrE215cZTpRJsvbBvc01O1Z','android','2018-12-08 11:54:56','2018-12-08 11:54:56'),(194,16,'fSPjblR_UXQ:APA91bEzNRvhIBPEoRFW8aIR3QgRBHPYeZN8u6XMni9dW5z4F5qVQ89f8I-qOHbRfdkWiXvq9u2htAIYVy_UibrKqStJzK6BGrcr-uz085pYXN_G1K1WlyrE215cZTpRJsvbBvc01O1Z','android','2018-12-08 11:54:56','2018-12-08 11:54:56'),(195,16,'fSPjblR_UXQ:APA91bEzNRvhIBPEoRFW8aIR3QgRBHPYeZN8u6XMni9dW5z4F5qVQ89f8I-qOHbRfdkWiXvq9u2htAIYVy_UibrKqStJzK6BGrcr-uz085pYXN_G1K1WlyrE215cZTpRJsvbBvc01O1Z','android','2018-12-08 11:54:56','2018-12-08 11:54:56'),(196,16,'fSPjblR_UXQ:APA91bEzNRvhIBPEoRFW8aIR3QgRBHPYeZN8u6XMni9dW5z4F5qVQ89f8I-qOHbRfdkWiXvq9u2htAIYVy_UibrKqStJzK6BGrcr-uz085pYXN_G1K1WlyrE215cZTpRJsvbBvc01O1Z','android','2018-12-08 11:54:56','2018-12-08 11:54:56'),(197,14,'fSPjblR_UXQ:APA91bEzNRvhIBPEoRFW8aIR3QgRBHPYeZN8u6XMni9dW5z4F5qVQ89f8I-qOHbRfdkWiXvq9u2htAIYVy_UibrKqStJzK6BGrcr-uz085pYXN_G1K1WlyrE215cZTpRJsvbBvc01O1Z','android','2018-12-08 14:05:11','2018-12-08 14:05:11'),(198,14,'fSPjblR_UXQ:APA91bEzNRvhIBPEoRFW8aIR3QgRBHPYeZN8u6XMni9dW5z4F5qVQ89f8I-qOHbRfdkWiXvq9u2htAIYVy_UibrKqStJzK6BGrcr-uz085pYXN_G1K1WlyrE215cZTpRJsvbBvc01O1Z','android','2018-12-08 14:05:11','2018-12-08 14:05:11'),(199,14,'fSPjblR_UXQ:APA91bEzNRvhIBPEoRFW8aIR3QgRBHPYeZN8u6XMni9dW5z4F5qVQ89f8I-qOHbRfdkWiXvq9u2htAIYVy_UibrKqStJzK6BGrcr-uz085pYXN_G1K1WlyrE215cZTpRJsvbBvc01O1Z','android','2018-12-08 14:05:11','2018-12-08 14:05:11'),(200,14,'fSPjblR_UXQ:APA91bEzNRvhIBPEoRFW8aIR3QgRBHPYeZN8u6XMni9dW5z4F5qVQ89f8I-qOHbRfdkWiXvq9u2htAIYVy_UibrKqStJzK6BGrcr-uz085pYXN_G1K1WlyrE215cZTpRJsvbBvc01O1Z','android','2018-12-08 14:26:55','2018-12-08 14:26:55'),(201,14,'fSPjblR_UXQ:APA91bEzNRvhIBPEoRFW8aIR3QgRBHPYeZN8u6XMni9dW5z4F5qVQ89f8I-qOHbRfdkWiXvq9u2htAIYVy_UibrKqStJzK6BGrcr-uz085pYXN_G1K1WlyrE215cZTpRJsvbBvc01O1Z','android','2018-12-08 14:26:55','2018-12-08 14:26:55'),(202,14,'fSPjblR_UXQ:APA91bEzNRvhIBPEoRFW8aIR3QgRBHPYeZN8u6XMni9dW5z4F5qVQ89f8I-qOHbRfdkWiXvq9u2htAIYVy_UibrKqStJzK6BGrcr-uz085pYXN_G1K1WlyrE215cZTpRJsvbBvc01O1Z','android','2018-12-08 14:26:55','2018-12-08 14:26:55'),(203,14,'fSPjblR_UXQ:APA91bEzNRvhIBPEoRFW8aIR3QgRBHPYeZN8u6XMni9dW5z4F5qVQ89f8I-qOHbRfdkWiXvq9u2htAIYVy_UibrKqStJzK6BGrcr-uz085pYXN_G1K1WlyrE215cZTpRJsvbBvc01O1Z','android','2018-12-08 15:38:50','2018-12-08 15:38:50'),(204,14,'fSPjblR_UXQ:APA91bEzNRvhIBPEoRFW8aIR3QgRBHPYeZN8u6XMni9dW5z4F5qVQ89f8I-qOHbRfdkWiXvq9u2htAIYVy_UibrKqStJzK6BGrcr-uz085pYXN_G1K1WlyrE215cZTpRJsvbBvc01O1Z','android','2018-12-08 15:38:50','2018-12-08 15:38:50'),(205,14,'fSPjblR_UXQ:APA91bEzNRvhIBPEoRFW8aIR3QgRBHPYeZN8u6XMni9dW5z4F5qVQ89f8I-qOHbRfdkWiXvq9u2htAIYVy_UibrKqStJzK6BGrcr-uz085pYXN_G1K1WlyrE215cZTpRJsvbBvc01O1Z','android','2018-12-08 15:38:51','2018-12-08 15:38:51'),(206,5,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-09 08:59:13','2018-12-09 08:59:13'),(207,5,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-09 08:59:13','2018-12-09 08:59:13'),(208,5,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-09 08:59:13','2018-12-09 08:59:13'),(209,14,'e7Ze_altAQ8:APA91bHq3ObPkFsS67xrsFkXIh0oot-cqwEf5EzIrB4d-L-9PNSLwi4Zm3dTTSGH_t1j9lrM-0e2p2oeIHqKVSOXhRxHduisgTdpQ9mcxpPQE6KTtTmOLwox4rlD354dKzwelJD1fECt','android','2018-12-10 07:56:11','2018-12-10 07:56:11'),(210,14,'e7Ze_altAQ8:APA91bHq3ObPkFsS67xrsFkXIh0oot-cqwEf5EzIrB4d-L-9PNSLwi4Zm3dTTSGH_t1j9lrM-0e2p2oeIHqKVSOXhRxHduisgTdpQ9mcxpPQE6KTtTmOLwox4rlD354dKzwelJD1fECt','android','2018-12-10 07:56:11','2018-12-10 07:56:11'),(211,14,'e7Ze_altAQ8:APA91bHq3ObPkFsS67xrsFkXIh0oot-cqwEf5EzIrB4d-L-9PNSLwi4Zm3dTTSGH_t1j9lrM-0e2p2oeIHqKVSOXhRxHduisgTdpQ9mcxpPQE6KTtTmOLwox4rlD354dKzwelJD1fECt','android','2018-12-10 07:56:11','2018-12-10 07:56:11'),(212,14,'e7Ze_altAQ8:APA91bHq3ObPkFsS67xrsFkXIh0oot-cqwEf5EzIrB4d-L-9PNSLwi4Zm3dTTSGH_t1j9lrM-0e2p2oeIHqKVSOXhRxHduisgTdpQ9mcxpPQE6KTtTmOLwox4rlD354dKzwelJD1fECt','android','2018-12-10 07:56:11','2018-12-10 07:56:11'),(213,16,'e7Ze_altAQ8:APA91bHq3ObPkFsS67xrsFkXIh0oot-cqwEf5EzIrB4d-L-9PNSLwi4Zm3dTTSGH_t1j9lrM-0e2p2oeIHqKVSOXhRxHduisgTdpQ9mcxpPQE6KTtTmOLwox4rlD354dKzwelJD1fECt','android','2018-12-10 08:19:58','2018-12-10 08:19:58'),(214,16,'e7Ze_altAQ8:APA91bHq3ObPkFsS67xrsFkXIh0oot-cqwEf5EzIrB4d-L-9PNSLwi4Zm3dTTSGH_t1j9lrM-0e2p2oeIHqKVSOXhRxHduisgTdpQ9mcxpPQE6KTtTmOLwox4rlD354dKzwelJD1fECt','android','2018-12-10 08:19:58','2018-12-10 08:19:58'),(215,16,'e7Ze_altAQ8:APA91bHq3ObPkFsS67xrsFkXIh0oot-cqwEf5EzIrB4d-L-9PNSLwi4Zm3dTTSGH_t1j9lrM-0e2p2oeIHqKVSOXhRxHduisgTdpQ9mcxpPQE6KTtTmOLwox4rlD354dKzwelJD1fECt','android','2018-12-10 08:19:58','2018-12-10 08:19:58'),(216,16,'e7Ze_altAQ8:APA91bHq3ObPkFsS67xrsFkXIh0oot-cqwEf5EzIrB4d-L-9PNSLwi4Zm3dTTSGH_t1j9lrM-0e2p2oeIHqKVSOXhRxHduisgTdpQ9mcxpPQE6KTtTmOLwox4rlD354dKzwelJD1fECt','android','2018-12-10 08:47:30','2018-12-10 08:47:30'),(217,16,'e7Ze_altAQ8:APA91bHq3ObPkFsS67xrsFkXIh0oot-cqwEf5EzIrB4d-L-9PNSLwi4Zm3dTTSGH_t1j9lrM-0e2p2oeIHqKVSOXhRxHduisgTdpQ9mcxpPQE6KTtTmOLwox4rlD354dKzwelJD1fECt','android','2018-12-10 08:47:30','2018-12-10 08:47:30'),(218,16,'e7Ze_altAQ8:APA91bHq3ObPkFsS67xrsFkXIh0oot-cqwEf5EzIrB4d-L-9PNSLwi4Zm3dTTSGH_t1j9lrM-0e2p2oeIHqKVSOXhRxHduisgTdpQ9mcxpPQE6KTtTmOLwox4rlD354dKzwelJD1fECt','android','2018-12-10 08:47:30','2018-12-10 08:47:30'),(219,14,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-10 09:05:46','2018-12-10 09:05:46'),(220,14,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-10 09:05:46','2018-12-10 09:05:46'),(221,14,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-10 09:05:46','2018-12-10 09:05:46'),(222,14,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-10 09:05:46','2018-12-10 09:05:46'),(223,14,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-10 09:17:35','2018-12-10 09:17:35'),(224,14,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-10 09:17:35','2018-12-10 09:17:35'),(225,14,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-10 09:17:35','2018-12-10 09:17:35'),(226,16,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-10 09:39:46','2018-12-10 09:39:46'),(227,16,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-10 09:39:47','2018-12-10 09:39:47'),(228,16,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-10 10:08:11','2018-12-10 10:08:11'),(229,16,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-10 10:08:11','2018-12-10 10:08:11'),(230,16,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-10 10:08:12','2018-12-10 10:08:12'),(231,14,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-10 13:14:42','2018-12-10 13:14:42'),(232,14,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-10 13:14:42','2018-12-10 13:14:42'),(233,14,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-10 13:14:43','2018-12-10 13:14:43'),(234,14,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-10 14:54:35','2018-12-10 14:54:35'),(235,14,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-10 14:54:35','2018-12-10 14:54:35'),(236,14,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-10 14:54:35','2018-12-10 14:54:35'),(237,14,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-10 14:55:00','2018-12-10 14:55:00'),(238,14,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-10 14:55:00','2018-12-10 14:55:00'),(239,14,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-10 14:55:00','2018-12-10 14:55:00'),(240,15,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-10 16:40:56','2018-12-10 16:40:56'),(241,15,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-10 16:40:56','2018-12-10 16:40:56'),(242,15,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-10 16:40:56','2018-12-10 16:40:56'),(243,15,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-10 16:40:56','2018-12-10 16:40:56'),(244,16,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-10 16:46:31','2018-12-10 16:46:31'),(245,16,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-10 16:46:31','2018-12-10 16:46:31'),(246,16,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-10 16:46:31','2018-12-10 16:46:31'),(247,16,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-11 07:57:21','2018-12-11 07:57:21'),(248,16,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-11 07:57:21','2018-12-11 07:57:21'),(249,16,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-11 07:57:21','2018-12-11 07:57:21'),(250,16,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-11 07:57:21','2018-12-11 07:57:21'),(251,16,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-11 08:07:43','2018-12-11 08:07:43'),(252,16,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-11 08:07:43','2018-12-11 08:07:43'),(253,16,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-11 08:07:43','2018-12-11 08:07:43'),(254,17,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-11 09:16:10','2018-12-11 09:16:10'),(255,17,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-11 09:16:10','2018-12-11 09:16:10'),(256,17,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-11 09:16:10','2018-12-11 09:16:10'),(257,5,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-11 11:15:00','2018-12-11 11:15:00'),(258,5,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-11 11:15:00','2018-12-11 11:15:00'),(259,5,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-11 11:15:00','2018-12-11 11:15:00'),(260,17,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-11 11:18:30','2018-12-11 11:18:30'),(261,17,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-11 11:18:30','2018-12-11 11:18:30'),(262,17,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-11 11:18:30','2018-12-11 11:18:30'),(263,14,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-11 12:02:46','2018-12-11 12:02:46'),(264,14,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-11 12:02:46','2018-12-11 12:02:46'),(265,14,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-11 12:02:46','2018-12-11 12:02:46'),(266,14,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-11 12:02:46','2018-12-11 12:02:46'),(267,14,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-11 14:00:08','2018-12-11 14:00:08'),(268,14,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-11 14:00:08','2018-12-11 14:00:08'),(269,14,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-11 14:00:09','2018-12-11 14:00:09'),(270,16,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-11 14:16:14','2018-12-11 14:16:14'),(271,16,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-11 14:16:14','2018-12-11 14:16:14'),(272,16,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-11 14:16:14','2018-12-11 14:16:14'),(273,16,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-11 14:16:14','2018-12-11 14:16:14'),(274,11,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-11 16:13:30','2018-12-11 16:13:30'),(275,11,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-11 16:13:31','2018-12-11 16:13:31'),(276,11,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-11 16:13:31','2018-12-11 16:13:31'),(277,21,'cJGyrbgFHCQ:APA91bFhDwcWxRU6wDsrEr6IgIowiOGmfJi5NTOaf5MXyvDG5W3TfwNs30Fjmpxlz7HrEH7jwL_wpCsz5gai5JiEuJggHydoTiPknK_7QNlBO85kHgtIo9rl6xTaYdhRm86ese46KeIt','ios','2018-12-11 18:11:48','2018-12-11 18:11:48'),(278,21,'cJGyrbgFHCQ:APA91bFhDwcWxRU6wDsrEr6IgIowiOGmfJi5NTOaf5MXyvDG5W3TfwNs30Fjmpxlz7HrEH7jwL_wpCsz5gai5JiEuJggHydoTiPknK_7QNlBO85kHgtIo9rl6xTaYdhRm86ese46KeIt','ios','2018-12-11 18:11:48','2018-12-11 18:11:48'),(279,21,'cJGyrbgFHCQ:APA91bFhDwcWxRU6wDsrEr6IgIowiOGmfJi5NTOaf5MXyvDG5W3TfwNs30Fjmpxlz7HrEH7jwL_wpCsz5gai5JiEuJggHydoTiPknK_7QNlBO85kHgtIo9rl6xTaYdhRm86ese46KeIt','ios','2018-12-11 18:11:48','2018-12-11 18:11:48'),(280,11,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-12 03:02:17','2018-12-12 03:02:17'),(281,11,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-12 03:02:17','2018-12-12 03:02:17'),(282,11,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-12 03:02:17','2018-12-12 03:02:17'),(283,11,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-12 03:02:44','2018-12-12 03:02:44'),(284,11,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-12 03:02:44','2018-12-12 03:02:44'),(285,11,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-12 03:02:44','2018-12-12 03:02:44'),(286,11,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-12 03:49:59','2018-12-12 03:49:59'),(287,11,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-12 03:49:59','2018-12-12 03:49:59'),(288,11,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-12 03:49:59','2018-12-12 03:49:59'),(289,17,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-12 07:47:09','2018-12-12 07:47:09'),(290,17,'e7mT3ia_jMI:APA91bHi7ZgGxPBw9o5Elb_Mh6yiGM3amuz8u-3ZZBW9Nx_ODbsqc0Ll0PtNtqTnj6836qBD0k1KIWGe1tvbBd2mNURhmYa62h65H0NIxiX5xPY61hg1c095yle5GbXNxCdNxotfd3Py','android','2018-12-12 07:47:09','2018-12-12 07:47:09'),(291,7,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 07:50:37','2018-12-12 07:50:37'),(292,7,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 07:50:37','2018-12-12 07:50:37'),(293,7,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 07:50:37','2018-12-12 07:50:37'),(294,7,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 07:50:37','2018-12-12 07:50:37'),(295,6,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 07:55:12','2018-12-12 07:55:12'),(296,6,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 07:55:12','2018-12-12 07:55:12'),(297,6,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 07:55:12','2018-12-12 07:55:12'),(298,6,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 07:55:12','2018-12-12 07:55:12'),(299,6,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 08:44:07','2018-12-12 08:44:07'),(300,6,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 08:44:07','2018-12-12 08:44:07'),(301,6,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 08:44:07','2018-12-12 08:44:07'),(302,7,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 09:18:52','2018-12-12 09:18:52'),(303,7,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 09:18:52','2018-12-12 09:18:52'),(304,7,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 09:18:53','2018-12-12 09:18:53'),(305,4,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 09:35:41','2018-12-12 09:35:41'),(306,4,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 09:35:41','2018-12-12 09:35:41'),(307,4,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 09:35:41','2018-12-12 09:35:41'),(308,4,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 10:11:40','2018-12-12 10:11:40'),(309,4,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 10:11:41','2018-12-12 10:11:41'),(310,4,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 10:11:41','2018-12-12 10:11:41'),(311,7,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 10:22:51','2018-12-12 10:22:51'),(312,7,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 10:22:51','2018-12-12 10:22:51'),(313,7,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 10:22:51','2018-12-12 10:22:51'),(314,7,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 10:22:51','2018-12-12 10:22:51'),(315,11,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 10:36:16','2018-12-12 10:36:16'),(316,11,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 10:36:16','2018-12-12 10:36:16'),(317,11,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 10:36:17','2018-12-12 10:36:17'),(318,11,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 10:39:18','2018-12-12 10:39:18'),(319,11,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 10:39:18','2018-12-12 10:39:18'),(320,11,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 10:39:18','2018-12-12 10:39:18'),(321,7,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 12:45:58','2018-12-12 12:45:58'),(322,7,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 12:45:58','2018-12-12 12:45:58'),(323,7,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 12:46:21','2018-12-12 12:46:21'),(324,7,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 12:46:21','2018-12-12 12:46:21'),(325,7,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 12:46:22','2018-12-12 12:46:22'),(326,4,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 13:10:10','2018-12-12 13:10:10'),(327,4,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 13:10:10','2018-12-12 13:10:10'),(328,4,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 13:10:10','2018-12-12 13:10:10'),(329,4,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 16:07:12','2018-12-12 16:07:12'),(330,4,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 16:07:13','2018-12-12 16:07:13'),(331,4,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 16:07:17','2018-12-12 16:07:17'),(332,4,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 16:07:17','2018-12-12 16:07:17'),(333,4,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 16:07:41','2018-12-12 16:07:41'),(334,4,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 16:07:41','2018-12-12 16:07:41'),(335,4,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 16:08:47','2018-12-12 16:08:47'),(336,4,'eHC6KnTZ8VM:APA91bFostzALoyh39Dv4Pwzgi_hL7XsMpF-3UcOVwNWTQnNuHudu9dWsXfxLVwigHnoAGQaYMXlULWvW6_vnoYYMZYjUFyTcHqbdmJcVFn13cjK6oAZgeIfjlj0r5m8xjuMaZAoioFX','android','2018-12-12 16:08:47','2018-12-12 16:08:47'),(337,16,'ersdGVNH2vM:APA91bG8gDpf6bJrGVx-iuUZ8RA-39qMTV7W3TL-9d7RQoNqm2XN8IKBW9ebz8tTBtMIJv7S4iTo-NS-uKyBjL1cSpnp4aUzelZFv9CoE55kbLkkI_dmpJiqzHzB-ylqjkwlBckQ8CT4','android','2018-12-12 16:10:57','2018-12-12 16:10:57'),(338,16,'ersdGVNH2vM:APA91bG8gDpf6bJrGVx-iuUZ8RA-39qMTV7W3TL-9d7RQoNqm2XN8IKBW9ebz8tTBtMIJv7S4iTo-NS-uKyBjL1cSpnp4aUzelZFv9CoE55kbLkkI_dmpJiqzHzB-ylqjkwlBckQ8CT4','android','2018-12-12 16:10:57','2018-12-12 16:10:57'),(339,16,'ersdGVNH2vM:APA91bG8gDpf6bJrGVx-iuUZ8RA-39qMTV7W3TL-9d7RQoNqm2XN8IKBW9ebz8tTBtMIJv7S4iTo-NS-uKyBjL1cSpnp4aUzelZFv9CoE55kbLkkI_dmpJiqzHzB-ylqjkwlBckQ8CT4','android','2018-12-12 16:10:57','2018-12-12 16:10:57'),(340,16,'ersdGVNH2vM:APA91bG8gDpf6bJrGVx-iuUZ8RA-39qMTV7W3TL-9d7RQoNqm2XN8IKBW9ebz8tTBtMIJv7S4iTo-NS-uKyBjL1cSpnp4aUzelZFv9CoE55kbLkkI_dmpJiqzHzB-ylqjkwlBckQ8CT4','android','2018-12-12 16:10:57','2018-12-12 16:10:57'),(341,11,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-12 16:33:12','2018-12-12 16:33:12'),(342,11,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-12 16:33:12','2018-12-12 16:33:12'),(343,11,'etU2VT3TsXw:APA91bHDk2exOCbIoopzWGlAa6VqbV9jfmphNly_htgWoHQ0-ASuHoKJIoXrNaYOmONV7tK8G55wlZkFAzQ33UaFYQTWEQHFUgniNvaWeh8uLsWu924ti5gU-_D1gmL0-rY6qosB1uB8','ios','2018-12-12 16:33:12','2018-12-12 16:33:12');
/*!40000 ALTER TABLE `devices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_attachments`
--

DROP TABLE IF EXISTS `email_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_attachments` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `file_file_name` varchar(255) DEFAULT NULL,
  `file_content_type` varchar(255) DEFAULT NULL,
  `file_file_size` int(11) DEFAULT NULL,
  `file_updated_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `tender_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_attachments`
--

LOCK TABLES `email_attachments` WRITE;
/*!40000 ALTER TABLE `email_attachments` DISABLE KEYS */;
/*!40000 ALTER TABLE `email_attachments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_templates`
--

DROP TABLE IF EXISTS `email_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `email_templates` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type_of_event` varchar(255) DEFAULT NULL,
  `before_here` varchar(255) DEFAULT NULL,
  `after_here` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_templates`
--

LOCK TABLES `email_templates` WRITE;
/*!40000 ALTER TABLE `email_templates` DISABLE KEYS */;
/*!40000 ALTER TABLE `email_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historical_records`
--

DROP TABLE IF EXISTS `historical_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `historical_records` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `seller_id` int(11) DEFAULT NULL,
  `buyer_id` int(11) DEFAULT NULL,
  `total_limit` int(11) DEFAULT NULL,
  `market_limit` int(11) DEFAULT NULL,
  `overdue_limit` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historical_records`
--

LOCK TABLES `historical_records` WRITE;
/*!40000 ALTER TABLE `historical_records` DISABLE KEYS */;
/*!40000 ALTER TABLE `historical_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `market_buyer_scores`
--

DROP TABLE IF EXISTS `market_buyer_scores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `market_buyer_scores` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `late_payment` float NOT NULL DEFAULT '0',
  `current_risk` float NOT NULL DEFAULT '0',
  `network_diversity` float NOT NULL DEFAULT '0',
  `buyer_network` float NOT NULL DEFAULT '0',
  `due_date` float NOT NULL DEFAULT '0',
  `credit_used` float NOT NULL DEFAULT '0',
  `count_of_credit_given` float NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `actual` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `market_buyer_scores`
--

LOCK TABLES `market_buyer_scores` WRITE;
/*!40000 ALTER TABLE `market_buyer_scores` DISABLE KEYS */;
/*!40000 ALTER TABLE `market_buyer_scores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `market_seller_scores`
--

DROP TABLE IF EXISTS `market_seller_scores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `market_seller_scores` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `late_payment` float NOT NULL DEFAULT '0',
  `current_risk` float NOT NULL DEFAULT '0',
  `network_diversity` float NOT NULL DEFAULT '0',
  `seller_network` float NOT NULL DEFAULT '0',
  `due_date` float NOT NULL DEFAULT '0',
  `credit_used` float NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `actual` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `market_seller_scores`
--

LOCK TABLES `market_seller_scores` WRITE;
/*!40000 ALTER TABLE `market_seller_scores` DISABLE KEYS */;
/*!40000 ALTER TABLE `market_seller_scores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `messages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sender_id` bigint(20) DEFAULT NULL,
  `receiver_id` bigint(20) DEFAULT NULL,
  `message` text,
  `message_type` varchar(255) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `proposal_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_messages_on_sender_id` (`sender_id`),
  KEY `index_messages_on_receiver_id` (`receiver_id`)
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (53,10,7,' </br>For more Details about proposal, <a href=\"/proposals/24\">Click Here</a>','Proposal','You have a new proposal','2018-12-06 10:02:08','2018-12-06 10:02:08',24),(54,7,10,' </br>For more Details about proposal, <a href=\"/proposals/24\">Click Here</a>','Proposal','Seller sent a new proposal.','2018-12-06 10:05:56','2018-12-06 10:05:56',24),(55,10,7,' </br>For more Details about proposal, <a href=\"/proposals/24\">Click Here</a>','Proposal','Buyer sent a new proposal.','2018-12-06 10:28:07','2018-12-06 10:28:07',24),(56,7,8,' </br>For more Details about proposal, <a href=\"/proposals/25\">Click Here</a>','Proposal','You have a new proposal','2018-12-06 17:33:52','2018-12-06 17:33:52',25),(57,10,9,' </br>For more Details about proposal, <a href=\"/proposals/26\">Click Here</a>','Proposal','You have a new proposal','2018-12-06 17:47:36','2018-12-06 17:47:36',26),(58,10,9,' </br>For more Details about proposal, <a href=\"/proposals/27\">Click Here</a>','Proposal','You have a new proposal','2018-12-06 17:47:40','2018-12-06 17:47:40',27),(59,10,9,' </br>For more Details about proposal, <a href=\"/proposals/28\">Click Here</a>','Proposal','You have a new proposal','2018-12-06 17:47:43','2018-12-06 17:47:43',28),(60,2,5,' </br>For more Details about proposal, <a href=\"/proposals/29\">Click Here</a>','Proposal','You have a new proposal','2018-12-06 23:53:44','2018-12-06 23:53:44',29),(61,1,4,' </br>For more Details about proposal, <a href=\"/proposals/30\">Click Here</a>','Proposal','You have a new proposal','2018-12-07 11:49:20','2018-12-07 11:49:20',30),(62,3,5,' </br>For more Details about proposal, <a href=\"/proposals/31\">Click Here</a>','Proposal','You have a new proposal','2018-12-07 12:11:21','2018-12-07 12:11:21',31),(63,7,8,'fjtdub </br>For more Details about proposal, <a href=\"/proposals/32\">Click Here</a>','Proposal','You have a new proposal','2018-12-08 11:57:10','2018-12-08 11:57:10',32),(64,7,8,' </br>For more Details about proposal, <a href=\"/proposals/33\">Click Here</a>','Proposal','You have a new proposal','2018-12-08 12:07:26','2018-12-08 12:07:26',33),(65,8,7,'The deal is accepted.','Proposal','Your proposal is accepted.','2018-12-08 12:07:56','2018-12-08 12:07:56',33),(66,7,8,' </br>For more Details about proposal, <a href=\"/proposals/34\">Click Here</a>','Proposal','You have a new proposal','2018-12-08 12:09:55','2018-12-08 12:09:55',34),(67,8,7,'The deal is accepted.','Proposal','Your proposal is accepted.','2018-12-08 12:10:09','2018-12-08 12:10:09',34),(68,7,8,'fugjhgjbybuh </br>For more Details about proposal, <a href=\"/proposals/35\">Click Here</a>','Proposal','You have a new proposal','2018-12-08 14:10:47','2018-12-08 14:10:47',35),(69,7,8,' </br>For more Details about proposal, <a href=\"/proposals/36\">Click Here</a>','Proposal','You have a new proposal','2018-12-08 14:29:05','2018-12-08 14:29:05',36),(70,3,6,' </br>For more Details about proposal, <a href=\"/proposals/37\">Click Here</a>','Proposal','You have a new proposal','2018-12-10 02:31:24','2018-12-10 02:31:24',37),(71,6,3,' </br>For more Details about proposal, <a href=\"/proposals/37\">Click Here</a>','Proposal','Seller sent a new proposal.','2018-12-10 02:32:27','2018-12-10 02:32:27',37),(72,3,5,' </br>For more Details about proposal, <a href=\"/proposals/38\">Click Here</a>','Proposal','You have a new proposal','2018-12-10 07:59:08','2018-12-10 07:59:08',38),(73,7,9,' </br>For more Details about proposal, <a href=\"/proposals/39\">Click Here</a>','Proposal','You have a new proposal','2018-12-10 08:23:19','2018-12-10 08:23:19',39),(74,7,8,' </br>For more Details about proposal, <a href=\"/proposals/40\">Click Here</a>','Proposal','You have a new proposal','2018-12-10 08:25:47','2018-12-10 08:25:47',40),(75,5,3,' </br>For more Details about proposal, <a href=\"/proposals/38\">Click Here</a>','Proposal','Seller sent a new proposal.','2018-12-10 09:23:02','2018-12-10 09:23:02',38),(76,7,8,' </br>For more Details about proposal, <a href=\"/proposals/41\">Click Here</a>','Proposal','You have a new proposal','2018-12-10 10:11:32','2018-12-10 10:11:32',41),(77,8,7,'The deal is accepted.','Proposal','Your proposal is accepted.','2018-12-10 10:12:24','2018-12-10 10:12:24',41),(78,7,8,' </br>For more Details about proposal, <a href=\"/proposals/42\">Click Here</a>','Proposal','You have a new proposal','2018-12-10 10:15:37','2018-12-10 10:15:37',42),(79,8,7,'The deal is accepted.','Proposal','Your proposal is accepted.','2018-12-10 10:16:01','2018-12-10 10:16:01',42),(80,7,8,' </br>For more Details about proposal, <a href=\"/proposals/43\">Click Here</a>','Proposal','You have a new proposal','2018-12-10 14:10:08','2018-12-10 14:10:08',43),(81,8,7,' </br>For more Details about proposal, <a href=\"/proposals/43\">Click Here</a>','Proposal','Seller sent a new proposal.','2018-12-10 14:10:54','2018-12-10 14:10:54',43),(82,10,8,' </br>For more Details about proposal, <a href=\"/proposals/44\">Click Here</a>','Proposal','You have a new proposal','2018-12-10 14:57:59','2018-12-10 14:57:59',44),(83,8,10,'The deal is accepted.','Proposal','Your proposal is accepted.','2018-12-10 14:58:11','2018-12-10 14:58:11',44),(84,10,9,' </br>For more Details about proposal, <a href=\"/proposals/45\">Click Here</a>','Proposal','You have a new proposal','2018-12-10 14:59:02','2018-12-10 14:59:02',45),(85,9,10,'The deal is accepted.','Proposal','Your proposal is accepted.','2018-12-10 14:59:54','2018-12-10 14:59:54',45),(86,9,10,'The deal is accepted.','Proposal','Your proposal is accepted.','2018-12-10 15:21:41','2018-12-10 15:21:41',28),(87,10,9,' </br>For more Details about proposal, <a href=\"/proposals/46\">Click Here</a>','Proposal','You have a new proposal','2018-12-10 15:23:14','2018-12-10 15:23:14',46),(88,9,10,'The deal is accepted.','Proposal','Your proposal is accepted.','2018-12-10 15:25:27','2018-12-10 15:25:27',46),(89,10,8,' </br>For more Details about proposal, <a href=\"/proposals/47\">Click Here</a>','Proposal','You have a new proposal','2018-12-10 16:41:10','2018-12-10 16:41:10',47),(90,8,10,'The deal is accepted.','Proposal','Your proposal is accepted.','2018-12-10 16:41:52','2018-12-10 16:41:52',47),(91,7,8,' </br>For more Details about proposal, <a href=\"/proposals/48\">Click Here</a>','Proposal','You have a new proposal','2018-12-11 08:14:28','2018-12-11 08:14:28',48),(92,8,7,'The deal is accepted.','Proposal','Your proposal is accepted.','2018-12-11 08:15:12','2018-12-11 08:15:12',48),(93,10,5,' </br>For more Details about proposal, <a href=\"/proposals/49\">Click Here</a>','Proposal','You have a new proposal','2018-12-11 09:38:33','2018-12-11 09:38:33',49),(94,10,5,' </br>For more Details about proposal, <a href=\"/proposals/50\">Click Here</a>','Proposal','You have a new proposal','2018-12-11 09:43:00','2018-12-11 09:43:00',50),(95,10,9,' </br>For more Details about proposal, <a href=\"/proposals/51\">Click Here</a>','Proposal','You have a new proposal','2018-12-11 09:49:36','2018-12-11 09:49:36',51),(96,6,3,'The deal is accepted.','Proposal','Your proposal is accepted.','2018-12-12 02:19:42','2018-12-12 02:19:42',37),(97,3,6,'The deal is accepted.','Proposal','Buyer accepted your negotiated proposal.','2018-12-12 02:19:43','2018-12-12 02:19:43',37),(98,3,5,' </br>For more Details about proposal, <a href=\"/proposals/52\">Click Here</a>','Proposal','You have a new proposal','2018-12-12 10:40:29','2018-12-12 10:40:29',52),(99,3,5,' </br>For more Details about proposal, <a href=\"/proposals/53\">Click Here</a>','Proposal','You have a new proposal','2018-12-12 10:40:38','2018-12-12 10:40:38',53),(100,3,5,' </br>For more Details about proposal, <a href=\"/proposals/54\">Click Here</a>','Proposal','You have a new proposal','2018-12-12 10:40:51','2018-12-12 10:40:51',54),(101,5,3,' </br>For more Details about proposal, <a href=\"/proposals/54\">Click Here</a>','Proposal','Seller sent a new proposal.','2018-12-12 10:42:22','2018-12-12 10:42:22',54),(102,3,4,' </br>For more Details about proposal, <a href=\"/proposals/55\">Click Here</a>','Proposal','You have a new proposal','2018-12-12 13:10:28','2018-12-12 13:10:28',55),(103,3,4,' </br>For more Details about proposal, <a href=\"/proposals/56\">Click Here</a>','Proposal','You have a new proposal','2018-12-12 13:11:15','2018-12-12 13:11:15',56),(104,3,5,' </br>For more Details about proposal, <a href=\"/proposals/54\">Click Here</a>','Proposal','Buyer sent a new proposal.','2018-12-12 18:38:59','2018-12-12 18:38:59',54);
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `negotiations`
--

DROP TABLE IF EXISTS `negotiations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `negotiations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `proposal_id` bigint(20) DEFAULT NULL,
  `percent` float DEFAULT NULL,
  `credit` int(11) DEFAULT NULL,
  `price` float DEFAULT NULL,
  `total_value` float DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL,
  `from` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_negotiations_on_proposal_id` (`proposal_id`),
  CONSTRAINT `fk_rails_b5a9a23046` FOREIGN KEY (`proposal_id`) REFERENCES `proposals` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `negotiations`
--

LOCK TABLES `negotiations` WRITE;
/*!40000 ALTER TABLE `negotiations` DISABLE KEYS */;
INSERT INTO `negotiations` VALUES (45,24,10,20,3300,3300,'',0,'2018-12-06 10:02:08','2018-12-06 10:02:08'),(46,24,10,20,3300,3300,'',1,'2018-12-06 10:05:56','2018-12-06 10:05:56'),(47,24,13.333,20,3400,3400,'',0,'2018-12-06 10:28:07','2018-12-06 10:34:07'),(48,25,10,15,3300,3300,'',0,'2018-12-06 17:33:52','2018-12-06 17:33:52'),(49,26,0,30,15,1500,'',0,'2018-12-06 17:47:36','2018-12-06 17:47:36'),(50,27,0,60,20,4000,'',0,'2018-12-06 17:47:40','2018-12-06 17:47:40'),(51,28,0,60,30,9000,'',0,'2018-12-06 17:47:43','2018-12-06 17:47:43'),(52,29,0,30,175,18025,'',0,'2018-12-06 23:53:44','2018-12-06 23:53:44'),(53,30,0,30,175,14000,'',0,'2018-12-07 11:49:20','2018-12-07 11:49:20'),(54,31,0,75,199,21890,'',0,'2018-12-07 12:11:21','2018-12-07 12:11:21'),(55,32,80,80,90,4500,'okay fine',0,'2018-12-08 11:57:10','2018-12-08 11:57:10'),(56,33,34,343,45.56,1549.04,'',0,'2018-12-08 12:07:26','2018-12-08 12:07:26'),(57,34,34,34,45.56,1549.04,'',0,'2018-12-08 12:09:55','2018-12-08 12:09:55'),(58,35,5,558,5.25,26.25,'proposql',0,'2018-12-08 14:10:47','2018-12-08 14:10:47'),(59,36,10,20,3300,3300,'',0,'2018-12-08 14:29:05','2018-12-08 14:29:05'),(60,37,7,60,160.5,32100,'',0,'2018-12-10 02:31:24','2018-12-10 02:31:24'),(61,37,10,60,165,33000,'',1,'2018-12-10 02:32:27','2018-12-10 02:32:27'),(62,38,0,90,195,20475,'',0,'2018-12-10 07:59:08','2018-12-10 07:59:08'),(63,39,0,60,20,4000,'',0,'2018-12-10 08:23:19','2018-12-10 08:23:19'),(64,40,10,20,3300,3300,'',0,'2018-12-10 08:25:47','2018-12-10 08:25:47'),(65,38,0,90,195,20475,'',1,'2018-12-10 09:23:02','2018-12-10 09:23:02'),(66,41,10,20,3300,3300,'',0,'2018-12-10 10:11:32','2018-12-10 10:11:32'),(67,42,10,20,3300,3300,'',0,'2018-12-10 10:15:37','2018-12-10 10:15:37'),(68,43,10,20,3300,3300,'',0,'2018-12-10 14:10:08','2018-12-10 14:10:08'),(69,43,6.667,20,3200,3200,'',1,'2018-12-10 14:10:54','2018-12-10 14:15:01'),(70,44,23,23,28.29,649.26,'this is testing',0,'2018-12-10 14:57:59','2018-12-10 14:57:59'),(71,45,10,15,3300,3300,'',0,'2018-12-10 14:59:02','2018-12-10 14:59:02'),(72,46,10,15,3300,3300,'',0,'2018-12-10 15:23:14','2018-12-10 15:23:14'),(73,47,10,20,3300,3300,'',0,'2018-12-10 16:41:10','2018-12-10 16:41:10'),(74,48,3000,20,5000,5000,'',0,'2018-12-11 08:14:28','2018-12-11 08:14:28'),(75,49,10,15,3000,3000,'',0,'2018-12-11 09:38:33','2018-12-11 09:38:33'),(76,50,10,15,3000,3000,'',0,'2018-12-11 09:43:00','2018-12-11 09:43:00'),(77,51,10,20,4000,4000,'',0,'2018-12-11 09:49:36','2018-12-11 09:49:36'),(78,52,0,90,200,21000,'',0,'2018-12-12 10:40:29','2018-12-12 10:40:29'),(79,53,0,90,200,21000,'',0,'2018-12-12 10:40:38','2018-12-12 10:40:38'),(80,54,0,90,205,21525,'',0,'2018-12-12 10:40:51','2018-12-12 10:40:51'),(81,54,0,90,195,20475,'',1,'2018-12-12 10:42:22','2018-12-12 10:42:22'),(82,55,0,60,200,17000,'',0,'2018-12-12 13:10:28','2018-12-12 13:10:28'),(83,56,0,60,200,17000,'',0,'2018-12-12 13:11:15','2018-12-12 13:11:15'),(84,54,0,90,215,22575,'',0,'2018-12-12 18:38:59','2018-12-12 18:52:35');
/*!40000 ALTER TABLE `negotiations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `news` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `url` text,
  `date` datetime DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `description` text,
  `status` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news`
--

LOCK TABLES `news` WRITE;
/*!40000 ALTER TABLE `news` DISABLE KEYS */;
/*!40000 ALTER TABLE `news` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notes`
--

DROP TABLE IF EXISTS `notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notes` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tender_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `key` varchar(255) DEFAULT NULL,
  `note` text,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `stone_id` int(11) DEFAULT NULL,
  `deec_no` varchar(255) DEFAULT NULL,
  `sight_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notes`
--

LOCK TABLES `notes` WRITE;
/*!40000 ALTER TABLE `notes` DISABLE KEYS */;
/*!40000 ALTER TABLE `notes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notifications` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `description` text,
  `tender_id` bigint(20) DEFAULT NULL,
  `customer_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_notifications_on_tender_id` (`tender_id`),
  KEY `index_notifications_on_customer_id` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `parcel_images`
--

DROP TABLE IF EXISTS `parcel_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `parcel_images` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `parcel_id` int(11) DEFAULT NULL,
  `image_file_name` varchar(255) DEFAULT NULL,
  `image_content_type` varchar(255) DEFAULT NULL,
  `image_file_size` int(11) DEFAULT NULL,
  `image_updated_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `parcel_images`
--

LOCK TABLES `parcel_images` WRITE;
/*!40000 ALTER TABLE `parcel_images` DISABLE KEYS */;
/*!40000 ALTER TABLE `parcel_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `parcel_size_infos`
--

DROP TABLE IF EXISTS `parcel_size_infos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `parcel_size_infos` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `carats` varchar(255) DEFAULT NULL,
  `size` varchar(255) DEFAULT NULL,
  `percent` varchar(255) DEFAULT NULL,
  `trading_parcel_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `parcel_size_infos`
--

LOCK TABLES `parcel_size_infos` WRITE;
/*!40000 ALTER TABLE `parcel_size_infos` DISABLE KEYS */;
/*!40000 ALTER TABLE `parcel_size_infos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `partial_payments`
--

DROP TABLE IF EXISTS `partial_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `partial_payments` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `company_id` bigint(20) DEFAULT NULL,
  `transaction_id` bigint(20) DEFAULT NULL,
  `amount` decimal(16,2) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_partial_payments_on_transaction_id` (`transaction_id`),
  KEY `index_partial_payments_on_company_id` (`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `partial_payments`
--

LOCK TABLES `partial_payments` WRITE;
/*!40000 ALTER TABLE `partial_payments` DISABLE KEYS */;
INSERT INTO `partial_payments` VALUES (1,5,16,21600.00,'2018-12-06 08:33:58','2018-12-06 08:33:58'),(2,5,14,1.01,'2018-12-06 09:04:33','2018-12-06 09:04:33'),(3,7,17,3300.00,'2018-12-06 17:14:11','2018-12-06 17:14:11'),(4,8,18,1000.00,'2018-12-06 17:39:50','2018-12-06 17:39:50'),(5,8,18,2300.00,'2018-12-06 18:07:14','2018-12-06 18:07:14'),(6,5,19,5000.00,'2018-12-06 23:57:04','2018-12-06 23:57:04'),(7,4,21,5000.00,'2018-12-07 11:53:29','2018-12-07 11:53:29'),(8,4,21,4000.00,'2018-12-07 11:54:22','2018-12-07 11:54:22'),(9,5,23,25000.00,'2018-12-07 12:49:50','2018-12-07 12:49:50'),(10,5,19,5000.00,'2018-12-10 00:27:14','2018-12-10 00:27:14'),(11,5,19,8025.00,'2018-12-10 00:28:00','2018-12-10 00:28:00'),(12,5,24,10000.00,'2018-12-10 00:29:59','2018-12-10 00:29:59'),(13,5,24,11890.00,'2018-12-10 00:31:42','2018-12-10 00:31:42'),(14,5,25,3750.00,'2018-12-10 00:33:00','2018-12-10 00:33:00'),(15,5,23,10000.00,'2018-12-10 00:33:49','2018-12-10 00:33:49'),(16,5,23,15000.00,'2018-12-10 00:34:27','2018-12-10 00:34:27'),(17,5,26,1375.00,'2018-12-10 00:34:56','2018-12-10 00:34:56'),(18,5,27,20000.00,'2018-12-10 00:52:36','2018-12-10 00:52:36'),(19,5,33,20000.00,'2018-12-10 08:19:07','2018-12-10 08:19:07'),(20,8,28,3000.00,'2018-12-10 08:33:40','2018-12-10 08:33:40'),(21,8,28,1500.00,'2018-12-10 08:54:25','2018-12-10 08:54:25'),(22,8,29,1549.04,'2018-12-10 08:55:18','2018-12-10 08:55:18'),(23,7,20,3400.00,'2018-12-10 09:17:46','2018-12-10 09:17:46'),(24,8,32,100.00,'2018-12-10 09:24:20','2018-12-10 09:24:20'),(25,8,32,3200.00,'2018-12-10 09:40:01','2018-12-10 09:40:01'),(26,8,30,500.00,'2018-12-10 09:43:05','2018-12-10 09:43:05'),(27,9,40,500.00,'2018-12-10 15:10:41','2018-12-10 15:10:41'),(28,9,42,500.00,'2018-12-10 16:26:04','2018-12-10 16:26:04'),(29,9,42,2800.00,'2018-12-10 16:26:30','2018-12-10 16:26:30'),(30,8,38,300.00,'2018-12-10 16:27:42','2018-12-10 16:27:42'),(31,8,38,349.26,'2018-12-10 16:27:55','2018-12-10 16:27:55'),(32,8,44,3300.00,'2018-12-10 16:46:37','2018-12-10 16:46:37'),(33,8,45,5000.00,'2018-12-11 08:17:20','2018-12-11 08:17:20'),(34,9,46,4000.00,'2018-12-11 14:28:14','2018-12-11 14:28:14'),(35,9,39,3300.00,'2018-12-11 14:29:10','2018-12-11 14:29:10'),(36,9,41,9000.00,'2018-12-11 14:29:15','2018-12-11 14:29:15'),(37,8,47,3300.00,'2018-12-11 14:46:58','2018-12-11 14:46:58'),(38,4,51,10000.00,'2018-12-11 16:50:38','2018-12-11 16:50:38'),(39,4,22,10000.00,'2018-12-12 00:02:09','2018-12-12 00:02:09'),(40,4,22,10000.00,'2018-12-12 00:03:58','2018-12-12 00:03:58'),(41,4,22,10000.00,'2018-12-12 00:05:43','2018-12-12 00:05:43');
/*!40000 ALTER TABLE `partial_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `polished_demands`
--

DROP TABLE IF EXISTS `polished_demands`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `polished_demands` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `demand_supplier_id` int(11) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `weight_from` int(11) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `block` tinyint(1) DEFAULT '0',
  `deleted` tinyint(1) DEFAULT '0',
  `shape` varchar(255) DEFAULT NULL,
  `color_from` varchar(255) DEFAULT NULL,
  `clarity_from` varchar(255) DEFAULT NULL,
  `cut_from` varchar(255) DEFAULT NULL,
  `polish_from` varchar(255) DEFAULT NULL,
  `symmetry_from` varchar(255) DEFAULT NULL,
  `fluorescence_from` varchar(255) DEFAULT NULL,
  `lab` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `weight_to` int(11) DEFAULT NULL,
  `color_to` varchar(255) DEFAULT NULL,
  `clarity_to` varchar(255) DEFAULT NULL,
  `cut_to` varchar(255) DEFAULT NULL,
  `polish_to` varchar(255) DEFAULT NULL,
  `symmetry_to` varchar(255) DEFAULT NULL,
  `fluorescence_to` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `polished_demands`
--

LOCK TABLES `polished_demands` WRITE;
/*!40000 ALTER TABLE `polished_demands` DISABLE KEYS */;
/*!40000 ALTER TABLE `polished_demands` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pre_registration_documents`
--

DROP TABLE IF EXISTS `pre_registration_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pre_registration_documents` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `document_file_name` varchar(255) DEFAULT NULL,
  `document_content_type` varchar(255) DEFAULT NULL,
  `document_file_size` int(11) DEFAULT NULL,
  `document_updated_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pre_registration_documents`
--

LOCK TABLES `pre_registration_documents` WRITE;
/*!40000 ALTER TABLE `pre_registration_documents` DISABLE KEYS */;
/*!40000 ALTER TABLE `pre_registration_documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pre_registrations`
--

DROP TABLE IF EXISTS `pre_registrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pre_registrations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `company_name` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pre_registrations`
--

LOCK TABLES `pre_registrations` WRITE;
/*!40000 ALTER TABLE `pre_registrations` DISABLE KEYS */;
/*!40000 ALTER TABLE `pre_registrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proposals`
--

DROP TABLE IF EXISTS `proposals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `proposals` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `buyer_id` int(11) DEFAULT NULL,
  `seller_id` int(11) DEFAULT NULL,
  `trading_parcel_id` int(11) DEFAULT NULL,
  `price` decimal(12,2) DEFAULT NULL,
  `credit` int(11) DEFAULT NULL,
  `notes` text,
  `status` int(11) DEFAULT '3',
  `action_for` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `total_value` decimal(12,2) DEFAULT '0.00',
  `percent` decimal(12,2) DEFAULT '0.00',
  `buyer_comment` varchar(255) DEFAULT NULL,
  `seller_price` int(11) DEFAULT NULL,
  `seller_credit` int(11) DEFAULT NULL,
  `seller_total_value` int(11) DEFAULT NULL,
  `seller_percent` int(11) DEFAULT NULL,
  `buyer_price` int(11) DEFAULT NULL,
  `buyer_credit` int(11) DEFAULT NULL,
  `buyer_total_value` int(11) DEFAULT NULL,
  `buyer_percent` int(11) DEFAULT NULL,
  `negotiated` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proposals`
--

LOCK TABLES `proposals` WRITE;
/*!40000 ALTER TABLE `proposals` DISABLE KEYS */;
INSERT INTO `proposals` VALUES (24,10,7,85,3400.00,20,NULL,1,7,'2018-12-06 10:02:08','2018-12-07 10:09:14',3400.00,13.33,'',NULL,NULL,NULL,NULL,3300,20,3300,10,0),(25,7,8,89,3300.00,15,'',1,8,'2018-12-06 17:33:52','2018-12-06 17:34:50',3300.00,10.00,'',NULL,NULL,NULL,NULL,3300,15,3300,10,0),(26,10,9,93,15.00,30,'',3,9,'2018-12-06 17:47:36','2018-12-06 17:47:36',1500.00,0.00,'',NULL,NULL,NULL,NULL,15,30,1500,0,0),(27,10,9,94,20.00,60,'',3,9,'2018-12-06 17:47:40','2018-12-06 17:47:40',4000.00,0.00,'',NULL,NULL,NULL,NULL,20,60,4000,0,0),(28,10,9,95,30.00,60,'',1,9,'2018-12-06 17:47:43','2018-12-10 15:21:41',9000.00,0.00,'',NULL,NULL,NULL,NULL,30,60,9000,0,0),(29,2,5,63,175.00,30,'',1,5,'2018-12-06 23:53:44','2018-12-06 23:55:30',18025.00,0.00,'',NULL,NULL,NULL,NULL,175,30,18025,0,0),(30,1,4,68,175.00,30,'',1,4,'2018-12-07 11:49:20','2018-12-07 11:51:22',14000.00,0.00,'',NULL,NULL,NULL,NULL,175,30,14000,0,0),(31,3,5,65,199.00,75,'',1,5,'2018-12-07 12:11:21','2018-12-07 12:32:14',21890.00,0.00,'',NULL,NULL,NULL,NULL,199,75,21890,0,0),(32,7,8,113,90.00,80,'fjtdub',1,8,'2018-12-08 11:57:10','2018-12-08 11:59:58',4500.00,80.00,'okay fine',NULL,NULL,NULL,NULL,90,80,4500,80,0),(33,7,8,114,45.56,343,NULL,1,8,'2018-12-08 12:07:26','2018-12-08 12:07:56',1549.04,34.00,'',NULL,NULL,NULL,NULL,45,343,1549,34,0),(34,7,8,115,45.56,34,NULL,1,8,'2018-12-08 12:09:55','2018-12-08 12:10:09',1549.04,34.00,'',NULL,NULL,NULL,NULL,45,34,1549,34,0),(35,7,8,116,5.25,558,'fugjhgjbybuh',1,8,'2018-12-08 14:10:47','2018-12-08 14:22:10',26.25,5.00,'proposql',NULL,NULL,NULL,NULL,5,558,26,5,0),(36,7,8,117,3300.00,20,'',1,8,'2018-12-08 14:29:05','2018-12-08 14:30:08',3300.00,10.00,'',NULL,NULL,NULL,NULL,3300,20,3300,10,0),(37,3,6,122,165.00,60,'',1,6,'2018-12-10 02:31:24','2018-12-12 02:19:42',33000.00,10.00,'',NULL,NULL,NULL,NULL,160,60,32100,7,0),(38,3,5,64,195.00,90,'',2,5,'2018-12-10 07:59:08','2018-12-12 10:40:08',20475.00,0.00,'',NULL,NULL,NULL,NULL,195,90,20475,0,0),(39,7,9,94,20.00,60,'',3,9,'2018-12-10 08:23:18','2018-12-10 08:23:18',4000.00,0.00,'',NULL,NULL,NULL,NULL,20,60,4000,0,0),(40,7,8,123,3300.00,20,'',2,8,'2018-12-10 08:25:47','2018-12-10 08:26:11',3300.00,10.00,'',NULL,NULL,NULL,NULL,3300,20,3300,10,0),(41,7,8,127,3300.00,20,'',1,8,'2018-12-10 10:11:32','2018-12-10 10:12:24',3300.00,10.00,'',NULL,NULL,NULL,NULL,3300,20,3300,10,0),(42,7,8,128,3300.00,20,'',1,8,'2018-12-10 10:15:37','2018-12-10 10:16:01',3300.00,10.00,'',NULL,NULL,NULL,NULL,3300,20,3300,10,0),(43,7,8,123,3200.00,20,'',0,8,'2018-12-10 14:10:08','2018-12-10 14:15:01',3200.00,6.67,'',NULL,NULL,NULL,NULL,3300,20,3300,10,0),(44,10,8,134,28.29,23,NULL,1,8,'2018-12-10 14:57:59','2018-12-10 14:58:11',649.26,23.00,'this is testing',NULL,NULL,NULL,NULL,28,23,649,23,0),(45,10,9,135,3300.00,15,'',1,9,'2018-12-10 14:59:02','2018-12-10 14:59:54',3300.00,10.00,'',NULL,NULL,NULL,NULL,3300,15,3300,10,0),(46,10,9,137,3300.00,15,'',1,9,'2018-12-10 15:23:14','2018-12-10 15:25:27',3300.00,10.00,'',NULL,NULL,NULL,NULL,3300,15,3300,10,0),(47,10,8,123,3300.00,20,'',1,8,'2018-12-10 16:41:10','2018-12-10 16:41:52',3300.00,10.00,'',NULL,NULL,NULL,NULL,3300,20,3300,10,0),(48,7,8,143,5000.00,20,'',1,8,'2018-12-11 08:14:28','2018-12-11 08:15:12',5000.00,3000.00,'',NULL,NULL,NULL,NULL,5000,20,5000,3000,0),(49,10,5,147,3000.00,15,'',2,5,'2018-12-11 09:38:33','2018-12-12 01:03:12',3000.00,10.00,'',NULL,NULL,NULL,NULL,3000,15,3000,10,0),(50,10,5,147,3000.00,15,'',2,5,'2018-12-11 09:43:00','2018-12-12 01:03:01',3000.00,10.00,'',NULL,NULL,NULL,NULL,3000,15,3000,10,0),(51,10,9,149,4000.00,20,'',3,9,'2018-12-11 09:49:36','2018-12-11 09:49:36',4000.00,10.00,'',NULL,NULL,NULL,NULL,4000,20,4000,10,0),(52,3,5,64,200.00,90,'',3,5,'2018-12-12 10:40:29','2018-12-12 10:40:29',21000.00,0.00,'',NULL,NULL,NULL,NULL,200,90,21000,0,0),(53,3,5,64,200.00,90,'',3,5,'2018-12-12 10:40:38','2018-12-12 10:40:38',21000.00,0.00,'',NULL,NULL,NULL,NULL,200,90,21000,0,0),(54,3,5,64,215.00,90,'',0,5,'2018-12-12 10:40:51','2018-12-12 18:52:35',22575.00,0.00,'',NULL,NULL,NULL,NULL,205,90,21525,0,0),(55,3,4,67,200.00,60,'',3,4,'2018-12-12 13:10:28','2018-12-12 13:10:28',17000.00,0.00,'',NULL,NULL,NULL,NULL,200,60,17000,0,0),(56,3,4,67,225.00,60,'',3,4,'2018-12-12 13:11:15','2018-12-12 18:32:03',19125.00,0.00,'',NULL,NULL,NULL,NULL,200,60,17000,0,0);
/*!40000 ALTER TABLE `proposals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `push_notifications`
--

DROP TABLE IF EXISTS `push_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `push_notifications` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type_of_event` varchar(255) DEFAULT NULL,
  `message` text,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `push_notifications`
--

LOCK TABLES `push_notifications` WRITE;
/*!40000 ALTER TABLE `push_notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `push_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rails_admin_histories`
--

DROP TABLE IF EXISTS `rails_admin_histories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rails_admin_histories` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `message` text,
  `username` varchar(255) DEFAULT NULL,
  `item` int(11) DEFAULT NULL,
  `table` varchar(255) DEFAULT NULL,
  `month` smallint(6) DEFAULT NULL,
  `year` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_rails_admin_histories` (`item`,`table`,`month`,`year`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rails_admin_histories`
--

LOCK TABLES `rails_admin_histories` WRITE;
/*!40000 ALTER TABLE `rails_admin_histories` DISABLE KEYS */;
INSERT INTO `rails_admin_histories` VALUES (1,'new','admin@safetrade.ai',1,'DemandSupplier',NULL,NULL,'2018-12-02 08:05:06','2018-12-02 08:05:06'),(2,'new','admin@safetrade.ai',1,'DemandList',NULL,NULL,'2018-12-02 08:05:19','2018-12-02 08:05:19'),(3,'new','admin@safetrade.ai',2,'DemandList',NULL,NULL,'2018-12-02 08:05:25','2018-12-02 08:05:25'),(4,'new','admin@safetrade.ai',3,'DemandList',NULL,NULL,'2018-12-02 08:05:28','2018-12-02 08:05:28'),(5,'new','admin@safetrade.ai',2,'DemandSupplier',NULL,NULL,'2018-12-02 11:49:29','2018-12-02 11:49:29'),(6,'new','admin@safetrade.ai',3,'DemandSupplier',NULL,NULL,'2018-12-02 11:49:35','2018-12-02 11:49:35'),(7,'new','admin@safetrade.ai',4,'DemandSupplier',NULL,NULL,'2018-12-02 11:49:40','2018-12-02 11:49:40'),(8,'new','admin@safetrade.ai',5,'DemandSupplier',NULL,NULL,'2018-12-02 11:49:49','2018-12-02 11:49:49'),(9,'new','admin@safetrade.ai',4,'DemandList',NULL,NULL,'2018-12-02 11:51:13','2018-12-02 11:51:13'),(10,'new','admin@safetrade.ai',5,'DemandList',NULL,NULL,'2018-12-02 11:51:35','2018-12-02 11:51:35'),(11,'new','admin@safetrade.ai',6,'DemandList',NULL,NULL,'2018-12-02 11:51:49','2018-12-02 11:51:49'),(12,'new','admin@safetrade.ai',7,'DemandList',NULL,NULL,'2018-12-02 11:51:57','2018-12-02 11:51:57'),(13,'new','admin@safetrade.ai',8,'DemandList',NULL,NULL,'2018-12-02 11:52:08','2018-12-02 11:52:08'),(14,'delete','admin@safetrade.ai',3,'Customer',NULL,NULL,'2018-12-03 07:54:19','2018-12-03 07:54:19'),(15,'new','admin@safetrade.ai',14,'CustomerRole',NULL,NULL,'2018-12-03 08:12:16','2018-12-03 08:12:16'),(16,'delete','admin@safetrade.ai',1,'Customer',NULL,NULL,'2018-12-04 13:43:20','2018-12-04 13:43:20'),(17,'delete','admin@safetrade.ai',15,'CustomerRole',NULL,NULL,'2018-12-04 18:13:07','2018-12-04 18:13:07'),(18,'delete','admin@safetrade.ai',16,'CustomerRole',NULL,NULL,'2018-12-04 18:13:12','2018-12-04 18:13:12'),(19,'delete','admin@safetrade.ai',2,'Customer',NULL,NULL,'2018-12-04 19:15:57','2018-12-04 19:15:57'),(20,'name: \"Special\" -> \"SOMETHING SPECIAL\"','admin@safetrade.ai',5,'DemandSupplier',NULL,NULL,'2018-12-05 12:45:42','2018-12-05 12:45:42'),(21,'name: \"Outside\" -> \"OUTSIDE GOODS\"','admin@safetrade.ai',4,'DemandSupplier',NULL,NULL,'2018-12-05 12:46:24','2018-12-05 12:46:24'),(22,'name: \"Russian\" -> \"RUSSIAN\"','admin@safetrade.ai',3,'DemandSupplier',NULL,NULL,'2018-12-05 12:46:45','2018-12-05 12:46:45'),(23,'name: \"Sight\" -> \"DTC\"','admin@safetrade.ai',2,'DemandSupplier',NULL,NULL,'2018-12-05 12:49:40','2018-12-05 12:49:40'),(24,'delete','admin@safetrade.ai',1,'DemandSupplier',NULL,NULL,'2018-12-05 15:06:38','2018-12-05 15:06:38'),(25,'delete','admin@safetrade.ai',9,'Customer',NULL,NULL,'2018-12-06 07:13:40','2018-12-06 07:13:40'),(26,'delete','admin@safetrade.ai',8,'Customer',NULL,NULL,'2018-12-06 07:13:51','2018-12-06 07:13:51'),(27,'delete','admin@safetrade.ai',16,'Transaction',NULL,NULL,'2018-12-06 09:09:03','2018-12-06 09:09:03'),(28,'delete','admin@safetrade.ai',15,'Transaction',NULL,NULL,'2018-12-06 09:09:03','2018-12-06 09:09:03'),(29,'delete','admin@safetrade.ai',14,'Transaction',NULL,NULL,'2018-12-06 09:09:03','2018-12-06 09:09:03'),(30,'delete','admin@safetrade.ai',13,'Transaction',NULL,NULL,'2018-12-06 09:09:03','2018-12-06 09:09:03'),(31,'delete','admin@safetrade.ai',22,'Proposal',NULL,NULL,'2018-12-06 09:09:12','2018-12-06 09:09:12'),(32,'delete','admin@safetrade.ai',21,'Proposal',NULL,NULL,'2018-12-06 09:09:12','2018-12-06 09:09:12'),(33,'delete','admin@safetrade.ai',20,'Proposal',NULL,NULL,'2018-12-06 09:09:13','2018-12-06 09:09:13'),(34,'delete','admin@safetrade.ai',19,'Proposal',NULL,NULL,'2018-12-06 09:09:13','2018-12-06 09:09:13'),(35,'delete','admin@safetrade.ai',18,'Demand',NULL,NULL,'2018-12-06 09:09:37','2018-12-06 09:09:37'),(36,'delete','admin@safetrade.ai',17,'Demand',NULL,NULL,'2018-12-06 09:09:37','2018-12-06 09:09:37'),(37,'delete','admin@safetrade.ai',16,'Demand',NULL,NULL,'2018-12-06 09:09:37','2018-12-06 09:09:37'),(38,'delete','admin@safetrade.ai',15,'Demand',NULL,NULL,'2018-12-06 09:09:37','2018-12-06 09:09:37'),(39,'delete','admin@safetrade.ai',14,'Demand',NULL,NULL,'2018-12-06 09:09:38','2018-12-06 09:09:38'),(40,'delete','admin@safetrade.ai',13,'Demand',NULL,NULL,'2018-12-06 09:09:38','2018-12-06 09:09:38'),(41,'delete','admin@safetrade.ai',12,'Demand',NULL,NULL,'2018-12-06 09:09:38','2018-12-06 09:09:38'),(42,'delete','admin@safetrade.ai',11,'Demand',NULL,NULL,'2018-12-06 09:09:38','2018-12-06 09:09:38'),(43,'delete','admin@safetrade.ai',10,'Demand',NULL,NULL,'2018-12-06 09:09:38','2018-12-06 09:09:38'),(44,'delete','admin@safetrade.ai',9,'Demand',NULL,NULL,'2018-12-06 09:09:38','2018-12-06 09:09:38'),(45,'delete','admin@safetrade.ai',8,'Demand',NULL,NULL,'2018-12-06 09:09:38','2018-12-06 09:09:38'),(46,'delete','admin@safetrade.ai',7,'Demand',NULL,NULL,'2018-12-06 09:09:38','2018-12-06 09:09:38'),(47,'delete','admin@safetrade.ai',6,'Demand',NULL,NULL,'2018-12-06 09:09:38','2018-12-06 09:09:38'),(48,'delete','admin@safetrade.ai',5,'Demand',NULL,NULL,'2018-12-06 09:09:38','2018-12-06 09:09:38'),(49,'delete','admin@safetrade.ai',4,'Demand',NULL,NULL,'2018-12-06 09:09:38','2018-12-06 09:09:38'),(50,'delete','admin@safetrade.ai',3,'Demand',NULL,NULL,'2018-12-06 09:09:38','2018-12-06 09:09:38'),(51,'delete','admin@safetrade.ai',2,'Demand',NULL,NULL,'2018-12-06 09:09:38','2018-12-06 09:09:38'),(52,'delete','admin@safetrade.ai',1,'Demand',NULL,NULL,'2018-12-06 09:09:38','2018-12-06 09:09:38'),(53,'new','admin@safetrade.ai',7,'Company',NULL,NULL,'2018-12-06 09:12:48','2018-12-06 09:12:48'),(54,'new','admin@safetrade.ai',8,'Company',NULL,NULL,'2018-12-06 09:12:54','2018-12-06 09:12:54'),(55,'new','admin@safetrade.ai',9,'Company',NULL,NULL,'2018-12-06 09:13:00','2018-12-06 09:13:00'),(56,'new','admin@safetrade.ai',10,'Company',NULL,NULL,'2018-12-06 09:13:08','2018-12-06 09:13:08'),(57,'county: \"\" -> \"India\"','admin@safetrade.ai',10,'Company',NULL,NULL,'2018-12-06 09:13:18','2018-12-06 09:13:18'),(58,'delete','admin@safetrade.ai',44,'Negotiation',NULL,NULL,'2018-12-06 09:18:11','2018-12-06 09:18:11'),(59,'delete','admin@safetrade.ai',43,'Negotiation',NULL,NULL,'2018-12-06 09:18:11','2018-12-06 09:18:11'),(60,'delete','admin@safetrade.ai',23,'Proposal',NULL,NULL,'2018-12-06 09:18:25','2018-12-06 09:18:25'),(61,'delete','admin@safetrade.ai',13,'Customer',NULL,NULL,'2018-12-06 09:19:21','2018-12-06 09:19:21'),(62,'delete','admin@safetrade.ai',12,'Customer',NULL,NULL,'2018-12-06 09:19:21','2018-12-06 09:19:21'),(63,'encrypted_password: \"$2a$10$PynXLTWxvP3JHJjVRJ9hguEKp.Tb1chFV35gM9H06PRz3ttb1bIWm\" -> \"$2a$10$zRHt2l8bXwJ5CpRJkHHa1uLCVmNycNm/Le6nXng2MeSeo3n1IBNIe\", city: nil -> \"\", address: nil -> \"\", phone: nil -> \"\", phone_2: nil -> \"\", company_address: nil -> \"\"','admin@safetrade.ai',11,'Customer',NULL,NULL,'2018-12-06 09:19:43','2018-12-06 09:19:43'),(64,'encrypted_password: \"$2a$10$BKi5Qcl9SL48bRsc188m3uxmfK/19SHH90veisuvQPKgeiprNeW7a\" -> \"$2a$10$v54zEcjyXRhc0V9vtX6FXe9yzMuZDF5JZFFm5P12uIvJSh5kMKJAi\", city: nil -> \"\", address: nil -> \"\", phone: nil -> \"\", phone_2: nil -> \"\", company_address: nil -> \"\"','admin@safetrade.ai',10,'Customer',NULL,NULL,'2018-12-06 09:19:56','2018-12-06 09:19:56'),(65,'encrypted_password: \"$2a$10$q7XlnO7qw8.dddzj3l9UmOs76osQSzLYxvZPoxJgnB3wuQW1Ej556\" -> \"$2a$10$gJV3L1EzbWH88OiKVW1o3OmzQ.iby5xDjE.B88qFpCH5e7qro9Rk6\", city: nil -> \"\", address: nil -> \"\", phone: nil -> \"\", phone_2: nil -> \"\", company_address: nil -> \"\"','admin@safetrade.ai',7,'Customer',NULL,NULL,'2018-12-06 09:20:10','2018-12-06 09:20:10'),(66,'encrypted_password: \"$2a$10$fGYNiNU3ZwZjxgvrUKInHumSUM0VYbUq2BrB3954/4eEAnxFBnm86\" -> \"$2a$10$L6Dpn0I1qNMvbwfsOUu1AO7GApfgWwqnx5DlKZnlCcyXVhHlFvPX.\", city: nil -> \"\", address: nil -> \"\", phone: nil -> \"\", phone_2: nil -> \"\", company_address: nil -> \"\"','admin@safetrade.ai',6,'Customer',NULL,NULL,'2018-12-06 09:20:36','2018-12-06 09:20:36'),(67,'encrypted_password: \"$2a$10$xjkx2pEJ6miHF.E/PZQ1iuaOHPuLmWg0oUo5f.V7di4UHHYmspG0i\" -> \"$2a$10$xgZL8acgm7HERmc55xP0oeKafd1KBUxCI8Xv4Gs6i7zX3VNthYggm\", city: nil -> \"\", address: nil -> \"\", phone: nil -> \"\", phone_2: nil -> \"\", company_address: nil -> \"\"','admin@safetrade.ai',5,'Customer',NULL,NULL,'2018-12-06 09:20:50','2018-12-06 09:20:50'),(68,'encrypted_password: \"$2a$10$ne76d9MZUehIm/YQZ2VItu7HTc/AzHZX2H2./i44RRIvpiFUcL5/O\" -> \"$2a$10$IaWS0CGAzFIOSLUmSuGxdOLtqRRs8l2SgTMQy.2.wnS3wiXsPZU36\", city: nil -> \"\", address: nil -> \"\", phone: nil -> \"\", phone_2: nil -> \"\", company_address: nil -> \"\"','admin@safetrade.ai',4,'Customer',NULL,NULL,'2018-12-06 09:21:00','2018-12-06 09:21:00'),(69,'city: nil -> \"\", address: nil -> \"\", phone: nil -> \"\", phone_2: nil -> \"\", company_id: 1 -> 10, company_address: nil -> \"\"','admin@safetrade.ai',18,'Customer',NULL,NULL,'2018-12-06 13:22:27','2018-12-06 13:22:27'),(70,'delete','admin@safetrade.ai',18,'Customer',NULL,NULL,'2018-12-06 13:27:38','2018-12-06 13:27:38');
/*!40000 ALTER TABLE `rails_admin_histories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ratings`
--

DROP TABLE IF EXISTS `ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ratings` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tender_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `key` varchar(255) DEFAULT NULL,
  `score` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `flag_type` varchar(255) DEFAULT 'Imp',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ratings`
--

LOCK TABLES `ratings` WRITE;
/*!40000 ALTER TABLE `ratings` DISABLE KEYS */;
/*!40000 ALTER TABLE `ratings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'Buyer','2018-12-02 22:08:15','2018-12-02 22:08:15'),(2,'Seller','2018-12-02 22:08:29','2018-12-02 22:08:29'),(3,'Supplier','2018-12-02 22:08:44','2018-12-02 22:08:44'),(4,'Broker','2018-12-02 22:08:57','2018-12-02 22:08:57');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `round_loosers`
--

DROP TABLE IF EXISTS `round_loosers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `round_loosers` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `stone_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `bid_id` int(11) DEFAULT NULL,
  `auction_round_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `auction_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `round_loosers`
--

LOCK TABLES `round_loosers` WRITE;
/*!40000 ALTER TABLE `round_loosers` DISABLE KEYS */;
/*!40000 ALTER TABLE `round_loosers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `round_winners`
--

DROP TABLE IF EXISTS `round_winners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `round_winners` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `customer_id` int(11) DEFAULT NULL,
  `auction_round_id` int(11) DEFAULT NULL,
  `bid_id` int(11) DEFAULT NULL,
  `stone_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `auction_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `round_winners`
--

LOCK TABLES `round_winners` WRITE;
/*!40000 ALTER TABLE `round_winners` DISABLE KEYS */;
/*!40000 ALTER TABLE `round_winners` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20130529095811'),('20130529095812'),('20130529095902'),('20130529120030'),('20130531085711'),('20130531090512'),('20130531093111'),('20130531100755'),('20130604085817'),('20130605092314'),('20130607113349'),('20130611095343'),('20130617101509'),('20130617115508'),('20130619064337'),('20130619070120'),('20130620064322'),('20130620092811'),('20130708082735'),('20130709055035'),('20130710053201'),('20130716053847'),('20130719050520'),('20130722102903'),('20130813090612'),('20130816073529'),('20130821064755'),('20130923101656'),('20130926081431'),('20131016053707'),('20131016073224'),('20131022065214'),('20131022065309'),('20131022120955'),('20131028112406'),('20131029091523'),('20131118064553'),('20131127060048'),('20140425090444'),('20140425090445'),('20150408144536'),('20150409060817'),('20150410050718'),('20150424073522'),('20150427113154'),('20150427121515'),('20170719100624'),('20170719122730'),('20170719132309'),('20170719133654'),('20170720055749'),('20170725061834'),('20170726095516'),('20170731091717'),('20170731130307'),('20170802102706'),('20170802135823'),('20170803073507'),('20170809121845'),('20170809125703'),('20170810060506'),('20170810062745'),('20170810112554'),('20170810132436'),('20170811072920'),('20170814114600'),('20170818084541'),('20170823111744'),('20170825105208'),('20170904104819'),('20170904293551'),('20170904293552'),('20170905065500'),('20170906100459'),('20170906101003'),('20170907125625'),('20170908113253'),('20170911090751'),('20170912062020'),('20170914093905'),('20170914102909'),('20170914103252'),('20170914103329'),('20170914103344'),('20170914115552'),('20170915060144'),('20170915065116'),('20170918093808'),('20170918123637'),('20170919123354'),('20170920091910'),('20170921101733'),('20170921114558'),('20170921114824'),('20170921115005'),('20170922044613'),('20170926071312'),('20170926121606'),('20170927095632'),('20170927121726'),('20170928053115'),('20170928061128'),('20171003043751'),('20171003123055'),('20171003131335'),('20171005044402'),('20171006122234'),('20171010095942'),('20171012045023'),('20171012075037'),('20171017054053'),('20171017083959'),('20171023095614'),('20171024101100'),('20171024101116'),('20171025095745'),('20171025134716'),('20171027040259'),('20171030112239'),('20171101070253'),('20171101094719'),('20171101121621'),('20171103055830'),('20171107092345'),('20171107133658'),('20171108113922'),('20171108113947'),('20171109113032'),('20171113105243'),('20171121101456'),('20171122132722'),('20171123121805'),('20171123134203'),('20171201080501'),('20171213070215'),('20171219083741'),('20171221113242'),('20180104071137'),('20180108103449'),('20180109075613'),('20180109105650'),('20180110092919'),('20180110114004'),('20180112115256'),('20180115061509'),('20180115061648'),('20180116073621'),('20180117120646'),('20180117122528'),('20180119095117'),('20180129105245'),('20180130134355'),('20180202102413'),('20180202141532'),('20180202154600'),('20180208095348'),('20180209112821'),('20180215065844'),('20180215072754'),('20180216103310'),('20180221094946'),('20180223103851'),('20180223141137'),('20180226085728'),('20180227122703'),('20180314083215'),('20180314122943'),('20180319123541'),('20180319123608'),('20180321121314'),('20180322072006'),('20180329081948'),('20180416094635'),('20180501133101'),('20180518101736'),('20180528123336'),('20180604061224'),('20180604111343'),('20180605122746'),('20180607071537'),('20180608085530'),('20180609110252'),('20180614093247'),('20180614130651'),('20180621084547'),('20180628073358'),('20180704110756'),('20180706113422'),('20180711074539'),('20180720131655'),('20180725091954'),('20180725103818'),('20180726113430'),('20180726113440'),('20180726113513'),('20180726113524'),('20180726153122'),('20180726153216'),('20180726153248'),('20180726153300'),('20180806115351'),('20180808132544'),('20180817070128'),('20180820075024'),('20180822065747'),('20180823075543'),('20180823100702'),('20180904091234'),('20180913083539'),('20180915153730'),('20180920094943'),('20180920105057'),('20180924120027'),('20181010092902'),('20181011093206'),('20181012053239'),('20181029082128'),('20181101105030'),('20181116192513'),('20181116192516'),('20181118150721'),('20181124161413'),('20181128112822'),('20181128162812'),('20181129134211'),('20181204143000'),('2018120711490');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `secure_centers`
--

DROP TABLE IF EXISTS `secure_centers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `secure_centers` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `seller_id` int(11) DEFAULT NULL,
  `buyer_id` int(11) DEFAULT NULL,
  `invoices_overdue` int(11) DEFAULT NULL,
  `paid_date` date DEFAULT NULL,
  `late_days` int(11) DEFAULT NULL,
  `buyer_days_limit` int(11) DEFAULT NULL,
  `market_limit` decimal(10,2) DEFAULT NULL,
  `supplier_paid` int(11) DEFAULT NULL,
  `outstandings` decimal(10,2) DEFAULT NULL,
  `overdue_amount` decimal(10,2) DEFAULT NULL,
  `given_credit_limit` decimal(10,2) DEFAULT NULL,
  `given_market_limit` decimal(10,2) DEFAULT NULL,
  `given_overdue_limit` decimal(10,2) DEFAULT NULL,
  `last_bought_on` date DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `supplier_unpaid` int(11) DEFAULT '0',
  `percentage` decimal(10,2) DEFAULT '0.00',
  `activity_bought` decimal(10,2) DEFAULT NULL,
  `buyer_percentage` decimal(10,2) DEFAULT '0.00',
  `system_percentage` decimal(10,2) DEFAULT '0.00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=248 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `secure_centers`
--

LOCK TABLES `secure_centers` WRITE;
/*!40000 ALTER TABLE `secure_centers` DISABLE KEYS */;
INSERT INTO `secure_centers` VALUES (245,6,3,2,'2018-12-12',27,0,0.00,3,33000.00,0.00,0.00,0.00,30.00,'2018-12-12','2018-12-12 08:44:10','2018-12-12 08:44:10',4,0.00,NULL,50.34,43.96),(246,5,3,2,'2018-12-12',27,2,50000.00,3,180000.00,80000.00,180000.00,50000.00,25.00,'2018-12-12','2018-12-12 08:44:55','2018-12-12 08:44:55',4,0.00,NULL,50.34,43.96),(247,4,3,2,'2018-12-12',27,0,50000.00,3,20000.00,20000.00,50000.00,50000.00,25.00,'2018-12-12','2018-12-12 08:45:43','2018-12-12 08:45:43',4,0.00,NULL,50.34,43.96);
/*!40000 ALTER TABLE `secure_centers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seller_scores`
--

DROP TABLE IF EXISTS `seller_scores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `seller_scores` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) DEFAULT NULL,
  `late_payment` float NOT NULL DEFAULT '0',
  `current_risk` float NOT NULL DEFAULT '0',
  `network_diversity` float NOT NULL DEFAULT '0',
  `seller_network` float NOT NULL DEFAULT '0',
  `due_date` float NOT NULL DEFAULT '0',
  `credit_used` float NOT NULL DEFAULT '0',
  `total` float NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `actual` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_seller_scores_on_company_id` (`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seller_scores`
--

LOCK TABLES `seller_scores` WRITE;
/*!40000 ALTER TABLE `seller_scores` DISABLE KEYS */;
/*!40000 ALTER TABLE `seller_scores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shareds`
--

DROP TABLE IF EXISTS `shareds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shareds` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `shared_to_id` bigint(20) DEFAULT NULL,
  `shared_by_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_shareds_on_shared_to_id` (`shared_to_id`),
  KEY `index_shareds_on_shared_by_id` (`shared_by_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shareds`
--

LOCK TABLES `shareds` WRITE;
/*!40000 ALTER TABLE `shareds` DISABLE KEYS */;
/*!40000 ALTER TABLE `shareds` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sights`
--

DROP TABLE IF EXISTS `sights`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sights` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `stone_type` varchar(255) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `box` varchar(255) DEFAULT NULL,
  `carats` int(11) DEFAULT NULL,
  `cost` int(11) DEFAULT NULL,
  `box_value_from` int(11) DEFAULT NULL,
  `box_value_to` int(11) DEFAULT NULL,
  `sight` varchar(255) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `credit` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `tender_id` int(11) DEFAULT NULL,
  `sight_reserved_price` varchar(255) DEFAULT NULL,
  `yes_no_system_price` float DEFAULT NULL,
  `stone_winning_price` float DEFAULT NULL,
  `interest` tinyint(1) DEFAULT '1',
  `status` int(11) DEFAULT '0',
  `starting_price` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sights`
--

LOCK TABLES `sights` WRITE;
/*!40000 ALTER TABLE `sights` DISABLE KEYS */;
/*!40000 ALTER TABLE `sights` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stone_ratings`
--

DROP TABLE IF EXISTS `stone_ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stone_ratings` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `stone_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `comments` varchar(255) DEFAULT NULL,
  `valuation` varchar(255) DEFAULT NULL,
  `parcel_rating` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stone_ratings`
--

LOCK TABLES `stone_ratings` WRITE;
/*!40000 ALTER TABLE `stone_ratings` DISABLE KEYS */;
/*!40000 ALTER TABLE `stone_ratings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stones`
--

DROP TABLE IF EXISTS `stones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stones` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `stone_type` varchar(255) DEFAULT NULL,
  `no_of_stones` int(11) DEFAULT NULL,
  `size` float DEFAULT NULL,
  `weight` float DEFAULT NULL,
  `carat` decimal(10,5) DEFAULT NULL,
  `purity` float DEFAULT NULL,
  `color` varchar(255) DEFAULT NULL,
  `polished` tinyint(1) DEFAULT NULL,
  `tender_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `deec_no` int(11) DEFAULT NULL,
  `lot_no` int(11) DEFAULT NULL,
  `description` text,
  `system_price` float DEFAULT NULL,
  `lot_permission` tinyint(1) DEFAULT NULL,
  `comments` varchar(255) DEFAULT NULL,
  `valuation` varchar(255) DEFAULT NULL,
  `parcel_rating` int(11) DEFAULT NULL,
  `reserved_price` int(11) DEFAULT NULL,
  `yes_no_system_price` float DEFAULT NULL,
  `stone_winning_price` float DEFAULT NULL,
  `status` int(11) DEFAULT '0',
  `starting_price` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_stones_on_tender_id` (`tender_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stones`
--

LOCK TABLES `stones` WRITE;
/*!40000 ALTER TABLE `stones` DISABLE KEYS */;
/*!40000 ALTER TABLE `stones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sub_company_credit_limits`
--

DROP TABLE IF EXISTS `sub_company_credit_limits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sub_company_credit_limits` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sub_company_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `credit_type` varchar(255) DEFAULT NULL,
  `credit_limit` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sub_company_credit_limits`
--

LOCK TABLES `sub_company_credit_limits` WRITE;
/*!40000 ALTER TABLE `sub_company_credit_limits` DISABLE KEYS */;
/*!40000 ALTER TABLE `sub_company_credit_limits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `supplier_mines`
--

DROP TABLE IF EXISTS `supplier_mines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `supplier_mines` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `supplier_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_supplier_mines_on_supplier_id` (`supplier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier_mines`
--

LOCK TABLES `supplier_mines` WRITE;
/*!40000 ALTER TABLE `supplier_mines` DISABLE KEYS */;
/*!40000 ALTER TABLE `supplier_mines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `supplier_notifications`
--

DROP TABLE IF EXISTS `supplier_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `supplier_notifications` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `supplier_id` int(11) DEFAULT NULL,
  `customer_id` bigint(20) DEFAULT NULL,
  `notify` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_supplier_notifications_on_customer_id` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier_notifications`
--

LOCK TABLES `supplier_notifications` WRITE;
/*!40000 ALTER TABLE `supplier_notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `supplier_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suppliers`
--

DROP TABLE IF EXISTS `suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `suppliers` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `registration_vat_no` varchar(255) DEFAULT NULL,
  `registration_no` varchar(255) DEFAULT NULL,
  `fax` varchar(255) DEFAULT NULL,
  `telephone` varchar(255) DEFAULT NULL,
  `mobile` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `credit_limit` int(11) DEFAULT NULL,
  `market_limit` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliers`
--

LOCK TABLES `suppliers` WRITE;
/*!40000 ALTER TABLE `suppliers` DISABLE KEYS */;
/*!40000 ALTER TABLE `suppliers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `temp_stones`
--

DROP TABLE IF EXISTS `temp_stones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temp_stones` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tender_id` int(11) DEFAULT NULL,
  `lot_no` int(11) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `no_of_stones` int(11) DEFAULT NULL,
  `carat` float DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temp_stones`
--

LOCK TABLES `temp_stones` WRITE;
/*!40000 ALTER TABLE `temp_stones` DISABLE KEYS */;
/*!40000 ALTER TABLE `temp_stones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tender_notifications`
--

DROP TABLE IF EXISTS `tender_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tender_notifications` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `customer_id` int(11) DEFAULT NULL,
  `tender_id` int(11) DEFAULT NULL,
  `notify` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tender_notifications`
--

LOCK TABLES `tender_notifications` WRITE;
/*!40000 ALTER TABLE `tender_notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `tender_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tender_winners`
--

DROP TABLE IF EXISTS `tender_winners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tender_winners` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tender_id` int(11) DEFAULT NULL,
  `lot_no` int(11) DEFAULT NULL,
  `selling_price` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `avg_selling_price` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tender_winners`
--

LOCK TABLES `tender_winners` WRITE;
/*!40000 ALTER TABLE `tender_winners` DISABLE KEYS */;
/*!40000 ALTER TABLE `tender_winners` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tenders`
--

DROP TABLE IF EXISTS `tenders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tenders` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `open_date` datetime DEFAULT NULL,
  `close_date` datetime DEFAULT NULL,
  `tender_open` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `document_file_name` varchar(255) DEFAULT NULL,
  `document_content_type` varchar(255) DEFAULT NULL,
  `document_file_size` int(11) DEFAULT NULL,
  `document_updated_at` datetime DEFAULT NULL,
  `send_confirmation` tinyint(1) DEFAULT NULL,
  `winner_list_file_name` varchar(255) DEFAULT NULL,
  `winner_list_content_type` varchar(255) DEFAULT NULL,
  `winner_list_file_size` int(11) DEFAULT NULL,
  `winner_list_updated_at` datetime DEFAULT NULL,
  `temp_document_file_name` varchar(255) DEFAULT NULL,
  `temp_document_content_type` varchar(255) DEFAULT NULL,
  `temp_document_file_size` int(11) DEFAULT NULL,
  `temp_document_updated_at` datetime DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `deec_no_field` varchar(255) DEFAULT NULL,
  `lot_no_field` varchar(255) DEFAULT NULL,
  `desc_field` varchar(255) DEFAULT NULL,
  `no_of_stones_field` varchar(255) DEFAULT NULL,
  `weight_field` varchar(255) DEFAULT NULL,
  `sheet_no` int(11) DEFAULT NULL,
  `winner_lot_no_field` varchar(255) DEFAULT NULL,
  `winner_desc_field` varchar(255) DEFAULT NULL,
  `winner_no_of_stones_field` varchar(255) DEFAULT NULL,
  `winner_weight_field` varchar(255) DEFAULT NULL,
  `winner_selling_price_field` varchar(255) DEFAULT NULL,
  `winner_carat_selling_price_field` varchar(255) DEFAULT NULL,
  `winner_sheet_no` int(11) DEFAULT NULL,
  `reference_id` int(11) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `tender_type` varchar(255) NOT NULL DEFAULT '',
  `diamond_type` varchar(255) DEFAULT NULL,
  `sight_document_file_name` varchar(255) DEFAULT NULL,
  `sight_document_content_type` varchar(255) DEFAULT NULL,
  `sight_document_file_size` int(11) DEFAULT NULL,
  `sight_document_updated_at` datetime DEFAULT NULL,
  `s_no_field` varchar(255) DEFAULT NULL,
  `source_no_field` varchar(255) DEFAULT NULL,
  `box_no_field` varchar(255) DEFAULT NULL,
  `carats_no_field` varchar(255) DEFAULT NULL,
  `cost_no_field` varchar(255) DEFAULT NULL,
  `boxvalue_no_field` varchar(255) DEFAULT NULL,
  `sight_no_field` varchar(255) DEFAULT NULL,
  `price_no_field` varchar(255) DEFAULT NULL,
  `credit_no_field` varchar(255) DEFAULT NULL,
  `bidding_start` datetime DEFAULT NULL,
  `bidding_end` datetime DEFAULT NULL,
  `timezone` varchar(255) DEFAULT NULL,
  `reserved_field` varchar(255) DEFAULT NULL,
  `bid_open` datetime DEFAULT NULL,
  `bid_close` datetime DEFAULT NULL,
  `round_duration` int(11) DEFAULT NULL,
  `supplier_mine_id` int(11) DEFAULT NULL,
  `sight_reserved_field` varchar(255) DEFAULT NULL,
  `rounds_between_duration` int(11) DEFAULT NULL,
  `round_open_time` datetime DEFAULT NULL,
  `round` int(11) DEFAULT '1',
  `updated_after_round` tinyint(1) DEFAULT NULL,
  `sight_starting_price_field` varchar(255) DEFAULT NULL,
  `stone_starting_price_field` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tenders`
--

LOCK TABLES `tenders` WRITE;
/*!40000 ALTER TABLE `tenders` DISABLE KEYS */;
/*!40000 ALTER TABLE `tenders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trading_documents`
--

DROP TABLE IF EXISTS `trading_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trading_documents` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `document_file_name` varchar(255) DEFAULT NULL,
  `document_content_type` varchar(255) DEFAULT NULL,
  `document_file_size` int(11) DEFAULT NULL,
  `document_updated_at` datetime DEFAULT NULL,
  `credit_field` varchar(255) DEFAULT NULL,
  `lot_no_field` varchar(255) DEFAULT NULL,
  `desc_field` varchar(255) DEFAULT NULL,
  `no_of_stones_field` varchar(255) DEFAULT NULL,
  `weight_field` varchar(255) DEFAULT NULL,
  `sheet_no` int(11) DEFAULT NULL,
  `customer_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `company_id` int(11) DEFAULT NULL,
  `diamond_type` varchar(255) DEFAULT NULL,
  `source_field` varchar(255) DEFAULT NULL,
  `box_field` varchar(255) DEFAULT NULL,
  `cost_field` varchar(255) DEFAULT NULL,
  `box_value_field` varchar(255) DEFAULT NULL,
  `sight_field` varchar(255) DEFAULT NULL,
  `price_field` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_trading_documents_on_customer_id` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trading_documents`
--

LOCK TABLES `trading_documents` WRITE;
/*!40000 ALTER TABLE `trading_documents` DISABLE KEYS */;
/*!40000 ALTER TABLE `trading_documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trading_parcels`
--

DROP TABLE IF EXISTS `trading_parcels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trading_parcels` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `lot_no` int(11) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `no_of_stones` int(11) DEFAULT NULL,
  `weight` decimal(16,2) DEFAULT NULL,
  `credit_period` int(11) DEFAULT NULL,
  `price` decimal(12,2) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `customer_id` bigint(20) DEFAULT NULL,
  `trading_document_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `cost` double DEFAULT NULL,
  `box_value` varchar(255) DEFAULT NULL,
  `sight` varchar(255) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `box` varchar(255) DEFAULT NULL,
  `sold` tinyint(1) DEFAULT '0',
  `uid` varchar(255) DEFAULT NULL,
  `diamond_type` varchar(255) DEFAULT NULL,
  `for_sale` int(11) DEFAULT '1',
  `broker_ids` text,
  `sale_all` tinyint(1) DEFAULT '0',
  `sale_none` tinyint(1) DEFAULT '1',
  `sale_broker` tinyint(1) DEFAULT '0',
  `sale_credit` tinyint(1) DEFAULT '0',
  `sale_demanded` tinyint(1) DEFAULT '0',
  `percent` decimal(16,2) DEFAULT NULL,
  `comment` text,
  `total_value` decimal(12,2) DEFAULT NULL,
  `shape` varchar(255) DEFAULT NULL,
  `color` varchar(255) DEFAULT NULL,
  `clarity` varchar(255) DEFAULT NULL,
  `cut` varchar(255) DEFAULT NULL,
  `polish` varchar(255) DEFAULT NULL,
  `symmetry` varchar(255) DEFAULT NULL,
  `fluorescence` varchar(255) DEFAULT NULL,
  `lab` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `anonymous` tinyint(1) DEFAULT '0',
  `size` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_trading_parcels_on_customer_id` (`customer_id`),
  KEY `index_trading_parcels_on_trading_document_id` (`trading_document_id`)
) ENGINE=InnoDB AUTO_INCREMENT=168 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trading_parcels`
--

LOCK TABLES `trading_parcels` WRITE;
/*!40000 ALTER TABLE `trading_parcels` DISABLE KEYS */;
INSERT INTO `trading_parcels` VALUES (1,NULL,'Dummy Parcel for Demo',NULL,10.00,30,10.00,1,NULL,NULL,'2018-12-02 08:04:34','2018-12-02 08:04:34',10,'12','07/18','OUTSIDE GOODS','2',0,'1fd20d6a','N/A',1,NULL,0,0,0,0,1,0.00,'This is a Demo Parcel',100.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(2,NULL,'Dummy Parcel for Demo',NULL,10.00,30,10.00,1,NULL,NULL,'2018-12-02 08:04:34','2018-12-02 08:04:34',10,'12','07/18','OUTSIDE GOODS','2',1,'37adf6fb','N/A',1,NULL,0,0,0,0,1,0.00,'This is a Demo Parcel',100.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(3,NULL,NULL,0,10.00,30,10.00,1,NULL,NULL,'2018-12-02 08:04:34','2018-12-02 08:04:34',10,'0',NULL,'POLISHED',NULL,0,'27646b8e','Polished',1,NULL,0,0,0,0,1,0.00,'This is Dummy Polished Parcel',240.00,'Round','M','SI3','Good','Excellent','Excellent','None','GCAL','Kabul','Afghanistan',0,NULL),(4,NULL,'Dummy Parcel for Demo',NULL,10.00,30,10.00,2,NULL,NULL,'2018-12-02 08:04:34','2018-12-02 08:04:34',10,'12','07/18','OUTSIDE GOODS','2',0,'05b90c41','N/A',1,NULL,0,0,0,0,1,0.00,'This is a Demo Parcel',100.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(5,NULL,'Dummy Parcel for Demo',NULL,10.00,30,10.00,2,NULL,NULL,'2018-12-02 08:04:34','2018-12-02 08:04:34',10,'12','07/18','OUTSIDE GOODS','2',1,'9056b5e4','N/A',1,NULL,0,0,0,0,1,0.00,'This is a Demo Parcel',100.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(6,NULL,NULL,0,10.00,30,10.00,2,NULL,NULL,'2018-12-02 08:04:34','2018-12-02 08:04:34',10,'0',NULL,'POLISHED',NULL,0,'e729192f','Polished',1,NULL,0,0,0,0,1,0.00,'This is Dummy Polished Parcel',240.00,'Round','M','SI3','Good','Excellent','Excellent','None','GCAL','Kabul','Afghanistan',0,NULL),(7,NULL,'Dummy Parcel for Demo',NULL,10.00,30,10.00,3,NULL,NULL,'2018-12-02 08:04:34','2018-12-02 08:04:34',10,'12','07/18','OUTSIDE GOODS','2',0,'4100404b','N/A',1,NULL,0,0,0,0,1,0.00,'This is a Demo Parcel',100.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(8,NULL,'Dummy Parcel for Demo',NULL,10.00,30,10.00,3,NULL,NULL,'2018-12-02 08:04:34','2018-12-02 08:04:34',10,'12','07/18','OUTSIDE GOODS','2',1,'482d2b4e','N/A',1,NULL,0,0,0,0,1,0.00,'This is a Demo Parcel',100.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(9,NULL,NULL,0,10.00,30,10.00,3,NULL,NULL,'2018-12-02 08:04:34','2018-12-02 08:04:34',10,'0',NULL,'POLISHED',NULL,0,'75769cd6','Polished',1,NULL,0,0,0,0,1,0.00,'This is Dummy Polished Parcel',240.00,'Round','M','SI3','Good','Excellent','Excellent','None','GCAL','Kabul','Afghanistan',0,NULL),(10,NULL,'Dummy Parcel for Demo',NULL,10.00,30,10.00,4,NULL,NULL,'2018-12-02 08:04:34','2018-12-02 08:04:34',10,'12','07/18','OUTSIDE GOODS','2',0,'1166a351','N/A',1,NULL,0,0,0,0,1,0.00,'This is a Demo Parcel',100.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(11,NULL,'Dummy Parcel for Demo',NULL,10.00,30,10.00,4,NULL,NULL,'2018-12-02 08:04:34','2018-12-02 08:04:34',10,'12','07/18','OUTSIDE GOODS','2',1,'77a2594b','N/A',1,NULL,0,0,0,0,1,0.00,'This is a Demo Parcel',100.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(12,NULL,NULL,0,10.00,30,10.00,4,NULL,NULL,'2018-12-02 08:04:34','2018-12-02 08:04:34',10,'0',NULL,'POLISHED',NULL,0,'5e2e3849','Polished',1,NULL,0,0,0,0,1,0.00,'This is Dummy Polished Parcel',240.00,'Round','M','SI3','Good','Excellent','Excellent','None','GCAL','Kabul','Afghanistan',0,NULL),(13,NULL,'Dummy Parcel for Demo',NULL,10.00,30,10.00,5,NULL,NULL,'2018-12-02 08:04:34','2018-12-02 08:04:34',10,'12','07/18','OUTSIDE GOODS','2',0,'1a847218','N/A',1,NULL,0,0,0,0,1,0.00,'This is a Demo Parcel',100.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(14,NULL,'Dummy Parcel for Demo',NULL,10.00,30,10.00,5,NULL,NULL,'2018-12-02 08:04:34','2018-12-02 08:04:34',10,'12','07/18','OUTSIDE GOODS','2',1,'a25fc457','N/A',1,NULL,0,0,0,0,1,0.00,'This is a Demo Parcel',100.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(15,NULL,NULL,0,10.00,30,10.00,5,NULL,NULL,'2018-12-02 08:04:34','2018-12-02 08:04:34',10,'0',NULL,'POLISHED',NULL,0,'a730c8c0','Polished',1,NULL,0,0,0,0,1,0.00,'This is Dummy Polished Parcel',240.00,'Round','M','SI3','Good','Excellent','Excellent','None','GCAL','Kabul','Afghanistan',0,NULL),(17,NULL,'Dummy Parcel for Demo',NULL,10.00,30,10.00,6,NULL,NULL,'2018-12-02 08:04:35','2018-12-02 08:04:35',10,'12','07/18','OUTSIDE GOODS','2',1,'9b514b13','N/A',1,NULL,0,0,0,0,1,0.00,'This is a Demo Parcel',100.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(18,NULL,NULL,0,10.00,30,10.00,6,NULL,NULL,'2018-12-02 08:04:35','2018-12-02 08:04:35',10,'0',NULL,'POLISHED',NULL,0,'cc807c79','Polished',1,NULL,0,0,0,0,1,0.00,'This is Dummy Polished Parcel',240.00,'Round','M','SI3','Good','Excellent','Excellent','None','GCAL','Kabul','Afghanistan',0,NULL),(57,NULL,'+9 SAWABLES LIGHT',1,1.00,15,1.01,5,5,NULL,'2018-12-05 18:29:54','2018-12-05 18:29:54',1,NULL,'12/2018','RUSSIAN',NULL,1,'8cb06e17','Sight',1,NULL,0,0,0,0,1,1.00,NULL,1.01,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(58,NULL,'+9 SAWABLES LIGHT',1,1.00,15,1.01,5,5,NULL,'2018-12-05 18:35:48','2018-12-05 18:35:48',1,NULL,'12/2018','RUSSIAN',NULL,1,'ca9fbf5a','Sight',1,NULL,0,0,0,0,1,1.00,NULL,1.01,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(62,NULL,'+9 SAWABLES LIGHT',0,108.00,60,200.00,5,5,NULL,'2018-12-06 07:22:30','2018-12-06 07:22:30',NULL,NULL,'12/2018','RUSSIAN',NULL,1,'f8ad11d2','Sight',1,NULL,0,0,0,0,1,0.00,'',21600.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(63,NULL,'+11 CLIV/MB LIGHT',0,103.00,30,175.00,5,5,NULL,'2018-12-06 07:23:08','2018-12-06 07:23:08',NULL,NULL,'12/2018','RUSSIAN',NULL,1,'9e1b8556','Sight',1,NULL,0,0,0,0,1,0.00,'',18025.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(64,NULL,'+11 BLK ST LIGHT',0,105.00,90,195.00,5,5,NULL,'2018-12-06 07:23:41','2018-12-06 07:23:41',NULL,NULL,'12/2018','RUSSIAN',NULL,0,'a99d2e50','Sight',1,NULL,0,0,0,0,1,0.00,'',20475.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(65,NULL,'+11 REJECTIONS',0,110.00,75,199.00,5,5,NULL,'2018-12-06 07:27:22','2018-12-06 07:27:22',NULL,NULL,'12/2018','RUSSIAN',NULL,1,'7de504dd','Sight',1,NULL,0,0,0,0,1,0.00,'',21890.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(66,NULL,'+11 SAWABLES LIGHT',0,101.00,70,190.00,5,5,NULL,'2018-12-06 07:28:27','2018-12-06 07:28:27',NULL,NULL,'12/2018','RUSSIAN',NULL,1,'f74a8043','Sight',1,NULL,0,0,0,0,1,0.00,'',19190.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(67,NULL,'+9 SAWABLES LIGHT',0,85.00,60,200.00,4,7,NULL,'2018-12-06 07:29:57','2018-12-06 07:29:57',NULL,NULL,'12/2018','RUSSIAN',NULL,0,'84b9026d','Sight',1,NULL,0,0,0,0,1,0.00,'',17000.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(68,NULL,'+11 CLIV/MB LIGHT',0,80.00,30,175.00,4,7,NULL,'2018-12-06 07:30:20','2018-12-07 16:48:07',15,NULL,'12/2018','RUSSIAN',NULL,1,'7f2a834a','Sight',1,NULL,0,0,0,0,1,0.00,'',14000.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(69,NULL,'+11 BLK ST LIGHT',0,75.00,90,195.00,4,7,NULL,'2018-12-06 07:30:58','2018-12-06 07:30:58',NULL,NULL,'12/2018','RUSSIAN',NULL,0,'d90e6c7a','Sight',1,NULL,0,0,0,0,1,0.00,'',14625.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(70,NULL,'+11 REJECTIONS',0,90.00,75,199.00,4,7,NULL,'2018-12-06 07:31:40','2018-12-06 07:31:40',NULL,NULL,'12/2018','RUSSIAN',NULL,0,'ef1288ce','Sight',1,NULL,0,0,0,0,1,0.00,'',17910.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(71,NULL,'+11 SAWABLES LIGHT',0,70.00,70,190.00,4,7,NULL,'2018-12-06 07:32:27','2018-12-06 07:32:27',NULL,NULL,'12/2018','RUSSIAN',NULL,0,'983d1ace','Sight',1,NULL,0,0,0,0,1,0.00,'',13300.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(73,NULL,'Dummy Parcel for Demo',NULL,10.00,30,10.00,7,NULL,NULL,'2018-12-06 09:12:48','2018-12-06 09:12:48',10,'12','07/18','OutSide Goods','2',0,'6f5c726a','N/A',1,NULL,0,0,0,0,1,0.00,'This is a Demo Parcel',100.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(74,NULL,'Dummy Parcel for Demo',NULL,10.00,30,10.00,7,NULL,NULL,'2018-12-06 09:12:48','2018-12-06 09:12:48',10,'12','07/18','OutSide Goods','2',1,'65d1ac6b','N/A',1,NULL,0,0,0,0,1,0.00,'This is a Demo Parcel',100.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(75,NULL,NULL,0,10.00,30,10.00,7,NULL,NULL,'2018-12-06 09:12:48','2018-12-06 09:12:48',10,'0',NULL,'POLISHED',NULL,0,'0561a4e1','Polished',1,NULL,0,0,0,0,1,0.00,'This is Dummy Polished Parcel',240.00,'Round','M','SI3','Good','Excellent','Excellent','None','GCAL','Kabul','Afghanistan',0,NULL),(76,NULL,'Dummy Parcel for Demo',NULL,10.00,30,10.00,8,NULL,NULL,'2018-12-06 09:12:54','2018-12-06 09:12:54',10,'12','07/18','OutSide Goods','2',0,'65900b8f','N/A',1,NULL,0,0,0,0,1,0.00,'This is a Demo Parcel',100.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(77,NULL,'Dummy Parcel for Demo',NULL,10.00,30,10.00,8,NULL,NULL,'2018-12-06 09:12:54','2018-12-06 09:12:54',10,'12','07/18','OutSide Goods','2',1,'7ed3388f','N/A',1,NULL,0,0,0,0,1,0.00,'This is a Demo Parcel',100.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(78,NULL,NULL,0,10.00,30,10.00,8,NULL,NULL,'2018-12-06 09:12:54','2018-12-06 09:12:54',10,'0',NULL,'POLISHED',NULL,0,'532d181a','Polished',1,NULL,0,0,0,0,1,0.00,'This is Dummy Polished Parcel',240.00,'Round','M','SI3','Good','Excellent','Excellent','None','GCAL','Kabul','Afghanistan',0,NULL),(79,NULL,'Dummy Parcel for Demo',NULL,10.00,30,10.00,9,NULL,NULL,'2018-12-06 09:13:00','2018-12-06 09:13:00',10,'12','07/18','OutSide Goods','2',0,'77db4067','N/A',1,NULL,0,0,0,0,1,0.00,'This is a Demo Parcel',100.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(80,NULL,'Dummy Parcel for Demo',NULL,10.00,30,10.00,9,NULL,NULL,'2018-12-06 09:13:00','2018-12-06 09:13:00',10,'12','07/18','OutSide Goods','2',1,'fc709860','N/A',1,NULL,0,0,0,0,1,0.00,'This is a Demo Parcel',100.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(81,NULL,NULL,0,10.00,30,10.00,9,NULL,NULL,'2018-12-06 09:13:00','2018-12-06 09:13:00',10,'0',NULL,'POLISHED',NULL,0,'9dd12901','Polished',1,NULL,0,0,0,0,1,0.00,'This is Dummy Polished Parcel',240.00,'Round','M','SI3','Good','Excellent','Excellent','None','GCAL','Kabul','Afghanistan',0,NULL),(82,NULL,'Dummy Parcel for Demo',NULL,10.00,30,10.00,10,NULL,NULL,'2018-12-06 09:13:08','2018-12-06 09:13:08',10,'12','07/18','OutSide Goods','2',0,'ed18eb4f','N/A',1,NULL,0,0,0,0,1,0.00,'This is a Demo Parcel',100.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(83,NULL,'Dummy Parcel for Demo',NULL,10.00,30,10.00,10,NULL,NULL,'2018-12-06 09:13:08','2018-12-06 09:13:08',10,'12','07/18','OutSide Goods','2',1,'c7084d5f','N/A',1,NULL,0,0,0,0,1,0.00,'This is a Demo Parcel',100.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(84,NULL,NULL,0,10.00,30,10.00,10,NULL,NULL,'2018-12-06 09:13:08','2018-12-06 09:13:08',10,'0',NULL,'POLISHED',NULL,0,'0f0d1d8b','Polished',1,NULL,0,0,0,0,1,0.00,'This is Dummy Polished Parcel',240.00,'Round','M','SI3','Good','Excellent','Excellent','None','GCAL','Kabul','Afghanistan',0,NULL),(85,NULL,'+11 CLIV/MB LIGHT',10,1.00,20,3300.00,7,14,NULL,'2018-12-06 10:01:44','2018-12-06 10:01:44',3000,'0','12/18','RUSSIAN',NULL,1,'ce9ccbd5','Sight',1,'--- \'\'\n',0,0,0,0,1,10.00,'',3300.00,'','','','','','','','','','AF',0,NULL),(87,NULL,'+11 CLIV/MB LIGHT',10,1.00,20,3300.00,7,14,NULL,'2018-12-06 16:27:26','2018-12-06 16:27:26',3000,NULL,'12/2018','RUSSIAN',NULL,1,'72257d15','Sight',1,NULL,0,0,0,0,1,10.00,NULL,3300.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(88,NULL,'+11 CLIV/MB LIGHT',10,1.00,20,3300.00,8,14,NULL,'2018-12-06 16:31:36','2018-12-06 16:31:36',3000,NULL,'12/2018','RUSSIAN',NULL,0,'30f67314','Sight',1,NULL,0,0,0,0,1,10.00,NULL,3300.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(89,NULL,'+9 SAWABLES LIGHT',10,1.00,15,3300.00,8,16,NULL,'2018-12-06 17:27:49','2018-12-06 17:27:49',3000,NULL,'12/2018','RUSSIAN',NULL,1,'dafbcaa2','Sight',1,NULL,0,0,0,0,1,10.00,'',3300.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(93,NULL,'+11 SAWABLES LIGHT',0,100.00,30,15.00,9,17,NULL,'2018-12-06 17:46:18','2018-12-06 17:46:18',NULL,NULL,'12/2018','RUSSIAN',NULL,0,'14d667db','Sight',1,NULL,0,0,0,0,1,0.00,'',1500.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(94,NULL,'+11 REJECTIONS',0,200.00,60,20.00,9,17,NULL,'2018-12-06 17:46:35','2018-12-06 17:46:35',NULL,NULL,'12/2018','RUSSIAN',NULL,0,'e8bd5b4f','Sight',1,NULL,0,0,0,0,1,0.00,'',4000.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(95,NULL,'+11 BLK ST LIGHT',0,300.00,60,30.00,9,17,NULL,'2018-12-06 17:46:52','2018-12-06 17:46:52',NULL,NULL,'12/2018','RUSSIAN',NULL,1,'c83ed30a','Sight',1,NULL,0,0,0,0,1,0.00,'',9000.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(97,NULL,'+9 SAWABLES LIGHT',NULL,100.00,30,500.00,4,7,NULL,'2018-12-07 12:04:47','2018-12-07 12:04:47',NULL,NULL,'11/2018','RUSSIAN',NULL,1,'e73e8b6f','Sight',1,NULL,0,0,0,0,1,0.00,NULL,50000.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(98,NULL,'+9 SAWABLES LIGHT',NULL,100.00,30,500.00,3,7,NULL,'2018-12-07 12:06:21','2018-12-07 12:06:21',NULL,NULL,'11/2018','RUSSIAN',NULL,0,'38a5a9ed','Sight',1,NULL,0,0,0,0,1,0.00,NULL,50000.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(99,NULL,'5-10 Cts BLK CLIV WHITE',10,1.00,2000,5000.00,9,17,NULL,'2018-12-07 12:29:14','2018-12-07 12:29:14',NULL,NULL,'','DTC',NULL,0,'1f8e3433','Sight',1,NULL,0,0,0,0,1,10.00,'',5000.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(100,NULL,'5-10 Cts BLK CLIV WHITE',10,1.00,2000,5000.00,9,17,NULL,'2018-12-07 12:30:51','2018-12-07 12:30:51',NULL,NULL,'','DTC',NULL,0,'a9a66c00','Sight',1,NULL,0,0,0,0,1,10.00,'',5000.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(101,NULL,'5-10 Cts BLK CLIV WHITE',10,1.00,2000,5000.00,9,17,NULL,'2018-12-07 12:30:52','2018-12-07 12:30:52',NULL,NULL,'','DTC',NULL,0,'fd34b13c','Sight',1,NULL,0,0,0,0,1,10.00,'',5000.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(103,NULL,'+9 SAWABLES LIGHT',NULL,500.00,30,100.00,5,5,NULL,'2018-12-07 12:31:48','2018-12-07 12:31:48',NULL,NULL,'11/2018','RUSSIAN',NULL,1,'de171b01','Sight',1,NULL,0,0,0,0,1,0.00,NULL,50000.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(104,NULL,'+9 SAWABLES LIGHT',NULL,500.00,30,100.00,3,5,NULL,'2018-12-07 12:48:09','2018-12-07 12:48:09',NULL,NULL,'11/2018','RUSSIAN',NULL,0,'0e175f36','Sight',1,NULL,0,0,0,0,1,0.00,NULL,50000.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(105,NULL,'+9 SAWABLES LIGHT',NULL,150.00,60,25.00,5,5,NULL,'2018-12-07 17:58:07','2018-12-07 17:58:07',NULL,'0','12/18','RUSSIAN',NULL,1,'4e2966e7','Sight',1,'--- \'\'\n',0,0,0,0,1,0.00,'',3750.00,'','','','','','','','','','AF',0,NULL),(106,NULL,'+11 CLIV/MB LIGHT',NULL,125.00,9,11.00,5,5,NULL,'2018-12-07 18:02:19','2018-12-07 18:02:19',NULL,'0','11/18','RUSSIAN',NULL,1,'8a1f5239','Sight',1,'--- \'\'\n',0,0,0,0,1,0.00,'',1375.00,'','','','','','','','','','AF',0,NULL),(107,NULL,'+11 CLIV/MB LIGHT',NULL,125.00,9,11.00,3,5,NULL,'2018-12-08 09:15:27','2018-12-08 09:15:27',NULL,'0','11/18','RUSSIAN',NULL,0,'eb3f1c34','Sight',1,'--- \'\'\n',0,0,0,0,1,0.00,'',1375.00,'','','','','','','','','','AF',0,NULL),(108,NULL,'+9 SAWABLES LIGHT',NULL,150.00,60,25.00,3,5,NULL,'2018-12-08 09:15:31','2018-12-08 09:15:31',NULL,'0','12/18','RUSSIAN',NULL,0,'3593603f','Sight',1,'--- \'\'\n',0,0,0,0,1,0.00,'',3750.00,'','','','','','','','','','AF',0,NULL),(111,NULL,'+9 SAWABLES LIGHT',NULL,100.00,60,200.00,5,5,NULL,'2018-12-08 09:17:34','2018-12-08 09:17:34',NULL,NULL,'12/2018','RUSSIAN',NULL,1,'7490c9e5','Sight',1,NULL,0,0,0,0,1,0.00,NULL,20000.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(112,NULL,'+11 CLIV/MB LIGHT',32,32.00,20,36.30,8,16,NULL,'2018-12-08 11:00:50','2018-12-08 11:00:50',33,NULL,'12/2016','RUSSIAN',NULL,0,'842de177','Sight',1,NULL,0,0,0,0,1,10.00,'this is comment',1161.60,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(113,NULL,'+9 SAWABLES LIGHT',80,50.00,80,90.00,8,16,NULL,'2018-12-08 11:55:57','2018-12-08 11:55:57',50,NULL,'12/2018','RUSSIAN',NULL,1,'e95a598e','Sight',1,NULL,0,0,0,0,1,80.00,'fjtdub',4500.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(114,NULL,'+11 BLK ST LIGHT',34,34.00,343,45.56,8,21,NULL,'2018-12-08 12:06:08','2018-12-08 12:06:08',34,'22','12/18','RUSSIAN',NULL,1,'839668b8','Sight',1,'--- \'\'\n',0,0,0,0,1,34.00,'ssfsfqsfqsfqsf',1549.04,'','','','','','','','','','AF',0,NULL),(115,NULL,'+11 CLIV/MB LIGHT',34,34.00,34,45.56,8,21,NULL,'2018-12-08 12:09:31','2018-12-08 12:09:31',34,'34','12/18','RUSSIAN',NULL,1,'ac122a40','Sight',1,'--- \'\'\n',0,0,0,0,1,34.00,'asdasdadasdasd',1549.04,'','','','','','','','','','AF',0,NULL),(116,NULL,'+9 SAWABLES LIGHT',5,5.00,558,5.25,8,16,NULL,'2018-12-08 14:09:39','2018-12-08 14:09:39',5,NULL,'12/2018','RUSSIAN',NULL,1,'775948f2','Sight',1,NULL,0,0,0,0,1,5.00,'fugjhgjbybuh',26.25,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(117,NULL,'Collection 5-10 ct',10,1.00,20,3300.00,8,16,NULL,'2018-12-08 14:28:20','2018-12-08 14:28:20',3000,NULL,'12/2018','DTC',NULL,1,'b708e0e7','Sight',1,NULL,0,0,0,0,1,10.00,'',3300.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(118,NULL,'+9 SAWABLES LIGHT',NULL,100.00,60,200.00,3,5,NULL,'2018-12-10 00:37:40','2018-12-10 00:37:40',NULL,NULL,'12/2018','RUSSIAN',NULL,0,'ca2bca80','Sight',1,NULL,0,0,0,0,1,0.00,NULL,20000.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(120,NULL,'+9 SAWABLES LIGHT',NULL,500.00,15,200.00,5,5,NULL,'2018-12-10 01:05:22','2018-12-10 01:05:22',NULL,NULL,'11/2018','RUSSIAN',NULL,1,'95961ebc','Sight',1,NULL,0,0,0,0,1,0.00,NULL,100000.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(121,NULL,'+9 SAWABLES LIGHT',NULL,500.00,15,200.00,3,5,NULL,'2018-12-10 02:13:44','2018-12-10 02:13:44',NULL,NULL,'11/2018','RUSSIAN',NULL,0,'e0953d07','Sight',1,NULL,0,0,0,0,1,0.00,NULL,100000.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(122,NULL,'-11+9 BLK ST LIGHT',0,200.00,60,165.00,6,6,NULL,'2018-12-10 02:28:08','2018-12-10 02:28:08',150,NULL,'12/2018','RUSSIAN',NULL,1,'5959459e','Sight',1,NULL,0,0,0,0,1,10.00,'',33000.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(123,NULL,'Fine 5-14.8 ct',10,1.00,20,3300.00,8,16,NULL,'2018-12-10 08:24:50','2018-12-10 08:24:50',3000,NULL,'12/2018','DTC',NULL,1,'964b3ea8','Sight',1,NULL,0,0,0,0,1,10.00,'',3300.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(125,NULL,'+9 SAWABLES LIGHT',NULL,100.00,30,1000.00,5,5,NULL,'2018-12-10 08:43:10','2018-12-10 08:43:10',NULL,NULL,'12/2018','RUSSIAN',NULL,1,'a2af0176','Sight',1,NULL,0,0,0,0,1,0.00,NULL,100000.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(126,NULL,'+9 SAWABLES LIGHT',NULL,100.00,30,1000.00,3,5,NULL,'2018-12-10 08:44:21','2018-12-10 08:44:21',NULL,NULL,'12/2018','RUSSIAN',NULL,0,'05fc6f6c','Sight',1,NULL,0,0,0,0,1,0.00,NULL,100000.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(127,NULL,'Collection 5-10 ct',10,1.00,20,3300.00,8,16,NULL,'2018-12-10 10:09:03','2018-12-10 10:09:03',3000,NULL,'12/2018','DTC',NULL,1,'9fb55b23','Sight',1,NULL,0,0,0,0,1,10.00,'',3300.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(128,NULL,'Col\'d Fine 5-14 ct.',10,1.00,20,3300.00,8,16,NULL,'2018-12-10 10:15:06','2018-12-10 10:15:06',3000,NULL,'12/2018','DTC',NULL,1,'8e78bd95','Sight',1,NULL,0,0,0,0,1,10.00,'',3300.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(130,NULL,'Crystals 5-14.8 ct.',10,1.00,15,3300.00,8,16,NULL,'2018-12-10 11:48:39','2018-12-10 11:48:39',3000,NULL,'12/2018','DTC',NULL,1,'1b76d2c9','Sight',1,NULL,0,0,0,0,1,10.00,NULL,3300.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(131,NULL,'Crystals 5-14.8 ct.',10,1.00,15,3300.00,7,16,NULL,'2018-12-10 11:49:26','2018-12-10 11:49:26',3000,NULL,'12/2018','DTC',NULL,0,'82ba8e5f','Sight',1,NULL,0,0,0,0,1,10.00,NULL,3300.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(132,NULL,'Coloured 2.5-14.8 ct',10,1.00,15,3300.00,7,14,NULL,'2018-12-10 14:09:30','2018-12-10 14:09:30',3000,NULL,'12/2018','DTC',NULL,0,'8ec4e19e','Sight',1,NULL,0,0,0,0,1,10.00,'',3300.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(133,NULL,'Commercial 5-14.8 ct',10,1.00,20,3500.00,8,16,NULL,'2018-12-10 14:26:59','2018-12-10 14:26:59',3000,NULL,'12/2018','DTC',NULL,0,'636a4fd4','Sight',1,NULL,0,0,0,0,1,16.67,'',3500.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(134,NULL,'+11 REJECTIONS',23,22.95,23,28.29,8,21,NULL,'2018-12-10 14:55:17','2018-12-10 14:55:17',23,'34','12/18','RUSSIAN',NULL,1,'8d1c7247','Sight',1,'--- \'\'\n',0,0,0,0,1,23.00,'adasdadasd',649.26,'','','','','','','','','','AF',0,NULL),(135,NULL,'Coloured 2.5-14.8 ct',10,1.00,15,3300.00,9,17,NULL,'2018-12-10 14:57:06','2018-12-10 14:57:06',3000,NULL,'12/2018','DTC',NULL,1,'9fc465d4','Sight',1,NULL,0,0,0,0,1,10.00,'',3300.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(136,NULL,'+9 SAWABLES LIGHT',10,1.00,15,3300.00,9,17,NULL,'2018-12-10 15:06:40','2018-12-10 15:06:40',3000,NULL,'12/2018','RUSSIAN',NULL,0,'0494bbd8','Sight',1,NULL,0,0,0,0,1,10.00,'',3300.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(137,NULL,'Fine 5-14.8 ct',10,1.00,15,3300.00,9,17,NULL,'2018-12-10 15:07:18','2018-12-10 15:07:18',3000,NULL,'12/2018','DTC',NULL,1,'2287751a','Sight',1,NULL,0,0,0,0,1,10.00,'',3300.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(139,NULL,'Crystals 5-14.8 ct.',10,1.00,20,3900.00,9,17,NULL,'2018-12-10 15:08:13','2018-12-10 15:08:13',3000,NULL,'12/2018','DTC',NULL,1,'3066cdb6','Sight',1,NULL,0,0,0,0,1,30.00,NULL,3900.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(140,NULL,'Crystals 5-14.8 ct.',10,1.00,20,3900.00,10,17,NULL,'2018-12-10 15:09:52','2018-12-10 15:09:52',3000,NULL,'12/2018','DTC',NULL,0,'e38da3bb','Sight',1,NULL,0,0,0,0,1,30.00,NULL,3900.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(141,NULL,'Col\'d Fine 5-14 ct.',34,34.00,34,45.56,8,21,NULL,'2018-12-10 15:34:34','2018-12-10 15:34:34',34,'34','12/18','DTC',NULL,1,'052b03bc','Sight',1,'--- \'\'\n',0,0,0,0,1,34.00,'',1549.04,'','','','','','','','','','AF',0,NULL),(142,NULL,'Basket +14.8 ct-buffer',10,1.00,15,2000.00,8,16,NULL,'2018-12-11 08:10:39','2018-12-11 08:10:39',NULL,NULL,'12/2018','DTC',NULL,0,'937460cf','Sight',1,NULL,0,0,0,0,1,10.00,'',2000.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(143,NULL,'Select MB 5-14.8 ct',10,1.00,20,5000.00,8,16,NULL,'2018-12-11 08:12:38','2018-12-11 08:12:38',NULL,NULL,'12/2018','DTC',NULL,1,'4ec1cf3b','Sight',1,NULL,0,0,0,0,1,3000.00,'',5000.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(145,NULL,'Spotted Z 5-10 ct',10,1.00,20,4000.00,9,17,NULL,'2018-12-11 08:19:46','2018-12-11 08:19:46',NULL,NULL,'12/2018','DTC',NULL,1,'604f8ac0','Sight',1,NULL,0,0,0,0,1,10.00,NULL,4000.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(146,NULL,'Spotted Z 5-10 ct',10,1.00,20,4000.00,10,17,NULL,'2018-12-11 08:47:02','2018-12-11 08:47:02',NULL,NULL,'12/2018','DTC',NULL,0,'fe950d67','Sight',1,NULL,0,0,0,0,1,10.00,NULL,4000.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(147,NULL,'Collection 5-10 ct',10,1.00,15,3000.00,5,5,NULL,'2018-12-11 09:37:00','2018-12-11 09:37:00',NULL,NULL,'12/2018','DTC',NULL,0,'7acec9df','Sight',1,NULL,0,0,0,0,1,10.00,'',3000.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(148,NULL,'+9 SAWABLES LIGHT',0,120.00,60,25.00,5,5,NULL,'2018-12-11 09:40:54','2018-12-11 09:40:54',NULL,'0','11/18','RUSSIAN',NULL,0,'0d498274','Sight',1,'--- \'\'\n',0,0,0,0,1,0.00,'',3000.00,'','','','','','','','','','AF',0,NULL),(149,NULL,'Frosted 2.5-10 ct',10,1.00,20,4000.00,9,17,NULL,'2018-12-11 09:42:06','2018-12-11 09:42:06',NULL,NULL,'12/2018','DTC',NULL,0,'86c7f745','Sight',1,NULL,0,0,0,0,1,10.00,'',4000.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(150,NULL,'Fine 5-14.8 ct',34,23.00,342,113.56,8,21,NULL,'2018-12-11 11:28:55','2018-12-11 11:28:55',34,'43','12/18','DTC',NULL,0,'e5a3f94d','Sight',1,'--- \'\'\n',0,0,0,0,1,234.00,'werwerrwxrwrxwrxwr',2611.88,'','','','','','','','','','AF',0,NULL),(151,NULL,'Crystals 5-14.8 ct.',0,0.00,0,0.00,8,21,NULL,'2018-12-11 11:29:23','2018-12-11 11:29:23',NULL,'0','12/18','DTC',NULL,0,'913ce5da','Sight',1,'--- \'\'\n',0,0,0,0,1,0.00,'werwerwerwr',0.00,'','','','','','','','','','AF',0,NULL),(152,NULL,'Fine 5-14.8 ct',4,0.00,0,0.00,8,21,NULL,'2018-12-11 11:34:32','2018-12-11 11:34:32',NULL,'0','12/18','DTC',NULL,0,'bdfbe855','Sight',1,'--- \'\'\n',0,0,0,0,1,0.00,'',0.00,'','','','','','','','','','AF',0,NULL),(153,NULL,'Crystals 5-14.8 ct.',10,1.00,20,3000.00,8,16,NULL,'2018-12-11 11:37:41','2018-12-11 11:37:41',NULL,NULL,'12/2018','DTC',NULL,0,'96fa9248','Sight',1,NULL,0,0,0,0,1,10.00,'',3000.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(154,NULL,'Basket +14.8 ct-buffer',10,1.00,3000,3000.00,7,14,NULL,'2018-12-11 11:47:39','2018-12-11 11:47:39',NULL,'0','12/18','DTC',NULL,0,'4e581ecd','Sight',1,'--- \'\'\n',0,0,0,0,1,0.00,'',3000.00,'','','','','','','','','','AF',0,NULL),(155,NULL,'Collection 5-10 ct',10,1.00,3000,3000.00,8,16,NULL,'2018-12-11 11:49:40','2018-12-11 11:49:40',NULL,'0','12/18','DTC',NULL,0,'a98d1901','Sight',1,'--- \'\'\n',0,0,0,0,1,0.00,'',3000.00,'','','','','','','','','','AF',0,NULL),(156,NULL,'Collection 5-10 ct',10,1.00,20,3300.00,8,16,NULL,'2018-12-11 14:14:37','2018-12-11 14:14:37',3000,NULL,'12/2018','DTC',NULL,1,'b60e33c8','Sight',1,NULL,0,0,0,0,1,10.00,NULL,3300.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(157,NULL,'Crystals 5-14.8 ct.',10,1.00,20,330.00,8,16,NULL,'2018-12-11 14:17:04','2018-12-11 14:17:04',300,NULL,'12/2018','DTC',NULL,1,'95ddca54','Sight',1,NULL,0,0,0,0,1,10.00,NULL,330.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(158,NULL,'Collection 5-10 ct',10,1.00,20,3300.00,10,16,NULL,'2018-12-11 14:23:34','2018-12-11 14:23:34',3000,NULL,'12/2018','DTC',NULL,0,'912252fb','Sight',1,NULL,0,0,0,0,1,10.00,NULL,3300.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(159,NULL,'Collection 5-10 ct',10,1.00,20,3300.00,10,16,NULL,'2018-12-11 14:23:37','2018-12-11 14:23:37',3000,NULL,'12/2018','DTC',NULL,0,'e49f2434','Sight',1,NULL,0,0,0,0,1,10.00,NULL,3300.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(160,NULL,'Collection 5-10 ct',10,1.00,20,3000.00,9,17,NULL,'2018-12-11 14:52:11','2018-12-11 14:52:11',NULL,NULL,'12/2018','DTC',NULL,1,'5bf03137','Sight',1,NULL,0,0,0,0,1,10.00,NULL,3000.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(161,NULL,'Collection 5-10 ct',10,1.00,20,3000.00,10,17,NULL,'2018-12-11 14:53:14','2018-12-11 14:53:14',NULL,NULL,'12/2018','DTC',NULL,0,'e7b1135d','Sight',1,NULL,0,0,0,0,1,10.00,NULL,3000.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(162,NULL,'Fine 5-14.8 ct',10,1.00,20,3300.00,8,16,NULL,'2018-12-11 14:55:26','2018-12-11 14:55:26',3000,NULL,'12/2018','DTC',NULL,1,'7efed1ef','Sight',1,NULL,0,0,0,0,1,10.00,NULL,3300.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(163,NULL,'Fine 5-14.8 ct',10,1.00,20,3300.00,10,16,NULL,'2018-12-11 14:56:02','2018-12-11 14:56:02',3000,NULL,'12/2018','DTC',NULL,0,'4f961e5f','Sight',1,NULL,0,0,0,0,1,10.00,NULL,3300.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(165,NULL,'+9 SAWABLES LIGHT',NULL,520.00,15,100.00,4,7,NULL,'2018-12-11 16:18:44','2018-12-11 16:18:44',NULL,NULL,'11/2018','RUSSIAN',NULL,1,'23928f86','Sight',1,NULL,0,0,0,0,1,0.00,NULL,52000.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(166,NULL,'+9 SAWABLES LIGHT',NULL,520.00,15,100.00,1,7,NULL,'2018-12-11 16:24:36','2018-12-11 16:24:36',NULL,NULL,'11/2018','RUSSIAN',NULL,0,'c1ce42cb','Sight',1,NULL,0,0,0,0,1,0.00,NULL,52000.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL),(167,NULL,'+9 SAWABLES LIGHT',NULL,520.00,15,100.00,1,7,NULL,'2018-12-11 16:24:50','2018-12-11 16:24:50',NULL,NULL,'11/2018','RUSSIAN',NULL,0,'6775408a','Sight',1,NULL,0,0,0,0,1,0.00,NULL,52000.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL);
/*!40000 ALTER TABLE `trading_parcels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transactions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `buyer_id` int(11) DEFAULT NULL,
  `seller_id` int(11) DEFAULT NULL,
  `trading_parcel_id` int(11) DEFAULT NULL,
  `due_date` datetime DEFAULT NULL,
  `price` decimal(12,2) DEFAULT NULL,
  `credit` int(11) DEFAULT NULL,
  `paid` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `buyer_confirmed` tinyint(1) DEFAULT '0',
  `reject_reason` text,
  `reject_date` datetime DEFAULT NULL,
  `transaction_type` varchar(255) DEFAULT NULL,
  `remaining_amount` decimal(16,2) DEFAULT NULL,
  `transaction_uid` varchar(255) DEFAULT NULL,
  `diamond_type` varchar(255) DEFAULT NULL,
  `total_amount` decimal(16,2) DEFAULT NULL,
  `invoice_no` varchar(255) DEFAULT NULL,
  `ready_for_buyer` tinyint(1) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `buyer_reject` tinyint(1) DEFAULT '0',
  `cancel` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
INSERT INTO `transactions` VALUES (17,8,7,87,'2018-12-25 18:30:00',3300.00,20,1,'2018-12-05 18:30:00','2018-12-06 17:14:11',1,NULL,NULL,'manual',0.00,'bf9bab6924cff07aa3ab279b','Sight',3300.00,NULL,NULL,'+11 CLIV/MB LIGHT',0,0),(18,7,8,89,'2018-12-20 18:30:00',3300.00,15,1,'2018-12-06 17:34:50','2018-12-06 18:07:14',1,NULL,NULL,NULL,0.00,'f30cb77dcc2d3767d85dbc4c','Sight',3300.00,NULL,NULL,'+9 SAWABLES LIGHT',0,0),(19,2,5,63,'2019-01-05 18:30:00',175.00,30,1,'2018-12-06 23:55:30','2018-12-10 00:28:00',1,NULL,NULL,NULL,0.00,'a693665cc9bf5f27953452ba','Sight',18025.00,NULL,NULL,'+11 CLIV/MB LIGHT',0,0),(20,10,7,85,'2018-12-26 18:30:00',3400.00,20,1,'2018-12-07 10:09:14','2018-12-10 09:17:46',1,NULL,NULL,NULL,0.00,'3ce8c24a90b802af63538300','Sight',3400.00,NULL,NULL,'+11 CLIV/MB LIGHT',0,0),(21,1,4,68,'2019-01-05 18:30:00',175.00,30,0,'2018-12-07 11:51:22','2018-12-07 11:54:22',1,NULL,NULL,NULL,5000.00,'e41fa4a83473fef1e55ff34b','Sight',14000.00,NULL,NULL,'+11 CLIV/MB LIGHT',0,0),(22,3,4,97,'2018-11-30 18:30:00',500.00,30,0,'2018-10-31 18:30:00','2018-12-12 00:05:43',1,NULL,NULL,'manual',20000.00,'8dce074bb297c3d35332072d','Sight',50000.00,NULL,NULL,'+9 SAWABLES LIGHT',0,0),(23,3,5,103,'2018-11-30 18:30:00',100.00,30,1,'2018-10-31 18:30:00','2018-12-10 00:34:27',1,NULL,NULL,'manual',0.00,'08e2a43b283a460ccefc0abf','Sight',50000.00,NULL,NULL,'+9 SAWABLES LIGHT',0,0),(24,3,5,65,'2019-02-19 18:30:00',199.00,75,1,'2018-12-07 12:32:14','2018-12-10 00:31:42',1,NULL,NULL,NULL,0.00,'407ac1c08f8090fbfc0fb27a','Sight',21890.00,NULL,NULL,'+11 REJECTIONS',0,0),(25,3,5,105,'2019-02-08 18:30:00',25.00,60,1,'2018-12-10 18:30:00','2018-12-10 00:33:00',1,NULL,NULL,'manual',0.00,'901edba26eca6f9201dee342','Sight',3750.00,NULL,NULL,'+9 SAWABLES LIGHT',0,0),(26,3,5,106,'2018-10-09 18:30:00',11.00,9,1,'2018-09-30 18:30:00','2018-12-10 00:34:56',1,NULL,NULL,'manual',0.00,'f572036151ca387229c323db','Sight',1375.00,NULL,NULL,'+11 CLIV/MB LIGHT',0,0),(27,3,5,111,'2018-02-05 18:30:00',200.00,60,1,'2017-12-07 18:30:00','2018-12-10 00:52:36',1,NULL,NULL,'manual',0.00,'dafc2aa2daf751b50984e3cc','Sight',20000.00,NULL,NULL,'+9 SAWABLES LIGHT',0,0),(28,7,8,113,'2019-02-25 18:30:00',90.00,80,1,'2018-12-08 11:59:58','2018-12-10 08:54:25',1,NULL,NULL,NULL,0.00,'b1d41ee4c0d01644181f2c3b','Sight',4500.00,NULL,NULL,'+9 SAWABLES LIGHT',0,0),(29,7,8,114,'2019-11-15 18:30:00',45.56,343,1,'2018-12-08 12:07:56','2018-12-10 08:55:18',1,NULL,NULL,NULL,0.00,'df6584a23a08320e19a24b6a','Sight',1549.04,NULL,NULL,'+11 BLK ST LIGHT',0,0),(30,7,8,115,'2019-01-10 18:30:00',45.56,34,0,'2018-12-08 12:10:09','2018-12-10 09:43:05',1,NULL,NULL,NULL,1049.04,'81790f2334f7a14d81b9cae0','Sight',1549.04,NULL,NULL,'+11 CLIV/MB LIGHT',0,0),(31,7,8,116,'2020-06-17 18:30:00',5.25,558,0,'2018-12-08 14:22:10','2018-12-08 14:22:10',1,NULL,NULL,NULL,26.25,'f262546226688b5f64265830','Sight',26.25,NULL,NULL,'+9 SAWABLES LIGHT',0,0),(32,7,8,117,'2018-12-27 18:30:00',3300.00,20,1,'2018-12-08 14:30:08','2018-12-10 09:40:01',1,NULL,NULL,NULL,0.00,'bfc4ae5154f688a29a4b74b8','Sight',3300.00,NULL,NULL,'Collection 5-10 ct',0,0),(33,3,5,120,'2018-11-15 18:30:00',200.00,15,0,'2018-10-31 18:30:00','2018-12-10 08:19:07',1,NULL,NULL,'manual',80000.00,'349fd0501003b8f8c0ad3af9','Sight',100000.00,NULL,NULL,'+9 SAWABLES LIGHT',0,0),(34,3,5,125,'2019-01-08 18:30:00',1000.00,30,0,'2018-12-09 18:30:00','2018-12-10 08:44:21',1,NULL,NULL,'manual',100000.00,'2c103078f8fc23268c8156f7','Sight',100000.00,NULL,NULL,'+9 SAWABLES LIGHT',0,0),(35,7,8,127,'2018-12-29 18:30:00',3300.00,20,0,'2018-12-10 10:12:24','2018-12-10 10:12:24',1,NULL,NULL,NULL,3300.00,'600be6d8bd4a691c5fe588a4','Sight',3300.00,NULL,NULL,'Collection 5-10 ct',0,0),(36,7,8,128,'2018-12-29 18:30:00',3300.00,20,0,'2018-12-10 10:16:01','2018-12-10 10:16:01',1,NULL,NULL,NULL,3300.00,'84afa74f1d66b6c862e8519c','Sight',3300.00,NULL,NULL,'Col\'d Fine 5-14 ct.',0,0),(37,7,8,130,'2018-12-25 00:00:00',3300.00,15,0,'2018-12-10 00:00:00','2018-12-10 11:49:26',1,NULL,NULL,'manual',3300.00,'1daa163dc57ca496db7625c9','Sight',3300.00,NULL,NULL,'Crystals 5-14.8 ct.',0,0),(38,10,8,134,'2019-01-02 00:00:00',28.29,23,1,'2018-12-10 14:58:11','2018-12-10 16:27:55',1,NULL,NULL,NULL,0.00,'79cf63cd7a50ab2085c38012','Sight',649.26,NULL,NULL,'+11 REJECTIONS',0,0),(39,10,9,135,'2018-12-25 00:00:00',3300.00,15,1,'2018-12-10 14:59:54','2018-12-11 14:29:10',1,NULL,NULL,NULL,0.00,'216b131e01484140b32ea7f5','Sight',3300.00,NULL,NULL,'Coloured 2.5-14.8 ct',0,0),(40,10,9,139,'2018-12-30 00:00:00',3900.00,20,0,'2018-12-10 00:00:00','2018-12-10 15:10:41',1,NULL,NULL,'manual',3400.00,'bdc001df7ce0f0ae2b72bac7','Sight',3900.00,NULL,NULL,'Crystals 5-14.8 ct.',0,0),(41,10,9,95,'2019-02-08 00:00:00',30.00,60,1,'2018-12-10 15:21:41','2018-12-11 14:29:15',1,NULL,NULL,NULL,0.00,'719fbcee33e7ab340c51a873','Sight',9000.00,NULL,NULL,'+11 BLK ST LIGHT',0,0),(42,10,9,137,'2018-12-25 00:00:00',3300.00,15,1,'2018-12-10 15:25:27','2018-12-10 16:26:30',1,NULL,NULL,NULL,0.00,'17083bec150cb963f1d520e3','Sight',3300.00,NULL,NULL,'Fine 5-14.8 ct',0,0),(43,6,8,141,'2019-01-24 00:00:00',45.56,34,1,'2018-12-21 00:00:00','2018-12-11 11:24:53',0,NULL,NULL,'manual',1549.04,'b90def3f9f1069a12e0af1a6','Sight',1549.04,NULL,NULL,'Col\'d Fine 5-14 ct.',0,1),(44,10,8,123,'2018-12-30 00:00:00',3300.00,20,1,'2018-12-10 16:41:52','2018-12-10 16:46:37',1,NULL,NULL,NULL,0.00,'af03637b081d52f22a309cbf','Sight',3300.00,NULL,NULL,'Fine 5-14.8 ct',0,0),(45,7,8,143,'2018-12-31 00:00:00',5000.00,20,1,'2018-12-11 08:15:12','2018-12-11 08:17:20',1,NULL,NULL,NULL,0.00,'250a6fe2e5b98fefa32f1df1','Sight',5000.00,NULL,NULL,'Select MB 5-14.8 ct',0,0),(46,10,9,145,'2018-12-31 00:00:00',4000.00,20,1,'2018-12-11 00:00:00','2018-12-11 14:28:14',1,NULL,NULL,'manual',0.00,'d8729d1b7785c72045877baf','Sight',4000.00,NULL,NULL,'Spotted Z 5-10 ct',0,0),(47,10,8,156,'2018-12-31 00:00:00',3300.00,20,1,'2018-12-11 00:00:00','2018-12-11 14:46:58',1,NULL,NULL,'manual',0.00,'a0faf41661f517b7f27ebe39','Sight',3300.00,NULL,NULL,'Collection 5-10 ct',0,0),(48,7,8,157,'2018-12-31 00:00:00',330.00,20,0,'2018-12-11 00:00:00','2018-12-11 14:17:04',0,NULL,NULL,'manual',330.00,'2066e1d4c457cfaa77a2964a','Sight',330.00,NULL,NULL,'Crystals 5-14.8 ct.',0,0),(49,10,9,160,'2018-12-31 00:00:00',3000.00,20,0,'2018-12-11 00:00:00','2018-12-11 14:53:14',1,NULL,NULL,'manual',3000.00,'d945c16f3ae52f812e0c7280','Sight',3000.00,NULL,NULL,'Collection 5-10 ct',0,0),(50,10,8,162,'2018-12-31 00:00:00',3300.00,20,0,'2018-12-11 00:00:00','2018-12-11 14:56:02',1,NULL,NULL,'manual',3300.00,'5b3b7bba8e6ec1bf8cf9d305','Sight',3300.00,NULL,NULL,'Fine 5-14.8 ct',0,0),(51,1,4,165,'2018-11-16 00:00:00',100.00,15,0,'2018-11-01 00:00:00','2018-12-11 16:50:38',1,NULL,NULL,'manual',42000.00,'0266a05ab37afd70d3453ca3','Sight',52000.00,NULL,NULL,'+9 SAWABLES LIGHT',0,0),(52,3,6,122,'2019-02-10 00:00:00',165.00,60,0,'2018-12-12 02:19:42','2018-12-12 02:19:42',1,NULL,NULL,NULL,33000.00,'ce7a398e2e9027330699dcad','Sight',33000.00,NULL,NULL,'-11+9 BLK ST LIGHT',0,0);
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `versions`
--

DROP TABLE IF EXISTS `versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `versions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `versioned_type` varchar(255) DEFAULT NULL,
  `versioned_id` bigint(20) DEFAULT NULL,
  `user_type` varchar(255) DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  `modifications` text,
  `number` int(11) DEFAULT NULL,
  `reverted_from` int(11) DEFAULT NULL,
  `tag` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `object_changes` text,
  PRIMARY KEY (`id`),
  KEY `index_versions_on_versioned_type_and_versioned_id` (`versioned_type`,`versioned_id`),
  KEY `index_versions_on_user_type_and_user_id` (`user_type`,`user_id`),
  KEY `index_versions_on_versioned_id_and_versioned_type` (`versioned_id`,`versioned_type`),
  KEY `index_versions_on_user_id_and_user_type` (`user_id`,`user_type`),
  KEY `index_versions_on_user_name` (`user_name`),
  KEY `index_versions_on_number` (`number`),
  KEY `index_versions_on_tag` (`tag`),
  KEY `index_versions_on_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `versions`
--

LOCK TABLES `versions` WRITE;
/*!40000 ALTER TABLE `versions` DISABLE KEYS */;
/*!40000 ALTER TABLE `versions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `winners`
--

DROP TABLE IF EXISTS `winners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `winners` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tender_id` bigint(20) DEFAULT NULL,
  `customer_id` bigint(20) DEFAULT NULL,
  `bid_id` bigint(20) DEFAULT NULL,
  `stone_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `sight_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_winners_on_tender_id` (`tender_id`),
  KEY `index_winners_on_customer_id` (`customer_id`),
  KEY `index_winners_on_bid_id` (`bid_id`),
  KEY `index_winners_on_stone_id` (`stone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `winners`
--

LOCK TABLES `winners` WRITE;
/*!40000 ALTER TABLE `winners` DISABLE KEYS */;
/*!40000 ALTER TABLE `winners` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yes_no_buyer_interests`
--

DROP TABLE IF EXISTS `yes_no_buyer_interests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yes_no_buyer_interests` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tender_id` bigint(20) DEFAULT NULL,
  `stone_id` bigint(20) DEFAULT NULL,
  `sight_id` bigint(20) DEFAULT NULL,
  `customer_id` bigint(20) DEFAULT NULL,
  `bid_open_time` datetime DEFAULT NULL,
  `bid_close_time` datetime DEFAULT NULL,
  `round` int(11) DEFAULT NULL,
  `reserved_price` varchar(255) DEFAULT NULL,
  `interest` tinyint(1) DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `buyer_left` tinyint(1) DEFAULT '1',
  `place_bid` int(11) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `index_yes_no_buyer_interests_on_tender_id` (`tender_id`),
  KEY `index_yes_no_buyer_interests_on_stone_id` (`stone_id`),
  KEY `index_yes_no_buyer_interests_on_sight_id` (`sight_id`),
  KEY `index_yes_no_buyer_interests_on_customer_id` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yes_no_buyer_interests`
--

LOCK TABLES `yes_no_buyer_interests` WRITE;
/*!40000 ALTER TABLE `yes_no_buyer_interests` DISABLE KEYS */;
/*!40000 ALTER TABLE `yes_no_buyer_interests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yes_no_buyer_winners`
--

DROP TABLE IF EXISTS `yes_no_buyer_winners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `yes_no_buyer_winners` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tender_id` bigint(20) DEFAULT NULL,
  `stone_id` bigint(20) DEFAULT NULL,
  `sight_id` bigint(20) DEFAULT NULL,
  `customer_id` bigint(20) DEFAULT NULL,
  `yes_no_buyer_interest_id` bigint(20) DEFAULT NULL,
  `bid_open_time` datetime DEFAULT NULL,
  `bid_close_time` datetime DEFAULT NULL,
  `round` int(11) DEFAULT NULL,
  `winning_price` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_yes_no_buyer_winners_on_tender_id` (`tender_id`),
  KEY `index_yes_no_buyer_winners_on_stone_id` (`stone_id`),
  KEY `index_yes_no_buyer_winners_on_sight_id` (`sight_id`),
  KEY `index_yes_no_buyer_winners_on_customer_id` (`customer_id`),
  KEY `index_yes_no_buyer_winners_on_yes_no_buyer_interest_id` (`yes_no_buyer_interest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yes_no_buyer_winners`
--

LOCK TABLES `yes_no_buyer_winners` WRITE;
/*!40000 ALTER TABLE `yes_no_buyer_winners` DISABLE KEYS */;
/*!40000 ALTER TABLE `yes_no_buyer_winners` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-12-13 16:17:48
