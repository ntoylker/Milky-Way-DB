DROP SCHEMA IF EXISTS `milkyway`;
CREATE SCHEMA `milkyway` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `milkyway`;
-- MySQL dump 10.13  Distrib 8.0.44, for Linux (x86_64)
--
-- Host: localhost    Database: milkyway
-- ------------------------------------------------------
-- Server version	8.0.44-0ubuntu0.24.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
--
-- Table structure for table `Black Hole`
--

DROP TABLE IF EXISTS `Black Hole`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Black Hole` (
  `CelestialId` int unsigned NOT NULL,
  `BlackHoleType` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ConstellationId` int unsigned NOT NULL,
  `DistanceFromEarth` decimal(10,2) NOT NULL,
  `Mass` decimal(6,3) NOT NULL,
  `Spin` decimal(5,4) NOT NULL,
  `EventHorizonRadius` decimal(12,2) NOT NULL,
  PRIMARY KEY (`CelestialId`),
  KEY `fk_bh_constellation` (`ConstellationId`),
  CONSTRAINT `fk_bh_celestial` FOREIGN KEY (`CelestialId`) REFERENCES `Celestial Object` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `fk_bh_constellation` FOREIGN KEY (`ConstellationId`) REFERENCES `Constellation` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Black Hole`
--

LOCK TABLES `Black Hole` WRITE;
/*!40000 ALTER TABLE `Black Hole` DISABLE KEYS */;
INSERT INTO `Black Hole` VALUES (20,'Stellar',1,1340.50,12.500,0.6700,37000.00),(21,'Intermediate',2,8700.20,520.000,0.8100,1540000.00),(22,'Supermassive',3,2000.00,999.999,0.9900,99999999.99);
/*!40000 ALTER TABLE `Black Hole` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Celestial Object`
--

DROP TABLE IF EXISTS `Celestial Object`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Celestial Object` (
  `Id` int unsigned NOT NULL AUTO_INCREMENT,
  `ObjectType` enum('Star','Planet','Black Hole','Nebula','Debris Disk') COLLATE utf8mb4_unicode_ci NOT NULL,
  `Name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=503 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Celestial Object`
--

LOCK TABLES `Celestial Object` WRITE;
/*!40000 ALTER TABLE `Celestial Object` DISABLE KEYS */;
INSERT INTO `Celestial Object` VALUES (1,'Star','Alphard'),(2,'Star','Acrux'),(3,'Star','Betelgeuse'),(4,'Planet','Pyrrhos'),(5,'Planet','Cyralon'),(6,'Planet','Varunox'),(20,'Black Hole','Stellar BH'),(21,'Black Hole','ORI-X1'),(22,'Black Hole','HYD-BH2'),(30,'Nebula','Emission Neb'),(31,'Nebula','Orionis Nebula-X'),(32,'Nebula','Lerna Shadow Cloud'),(40,'Debris Disk','Dusty Ring'),(41,'Debris Disk','Alphard Dust Belt'),(42,'Debris Disk','Acrux Outer Disk'),(100,'Planet','Planet Winner'),(101,'Planet','Planet Far'),(102,'Planet','Planet Gas'),(103,'Planet','Planet Dead'),(200,'Star','Orion Hot Star'),(201,'Star','Orion Cold Star'),(202,'Star','Draco Hot Star'),(301,'Planet','Trappist-Belt Dweller'),(302,'Planet','Trappist-Inner'),(303,'Planet','Trappist-Outer'),(304,'Debris Disk','Trappist Belt'),(401,'Planet','Busy-1'),(402,'Planet','Busy-2'),(403,'Planet','Busy-3'),(404,'Planet','Busy-4'),(405,'Planet','Quiet-1'),(406,'Planet','Quiet-2'),(407,'Planet','Quiet-3'),(500,'Star','Vega (The Match)'),(501,'Star','Sheliak (Too Cold)'),(502,'Star','Markab (Wrong Constellation)');
/*!40000 ALTER TABLE `Celestial Object` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Constellation`
--

