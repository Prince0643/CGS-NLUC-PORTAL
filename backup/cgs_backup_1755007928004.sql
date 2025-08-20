-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: cgs
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

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
-- Table structure for table `announcements`
--

DROP TABLE IF EXISTS `announcements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `announcements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `announcements_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `announcements`
--

LOCK TABLES `announcements` WRITE;
/*!40000 ALTER TABLE `announcements` DISABLE KEYS */;
INSERT INTO `announcements` VALUES (1,'adsafsa','dsadsadsa',6,'2025-08-07 15:03:15'),(2,'ssss','sssss',6,'2025-08-12 13:53:24');
/*!40000 ALTER TABLE `announcements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chatbot_responses`
--

DROP TABLE IF EXISTS `chatbot_responses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chatbot_responses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `keyword` varchar(100) NOT NULL,
  `response` text NOT NULL,
  `category` varchar(50) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chatbot_responses`
--

LOCK TABLES `chatbot_responses` WRITE;
/*!40000 ALTER TABLE `chatbot_responses` DISABLE KEYS */;
INSERT INTO `chatbot_responses` VALUES (1,'grade','You can find your grade in the office.',NULL,1,'2025-06-26 17:04:04','2025-06-26 17:04:04'),(3,'thank','You\'re welcome!',NULL,1,'2025-06-26 17:10:11','2025-06-26 17:10:11'),(4,'subject','You can view your subjects in the \"Subject\" tab.',NULL,1,'2025-06-26 17:11:01','2025-06-26 17:11:01');
/*!40000 ALTER TABLE `chatbot_responses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_faculty`
--

DROP TABLE IF EXISTS `course_faculty`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_faculty` (
  `course_id` int(11) NOT NULL,
  `faculty_id` int(11) NOT NULL,
  PRIMARY KEY (`course_id`,`faculty_id`),
  KEY `faculty_id` (`faculty_id`),
  CONSTRAINT `course_faculty_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`),
  CONSTRAINT `course_faculty_ibfk_2` FOREIGN KEY (`faculty_id`) REFERENCES `faculty` (`faculty_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_faculty`
--

LOCK TABLES `course_faculty` WRITE;
/*!40000 ALTER TABLE `course_faculty` DISABLE KEYS */;
INSERT INTO `course_faculty` VALUES (1,1),(2,2),(3,3),(4,4),(5,5),(6,3),(7,4),(8,6),(9,3),(10,7),(11,8),(12,3),(13,9),(14,1),(14,9),(15,3),(16,10),(17,5),(18,3),(19,6),(20,6),(21,3),(22,11),(23,12),(24,3),(25,13),(26,14),(27,3),(28,15),(29,16),(30,3),(31,17),(32,17),(33,3),(34,18),(35,19),(36,3),(37,3);
/*!40000 ALTER TABLE `course_faculty` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `courses` (
  `course_id` int(11) NOT NULL AUTO_INCREMENT,
  `course_code` varchar(50) NOT NULL,
  `program_id` int(11) NOT NULL,
  `course_description` text NOT NULL,
  `units` int(11) NOT NULL,
  `offered` enum('offered','not offered') NOT NULL DEFAULT 'offered',
  PRIMARY KEY (`course_id`),
  UNIQUE KEY `course_code` (`course_code`),
  KEY `program_id` (`program_id`),
  CONSTRAINT `courses_ibfk_1` FOREIGN KEY (`program_id`) REFERENCES `programs` (`program_id`)
) ENGINE=InnoDB AUTO_INCREMENT=306 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
INSERT INTO `courses` VALUES (1,'PHEA 301',1,'Philosophical and Critical Perspectives in Educational Administration',3,'offered'),(2,'PHEA 311',1,'Administrative Reforms and Innovations in Education',3,'offered'),(3,'PHEA 314',1,'Dissertation Writing',6,'offered'),(4,'PHAG 313',2,'Program Planning and Project Development',3,'offered'),(5,'PHAG 309',2,'Advanced Seed Production and Processing',3,'offered'),(6,'PHAG 314',2,'Dissertation Writing',6,'offered'),(7,'PHAS 310',3,'Program Planning and Project Development',3,'offered'),(8,'PHAS 309',3,'Animal Diseases and Parasites',3,'offered'),(9,'PHAS 314',3,'Dissertation Writing',6,'offered'),(10,'MAEM 202',4,'Methods of Research',3,'offered'),(11,'MAEM 203',4,'Legal Bases of Education',3,'offered'),(12,'MAEM 213',4,'Thesis Writing 1',3,'offered'),(13,'MATL 206',5,'Home Economic II (Sustainable Household Consumption)',3,'offered'),(14,'MATL 204',5,'Administration and Supervision of TLE',3,'offered'),(15,'MATL 213',5,'Thesis Writing',3,'offered'),(16,'MSAG 210',6,'Advanced Soil Fertility and Fertility Evaluation',3,'offered'),(17,'MSAG 203',6,'Advanced Farming Systems',3,'offered'),(18,'MSAG 213',6,'Thesis Writing',3,'offered'),(19,'MSAS 209',7,'Advanced Farming Systems',3,'offered'),(20,'MSAS 208',7,'Livestock and Poultry Diseases Parasites',3,'offered'),(21,'MSAS 213',7,'Thesis Writing',3,'offered'),(22,'MSES 201',8,'Perspectives in Environmental Studies',3,'offered'),(23,'MSES 211',8,'Environmental Laws & Policies',3,'offered'),(24,'MSES 213',8,'Thesis Writing',3,'offered'),(25,'MSAF 203',9,'Agroforestry Theory, Practice and Adoption',3,'offered'),(26,'MSAF 206',9,'Silvopasture and Integrated Livestock System',2,'offered'),(27,'MSAF 213',9,'Thesis Writing',3,'offered'),(28,'MSAM 203',10,'Agribusiness Production and Operation Management',3,'offered'),(29,'MSAM 210',10,'Agricultural Business Risk and Investment',3,'offered'),(30,'MSAM 213',10,'Thesis Writing',3,'offered'),(31,'MSRD 209',11,'Rural Community Institution Building',3,'offered'),(32,'MSRD 208',11,'Rural Community Development and the Local Government',3,'offered'),(33,'MSRD 213',11,'Thesis Writing',3,'offered'),(34,'CCIS 204',12,'Information Security',3,'offered'),(35,'MCIS 217',12,'Corporate Information Systems Plan',3,'offered'),(36,'TWIS 220',12,'Thesis Writing',3,'offered'),(37,'Seri 300',13,'Thesis Writing',3,'offered'),(38,'MAEM 200',4,'Graduate Seminar',3,'not offered'),(44,'MAEM 201',4,'Perspectives in Education',3,'not offered'),(56,'MAEM 204',4,'Human Resource Management',3,'not offered'),(57,'MAEM 205',4,'Educational Planning',3,'not offered'),(58,'MAEM 206',4,'School Finance and Budgeting',3,'not offered'),(59,'MAEM 207',4,'Organization and Management of Educational Institutions',3,'not offered'),(60,'MAEM 208',4,'Communication in Educational Management',3,'not offered'),(61,'MAEM 209',4,'Development and Governance',3,'not offered'),(62,'MAEM 210',4,'Organizational Behavior',3,'not offered'),(63,'MAEM 211',4,'Trends in Human Public Relation Setting',3,'not offered'),(64,'MAEM 212',4,'Theory of Interest',3,'not offered'),(101,'MAEM 214',4,'Thesis Writing 2',3,'not offered'),(131,'MATL 200',5,'Graduate Seminar',3,'not offered'),(132,'MATL 201',5,'Perspectives in Education',3,'not offered'),(133,'MATL 202',5,'Methods of Research',3,'not offered'),(134,'MATL 203',5,'Livelihood Project Feasibility in TLE',3,'not offered'),(135,'MATL 205',5,'Home Economics I (Family Life Education Programs)',3,'not offered'),(136,'MATL 207',5,'Agri-fishery Arts I (Farming Systems and Production Management)',3,'not offered'),(137,'MATL 208',5,'Agri-fishery Arts II (Principles, Methods, and Trends in Aquaculture)',3,'not offered'),(138,'MATL 209',5,'ICT I (Advanced Multimedia Applications)',3,'not offered'),(139,'MATL 210',5,'ICT II (Advanced Web Application Development)',3,'not offered'),(140,'MATL 211',5,'Industrial Arts I (Industry standards and regulations)',3,'not offered'),(141,'MATL 212',5,'Industrial Arts II (Skills Development Education)',3,'not offered'),(142,'MATL 214',5,'Thesis Writing 2',3,'not offered'),(146,'MSAF 200',9,'Graduate Seminar',3,'not offered'),(147,'MSAF 201',9,'Perspectives in Agroforestry',3,'not offered'),(148,'MSAF 202',9,'Methods of Research',3,'not offered'),(149,'MSAF 204',9,'Ecological Basis of Agroforestry',3,'not offered'),(150,'MSAF 205',9,'Project Development and Management in Agroforestry',3,'not offered'),(151,'MSAF 207',9,'Agroforestry Enterprise Development',3,'not offered'),(152,'MSAF 208',9,'Soil Productivity in Agroforestry',3,'not offered'),(153,'MSAF 209',9,'Agroforestry Systems Design and Management',3,'not offered'),(154,'MSAF 210',9,'Social Forestry and Governance',3,'not offered'),(155,'MSAF 211',9,'Tree Biology and Silviculture',3,'not offered'),(156,'MSAF 212',9,'Agroforestry Policy and Planning',3,'not offered'),(157,'MSAF 214',9,'Thesis Writing 2',3,'not offered'),(161,'MSAG 200',6,'Graduate Seminar',3,'not offered'),(162,'MSAG 201',6,'Perspectives in Agronomy',3,'not offered'),(163,'MSAG 202',6,'Methods of Research',3,'not offered'),(164,'MSAG 204',6,'Advanced Field Crop Physiology and Ecology',3,'not offered'),(165,'MSAG 205',6,'Advanced Plant Breeding',3,'not offered'),(166,'MSAG 206',6,'Sustainable Agriculture',3,'not offered'),(167,'MSAG 207',6,'Advanced Cereal Production',3,'not offered'),(168,'MSAG 208',6,'Advanced Field Legumes, Root Crops and Forage Crops',3,'not offered'),(169,'MSAG 209',6,'Crop Pest Management',3,'not offered'),(170,'MSAG 211',6,'Post Harvest Field Crop Physiology and Technology',3,'not offered'),(171,'MSAG 212',6,'Advanced Field Crop Processing, Storage and Marketing',3,'not offered'),(172,'MSAG 214',6,'Thesis Writing 2',3,'not offered'),(176,'MSAM 200',10,'Graduate Seminar',3,'not offered'),(177,'MSAM 201',10,'Perspectives in Agribusiness Management',3,'not offered'),(178,'MSAM 202',10,'Methods of Research',3,'not offered'),(179,'MSAM 204',10,'Financial Management Accounting and Control',3,'not offered'),(180,'MSAM 205',10,'Agribusiness Cooperative & Entrepreneurship Development',3,'not offered'),(181,'MSAM 206',10,'Personnel Management & Industrial Relations',3,'not offered'),(182,'MSAM 207',10,'Advanced Marketing Management',3,'not offered'),(183,'MSAM 208',10,'Technology Commercialization & Technopreneurship',3,'not offered'),(184,'MSAM 209',10,'Innovative and Integrative Arrangements in Managing Agribusiness Enterprises',3,'not offered'),(185,'MSAM 211',10,'Sustainable Agri-Farming Systems',3,'not offered'),(186,'MSAM 212',10,'Strategic Management in Agribusiness',3,'not offered'),(187,'MSAM 214',10,'Thesis Writing 2',3,'not offered'),(191,'MSES 200',8,'Graduate Seminar',3,'not offered'),(192,'MSES 202',8,'Methods of Research',3,'not offered'),(193,'MSES 203',8,'Coastal Resources Management',3,'not offered'),(194,'MSES 204',8,'Forest Resources Management',3,'not offered'),(195,'MSES 205',8,'Sustainable Environmental and Development',3,'not offered'),(196,'MSES 206',8,'Culture and the Environment',3,'not offered'),(197,'MSES 207',8,'Settlement Systems and Land Use',3,'not offered'),(198,'MSES 208',8,'Environmental Impact Assessment',3,'not offered'),(199,'MSES 209',8,'Aquatic Ecosystem',3,'not offered'),(200,'MSES 210',8,'Terrestrial Ecosystem',3,'not offered'),(201,'MSES 212',8,'Environmental Management',3,'not offered'),(202,'MSES 214',8,'Thesis Writing 2',3,'not offered'),(206,'MSRD 200',11,'Graduate Seminar',3,'not offered'),(207,'MSRD 201',11,'Perspectives in Rural Community Development',3,'not offered'),(208,'MSRD 202',11,'Methods of Research',3,'not offered'),(209,'MSRD 203',11,'Rural Sociology',3,'not offered'),(210,'MSRD 204',11,'Socio-Cultural Innovations',3,'not offered'),(211,'MSRD 205',11,'Philippine Rural Community Structure and Change',3,'not offered'),(212,'MSRD 206',11,'Program Planning and Management of Rural Development',3,'not offered'),(213,'MSRD 207',11,'Evaluation of Rural Community Development',3,'not offered'),(214,'MSRD 210',11,'Sustainable Agriculture and Development',3,'not offered'),(215,'MSRD 211',11,'Community and Natural Resources Management',3,'not offered'),(216,'MSRD 212',11,'Community and Economic Development',3,'not offered'),(217,'MSRD 214',11,'Thesis Writing 2',3,'not offered'),(236,'CCIS 201',12,'Digital Transformation of Organizations',3,'not offered'),(237,'CCIS 202',12,'Agile Project Management and Risk Management',3,'not offered'),(238,'CCIS 203',12,'Legal Issues in Information Systems',3,'not offered'),(239,'CCIS 205',12,'Knowledge Management',3,'not offered'),(240,'MCIS 210',12,'Data Science and Analytics',3,'not offered'),(241,'MCIS 211',12,'Enterprise Resource Planning (ERP) – Business Processes',3,'not offered'),(242,'MCIS 212',12,'Enterprise Resource Planning (ERP) – Customization and configuration',3,'not offered'),(243,'MCIS 213',12,'Performance Management and Business Intelligence',3,'not offered'),(244,'MCIS 214',12,'Decision Support and Predictive Analytics',3,'not offered'),(245,'MCIS 215',12,'Corporate Information Systems Plan',3,'not offered'),(246,'MCIS 216',12,'Emerging Technologies and Issues',3,'not offered'),(247,'MCIS 218',12,'Information Systems Architecture',3,'not offered'),(248,'MCIS 219',12,'Industry Immersion',3,'not offered'),(249,'ISBA 102',12,'Fundamentals of Enterprise Data Management',3,'not offered'),(250,'ISPC 104',12,'IT Infrastructure and Network Technologies',3,'not offered'),(251,'ISBA 101',12,'Fundamentals of Business Analytics',3,'not offered'),(252,'ISPC 107',12,'IS Project Management',3,'not offered'),(253,'ISPC 112',12,'IS Strategy Management & Acquisition',3,'not offered'),(254,'ISPC 108',12,'Enterprise Systems & Architecture',3,'not offered'),(255,'ISPC 109',12,'Evaluation of Business Process',3,'not offered'),(259,'PHAG 300',2,'Graduate Seminar',3,'not offered'),(260,'PHAG 301',2,'Philosophical and Critical Perspectives in Agronomy',3,'not offered'),(261,'PHAG 302',2,'Research Designs and Methodologies',3,'not offered'),(262,'PHAG 303',2,'Knowledge Management in Agronomy',3,'not offered'),(263,'PHAG 304',2,'Applied Plant Breeding and Population Genetics',3,'not offered'),(264,'PHAG 305',2,'Seed Science and Technology',3,'not offered'),(265,'PHAG 306',2,'Physiology of Herbicides and its Interaction to Soil',3,'not offered'),(266,'PHAG 307',2,'Advanced Agronomic Crop Management',3,'not offered'),(267,'PHAG 308',2,'Advanced Crop Pest Management',3,'not offered'),(268,'PHAG 310',2,'Environmental Physiology',3,'not offered'),(269,'PHAG 311',2,'Advanced Plant Growth and Development',3,'not offered'),(270,'PHAG 312',2,'Sustainable Development',3,'not offered'),(271,'PHAG 315',2,'Dissertation Writing 2',6,'not offered'),(275,'PHAS 300',3,'Graduate Seminar',3,'not offered'),(276,'PHAS 301',3,'Philosophical and Critical Perspectives in Animal Science',3,'not offered'),(277,'PHAS 302',3,'Research Designs and Methodologies',3,'not offered'),(278,'PHAS 303',3,'Knowledge Management in Animal Science',3,'not offered'),(279,'PHAS 304',3,'Advanced Ruminant Production',3,'not offered'),(280,'PHAS 305',3,'Advanced Poultry Production',3,'not offered'),(281,'PHAS 306',3,'Advanced Swine Production',3,'not offered'),(282,'PHAS 307',3,'Advanced Forage Production and Pasture Management',3,'not offered'),(283,'PHAS 308',3,'Exotic and Wild Animal',3,'not offered'),(284,'PHAS 311',3,'Environmental Animal Health Management',3,'not offered'),(285,'PHAS 312',3,'Livestock Endocrinology',3,'not offered'),(286,'PHAS 313',3,'Advanced Farming Systems',3,'not offered'),(287,'PHAS 315',3,'Dissertation Writing 2',6,'not offered'),(291,'PHEA 300',1,'Graduate Seminar',3,'not offered'),(292,'PHEA 302',1,'Research Designs and Methodology',3,'not offered'),(293,'PHEA 303',1,'Knowledge Management in Educational Administration',3,'not offered'),(294,'PHEA 304',1,'Theories & Practices in Administration & Supervision',3,'not offered'),(295,'PHEA 305',1,'Qualitative Research Methods in Educational Administration and Organization Development',3,'not offered'),(296,'PHEA 306',1,'Educational Leadership',3,'not offered'),(297,'PHEA 307',1,'Legal Issues and Administrative Policies in Education',3,'not offered'),(298,'PHEA 308',1,'Systems Analysis in Education',3,'not offered'),(299,'PHEA 309',1,'Economics of Education: Fiscal Administration',3,'not offered'),(300,'PHEA 310',1,'Trends and Issues in Educational Planning',3,'not offered'),(301,'PHEA 312',1,'Quantitative Research Methods in Educational Administration and Organization Development',3,'not offered'),(302,'PHEA 313',1,'Methodology and Supervision of Higher Education',3,'not offered'),(303,'PHEA 315',1,'Environmental Planning and Management for Sustainable Development',3,'not offered'),(304,'PHEA 316',1,'Dissertation Writing 1',6,'not offered'),(305,'PHEA 317',1,'Dissertation Writing 2',6,'not offered');
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enrollment_fees`
--

DROP TABLE IF EXISTS `enrollment_fees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `enrollment_fees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `total_units` int(11) NOT NULL,
  `tuition_fee` decimal(10,2) NOT NULL,
  `misc_fee` decimal(10,2) NOT NULL,
  `total_fee` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`),
  CONSTRAINT `enrollment_fees_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enrollment_fees`
--

LOCK TABLES `enrollment_fees` WRITE;
/*!40000 ALTER TABLE `enrollment_fees` DISABLE KEYS */;
INSERT INTO `enrollment_fees` VALUES (3,15,9,3600.00,3175.00,6775.00,'2025-07-04 12:06:45'),(4,14,9,3600.00,3375.00,6975.00,'2025-07-04 13:34:47');
/*!40000 ALTER TABLE `enrollment_fees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enrollments`
--

DROP TABLE IF EXISTS `enrollments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `enrollments` (
  `enrollment_id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `term` varchar(10) NOT NULL,
  `academic_year` varchar(10) NOT NULL,
  `student_category` varchar(4) NOT NULL,
  `status` enum('pending','enrolled','rejected') DEFAULT 'pending',
  `id_number` varchar(50) DEFAULT NULL,
  `date_applied` timestamp NOT NULL DEFAULT current_timestamp(),
  `full_name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `program` varchar(100) DEFAULT NULL,
  `student_name` varchar(255) DEFAULT NULL,
  `student_email` varchar(255) DEFAULT NULL,
  `student_id_number` varchar(50) DEFAULT NULL,
  `program_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`enrollment_id`),
  KEY `course_id` (`course_id`),
  KEY `fk_enrollments_student` (`student_id`),
  CONSTRAINT `enrollments_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_enrollments_student` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=340 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enrollments`
--

LOCK TABLES `enrollments` WRITE;
/*!40000 ALTER TABLE `enrollments` DISABLE KEYS */;
INSERT INTO `enrollments` VALUES (334,15,31,'1st Sem','2025-2026','Old','pending',NULL,'2025-07-04 12:06:45',NULL,NULL,'Pagdalagan, San Fernando City, La Union',NULL,'Mark Morillo Quinitip','mark@gmail.com','211-1003-6',11),(335,15,32,'1st Sem','2025-2026','Old','pending',NULL,'2025-07-04 12:06:45',NULL,NULL,'Pagdalagan, San Fernando City, La Union',NULL,'Mark Morillo Quinitip','mark@gmail.com','211-1003-6',11),(336,15,33,'1st Sem','2025-2026','Old','pending',NULL,'2025-07-04 12:06:45',NULL,NULL,'Pagdalagan, San Fernando City, La Union',NULL,'Mark Morillo Quinitip','mark@gmail.com','211-1003-6',11),(337,14,13,'1st Sem','2025-2026','New','enrolled',NULL,'2025-07-04 13:34:47',NULL,NULL,'Sevilla, San Fernando City, La Union',NULL,'Bianca Mairah','bianca@gmail.com','211-1003-5',5),(338,14,14,'1st Sem','2025-2026','New','enrolled',NULL,'2025-07-04 13:34:47',NULL,NULL,'Sevilla, San Fernando City, La Union',NULL,'Bianca Mairah','bianca@gmail.com','211-1003-5',5),(339,14,15,'1st Sem','2025-2026','New','enrolled',NULL,'2025-07-04 13:34:47',NULL,NULL,'Sevilla, San Fernando City, La Union',NULL,'Bianca Mairah','bianca@gmail.com','211-1003-5',5);
/*!40000 ALTER TABLE `enrollments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faculty`
--

DROP TABLE IF EXISTS `faculty`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `faculty` (
  `faculty_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`faculty_id`),
  UNIQUE KEY `name` (`name`),
  KEY `fk_faculty_user` (`user_id`),
  CONSTRAINT `fk_faculty_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faculty`
--

LOCK TABLES `faculty` WRITE;
/*!40000 ALTER TABLE `faculty` DISABLE KEYS */;
INSERT INTO `faculty` VALUES (1,'GSNisperos',NULL),(2,'JRETabafunda',NULL),(3,'TBA',NULL),(4,'PPFontanilla',NULL),(5,'AVSagun',17),(6,'FMCamalig',NULL),(7,'MBMendoza',NULL),(8,'DPLicay',NULL),(9,'NBTugelida',18),(10,'VMLibunao',NULL),(11,'JJCAndrada',NULL),(12,'DAVilar',NULL),(13,'LDGavina',NULL),(14,'JCortado',NULL),(15,'AGLaquidan',16),(16,'JNQuinquito',NULL),(17,'GTBondot',NULL),(18,'DANeri',NULL),(19,'ECEbuenga',NULL);
/*!40000 ALTER TABLE `faculty` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grades`
--

DROP TABLE IF EXISTS `grades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `grades` (
  `grade_id` int(11) NOT NULL AUTO_INCREMENT,
  `enrollment_id` int(11) NOT NULL,
  `grade` varchar(10) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`grade_id`),
  KEY `enrollment_id` (`enrollment_id`),
  CONSTRAINT `grades_ibfk_1` FOREIGN KEY (`enrollment_id`) REFERENCES `enrollments` (`enrollment_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grades`
--

LOCK TABLES `grades` WRITE;
/*!40000 ALTER TABLE `grades` DISABLE KEYS */;
INSERT INTO `grades` VALUES (1,337,'89','2025-08-08 06:04:35','2025-08-08 06:04:35'),(2,338,'92','2025-08-08 06:05:42','2025-08-08 06:05:42');
/*!40000 ALTER TABLE `grades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(255) NOT NULL,
  `details` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs`
--

LOCK TABLES `logs` WRITE;
/*!40000 ALTER TABLE `logs` DISABLE KEYS */;
INSERT INTO `logs` VALUES (1,NULL,'Backup','Database backup downloaded','2025-08-10 14:31:08'),(2,14,'Login','User bianca@gmail.com logged in','2025-08-12 13:52:42'),(3,6,'Login','User admin2@cgs.edu logged in','2025-08-12 13:52:51'),(4,NULL,'Database Backup','Backup created successfully','2025-08-12 13:52:58'),(5,6,'Login','User admin2@cgs.edu logged in','2025-08-12 13:55:45'),(6,6,'Login','User admin2@cgs.edu logged in','2025-08-12 14:00:11');
/*!40000 ALTER TABLE `logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `programs`
--

DROP TABLE IF EXISTS `programs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `programs` (
  `program_id` int(11) NOT NULL AUTO_INCREMENT,
  `program_name` varchar(255) NOT NULL,
  `program_level` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`program_id`),
  UNIQUE KEY `program_name` (`program_name`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `programs`
--

LOCK TABLES `programs` WRITE;
/*!40000 ALTER TABLE `programs` DISABLE KEYS */;
INSERT INTO `programs` VALUES (1,'Doctor of Philosophy in Educational Administration',NULL),(2,'Doctor of Philosophy in Agronomy',NULL),(3,'Doctor of Philosophy in Animal Science',NULL),(4,'Master of Arts in Educational Management',NULL),(5,'Master of Science in Education (TLE)',NULL),(6,'Master of Science in Agronomy',NULL),(7,'Master of Science in Animal Science',NULL),(8,'Master of Science in Environmental Studies',NULL),(9,'Master of Science in Agroforestry',NULL),(10,'Master of Science in Agribusiness Management',NULL),(11,'Master of Science in Rural Community Development',NULL),(12,'Master of Science in Information Systems',NULL),(13,'Master of Science in Sericulture',NULL);
/*!40000 ALTER TABLE `programs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedules`
--

DROP TABLE IF EXISTS `schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schedules` (
  `schedule_id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` int(11) NOT NULL,
  `day_time` varchar(50) NOT NULL,
  PRIMARY KEY (`schedule_id`),
  KEY `course_id` (`course_id`),
  CONSTRAINT `schedules_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedules`
--

LOCK TABLES `schedules` WRITE;
/*!40000 ALTER TABLE `schedules` DISABLE KEYS */;
INSERT INTO `schedules` VALUES (1,1,'8-12S'),(2,1,'5:30-8:30W'),(3,1,'5:30-7:30F'),(4,2,'1-5S'),(5,2,'5:30-8:30T'),(6,2,'5:30-7:30Th'),(7,3,'TBA'),(8,4,'8-12S'),(9,4,'5:30-8:30W'),(10,4,'5:30-7:30F'),(11,5,'1-5S'),(12,5,'5:30-8:30T'),(13,5,'5:30-7:30Th'),(14,6,'TBA'),(15,7,'8-12S'),(16,7,'5:30-8:30W'),(17,7,'5:30-7:30F'),(18,8,'1-5S'),(19,8,'5:30-8:30T'),(20,8,'5:30-7:30Th'),(21,9,'TBA'),(22,10,'8-12S'),(23,10,'5:30-8:30W'),(24,10,'5:30-7:30F'),(25,11,'1-5S'),(26,11,'5:30-8:30T'),(27,11,'5:30-7:30Th'),(28,12,'TBA'),(29,13,'8-12S'),(30,13,'5:30-8:30W'),(31,13,'5:30-7:30F'),(32,14,'1-5S'),(33,14,'5:30-8:30T'),(34,14,'5:30-7:30Th'),(35,15,'TBA'),(36,16,'8-12S'),(37,16,'5:30-8:30W'),(38,16,'5:30-7:30F'),(39,17,'1-5S'),(40,17,'5:30-8:30T'),(41,17,'5:30-7:30Th'),(42,18,'TBA'),(43,19,'1-6S'),(44,19,'5:30-8:30T'),(45,20,'8-12S'),(46,20,'5:30-8:30W'),(47,20,'5:30-7:30F'),(48,21,'TBA'),(49,22,'8-12S'),(50,22,'5:30-8:30W'),(51,22,'5:30-7:30F'),(52,23,'1-5S'),(53,23,'5:30-8:30T'),(54,23,'5:30-7:30Th'),(55,24,'TBA'),(56,25,'8-12S'),(57,25,'5:30-8:30W'),(58,25,'5:30-7:30F'),(59,26,'1-5S'),(60,26,'5:30-8:30T'),(61,26,'5:30-7:30Th'),(62,27,'TBA'),(63,28,'8-12S'),(64,28,'5:30-8:30W'),(65,28,'5:30-7:30F'),(66,29,'1-5S'),(67,29,'5:30-8:30T'),(68,29,'5:30-7:30Th'),(69,30,'TBA'),(70,31,'8-12S'),(71,31,'5:30-8:30W'),(72,31,'5:30-7:30F'),(73,32,'1-5S'),(74,32,'5:30-8:30T'),(75,32,'5:30-7:30Th'),(76,33,'TBA'),(77,34,'1-5S'),(78,34,'5:30-8:30T'),(79,34,'5:30-7:30Th'),(80,35,'8-12S'),(81,35,'5:30-8:30W'),(82,35,'5:30-7:30F'),(83,36,'TBA'),(84,37,'TBA');
/*!40000 ALTER TABLE `schedules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `user_level` enum('admin','student','teacher') NOT NULL DEFAULT 'student',
  `program_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_email` (`email`),
  KEY `idx_user_level` (`user_level`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (4,'tolentino@gmail.com','$2b$10$C8T1WMh7VEYNcmz2UEn1yOJQhwfy7vnHXlLCdWBHO10iVLIm8AY4y','','2025-06-24 13:29:30','student',NULL),(6,'admin2@cgs.edu','$2b$10$RhVLs/JwrUyGaC/7ZvftD.hggvXtffTUsu4pQrbk8qfnGxhpO3hgy','','2025-06-25 16:26:09','admin',NULL),(7,'msis.student@cgs.edu','password123','','2025-06-28 07:04:15','student',NULL),(11,'tolen@gmail.com','$2b$10$4kXdclLy1gYvdnslIhhDgelL2lUxdZc8HLU6ObqBlip0IaTvno.Jy','','2025-06-30 07:51:34','student',NULL),(12,'tolentinochristian89@gmail.com','$2b$10$mNfLLKuEPmBqx7cIr62PoOOGnQuEICPqS0Gsunlq6jqO/rzO6WStO','','2025-06-30 10:03:56','student',NULL),(13,'prence@gmail.com','$2b$10$FNO0JFizImtzMS8jL2VuCexsgbRM1/JFpUiuexhXw.gjA2YvEurOG','','2025-06-30 14:57:16','student',NULL),(14,'bianca@gmail.com','$2b$10$gMdc7QlJw8mGsxXwKIrSR.ZtbXQjU2qwzH6hxGOIQljWQfkvRDr/u','Bianca Mairah','2025-06-30 15:30:10','student',NULL),(15,'mark@gmail.com','$2b$10$12haxuMG42A0O8JBMnhSBeoHVyy3cyGhNzVM4oyRD/lqj706QERG6','Mark Morillo Quinitip','2025-07-04 12:05:54','student',NULL),(16,'aglaquidan@gmail.com','$2b$10$M85TFcZONVbqzUYBTX5lI.cUiut7xKjSZqnf2ccruM.rHxQ4iXNRm','AGLaquidan','2025-08-07 15:06:08','teacher',NULL),(17,'avsagun@gmail.com','$2b$10$CuDg/lSKzW0WVWVdoPVE.Oe0BC0h5J8cz3jrtot98FGa5DxfBMYEa','AVSagun','2025-08-08 05:32:57','teacher',NULL),(18,'nbtugelida@gmail.com','$2b$10$DDob9R2x8ChvbMZt4MY7yethQmwvegTWmXXDvFZqdfl8FPmsmu8fK','NBTugelida','2025-08-08 05:55:28','teacher',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-08-12 22:12:08
