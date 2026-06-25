/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.5.29-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: ghost_production
-- ------------------------------------------------------
-- Server version	10.5.29-MariaDB-0+deb11u1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `actions`
--

DROP TABLE IF EXISTS `actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `actions` (
  `id` varchar(24) NOT NULL,
  `resource_id` varchar(24) DEFAULT NULL,
  `resource_type` varchar(50) NOT NULL,
  `actor_id` varchar(24) NOT NULL,
  `actor_type` varchar(50) NOT NULL,
  `event` varchar(50) NOT NULL,
  `context` text DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actions`
--

LOCK TABLES `actions` WRITE;
/*!40000 ALTER TABLE `actions` DISABLE KEYS */;
/*!40000 ALTER TABLE `actions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_keys`
--

DROP TABLE IF EXISTS `api_keys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_keys` (
  `id` varchar(24) NOT NULL,
  `type` varchar(50) NOT NULL,
  `secret` varchar(191) NOT NULL,
  `role_id` varchar(24) DEFAULT NULL,
  `integration_id` varchar(24) DEFAULT NULL,
  `user_id` varchar(24) DEFAULT NULL,
  `last_seen_at` datetime DEFAULT NULL,
  `last_seen_version` varchar(50) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `api_keys_secret_unique` (`secret`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_keys`
--

LOCK TABLES `api_keys` WRITE;
/*!40000 ALTER TABLE `api_keys` DISABLE KEYS */;
INSERT INTO `api_keys` VALUES ('6a3d0248cb2d0a7ab1a5a073','admin','00fc7fcf96cb327142354945284a2114768138bc863b602832a48fa15bc2aba6','6a3d0244cb2d0a7ab1a59fd7','6a3d0248cb2d0a7ab1a5a072',NULL,NULL,NULL,'2026-06-25 10:26:16','2026-06-25 10:26:16'),('6a3d0248cb2d0a7ab1a5a075','admin','a66153f6137f569afeb702e344d10a2f50e91a70839d0a122dbe28e1120707a2','6a3d0244cb2d0a7ab1a59fd7','6a3d0248cb2d0a7ab1a5a074',NULL,NULL,NULL,'2026-06-25 10:26:16','2026-06-25 10:26:16'),('6a3d0248cb2d0a7ab1a5a077','admin','c25b0ae13250afdb360f341a909203f97c2e7e09e02ae92111e2a53f233745ef','6a3d0244cb2d0a7ab1a59fd8','6a3d0248cb2d0a7ab1a5a076',NULL,NULL,NULL,'2026-06-25 10:26:16','2026-06-25 10:26:16'),('6a3d0248cb2d0a7ab1a5a079','admin','71912df863b07c398a765ef46067b14891f56f1aa9d300980ec3bcb118cd20c6','6a3d0244cb2d0a7ab1a59fd9','6a3d0248cb2d0a7ab1a5a078',NULL,NULL,NULL,'2026-06-25 10:26:16','2026-06-25 10:26:16'),('6a3d0248cb2d0a7ab1a5a07b','admin','1d72c1351f3132dc3ee7a2d6cf1b1b19f2cf1267471ddfe13afdbfc4f8b68e39','6a3d0244cb2d0a7ab1a59fda','6a3d0248cb2d0a7ab1a5a07a',NULL,NULL,NULL,'2026-06-25 10:26:16','2026-06-25 10:26:16'),('6a3d0248cb2d0a7ab1a5a07d','admin','a3a22a41cfa94ceefea71dc03f13d0f15dbd3c6818faeaeac9b63b1569f2c122','6a3d0244cb2d0a7ab1a59fdb','6a3d0248cb2d0a7ab1a5a07c',NULL,NULL,NULL,'2026-06-25 10:26:16','2026-06-25 10:26:16'),('6a3d0248cb2d0a7ab1a5a07f','content','7e2e217f174a01028e1c7bcde2',NULL,'6a3d0248cb2d0a7ab1a5a07e',NULL,NULL,NULL,'2026-06-25 10:26:16','2026-06-25 10:26:16'),('6a3d0248cb2d0a7ab1a5a081','content','d81522ed40ac10818f2c171471',NULL,'6a3d0248cb2d0a7ab1a5a080',NULL,NULL,NULL,'2026-06-25 10:26:16','2026-06-25 10:26:16');
/*!40000 ALTER TABLE `api_keys` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `automated_email_recipients`
--

DROP TABLE IF EXISTS `automated_email_recipients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `automated_email_recipients` (
  `id` varchar(24) NOT NULL,
  `automated_email_id` varchar(24) DEFAULT NULL,
  `automation_action_revision_id` varchar(24) DEFAULT NULL,
  `member_id` varchar(24) NOT NULL,
  `member_uuid` varchar(36) NOT NULL,
  `member_email` varchar(191) NOT NULL,
  `member_name` varchar(191) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `automated_email_recipients_automated_email_id_foreign` (`automated_email_id`),
  KEY `automated_email_recipients_automation_action_revision_id_foreign` (`automation_action_revision_id`),
  KEY `automated_email_recipients_member_id_index` (`member_id`),
  CONSTRAINT `automated_email_recipients_automated_email_id_foreign` FOREIGN KEY (`automated_email_id`) REFERENCES `welcome_email_automated_emails` (`id`),
  CONSTRAINT `automated_email_recipients_automation_action_revision_id_foreign` FOREIGN KEY (`automation_action_revision_id`) REFERENCES `automation_action_revisions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `automated_email_recipients`
--

LOCK TABLES `automated_email_recipients` WRITE;
/*!40000 ALTER TABLE `automated_email_recipients` DISABLE KEYS */;
/*!40000 ALTER TABLE `automated_email_recipients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `automation_action_edges`
--

DROP TABLE IF EXISTS `automation_action_edges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `automation_action_edges` (
  `source_action_id` varchar(24) NOT NULL,
  `target_action_id` varchar(24) NOT NULL,
  PRIMARY KEY (`source_action_id`,`target_action_id`),
  KEY `automation_action_edges_target_action_id_foreign` (`target_action_id`),
  CONSTRAINT `automation_action_edges_source_action_id_foreign` FOREIGN KEY (`source_action_id`) REFERENCES `automation_actions` (`id`),
  CONSTRAINT `automation_action_edges_target_action_id_foreign` FOREIGN KEY (`target_action_id`) REFERENCES `automation_actions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `automation_action_edges`
--

LOCK TABLES `automation_action_edges` WRITE;
/*!40000 ALTER TABLE `automation_action_edges` DISABLE KEYS */;
/*!40000 ALTER TABLE `automation_action_edges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `automation_action_revisions`
--

DROP TABLE IF EXISTS `automation_action_revisions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `automation_action_revisions` (
  `id` varchar(24) NOT NULL,
  `created_at` datetime NOT NULL,
  `action_id` varchar(24) NOT NULL,
  `wait_hours` int(10) unsigned DEFAULT NULL,
  `email_subject` varchar(300) DEFAULT NULL,
  `email_lexical` longtext DEFAULT NULL,
  `email_design_setting_id` varchar(24) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `automation_action_revisions_created_at_action_id_unique` (`created_at`,`action_id`),
  KEY `automation_action_revisions_action_id_foreign` (`action_id`),
  KEY `automation_action_revisions_email_design_setting_id_foreign` (`email_design_setting_id`),
  CONSTRAINT `automation_action_revisions_action_id_foreign` FOREIGN KEY (`action_id`) REFERENCES `automation_actions` (`id`),
  CONSTRAINT `automation_action_revisions_email_design_setting_id_foreign` FOREIGN KEY (`email_design_setting_id`) REFERENCES `email_design_settings` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `automation_action_revisions`
--

LOCK TABLES `automation_action_revisions` WRITE;
/*!40000 ALTER TABLE `automation_action_revisions` DISABLE KEYS */;
/*!40000 ALTER TABLE `automation_action_revisions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `automation_actions`
--

DROP TABLE IF EXISTS `automation_actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `automation_actions` (
  `id` varchar(24) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `automation_id` varchar(24) NOT NULL,
  `type` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `automation_actions_automation_id_foreign` (`automation_id`),
  CONSTRAINT `automation_actions_automation_id_foreign` FOREIGN KEY (`automation_id`) REFERENCES `automations` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `automation_actions`
--

LOCK TABLES `automation_actions` WRITE;
/*!40000 ALTER TABLE `automation_actions` DISABLE KEYS */;
/*!40000 ALTER TABLE `automation_actions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `automation_run_steps`
--

DROP TABLE IF EXISTS `automation_run_steps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `automation_run_steps` (
  `id` varchar(24) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `automation_run_id` varchar(24) NOT NULL,
  `automation_action_revision_id` varchar(24) NOT NULL,
  `ready_at` datetime NOT NULL,
  `step_attempts` int(10) unsigned NOT NULL DEFAULT 0,
  `started_at` datetime DEFAULT NULL,
  `finished_at` datetime DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'pending',
  `locked_by` varchar(191) DEFAULT NULL,
  `locked_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `automation_run_steps_automation_run_id_foreign` (`automation_run_id`),
  KEY `automation_run_steps_automation_action_revision_id_foreign` (`automation_action_revision_id`),
  CONSTRAINT `automation_run_steps_automation_action_revision_id_foreign` FOREIGN KEY (`automation_action_revision_id`) REFERENCES `automation_action_revisions` (`id`),
  CONSTRAINT `automation_run_steps_automation_run_id_foreign` FOREIGN KEY (`automation_run_id`) REFERENCES `automation_runs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `automation_run_steps`
--

LOCK TABLES `automation_run_steps` WRITE;
/*!40000 ALTER TABLE `automation_run_steps` DISABLE KEYS */;
/*!40000 ALTER TABLE `automation_run_steps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `automation_runs`
--

DROP TABLE IF EXISTS `automation_runs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `automation_runs` (
  `id` varchar(24) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `automation_id` varchar(24) NOT NULL,
  `member_id` varchar(24) DEFAULT NULL,
  `member_email` varchar(191) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `automation_runs_automation_id_foreign` (`automation_id`),
  KEY `automation_runs_member_id_index` (`member_id`),
  CONSTRAINT `automation_runs_automation_id_foreign` FOREIGN KEY (`automation_id`) REFERENCES `automations` (`id`),
  CONSTRAINT `automation_runs_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `automation_runs`
--

LOCK TABLES `automation_runs` WRITE;
/*!40000 ALTER TABLE `automation_runs` DISABLE KEYS */;
/*!40000 ALTER TABLE `automation_runs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `automations`
--

DROP TABLE IF EXISTS `automations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `automations` (
  `id` varchar(24) NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'inactive',
  `name` varchar(191) NOT NULL,
  `slug` varchar(191) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `automations_name_unique` (`name`),
  UNIQUE KEY `automations_slug_unique` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `automations`
--

LOCK TABLES `automations` WRITE;
/*!40000 ALTER TABLE `automations` DISABLE KEYS */;
/*!40000 ALTER TABLE `automations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `benefits`
--

DROP TABLE IF EXISTS `benefits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `benefits` (
  `id` varchar(24) NOT NULL,
  `name` varchar(191) NOT NULL,
  `slug` varchar(191) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `benefits_slug_unique` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `benefits`
--

LOCK TABLES `benefits` WRITE;
/*!40000 ALTER TABLE `benefits` DISABLE KEYS */;
/*!40000 ALTER TABLE `benefits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `brute`
--

DROP TABLE IF EXISTS `brute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `brute` (
  `key` varchar(191) NOT NULL,
  `firstRequest` bigint(20) NOT NULL,
  `lastRequest` bigint(20) NOT NULL,
  `lifetime` bigint(20) NOT NULL,
  `count` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `brute`
--

LOCK TABLES `brute` WRITE;
/*!40000 ALTER TABLE `brute` DISABLE KEYS */;
INSERT INTO `brute` VALUES ('cELT31H86/xtdByIztxDGDsyK2oCnISvEkZjl5QwDXU=',1782388526493,1782388526493,1782389526496,1);
/*!40000 ALTER TABLE `brute` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collections`
--

DROP TABLE IF EXISTS `collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `collections` (
  `id` varchar(24) NOT NULL,
  `title` varchar(191) NOT NULL,
  `slug` varchar(191) NOT NULL,
  `description` varchar(2000) DEFAULT NULL,
  `type` varchar(50) NOT NULL,
  `filter` text DEFAULT NULL,
  `feature_image` varchar(2000) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `collections_slug_unique` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collections`
--

LOCK TABLES `collections` WRITE;
/*!40000 ALTER TABLE `collections` DISABLE KEYS */;
INSERT INTO `collections` VALUES ('6a3d0246cb2d0a7ab1a59fde','Latest','latest','All posts','automatic',NULL,NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a59fdf','Featured','featured','Featured posts','automatic','featured:true',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14');
/*!40000 ALTER TABLE `collections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collections_posts`
--

DROP TABLE IF EXISTS `collections_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `collections_posts` (
  `id` varchar(24) NOT NULL,
  `collection_id` varchar(24) NOT NULL,
  `post_id` varchar(24) NOT NULL,
  `sort_order` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `collections_posts_collection_id_foreign` (`collection_id`),
  KEY `collections_posts_post_id_foreign` (`post_id`),
  CONSTRAINT `collections_posts_collection_id_foreign` FOREIGN KEY (`collection_id`) REFERENCES `collections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `collections_posts_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collections_posts`
--

LOCK TABLES `collections_posts` WRITE;
/*!40000 ALTER TABLE `collections_posts` DISABLE KEYS */;
/*!40000 ALTER TABLE `collections_posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment_likes`
--

DROP TABLE IF EXISTS `comment_likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment_likes` (
  `id` varchar(24) NOT NULL,
  `comment_id` varchar(24) NOT NULL,
  `member_id` varchar(24) NOT NULL,
  `score` int(11) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `comment_likes_comment_id_foreign` (`comment_id`),
  KEY `comment_likes_member_id_foreign` (`member_id`),
  CONSTRAINT `comment_likes_comment_id_foreign` FOREIGN KEY (`comment_id`) REFERENCES `comments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comment_likes_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment_likes`
--

LOCK TABLES `comment_likes` WRITE;
/*!40000 ALTER TABLE `comment_likes` DISABLE KEYS */;
/*!40000 ALTER TABLE `comment_likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment_reports`
--

DROP TABLE IF EXISTS `comment_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment_reports` (
  `id` varchar(24) NOT NULL,
  `comment_id` varchar(24) NOT NULL,
  `member_id` varchar(24) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `comment_reports_comment_id_foreign` (`comment_id`),
  KEY `comment_reports_member_id_foreign` (`member_id`),
  CONSTRAINT `comment_reports_comment_id_foreign` FOREIGN KEY (`comment_id`) REFERENCES `comments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comment_reports_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment_reports`
--

LOCK TABLES `comment_reports` WRITE;
/*!40000 ALTER TABLE `comment_reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `comment_reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `comments` (
  `id` varchar(24) NOT NULL,
  `post_id` varchar(24) NOT NULL,
  `member_id` varchar(24) DEFAULT NULL,
  `parent_id` varchar(24) DEFAULT NULL,
  `in_reply_to_id` varchar(24) DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'published',
  `html` longtext DEFAULT NULL,
  `edited_at` datetime DEFAULT NULL,
  `pinned_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `comments_member_id_foreign` (`member_id`),
  KEY `comments_parent_id_foreign` (`parent_id`),
  KEY `comments_in_reply_to_id_foreign` (`in_reply_to_id`),
  KEY `comments_post_id_parent_id_pinned_at_index` (`post_id`,`parent_id`,`pinned_at`),
  CONSTRAINT `comments_in_reply_to_id_foreign` FOREIGN KEY (`in_reply_to_id`) REFERENCES `comments` (`id`) ON DELETE SET NULL,
  CONSTRAINT `comments_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE SET NULL,
  CONSTRAINT `comments_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `comments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comments_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `custom_theme_settings`
--

DROP TABLE IF EXISTS `custom_theme_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `custom_theme_settings` (
  `id` varchar(24) NOT NULL,
  `theme` varchar(191) NOT NULL,
  `key` varchar(191) NOT NULL,
  `type` varchar(50) NOT NULL,
  `value` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `custom_theme_settings`
--

LOCK TABLES `custom_theme_settings` WRITE;
/*!40000 ALTER TABLE `custom_theme_settings` DISABLE KEYS */;
INSERT INTO `custom_theme_settings` VALUES ('6a3d024ecb2d0a7ab1a5a2c3','source','navigation_layout','select','Logo in the middle'),('6a3d024ecb2d0a7ab1a5a2c4','source','site_background_color','color','#ffffff'),('6a3d024ecb2d0a7ab1a5a2c5','source','header_and_footer_color','select','Background color'),('6a3d024ecb2d0a7ab1a5a2c6','source','title_font','select','Modern sans-serif'),('6a3d024ecb2d0a7ab1a5a2c7','source','body_font','select','Modern sans-serif'),('6a3d024ecb2d0a7ab1a5a2c8','source','signup_heading','text',NULL),('6a3d024ecb2d0a7ab1a5a2c9','source','signup_subheading','text',NULL),('6a3d024ecb2d0a7ab1a5a2ca','source','header_style','select','Landing'),('6a3d024ecb2d0a7ab1a5a2cb','source','header_text','text',NULL),('6a3d024ecb2d0a7ab1a5a2cc','source','background_image','boolean','true'),('6a3d024ecb2d0a7ab1a5a2cd','source','show_featured_posts','boolean','false'),('6a3d024ecb2d0a7ab1a5a2ce','source','post_feed_style','select','List'),('6a3d024ecb2d0a7ab1a5a2cf','source','show_images_in_feed','boolean','true'),('6a3d024ecb2d0a7ab1a5a2d0','source','show_author','boolean','true'),('6a3d024ecb2d0a7ab1a5a2d1','source','show_publish_date','boolean','true'),('6a3d024ecb2d0a7ab1a5a2d2','source','show_publication_info_sidebar','boolean','false'),('6a3d024ecb2d0a7ab1a5a2d3','source','show_post_metadata','boolean','true'),('6a3d024ecb2d0a7ab1a5a2d4','source','enable_drop_caps_on_posts','boolean','false'),('6a3d024ecb2d0a7ab1a5a2d5','source','show_related_articles','boolean','true');
/*!40000 ALTER TABLE `custom_theme_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `donation_payment_events`
--

DROP TABLE IF EXISTS `donation_payment_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `donation_payment_events` (
  `id` varchar(24) NOT NULL,
  `name` varchar(191) DEFAULT NULL,
  `email` varchar(191) NOT NULL,
  `member_id` varchar(24) DEFAULT NULL,
  `amount` int(11) NOT NULL,
  `currency` varchar(50) NOT NULL,
  `attribution_id` varchar(24) DEFAULT NULL,
  `attribution_type` varchar(50) DEFAULT NULL,
  `attribution_url` varchar(2000) DEFAULT NULL,
  `referrer_source` varchar(191) DEFAULT NULL,
  `referrer_medium` varchar(191) DEFAULT NULL,
  `referrer_url` varchar(2000) DEFAULT NULL,
  `utm_source` varchar(191) DEFAULT NULL,
  `utm_medium` varchar(191) DEFAULT NULL,
  `utm_campaign` varchar(191) DEFAULT NULL,
  `utm_term` varchar(191) DEFAULT NULL,
  `utm_content` varchar(191) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `donation_message` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `donation_payment_events_member_id_foreign` (`member_id`),
  CONSTRAINT `donation_payment_events_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donation_payment_events`
--

LOCK TABLES `donation_payment_events` WRITE;
/*!40000 ALTER TABLE `donation_payment_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `donation_payment_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_batches`
--

DROP TABLE IF EXISTS `email_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_batches` (
  `id` varchar(24) NOT NULL,
  `email_id` varchar(24) NOT NULL,
  `provider_id` varchar(255) DEFAULT NULL,
  `fallback_sending_domain` tinyint(1) NOT NULL DEFAULT 0,
  `status` varchar(50) NOT NULL DEFAULT 'pending',
  `member_segment` text DEFAULT NULL,
  `error_status_code` int(10) unsigned DEFAULT NULL,
  `error_message` varchar(2000) DEFAULT NULL,
  `error_data` longtext DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `email_batches_email_id_foreign` (`email_id`),
  CONSTRAINT `email_batches_email_id_foreign` FOREIGN KEY (`email_id`) REFERENCES `emails` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_batches`
--

LOCK TABLES `email_batches` WRITE;
/*!40000 ALTER TABLE `email_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `email_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_design_settings`
--

DROP TABLE IF EXISTS `email_design_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_design_settings` (
  `id` varchar(24) NOT NULL,
  `slug` varchar(191) NOT NULL,
  `background_color` varchar(50) NOT NULL DEFAULT 'light',
  `header_background_color` varchar(50) NOT NULL DEFAULT 'transparent',
  `header_image` varchar(2000) DEFAULT NULL,
  `show_header_icon` tinyint(1) NOT NULL DEFAULT 1,
  `show_header_title` tinyint(1) NOT NULL DEFAULT 1,
  `footer_content` text DEFAULT NULL,
  `button_color` varchar(50) DEFAULT 'accent',
  `button_corners` varchar(50) NOT NULL DEFAULT 'rounded',
  `button_style` varchar(50) NOT NULL DEFAULT 'fill',
  `link_color` varchar(50) DEFAULT 'accent',
  `link_style` varchar(50) NOT NULL DEFAULT 'underline',
  `body_font_category` varchar(191) NOT NULL DEFAULT 'sans_serif',
  `title_font_category` varchar(191) NOT NULL DEFAULT 'sans_serif',
  `title_font_weight` varchar(50) NOT NULL DEFAULT 'bold',
  `image_corners` varchar(50) NOT NULL DEFAULT 'square',
  `divider_color` varchar(50) DEFAULT NULL,
  `section_title_color` varchar(50) DEFAULT NULL,
  `show_badge` tinyint(1) NOT NULL DEFAULT 1,
  `sender_name` varchar(191) DEFAULT NULL,
  `sender_email` varchar(191) DEFAULT NULL,
  `sender_reply_to` varchar(191) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_design_settings_slug_unique` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_design_settings`
--

LOCK TABLES `email_design_settings` WRITE;
/*!40000 ALTER TABLE `email_design_settings` DISABLE KEYS */;
INSERT INTO `email_design_settings` VALUES ('6a3d0246cb2d0a7ab1a59fe3','default-automated-email','light','transparent',NULL,1,1,NULL,'accent','rounded','fill','accent','underline','sans_serif','sans_serif','bold','square',NULL,NULL,1,NULL,NULL,NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14');
/*!40000 ALTER TABLE `email_design_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_recipient_failures`
--

DROP TABLE IF EXISTS `email_recipient_failures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_recipient_failures` (
  `id` varchar(24) NOT NULL,
  `email_id` varchar(24) NOT NULL,
  `member_id` varchar(24) DEFAULT NULL,
  `email_recipient_id` varchar(24) NOT NULL,
  `code` int(10) unsigned NOT NULL,
  `enhanced_code` varchar(50) DEFAULT NULL,
  `message` varchar(2000) NOT NULL,
  `severity` varchar(50) NOT NULL DEFAULT 'permanent',
  `failed_at` datetime NOT NULL,
  `event_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `email_recipient_failures_email_id_foreign` (`email_id`),
  KEY `email_recipient_failures_email_recipient_id_foreign` (`email_recipient_id`),
  CONSTRAINT `email_recipient_failures_email_id_foreign` FOREIGN KEY (`email_id`) REFERENCES `emails` (`id`),
  CONSTRAINT `email_recipient_failures_email_recipient_id_foreign` FOREIGN KEY (`email_recipient_id`) REFERENCES `email_recipients` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_recipient_failures`
--

LOCK TABLES `email_recipient_failures` WRITE;
/*!40000 ALTER TABLE `email_recipient_failures` DISABLE KEYS */;
/*!40000 ALTER TABLE `email_recipient_failures` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_recipients`
--

DROP TABLE IF EXISTS `email_recipients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_recipients` (
  `id` varchar(24) NOT NULL,
  `email_id` varchar(24) NOT NULL,
  `member_id` varchar(24) NOT NULL,
  `batch_id` varchar(24) NOT NULL,
  `processed_at` datetime DEFAULT NULL,
  `delivered_at` datetime DEFAULT NULL,
  `opened_at` datetime DEFAULT NULL,
  `failed_at` datetime DEFAULT NULL,
  `member_uuid` varchar(36) NOT NULL,
  `member_email` varchar(191) NOT NULL,
  `member_name` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `email_recipients_member_id_index` (`member_id`),
  KEY `email_recipients_batch_id_foreign` (`batch_id`),
  KEY `email_recipients_email_id_member_email_index` (`email_id`,`member_email`),
  KEY `email_recipients_email_id_delivered_at_index` (`email_id`,`delivered_at`),
  KEY `email_recipients_email_id_opened_at_index` (`email_id`,`opened_at`),
  KEY `email_recipients_email_id_failed_at_index` (`email_id`,`failed_at`),
  CONSTRAINT `email_recipients_batch_id_foreign` FOREIGN KEY (`batch_id`) REFERENCES `email_batches` (`id`),
  CONSTRAINT `email_recipients_email_id_foreign` FOREIGN KEY (`email_id`) REFERENCES `emails` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_recipients`
--

LOCK TABLES `email_recipients` WRITE;
/*!40000 ALTER TABLE `email_recipients` DISABLE KEYS */;
/*!40000 ALTER TABLE `email_recipients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_spam_complaint_events`
--

DROP TABLE IF EXISTS `email_spam_complaint_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_spam_complaint_events` (
  `id` varchar(24) NOT NULL,
  `member_id` varchar(24) NOT NULL,
  `email_id` varchar(24) NOT NULL,
  `email_address` varchar(191) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_spam_complaint_events_email_id_member_id_unique` (`email_id`,`member_id`),
  KEY `email_spam_complaint_events_member_id_foreign` (`member_id`),
  CONSTRAINT `email_spam_complaint_events_email_id_foreign` FOREIGN KEY (`email_id`) REFERENCES `emails` (`id`),
  CONSTRAINT `email_spam_complaint_events_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_spam_complaint_events`
--

LOCK TABLES `email_spam_complaint_events` WRITE;
/*!40000 ALTER TABLE `email_spam_complaint_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `email_spam_complaint_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emails`
--

DROP TABLE IF EXISTS `emails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `emails` (
  `id` varchar(24) NOT NULL,
  `post_id` varchar(24) NOT NULL,
  `uuid` varchar(36) NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'pending',
  `recipient_filter` text NOT NULL,
  `error` varchar(2000) DEFAULT NULL,
  `error_data` longtext DEFAULT NULL,
  `email_count` int(10) unsigned NOT NULL DEFAULT 0,
  `csd_email_count` int(10) unsigned DEFAULT NULL,
  `delivered_count` int(10) unsigned NOT NULL DEFAULT 0,
  `opened_count` int(10) unsigned NOT NULL DEFAULT 0,
  `failed_count` int(10) unsigned NOT NULL DEFAULT 0,
  `subject` varchar(300) DEFAULT NULL,
  `from` varchar(2000) DEFAULT NULL,
  `reply_to` varchar(2000) DEFAULT NULL,
  `html` longtext DEFAULT NULL,
  `plaintext` longtext DEFAULT NULL,
  `source` longtext DEFAULT NULL,
  `source_type` varchar(50) NOT NULL DEFAULT 'html',
  `track_opens` tinyint(1) NOT NULL DEFAULT 0,
  `track_clicks` tinyint(1) NOT NULL DEFAULT 0,
  `feedback_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `submitted_at` datetime NOT NULL,
  `newsletter_id` varchar(24) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `emails_post_id_unique` (`post_id`),
  KEY `emails_post_id_index` (`post_id`),
  KEY `emails_newsletter_id_foreign` (`newsletter_id`),
  CONSTRAINT `emails_newsletter_id_foreign` FOREIGN KEY (`newsletter_id`) REFERENCES `newsletters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emails`
--

LOCK TABLES `emails` WRITE;
/*!40000 ALTER TABLE `emails` DISABLE KEYS */;
/*!40000 ALTER TABLE `emails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gift_links`
--

DROP TABLE IF EXISTS `gift_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `gift_links` (
  `token` varchar(32) NOT NULL,
  `post_id` varchar(24) NOT NULL,
  `redeemed_count` int(10) unsigned NOT NULL DEFAULT 0,
  `last_redeemed_at` datetime DEFAULT NULL,
  `revoked_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`token`),
  KEY `gift_links_post_id_foreign` (`post_id`),
  CONSTRAINT `gift_links_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gift_links`
--

LOCK TABLES `gift_links` WRITE;
/*!40000 ALTER TABLE `gift_links` DISABLE KEYS */;
/*!40000 ALTER TABLE `gift_links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gifts`
--

DROP TABLE IF EXISTS `gifts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `gifts` (
  `id` varchar(24) NOT NULL,
  `token` varchar(48) NOT NULL,
  `buyer_email` varchar(191) NOT NULL,
  `buyer_member_id` varchar(24) DEFAULT NULL,
  `redeemer_member_id` varchar(24) DEFAULT NULL,
  `tier_id` varchar(24) NOT NULL,
  `cadence` varchar(50) NOT NULL,
  `duration` int(10) unsigned NOT NULL,
  `currency` varchar(50) NOT NULL,
  `amount` int(10) unsigned NOT NULL,
  `stripe_checkout_session_id` varchar(255) NOT NULL,
  `stripe_payment_intent_id` varchar(255) NOT NULL,
  `consumes_at` datetime DEFAULT NULL,
  `expires_at` datetime NOT NULL,
  `status` varchar(50) NOT NULL,
  `purchased_at` datetime NOT NULL,
  `redeemed_at` datetime DEFAULT NULL,
  `consumed_at` datetime DEFAULT NULL,
  `expired_at` datetime DEFAULT NULL,
  `refunded_at` datetime DEFAULT NULL,
  `consumes_soon_reminder_sent_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `gifts_token_unique` (`token`),
  UNIQUE KEY `gifts_stripe_checkout_session_id_unique` (`stripe_checkout_session_id`),
  UNIQUE KEY `gifts_stripe_payment_intent_id_unique` (`stripe_payment_intent_id`),
  KEY `gifts_buyer_member_id_foreign` (`buyer_member_id`),
  KEY `gifts_redeemer_member_id_foreign` (`redeemer_member_id`),
  KEY `gifts_tier_id_foreign` (`tier_id`),
  KEY `gifts_status_consumes_at_index` (`status`,`consumes_at`),
  KEY `gifts_status_expires_at_index` (`status`,`expires_at`),
  CONSTRAINT `gifts_buyer_member_id_foreign` FOREIGN KEY (`buyer_member_id`) REFERENCES `members` (`id`) ON DELETE SET NULL,
  CONSTRAINT `gifts_redeemer_member_id_foreign` FOREIGN KEY (`redeemer_member_id`) REFERENCES `members` (`id`) ON DELETE SET NULL,
  CONSTRAINT `gifts_tier_id_foreign` FOREIGN KEY (`tier_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gifts`
--

LOCK TABLES `gifts` WRITE;
/*!40000 ALTER TABLE `gifts` DISABLE KEYS */;
/*!40000 ALTER TABLE `gifts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `integrations`
--

DROP TABLE IF EXISTS `integrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `integrations` (
  `id` varchar(24) NOT NULL,
  `type` varchar(50) NOT NULL DEFAULT 'custom',
  `name` varchar(191) NOT NULL,
  `slug` varchar(191) NOT NULL,
  `icon_image` varchar(2000) DEFAULT NULL,
  `description` varchar(2000) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `integrations_slug_unique` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `integrations`
--

LOCK TABLES `integrations` WRITE;
/*!40000 ALTER TABLE `integrations` DISABLE KEYS */;
INSERT INTO `integrations` VALUES ('6a3d0248cb2d0a7ab1a5a072','builtin','Zapier','zapier',NULL,'Built-in Zapier integration','2026-06-25 10:26:16','2026-06-25 10:26:16'),('6a3d0248cb2d0a7ab1a5a074','builtin','Transistor','transistor',NULL,'Built-in Transistor integration','2026-06-25 10:26:16','2026-06-25 10:26:16'),('6a3d0248cb2d0a7ab1a5a076','core','Ghost Explore','ghost-explore',NULL,'Built-in Ghost Explore integration','2026-06-25 10:26:16','2026-06-25 10:26:16'),('6a3d0248cb2d0a7ab1a5a078','core','Self-Serve Migration Integration','self-serve-migration',NULL,'Core Self-Serve Migration integration','2026-06-25 10:26:16','2026-06-25 10:26:16'),('6a3d0248cb2d0a7ab1a5a07a','internal','Ghost Backup','ghost-backup',NULL,'Internal DB Backup integration','2026-06-25 10:26:16','2026-06-25 10:26:16'),('6a3d0248cb2d0a7ab1a5a07c','internal','Ghost Scheduler','ghost-scheduler',NULL,'Internal Scheduler integration','2026-06-25 10:26:16','2026-06-25 10:26:16'),('6a3d0248cb2d0a7ab1a5a07e','internal','Ghost Internal Frontend','ghost-internal-frontend',NULL,'Internal frontend integration','2026-06-25 10:26:16','2026-06-25 10:26:16'),('6a3d0248cb2d0a7ab1a5a080','core','Ghost Core Content API','ghost-core-content',NULL,'Internal Content API integration for Admin access','2026-06-25 10:26:16','2026-06-25 10:26:16'),('6a3d0248cb2d0a7ab1a5a082','internal','Ghost ActivityPub','ghost-activitypub',NULL,'Internal Integration for ActivityPub','2026-06-25 10:26:16','2026-06-25 10:26:16');
/*!40000 ALTER TABLE `integrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invites`
--

DROP TABLE IF EXISTS `invites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `invites` (
  `id` varchar(24) NOT NULL,
  `role_id` varchar(24) NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'pending',
  `token` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `expires` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `invites_token_unique` (`token`),
  UNIQUE KEY `invites_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invites`
--

LOCK TABLES `invites` WRITE;
/*!40000 ALTER TABLE `invites` DISABLE KEYS */;
/*!40000 ALTER TABLE `invites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` varchar(24) NOT NULL,
  `name` varchar(191) NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'queued',
  `started_at` datetime DEFAULT NULL,
  `finished_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `metadata` varchar(2000) DEFAULT NULL,
  `queue_entry` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `jobs_name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
INSERT INTO `jobs` VALUES ('6a3d0252cb2d0a7ab1a5a2d6','members-migrations','finished','2026-06-25 10:26:26','2026-06-25 10:26:26','2026-06-25 10:26:26','2026-06-25 10:26:26',NULL,NULL);
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `labels`
--

DROP TABLE IF EXISTS `labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `labels` (
  `id` varchar(24) NOT NULL,
  `name` varchar(191) NOT NULL,
  `slug` varchar(191) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `labels_name_unique` (`name`),
  UNIQUE KEY `labels_slug_unique` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `labels`
--

LOCK TABLES `labels` WRITE;
/*!40000 ALTER TABLE `labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `members` (
  `id` varchar(24) NOT NULL,
  `uuid` varchar(36) NOT NULL,
  `transient_id` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'free',
  `name` varchar(191) DEFAULT NULL,
  `expertise` varchar(191) DEFAULT NULL,
  `note` varchar(2000) DEFAULT NULL,
  `geolocation` varchar(2000) DEFAULT NULL,
  `enable_comment_notifications` tinyint(1) NOT NULL DEFAULT 1,
  `enable_updates_and_announcements` tinyint(1) DEFAULT NULL,
  `email_count` int(10) unsigned NOT NULL DEFAULT 0,
  `email_opened_count` int(10) unsigned NOT NULL DEFAULT 0,
  `email_open_rate` int(10) unsigned DEFAULT NULL,
  `email_disabled` tinyint(1) NOT NULL DEFAULT 0,
  `last_seen_at` datetime DEFAULT NULL,
  `last_commented_at` datetime DEFAULT NULL,
  `commenting` text DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `members_uuid_unique` (`uuid`),
  UNIQUE KEY `members_transient_id_unique` (`transient_id`),
  UNIQUE KEY `members_email_unique` (`email`),
  KEY `members_email_open_rate_index` (`email_open_rate`),
  KEY `members_email_disabled_index` (`email_disabled`),
  KEY `members_created_at_id_index` (`created_at`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
/*!40000 ALTER TABLE `members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members_cancel_events`
--

DROP TABLE IF EXISTS `members_cancel_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `members_cancel_events` (
  `id` varchar(24) NOT NULL,
  `member_id` varchar(24) NOT NULL,
  `from_plan` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `members_cancel_events_member_id_foreign` (`member_id`),
  CONSTRAINT `members_cancel_events_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members_cancel_events`
--

LOCK TABLES `members_cancel_events` WRITE;
/*!40000 ALTER TABLE `members_cancel_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `members_cancel_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members_click_events`
--

DROP TABLE IF EXISTS `members_click_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `members_click_events` (
  `id` varchar(24) NOT NULL,
  `member_id` varchar(24) NOT NULL,
  `redirect_id` varchar(24) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `members_click_events_member_id_foreign` (`member_id`),
  KEY `members_click_events_redirect_id_foreign` (`redirect_id`),
  CONSTRAINT `members_click_events_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  CONSTRAINT `members_click_events_redirect_id_foreign` FOREIGN KEY (`redirect_id`) REFERENCES `redirects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members_click_events`
--

LOCK TABLES `members_click_events` WRITE;
/*!40000 ALTER TABLE `members_click_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `members_click_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members_created_events`
--

DROP TABLE IF EXISTS `members_created_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `members_created_events` (
  `id` varchar(24) NOT NULL,
  `created_at` datetime NOT NULL,
  `member_id` varchar(24) NOT NULL,
  `attribution_id` varchar(24) DEFAULT NULL,
  `attribution_type` varchar(50) DEFAULT NULL,
  `attribution_url` varchar(2000) DEFAULT NULL,
  `referrer_source` varchar(191) DEFAULT NULL,
  `referrer_medium` varchar(191) DEFAULT NULL,
  `referrer_url` varchar(2000) DEFAULT NULL,
  `utm_source` varchar(191) DEFAULT NULL,
  `utm_medium` varchar(191) DEFAULT NULL,
  `utm_campaign` varchar(191) DEFAULT NULL,
  `utm_term` varchar(191) DEFAULT NULL,
  `utm_content` varchar(191) DEFAULT NULL,
  `source` varchar(50) NOT NULL,
  `batch_id` varchar(24) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `members_created_events_member_id_foreign` (`member_id`),
  KEY `members_created_events_attribution_id_index` (`attribution_id`),
  CONSTRAINT `members_created_events_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members_created_events`
--

LOCK TABLES `members_created_events` WRITE;
/*!40000 ALTER TABLE `members_created_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `members_created_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members_current_subscription`
--

DROP TABLE IF EXISTS `members_current_subscription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `members_current_subscription` (
  `member_id` varchar(24) NOT NULL,
  `subscription_id` varchar(24) NOT NULL,
  PRIMARY KEY (`member_id`),
  UNIQUE KEY `members_current_subscription_subscription_id_unique` (`subscription_id`),
  CONSTRAINT `members_current_subscription_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  CONSTRAINT `members_current_subscription_subscription_id_foreign` FOREIGN KEY (`subscription_id`) REFERENCES `members_stripe_customers_subscriptions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members_current_subscription`
--

LOCK TABLES `members_current_subscription` WRITE;
/*!40000 ALTER TABLE `members_current_subscription` DISABLE KEYS */;
/*!40000 ALTER TABLE `members_current_subscription` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members_email_change_events`
--

DROP TABLE IF EXISTS `members_email_change_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `members_email_change_events` (
  `id` varchar(24) NOT NULL,
  `member_id` varchar(24) NOT NULL,
  `to_email` varchar(191) NOT NULL,
  `from_email` varchar(191) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `members_email_change_events_member_id_foreign` (`member_id`),
  CONSTRAINT `members_email_change_events_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members_email_change_events`
--

LOCK TABLES `members_email_change_events` WRITE;
/*!40000 ALTER TABLE `members_email_change_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `members_email_change_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members_feedback`
--

DROP TABLE IF EXISTS `members_feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `members_feedback` (
  `id` varchar(24) NOT NULL,
  `score` int(10) unsigned NOT NULL DEFAULT 0,
  `member_id` varchar(24) NOT NULL,
  `post_id` varchar(24) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `members_feedback_member_id_foreign` (`member_id`),
  KEY `members_feedback_post_id_foreign` (`post_id`),
  CONSTRAINT `members_feedback_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  CONSTRAINT `members_feedback_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members_feedback`
--

LOCK TABLES `members_feedback` WRITE;
/*!40000 ALTER TABLE `members_feedback` DISABLE KEYS */;
/*!40000 ALTER TABLE `members_feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members_labels`
--

DROP TABLE IF EXISTS `members_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `members_labels` (
  `id` varchar(24) NOT NULL,
  `member_id` varchar(24) NOT NULL,
  `label_id` varchar(24) NOT NULL,
  `sort_order` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `members_labels_member_id_foreign` (`member_id`),
  KEY `members_labels_label_id_foreign` (`label_id`),
  CONSTRAINT `members_labels_label_id_foreign` FOREIGN KEY (`label_id`) REFERENCES `labels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `members_labels_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members_labels`
--

LOCK TABLES `members_labels` WRITE;
/*!40000 ALTER TABLE `members_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `members_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members_login_events`
--

DROP TABLE IF EXISTS `members_login_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `members_login_events` (
  `id` varchar(24) NOT NULL,
  `member_id` varchar(24) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `members_login_events_member_id_foreign` (`member_id`),
  CONSTRAINT `members_login_events_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members_login_events`
--

LOCK TABLES `members_login_events` WRITE;
/*!40000 ALTER TABLE `members_login_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `members_login_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members_newsletters`
--

DROP TABLE IF EXISTS `members_newsletters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `members_newsletters` (
  `id` varchar(24) NOT NULL,
  `member_id` varchar(24) NOT NULL,
  `newsletter_id` varchar(24) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `members_newsletters_member_id_foreign` (`member_id`),
  KEY `members_newsletters_newsletter_id_member_id_index` (`newsletter_id`,`member_id`),
  CONSTRAINT `members_newsletters_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  CONSTRAINT `members_newsletters_newsletter_id_foreign` FOREIGN KEY (`newsletter_id`) REFERENCES `newsletters` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members_newsletters`
--

LOCK TABLES `members_newsletters` WRITE;
/*!40000 ALTER TABLE `members_newsletters` DISABLE KEYS */;
/*!40000 ALTER TABLE `members_newsletters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members_paid_subscription_events`
--

DROP TABLE IF EXISTS `members_paid_subscription_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `members_paid_subscription_events` (
  `id` varchar(24) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `member_id` varchar(24) NOT NULL,
  `subscription_id` varchar(24) DEFAULT NULL,
  `from_plan` varchar(255) DEFAULT NULL,
  `to_plan` varchar(255) DEFAULT NULL,
  `currency` varchar(191) NOT NULL,
  `source` varchar(50) NOT NULL,
  `mrr_delta` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `members_paid_subscription_events_member_id_foreign` (`member_id`),
  CONSTRAINT `members_paid_subscription_events_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members_paid_subscription_events`
--

LOCK TABLES `members_paid_subscription_events` WRITE;
/*!40000 ALTER TABLE `members_paid_subscription_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `members_paid_subscription_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members_payment_events`
--

DROP TABLE IF EXISTS `members_payment_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `members_payment_events` (
  `id` varchar(24) NOT NULL,
  `member_id` varchar(24) NOT NULL,
  `amount` int(11) NOT NULL,
  `currency` varchar(191) NOT NULL,
  `source` varchar(50) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `members_payment_events_member_id_foreign` (`member_id`),
  CONSTRAINT `members_payment_events_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members_payment_events`
--

LOCK TABLES `members_payment_events` WRITE;
/*!40000 ALTER TABLE `members_payment_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `members_payment_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members_product_events`
--

DROP TABLE IF EXISTS `members_product_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `members_product_events` (
  `id` varchar(24) NOT NULL,
  `member_id` varchar(24) NOT NULL,
  `product_id` varchar(24) NOT NULL,
  `action` varchar(50) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `members_product_events_member_id_foreign` (`member_id`),
  KEY `members_product_events_product_id_foreign` (`product_id`),
  CONSTRAINT `members_product_events_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  CONSTRAINT `members_product_events_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members_product_events`
--

LOCK TABLES `members_product_events` WRITE;
/*!40000 ALTER TABLE `members_product_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `members_product_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members_products`
--

DROP TABLE IF EXISTS `members_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `members_products` (
  `id` varchar(24) NOT NULL,
  `member_id` varchar(24) NOT NULL,
  `product_id` varchar(24) NOT NULL,
  `sort_order` int(10) unsigned NOT NULL DEFAULT 0,
  `expiry_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `members_products_member_id_foreign` (`member_id`),
  KEY `members_products_product_id_foreign` (`product_id`),
  CONSTRAINT `members_products_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  CONSTRAINT `members_products_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members_products`
--

LOCK TABLES `members_products` WRITE;
/*!40000 ALTER TABLE `members_products` DISABLE KEYS */;
/*!40000 ALTER TABLE `members_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `members_resolved_subscription`
--

DROP TABLE IF EXISTS `members_resolved_subscription`;
/*!50001 DROP VIEW IF EXISTS `members_resolved_subscription`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `members_resolved_subscription` AS SELECT
 1 AS `member_id`,
  1 AS `subscription_id` */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `members_status_events`
--

DROP TABLE IF EXISTS `members_status_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `members_status_events` (
  `id` varchar(24) NOT NULL,
  `member_id` varchar(24) NOT NULL,
  `from_status` varchar(50) DEFAULT NULL,
  `to_status` varchar(50) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `batch_id` varchar(24) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `members_status_events_member_id_foreign` (`member_id`),
  CONSTRAINT `members_status_events_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members_status_events`
--

LOCK TABLES `members_status_events` WRITE;
/*!40000 ALTER TABLE `members_status_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `members_status_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members_stripe_customers`
--

DROP TABLE IF EXISTS `members_stripe_customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `members_stripe_customers` (
  `id` varchar(24) NOT NULL,
  `member_id` varchar(24) NOT NULL,
  `customer_id` varchar(255) NOT NULL,
  `name` varchar(191) DEFAULT NULL,
  `email` varchar(191) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `members_stripe_customers_customer_id_unique` (`customer_id`),
  KEY `members_stripe_customers_member_id_foreign` (`member_id`),
  CONSTRAINT `members_stripe_customers_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members_stripe_customers`
--

LOCK TABLES `members_stripe_customers` WRITE;
/*!40000 ALTER TABLE `members_stripe_customers` DISABLE KEYS */;
/*!40000 ALTER TABLE `members_stripe_customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members_stripe_customers_subscriptions`
--

DROP TABLE IF EXISTS `members_stripe_customers_subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `members_stripe_customers_subscriptions` (
  `id` varchar(24) NOT NULL,
  `customer_id` varchar(255) NOT NULL,
  `ghost_subscription_id` varchar(24) DEFAULT NULL,
  `subscription_id` varchar(255) NOT NULL,
  `stripe_price_id` varchar(255) NOT NULL DEFAULT '',
  `status` varchar(50) NOT NULL,
  `cancel_at_period_end` tinyint(1) NOT NULL DEFAULT 0,
  `cancellation_reason` varchar(500) DEFAULT NULL,
  `current_period_end` datetime NOT NULL,
  `start_date` datetime NOT NULL,
  `default_payment_card_last4` varchar(4) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `mrr` int(10) unsigned NOT NULL DEFAULT 0,
  `offer_id` varchar(24) DEFAULT NULL,
  `discount_start` datetime DEFAULT NULL,
  `discount_end` datetime DEFAULT NULL,
  `trial_start_at` datetime DEFAULT NULL,
  `trial_end_at` datetime DEFAULT NULL,
  `plan_id` varchar(255) NOT NULL,
  `plan_nickname` varchar(50) NOT NULL,
  `plan_interval` varchar(50) NOT NULL,
  `plan_amount` int(11) NOT NULL,
  `plan_currency` varchar(191) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `members_stripe_customers_subscriptions_subscription_id_unique` (`subscription_id`),
  KEY `members_stripe_customers_subscriptions_customer_id_foreign` (`customer_id`),
  KEY `mscs_ghost_subscription_id_foreign` (`ghost_subscription_id`),
  KEY `members_stripe_customers_subscriptions_stripe_price_id_index` (`stripe_price_id`),
  KEY `members_stripe_customers_subscriptions_offer_id_foreign` (`offer_id`),
  CONSTRAINT `members_stripe_customers_subscriptions_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `members_stripe_customers` (`customer_id`) ON DELETE CASCADE,
  CONSTRAINT `members_stripe_customers_subscriptions_offer_id_foreign` FOREIGN KEY (`offer_id`) REFERENCES `offers` (`id`),
  CONSTRAINT `mscs_ghost_subscription_id_foreign` FOREIGN KEY (`ghost_subscription_id`) REFERENCES `subscriptions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members_stripe_customers_subscriptions`
--

LOCK TABLES `members_stripe_customers_subscriptions` WRITE;
/*!40000 ALTER TABLE `members_stripe_customers_subscriptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `members_stripe_customers_subscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members_subscribe_events`
--

DROP TABLE IF EXISTS `members_subscribe_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `members_subscribe_events` (
  `id` varchar(24) NOT NULL,
  `member_id` varchar(24) NOT NULL,
  `subscribed` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL,
  `source` varchar(50) DEFAULT NULL,
  `newsletter_id` varchar(24) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `members_subscribe_events_member_id_foreign` (`member_id`),
  KEY `members_subscribe_events_newsletter_id_created_at_index` (`newsletter_id`,`created_at`),
  CONSTRAINT `members_subscribe_events_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  CONSTRAINT `members_subscribe_events_newsletter_id_foreign` FOREIGN KEY (`newsletter_id`) REFERENCES `newsletters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members_subscribe_events`
--

LOCK TABLES `members_subscribe_events` WRITE;
/*!40000 ALTER TABLE `members_subscribe_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `members_subscribe_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members_subscription_created_events`
--

DROP TABLE IF EXISTS `members_subscription_created_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `members_subscription_created_events` (
  `id` varchar(24) NOT NULL,
  `created_at` datetime NOT NULL,
  `member_id` varchar(24) NOT NULL,
  `subscription_id` varchar(24) NOT NULL,
  `attribution_id` varchar(24) DEFAULT NULL,
  `attribution_type` varchar(50) DEFAULT NULL,
  `attribution_url` varchar(2000) DEFAULT NULL,
  `referrer_source` varchar(191) DEFAULT NULL,
  `referrer_medium` varchar(191) DEFAULT NULL,
  `referrer_url` varchar(2000) DEFAULT NULL,
  `utm_source` varchar(191) DEFAULT NULL,
  `utm_medium` varchar(191) DEFAULT NULL,
  `utm_campaign` varchar(191) DEFAULT NULL,
  `utm_term` varchar(191) DEFAULT NULL,
  `utm_content` varchar(191) DEFAULT NULL,
  `batch_id` varchar(24) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `members_subscription_created_events_member_id_foreign` (`member_id`),
  KEY `members_subscription_created_events_subscription_id_foreign` (`subscription_id`),
  KEY `members_subscription_created_events_attribution_id_index` (`attribution_id`),
  CONSTRAINT `members_subscription_created_events_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  CONSTRAINT `members_subscription_created_events_subscription_id_foreign` FOREIGN KEY (`subscription_id`) REFERENCES `members_stripe_customers_subscriptions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members_subscription_created_events`
--

LOCK TABLES `members_subscription_created_events` WRITE;
/*!40000 ALTER TABLE `members_subscription_created_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `members_subscription_created_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mentions`
--

DROP TABLE IF EXISTS `mentions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `mentions` (
  `id` varchar(24) NOT NULL,
  `source` varchar(2000) NOT NULL,
  `source_title` varchar(2000) DEFAULT NULL,
  `source_site_title` varchar(2000) DEFAULT NULL,
  `source_excerpt` varchar(2000) DEFAULT NULL,
  `source_author` varchar(2000) DEFAULT NULL,
  `source_featured_image` varchar(2000) DEFAULT NULL,
  `source_favicon` varchar(2000) DEFAULT NULL,
  `target` varchar(2000) NOT NULL,
  `resource_id` varchar(24) DEFAULT NULL,
  `resource_type` varchar(50) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `payload` text DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `verified` tinyint(1) NOT NULL DEFAULT 0,
  `revalidation_failure_count` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mentions`
--

LOCK TABLES `mentions` WRITE;
/*!40000 ALTER TABLE `mentions` DISABLE KEYS */;
/*!40000 ALTER TABLE `mentions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) NOT NULL,
  `version` varchar(70) NOT NULL,
  `currentVersion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `migrations_name_version_unique` (`name`,`version`)
) ENGINE=InnoDB AUTO_INCREMENT=302 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'1-create-tables.js','init','6.47'),(2,'2-create-fixtures.js','init','6.47'),(3,'01-final-v1.js','1.25','6.47'),(4,'02-noop.js','1.25','6.47'),(5,'01-final-v2.js','2.37','6.47'),(6,'01-final-v3.js','3.41','6.47'),(7,'2022-05-03-15-30-final-v4.js','4.47','6.47'),(8,'2022-05-04-10-03-no-op.js','4.47','6.47'),(9,'2022-03-14-12-33-delete-duplicate-offer-redemptions.js','5.0','6.47'),(10,'2022-03-28-15-25-backfill-mrr-adjustments-for-offers.js','5.0','6.47'),(11,'2022-04-25-10-32-backfill-mrr-for-discounted-subscriptions.js','5.0','6.47'),(12,'2022-04-26-15-44-backfill-mrr-events-for-canceled-subscriptions.js','5.0','6.47'),(13,'2022-04-27-11-26-backfill-mrr-for-canceled-subscriptions.js','5.0','6.47'),(14,'2022-04-28-03-26-remove-author-id-column-from-posts-table.js','5.0','6.47'),(15,'2022-05-03-09-39-drop-nullable-subscribe-event-newsletter-id.js','5.0','6.47'),(16,'2022-05-04-15-24-map-existing-emails-to-default-newsletter.js','5.0','6.47'),(17,'2022-05-05-13-13-migrate-legacy-recipient-filters.js','5.0','6.47'),(18,'2022-05-05-13-29-add-newsletters-admin-integration-permission-roles.js','5.0','6.47'),(19,'2022-05-05-15-17-drop-oauth-table.js','5.0','6.47'),(20,'2022-05-06-08-16-cleanup-client-subscriber-permissions.js','5.0','6.47'),(21,'2022-05-06-13-22-add-frontend-integration.js','5.0','6.47'),(22,'2022-05-09-10-00-drop-members-subscribed-column.js','5.0','6.47'),(23,'2022-05-09-14-17-cleanup-invalid-users-status.js','5.0','6.47'),(24,'2022-05-10-08-33-drop-members-analytics-table.js','5.0','6.47'),(25,'2022-05-10-14-57-cleanup-invalid-posts-status.js','5.0','6.47'),(26,'2022-05-11-12-08-drop-webhooks-status-column.js','5.0','6.47'),(27,'2022-05-11-13-12-rename-settings.js','5.0','6.47'),(28,'2022-05-11-16-36-remove-unused-settings.js','5.0','6.47'),(29,'2022-05-12-10-29-add-newsletter-permissions-for-editors-and-authors.js','5.0','6.47'),(30,'2022-05-12-13-51-add-label-permissions-for-authors.js','5.0','6.47'),(31,'2022-05-13-11-38-drop-none-email-recipient-filter.js','5.0','6.47'),(32,'2022-05-21-00-00-regenerate-posts-html.js','5.0','6.47'),(33,'2022-07-04-13-49-add-comments-table.js','5.3','6.47'),(34,'2022-07-05-09-36-add-comments-likes-table.js','5.3','6.47'),(35,'2022-07-05-09-47-add-comments-reports-table.js','5.3','6.47'),(36,'2022-07-05-10-00-add-comment-related-fields-to-members.js','5.3','6.47'),(37,'2022-07-05-12-55-add-comments-crud-permissions.js','5.3','6.47'),(38,'2022-07-05-15-35-add-comment-notifications-field-to-users-table.js','5.3','6.47'),(39,'2022-07-06-07-26-add-comments-enabled-setting.js','5.3','6.47'),(40,'2022-07-06-07-58-add-ghost-explore-integration-role.js','5.3','6.47'),(41,'2022-07-06-09-13-add-ghost-explore-integration-role-permissions.js','5.3','6.47'),(42,'2022-07-06-09-17-add-ghost-explore-integration.js','5.3','6.47'),(43,'2022-07-06-09-26-add-ghost-explore-integration-api-key.js','5.3','6.47'),(44,'2022-07-18-14-29-add-comment-reporting-permissions.js','5.5','6.47'),(45,'2022-07-18-14-31-drop-reports-reason.js','5.5','6.47'),(46,'2022-07-18-14-32-drop-nullable-member-id-from-likes.js','5.5','6.47'),(47,'2022-07-18-14-33-fix-comments-on-delete-foreign-keys.js','5.5','6.47'),(48,'2022-07-21-08-56-add-jobs-table.js','5.5','6.47'),(49,'2022-07-27-13-40-change-explore-type.js','5.6','6.47'),(50,'2022-08-02-06-09-add-trial-period-days-column-to-tiers.js','5.8','6.47'),(51,'2022-08-03-15-28-add-trial-start-column-to-stripe-subscriptions.js','5.8','6.47'),(52,'2022-08-03-15-29-add-trial-end-column-to-stripe-subscriptions.js','5.8','6.47'),(53,'2022-08-09-08-32-added-new-integration-type.js','5.9','6.47'),(54,'2022-08-15-05-34-add-expiry-at-column-to-members-products.js','5.10','6.47'),(55,'2022-08-16-14-25-add-member-created-events-table.js','5.10','6.47'),(56,'2022-08-16-14-25-add-subscription-created-events-table.js','5.10','6.47'),(57,'2022-08-19-14-15-fix-comments-deletion-strategy.js','5.10','6.47'),(58,'2022-08-22-11-03-add-member-alert-settings-columns-to-users.js','5.11','6.47'),(59,'2022-08-23-13-41-backfill-members-created-events.js','5.11','6.47'),(60,'2022-08-23-13-59-fix-page-resource-type.js','5.11','6.47'),(61,'2022-09-02-12-55-rename-members-bio-to-expertise.js','5.14','6.47'),(62,'2022-09-12-16-10-add-posts-lexical-column.js','5.15','6.47'),(63,'2022-09-14-12-46-add-email-track-clicks-setting.js','5.15','6.47'),(64,'2022-09-16-08-22-add-post-revisions-table.js','5.15','6.47'),(65,'2022-09-19-09-04-add-link-redirects-table.js','5.16','6.47'),(66,'2022-09-19-09-05-add-members-link-click-events-table.js','5.16','6.47'),(67,'2022-09-19-17-44-add-referrer-columns-to-member-events-table.js','5.16','6.47'),(68,'2022-09-19-17-44-add-referrer-columns-to-subscription-events-table.js','5.16','6.47'),(69,'2022-09-27-13-53-remove-click-tracking-tables.js','5.17','6.47'),(70,'2022-09-27-13-55-add-redirects-table.js','5.17','6.47'),(71,'2022-09-27-13-56-add-members-click-events-table.js','5.17','6.47'),(72,'2022-09-27-16-49-set-track-clicks-based-on-opens.js','5.17','6.47'),(73,'2022-09-29-12-39-add-track-clicks-column-to-emails.js','5.17','6.47'),(74,'2022-09-02-20-25-add-columns-to-products-table.js','5.19','6.47'),(75,'2022-09-02-20-52-backfill-new-product-columns.js','5.19','6.47'),(76,'2022-10-10-06-58-add-subscriptions-table.js','5.19','6.47'),(77,'2022-10-10-10-05-add-members-feedback-table.js','5.19','6.47'),(78,'2022-10-11-10-38-add-feedback-enabled-column-to-newsletters.js','5.19','6.47'),(79,'2022-10-18-05-39-drop-nullable-tier-id.js','5.20','6.47'),(80,'2022-10-18-10-13-add-ghost-subscription-id-column-to-mscs.js','5.20','6.47'),(81,'2022-10-19-11-17-add-link-browse-permissions.js','5.20','6.47'),(82,'2022-10-20-02-52-add-link-edit-permissions.js','5.20','6.47'),(83,'2022-10-24-07-23-disable-feedback-enabled.js','5.21','6.47'),(84,'2022-10-25-12-05-backfill-missed-products-columns.js','5.21','6.47'),(85,'2022-10-26-04-49-add-batch-id-members-created-events.js','5.21','6.47'),(86,'2022-10-26-04-49-add-batch-id-subscription-created-events.js','5.21','6.47'),(87,'2022-10-26-04-50-member-subscription-created-batch-id.js','5.21','6.47'),(88,'2022-10-26-09-32-add-feedback-enabled-column-to-emails.js','5.21','6.47'),(89,'2022-10-27-09-50-add-member-track-source-setting.js','5.21','6.47'),(90,'2022-10-31-12-03-backfill-new-product-columns.js','5.22','6.47'),(91,'2022-11-21-09-32-add-source-columns-to-emails-table.js','5.24','6.47'),(92,'2022-11-21-15-03-populate-source-column-with-html-for-emails.js','5.24','6.47'),(93,'2022-11-21-15-57-add-error-columns-for-email-batches.js','5.24','6.47'),(94,'2022-11-24-10-36-add-suppressions-table.js','5.25','6.47'),(95,'2022-11-24-10-37-add-email-spam-complaint-events-table.js','5.25','6.47'),(96,'2022-11-29-08-30-add-error-recipient-failures-table.js','5.25','6.47'),(97,'2022-12-13-16-15-add-usage-colums-to-tokens.js','5.27','6.47'),(98,'2023-01-04-04-12-drop-suppressions-table.js','5.27','6.47'),(99,'2023-01-04-04-13-add-suppressions-table.js','5.27','6.47'),(100,'2023-01-05-15-13-add-active-theme-permissions.js','5.28','6.47'),(101,'2023-01-11-02-45-truncate-suppressions.js','5.29','6.47'),(102,'2023-01-13-04-25-unsubscribe-suppressed-emails.js','5.30','6.47'),(103,'2022-12-05-09-56-update-newsletter-subscriptions.js','5.31','6.47'),(104,'2023-01-17-14-59-add-outbound-link-tagging-setting.js','5.31','6.47'),(105,'2023-01-19-07-46-add-mentions-table.js','5.31','6.47'),(106,'2023-01-24-08-00-fix-invalid-tier-expiry-for-paid-members.js','5.32','6.47'),(107,'2023-01-24-08-09-restore-incorrect-expired-tiers-for-members.js','5.32','6.47'),(108,'2023-01-30-07-27-add-mentions-permission.js','5.34','6.47'),(109,'2023-02-08-03-08-add-mentions-notifications-column.js','5.34','6.47'),(110,'2023-02-08-22-32-add-mentions-delete-column.js','5.34','6.47'),(111,'2023-02-13-06-24-add-mentions-verified-column.js','5.35','6.47'),(112,'2023-02-20-12-22-add-milestones-table.js','5.36','6.47'),(113,'2023-02-21-12-29-add-milestone-notifications-column.js','5.36','6.47'),(114,'2023-02-23-10-40-set-outbound-link-tagging-based-on-source-tracking.js','5.36','6.47'),(115,'2023-03-13-09-29-add-newsletter-show-post-title-section.js','5.39','6.47'),(116,'2023-03-13-13-11-add-newsletter-show-comment-cta.js','5.39','6.47'),(117,'2023-03-13-14-30-add-newsletter-show-subscription-details.js','5.39','6.47'),(118,'2023-03-14-12-26-add-last-mentions-email-report-timestamp-setting.js','5.39','6.47'),(119,'2023-03-13-14-05-add-newsletter-show-latest-posts.js','5.40','6.47'),(120,'2023-03-21-18-42-add-self-serve-integration-role.js','5.40','6.47'),(121,'2023-03-21-18-43-add-self-serve-migration-and-permissions.js','5.40','6.47'),(122,'2023-03-21-18-52-add-self-serve-integration.js','5.40','6.47'),(123,'2023-03-21-19-02-add-self-serve-integration-api-key.js','5.40','6.47'),(124,'2023-03-27-15-00-add-newsletter-colors.js','5.41','6.47'),(125,'2023-03-27-17-51-fix-self-serve-integration-api-key-type.js','5.41','6.47'),(126,'2023-04-04-07-03-add-portal-terms-settings.js','5.42','6.47'),(127,'2023-04-14-04-17-add-snippets-lexical-column.js','5.44','6.47'),(128,'2023-04-17-11-05-add-post-revision-author.js','5.45','6.47'),(129,'2023-04-18-12-56-add-announcement-settings.js','5.45','6.47'),(130,'2023-04-19-13-45-add-pintura-settings.js','5.45','6.47'),(131,'2023-04-20-14-19-add-announcement-visibility-setting.js','5.45','6.47'),(132,'2023-04-21-08-54-add-post-revision-status.js','5.45','6.47'),(133,'2023-04-21-10-30-add-feature-image-to-revisions.js','5.45','6.47'),(134,'2023-04-21-13-01-add-feature-image-meta-to-post-revisions.js','5.45','6.47'),(135,'2023-05-30-19-03-update-pintura-setting.js','5.51','6.47'),(136,'2023-06-07-10-17-add-collections-crud-persmissions.js','5.51','6.47'),(137,'2023-06-13-12-24-add-temp-mail-events-table.js','5.53','6.47'),(138,'2023-06-20-10-18-add-collections-table.js','5.53','6.47'),(139,'2023-06-20-10-19-add-collections-posts-table.js','5.53','6.47'),(140,'2023-07-07-11-57-add-show-title-and-feature-image-column-to-posts.js','5.54','6.47'),(141,'2023-07-10-05-15-55-add-built-in-collections.js','5.55','6.47'),(142,'2023-07-10-05-16-55-add-built-in-collection-posts.js','5.55','6.47'),(143,'2023-07-14-10-11-12-add-email-disabled-field-to-members.js','5.56','6.47'),(144,'2023-07-15-10-11-12-update-members-email-disabled-field.js','5.56','6.47'),(145,'2023-07-26-12-44-stripe-products-nullable-product.js','5.57','6.47'),(146,'2023-07-27-11-47-49-create-donation-events.js','5.57','6.47'),(147,'2023-08-02-09-42-add-donation-settings.js','5.58','6.47'),(148,'2023-08-07-10-42-add-donation-notifications-column.js','5.59','6.47'),(149,'2023-08-07-11-17-05-add-posts-published-at-index.js','5.59','6.47'),(150,'2023-08-29-10-17-add-recommendations-crud-permissions.js','5.61','6.47'),(151,'2023-08-29-11-39-10-add-recommendations-table.js','5.61','6.47'),(152,'2023-08-30-07-37-04-add-recommendations-enabled-settings.js','5.61','6.47'),(153,'2023-09-12-11-22-10-add-recommendation-click-events-table.js','5.63','6.47'),(154,'2023-09-12-11-22-11-add-recommendation-subscribe-events-table.js','5.63','6.47'),(155,'2023-09-13-13-03-10-add-ghost-core-content-integration.js','5.63','6.47'),(156,'2023-09-13-13-34-11-add-ghost-core-content-integration-key.js','5.63','6.47'),(157,'2023-09-19-04-25-40-truncate-stale-built-in-collections-posts.js','5.64','6.47'),(158,'2023-09-19-04-34-10-repopulate-built-in-collection-posts.js','5.64','6.47'),(159,'2023-09-22-06-42-15-truncate-stale-built-in-collections-posts.js','5.65','6.47'),(160,'2023-09-22-06-42-55-repopulate-built-in-featured-collection-posts.js','5.65','6.47'),(161,'2023-09-22-14-15-add-recommendation-notifications-column.js','5.66','6.47'),(162,'2023-10-03-00-32-32-rollback-source-theme.js','5.67','6.47'),(163,'2023-10-06-15-06-00-rename-recommendations-reason-to-description.js','5.69','6.47'),(164,'2023-10-31-11-06-00-members-created-attribution-id-index.js','5.72','6.47'),(165,'2023-10-31-11-06-01-members-subscription-created-attribution-id-index.js','5.72','6.47'),(166,'2023-11-14-11-15-00-add-transient-id-column-nullable.js','5.74','6.47'),(167,'2023-11-14-11-16-00-fill-transient-id-column.js','5.74','6.47'),(168,'2023-11-14-11-17-00-drop-nullable-transient-id-column.js','5.74','6.47'),(169,'2023-11-27-15-55-add-members-newsletters-index.js','5.75','6.47'),(170,'2023-12-05-11-00-add-portal-default-plan-setting.js','5.76','6.47'),(171,'2024-01-30-19-36-44-fix-discrepancy-in-free-tier-visibility.js','5.79','6.47'),(172,'2024-03-18-16-20-add-missing-post-permissions.js','5.81','6.47'),(173,'2024-03-25-16-46-10-add-email-recipients-email-id-indexes.js','5.82','6.47'),(174,'2024-03-25-16-51-29-drop-email-recipients-non-email-id-indexes.js','5.82','6.47'),(175,'2024-05-28-02-20-55-add-show-subhead-column-newsletters.js','5.83','6.47'),(176,'2024-06-04-09-13-33-rename-newsletters-show-subhead.js','5.84','6.47'),(177,'2024-06-04-11-10-37-add-custom-excerpt-to-post-revisions.js','5.84','6.47'),(178,'2024-06-05-08-42-34-populate-post-revisions-custom-excerpt.js','5.84','6.47'),(179,'2024-06-05-13-48-35-rename-newsletters-show-subtitle.js','5.84','6.47'),(180,'2024-06-10-14-53-31-add-posts-updated-at-index.js','5.85','6.47'),(181,'2024-06-25-12-08-20-add-posts-tags-post-tag-index.js','5.87','6.47'),(182,'2024-06-25-12-08-45-add-posts-type-status-updated-at-index.js','5.87','6.47'),(183,'2024-07-30-19-51-06-backfill-offer-redemptions.js','5.89','6.47'),(184,'2024-08-20-09-40-24-update-default-donations-suggested-amount.js','5.90','6.47'),(185,'2024-08-28-05-28-22-add-donation-message-column-to-donation-payment-events.js','5.91','6.47'),(186,'2024-09-03-18-51-01-update-stripe-prices-nickname-length.js','5.93','6.47'),(187,'2024-09-03-20-09-40-null-analytics-jobs-timings.js','5.94','6.47'),(188,'2024-10-08-14-25-27-added-body-font-settings.js','5.97','6.47'),(189,'2024-10-08-14-36-58-added-heading-font-setting.js','5.97','6.47'),(190,'2024-10-09-14-04-10-add-session-verification-field.js','5.97','6.47'),(191,'2024-10-10-01-02-03-add-signin-urls-permissions.js','5.97','6.47'),(192,'2024-10-31-15-27-42-add-jobs-queue-columns.js','5.100','6.47'),(193,'2024-11-05-14-48-08-add-comments-in-reply-to-id.js','5.100','6.47'),(194,'2024-11-06-04-45-15-add-activitypub-integration.js','5.100','6.47'),(195,'2024-12-02-17-32-40-alter-length-redirects-from.js','5.102','6.47'),(196,'2024-12-02-17-48-40-add-index-redirects-from.js','5.102','6.47'),(197,'2025-01-23-02-51-10-add-blocked-email-domains-setting.js','5.108','6.47'),(198,'2025-03-05-16-36-39-add-captcha-setting.js','5.111','6.47'),(199,'2025-03-10-10-01-01-add-require-mfa-setting.js','5.112','6.47'),(200,'2025-03-07-12-24-00-add-super-editor.js','5.113','6.47'),(201,'2025-03-07-12-25-00-add-member-perms-to-super-editor.js','5.113','6.47'),(202,'2025-03-19-03-13-04-add-index-to-posts-uuid.js','5.114','6.47'),(203,'2025-03-24-07-19-27-add-identity-read-permission-to-administrators.js','5.115','6.47'),(204,'2025-04-14-02-36-30-add-additional-social-accounts-columns-to-user-table.js','5.117','6.47'),(205,'2025-04-30-13-01-28-remove-captcha-setting.js','5.119','6.47'),(206,'2025-05-07-14-57-38-add-newsletters-button-corners-column.js','5.120','6.47'),(207,'2025-05-13-17-36-56-add-newsletters-button-style-column.js','5.120','6.47'),(208,'2025-05-14-20-00-15-add-newsletters-setting-columns.js','5.120','6.47'),(209,'2025-05-26-08-59-26-drop-newsletters-border-color-column.js','5.121','6.47'),(210,'2025-05-26-09-10-30-rename-newsletters-title-color-column.js','5.121','6.47'),(211,'2025-05-26-12-03-24-add-newsletters-color-columns.js','5.121','6.47'),(212,'2025-05-29-08-41-04-add-member-export-permissions-to-backup-integration.js','5.121','6.47'),(213,'2025-06-03-19-32-57-change-default-for-newsletters-button-color.js','5.122','6.47'),(214,'2025-06-06-23-12-11-create-site-uuid-setting.js','5.124','6.47'),(215,'2025-06-12-14-18-27-add-email-disabled-index.js','5.126','6.47'),(216,'2025-06-12-14-18-57-add-mse-newsletter-created-index.js','5.126','6.47'),(217,'2025-06-18-11-35-41-change-newsletters-link-color-default-to-accent.js','5.126','6.47'),(218,'2025-06-18-11-36-00-update-newsletters-link-color-null-to-accent.js','5.126','6.47'),(219,'2025-06-19-13-41-54-add-web-analytics-setting.js','5.127','6.47'),(220,'2025-06-26-09-36-41-add-social-web-setting.js','5.128','6.47'),(221,'2025-07-11-14-14-54-add-explore-settings.js','5.130','6.47'),(222,'2025-06-20-01-41-54-remove-updated-by-column.js','6.0','6.47'),(223,'2025-06-20-13-41-55-remove-created-by-column.js','6.0','6.47'),(224,'2025-06-23-09-49-25-add-missing-member-uuids.js','6.0','6.47'),(225,'2025-06-23-10-03-26-members-nullable-uuid.js','6.0','6.47'),(226,'2025-06-24-09-19-42-use-object-id-for-hardcoded-user-id.js','6.0','6.47'),(227,'2025-06-25-15-03-29-remove-amp-from-settings.js','6.0','6.47'),(228,'2025-06-30-13-59-10-remove-mail-events-table.js','6.0','6.47'),(229,'2025-06-30-14-00-00-update-feature-image-alt-length.js','6.0','6.47'),(230,'2025-09-11-00-38-13-add-uuid-column-to-tokens.js','6.1','6.47'),(231,'2025-09-11-00-39-08-backfill-tokens-uuid.js','6.1','6.47'),(232,'2025-09-11-00-39-36-tokens-drop-nullable-uuid.js','6.1','6.47'),(233,'2025-09-30-14-28-09-add-utm-fields.js','6.2','6.47'),(234,'2025-10-02-15-13-31-add-members-otc-secret-setting.js','6.3','6.47'),(235,'2025-10-13-10-18-38-add-tokens-otc-used-count-column.js','6.4','6.47'),(236,'2025-11-02-18-29-37-add-outbox-table.js','6.7','6.47'),(237,'2025-11-03-15-17-05-add-csd-email-count.js','6.7','6.47'),(238,'2025-11-03-15-18-04-add-email-batch-fallback-domain.js','6.7','6.47'),(239,'2025-12-01-21-04-36-add-automated-emails-table.js','6.10','6.47'),(240,'2025-12-01-21-04-37-add-automated-email-permissions.js','6.10','6.47'),(241,'2026-01-08-11-48-16-add-indexnow-api-key-setting.js','6.12','6.47'),(242,'2026-01-14-12-56-03-add-redemption-type-to-offers.js','6.13','6.47'),(243,'2026-01-15-12-00-00-add-transistor-integration.js','6.14','6.47'),(244,'2026-01-15-12-01-00-add-transistor-integration-api-key.js','6.14','6.47'),(245,'2026-01-22-12-00-49-add-automated-email-recipients-table.js','6.14','6.47'),(246,'2026-01-26-12-00-00-add-commenting-column-to-members.js','6.15','6.47'),(247,'2026-01-26-18-06-00-add-billing-portal-setting.js','6.15','6.47'),(248,'2026-01-27-12-55-51-add-discount-start-end-to-subscriptions.js','6.16','6.47'),(249,'2026-02-04-10-42-20-offers-nullable-product-id.js','6.17','6.47'),(250,'2026-02-04-10-42-20-offers-nullable-product-id.js','6.18','6.47'),(251,'2026-02-10-12-00-00-add-transistor-portal-settings.js','6.19','6.47'),(252,'2026-03-24-15-55-52-add-show-share-button-to-newsletters.js','6.23','6.47'),(253,'2026-03-26-15-46-51-add-email-design-settings-table.js','6.24','6.47'),(254,'2026-03-26-15-47-00-insert-default-email-design-settings-row.js','6.25','6.47'),(255,'2026-03-30-20-22-25-add-email-design-setting-permissions.js','6.25','6.47'),(256,'2026-03-30-22-16-43-add-email-design-setting-id-to-automated-emails.js','6.25','6.47'),(257,'2026-03-31-13-12-10-backfill-automated-emails-email-design-setting-id.js','6.25','6.47'),(258,'2026-03-31-20-31-19-drop-nullable-on-automated-emails-email-design-setting-id.js','6.25','6.47'),(259,'2026-04-06-07-48-06-add-gifts-table.js','6.27','6.47'),(260,'2026-04-06-14-27-21-add-welcome-email-automation-tables.js','6.27','6.47'),(261,'2026-04-06-15-55-20-split-automated-emails-into-welcome-email-tables.js','6.27','6.47'),(262,'2026-04-07-15-10-32-update-automated-email-recipients-foreign-key.js','6.27','6.47'),(263,'2026-04-08-13-05-35-drop-automated-emails-table.js','6.28','6.47'),(264,'2026-04-08-21-40-32-add-show-header-icon-to-email-design-settings.js','6.28','6.47'),(265,'2026-04-09-02-30-06-disable-default-header-fields-for-existing-welcome-emails.js','6.28','6.47'),(266,'2026-04-09-15-17-41-drop-nullable-gifts-expires-at.js','6.28','6.47'),(267,'2026-04-09-15-50-03-add-gift-subscription-purchase-notification-column.js','6.28','6.47'),(268,'2026-04-09-15-50-08-add-gift-subscription-redemption-notification-column.js','6.28','6.47'),(269,'2026-04-12-20-34-22-add-welcome-email-automation-runs-table.js','6.29','6.47'),(270,'2026-04-13-09-12-13-drop-gift-subscription-redemption-notification-column.js','6.29','6.47'),(271,'2026-04-15-15-18-28-add-gifts-status-indexes.js','6.31','6.47'),(272,'2026-04-16-12-30-53-add-gifts-consumes-soon-reminder-sent-at-column.js','6.31','6.47'),(273,'2026-04-22-20-53-24-add-automations-poll-permission-to-scheduler-integration.js','6.33','6.47'),(274,'2026-04-14-20-12-28-add-publication-social-account-settings.js','6.36','6.47'),(275,'2026-04-28-12-03-44-add-gifts-flush-reminders-permission-to-scheduler-integration.js','6.36','6.47'),(276,'2026-04-28-22-57-29-add-automations-permissions.js','6.36','6.47'),(277,'2026-04-29-12-13-44-add-batch-id-to-members-status-events.js','6.36','6.47'),(278,'2026-05-04-07-51-14-add-members-created-at-id-index.js','6.37','6.47'),(279,'2026-05-13-13-00-33-rename-users-gift-subscription-purchase-notification.js','6.39','6.47'),(280,'2026-05-18-10-08-40-add-pinned-at-to-comments.js','6.40','6.47'),(281,'2026-05-18-19-32-45-rename-welcome-email-automations-table-to-automations.js','6.40','6.47'),(282,'2026-05-20-00-00-00-add-llms-enabled-setting.js','6.40','6.47'),(283,'2026-05-13-12-00-00-rename-reset-all-passwords-permission.js','6.41','6.47'),(284,'2026-05-21-06-56-05-add-score-to-comment-likes.js','6.42','6.47'),(285,'2026-06-08-11-23-46-add-revalidation-failure-count-to-mentions.js','6.45','6.47'),(286,'2026-06-09-09-00-00-add-members-current-subscription-table.js','6.45','6.47'),(287,'2026-06-09-09-00-01-add-members-resolved-subscription-view.js','6.45','6.47'),(288,'2026-06-09-09-00-02-backfill-members-current-subscription.js','6.45','6.47'),(289,'2026-06-09-21-16-36-add-sender-columns-to-email-design-settings.js','6.45','6.47'),(290,'2026-06-11-16-04-43-make-automated-email-recipient-email-id-nullable.js','6.45','6.47'),(291,'2026-05-29-08-35-51-add-gift-links-table.js','6.46','6.47'),(292,'2026-05-29-08-35-56-add-gift-links-permissions.js','6.46','6.47'),(293,'2026-06-14-02-38-59-create-automation-tables.js','6.46','6.47'),(294,'2026-06-14-03-36-21-backfill-welcome-email-sender-fields-to-email-design-settings.js','6.46','6.47'),(295,'2026-06-15-16-49-31-add-automation-action-revision-id-to-automated-email-recipients.js','6.46','6.47'),(296,'2026-06-17-10-00-00-add-gift-links-permission-to-admin-integration.js','6.46','6.47'),(297,'2026-06-17-12-00-00-redesign-gift-links-table.js','6.46','6.47'),(298,'2026-06-17-13-00-00-rename-gift-links-revoke-all-permission.js','6.46','6.47'),(299,'2026-06-17-16-09-07-add-enable-updates-and-announcements-to-members.js','6.46','6.47'),(300,'2026-06-18-16-37-27-rename-welcome-email-automation-names.js','6.46','6.47'),(301,'2026-06-19-10-00-00-grandfather-llms.js','6.46','6.47');
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations_lock`
--

DROP TABLE IF EXISTS `migrations_lock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations_lock` (
  `lock_key` varchar(191) NOT NULL,
  `locked` tinyint(1) DEFAULT 0,
  `acquired_at` datetime DEFAULT NULL,
  `released_at` datetime DEFAULT NULL,
  PRIMARY KEY (`lock_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations_lock`
--

LOCK TABLES `migrations_lock` WRITE;
/*!40000 ALTER TABLE `migrations_lock` DISABLE KEYS */;
INSERT INTO `migrations_lock` VALUES ('km01',0,'2026-06-25 10:26:04','2026-06-25 10:26:18');
/*!40000 ALTER TABLE `migrations_lock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `milestones`
--

DROP TABLE IF EXISTS `milestones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `milestones` (
  `id` varchar(24) NOT NULL,
  `type` varchar(24) NOT NULL,
  `value` int(11) NOT NULL,
  `currency` varchar(24) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `email_sent_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `milestones`
--

LOCK TABLES `milestones` WRITE;
/*!40000 ALTER TABLE `milestones` DISABLE KEYS */;
INSERT INTO `milestones` VALUES ('6a3d0392cda08b7e3b98ebcf','members',0,NULL,'2026-06-25 10:31:46',NULL);
/*!40000 ALTER TABLE `milestones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mobiledoc_revisions`
--

DROP TABLE IF EXISTS `mobiledoc_revisions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `mobiledoc_revisions` (
  `id` varchar(24) NOT NULL,
  `post_id` varchar(24) NOT NULL,
  `mobiledoc` longtext DEFAULT NULL,
  `created_at_ts` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mobiledoc_revisions_post_id_index` (`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mobiledoc_revisions`
--

LOCK TABLES `mobiledoc_revisions` WRITE;
/*!40000 ALTER TABLE `mobiledoc_revisions` DISABLE KEYS */;
/*!40000 ALTER TABLE `mobiledoc_revisions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `newsletters`
--

DROP TABLE IF EXISTS `newsletters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `newsletters` (
  `id` varchar(24) NOT NULL,
  `uuid` varchar(36) NOT NULL,
  `name` varchar(191) NOT NULL,
  `description` varchar(2000) DEFAULT NULL,
  `feedback_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `slug` varchar(191) NOT NULL,
  `sender_name` varchar(191) DEFAULT NULL,
  `sender_email` varchar(191) DEFAULT NULL,
  `sender_reply_to` varchar(191) NOT NULL DEFAULT 'newsletter',
  `status` varchar(50) NOT NULL DEFAULT 'active',
  `visibility` varchar(50) NOT NULL DEFAULT 'members',
  `subscribe_on_signup` tinyint(1) NOT NULL DEFAULT 1,
  `sort_order` int(10) unsigned NOT NULL DEFAULT 0,
  `header_image` varchar(2000) DEFAULT NULL,
  `show_header_icon` tinyint(1) NOT NULL DEFAULT 1,
  `show_header_title` tinyint(1) NOT NULL DEFAULT 1,
  `show_excerpt` tinyint(1) NOT NULL DEFAULT 0,
  `title_font_category` varchar(191) NOT NULL DEFAULT 'sans_serif',
  `title_alignment` varchar(191) NOT NULL DEFAULT 'center',
  `show_feature_image` tinyint(1) NOT NULL DEFAULT 1,
  `body_font_category` varchar(191) NOT NULL DEFAULT 'sans_serif',
  `footer_content` text DEFAULT NULL,
  `show_badge` tinyint(1) NOT NULL DEFAULT 1,
  `show_header_name` tinyint(1) NOT NULL DEFAULT 1,
  `show_post_title_section` tinyint(1) NOT NULL DEFAULT 1,
  `show_comment_cta` tinyint(1) NOT NULL DEFAULT 1,
  `show_subscription_details` tinyint(1) NOT NULL DEFAULT 0,
  `show_latest_posts` tinyint(1) NOT NULL DEFAULT 0,
  `show_share_button` tinyint(1) NOT NULL DEFAULT 0,
  `background_color` varchar(50) NOT NULL DEFAULT 'light',
  `post_title_color` varchar(50) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `button_corners` varchar(50) NOT NULL DEFAULT 'rounded',
  `button_style` varchar(50) NOT NULL DEFAULT 'fill',
  `title_font_weight` varchar(50) NOT NULL DEFAULT 'bold',
  `link_style` varchar(50) NOT NULL DEFAULT 'underline',
  `image_corners` varchar(50) NOT NULL DEFAULT 'square',
  `header_background_color` varchar(50) NOT NULL DEFAULT 'transparent',
  `section_title_color` varchar(50) DEFAULT NULL,
  `divider_color` varchar(50) DEFAULT NULL,
  `button_color` varchar(50) DEFAULT 'accent',
  `link_color` varchar(50) DEFAULT 'accent',
  PRIMARY KEY (`id`),
  UNIQUE KEY `newsletters_uuid_unique` (`uuid`),
  UNIQUE KEY `newsletters_name_unique` (`name`),
  UNIQUE KEY `newsletters_slug_unique` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `newsletters`
--

LOCK TABLES `newsletters` WRITE;
/*!40000 ALTER TABLE `newsletters` DISABLE KEYS */;
INSERT INTO `newsletters` VALUES ('6a3d0246cb2d0a7ab1a59fe2','779057ed-97af-4618-873e-833be5f9e4da','Default Newsletter',NULL,0,'default-newsletter',NULL,NULL,'newsletter','active','members',1,0,NULL,1,1,0,'sans_serif','center',1,'sans_serif',NULL,1,0,1,1,0,0,0,'light',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14','rounded','fill','bold','underline','square','transparent',NULL,NULL,'accent','accent');
/*!40000 ALTER TABLE `newsletters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `offer_redemptions`
--

DROP TABLE IF EXISTS `offer_redemptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `offer_redemptions` (
  `id` varchar(24) NOT NULL,
  `offer_id` varchar(24) NOT NULL,
  `member_id` varchar(24) NOT NULL,
  `subscription_id` varchar(24) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `offer_redemptions_offer_id_foreign` (`offer_id`),
  KEY `offer_redemptions_member_id_foreign` (`member_id`),
  KEY `offer_redemptions_subscription_id_foreign` (`subscription_id`),
  CONSTRAINT `offer_redemptions_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  CONSTRAINT `offer_redemptions_offer_id_foreign` FOREIGN KEY (`offer_id`) REFERENCES `offers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `offer_redemptions_subscription_id_foreign` FOREIGN KEY (`subscription_id`) REFERENCES `members_stripe_customers_subscriptions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `offer_redemptions`
--

LOCK TABLES `offer_redemptions` WRITE;
/*!40000 ALTER TABLE `offer_redemptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `offer_redemptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `offers`
--

DROP TABLE IF EXISTS `offers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `offers` (
  `id` varchar(24) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `name` varchar(191) NOT NULL,
  `code` varchar(191) NOT NULL,
  `product_id` varchar(24) DEFAULT NULL,
  `stripe_coupon_id` varchar(255) DEFAULT NULL,
  `interval` varchar(50) NOT NULL,
  `currency` varchar(50) DEFAULT NULL,
  `discount_type` varchar(50) NOT NULL,
  `discount_amount` int(11) NOT NULL,
  `duration` varchar(50) NOT NULL,
  `duration_in_months` int(11) DEFAULT NULL,
  `portal_title` varchar(191) DEFAULT NULL,
  `portal_description` varchar(2000) DEFAULT NULL,
  `redemption_type` varchar(50) NOT NULL DEFAULT 'signup',
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `offers_name_unique` (`name`),
  UNIQUE KEY `offers_code_unique` (`code`),
  UNIQUE KEY `offers_stripe_coupon_id_unique` (`stripe_coupon_id`),
  KEY `offers_product_id_foreign` (`product_id`),
  CONSTRAINT `offers_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `offers`
--

LOCK TABLES `offers` WRITE;
/*!40000 ALTER TABLE `offers` DISABLE KEYS */;
/*!40000 ALTER TABLE `offers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `outbox`
--

DROP TABLE IF EXISTS `outbox`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `outbox` (
  `id` varchar(24) NOT NULL,
  `event_type` varchar(50) NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'pending',
  `payload` text NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `retry_count` int(10) unsigned NOT NULL DEFAULT 0,
  `last_retry_at` datetime DEFAULT NULL,
  `message` varchar(2000) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `outbox_event_type_status_created_at_index` (`event_type`,`status`,`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `outbox`
--

LOCK TABLES `outbox` WRITE;
/*!40000 ALTER TABLE `outbox` DISABLE KEYS */;
/*!40000 ALTER TABLE `outbox` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions` (
  `id` varchar(24) NOT NULL,
  `name` varchar(50) NOT NULL,
  `object_type` varchar(50) NOT NULL,
  `action_type` varchar(50) NOT NULL,
  `object_id` varchar(24) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `permissions_name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES ('6a3d0246cb2d0a7ab1a59fe5','Read explore data','explore','read',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a59fe6','Export database','db','exportContent',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a59fe7','Import database','db','importContent',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a59fe8','Delete all content','db','deleteAllContent',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a59fe9','Send mail','mail','send',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a59fea','Browse notifications','notification','browse',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a59feb','Add notifications','notification','add',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a59fec','Delete notifications','notification','destroy',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a59fed','Browse posts','post','browse',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a59fee','Read posts','post','read',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a59fef','Edit posts','post','edit',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a59ff0','Add posts','post','add',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a59ff1','Delete posts','post','destroy',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a59ff2','Browse settings','setting','browse',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a59ff3','Read settings','setting','read',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a59ff4','Edit settings','setting','edit',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a59ff5','Generate slugs','slug','generate',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a59ff6','Browse tags','tag','browse',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a59ff7','Read tags','tag','read',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a59ff8','Edit tags','tag','edit',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a59ff9','Add tags','tag','add',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a59ffa','Delete tags','tag','destroy',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a59ffb','Browse themes','theme','browse',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a59ffc','Edit themes','theme','edit',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a59ffd','Activate themes','theme','activate',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a59ffe','View active theme details','theme','readActive',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a59fff','Upload themes','theme','add',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a000','Download themes','theme','read',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a001','Delete themes','theme','destroy',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a002','Browse users','user','browse',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a003','Read users','user','read',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a004','Edit users','user','edit',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a005','Add users','user','add',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a006','Delete users','user','destroy',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a007','Assign a role','role','assign',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a008','Browse roles','role','browse',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a009','Browse invites','invite','browse',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a00a','Read invites','invite','read',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a00b','Edit invites','invite','edit',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a00c','Add invites','invite','add',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a00d','Delete invites','invite','destroy',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a00e','Download redirects','redirect','download',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a00f','Upload redirects','redirect','upload',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a010','Add webhooks','webhook','add',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a011','Edit webhooks','webhook','edit',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a012','Delete webhooks','webhook','destroy',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a013','Browse integrations','integration','browse',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a014','Read integrations','integration','read',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a015','Edit integrations','integration','edit',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a016','Add integrations','integration','add',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a017','Delete integrations','integration','destroy',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a018','Browse API keys','api_key','browse',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a019','Read API keys','api_key','read',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a01a','Edit API keys','api_key','edit',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a01b','Add API keys','api_key','add',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a01c','Delete API keys','api_key','destroy',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a01d','Browse Actions','action','browse',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a01e','Browse Members','member','browse',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a01f','Read Members','member','read',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a020','Edit Members','member','edit',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a021','Add Members','member','add',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a022','Delete Members','member','destroy',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a023','Browse Products','product','browse',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a024','Read Products','product','read',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a025','Edit Products','product','edit',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a026','Add Products','product','add',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a027','Delete Products','product','destroy',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a028','Publish posts','post','publish',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a029','Backup database','db','backupContent',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a02a','Email preview','email_preview','read',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a02b','Send test email','email_preview','sendTestEmail',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a02c','Browse emails','email','browse',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a02d','Read emails','email','read',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a02e','Retry emails','email','retry',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a02f','Browse labels','label','browse',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a030','Read labels','label','read',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a031','Edit labels','label','edit',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a032','Add labels','label','add',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a033','Delete labels','label','destroy',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a034','Browse automated emails','automated_email','browse',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a035','Read automated emails','automated_email','read',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a036','Edit automated emails','automated_email','edit',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a037','Add automated emails','automated_email','add',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a038','Delete automated emails','automated_email','destroy',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a039','Browse email design settings','email_design_setting','browse',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a03a','Read email design settings','email_design_setting','read',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a03b','Edit email design settings','email_design_setting','edit',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a03c','Add email design settings','email_design_setting','add',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a03d','Delete email design settings','email_design_setting','destroy',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a03e','Read member signin urls','member_signin_url','read',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a03f','Read identities','identity','read',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a040','Auth Stripe Connect for Members','members_stripe_connect','auth',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a041','Browse snippets','snippet','browse',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a042','Read snippets','snippet','read',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a043','Edit snippets','snippet','edit',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a044','Add snippets','snippet','add',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a045','Delete snippets','snippet','destroy',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a046','Browse offers','offer','browse',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a047','Read offers','offer','read',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a048','Edit offers','offer','edit',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a049','Add offers','offer','add',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a04a','Reset authentication','authentication','reset',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a04b','Browse custom theme settings','custom_theme_setting','browse',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a04c','Edit custom theme settings','custom_theme_setting','edit',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a04d','Browse newsletters','newsletter','browse',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a04e','Read newsletters','newsletter','read',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a04f','Add newsletters','newsletter','add',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a050','Edit newsletters','newsletter','edit',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a051','Browse comments','comment','browse',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a052','Read comments','comment','read',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a053','Edit comments','comment','edit',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a054','Add comments','comment','add',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a055','Delete comments','comment','destroy',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a056','Moderate comments','comment','moderate',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a057','Like comments','comment','like',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a058','Unlike comments','comment','unlike',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a059','Report comments','comment','report',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a05a','Browse links','link','browse',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a05b','Edit links','link','edit',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a05c','Browse mentions','mention','browse',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a05d','Browse collections','collection','browse',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a05e','Read collections','collection','read',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a05f','Edit collections','collection','edit',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a060','Add collections','collection','add',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a061','Delete collections','collection','destroy',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a062','Browse recommendations','recommendation','browse',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a063','Read recommendations','recommendation','read',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a064','Edit recommendations','recommendation','edit',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a065','Add recommendations','recommendation','add',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a066','Delete recommendations','recommendation','destroy',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a067','Browse automations','automation','browse',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a068','Read automations','automation','read',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a069','Edit automations','automation','edit',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a06a','Poll automations','automation','poll',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a06b','Flush gift reminders','gift','flushReminders',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a06c','Manage gift links','gift_link','manage',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14'),('6a3d0246cb2d0a7ab1a5a06d','Revoke all gift links','gift_link','revokeAll',NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14');
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions_roles`
--

DROP TABLE IF EXISTS `permissions_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions_roles` (
  `id` varchar(24) NOT NULL,
  `role_id` varchar(24) NOT NULL,
  `permission_id` varchar(24) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions_roles`
--

LOCK TABLES `permissions_roles` WRITE;
/*!40000 ALTER TABLE `permissions_roles` DISABLE KEYS */;
INSERT INTO `permissions_roles` VALUES ('6a3d0249cb2d0a7ab1a5a083','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a59fe6'),('6a3d0249cb2d0a7ab1a5a084','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a59fe7'),('6a3d0249cb2d0a7ab1a5a085','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a59fe8'),('6a3d0249cb2d0a7ab1a5a086','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a029'),('6a3d0249cb2d0a7ab1a5a087','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a59fe9'),('6a3d0249cb2d0a7ab1a5a088','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a59fea'),('6a3d0249cb2d0a7ab1a5a089','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a59feb'),('6a3d0249cb2d0a7ab1a5a08a','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a59fec'),('6a3d0249cb2d0a7ab1a5a08b','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a59fed'),('6a3d0249cb2d0a7ab1a5a08c','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a59fee'),('6a3d0249cb2d0a7ab1a5a08d','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a59fef'),('6a3d0249cb2d0a7ab1a5a08e','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a59ff0'),('6a3d0249cb2d0a7ab1a5a08f','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a59ff1'),('6a3d0249cb2d0a7ab1a5a090','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a028'),('6a3d0249cb2d0a7ab1a5a091','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a59ff2'),('6a3d0249cb2d0a7ab1a5a092','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a59ff3'),('6a3d0249cb2d0a7ab1a5a093','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a59ff4'),('6a3d0249cb2d0a7ab1a5a094','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a59ff5'),('6a3d0249cb2d0a7ab1a5a095','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a59ff6'),('6a3d0249cb2d0a7ab1a5a096','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a59ff7'),('6a3d0249cb2d0a7ab1a5a097','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a59ff8'),('6a3d0249cb2d0a7ab1a5a098','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a59ff9'),('6a3d0249cb2d0a7ab1a5a099','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a59ffa'),('6a3d0249cb2d0a7ab1a5a09a','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a59ffb'),('6a3d0249cb2d0a7ab1a5a09b','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a59ffc'),('6a3d0249cb2d0a7ab1a5a09c','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a59ffd'),('6a3d0249cb2d0a7ab1a5a09d','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a59ffe'),('6a3d0249cb2d0a7ab1a5a09e','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a59fff'),('6a3d0249cb2d0a7ab1a5a09f','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a000'),('6a3d0249cb2d0a7ab1a5a0a0','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a001'),('6a3d0249cb2d0a7ab1a5a0a1','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a002'),('6a3d0249cb2d0a7ab1a5a0a2','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a003'),('6a3d0249cb2d0a7ab1a5a0a3','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a004'),('6a3d0249cb2d0a7ab1a5a0a4','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a005'),('6a3d0249cb2d0a7ab1a5a0a5','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a006'),('6a3d0249cb2d0a7ab1a5a0a6','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a007'),('6a3d0249cb2d0a7ab1a5a0a7','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a008'),('6a3d0249cb2d0a7ab1a5a0a8','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a009'),('6a3d0249cb2d0a7ab1a5a0a9','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a00a'),('6a3d0249cb2d0a7ab1a5a0aa','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a00b'),('6a3d0249cb2d0a7ab1a5a0ab','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a00c'),('6a3d0249cb2d0a7ab1a5a0ac','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a00d'),('6a3d0249cb2d0a7ab1a5a0ad','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a00e'),('6a3d0249cb2d0a7ab1a5a0ae','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a00f'),('6a3d0249cb2d0a7ab1a5a0af','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a010'),('6a3d0249cb2d0a7ab1a5a0b0','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a011'),('6a3d0249cb2d0a7ab1a5a0b1','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a012'),('6a3d0249cb2d0a7ab1a5a0b2','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a013'),('6a3d0249cb2d0a7ab1a5a0b3','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a014'),('6a3d0249cb2d0a7ab1a5a0b4','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a015'),('6a3d0249cb2d0a7ab1a5a0b5','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a016'),('6a3d0249cb2d0a7ab1a5a0b6','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a017'),('6a3d0249cb2d0a7ab1a5a0b7','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a018'),('6a3d0249cb2d0a7ab1a5a0b8','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a019'),('6a3d0249cb2d0a7ab1a5a0b9','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a01a'),('6a3d0249cb2d0a7ab1a5a0ba','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a01b'),('6a3d0249cb2d0a7ab1a5a0bb','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a01c'),('6a3d0249cb2d0a7ab1a5a0bc','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a01d'),('6a3d0249cb2d0a7ab1a5a0bd','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a01e'),('6a3d0249cb2d0a7ab1a5a0be','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a01f'),('6a3d0249cb2d0a7ab1a5a0bf','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a020'),('6a3d0249cb2d0a7ab1a5a0c0','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a021'),('6a3d0249cb2d0a7ab1a5a0c1','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a022'),('6a3d0249cb2d0a7ab1a5a0c2','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a023'),('6a3d0249cb2d0a7ab1a5a0c3','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a024'),('6a3d0249cb2d0a7ab1a5a0c4','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a025'),('6a3d0249cb2d0a7ab1a5a0c5','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a026'),('6a3d0249cb2d0a7ab1a5a0c6','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a027'),('6a3d0249cb2d0a7ab1a5a0c7','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a02f'),('6a3d0249cb2d0a7ab1a5a0c8','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a030'),('6a3d0249cb2d0a7ab1a5a0c9','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a031'),('6a3d0249cb2d0a7ab1a5a0ca','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a032'),('6a3d0249cb2d0a7ab1a5a0cb','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a033'),('6a3d0249cb2d0a7ab1a5a0cc','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a034'),('6a3d0249cb2d0a7ab1a5a0cd','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a035'),('6a3d0249cb2d0a7ab1a5a0ce','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a036'),('6a3d0249cb2d0a7ab1a5a0cf','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a037'),('6a3d0249cb2d0a7ab1a5a0d0','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a038'),('6a3d0249cb2d0a7ab1a5a0d1','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a039'),('6a3d0249cb2d0a7ab1a5a0d2','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a03a'),('6a3d0249cb2d0a7ab1a5a0d3','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a03b'),('6a3d0249cb2d0a7ab1a5a0d4','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a03c'),('6a3d0249cb2d0a7ab1a5a0d5','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a03d'),('6a3d0249cb2d0a7ab1a5a0d6','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a02a'),('6a3d0249cb2d0a7ab1a5a0d7','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a02b'),('6a3d0249cb2d0a7ab1a5a0d8','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a02c'),('6a3d0249cb2d0a7ab1a5a0d9','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a02d'),('6a3d0249cb2d0a7ab1a5a0da','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a02e'),('6a3d0249cb2d0a7ab1a5a0db','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a03e'),('6a3d0249cb2d0a7ab1a5a0dc','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a041'),('6a3d0249cb2d0a7ab1a5a0dd','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a042'),('6a3d0249cb2d0a7ab1a5a0de','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a043'),('6a3d0249cb2d0a7ab1a5a0df','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a044'),('6a3d0249cb2d0a7ab1a5a0e0','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a045'),('6a3d0249cb2d0a7ab1a5a0e1','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a04b'),('6a3d0249cb2d0a7ab1a5a0e2','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a04c'),('6a3d0249cb2d0a7ab1a5a0e3','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a046'),('6a3d0249cb2d0a7ab1a5a0e4','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a047'),('6a3d0249cb2d0a7ab1a5a0e5','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a048'),('6a3d0249cb2d0a7ab1a5a0e6','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a049'),('6a3d0249cb2d0a7ab1a5a0e7','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a04a'),('6a3d0249cb2d0a7ab1a5a0e8','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a040'),('6a3d0249cb2d0a7ab1a5a0e9','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a04d'),('6a3d0249cb2d0a7ab1a5a0ea','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a04e'),('6a3d0249cb2d0a7ab1a5a0eb','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a04f'),('6a3d0249cb2d0a7ab1a5a0ec','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a050'),('6a3d0249cb2d0a7ab1a5a0ed','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a59fe5'),('6a3d0249cb2d0a7ab1a5a0ee','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a051'),('6a3d0249cb2d0a7ab1a5a0ef','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a052'),('6a3d0249cb2d0a7ab1a5a0f0','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a053'),('6a3d0249cb2d0a7ab1a5a0f1','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a054'),('6a3d0249cb2d0a7ab1a5a0f2','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a055'),('6a3d0249cb2d0a7ab1a5a0f3','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a056'),('6a3d0249cb2d0a7ab1a5a0f4','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a057'),('6a3d0249cb2d0a7ab1a5a0f5','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a058'),('6a3d0249cb2d0a7ab1a5a0f6','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a059'),('6a3d0249cb2d0a7ab1a5a0f7','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a05a'),('6a3d0249cb2d0a7ab1a5a0f8','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a05b'),('6a3d0249cb2d0a7ab1a5a0f9','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a05c'),('6a3d0249cb2d0a7ab1a5a0fa','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a05d'),('6a3d0249cb2d0a7ab1a5a0fb','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a05e'),('6a3d0249cb2d0a7ab1a5a0fc','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a05f'),('6a3d0249cb2d0a7ab1a5a0fd','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a060'),('6a3d0249cb2d0a7ab1a5a0fe','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a061'),('6a3d0249cb2d0a7ab1a5a0ff','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a062'),('6a3d0249cb2d0a7ab1a5a100','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a063'),('6a3d0249cb2d0a7ab1a5a101','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a064'),('6a3d0249cb2d0a7ab1a5a102','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a065'),('6a3d0249cb2d0a7ab1a5a103','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a066'),('6a3d0249cb2d0a7ab1a5a104','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a06c'),('6a3d0249cb2d0a7ab1a5a105','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a06d'),('6a3d0249cb2d0a7ab1a5a106','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a067'),('6a3d0249cb2d0a7ab1a5a107','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a068'),('6a3d0249cb2d0a7ab1a5a108','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a069'),('6a3d0249cb2d0a7ab1a5a109','6a3d0243cb2d0a7ab1a59fd2','6a3d0246cb2d0a7ab1a5a03f'),('6a3d0249cb2d0a7ab1a5a10a','6a3d0244cb2d0a7ab1a59fda','6a3d0246cb2d0a7ab1a59fe6'),('6a3d0249cb2d0a7ab1a5a10b','6a3d0244cb2d0a7ab1a59fda','6a3d0246cb2d0a7ab1a59fe7'),('6a3d0249cb2d0a7ab1a5a10c','6a3d0244cb2d0a7ab1a59fda','6a3d0246cb2d0a7ab1a59fe8'),('6a3d0249cb2d0a7ab1a5a10d','6a3d0244cb2d0a7ab1a59fda','6a3d0246cb2d0a7ab1a5a029'),('6a3d0249cb2d0a7ab1a5a10e','6a3d0244cb2d0a7ab1a59fda','6a3d0246cb2d0a7ab1a5a01e'),('6a3d0249cb2d0a7ab1a5a10f','6a3d0244cb2d0a7ab1a59fdb','6a3d0246cb2d0a7ab1a5a028'),('6a3d0249cb2d0a7ab1a5a110','6a3d0244cb2d0a7ab1a59fdb','6a3d0246cb2d0a7ab1a5a06a'),('6a3d0249cb2d0a7ab1a5a111','6a3d0244cb2d0a7ab1a59fdb','6a3d0246cb2d0a7ab1a5a06b'),('6a3d0249cb2d0a7ab1a5a112','6a3d0244cb2d0a7ab1a59fd8','6a3d0246cb2d0a7ab1a59fe5'),('6a3d0249cb2d0a7ab1a5a113','6a3d0244cb2d0a7ab1a59fd9','6a3d0246cb2d0a7ab1a59fe7'),('6a3d0249cb2d0a7ab1a5a114','6a3d0244cb2d0a7ab1a59fd9','6a3d0246cb2d0a7ab1a5a021'),('6a3d0249cb2d0a7ab1a5a115','6a3d0244cb2d0a7ab1a59fd9','6a3d0246cb2d0a7ab1a59ff7'),('6a3d0249cb2d0a7ab1a5a116','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a59fe9'),('6a3d0249cb2d0a7ab1a5a117','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a59fea'),('6a3d0249cb2d0a7ab1a5a118','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a59feb'),('6a3d0249cb2d0a7ab1a5a119','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a59fec'),('6a3d0249cb2d0a7ab1a5a11a','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a59fed'),('6a3d0249cb2d0a7ab1a5a11b','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a59fee'),('6a3d0249cb2d0a7ab1a5a11c','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a59fef'),('6a3d0249cb2d0a7ab1a5a11d','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a59ff0'),('6a3d0249cb2d0a7ab1a5a11e','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a59ff1'),('6a3d0249cb2d0a7ab1a5a11f','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a028'),('6a3d0249cb2d0a7ab1a5a120','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a59ff2'),('6a3d0249cb2d0a7ab1a5a121','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a59ff3'),('6a3d0249cb2d0a7ab1a5a122','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a59ff4'),('6a3d0249cb2d0a7ab1a5a123','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a59ff5'),('6a3d0249cb2d0a7ab1a5a124','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a59ff6'),('6a3d0249cb2d0a7ab1a5a125','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a59ff7'),('6a3d0249cb2d0a7ab1a5a126','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a59ff8'),('6a3d0249cb2d0a7ab1a5a127','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a59ff9'),('6a3d0249cb2d0a7ab1a5a128','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a59ffa'),('6a3d0249cb2d0a7ab1a5a129','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a59ffb'),('6a3d0249cb2d0a7ab1a5a12a','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a59ffc'),('6a3d0249cb2d0a7ab1a5a12b','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a59ffd'),('6a3d0249cb2d0a7ab1a5a12c','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a59ffe'),('6a3d0249cb2d0a7ab1a5a12d','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a59fff'),('6a3d0249cb2d0a7ab1a5a12e','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a000'),('6a3d0249cb2d0a7ab1a5a12f','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a001'),('6a3d0249cb2d0a7ab1a5a130','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a002'),('6a3d0249cb2d0a7ab1a5a131','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a003'),('6a3d0249cb2d0a7ab1a5a132','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a004'),('6a3d0249cb2d0a7ab1a5a133','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a005'),('6a3d0249cb2d0a7ab1a5a134','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a006'),('6a3d0249cb2d0a7ab1a5a135','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a007'),('6a3d0249cb2d0a7ab1a5a136','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a008'),('6a3d0249cb2d0a7ab1a5a137','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a009'),('6a3d0249cb2d0a7ab1a5a138','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a00a'),('6a3d0249cb2d0a7ab1a5a139','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a00b'),('6a3d0249cb2d0a7ab1a5a13a','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a00c'),('6a3d0249cb2d0a7ab1a5a13b','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a00d'),('6a3d0249cb2d0a7ab1a5a13c','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a00e'),('6a3d0249cb2d0a7ab1a5a13d','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a00f'),('6a3d0249cb2d0a7ab1a5a13e','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a010'),('6a3d0249cb2d0a7ab1a5a13f','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a011'),('6a3d0249cb2d0a7ab1a5a140','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a012'),('6a3d0249cb2d0a7ab1a5a141','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a01d'),('6a3d0249cb2d0a7ab1a5a142','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a01e'),('6a3d0249cb2d0a7ab1a5a143','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a01f'),('6a3d0249cb2d0a7ab1a5a144','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a020'),('6a3d0249cb2d0a7ab1a5a145','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a021'),('6a3d0249cb2d0a7ab1a5a146','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a022'),('6a3d0249cb2d0a7ab1a5a147','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a02f'),('6a3d0249cb2d0a7ab1a5a148','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a030'),('6a3d0249cb2d0a7ab1a5a149','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a031'),('6a3d0249cb2d0a7ab1a5a14a','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a032'),('6a3d0249cb2d0a7ab1a5a14b','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a033'),('6a3d0249cb2d0a7ab1a5a14c','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a034'),('6a3d0249cb2d0a7ab1a5a14d','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a035'),('6a3d0249cb2d0a7ab1a5a14e','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a036'),('6a3d0249cb2d0a7ab1a5a14f','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a037'),('6a3d0249cb2d0a7ab1a5a150','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a038'),('6a3d0249cb2d0a7ab1a5a151','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a039'),('6a3d0249cb2d0a7ab1a5a152','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a03a'),('6a3d0249cb2d0a7ab1a5a153','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a03b'),('6a3d0249cb2d0a7ab1a5a154','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a03c'),('6a3d0249cb2d0a7ab1a5a155','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a03d'),('6a3d0249cb2d0a7ab1a5a156','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a02a'),('6a3d0249cb2d0a7ab1a5a157','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a02b'),('6a3d0249cb2d0a7ab1a5a158','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a02c'),('6a3d0249cb2d0a7ab1a5a159','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a02d'),('6a3d0249cb2d0a7ab1a5a15a','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a02e'),('6a3d0249cb2d0a7ab1a5a15b','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a041'),('6a3d0249cb2d0a7ab1a5a15c','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a042'),('6a3d0249cb2d0a7ab1a5a15d','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a043'),('6a3d0249cb2d0a7ab1a5a15e','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a044'),('6a3d0249cb2d0a7ab1a5a15f','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a045'),('6a3d0249cb2d0a7ab1a5a160','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a023'),('6a3d0249cb2d0a7ab1a5a161','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a024'),('6a3d0249cb2d0a7ab1a5a162','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a025'),('6a3d0249cb2d0a7ab1a5a163','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a026'),('6a3d0249cb2d0a7ab1a5a164','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a046'),('6a3d0249cb2d0a7ab1a5a165','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a047'),('6a3d0249cb2d0a7ab1a5a166','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a048'),('6a3d0249cb2d0a7ab1a5a167','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a049'),('6a3d0249cb2d0a7ab1a5a168','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a04d'),('6a3d0249cb2d0a7ab1a5a169','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a04e'),('6a3d0249cb2d0a7ab1a5a16a','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a04f'),('6a3d0249cb2d0a7ab1a5a16b','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a050'),('6a3d0249cb2d0a7ab1a5a16c','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a59fe5'),('6a3d0249cb2d0a7ab1a5a16d','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a051'),('6a3d0249cb2d0a7ab1a5a16e','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a052'),('6a3d0249cb2d0a7ab1a5a16f','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a053'),('6a3d0249cb2d0a7ab1a5a170','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a054'),('6a3d0249cb2d0a7ab1a5a171','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a055'),('6a3d0249cb2d0a7ab1a5a172','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a056'),('6a3d0249cb2d0a7ab1a5a173','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a057'),('6a3d0249cb2d0a7ab1a5a174','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a058'),('6a3d0249cb2d0a7ab1a5a175','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a059'),('6a3d0249cb2d0a7ab1a5a176','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a05a'),('6a3d0249cb2d0a7ab1a5a177','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a05b'),('6a3d0249cb2d0a7ab1a5a178','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a05c'),('6a3d0249cb2d0a7ab1a5a179','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a05d'),('6a3d0249cb2d0a7ab1a5a17a','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a05e'),('6a3d0249cb2d0a7ab1a5a17b','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a05f'),('6a3d0249cb2d0a7ab1a5a17c','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a060'),('6a3d0249cb2d0a7ab1a5a17d','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a061'),('6a3d0249cb2d0a7ab1a5a17e','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a062'),('6a3d0249cb2d0a7ab1a5a17f','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a063'),('6a3d0249cb2d0a7ab1a5a180','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a064'),('6a3d0249cb2d0a7ab1a5a181','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a065'),('6a3d0249cb2d0a7ab1a5a182','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a066'),('6a3d0249cb2d0a7ab1a5a183','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a067'),('6a3d0249cb2d0a7ab1a5a184','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a068'),('6a3d0249cb2d0a7ab1a5a185','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a069'),('6a3d0249cb2d0a7ab1a5a186','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a03e'),('6a3d0249cb2d0a7ab1a5a187','6a3d0244cb2d0a7ab1a59fd7','6a3d0246cb2d0a7ab1a5a06c'),('6a3d0249cb2d0a7ab1a5a188','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a59fea'),('6a3d0249cb2d0a7ab1a5a189','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a59feb'),('6a3d0249cb2d0a7ab1a5a18a','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a59fec'),('6a3d0249cb2d0a7ab1a5a18b','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a59fed'),('6a3d0249cb2d0a7ab1a5a18c','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a59fee'),('6a3d0249cb2d0a7ab1a5a18d','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a59fef'),('6a3d0249cb2d0a7ab1a5a18e','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a59ff0'),('6a3d0249cb2d0a7ab1a5a18f','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a59ff1'),('6a3d0249cb2d0a7ab1a5a190','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a028'),('6a3d0249cb2d0a7ab1a5a191','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a59ff2'),('6a3d0249cb2d0a7ab1a5a192','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a59ff3'),('6a3d0249cb2d0a7ab1a5a193','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a59ff5'),('6a3d0249cb2d0a7ab1a5a194','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a59ff6'),('6a3d0249cb2d0a7ab1a5a195','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a59ff7'),('6a3d0249cb2d0a7ab1a5a196','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a59ff8'),('6a3d0249cb2d0a7ab1a5a197','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a59ff9'),('6a3d0249cb2d0a7ab1a5a198','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a59ffa'),('6a3d0249cb2d0a7ab1a5a199','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a002'),('6a3d0249cb2d0a7ab1a5a19a','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a003'),('6a3d0249cb2d0a7ab1a5a19b','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a004'),('6a3d0249cb2d0a7ab1a5a19c','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a005'),('6a3d0249cb2d0a7ab1a5a19d','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a006'),('6a3d0249cb2d0a7ab1a5a19e','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a007'),('6a3d0249cb2d0a7ab1a5a19f','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a008'),('6a3d0249cb2d0a7ab1a5a1a0','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a009'),('6a3d0249cb2d0a7ab1a5a1a1','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a00a'),('6a3d0249cb2d0a7ab1a5a1a2','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a00b'),('6a3d0249cb2d0a7ab1a5a1a3','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a00c'),('6a3d0249cb2d0a7ab1a5a1a4','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a00d'),('6a3d0249cb2d0a7ab1a5a1a5','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a59ffb'),('6a3d0249cb2d0a7ab1a5a1a6','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a59ffe'),('6a3d0249cb2d0a7ab1a5a1a7','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a02a'),('6a3d0249cb2d0a7ab1a5a1a8','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a02b'),('6a3d0249cb2d0a7ab1a5a1a9','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a02c'),('6a3d0249cb2d0a7ab1a5a1aa','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a02d'),('6a3d0249cb2d0a7ab1a5a1ab','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a02e'),('6a3d0249cb2d0a7ab1a5a1ac','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a041'),('6a3d0249cb2d0a7ab1a5a1ad','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a042'),('6a3d0249cb2d0a7ab1a5a1ae','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a043'),('6a3d0249cb2d0a7ab1a5a1af','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a044'),('6a3d0249cb2d0a7ab1a5a1b0','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a045'),('6a3d0249cb2d0a7ab1a5a1b1','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a02f'),('6a3d0249cb2d0a7ab1a5a1b2','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a030'),('6a3d0249cb2d0a7ab1a5a1b3','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a031'),('6a3d0249cb2d0a7ab1a5a1b4','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a032'),('6a3d0249cb2d0a7ab1a5a1b5','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a033'),('6a3d0249cb2d0a7ab1a5a1b6','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a023'),('6a3d0249cb2d0a7ab1a5a1b7','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a024'),('6a3d0249cb2d0a7ab1a5a1b8','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a04d'),('6a3d0249cb2d0a7ab1a5a1b9','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a04e'),('6a3d0249cb2d0a7ab1a5a1ba','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a05d'),('6a3d0249cb2d0a7ab1a5a1bb','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a05e'),('6a3d0249cb2d0a7ab1a5a1bc','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a05f'),('6a3d0249cb2d0a7ab1a5a1bd','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a060'),('6a3d0249cb2d0a7ab1a5a1be','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a061'),('6a3d0249cb2d0a7ab1a5a1bf','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a062'),('6a3d0249cb2d0a7ab1a5a1c0','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a063'),('6a3d0249cb2d0a7ab1a5a1c1','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a01e'),('6a3d0249cb2d0a7ab1a5a1c2','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a01f'),('6a3d0249cb2d0a7ab1a5a1c3','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a020'),('6a3d0249cb2d0a7ab1a5a1c4','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a021'),('6a3d0249cb2d0a7ab1a5a1c5','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a022'),('6a3d0249cb2d0a7ab1a5a1c6','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a03e'),('6a3d0249cb2d0a7ab1a5a1c7','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a046'),('6a3d0249cb2d0a7ab1a5a1c8','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a047'),('6a3d0249cb2d0a7ab1a5a1c9','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a051'),('6a3d0249cb2d0a7ab1a5a1ca','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a052'),('6a3d0249cb2d0a7ab1a5a1cb','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a053'),('6a3d0249cb2d0a7ab1a5a1cc','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a054'),('6a3d0249cb2d0a7ab1a5a1cd','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a055'),('6a3d0249cb2d0a7ab1a5a1ce','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a056'),('6a3d0249cb2d0a7ab1a5a1cf','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a057'),('6a3d0249cb2d0a7ab1a5a1d0','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a058'),('6a3d0249cb2d0a7ab1a5a1d1','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a059'),('6a3d0249cb2d0a7ab1a5a1d2','6a3d0244cb2d0a7ab1a59fdc','6a3d0246cb2d0a7ab1a5a06c'),('6a3d0249cb2d0a7ab1a5a1d3','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a59fea'),('6a3d0249cb2d0a7ab1a5a1d4','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a59feb'),('6a3d0249cb2d0a7ab1a5a1d5','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a59fec'),('6a3d0249cb2d0a7ab1a5a1d6','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a59fed'),('6a3d0249cb2d0a7ab1a5a1d7','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a59fee'),('6a3d0249cb2d0a7ab1a5a1d8','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a59fef'),('6a3d0249cb2d0a7ab1a5a1d9','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a59ff0'),('6a3d0249cb2d0a7ab1a5a1da','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a59ff1'),('6a3d0249cb2d0a7ab1a5a1db','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a028'),('6a3d024acb2d0a7ab1a5a1dc','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a59ff2'),('6a3d024acb2d0a7ab1a5a1dd','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a59ff3'),('6a3d024acb2d0a7ab1a5a1de','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a59ff5'),('6a3d024acb2d0a7ab1a5a1df','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a59ff6'),('6a3d024acb2d0a7ab1a5a1e0','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a59ff7'),('6a3d024acb2d0a7ab1a5a1e1','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a59ff8'),('6a3d024acb2d0a7ab1a5a1e2','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a59ff9'),('6a3d024acb2d0a7ab1a5a1e3','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a59ffa'),('6a3d024acb2d0a7ab1a5a1e4','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a002'),('6a3d024acb2d0a7ab1a5a1e5','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a003'),('6a3d024acb2d0a7ab1a5a1e6','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a004'),('6a3d024acb2d0a7ab1a5a1e7','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a005'),('6a3d024acb2d0a7ab1a5a1e8','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a006'),('6a3d024acb2d0a7ab1a5a1e9','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a007'),('6a3d024acb2d0a7ab1a5a1ea','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a008'),('6a3d024acb2d0a7ab1a5a1eb','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a009'),('6a3d024acb2d0a7ab1a5a1ec','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a00a'),('6a3d024acb2d0a7ab1a5a1ed','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a00b'),('6a3d024acb2d0a7ab1a5a1ee','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a00c'),('6a3d024acb2d0a7ab1a5a1ef','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a00d'),('6a3d024acb2d0a7ab1a5a1f0','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a59ffb'),('6a3d024acb2d0a7ab1a5a1f1','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a59ffe'),('6a3d024acb2d0a7ab1a5a1f2','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a02a'),('6a3d024acb2d0a7ab1a5a1f3','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a02b'),('6a3d024acb2d0a7ab1a5a1f4','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a02c'),('6a3d024acb2d0a7ab1a5a1f5','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a02d'),('6a3d024acb2d0a7ab1a5a1f6','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a02e'),('6a3d024acb2d0a7ab1a5a1f7','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a041'),('6a3d024acb2d0a7ab1a5a1f8','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a042'),('6a3d024acb2d0a7ab1a5a1f9','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a043'),('6a3d024acb2d0a7ab1a5a1fa','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a044'),('6a3d024acb2d0a7ab1a5a1fb','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a045'),('6a3d024acb2d0a7ab1a5a1fc','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a02f'),('6a3d024acb2d0a7ab1a5a1fd','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a030'),('6a3d024acb2d0a7ab1a5a1fe','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a023'),('6a3d024acb2d0a7ab1a5a1ff','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a024'),('6a3d024acb2d0a7ab1a5a200','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a04d'),('6a3d024acb2d0a7ab1a5a201','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a04e'),('6a3d024acb2d0a7ab1a5a202','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a05d'),('6a3d024acb2d0a7ab1a5a203','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a05e'),('6a3d024acb2d0a7ab1a5a204','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a05f'),('6a3d024acb2d0a7ab1a5a205','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a060'),('6a3d024acb2d0a7ab1a5a206','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a061'),('6a3d024acb2d0a7ab1a5a207','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a062'),('6a3d024acb2d0a7ab1a5a208','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a063'),('6a3d024acb2d0a7ab1a5a209','6a3d0243cb2d0a7ab1a59fd3','6a3d0246cb2d0a7ab1a5a06c'),('6a3d024acb2d0a7ab1a5a20a','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a59fed'),('6a3d024acb2d0a7ab1a5a20b','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a59fee'),('6a3d024acb2d0a7ab1a5a20c','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a59fef'),('6a3d024acb2d0a7ab1a5a20d','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a59ff0'),('6a3d024acb2d0a7ab1a5a20e','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a59ff1'),('6a3d024acb2d0a7ab1a5a20f','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a59ff2'),('6a3d024acb2d0a7ab1a5a210','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a59ff3'),('6a3d024acb2d0a7ab1a5a211','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a59ff5'),('6a3d024acb2d0a7ab1a5a212','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a59ff6'),('6a3d024acb2d0a7ab1a5a213','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a59ff7'),('6a3d024acb2d0a7ab1a5a214','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a59ff9'),('6a3d024acb2d0a7ab1a5a215','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a5a002'),('6a3d024acb2d0a7ab1a5a216','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a5a003'),('6a3d024acb2d0a7ab1a5a217','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a5a008'),('6a3d024acb2d0a7ab1a5a218','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a59ffb'),('6a3d024acb2d0a7ab1a5a219','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a59ffe'),('6a3d024acb2d0a7ab1a5a21a','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a5a02a'),('6a3d024acb2d0a7ab1a5a21b','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a5a02d'),('6a3d024acb2d0a7ab1a5a21c','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a5a041'),('6a3d024acb2d0a7ab1a5a21d','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a5a042'),('6a3d024acb2d0a7ab1a5a21e','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a5a02f'),('6a3d024acb2d0a7ab1a5a21f','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a5a030'),('6a3d024acb2d0a7ab1a5a220','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a5a023'),('6a3d024acb2d0a7ab1a5a221','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a5a024'),('6a3d024acb2d0a7ab1a5a222','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a5a04d'),('6a3d024acb2d0a7ab1a5a223','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a5a04e'),('6a3d024acb2d0a7ab1a5a224','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a5a05d'),('6a3d024acb2d0a7ab1a5a225','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a5a05e'),('6a3d024acb2d0a7ab1a5a226','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a5a060'),('6a3d024acb2d0a7ab1a5a227','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a5a062'),('6a3d024acb2d0a7ab1a5a228','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a5a063'),('6a3d024acb2d0a7ab1a5a229','6a3d0243cb2d0a7ab1a59fd4','6a3d0246cb2d0a7ab1a5a06c'),('6a3d024acb2d0a7ab1a5a22a','6a3d0243cb2d0a7ab1a59fd5','6a3d0246cb2d0a7ab1a59fed'),('6a3d024acb2d0a7ab1a5a22b','6a3d0243cb2d0a7ab1a59fd5','6a3d0246cb2d0a7ab1a59fee'),('6a3d024acb2d0a7ab1a5a22c','6a3d0243cb2d0a7ab1a59fd5','6a3d0246cb2d0a7ab1a59fef'),('6a3d024acb2d0a7ab1a5a22d','6a3d0243cb2d0a7ab1a59fd5','6a3d0246cb2d0a7ab1a59ff0'),('6a3d024acb2d0a7ab1a5a22e','6a3d0243cb2d0a7ab1a59fd5','6a3d0246cb2d0a7ab1a59ff1'),('6a3d024acb2d0a7ab1a5a22f','6a3d0243cb2d0a7ab1a59fd5','6a3d0246cb2d0a7ab1a59ff2'),('6a3d024acb2d0a7ab1a5a230','6a3d0243cb2d0a7ab1a59fd5','6a3d0246cb2d0a7ab1a59ff3'),('6a3d024acb2d0a7ab1a5a231','6a3d0243cb2d0a7ab1a59fd5','6a3d0246cb2d0a7ab1a59ff5'),('6a3d024acb2d0a7ab1a5a232','6a3d0243cb2d0a7ab1a59fd5','6a3d0246cb2d0a7ab1a59ff6'),('6a3d024acb2d0a7ab1a5a233','6a3d0243cb2d0a7ab1a59fd5','6a3d0246cb2d0a7ab1a59ff7'),('6a3d024acb2d0a7ab1a5a234','6a3d0243cb2d0a7ab1a59fd5','6a3d0246cb2d0a7ab1a5a002'),('6a3d024acb2d0a7ab1a5a235','6a3d0243cb2d0a7ab1a59fd5','6a3d0246cb2d0a7ab1a5a003'),('6a3d024acb2d0a7ab1a5a236','6a3d0243cb2d0a7ab1a59fd5','6a3d0246cb2d0a7ab1a5a008'),('6a3d024acb2d0a7ab1a5a237','6a3d0243cb2d0a7ab1a59fd5','6a3d0246cb2d0a7ab1a59ffb'),('6a3d024acb2d0a7ab1a5a238','6a3d0243cb2d0a7ab1a59fd5','6a3d0246cb2d0a7ab1a5a02a'),('6a3d024acb2d0a7ab1a5a239','6a3d0243cb2d0a7ab1a59fd5','6a3d0246cb2d0a7ab1a5a02d'),('6a3d024acb2d0a7ab1a5a23a','6a3d0243cb2d0a7ab1a59fd5','6a3d0246cb2d0a7ab1a5a041'),('6a3d024acb2d0a7ab1a5a23b','6a3d0243cb2d0a7ab1a59fd5','6a3d0246cb2d0a7ab1a5a042'),('6a3d024acb2d0a7ab1a5a23c','6a3d0243cb2d0a7ab1a59fd5','6a3d0246cb2d0a7ab1a5a05d'),('6a3d024acb2d0a7ab1a5a23d','6a3d0243cb2d0a7ab1a59fd5','6a3d0246cb2d0a7ab1a5a05e'),('6a3d024acb2d0a7ab1a5a23e','6a3d0243cb2d0a7ab1a59fd5','6a3d0246cb2d0a7ab1a5a062'),('6a3d024acb2d0a7ab1a5a23f','6a3d0243cb2d0a7ab1a59fd5','6a3d0246cb2d0a7ab1a5a063');
/*!40000 ALTER TABLE `permissions_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions_users`
--

DROP TABLE IF EXISTS `permissions_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions_users` (
  `id` varchar(24) NOT NULL,
  `user_id` varchar(24) NOT NULL,
  `permission_id` varchar(24) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions_users`
--

LOCK TABLES `permissions_users` WRITE;
/*!40000 ALTER TABLE `permissions_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `permissions_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_gift_links`
--

DROP TABLE IF EXISTS `post_gift_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `post_gift_links` (
  `post_id` varchar(24) NOT NULL,
  `gift_link_token` varchar(32) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`gift_link_token`),
  UNIQUE KEY `post_gift_links_post_id_unique` (`post_id`),
  CONSTRAINT `post_gift_links_gift_link_token_foreign` FOREIGN KEY (`gift_link_token`) REFERENCES `gift_links` (`token`) ON DELETE CASCADE,
  CONSTRAINT `post_gift_links_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_gift_links`
--

LOCK TABLES `post_gift_links` WRITE;
/*!40000 ALTER TABLE `post_gift_links` DISABLE KEYS */;
/*!40000 ALTER TABLE `post_gift_links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_revisions`
--

DROP TABLE IF EXISTS `post_revisions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `post_revisions` (
  `id` varchar(24) NOT NULL,
  `post_id` varchar(24) NOT NULL,
  `lexical` longtext DEFAULT NULL,
  `created_at_ts` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL,
  `author_id` varchar(24) DEFAULT NULL,
  `title` varchar(2000) DEFAULT NULL,
  `post_status` varchar(50) DEFAULT NULL,
  `reason` varchar(50) DEFAULT NULL,
  `feature_image` varchar(2000) DEFAULT NULL,
  `feature_image_alt` varchar(2000) DEFAULT NULL,
  `feature_image_caption` text DEFAULT NULL,
  `custom_excerpt` varchar(2000) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `post_revisions_post_id_index` (`post_id`),
  KEY `post_revs_author_id_foreign` (`author_id`),
  CONSTRAINT `post_revs_author_id_foreign` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_revisions`
--

LOCK TABLES `post_revisions` WRITE;
/*!40000 ALTER TABLE `post_revisions` DISABLE KEYS */;
/*!40000 ALTER TABLE `post_revisions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `posts` (
  `id` varchar(24) NOT NULL,
  `uuid` varchar(36) NOT NULL,
  `title` varchar(2000) NOT NULL,
  `slug` varchar(191) NOT NULL,
  `mobiledoc` longtext DEFAULT NULL,
  `lexical` longtext DEFAULT NULL,
  `html` longtext DEFAULT NULL,
  `comment_id` varchar(50) DEFAULT NULL,
  `plaintext` longtext DEFAULT NULL,
  `feature_image` varchar(2000) DEFAULT NULL,
  `featured` tinyint(1) NOT NULL DEFAULT 0,
  `type` varchar(50) NOT NULL DEFAULT 'post',
  `status` varchar(50) NOT NULL DEFAULT 'draft',
  `locale` varchar(6) DEFAULT NULL,
  `visibility` varchar(50) NOT NULL DEFAULT 'public',
  `email_recipient_filter` text NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `published_by` varchar(24) DEFAULT NULL,
  `custom_excerpt` varchar(2000) DEFAULT NULL,
  `codeinjection_head` text DEFAULT NULL,
  `codeinjection_foot` text DEFAULT NULL,
  `custom_template` varchar(100) DEFAULT NULL,
  `canonical_url` text DEFAULT NULL,
  `newsletter_id` varchar(24) DEFAULT NULL,
  `show_title_and_feature_image` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `posts_slug_type_unique` (`slug`,`type`),
  KEY `posts_uuid_index` (`uuid`),
  KEY `posts_updated_at_index` (`updated_at`),
  KEY `posts_published_at_index` (`published_at`),
  KEY `posts_newsletter_id_foreign` (`newsletter_id`),
  KEY `posts_type_status_updated_at_index` (`type`,`status`,`updated_at`),
  CONSTRAINT `posts_newsletter_id_foreign` FOREIGN KEY (`newsletter_id`) REFERENCES `newsletters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
INSERT INTO `posts` VALUES ('6a3d0246cb2d0a7ab1a5a06e','fa8d0b46-2728-4ff2-ab72-511cd7a2f0ee','Coming soon','coming-soon','{\"version\":\"0.3.1\",\"atoms\":[],\"cards\":[],\"markups\":[[\"a\",[\"href\",\"#/portal/\",\"rel\",\"noopener noreferrer\"]]],\"sections\":[[1,\"p\",[[0,[],0,\"This is a brand new site that\'s just getting started. Things will be up and running here shortly, but you can \"],[0,[0],1,\"subscribe\"],[0,[],0,\" in the meantime if you\'d like to stay up to date and receive emails when new content is published!\"]]]],\"ghostVersion\":\"4.0\"}',NULL,'<p>This is a brand new site that\'s just getting started. Things will be up and running here shortly, but you can <a href=\"#/portal/\" rel=\"noopener noreferrer\">subscribe</a> in the meantime if you\'d like to stay up to date and receive emails when new content is published!</p>','6a3d0246cb2d0a7ab1a5a06e','This is a brand new site that\'s just getting started. Things will be up and running here shortly, but you can subscribe in the meantime if you\'d like to stay up to date and receive emails when new content is published!','https://static.ghost.org/v4.0.0/images/feature-image.jpg',0,'post','published',NULL,'public','all','2026-06-25 10:26:14','2026-06-25 10:26:14','2026-06-25 10:26:14','6a3d0243cb2d0a7ab1a59fd1',NULL,NULL,NULL,NULL,NULL,NULL,1),('6a3d0248cb2d0a7ab1a5a070','9e8ecc1a-bf7a-430d-acd5-2b82258b52b0','About this site','about','{\"version\":\"0.3.1\",\"atoms\":[],\"cards\":[[\"hr\",{}]],\"markups\":[[\"a\",[\"href\",\"https://ghost.org\"]]],\"sections\":[[1,\"p\",[[0,[],0,\"This is an independent publication. If you subscribe today, you\'ll get full access to the website as well as email newsletters about new content when it\'s available. Your subscription makes this site possible. Thank you!\"]]],[1,\"h3\",[[0,[],0,\"Access all areas\"]]],[1,\"p\",[[0,[],0,\"By signing up, you\'ll get access to the full archive of everything that\'s been published before and everything that\'s still to come. Your very own private library.\"]]],[1,\"h3\",[[0,[],0,\"Fresh content, delivered\"]]],[1,\"p\",[[0,[],0,\"Stay up to date with new content sent straight to your inbox! No more worrying about whether you missed something because of a pesky algorithm or news feed.\"]]],[1,\"h3\",[[0,[],0,\"Meet people like you\"]]],[1,\"p\",[[0,[],0,\"Join a community of other subscribers who share the same interests.\"]]],[10,0],[1,\"h3\",[[0,[],0,\"Start your own thing\"]]],[1,\"p\",[[0,[],0,\"Enjoying the experience? Get started for free and set up your very own subscription business using \"],[0,[0],1,\"Ghost\"],[0,[],0,\", the same platform that powers this website.\"]]]],\"ghostVersion\":\"4.0\"}',NULL,'<p>This is an independent publication. If you subscribe today, you\'ll get full access to the website as well as email newsletters about new content when it\'s available. Your subscription makes this site possible. Thank you!</p><h3 id=\"access-all-areas\">Access all areas</h3><p>By signing up, you\'ll get access to the full archive of everything that\'s been published before and everything that\'s still to come. Your very own private library.</p><h3 id=\"fresh-content-delivered\">Fresh content, delivered</h3><p>Stay up to date with new content sent straight to your inbox! No more worrying about whether you missed something because of a pesky algorithm or news feed.</p><h3 id=\"meet-people-like-you\">Meet people like you</h3><p>Join a community of other subscribers who share the same interests.</p><hr><h3 id=\"start-your-own-thing\">Start your own thing</h3><p>Enjoying the experience? Get started for free and set up your very own subscription business using <a href=\"https://ghost.org\">Ghost</a>, the same platform that powers this website.</p>','6a3d0248cb2d0a7ab1a5a070','This is an independent publication. If you subscribe today, you\'ll get full access to the website as well as email newsletters about new content when it\'s available. Your subscription makes this site possible. Thank you!\n\n\nAccess all areas\n\nBy signing up, you\'ll get access to the full archive of everything that\'s been published before and everything that\'s still to come. Your very own private library.\n\n\nFresh content, delivered\n\nStay up to date with new content sent straight to your inbox! No more worrying about whether you missed something because of a pesky algorithm or news feed.\n\n\nMeet people like you\n\nJoin a community of other subscribers who share the same interests.\n\n\nStart your own thing\n\nEnjoying the experience? Get started for free and set up your very own subscription business using Ghost, the same platform that powers this website.',NULL,0,'page','published',NULL,'public','all','2026-06-25 10:26:16','2026-06-25 10:26:16','2026-06-25 10:26:15','6a3d0243cb2d0a7ab1a59fd1',NULL,NULL,NULL,NULL,NULL,NULL,1);
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts_authors`
--

DROP TABLE IF EXISTS `posts_authors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `posts_authors` (
  `id` varchar(24) NOT NULL,
  `post_id` varchar(24) NOT NULL,
  `author_id` varchar(24) NOT NULL,
  `sort_order` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `posts_authors_post_id_foreign` (`post_id`),
  KEY `posts_authors_author_id_foreign` (`author_id`),
  CONSTRAINT `posts_authors_author_id_foreign` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`),
  CONSTRAINT `posts_authors_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts_authors`
--

LOCK TABLES `posts_authors` WRITE;
/*!40000 ALTER TABLE `posts_authors` DISABLE KEYS */;
INSERT INTO `posts_authors` VALUES ('6a3d0248cb2d0a7ab1a5a06f','6a3d0246cb2d0a7ab1a5a06e','6a3d0243cb2d0a7ab1a59fd1',0),('6a3d0248cb2d0a7ab1a5a071','6a3d0248cb2d0a7ab1a5a070','6a3d0243cb2d0a7ab1a59fd1',0);
/*!40000 ALTER TABLE `posts_authors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts_meta`
--

DROP TABLE IF EXISTS `posts_meta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `posts_meta` (
  `id` varchar(24) NOT NULL,
  `post_id` varchar(24) NOT NULL,
  `og_image` varchar(2000) DEFAULT NULL,
  `og_title` varchar(300) DEFAULT NULL,
  `og_description` varchar(500) DEFAULT NULL,
  `twitter_image` varchar(2000) DEFAULT NULL,
  `twitter_title` varchar(300) DEFAULT NULL,
  `twitter_description` varchar(500) DEFAULT NULL,
  `meta_title` varchar(2000) DEFAULT NULL,
  `meta_description` varchar(2000) DEFAULT NULL,
  `email_subject` varchar(300) DEFAULT NULL,
  `frontmatter` text DEFAULT NULL,
  `feature_image_alt` varchar(2000) DEFAULT NULL,
  `feature_image_caption` text DEFAULT NULL,
  `email_only` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `posts_meta_post_id_unique` (`post_id`),
  CONSTRAINT `posts_meta_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts_meta`
--

LOCK TABLES `posts_meta` WRITE;
/*!40000 ALTER TABLE `posts_meta` DISABLE KEYS */;
/*!40000 ALTER TABLE `posts_meta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts_products`
--

DROP TABLE IF EXISTS `posts_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `posts_products` (
  `id` varchar(24) NOT NULL,
  `post_id` varchar(24) NOT NULL,
  `product_id` varchar(24) NOT NULL,
  `sort_order` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `posts_products_post_id_foreign` (`post_id`),
  KEY `posts_products_product_id_foreign` (`product_id`),
  CONSTRAINT `posts_products_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `posts_products_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts_products`
--

LOCK TABLES `posts_products` WRITE;
/*!40000 ALTER TABLE `posts_products` DISABLE KEYS */;
/*!40000 ALTER TABLE `posts_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts_tags`
--

DROP TABLE IF EXISTS `posts_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `posts_tags` (
  `id` varchar(24) NOT NULL,
  `post_id` varchar(24) NOT NULL,
  `tag_id` varchar(24) NOT NULL,
  `sort_order` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `posts_tags_tag_id_foreign` (`tag_id`),
  KEY `posts_tags_post_id_tag_id_index` (`post_id`,`tag_id`),
  CONSTRAINT `posts_tags_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`),
  CONSTRAINT `posts_tags_tag_id_foreign` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts_tags`
--

LOCK TABLES `posts_tags` WRITE;
/*!40000 ALTER TABLE `posts_tags` DISABLE KEYS */;
INSERT INTO `posts_tags` VALUES ('6a3d024acb2d0a7ab1a5a240','6a3d0246cb2d0a7ab1a5a06e','6a3d0246cb2d0a7ab1a59fe4',0);
/*!40000 ALTER TABLE `posts_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` varchar(24) NOT NULL,
  `name` varchar(191) NOT NULL,
  `slug` varchar(191) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `welcome_page_url` varchar(2000) DEFAULT NULL,
  `visibility` varchar(50) NOT NULL DEFAULT 'none',
  `trial_days` int(10) unsigned NOT NULL DEFAULT 0,
  `description` varchar(191) DEFAULT NULL,
  `type` varchar(50) NOT NULL DEFAULT 'paid',
  `currency` varchar(50) DEFAULT NULL,
  `monthly_price` int(10) unsigned DEFAULT NULL,
  `yearly_price` int(10) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `monthly_price_id` varchar(24) DEFAULT NULL,
  `yearly_price_id` varchar(24) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `products_slug_unique` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES ('6a3d0246cb2d0a7ab1a59fe0','Free','free',1,NULL,'public',0,NULL,'free',NULL,NULL,NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14',NULL,NULL),('6a3d0246cb2d0a7ab1a59fe1','Default Product','default-product',1,NULL,'public',0,NULL,'paid','usd',500,5000,'2026-06-25 10:26:14','2026-06-25 10:26:14',NULL,NULL);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products_benefits`
--

DROP TABLE IF EXISTS `products_benefits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `products_benefits` (
  `id` varchar(24) NOT NULL,
  `product_id` varchar(24) NOT NULL,
  `benefit_id` varchar(24) NOT NULL,
  `sort_order` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `products_benefits_product_id_foreign` (`product_id`),
  KEY `products_benefits_benefit_id_foreign` (`benefit_id`),
  CONSTRAINT `products_benefits_benefit_id_foreign` FOREIGN KEY (`benefit_id`) REFERENCES `benefits` (`id`) ON DELETE CASCADE,
  CONSTRAINT `products_benefits_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products_benefits`
--

LOCK TABLES `products_benefits` WRITE;
/*!40000 ALTER TABLE `products_benefits` DISABLE KEYS */;
/*!40000 ALTER TABLE `products_benefits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recommendation_click_events`
--

DROP TABLE IF EXISTS `recommendation_click_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `recommendation_click_events` (
  `id` varchar(24) NOT NULL,
  `recommendation_id` varchar(24) NOT NULL,
  `member_id` varchar(24) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `recommendation_click_events_recommendation_id_foreign` (`recommendation_id`),
  KEY `recommendation_click_events_member_id_foreign` (`member_id`),
  CONSTRAINT `recommendation_click_events_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE SET NULL,
  CONSTRAINT `recommendation_click_events_recommendation_id_foreign` FOREIGN KEY (`recommendation_id`) REFERENCES `recommendations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recommendation_click_events`
--

LOCK TABLES `recommendation_click_events` WRITE;
/*!40000 ALTER TABLE `recommendation_click_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `recommendation_click_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recommendation_subscribe_events`
--

DROP TABLE IF EXISTS `recommendation_subscribe_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `recommendation_subscribe_events` (
  `id` varchar(24) NOT NULL,
  `recommendation_id` varchar(24) NOT NULL,
  `member_id` varchar(24) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `recommendation_subscribe_events_recommendation_id_foreign` (`recommendation_id`),
  KEY `recommendation_subscribe_events_member_id_foreign` (`member_id`),
  CONSTRAINT `recommendation_subscribe_events_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE SET NULL,
  CONSTRAINT `recommendation_subscribe_events_recommendation_id_foreign` FOREIGN KEY (`recommendation_id`) REFERENCES `recommendations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recommendation_subscribe_events`
--

LOCK TABLES `recommendation_subscribe_events` WRITE;
/*!40000 ALTER TABLE `recommendation_subscribe_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `recommendation_subscribe_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recommendations`
--

DROP TABLE IF EXISTS `recommendations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `recommendations` (
  `id` varchar(24) NOT NULL,
  `url` varchar(2000) NOT NULL,
  `title` varchar(2000) NOT NULL,
  `excerpt` varchar(2000) DEFAULT NULL,
  `featured_image` varchar(2000) DEFAULT NULL,
  `favicon` varchar(2000) DEFAULT NULL,
  `description` varchar(2000) DEFAULT NULL,
  `one_click_subscribe` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recommendations`
--

LOCK TABLES `recommendations` WRITE;
/*!40000 ALTER TABLE `recommendations` DISABLE KEYS */;
/*!40000 ALTER TABLE `recommendations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `redirects`
--

DROP TABLE IF EXISTS `redirects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `redirects` (
  `id` varchar(24) NOT NULL,
  `from` varchar(191) NOT NULL,
  `to` varchar(2000) NOT NULL,
  `post_id` varchar(24) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `redirects_from_index` (`from`),
  KEY `redirects_post_id_foreign` (`post_id`),
  CONSTRAINT `redirects_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `redirects`
--

LOCK TABLES `redirects` WRITE;
/*!40000 ALTER TABLE `redirects` DISABLE KEYS */;
/*!40000 ALTER TABLE `redirects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` varchar(24) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(2000) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roles_name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES ('6a3d0243cb2d0a7ab1a59fd2','Administrator','Administrators','2026-06-25 10:26:11','2026-06-25 10:26:11'),('6a3d0243cb2d0a7ab1a59fd3','Editor','Editors','2026-06-25 10:26:11','2026-06-25 10:26:11'),('6a3d0243cb2d0a7ab1a59fd4','Author','Authors','2026-06-25 10:26:11','2026-06-25 10:26:11'),('6a3d0243cb2d0a7ab1a59fd5','Contributor','Contributors','2026-06-25 10:26:11','2026-06-25 10:26:11'),('6a3d0243cb2d0a7ab1a59fd6','Owner','Blog Owner','2026-06-25 10:26:11','2026-06-25 10:26:11'),('6a3d0244cb2d0a7ab1a59fd7','Admin Integration','External Apps','2026-06-25 10:26:12','2026-06-25 10:26:12'),('6a3d0244cb2d0a7ab1a59fd8','Ghost Explore Integration','Internal Integration for the Ghost Explore directory','2026-06-25 10:26:12','2026-06-25 10:26:12'),('6a3d0244cb2d0a7ab1a59fd9','Self-Serve Migration Integration','Internal Integration for the Self-Serve migration tool','2026-06-25 10:26:12','2026-06-25 10:26:12'),('6a3d0244cb2d0a7ab1a59fda','DB Backup Integration','Internal DB Backup Client','2026-06-25 10:26:12','2026-06-25 10:26:12'),('6a3d0244cb2d0a7ab1a59fdb','Scheduler Integration','Internal Scheduler Client','2026-06-25 10:26:12','2026-06-25 10:26:12'),('6a3d0244cb2d0a7ab1a59fdc','Super Editor','Super Editors','2026-06-25 10:26:12','2026-06-25 10:26:12');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles_users`
--

DROP TABLE IF EXISTS `roles_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles_users` (
  `id` varchar(24) NOT NULL,
  `role_id` varchar(24) NOT NULL,
  `user_id` varchar(24) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles_users`
--

LOCK TABLES `roles_users` WRITE;
/*!40000 ALTER TABLE `roles_users` DISABLE KEYS */;
INSERT INTO `roles_users` VALUES ('6a3d0246cb2d0a7ab1a59fdd','6a3d0243cb2d0a7ab1a59fd6','6a3d0243cb2d0a7ab1a59fd1');
/*!40000 ALTER TABLE `roles_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(24) NOT NULL,
  `session_id` varchar(32) NOT NULL,
  `user_id` varchar(24) NOT NULL,
  `session_data` varchar(2000) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sessions_session_id_unique` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `settings` (
  `id` varchar(24) NOT NULL,
  `group` varchar(50) NOT NULL DEFAULT 'core',
  `key` varchar(50) NOT NULL,
  `value` text DEFAULT NULL,
  `type` varchar(50) NOT NULL,
  `flags` varchar(50) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `settings_key_unique` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` VALUES ('6a3d024bcb2d0a7ab1a5a241','core','last_mentions_report_email_timestamp',NULL,'number',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a242','core','db_hash','482a574d-5e15-4f0f-8181-d09db18af498','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a243','core','routes_hash','3d180d52c663d173a6be791ef411ed01','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:24'),('6a3d024bcb2d0a7ab1a5a244','core','next_update_check',NULL,'number',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a245','core','notifications','[]','array',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a246','core','version_notifications','[]','array',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a247','core','admin_session_secret','0fb9c7eb8036e2cca4205738c6998b93eec165aa465ffb4aa074f324199c26eb','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a248','core','theme_session_secret','bab1fbf1ae6e4a031f8a0c1e7beac532f16bc64d40b2060e4d02a23d1b3227a8','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a249','core','ghost_public_key','-----BEGIN RSA PUBLIC KEY-----\nMIGJAoGBAKuCEO9Fh6nFqJGs1UkRPgpPHNiB8BfzxzLMUOW74P0iUpWYvNIKKmhyFkL6cZCR\nB45WIV2EuKVvtZzYpf18+DuWof6iPDDofqX8haLiBNQ9a6gC7mdThj7UsFyZjDrub87teH6D\nS5sNoygEMFgCYB9s2DiUzvKtY8jB1heBQPGfAgMBAAE=\n-----END RSA PUBLIC KEY-----\n','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a24a','core','ghost_private_key','-----BEGIN RSA PRIVATE KEY-----\nMIICXAIBAAKBgQCrghDvRYepxaiRrNVJET4KTxzYgfAX88cyzFDlu+D9IlKVmLzSCipochZC\n+nGQkQeOViFdhLilb7Wc2KX9fPg7lqH+ojww6H6l/IWi4gTUPWuoAu5nU4Y+1LBcmYw67m/O\n7Xh+g0ubDaMoBDBYAmAfbNg4lM7yrWPIwdYXgUDxnwIDAQABAoGAQkmpJfGnt5RvzK4SWYVS\nh0WAjqXaGEfea+HQOprdILlNVgiMolnPfkLqG8UUc526X+cmSjDr9PUyKocJ0OmmPy5Do4c5\nUp12P9OacKws8rX9PV5GIVWL0avG60AbKInZbgo95KnxM7775jzwEtkDFUBg2eh8L9+f5MC9\neYsiFNECQQDwJaarmpY1aotf+/nof1APciYxHI1FlBbW2SHL5zmtmgJwU6+AjXCa6bgrgvQM\nuMVDsdnCzX7fyUTMZes2Y40VAkEAttR0ebmzNc8FwMHPO2ZwkDYSgrCvlv/4QInNhTyeE8KT\nwPWuu18WDRiWliw6+frj//l+hXUWn0wqU7r6qbV44wJAdSL4ZFX4FMAOkdgXszd+drpINMZn\nhlvQtCWfXZVAxhQMQnwfbAYRug5svhSXNClgVz/GJ0YTL9c9zrGcBKCUbQJBAAt+X7QnUHTZ\nhusPRA/f6MOoIpHEucUsYlbsUtdFcEqduNwwlcOBvskj+pOGRE7izuKQtLt/GOT6zM5mustg\ndTECQHeoFEe6Udt1Jcy1ESSPUhomF358peurYYBBLFMWsXrclSMAcOtpchWrfSYJWEdWrWRV\n+iV4ia6+DhHZTjeArqw=\n-----END RSA PRIVATE KEY-----\n','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a24b','core','members_public_key','-----BEGIN RSA PUBLIC KEY-----\nMIGJAoGBAItgrrZPyoj67U06otQ8pf0pZTrIpv2WafC8hzSZ5xqTz6qgYFEOODc1+UQ+lqZ1\nQr5XGXdbz+nJyLPrlURHw79vFALV76V8Mz+QRqmTgFP35QTErASNOP5hOUoMvw3t+eOs5tF3\nEqRtj5yp73480My1pElK2+x/r0QsLNflRgMlAgMBAAE=\n-----END RSA PUBLIC KEY-----\n','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a24c','core','members_private_key','-----BEGIN RSA PRIVATE KEY-----\nMIICWwIBAAKBgQCLYK62T8qI+u1NOqLUPKX9KWU6yKb9lmnwvIc0mecak8+qoGBRDjg3NflE\nPpamdUK+Vxl3W8/pyciz65VER8O/bxQC1e+lfDM/kEapk4BT9+UExKwEjTj+YTlKDL8N7fnj\nrObRdxKkbY+cqe9+PNDMtaRJStvsf69ELCzX5UYDJQIDAQABAoGAe/LNLOCks1DDvEyLBcex\nrgQkPDS5HQeoyyg97S948I/GvGzHew30PFVJicFHZF0fr/nxcc46hiSm0iqNoh1YHBMm3swL\nJdxlnkBMzt74mBhje9E6h8IcqBeB6VGUWSKyBmYHXCPyrtkDnQfhuMWO6irFuuEuBCdksRv8\njgXeagECQQDO2zSlxHZ1SD8LLxmrhx9gt5e/pQVPy0vSkJycA+ofHNJKNOST7r9+KTRfZHpu\nBR2hpXoF16pgKErhT1BDAWpBAkEArH1+nFrKEsDkrlUWFBfr5DI/cwntRaY6LWtLQQoWHdxe\nfXjtp5M9Mrdr2e0qV2bccc85OE9NNlZ85UmOr6435QJAGvR9m8xKE2ZisLZmhe+JqzTBVXvP\ngWJgcwPdJIduDrfWv0y9LHnEAlCkPnn9ajDId7P0fqZn0Tfu6gVH1DNvAQJAEKpfXUP4Wi+A\n6McXxwE4rWedccP3xM72uASx1Krg0CnGh2DztUkolIncRcYAXUl26xgWczZWQ3W/w3eD7b1r\ncQJAFwaHFbQkMB3B8CzVG45myh7w9P+znMGhWzr6nyoHw4LbhR/s0IwrTqjfAhLPvV3yAadD\nnknb+sm+YWa/9/QmyA==\n-----END RSA PRIVATE KEY-----\n','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a24d','core','members_email_auth_secret','51dcee498cfe014e67c7e791052d55ffca42c77e0302699344b7deeb58a156ebe6e06f61aa65f4372f3f9633a88397fd863b3320f36a045305689b7f872a7c1d','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a24e','core','members_stripe_webhook_id',NULL,'string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a24f','core','members_stripe_webhook_secret',NULL,'string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a250','core','members_otc_secret','997d00bffe85f5e0bea34cb8cf0978d4b0ebe649145136650d2f63e71b9cbdf95e6d0f717f53aea6263133a6ca656ac20bcf3e09f03bf61fc0b1ced856954520','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a251','core','site_uuid','2f43c552-5420-4290-8856-6a82212cf90c','string','PUBLIC,RO','2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a252','site','title','Ghost','string','PUBLIC','2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a253','site','description','Thoughts, stories and ideas','string','PUBLIC','2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a254','site','heading_font','','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a255','site','body_font','','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a256','site','logo','','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a257','site','cover_image','https://static.ghost.org/v5.0.0/images/publication-cover.jpg','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a258','site','icon','','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a259','site','accent_color','#FF1A75','string','PUBLIC','2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a25a','site','locale','en','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a25b','site','timezone','Etc/UTC','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a25c','site','codeinjection_head','','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a25d','site','codeinjection_foot','','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a25e','site','facebook','ghost','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a25f','site','twitter','@ghost','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a260','site','threads',NULL,'string','PUBLIC','2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a261','site','bluesky',NULL,'string','PUBLIC','2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a262','site','mastodon',NULL,'string','PUBLIC','2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a263','site','tiktok',NULL,'string','PUBLIC','2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a264','site','youtube',NULL,'string','PUBLIC','2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a265','site','instagram',NULL,'string','PUBLIC','2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a266','site','linkedin',NULL,'string','PUBLIC','2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a267','site','navigation','[{\"label\":\"Home\",\"url\":\"/\"},{\"label\":\"About\",\"url\":\"/about/\"}]','array',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a268','site','secondary_navigation','[{\"label\":\"Sign up\",\"url\":\"#/portal/\"}]','array',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a269','site','llms_enabled','true','boolean',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a26a','site','meta_title',NULL,'string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a26b','site','meta_description',NULL,'string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a26c','site','og_image',NULL,'string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a26d','site','og_title',NULL,'string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a26e','site','og_description',NULL,'string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a26f','site','twitter_image',NULL,'string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a270','site','twitter_title',NULL,'string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a271','site','twitter_description',NULL,'string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a272','theme','active_theme','source','string','RO','2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a273','private','is_private','false','boolean',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a274','private','password','','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a275','private','public_hash','fce6feb904f04bb836d1ceac75e349','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a276','members','default_content_visibility','public','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a277','members','default_content_visibility_tiers','[]','array',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a278','members','members_signup_access','all','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a279','members','members_support_address','noreply','string','PUBLIC,RO','2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a27a','members','stripe_billing_portal_configuration_id',NULL,'string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a27b','members','stripe_secret_key',NULL,'string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a27c','members','stripe_publishable_key',NULL,'string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a27d','members','stripe_plans','[]','array',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a27e','members','stripe_connect_publishable_key',NULL,'string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a27f','members','stripe_connect_secret_key',NULL,'string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a280','members','stripe_connect_livemode',NULL,'boolean',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a281','members','stripe_connect_display_name',NULL,'string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a282','members','stripe_connect_account_id',NULL,'string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a283','members','members_monthly_price_id',NULL,'string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a284','members','members_yearly_price_id',NULL,'string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a285','members','members_track_sources','true','boolean',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a286','members','blocked_email_domains','[]','array',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a287','portal','portal_name','true','boolean',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a288','portal','portal_button','false','boolean',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a289','portal','portal_plans','[\"free\"]','array',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a28a','portal','portal_default_plan','yearly','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a28b','portal','portal_products','[]','array',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a28c','portal','portal_button_style','icon-and-text','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a28d','portal','portal_button_icon',NULL,'string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a28e','portal','portal_button_signup_text','Subscribe','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a28f','portal','portal_signup_terms_html',NULL,'string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a290','portal','portal_signup_checkbox_required','false','boolean',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a291','email','mailgun_domain',NULL,'string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a292','email','mailgun_api_key',NULL,'string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a293','email','mailgun_base_url',NULL,'string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a294','email','email_track_opens','true','boolean',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a295','email','email_track_clicks','true','boolean',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a296','email','email_verification_required','false','boolean','RO','2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a297','firstpromoter','firstpromoter','false','boolean',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a298','firstpromoter','firstpromoter_id',NULL,'string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a299','labs','labs','{}','object',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a29a','slack','slack_url','','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a29b','slack','slack_username','Ghost','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a29c','unsplash','unsplash','true','boolean',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a29d','transistor','transistor','false','boolean',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a29e','transistor','transistor_portal_enabled','true','boolean','PUBLIC','2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a29f','transistor','transistor_portal_heading','Podcasts','string','PUBLIC','2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a2a0','transistor','transistor_portal_description','Access your private podcast feed','string','PUBLIC','2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a2a1','transistor','transistor_portal_button_text','View','string','PUBLIC','2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a2a2','transistor','transistor_portal_url_template','https://partner.transistor.fm/ghost/{memberUuid}','string','PUBLIC','2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a2a3','views','shared_views','[]','array',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a2a4','editor','editor_default_email_recipients','visibility','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a2a5','editor','editor_default_email_recipients_filter','all','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a2a6','announcement','announcement_content',NULL,'string','PUBLIC','2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a2a7','announcement','announcement_visibility','[]','array',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a2a8','announcement','announcement_background','dark','string','PUBLIC','2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a2a9','comments','comments_enabled','all','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a2aa','analytics','outbound_link_tagging','true','boolean',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a2ab','analytics','web_analytics','true','boolean',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a2ac','pintura','pintura','true','boolean',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a2ad','pintura','pintura_js_url',NULL,'string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a2ae','pintura','pintura_css_url',NULL,'string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a2af','donations','donations_currency','USD','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a2b0','donations','donations_suggested_amount','500','number',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a2b1','recommendations','recommendations_enabled','false','boolean',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a2b2','security','require_email_mfa','0','boolean',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a2b3','social_web','social_web','true','boolean',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a2b4','explore','explore_ping','true','boolean',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a2b5','explore','explore_ping_growth','false','boolean',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19'),('6a3d024bcb2d0a7ab1a5a2b6','indexnow','indexnow_api_key','1e6a0735d6094fe8e7ab52257855bb86','string',NULL,'2026-06-25 10:26:19','2026-06-25 10:26:19');
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `snippets`
--

DROP TABLE IF EXISTS `snippets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `snippets` (
  `id` varchar(24) NOT NULL,
  `name` varchar(191) NOT NULL,
  `mobiledoc` longtext NOT NULL,
  `lexical` longtext DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `snippets_name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `snippets`
--

LOCK TABLES `snippets` WRITE;
/*!40000 ALTER TABLE `snippets` DISABLE KEYS */;
/*!40000 ALTER TABLE `snippets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stripe_prices`
--

DROP TABLE IF EXISTS `stripe_prices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `stripe_prices` (
  `id` varchar(24) NOT NULL,
  `stripe_price_id` varchar(255) NOT NULL,
  `stripe_product_id` varchar(255) NOT NULL,
  `active` tinyint(1) NOT NULL,
  `nickname` varchar(255) DEFAULT NULL,
  `currency` varchar(191) NOT NULL,
  `amount` int(11) NOT NULL,
  `type` varchar(50) NOT NULL DEFAULT 'recurring',
  `interval` varchar(50) DEFAULT NULL,
  `description` varchar(191) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `stripe_prices_stripe_price_id_unique` (`stripe_price_id`),
  KEY `stripe_prices_stripe_product_id_foreign` (`stripe_product_id`),
  CONSTRAINT `stripe_prices_stripe_product_id_foreign` FOREIGN KEY (`stripe_product_id`) REFERENCES `stripe_products` (`stripe_product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stripe_prices`
--

LOCK TABLES `stripe_prices` WRITE;
/*!40000 ALTER TABLE `stripe_prices` DISABLE KEYS */;
/*!40000 ALTER TABLE `stripe_prices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stripe_products`
--

DROP TABLE IF EXISTS `stripe_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `stripe_products` (
  `id` varchar(24) NOT NULL,
  `product_id` varchar(24) DEFAULT NULL,
  `stripe_product_id` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `stripe_products_stripe_product_id_unique` (`stripe_product_id`),
  KEY `stripe_products_product_id_foreign` (`product_id`),
  CONSTRAINT `stripe_products_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stripe_products`
--

LOCK TABLES `stripe_products` WRITE;
/*!40000 ALTER TABLE `stripe_products` DISABLE KEYS */;
/*!40000 ALTER TABLE `stripe_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscriptions`
--

DROP TABLE IF EXISTS `subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `subscriptions` (
  `id` varchar(24) NOT NULL,
  `type` varchar(50) NOT NULL,
  `status` varchar(50) NOT NULL,
  `member_id` varchar(24) NOT NULL,
  `tier_id` varchar(24) NOT NULL,
  `cadence` varchar(50) DEFAULT NULL,
  `currency` varchar(50) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `payment_provider` varchar(50) DEFAULT NULL,
  `payment_subscription_url` varchar(2000) DEFAULT NULL,
  `payment_user_url` varchar(2000) DEFAULT NULL,
  `offer_id` varchar(24) DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `subscriptions_member_id_foreign` (`member_id`),
  KEY `subscriptions_tier_id_foreign` (`tier_id`),
  KEY `subscriptions_offer_id_foreign` (`offer_id`),
  CONSTRAINT `subscriptions_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  CONSTRAINT `subscriptions_offer_id_foreign` FOREIGN KEY (`offer_id`) REFERENCES `offers` (`id`),
  CONSTRAINT `subscriptions_tier_id_foreign` FOREIGN KEY (`tier_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subscriptions`
--

LOCK TABLES `subscriptions` WRITE;
/*!40000 ALTER TABLE `subscriptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `subscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suppressions`
--

DROP TABLE IF EXISTS `suppressions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `suppressions` (
  `id` varchar(24) NOT NULL,
  `email` varchar(191) NOT NULL,
  `email_id` varchar(24) DEFAULT NULL,
  `reason` varchar(50) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `suppressions_email_unique` (`email`),
  KEY `suppressions_email_id_foreign` (`email_id`),
  CONSTRAINT `suppressions_email_id_foreign` FOREIGN KEY (`email_id`) REFERENCES `emails` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppressions`
--

LOCK TABLES `suppressions` WRITE;
/*!40000 ALTER TABLE `suppressions` DISABLE KEYS */;
/*!40000 ALTER TABLE `suppressions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tags` (
  `id` varchar(24) NOT NULL,
  `name` varchar(191) NOT NULL,
  `slug` varchar(191) NOT NULL,
  `description` text DEFAULT NULL,
  `feature_image` varchar(2000) DEFAULT NULL,
  `parent_id` varchar(191) DEFAULT NULL,
  `visibility` varchar(50) NOT NULL DEFAULT 'public',
  `og_image` varchar(2000) DEFAULT NULL,
  `og_title` varchar(300) DEFAULT NULL,
  `og_description` varchar(500) DEFAULT NULL,
  `twitter_image` varchar(2000) DEFAULT NULL,
  `twitter_title` varchar(300) DEFAULT NULL,
  `twitter_description` varchar(500) DEFAULT NULL,
  `meta_title` varchar(2000) DEFAULT NULL,
  `meta_description` varchar(2000) DEFAULT NULL,
  `codeinjection_head` text DEFAULT NULL,
  `codeinjection_foot` text DEFAULT NULL,
  `canonical_url` varchar(2000) DEFAULT NULL,
  `accent_color` varchar(50) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tags_slug_unique` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tags`
--

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
INSERT INTO `tags` VALUES ('6a3d0246cb2d0a7ab1a59fe4','News','news',NULL,NULL,NULL,'public',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-25 10:26:14','2026-06-25 10:26:14');
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tokens`
--

DROP TABLE IF EXISTS `tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tokens` (
  `id` varchar(24) NOT NULL,
  `token` varchar(32) NOT NULL,
  `uuid` varchar(36) NOT NULL,
  `data` varchar(2000) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `first_used_at` datetime DEFAULT NULL,
  `used_count` int(10) unsigned NOT NULL DEFAULT 0,
  `otc_used_count` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tokens_uuid_unique` (`uuid`),
  KEY `tokens_token_index` (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tokens`
--

LOCK TABLES `tokens` WRITE;
/*!40000 ALTER TABLE `tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` varchar(24) NOT NULL,
  `name` varchar(191) NOT NULL,
  `slug` varchar(191) NOT NULL,
  `password` varchar(60) NOT NULL,
  `email` varchar(191) NOT NULL,
  `profile_image` varchar(2000) DEFAULT NULL,
  `cover_image` varchar(2000) DEFAULT NULL,
  `bio` text DEFAULT NULL,
  `website` varchar(2000) DEFAULT NULL,
  `location` text DEFAULT NULL,
  `facebook` varchar(2000) DEFAULT NULL,
  `twitter` varchar(2000) DEFAULT NULL,
  `threads` varchar(191) DEFAULT NULL,
  `bluesky` varchar(191) DEFAULT NULL,
  `mastodon` varchar(191) DEFAULT NULL,
  `tiktok` varchar(191) DEFAULT NULL,
  `youtube` varchar(191) DEFAULT NULL,
  `instagram` varchar(191) DEFAULT NULL,
  `linkedin` varchar(191) DEFAULT NULL,
  `accessibility` text DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'active',
  `locale` varchar(6) DEFAULT NULL,
  `visibility` varchar(50) NOT NULL DEFAULT 'public',
  `meta_title` varchar(2000) DEFAULT NULL,
  `meta_description` varchar(2000) DEFAULT NULL,
  `tour` text DEFAULT NULL,
  `last_seen` datetime DEFAULT NULL,
  `comment_notifications` tinyint(1) NOT NULL DEFAULT 1,
  `free_member_signup_notification` tinyint(1) NOT NULL DEFAULT 1,
  `paid_subscription_started_notification` tinyint(1) NOT NULL DEFAULT 1,
  `paid_subscription_canceled_notification` tinyint(1) NOT NULL DEFAULT 0,
  `mention_notifications` tinyint(1) NOT NULL DEFAULT 1,
  `recommendation_notifications` tinyint(1) NOT NULL DEFAULT 1,
  `milestone_notifications` tinyint(1) NOT NULL DEFAULT 1,
  `donation_notifications` tinyint(1) NOT NULL DEFAULT 1,
  `gift_subscription_notifications` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_slug_unique` (`slug`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('6a3d0243cb2d0a7ab1a59fd1','Ghost','ghost-user','$2b$10$vHJ/Mv3uTbmcCFExRsDnquYgTsiwa.G1zBone4ZS/0ZQ8IbB.yaMe','ghost@example.com',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'inactive',NULL,'public',NULL,NULL,NULL,NULL,1,1,1,0,1,1,1,1,1,'2026-06-25 10:26:12','2026-06-25 10:26:12');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `webhooks`
--

DROP TABLE IF EXISTS `webhooks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `webhooks` (
  `id` varchar(24) NOT NULL,
  `event` varchar(50) NOT NULL,
  `target_url` varchar(2000) NOT NULL,
  `name` varchar(191) DEFAULT NULL,
  `secret` varchar(191) DEFAULT NULL,
  `api_version` varchar(50) NOT NULL DEFAULT 'v2',
  `integration_id` varchar(24) NOT NULL,
  `last_triggered_at` datetime DEFAULT NULL,
  `last_triggered_status` varchar(50) DEFAULT NULL,
  `last_triggered_error` varchar(50) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `webhooks_integration_id_foreign` (`integration_id`),
  CONSTRAINT `webhooks_integration_id_foreign` FOREIGN KEY (`integration_id`) REFERENCES `integrations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webhooks`
--

LOCK TABLES `webhooks` WRITE;
/*!40000 ALTER TABLE `webhooks` DISABLE KEYS */;
/*!40000 ALTER TABLE `webhooks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `welcome_email_automated_emails`
--

DROP TABLE IF EXISTS `welcome_email_automated_emails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `welcome_email_automated_emails` (
  `id` varchar(24) NOT NULL,
  `welcome_email_automation_id` varchar(24) NOT NULL,
  `next_welcome_email_automated_email_id` varchar(24) DEFAULT NULL,
  `delay_days` int(10) unsigned NOT NULL,
  `subject` varchar(300) NOT NULL,
  `lexical` longtext DEFAULT NULL,
  `sender_name` varchar(191) DEFAULT NULL,
  `sender_email` varchar(191) DEFAULT NULL,
  `sender_reply_to` varchar(191) DEFAULT NULL,
  `email_design_setting_id` varchar(24) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `weae_automation_id_foreign` (`welcome_email_automation_id`),
  KEY `weae_next_email_id_foreign` (`next_welcome_email_automated_email_id`),
  KEY `welcome_email_automated_emails_email_design_setting_id_foreign` (`email_design_setting_id`),
  CONSTRAINT `weae_automation_id_foreign` FOREIGN KEY (`welcome_email_automation_id`) REFERENCES `automations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `weae_next_email_id_foreign` FOREIGN KEY (`next_welcome_email_automated_email_id`) REFERENCES `welcome_email_automated_emails` (`id`),
  CONSTRAINT `welcome_email_automated_emails_email_design_setting_id_foreign` FOREIGN KEY (`email_design_setting_id`) REFERENCES `email_design_settings` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `welcome_email_automated_emails`
--

LOCK TABLES `welcome_email_automated_emails` WRITE;
/*!40000 ALTER TABLE `welcome_email_automated_emails` DISABLE KEYS */;
/*!40000 ALTER TABLE `welcome_email_automated_emails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `welcome_email_automation_runs`
--

DROP TABLE IF EXISTS `welcome_email_automation_runs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `welcome_email_automation_runs` (
  `id` varchar(24) NOT NULL,
  `welcome_email_automation_id` varchar(24) NOT NULL,
  `member_id` varchar(24) NOT NULL,
  `next_welcome_email_automated_email_id` varchar(24) DEFAULT NULL,
  `ready_at` datetime DEFAULT NULL,
  `step_started_at` datetime DEFAULT NULL,
  `step_attempts` int(10) unsigned NOT NULL DEFAULT 0,
  `exit_reason` varchar(50) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `wear_automation_id_foreign` (`welcome_email_automation_id`),
  KEY `wear_member_id_foreign` (`member_id`),
  KEY `wear_next_email_id_foreign` (`next_welcome_email_automated_email_id`),
  KEY `welcome_email_automation_runs_ready_at_index` (`ready_at`),
  CONSTRAINT `wear_automation_id_foreign` FOREIGN KEY (`welcome_email_automation_id`) REFERENCES `automations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `wear_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  CONSTRAINT `wear_next_email_id_foreign` FOREIGN KEY (`next_welcome_email_automated_email_id`) REFERENCES `welcome_email_automated_emails` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `welcome_email_automation_runs`
--

LOCK TABLES `welcome_email_automation_runs` WRITE;
/*!40000 ALTER TABLE `welcome_email_automation_runs` DISABLE KEYS */;
/*!40000 ALTER TABLE `welcome_email_automation_runs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `members_resolved_subscription`
--

/*!50001 DROP VIEW IF EXISTS `members_resolved_subscription`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`ghost-52`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `members_resolved_subscription` AS select `ranked`.`member_id` AS `member_id`,`ranked`.`subscription_id` AS `subscription_id` from (select `msc`.`member_id` AS `member_id`,`mscs`.`id` AS `subscription_id`,row_number() over ( partition by `msc`.`member_id` order by case when `mscs`.`status` in ('active','trialing','past_due','unpaid') then 0 else 1 end,`mscs`.`created_at` desc,`mscs`.`id`) AS `rn` from (`members_stripe_customers_subscriptions` `mscs` join `members_stripe_customers` `msc` on(`msc`.`customer_id` = `mscs`.`customer_id`)) where `mscs`.`status` not in ('incomplete','incomplete_expired')) `ranked` where `ranked`.`rn` = 1 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-25 12:14:52