DROP TABLE IF EXISTS `Constellation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Constellation` (
  `Id` int unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Area` decimal(8,3) NOT NULL,
  `History` text COLLATE utf8mb4_unicode_ci,
  `GeometricalDescription` text COLLATE utf8mb4_unicode_ci,
  `Quadrant` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=502 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Constellation`
--

LOCK TABLES `Constellation` WRITE;
/*!40000 ALTER TABLE `Constellation` DISABLE KEYS */;
INSERT INTO `Constellation` VALUES (1,'Ωρίωνας',594.000,'Ένας από τους πιο αναγνωρίσιμους, βασισμένος στον μυθικό κυνηγό.','Διακρίνεται από τη χαρακτηριστική ζώνη τριών αστέρων.','Ισημερινός'),(2,'Ύδρα',1303.000,'Ο μεγαλύτερος αστερισμός του ουρανού.','Πολύ μεγάλο και λεπτό σχήμα.','Νότιος'),(3,'Νότιος Σταυρός',168.000,'Ο μικρότερος αστερισμός, ναυτιλιακός δείκτης.','Έχει σχήμα σταυρού ή χαρταετού.','Νότιος'),(100,'Test Constellation for QUERY 1',500.000,'Τεστ ιστορία, πάντα χαμηλά','Έχει σχήμα σαν το κεφάλι του Κουδ','Test Quadrant'),(201,'Draco',1083.000,'TEST','test','Test Quad'),(300,'Aquarius',980.000,'TEST','test','Test Quad'),(400,'Cassiopeia',598.000,'TEST','test','Test Quad'),(500,'Lyra',286.000,'TEST','test','Test Quad'),(501,'Pegasus',1121.000,'TEST','test','Test Quad');
/*!40000 ALTER TABLE `Constellation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Debris Disk`
--

DROP TABLE IF EXISTS `Debris Disk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Debris Disk` (
  `CelestialId` int unsigned NOT NULL,
  `DebrisDiskType` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `PlanetarySystemId` int unsigned NOT NULL,
  `InnerRadius` decimal(12,3) NOT NULL,
  `OuterRadius` decimal(12,3) NOT NULL,
  `Mass` decimal(10,6) NOT NULL,
  `MainComposition` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`CelestialId`),
  KEY `fk_dd_ps` (`PlanetarySystemId`),
  CONSTRAINT `fk_dd_celestial` FOREIGN KEY (`CelestialId`) REFERENCES `Celestial Object` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `fk_dd_ps` FOREIGN KEY (`PlanetarySystemId`) REFERENCES `Planetary System` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Debris Disk`
--

LOCK TABLES `Debris Disk` WRITE;
/*!40000 ALTER TABLE `Debris Disk` DISABLE KEYS */;
INSERT INTO `Debris Disk` VALUES (40,'Dusty Ring',1,18.200,42.500,0.000021,'Silicates, Ice Grains'),(41,'Icy Debris',2,34.100,88.000,0.000305,'Water Ice, CO Ice'),(42,'Rocky',3,12.700,29.300,0.000150,'Carbonaceous Rock'),(304,'Rocky Ring',300,10.000,20.000,0.005000,'Silicates');
/*!40000 ALTER TABLE `Debris Disk` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Nebula`
--

DROP TABLE IF EXISTS `Nebula`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Nebula` (
  `CelestialId` int unsigned NOT NULL,
  `NebulaType` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ConstellationId` int unsigned NOT NULL,
  `DistanceFromEarth` decimal(10,2) NOT NULL,
  `PhysicalSize` decimal(6,2) NOT NULL,
  `PrimaryComposition` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`CelestialId`),
  KEY `fk_nebula_constellation` (`ConstellationId`),
  CONSTRAINT `fk_nebula_celestial` FOREIGN KEY (`CelestialId`) REFERENCES `Celestial Object` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `fk_nebula_constellation` FOREIGN KEY (`ConstellationId`) REFERENCES `Constellation` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Nebula`
--

LOCK TABLES `Nebula` WRITE;
/*!40000 ALTER TABLE `Nebula` DISABLE KEYS */;
INSERT INTO `Nebula` VALUES (30,'Emission',1,1344.20,24.00,'H2, He, OIII'),(31,'Dark',2,3900.50,12.70,'Carbon Dust, H2'),(32,'Reflection',3,620.30,8.10,'Silicates, Molecular Gas');
/*!40000 ALTER TABLE `Nebula` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Observation`
--

DROP TABLE IF EXISTS `Observation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Observation` (
  `Id` int unsigned NOT NULL AUTO_INCREMENT,
  `CelestialId` int unsigned NOT NULL,
  `Method` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `InstrumentType` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Date` date NOT NULL,
  `ResearcherName` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ObservationStatus` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `fk_obs_celestial` (`CelestialId`),
  CONSTRAINT `fk_obs_celestial` FOREIGN KEY (`CelestialId`) REFERENCES `Celestial Object` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Observation`
--

LOCK TABLES `Observation` WRITE;
/*!40000 ALTER TABLE `Observation` DISABLE KEYS */;
INSERT INTO `Observation` VALUES (1,2,'Spectroscopy','Infrared-Telescope','2034-05-01','Dr. Elena Korvin','Completed'),(2,6,'Radar Imaging','Deep-Space-Radar-Array','2035-01-01','Prof. Luis Ortega','In Progress'),(3,21,'Transit Photometry','Optical-Space-Telescope','2033-11-01','Dr. Mei-Ling Tan','Failed');
/*!40000 ALTER TABLE `Observation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Pending_Observation`
--

DROP TABLE IF EXISTS `Pending_Observation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Pending_Observation` (
  `Id` int unsigned NOT NULL AUTO_INCREMENT,
  `SubmitterName` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `TargetObject` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ObservationData` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `SubmissionDate` date NOT NULL,
  `Status` enum('Pending','Approved','Rejected') COLLATE utf8mb4_unicode_ci DEFAULT 'Pending',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Pending_Observation`
--

LOCK TABLES `Pending_Observation` WRITE;
/*!40000 ALTER TABLE `Pending_Observation` DISABLE KEYS */;
/*!40000 ALTER TABLE `Pending_Observation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Planet`
--

DROP TABLE IF EXISTS `Planet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Planet` (
  `CelestialId` int unsigned NOT NULL,
  `PlanetarySystemId` int unsigned NOT NULL,
  `DistanceFromEarth` decimal(10,2) NOT NULL,
  `DistanceFromCenter` decimal(12,2) NOT NULL,
  `Mass` decimal(10,2) NOT NULL,
  `PlanetType` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `CoreTemp` int NOT NULL,
  `SurfaceTemp` int NOT NULL,
  `OrbitalPeriod` decimal(10,5) NOT NULL,
  `Habitability` bit(1) NOT NULL,
  PRIMARY KEY (`CelestialId`),
  KEY `fk_planet_ps` (`PlanetarySystemId`),
  CONSTRAINT `fk_planet_celestial` FOREIGN KEY (`CelestialId`) REFERENCES `Celestial Object` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `fk_planet_ps` FOREIGN KEY (`PlanetarySystemId`) REFERENCES `Planetary System` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Planet`
--

LOCK TABLES `Planet` WRITE;
/*!40000 ALTER TABLE `Planet` DISABLE KEYS */;
INSERT INTO `Planet` VALUES (4,2,180620.00,54236.75,1017.00,'Gas Giant',45000,2200,1752.00000,_binary '\0'),(5,1,14500.00,8589579.82,5.80,'Rocky',7900,850,64.00000,_binary '\0'),(6,3,9556.00,9898579.56,133.50,'Ice Giant',14500,380,840.00000,_binary '\0'),(100,100,4.30,10000.00,1.50,'Super Earth',5000,280,365.00000,_binary ''),(101,101,6.00,10000.00,1.50,'Super Earth',5000,280,365.00000,_binary ''),(102,102,3.50,20000.00,300.00,'Gas Giant',4000,150,4000.00000,_binary ''),(103,103,2.00,5000.00,1.80,'Super Earth',6000,800,100.00000,_binary '\0'),(301,300,39.00,15.00,1.00,'Rocky',4000,200,100.00000,_binary '\0'),(302,300,39.00,5.00,0.80,'Rocky',5000,300,50.00000,_binary ''),(303,300,39.00,25.00,5.00,'Ice Giant',4000,50,500.00000,_binary '\0'),(401,400,25.00,5.00,300.00,'Gas Giant',5000,150,400.00000,_binary '\0'),(402,400,25.00,2.00,1.00,'Rocky',4000,280,100.00000,_binary ''),(403,400,25.00,10.00,15.00,'Ice Giant',3000,80,1000.00000,_binary '\0'),(404,400,25.00,1.50,0.50,'Rocky',4500,400,80.00000,_binary '\0'),(405,401,12.00,4.00,250.00,'Gas Giant',5000,140,300.00000,_binary '\0'),(406,401,12.00,1.20,1.20,'Rocky',4100,300,90.00000,_binary ''),(407,401,12.00,0.80,0.40,'Rocky',4600,500,50.00000,_binary '\0');
/*!40000 ALTER TABLE `Planet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Planetary System`
--

DROP TABLE IF EXISTS `Planetary System`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Planetary System` (
  `Id` int unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `DistanceFromEarth` decimal(10,2) NOT NULL,
  `ConstellationId` int unsigned NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `fk_ps_constellation` (`ConstellationId`),
  CONSTRAINT `fk_ps_constellation` FOREIGN KEY (`ConstellationId`) REFERENCES `Constellation` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=503 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Planetary System`
--

LOCK TABLES `Planetary System` WRITE;
/*!40000 ALTER TABLE `Planetary System` DISABLE KEYS */;
INSERT INTO `Planetary System` VALUES (1,'Alphard System',177.00,2),(2,'Acrux System',321.00,3),(3,'Betelgeuse System',642.00,1),(100,'Alpha System (Winner)',4.30,100),(101,'Beta System (Too Far)',6.00,100),(102,'Gamma System (Wrong Type)',3.50,100),(103,'Delta System (Unhabitable)',2.00,100),(200,'Orion Alpha Sys',500.00,1),(201,'Orion Beta Sys',400.00,1),(202,'Draco Gamma Sys',100.00,201),(300,'Trappist',39.00,300),(400,'Busy System (Large)',25.00,400),(401,'Quiet System (Small)',12.00,400),(500,'Vega System',25.00,500),(501,'Sheliak System',880.00,500),(502,'Markab System',133.00,501);
/*!40000 ALTER TABLE `Planetary System` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Satellite`
--

DROP TABLE IF EXISTS `Satellite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Satellite` (
  `Name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Diameter` decimal(12,3) NOT NULL,
  `PlanetId` int unsigned NOT NULL,
  `Mass` decimal(5,2) NOT NULL,
  `SurfaceTemp` int NOT NULL,
  `SatelliteType` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`Name`,`PlanetId`),
  KEY `fk_satellite_planet` (`PlanetId`),
  CONSTRAINT `fk_satellite_planet` FOREIGN KEY (`PlanetId`) REFERENCES `Planet` (`CelestialId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Satellite`
--

LOCK TABLES `Satellite` WRITE;
/*!40000 ALTER TABLE `Satellite` DISABLE KEYS */;
INSERT INTO `Satellite` VALUES ('Busy-Moon',3000.000,401,0.05,100,'Natural'),('Dravix',11800.000,6,0.19,95,'Natural'),('Kelython',5400.000,5,0.03,150,'Natural'),('Quiet-Moon',2500.000,405,0.04,110,'Natural'),('Thalmar',3200.000,4,0.01,180,'Quasi');
/*!40000 ALTER TABLE `Satellite` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Star`
--

DROP TABLE IF EXISTS `Star`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Star` (
  `CelestialId` int unsigned NOT NULL,
  `PlanetarySystemId` int unsigned NOT NULL,
  `DistanceFromEarth` decimal(10,2) NOT NULL,
  `Mass` decimal(6,3) NOT NULL,
  `Age` decimal(11,2) NOT NULL,
  `SurfaceTemp` int NOT NULL,
  `Luminocity` decimal(10,3) NOT NULL,
  `Phase` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`CelestialId`),
  KEY `fk_star_ps` (`PlanetarySystemId`),
  CONSTRAINT `fk_star_celestial` FOREIGN KEY (`CelestialId`) REFERENCES `Celestial Object` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `fk_star_ps` FOREIGN KEY (`PlanetarySystemId`) REFERENCES `Planetary System` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Star`
--

LOCK TABLES `Star` WRITE;
/*!40000 ALTER TABLE `Star` DISABLE KEYS */;
INSERT INTO `Star` VALUES (1,1,177.00,3.000,420.00,4230,700.000,'Main Sequence'),(2,2,321.00,14.500,18.00,24000,25000.000,'Subgiant'),(3,3,640.00,15.000,10.00,3500,100000.000,'Red Supergiant'),(200,200,500.00,10.000,15.00,3500,10000.000,'Red Supergiant'),(201,201,400.00,460.000,0.50,2500,0.050,'Red Dwarf'),(202,202,100.00,500.000,2.00,9000,20.000,'Main Sequence'),(500,500,25.00,455.000,2.10,9600,40.000,'Main Sequence'),(501,501,880.00,100.000,5.00,3500,2000.000,'Eclipsing Binary'),(502,502,133.00,300.000,3.00,10000,95.000,'Main Sequence');
/*!40000 ALTER TABLE `Star` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `View_Hot_Planets`
--

DROP TABLE IF EXISTS `View_Hot_Planets`;
/*!50001 DROP VIEW IF EXISTS `View_Hot_Planets`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `View_Hot_Planets` AS SELECT 
 1 AS `PlanetName`,
 1 AS `PlanetType`,
 1 AS `SurfaceTemp`,
 1 AS `SystemName`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `View_Planet_Directory`
--

DROP TABLE IF EXISTS `View_Planet_Directory`;
/*!50001 DROP VIEW IF EXISTS `View_Planet_Directory`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `View_Planet_Directory` AS SELECT 
 1 AS `PlanetName`,
 1 AS `SystemName`,
 1 AS `Habitability`,
 1 AS `DistanceFromEarth`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `View_Red_Dwarf_Systems`
--

DROP TABLE IF EXISTS `View_Red_Dwarf_Systems`;
/*!50001 DROP VIEW IF EXISTS `View_Red_Dwarf_Systems`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `View_Red_Dwarf_Systems` AS SELECT 
 1 AS `SystemName`,
 1 AS `StarName`,
 1 AS `Mass`,
 1 AS `Luminocity`,
 1 AS `Phase`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `View_Satellite_Full_Details`
--

DROP TABLE IF EXISTS `View_Satellite_Full_Details`;
/*!50001 DROP VIEW IF EXISTS `View_Satellite_Full_Details`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `View_Satellite_Full_Details` AS SELECT 
 1 AS `SatelliteName`,
 1 AS `Diameter`,
 1 AS `SatelliteType`,
 1 AS `PlanetName`,
 1 AS `SystemName`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `View_Hot_Planets`
--

/*!50001 DROP VIEW IF EXISTS `View_Hot_Planets`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`admin`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `View_Hot_Planets` AS select `co`.`Name` AS `PlanetName`,`p`.`PlanetType` AS `PlanetType`,`p`.`SurfaceTemp` AS `SurfaceTemp`,`ps`.`Name` AS `SystemName` from ((`Planet` `p` join `Celestial Object` `co` on((`p`.`CelestialId` = `co`.`Id`))) join `Planetary System` `ps` on((`p`.`PlanetarySystemId` = `ps`.`Id`))) where (`p`.`SurfaceTemp` > 400) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `View_Planet_Directory`
--

/*!50001 DROP VIEW IF EXISTS `View_Planet_Directory`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`admin`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `View_Planet_Directory` AS select `co`.`Name` AS `PlanetName`,`ps`.`Name` AS `SystemName`,`p`.`Habitability` AS `Habitability`,`p`.`DistanceFromEarth` AS `DistanceFromEarth` from ((`Planet` `p` join `Planetary System` `ps` on((`p`.`PlanetarySystemId` = `ps`.`Id`))) join `Celestial Object` `co` on((`p`.`CelestialId` = `co`.`Id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `View_Red_Dwarf_Systems`
--

/*!50001 DROP VIEW IF EXISTS `View_Red_Dwarf_Systems`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`admin`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `View_Red_Dwarf_Systems` AS select `ps`.`Name` AS `SystemName`,`co`.`Name` AS `StarName`,`s`.`Mass` AS `Mass`,`s`.`Luminocity` AS `Luminocity`,`s`.`Phase` AS `Phase` from ((`Star` `s` join `Planetary System` `ps` on((`s`.`PlanetarySystemId` = `ps`.`Id`))) join `Celestial Object` `co` on((`s`.`CelestialId` = `co`.`Id`))) where (`s`.`Phase` = 'Red Dwarf') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `View_Satellite_Full_Details`
--

/*!50001 DROP VIEW IF EXISTS `View_Satellite_Full_Details`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`admin`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `View_Satellite_Full_Details` AS select `s`.`Name` AS `SatelliteName`,`s`.`Diameter` AS `Diameter`,`s`.`SatelliteType` AS `SatelliteType`,`co`.`Name` AS `PlanetName`,`ps`.`Name` AS `SystemName` from (((`Satellite` `s` join `Planet` `p` on((`s`.`PlanetId` = `p`.`CelestialId`))) join `Celestial Object` `co` on((`p`.`CelestialId` = `co`.`Id`))) join `Planetary System` `ps` on((`p`.`PlanetarySystemId` = `ps`.`Id`))) */;
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

-- Dump completed on 2025-12-16  2:15:48
