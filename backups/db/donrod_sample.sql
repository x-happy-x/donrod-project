-- MySQL dump 10.13  Distrib 8.0.29, for Win64 (x86_64)
--
-- Host: localhost    Database: j955969_donrod
-- ------------------------------------------------------
-- Server version	8.0.29

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `addons`
--

DROP TABLE IF EXISTS `addons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `addons` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) DEFAULT NULL,
  `price` float DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addons`
--

LOCK TABLES `addons` WRITE;
/*!40000 ALTER TABLE `addons` DISABLE KEYS */;
INSERT INTO `addons` VALUES (1,'-',0,'money'),(2,'С тарой',400,'money'),(3,'Без тары',0,'money');
/*!40000 ALTER TABLE `addons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `address`
--

DROP TABLE IF EXISTS `address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `address` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user` int NOT NULL,
  `address_code` varchar(40) NOT NULL COMMENT 'Адресный код',
  `manyfloors` tinyint(1) DEFAULT NULL,
  `dcode` int DEFAULT NULL COMMENT 'Код домофона',
  `apartment` int DEFAULT NULL COMMENT 'Квартира',
  `entrance` int DEFAULT NULL COMMENT 'Подъезд',
  `note` varchar(300) DEFAULT NULL COMMENT 'Примечание',
  `floor` int DEFAULT NULL COMMENT 'Этаж',
  `house` varchar(50) DEFAULT NULL,
  `state` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `address_users_id_fk` (`user`),
  CONSTRAINT `address_users_id_fk` FOREIGN KEY (`user`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `address`
--

LOCK TABLES `address` WRITE;
/*!40000 ALTER TABLE `address` DISABLE KEYS */;
INSERT INTO `address` VALUES (20,1,'61.000.001.000.0421.0007',1,92,92,3,'Если не работает домофон позвоните на мобильный +7 (928) 601-31-52',8,'58',1),(21,1,'61.013.001.000.0130.0001',0,NULL,NULL,NULL,'',NULL,'3А',1),(25,1,'61.000.001.000.0421.0007',0,NULL,NULL,NULL,'',NULL,'58',0);
/*!40000 ALTER TABLE `address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `address_filter`
--

DROP TABLE IF EXISTS `address_filter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `address_filter` (
  `id` int NOT NULL AUTO_INCREMENT,
  `address` varchar(30) NOT NULL,
  `price` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `address_filter_address_uindex` (`address`),
  UNIQUE KEY `address_filter_id_uindex` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `address_filter`
--

LOCK TABLES `address_filter` WRITE;
/*!40000 ALTER TABLE `address_filter` DISABLE KEYS */;
INSERT INTO `address_filter` VALUES (5,'61.000.001.%%%.%%%%.%%%%',200),(6,'61.013.001.%%%.%%%%.%%%%',350);
/*!40000 ALTER TABLE `address_filter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth`
--

DROP TABLE IF EXISTS `auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user` int DEFAULT NULL COMMENT 'Пользователь',
  `token` varchar(255) DEFAULT NULL COMMENT 'Токен авторизации',
  `date` datetime DEFAULT NULL COMMENT 'Время получения',
  `app` varchar(50) DEFAULT 'site',
  PRIMARY KEY (`id`),
  KEY `user` (`user`),
  CONSTRAINT `auth_ibfk_1` FOREIGN KEY (`user`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=138 DEFAULT CHARSET=utf8mb3 COMMENT='Авторизация';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth`
--

LOCK TABLES `auth` WRITE;
/*!40000 ALTER TABLE `auth` DISABLE KEYS */;
INSERT INTO `auth` VALUES (119,1,'f12a210f19f617562ace6c3988093421','2022-06-15 18:25:17','site'),(120,4,'a7207cd8d21436395a2eb56cde390aa6','2022-06-16 02:23:13','site'),(122,2,'e04156665e6fbbf9bb73aca3462a2347','2022-06-16 10:29:37','site'),(124,1,'5d540198e042545bbcd6a1445546191b','2022-06-19 12:13:35','site'),(125,1,'fb2ead8f31e90bd4437efd6604bd3765','2022-06-19 13:35:02','site'),(127,1,'8b901d929b0da19ebf92e80be2711172','2022-06-23 01:10:22','site'),(129,1,'79808fc022d37e3380c3a85c000da4be','2022-06-28 20:19:31','site'),(130,1,'1c3587f61714e548fded9885954df6c0','2022-06-28 21:10:58','site'),(131,1,'51112b8e77931b23ed27b4c4ce65d32d','2022-06-28 21:11:14','site'),(132,1,'84662366c7c3f38765a9ae6b6d7b6a78','2022-06-28 21:13:34','site'),(133,1,'b7d055ee78bf975bc207fe37535a7310','2022-06-28 21:20:47','site'),(134,1,'95f9b5ff2eab1fb7c10bdced46b5f050','2022-07-03 19:05:50','site'),(135,1,'f30edd854f334c2094ad7112a01e4d75','2022-07-06 07:15:38','site'),(136,1,'8ab8911dd109918a0cb9f14d106237c4','2022-07-09 12:48:31','site'),(137,1,'871b917e566ce44fd7ebf60e75ede288','2022-07-11 14:19:21','site');
/*!40000 ALTER TABLE `auth` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `buylist`
--

DROP TABLE IF EXISTS `buylist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `buylist` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'Код',
  `order_id` int DEFAULT NULL COMMENT 'Заказ',
  `count` int NOT NULL COMMENT 'Количество',
  `price` float NOT NULL COMMENT 'Цена',
  `cart_id` int DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Добавлено',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Обновлено',
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `buylist_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8mb3 COMMENT='История покупок';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buylist`
--

LOCK TABLES `buylist` WRITE;
/*!40000 ALTER TABLE `buylist` DISABLE KEYS */;
INSERT INTO `buylist` VALUES (81,49,3,540,248,'2022-06-16 22:23:10','2022-06-16 22:23:20'),(82,50,3,550,249,'2022-06-16 22:23:53','2022-06-16 22:25:13'),(83,50,1,170,250,'2022-06-16 22:25:01','2022-06-16 22:25:13'),(84,50,3,150,251,'2022-06-16 22:25:02','2022-06-16 22:25:13'),(85,50,1,100,252,'2022-06-16 22:25:05','2022-06-16 22:25:13'),(94,53,6,170,255,'2022-06-16 22:36:57','2022-07-03 19:24:07'),(95,53,10,140,256,'2022-06-16 22:40:12','2022-07-03 19:24:07'),(96,53,9,540,257,'2022-06-16 22:40:19','2022-07-03 19:24:07'),(97,53,1,100,268,'2022-07-03 19:08:08','2022-07-03 19:24:07'),(98,54,7,540,269,'2022-07-06 07:15:45','2022-07-09 16:39:52'),(99,54,4,550,270,'2022-07-06 07:19:20','2022-07-09 16:39:52'),(101,55,1,100,271,'2022-07-10 19:27:20','2022-07-10 19:27:30'),(102,55,1,100,272,'2022-07-10 19:27:21','2022-07-10 19:27:30'),(103,56,6,540,273,'2022-08-03 19:05:53','2022-08-03 19:08:33'),(104,56,5,550,274,'2022-08-03 19:05:55','2022-08-03 19:08:33');
/*!40000 ALTER TABLE `buylist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'Код товара',
  `user` int DEFAULT NULL COMMENT 'Покупатель',
  `count` int NOT NULL COMMENT 'Количество',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Добавлено',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Обновлено',
  `state` int DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `user` (`user`),
  CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`user`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=277 DEFAULT CHARSET=utf8mb3 COMMENT='Корзина';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
INSERT INTO `cart` VALUES (248,1,3,'2022-06-16 22:23:10','2022-06-16 22:23:11',-1),(249,1,3,'2022-06-16 22:23:53','2022-06-16 22:23:54',-1),(250,1,1,'2022-06-16 22:25:01','2022-06-16 22:25:01',-1),(251,1,3,'2022-06-16 22:25:02','2022-06-16 22:25:03',-1),(252,1,1,'2022-06-16 22:25:05','2022-06-16 22:25:05',-1),(255,1,6,'2022-06-16 22:36:57','2022-06-16 22:38:04',-1),(256,1,10,'2022-06-16 22:40:12','2022-06-16 22:40:15',-1),(257,1,9,'2022-06-16 22:40:19','2022-07-03 19:06:32',-1),(268,1,1,'2022-07-03 19:08:08','2022-07-03 19:08:08',-1),(269,1,7,'2022-07-06 07:15:45','2022-07-06 07:15:47',-1),(270,1,4,'2022-07-06 07:19:20','2022-07-06 07:19:21',-1),(271,1,1,'2022-07-10 19:27:20','2022-07-10 19:27:20',-1),(272,1,1,'2022-07-10 19:27:21','2022-07-10 19:27:21',-1),(273,1,6,'2022-08-03 19:05:53','2022-08-03 19:06:03',-1),(274,1,5,'2022-08-03 19:05:55','2022-08-03 19:05:59',-1),(275,1,7,'2022-08-03 19:12:30','2022-08-03 19:12:30',1),(276,1,1,'2022-08-03 19:12:32','2022-08-03 19:12:32',1);
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_addons`
--

DROP TABLE IF EXISTS `cart_addons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart_addons` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cart` int NOT NULL,
  `item_addon` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cart_addons_cart_id_fk` (`cart`),
  KEY `cart_addons_items_addons_id_fk` (`item_addon`),
  CONSTRAINT `cart_addons_cart_id_fk` FOREIGN KEY (`cart`) REFERENCES `cart` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `cart_addons_items_addons_id_fk` FOREIGN KEY (`item_addon`) REFERENCES `items_addons` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=152 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_addons`
--

LOCK TABLES `cart_addons` WRITE;
/*!40000 ALTER TABLE `cart_addons` DISABLE KEYS */;
INSERT INTO `cart_addons` VALUES (123,248,77),(124,249,80),(125,250,3),(126,251,81),(127,252,4),(130,255,3),(131,256,78),(132,257,77),(143,268,19),(144,269,77),(145,270,80),(146,271,17),(147,272,16),(148,273,77),(149,274,80),(150,275,80),(151,276,3);
/*!40000 ALTER TABLE `cart_addons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'Большие','19 литров'),(2,'Средние','5 - 10 литров'),(3,'Мелкие','0.5 - 1.5 литров');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_categories`
--

DROP TABLE IF EXISTS `item_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `item` int NOT NULL,
  `category` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Item_categories_items_id_fk` (`item`),
  KEY `Item_categories_category_id_fk` (`category`),
  CONSTRAINT `Item_categories_category_id_fk` FOREIGN KEY (`category`) REFERENCES `category` (`id`),
  CONSTRAINT `item_categories_items_id_fk` FOREIGN KEY (`item`) REFERENCES `items` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_categories`
--

LOCK TABLES `item_categories` WRITE;
/*!40000 ALTER TABLE `item_categories` DISABLE KEYS */;
INSERT INTO `item_categories` VALUES (1,9,3),(2,10,3),(3,11,3),(4,12,3),(5,13,3),(6,14,3),(7,15,3),(8,16,3),(9,4,2),(10,5,2),(11,6,2),(12,7,2),(13,8,2),(14,1,1),(15,2,1),(16,3,1);
/*!40000 ALTER TABLE `item_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `items`
--

DROP TABLE IF EXISTS `items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(2500) DEFAULT NULL,
  `price` float NOT NULL,
  `count` int NOT NULL,
  `weight` float NOT NULL COMMENT 'Вес',
  `unit` varchar(20) NOT NULL COMMENT 'Ед. измерения',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `image` varchar(150) DEFAULT NULL COMMENT 'Путь к изображению',
  `status` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8mb3 COMMENT='Товары';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `items`
--

LOCK TABLES `items` WRITE;
/*!40000 ALTER TABLE `items` DISABLE KEYS */;
INSERT INTO `items` VALUES (1,'Вода питьевая негазированная \"Донской Родник\"','Артезианская негазированная вода',140,55,19,'л.','2022-05-21 16:34:47','2022-06-28 20:51:51','d19_0.png',1),(2,'Вода питьевая негазированная \"Родничок\"','Артезианская негазированная вода',150,60,19,'л.','2022-05-21 16:42:19','2022-06-28 20:59:19','r19_0.png',1),(3,'Вода питьевая негазированная \"H₂O Элитная\"','Артезианская негазированная вода',170,80,19,'л.','2022-05-21 16:42:19','2022-06-28 21:07:30','19_0.png',1),(4,'Вода питьевая негазированная \"H₂O Элитная\"','Артезианская негазированная вода',100,99,5,'л.','2022-05-21 16:42:19','2022-05-25 06:59:12','5_0.png',1),(5,'Вода питьевая негазированная \"Донской Родник\"','Артезианская негазированная вода',100,99,5,'л.','2022-05-21 16:34:47','2022-06-28 21:34:21','d5_0.png',1),(6,'Вода питьевая негазированная \"Родничок\"','Артезианская негазированная вода',100,100,5,'л.','2022-05-21 16:42:19','2022-05-25 06:59:12','r5_0.png',1),(7,'Вода питьевая негазированная \"Донской Родник\"','Артезианская негазированная вода',100,100,10,'л.','2022-05-21 16:42:19','2022-05-25 06:59:12','d10_0.png',0),(8,'Вода питьевая негазированная \"H₂O Элитная\"','Артезианская негазированная вода',100,100,10,'л.','2022-05-21 16:42:19','2022-05-25 06:59:12','10_0.png',0),(9,'Вода питьевая негазированная \"H₂O Элитная\"','Артезианская негазированная вода',100,100,0.5,'л.','2022-05-21 16:42:19','2022-05-25 06:59:12','05_0png.png',-1),(10,'Вода питьевая газированная \"H₂O Элитная\"','Артезианская газированная вода',100,100,0.5,'л.','2022-05-21 16:42:19','2022-05-25 06:59:12','05_gas_0.png',-1),(11,'Вода питьевая газированная \"Донской Родник\"','Артезианская газированная вода',100,100,0.5,'л.','2022-05-21 16:42:19','2022-05-25 06:59:12','d05_gas0.png',-1),(12,'Вода питьевая негазированная \"Донской Родник\"','Артезианская негазированная вода',100,100,0.5,'л.','2022-05-21 16:42:19','2022-05-25 06:59:12','d05_0.png',-1),(13,'Вода питьевая негазированная \"Донской Родник\"','Артезианская негазированная вода',100,99,1.5,'л.','2022-05-21 16:42:19','2022-05-25 06:59:12','d15_0.png',1),(14,'Вода питьевая газированная \"Донской Родник\"','Артезианская газированная вода',100,99,1.5,'л.','2022-05-21 16:42:19','2022-05-25 06:59:12','d15_gas0.png',1),(15,'Вода питьевая газированная \"H₂O Элитная\"','Артезианская газированная вода',100,99,1.5,'л.','2022-05-21 16:42:19','2022-05-25 06:59:12','15_gas_0.png',1),(16,'Вода питьевая негазированная \"H₂O Элитная\"','Артезианская негазированная вода',100,99,1.5,'л.','2022-05-21 16:42:19','2022-05-25 06:59:12','15_0.png',1);
/*!40000 ALTER TABLE `items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `items_addons`
--

DROP TABLE IF EXISTS `items_addons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `items_addons` (
  `id` int NOT NULL AUTO_INCREMENT,
  `item` int NOT NULL,
  `addon` int DEFAULT NULL,
  `type` varchar(10) DEFAULT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `items_addons_addons_id_fk` (`addon`),
  KEY `items_addons_items_id_fk` (`item`),
  CONSTRAINT `items_addons_addons_id_fk` FOREIGN KEY (`addon`) REFERENCES `addons` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `items_addons_items_id_fk` FOREIGN KEY (`item`) REFERENCES `items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `items_addons`
--

LOCK TABLES `items_addons` WRITE;
/*!40000 ALTER TABLE `items_addons` DISABLE KEYS */;
INSERT INTO `items_addons` VALUES (3,3,3,'radio',1),(4,4,1,'radio',1),(5,5,1,'radio',1),(8,3,2,'radio',1),(9,6,1,'radio',1),(10,7,1,'radio',1),(11,8,1,'radio',1),(12,9,1,'radio',1),(13,10,1,'radio',1),(14,11,1,'radio',1),(15,12,1,'radio',1),(16,13,1,'radio',1),(17,14,1,'radio',1),(18,15,1,'radio',1),(19,16,1,'radio',1),(77,1,2,'radio',3),(78,1,3,'radio',3),(80,2,2,'radio',1),(81,2,3,'radio',1);
/*!40000 ALTER TABLE `items_addons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `items_promotions`
--

DROP TABLE IF EXISTS `items_promotions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `items_promotions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `item` int DEFAULT NULL,
  `promotion` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `items_promotions_id_uindex` (`id`),
  KEY `items_promotions_discounts_id_fk` (`promotion`),
  KEY `items_promotions_items_addons_id_fk` (`item`),
  CONSTRAINT `items_promotions_discounts_id_fk` FOREIGN KEY (`promotion`) REFERENCES `promotions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `items_promotions_items_addons_id_fk` FOREIGN KEY (`item`) REFERENCES `items_addons` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `items_promotions`
--

LOCK TABLES `items_promotions` WRITE;
/*!40000 ALTER TABLE `items_promotions` DISABLE KEYS */;
INSERT INTO `items_promotions` VALUES (7,78,1),(9,77,1),(10,77,4),(11,3,1),(12,3,4);
/*!40000 ALTER TABLE `items_promotions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `items_rating`
--

DROP TABLE IF EXISTS `items_rating`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `items_rating` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user` int NOT NULL,
  `item` int NOT NULL,
  `rating` smallint NOT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `rating_users_id_fk` (`user`),
  KEY `rating_items_id_fk` (`item`),
  CONSTRAINT `rating_items_id_fk` FOREIGN KEY (`item`) REFERENCES `items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `rating_users_id_fk` FOREIGN KEY (`user`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `items_rating`
--

LOCK TABLES `items_rating` WRITE;
/*!40000 ALTER TABLE `items_rating` DISABLE KEYS */;
INSERT INTO `items_rating` VALUES (8,1,1,5,'2022-06-15 18:25:34','2022-06-15 18:25:34'),(9,1,2,5,'2022-06-15 18:26:45','2022-06-15 18:26:45'),(10,1,3,5,'2022-06-15 18:26:47','2022-06-15 18:26:47'),(11,1,4,5,'2022-06-16 22:10:35','2022-06-16 22:10:35'),(14,1,16,5,'2022-07-03 19:07:52','2022-07-03 19:07:52');
/*!40000 ALTER TABLE `items_rating` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mail_templates`
--

DROP TABLE IF EXISTS `mail_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mail_templates` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `value` varchar(2000) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mail_templates_id_uindex` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mail_templates`
--

LOCK TABLES `mail_templates` WRITE;
/*!40000 ALTER TABLE `mail_templates` DISABLE KEYS */;
INSERT INTO `mail_templates` VALUES (1,'register-title','Регистрация прошла успешно'),(2,'register-message','На данный адрес электронной почты был зарегистрирован аккаунт на сайте {% url %}\n{% user->mail %}\n{% user->name %}\n{% user->pass %}');
/*!40000 ALTER TABLE `mail_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `message` varchar(5000) DEFAULT NULL,
  `send_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `user` int NOT NULL,
  `state` int DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `messages_id_uindex` (`id`),
  KEY `messages_users_id_fk` (`user`),
  CONSTRAINT `messages_users_id_fk` FOREIGN KEY (`user`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (28,'всем привет','2022-06-23 01:10:48',1,1),(29,'привет','2022-06-23 01:13:48',1,1),(31,'Привет','2022-07-03 22:40:08',1,1);
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages_read`
--

DROP TABLE IF EXISTS `messages_read`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `messages_read` (
  `id` int NOT NULL AUTO_INCREMENT,
  `message` int NOT NULL,
  `user` int NOT NULL,
  PRIMARY KEY (`message`,`user`),
  UNIQUE KEY `messages_read_id_uindex` (`id`),
  KEY `messages_read_users_id_fk` (`user`),
  CONSTRAINT `messages_read_messages_id_fk` FOREIGN KEY (`message`) REFERENCES `messages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `messages_read_users_id_fk` FOREIGN KEY (`user`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1547 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages_read`
--

LOCK TABLES `messages_read` WRITE;
/*!40000 ALTER TABLE `messages_read` DISABLE KEYS */;
/*!40000 ALTER TABLE `messages_read` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_state`
--

DROP TABLE IF EXISTS `order_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_state` (
  `id` int NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_state_id_uindex` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_state`
--

LOCK TABLES `order_state` WRITE;
/*!40000 ALTER TABLE `order_state` DISABLE KEYS */;
INSERT INTO `order_state` VALUES (-1,'Возникли проблемы'),(0,'Отменён'),(1,'Ожидает оплаты'),(2,'Заказ принят'),(3,'В пути'),(4,'Доставлен');
/*!40000 ALTER TABLE `order_state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'Код заказа',
  `user` int DEFAULT NULL COMMENT 'Заказчик',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Добавлено',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Обновлено',
  `price` float DEFAULT NULL,
  `discounts` float DEFAULT NULL,
  `take_date` datetime DEFAULT NULL,
  `address` int NOT NULL,
  `state` int NOT NULL DEFAULT '1',
  `comment` varchar(300) DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `user` (`user`),
  KEY `orders_order_state_id_fk` (`state`),
  KEY `orders_address_id_fk` (`address`),
  CONSTRAINT `orders_address_id_fk` FOREIGN KEY (`address`) REFERENCES `address` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `orders_order_state_id_fk` FOREIGN KEY (`state`) REFERENCES `order_state` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb3 COMMENT='Заказы';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (49,1,'2022-06-16 22:23:20','2022-06-16 22:23:20',1820,0,'2022-06-17 12:00:00',20,-1,''),(50,1,'2022-06-16 22:25:13','2022-06-16 22:25:13',2720,0,'2022-06-17 12:00:00',21,0,''),(53,1,'2022-07-03 19:24:07','2022-07-03 19:24:07',7216,364,'2022-07-04 12:00:00',25,3,''),(54,1,'2022-07-09 16:39:52','2022-07-09 16:39:52',5991,189,'2022-07-10 12:00:00',20,1,''),(55,1,'2022-07-10 19:27:30','2022-07-10 19:27:30',400,0,'2022-07-11 12:00:00',20,1,''),(56,1,'2022-08-03 19:08:33','2022-08-03 19:08:33',6028,162,'2022-08-04 12:00:00',20,1,'');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `promotions`
--

DROP TABLE IF EXISTS `promotions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promotions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(10) DEFAULT NULL,
  `name` varchar(30) DEFAULT NULL,
  `text` varchar(200) DEFAULT NULL,
  `size` float DEFAULT NULL,
  `worked_from_price` float DEFAULT NULL,
  `worked_from_count` int DEFAULT NULL,
  `worked_from_weight` float DEFAULT NULL,
  `worked_to_price` float DEFAULT NULL,
  `worked_to_count` int DEFAULT NULL,
  `worked_to_weight` float DEFAULT NULL,
  `worked_from_time` datetime DEFAULT NULL,
  `worked_to_time` datetime DEFAULT NULL,
  `state` int DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promotions`
--

LOCK TABLES `promotions` WRITE;
/*!40000 ALTER TABLE `promotions` DISABLE KEYS */;
INSERT INTO `promotions` VALUES (1,'%','Скидка от 2-х штук','При покупке от {% worked_from_count %} штук, цена снижается на {% size %}%',5,NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,1),(4,'%','Скидка от 5-х штук','При покупке от {% worked_from_count %} штук, цена снижается на {% size %}%',5,NULL,5,NULL,NULL,NULL,NULL,NULL,NULL,1);
/*!40000 ALTER TABLE `promotions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_params`
--

DROP TABLE IF EXISTS `site_params`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `site_params` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(30) DEFAULT NULL COMMENT 'Ключ',
  `value` varchar(300) DEFAULT NULL COMMENT 'Значение',
  `user` int DEFAULT NULL COMMENT 'Пользователь',
  PRIMARY KEY (`id`),
  KEY `user` (`user`),
  CONSTRAINT `site_params_ibfk_1` FOREIGN KEY (`user`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COMMENT='Параметры сайта';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_params`
--

LOCK TABLES `site_params` WRITE;
/*!40000 ALTER TABLE `site_params` DISABLE KEYS */;
INSERT INTO `site_params` VALUES (1,'product-count','10',NULL),(2,'image-404','icon-error.svg',NULL),(3,'image-path','/images/items/',NULL),(4,'title','Донской родник',NULL),(5,'phone','+7 (961) 290-08-08',NULL),(6,'mail','donskoy-rodnik@mail.ru',NULL);
/*!40000 ALTER TABLE `site_params` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `telegram_users`
--

DROP TABLE IF EXISTS `telegram_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `telegram_users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user` int NOT NULL,
  `tg_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user` (`user`),
  CONSTRAINT `telegram_users_ibfk_1` FOREIGN KEY (`user`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `telegram_users`
--

LOCK TABLES `telegram_users` WRITE;
/*!40000 ALTER TABLE `telegram_users` DISABLE KEYS */;
INSERT INTO `telegram_users` VALUES (11,1,2002282141);
/*!40000 ALTER TABLE `telegram_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_class`
--

DROP TABLE IF EXISTS `user_class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_class` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор',
  `name` varchar(50) DEFAULT NULL COMMENT 'Название',
  `auth_available` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COMMENT='Типы пользователей';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_class`
--

LOCK TABLES `user_class` WRITE;
/*!40000 ALTER TABLE `user_class` DISABLE KEYS */;
INSERT INTO `user_class` VALUES (1,'Разработчик',0),(2,'Администратор',0),(3,'Юридическое лицо',2),(4,'Физическое лицо',1),(5,'Гость',0),(6,'Заблокированный',0),(7,'Удаленный',0);
/*!40000 ALTER TABLE `user_class` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_history`
--

DROP TABLE IF EXISTS `user_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user` int DEFAULT NULL,
  `ip` varchar(15) NOT NULL,
  `time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `data` varchar(2500) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_history`
--

LOCK TABLES `user_history` WRITE;
/*!40000 ALTER TABLE `user_history` DISABLE KEYS */;
INSERT INTO `user_history` VALUES (1,NULL,'::1','2022-08-04 00:56:54','{\"DOCUMENT_ROOT\":\"E:\\Projects\\Sites\\donrod-project\",\"REMOTE_ADDR\":\"::1\",\"REMOTE_PORT\":\"10090\",\"SERVER_SOFTWARE\":\"PHP 8.1.5 Development Server\",\"SERVER_PROTOCOL\":\"HTTP/1.1\",\"SERVER_NAME\":\"localhost\",\"SERVER_PORT\":\"39153\",\"REQUEST_URI\":\"/api/users/auth.php\",\"REQUEST_METHOD\":\"GET\",\"SCRIPT_NAME\":\"/api/users/auth.php\",\"SCRIPT_FILENAME\":\"E:\\Projects\\Sites\\donrod-project\\api\\users\\auth.php\",\"PHP_SELF\":\"/api/users/auth.php\",\"HTTP_HOST\":\"localhost:39153\",\"HTTP_CONNECTION\":\"keep-alive\",\"HTTP_PRAGMA\":\"no-cache\",\"HTTP_CACHE_CONTROL\":\"no-cache\",\"HTTP_SEC_CH_UA\":\"\" Not A;Brand\";v=\"99\", \"Chromium\";v=\"102\", \"Yandex\";v=\"22\"\",\"HTTP_DNT\":\"1\",\"HTTP_SEC_CH_UA_MOBILE\":\"?0\",\"HTTP_USER_AGENT\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.134 YaBrowser/22.7.1.806 Yowser/2.5 Safari/537.36\",\"HTTP_SEC_CH_UA_PLATFORM\":\"\"Windows\"\",\"HTTP_ACCEPT\":\"*/*\",\"HTTP_SEC_FETCH_SITE\":\"same-origin\",\"HTTP_SEC_FETCH_MODE\":\"cors\",\"HTTP_SEC_FETCH_DEST\":\"empty\",\"HTTP_REFERER\":\"http://localhost:39153/pages\",\"HTTP_ACCEPT_ENCODING\":\"gzip, deflate, br\",\"HTTP_ACCEPT_LANGUAGE\":\"ru,en;q=0.9\",\"HTTP_COOKIE\":\"auth_token=8ab8911dd109918a0cb9f14d106237c4\",\"REQUEST_TIME_FLOAT\":1659563814.069738,\"REQUEST_TIME\":1659563814}'),(2,NULL,'::1','2022-08-04 00:56:54','{\"DOCUMENT_ROOT\":\"E:\\Projects\\Sites\\donrod-project\",\"REMOTE_ADDR\":\"::1\",\"REMOTE_PORT\":\"10092\",\"SERVER_SOFTWARE\":\"PHP 8.1.5 Development Server\",\"SERVER_PROTOCOL\":\"HTTP/1.1\",\"SERVER_NAME\":\"localhost\",\"SERVER_PORT\":\"39153\",\"REQUEST_URI\":\"/api/items/list.php?categories\",\"REQUEST_METHOD\":\"GET\",\"SCRIPT_NAME\":\"/api/items/list.php\",\"SCRIPT_FILENAME\":\"E:\\Projects\\Sites\\donrod-project\\api\\items\\list.php\",\"PHP_SELF\":\"/api/items/list.php\",\"QUERY_STRING\":\"categories\",\"HTTP_HOST\":\"localhost:39153\",\"HTTP_CONNECTION\":\"keep-alive\",\"HTTP_PRAGMA\":\"no-cache\",\"HTTP_CACHE_CONTROL\":\"no-cache\",\"HTTP_SEC_CH_UA\":\"\" Not A;Brand\";v=\"99\", \"Chromium\";v=\"102\", \"Yandex\";v=\"22\"\",\"HTTP_DNT\":\"1\",\"HTTP_SEC_CH_UA_MOBILE\":\"?0\",\"HTTP_USER_AGENT\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.134 YaBrowser/22.7.1.806 Yowser/2.5 Safari/537.36\",\"HTTP_SEC_CH_UA_PLATFORM\":\"\"Windows\"\",\"HTTP_ACCEPT\":\"*/*\",\"HTTP_SEC_FETCH_SITE\":\"same-origin\",\"HTTP_SEC_FETCH_MODE\":\"cors\",\"HTTP_SEC_FETCH_DEST\":\"empty\",\"HTTP_REFERER\":\"http://localhost:39153/pages\",\"HTTP_ACCEPT_ENCODING\":\"gzip, deflate, br\",\"HTTP_ACCEPT_LANGUAGE\":\"ru,en;q=0.9\",\"HTTP_COOKIE\":\"auth_token=8ab8911dd109918a0cb9f14d106237c4\",\"REQUEST_TIME_FLOAT\":1659563814.094379,\"REQUEST_TIME\":1659563814}'),(3,NULL,'::1','2022-08-04 00:56:54','{\"DOCUMENT_ROOT\":\"E:\\Projects\\Sites\\donrod-project\",\"REMOTE_ADDR\":\"::1\",\"REMOTE_PORT\":\"10094\",\"SERVER_SOFTWARE\":\"PHP 8.1.5 Development Server\",\"SERVER_PROTOCOL\":\"HTTP/1.1\",\"SERVER_NAME\":\"localhost\",\"SERVER_PORT\":\"39153\",\"REQUEST_URI\":\"/api/items/list.php?show-all&category=1&cart=false\",\"REQUEST_METHOD\":\"GET\",\"SCRIPT_NAME\":\"/api/items/list.php\",\"SCRIPT_FILENAME\":\"E:\\Projects\\Sites\\donrod-project\\api\\items\\list.php\",\"PHP_SELF\":\"/api/items/list.php\",\"QUERY_STRING\":\"show-all&category=1&cart=false\",\"HTTP_HOST\":\"localhost:39153\",\"HTTP_CONNECTION\":\"keep-alive\",\"HTTP_PRAGMA\":\"no-cache\",\"HTTP_CACHE_CONTROL\":\"no-cache\",\"HTTP_SEC_CH_UA\":\"\" Not A;Brand\";v=\"99\", \"Chromium\";v=\"102\", \"Yandex\";v=\"22\"\",\"HTTP_DNT\":\"1\",\"HTTP_SEC_CH_UA_MOBILE\":\"?0\",\"HTTP_USER_AGENT\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.134 YaBrowser/22.7.1.806 Yowser/2.5 Safari/537.36\",\"HTTP_SEC_CH_UA_PLATFORM\":\"\"Windows\"\",\"HTTP_ACCEPT\":\"*/*\",\"HTTP_SEC_FETCH_SITE\":\"same-origin\",\"HTTP_SEC_FETCH_MODE\":\"cors\",\"HTTP_SEC_FETCH_DEST\":\"empty\",\"HTTP_REFERER\":\"http://localhost:39153/pages\",\"HTTP_ACCEPT_ENCODING\":\"gzip, deflate, br\",\"HTTP_ACCEPT_LANGUAGE\":\"ru,en;q=0.9\",\"HTTP_COOKIE\":\"auth_token=8ab8911dd109918a0cb9f14d106237c4\",\"REQUEST_TIME_FLOAT\":1659563814.111414,\"REQUEST_TIME\":1659563814}'),(4,NULL,'::1','2022-08-04 00:56:54','{\"DOCUMENT_ROOT\":\"E:\\Projects\\Sites\\donrod-project\",\"REMOTE_ADDR\":\"::1\",\"REMOTE_PORT\":\"10101\",\"SERVER_SOFTWARE\":\"PHP 8.1.5 Development Server\",\"SERVER_PROTOCOL\":\"HTTP/1.1\",\"SERVER_NAME\":\"localhost\",\"SERVER_PORT\":\"39153\",\"REQUEST_URI\":\"/api/items/list.php?show-all&category=2&cart=false\",\"REQUEST_METHOD\":\"GET\",\"SCRIPT_NAME\":\"/api/items/list.php\",\"SCRIPT_FILENAME\":\"E:\\Projects\\Sites\\donrod-project\\api\\items\\list.php\",\"PHP_SELF\":\"/api/items/list.php\",\"QUERY_STRING\":\"show-all&category=2&cart=false\",\"HTTP_HOST\":\"localhost:39153\",\"HTTP_CONNECTION\":\"keep-alive\",\"HTTP_PRAGMA\":\"no-cache\",\"HTTP_CACHE_CONTROL\":\"no-cache\",\"HTTP_SEC_CH_UA\":\"\" Not A;Brand\";v=\"99\", \"Chromium\";v=\"102\", \"Yandex\";v=\"22\"\",\"HTTP_DNT\":\"1\",\"HTTP_SEC_CH_UA_MOBILE\":\"?0\",\"HTTP_USER_AGENT\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.134 YaBrowser/22.7.1.806 Yowser/2.5 Safari/537.36\",\"HTTP_SEC_CH_UA_PLATFORM\":\"\"Windows\"\",\"HTTP_ACCEPT\":\"*/*\",\"HTTP_SEC_FETCH_SITE\":\"same-origin\",\"HTTP_SEC_FETCH_MODE\":\"cors\",\"HTTP_SEC_FETCH_DEST\":\"empty\",\"HTTP_REFERER\":\"http://localhost:39153/pages\",\"HTTP_ACCEPT_ENCODING\":\"gzip, deflate, br\",\"HTTP_ACCEPT_LANGUAGE\":\"ru,en;q=0.9\",\"HTTP_COOKIE\":\"auth_token=8ab8911dd109918a0cb9f14d106237c4\",\"REQUEST_TIME_FLOAT\":1659563814.150372,\"REQUEST_TIME\":1659563814}'),(5,NULL,'::1','2022-08-04 00:56:54','{\"DOCUMENT_ROOT\":\"E:\\Projects\\Sites\\donrod-project\",\"REMOTE_ADDR\":\"::1\",\"REMOTE_PORT\":\"10104\",\"SERVER_SOFTWARE\":\"PHP 8.1.5 Development Server\",\"SERVER_PROTOCOL\":\"HTTP/1.1\",\"SERVER_NAME\":\"localhost\",\"SERVER_PORT\":\"39153\",\"REQUEST_URI\":\"/api/items/list.php?show-all&category=3&cart=false\",\"REQUEST_METHOD\":\"GET\",\"SCRIPT_NAME\":\"/api/items/list.php\",\"SCRIPT_FILENAME\":\"E:\\Projects\\Sites\\donrod-project\\api\\items\\list.php\",\"PHP_SELF\":\"/api/items/list.php\",\"QUERY_STRING\":\"show-all&category=3&cart=false\",\"HTTP_HOST\":\"localhost:39153\",\"HTTP_CONNECTION\":\"keep-alive\",\"HTTP_PRAGMA\":\"no-cache\",\"HTTP_CACHE_CONTROL\":\"no-cache\",\"HTTP_SEC_CH_UA\":\"\" Not A;Brand\";v=\"99\", \"Chromium\";v=\"102\", \"Yandex\";v=\"22\"\",\"HTTP_DNT\":\"1\",\"HTTP_SEC_CH_UA_MOBILE\":\"?0\",\"HTTP_USER_AGENT\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.134 YaBrowser/22.7.1.806 Yowser/2.5 Safari/537.36\",\"HTTP_SEC_CH_UA_PLATFORM\":\"\"Windows\"\",\"HTTP_ACCEPT\":\"*/*\",\"HTTP_SEC_FETCH_SITE\":\"same-origin\",\"HTTP_SEC_FETCH_MODE\":\"cors\",\"HTTP_SEC_FETCH_DEST\":\"empty\",\"HTTP_REFERER\":\"http://localhost:39153/pages\",\"HTTP_ACCEPT_ENCODING\":\"gzip, deflate, br\",\"HTTP_ACCEPT_LANGUAGE\":\"ru,en;q=0.9\",\"HTTP_COOKIE\":\"auth_token=8ab8911dd109918a0cb9f14d106237c4\",\"REQUEST_TIME_FLOAT\":1659563814.204713,\"REQUEST_TIME\":1659563814}'),(6,NULL,'::1','2022-08-04 00:56:55','{\"DOCUMENT_ROOT\":\"E:\\Projects\\Sites\\donrod-project\",\"REMOTE_ADDR\":\"::1\",\"REMOTE_PORT\":\"10114\",\"SERVER_SOFTWARE\":\"PHP 8.1.5 Development Server\",\"SERVER_PROTOCOL\":\"HTTP/1.1\",\"SERVER_NAME\":\"localhost\",\"SERVER_PORT\":\"39153\",\"REQUEST_URI\":\"/api/users/get-class.php\",\"REQUEST_METHOD\":\"GET\",\"SCRIPT_NAME\":\"/api/users/get-class.php\",\"SCRIPT_FILENAME\":\"E:\\Projects\\Sites\\donrod-project\\api\\users\\get-class.php\",\"PHP_SELF\":\"/api/users/get-class.php\",\"HTTP_HOST\":\"localhost:39153\",\"HTTP_CONNECTION\":\"keep-alive\",\"HTTP_PRAGMA\":\"no-cache\",\"HTTP_CACHE_CONTROL\":\"no-cache\",\"HTTP_SEC_CH_UA\":\"\" Not A;Brand\";v=\"99\", \"Chromium\";v=\"102\", \"Yandex\";v=\"22\"\",\"HTTP_DNT\":\"1\",\"HTTP_SEC_CH_UA_MOBILE\":\"?0\",\"HTTP_USER_AGENT\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.134 YaBrowser/22.7.1.806 Yowser/2.5 Safari/537.36\",\"HTTP_SEC_CH_UA_PLATFORM\":\"\"Windows\"\",\"HTTP_ACCEPT\":\"*/*\",\"HTTP_SEC_FETCH_SITE\":\"same-origin\",\"HTTP_SEC_FETCH_MODE\":\"cors\",\"HTTP_SEC_FETCH_DEST\":\"empty\",\"HTTP_REFERER\":\"http://localhost:39153/pages\",\"HTTP_ACCEPT_ENCODING\":\"gzip, deflate, br\",\"HTTP_ACCEPT_LANGUAGE\":\"ru,en;q=0.9\",\"HTTP_COOKIE\":\"auth_token=8ab8911dd109918a0cb9f14d106237c4\",\"REQUEST_TIME_FLOAT\":1659563815.911783,\"REQUEST_TIME\":1659563815}'),(7,NULL,'::1','2022-08-04 00:56:56','{\"DOCUMENT_ROOT\":\"E:\\Projects\\Sites\\donrod-project\",\"REMOTE_ADDR\":\"::1\",\"REMOTE_PORT\":\"10119\",\"SERVER_SOFTWARE\":\"PHP 8.1.5 Development Server\",\"SERVER_PROTOCOL\":\"HTTP/1.1\",\"SERVER_NAME\":\"localhost\",\"SERVER_PORT\":\"39153\",\"REQUEST_URI\":\"/api/items/list.php?show-all&cart=true\",\"REQUEST_METHOD\":\"GET\",\"SCRIPT_NAME\":\"/api/items/list.php\",\"SCRIPT_FILENAME\":\"E:\\Projects\\Sites\\donrod-project\\api\\items\\list.php\",\"PHP_SELF\":\"/api/items/list.php\",\"QUERY_STRING\":\"show-all&cart=true\",\"HTTP_HOST\":\"localhost:39153\",\"HTTP_CONNECTION\":\"keep-alive\",\"HTTP_PRAGMA\":\"no-cache\",\"HTTP_CACHE_CONTROL\":\"no-cache\",\"HTTP_SEC_CH_UA\":\"\" Not A;Brand\";v=\"99\", \"Chromium\";v=\"102\", \"Yandex\";v=\"22\"\",\"HTTP_DNT\":\"1\",\"HTTP_SEC_CH_UA_MOBILE\":\"?0\",\"HTTP_USER_AGENT\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.134 YaBrowser/22.7.1.806 Yowser/2.5 Safari/537.36\",\"HTTP_SEC_CH_UA_PLATFORM\":\"\"Windows\"\",\"HTTP_ACCEPT\":\"*/*\",\"HTTP_SEC_FETCH_SITE\":\"same-origin\",\"HTTP_SEC_FETCH_MODE\":\"cors\",\"HTTP_SEC_FETCH_DEST\":\"empty\",\"HTTP_REFERER\":\"http://localhost:39153/pages\",\"HTTP_ACCEPT_ENCODING\":\"gzip, deflate, br\",\"HTTP_ACCEPT_LANGUAGE\":\"ru,en;q=0.9\",\"HTTP_COOKIE\":\"auth_token=8ab8911dd109918a0cb9f14d106237c4\",\"REQUEST_TIME_FLOAT\":1659563816.56162,\"REQUEST_TIME\":1659563816}'),(8,NULL,'::1','2022-08-05 20:49:22','{\"DOCUMENT_ROOT\":\"E:\\Projects\\Sites\\donrod-project\",\"REMOTE_ADDR\":\"::1\",\"REMOTE_PORT\":\"9590\",\"SERVER_SOFTWARE\":\"PHP 8.1.5 Development Server\",\"SERVER_PROTOCOL\":\"HTTP/1.1\",\"SERVER_NAME\":\"localhost\",\"SERVER_PORT\":\"39153\",\"REQUEST_URI\":\"/api/users/auth.php\",\"REQUEST_METHOD\":\"GET\",\"SCRIPT_NAME\":\"/api/users/auth.php\",\"SCRIPT_FILENAME\":\"E:\\Projects\\Sites\\donrod-project\\api\\users\\auth.php\",\"PHP_SELF\":\"/api/users/auth.php\",\"HTTP_HOST\":\"localhost:39153\",\"HTTP_CONNECTION\":\"keep-alive\",\"HTTP_SEC_CH_UA\":\"\" Not A;Brand\";v=\"99\", \"Chromium\";v=\"102\", \"Yandex\";v=\"22\"\",\"HTTP_DNT\":\"1\",\"HTTP_SEC_CH_UA_MOBILE\":\"?0\",\"HTTP_USER_AGENT\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.148 YaBrowser/22.7.2.899 Yowser/2.5 Safari/537.36\",\"HTTP_SEC_CH_UA_PLATFORM\":\"\"Windows\"\",\"HTTP_ACCEPT\":\"*/*\",\"HTTP_SEC_FETCH_SITE\":\"same-origin\",\"HTTP_SEC_FETCH_MODE\":\"cors\",\"HTTP_SEC_FETCH_DEST\":\"empty\",\"HTTP_REFERER\":\"http://localhost:39153/pages\",\"HTTP_ACCEPT_ENCODING\":\"gzip, deflate, br\",\"HTTP_ACCEPT_LANGUAGE\":\"ru,en;q=0.9\",\"HTTP_COOKIE\":\"auth_token=8ab8911dd109918a0cb9f14d106237c4\",\"REQUEST_TIME_FLOAT\":1659721761.381989,\"REQUEST_TIME\":1659721761}'),(9,NULL,'::1','2022-08-05 20:49:23','{\"DOCUMENT_ROOT\":\"E:\\Projects\\Sites\\donrod-project\",\"REMOTE_ADDR\":\"::1\",\"REMOTE_PORT\":\"9594\",\"SERVER_SOFTWARE\":\"PHP 8.1.5 Development Server\",\"SERVER_PROTOCOL\":\"HTTP/1.1\",\"SERVER_NAME\":\"localhost\",\"SERVER_PORT\":\"39153\",\"REQUEST_URI\":\"/api/items/list.php?categories\",\"REQUEST_METHOD\":\"GET\",\"SCRIPT_NAME\":\"/api/items/list.php\",\"SCRIPT_FILENAME\":\"E:\\Projects\\Sites\\donrod-project\\api\\items\\list.php\",\"PHP_SELF\":\"/api/items/list.php\",\"QUERY_STRING\":\"categories\",\"HTTP_HOST\":\"localhost:39153\",\"HTTP_CONNECTION\":\"keep-alive\",\"HTTP_SEC_CH_UA\":\"\" Not A;Brand\";v=\"99\", \"Chromium\";v=\"102\", \"Yandex\";v=\"22\"\",\"HTTP_DNT\":\"1\",\"HTTP_SEC_CH_UA_MOBILE\":\"?0\",\"HTTP_USER_AGENT\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.148 YaBrowser/22.7.2.899 Yowser/2.5 Safari/537.36\",\"HTTP_SEC_CH_UA_PLATFORM\":\"\"Windows\"\",\"HTTP_ACCEPT\":\"*/*\",\"HTTP_SEC_FETCH_SITE\":\"same-origin\",\"HTTP_SEC_FETCH_MODE\":\"cors\",\"HTTP_SEC_FETCH_DEST\":\"empty\",\"HTTP_REFERER\":\"http://localhost:39153/pages\",\"HTTP_ACCEPT_ENCODING\":\"gzip, deflate, br\",\"HTTP_ACCEPT_LANGUAGE\":\"ru,en;q=0.9\",\"HTTP_COOKIE\":\"auth_token=8ab8911dd109918a0cb9f14d106237c4\",\"REQUEST_TIME_FLOAT\":1659721763.060578,\"REQUEST_TIME\":1659721763}'),(10,NULL,'::1','2022-08-05 20:49:23','{\"DOCUMENT_ROOT\":\"E:\\Projects\\Sites\\donrod-project\",\"REMOTE_ADDR\":\"::1\",\"REMOTE_PORT\":\"9596\",\"SERVER_SOFTWARE\":\"PHP 8.1.5 Development Server\",\"SERVER_PROTOCOL\":\"HTTP/1.1\",\"SERVER_NAME\":\"localhost\",\"SERVER_PORT\":\"39153\",\"REQUEST_URI\":\"/api/items/list.php?show-all&category=1&cart=false\",\"REQUEST_METHOD\":\"GET\",\"SCRIPT_NAME\":\"/api/items/list.php\",\"SCRIPT_FILENAME\":\"E:\\Projects\\Sites\\donrod-project\\api\\items\\list.php\",\"PHP_SELF\":\"/api/items/list.php\",\"QUERY_STRING\":\"show-all&category=1&cart=false\",\"HTTP_HOST\":\"localhost:39153\",\"HTTP_CONNECTION\":\"keep-alive\",\"HTTP_SEC_CH_UA\":\"\" Not A;Brand\";v=\"99\", \"Chromium\";v=\"102\", \"Yandex\";v=\"22\"\",\"HTTP_DNT\":\"1\",\"HTTP_SEC_CH_UA_MOBILE\":\"?0\",\"HTTP_USER_AGENT\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.148 YaBrowser/22.7.2.899 Yowser/2.5 Safari/537.36\",\"HTTP_SEC_CH_UA_PLATFORM\":\"\"Windows\"\",\"HTTP_ACCEPT\":\"*/*\",\"HTTP_SEC_FETCH_SITE\":\"same-origin\",\"HTTP_SEC_FETCH_MODE\":\"cors\",\"HTTP_SEC_FETCH_DEST\":\"empty\",\"HTTP_REFERER\":\"http://localhost:39153/pages\",\"HTTP_ACCEPT_ENCODING\":\"gzip, deflate, br\",\"HTTP_ACCEPT_LANGUAGE\":\"ru,en;q=0.9\",\"HTTP_COOKIE\":\"auth_token=8ab8911dd109918a0cb9f14d106237c4\",\"REQUEST_TIME_FLOAT\":1659721763.110431,\"REQUEST_TIME\":1659721763}'),(11,NULL,'::1','2022-08-05 20:49:23','{\"DOCUMENT_ROOT\":\"E:\\Projects\\Sites\\donrod-project\",\"REMOTE_ADDR\":\"::1\",\"REMOTE_PORT\":\"9602\",\"SERVER_SOFTWARE\":\"PHP 8.1.5 Development Server\",\"SERVER_PROTOCOL\":\"HTTP/1.1\",\"SERVER_NAME\":\"localhost\",\"SERVER_PORT\":\"39153\",\"REQUEST_URI\":\"/api/items/list.php?show-all&category=2&cart=false\",\"REQUEST_METHOD\":\"GET\",\"SCRIPT_NAME\":\"/api/items/list.php\",\"SCRIPT_FILENAME\":\"E:\\Projects\\Sites\\donrod-project\\api\\items\\list.php\",\"PHP_SELF\":\"/api/items/list.php\",\"QUERY_STRING\":\"show-all&category=2&cart=false\",\"HTTP_HOST\":\"localhost:39153\",\"HTTP_CONNECTION\":\"keep-alive\",\"HTTP_SEC_CH_UA\":\"\" Not A;Brand\";v=\"99\", \"Chromium\";v=\"102\", \"Yandex\";v=\"22\"\",\"HTTP_DNT\":\"1\",\"HTTP_SEC_CH_UA_MOBILE\":\"?0\",\"HTTP_USER_AGENT\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.148 YaBrowser/22.7.2.899 Yowser/2.5 Safari/537.36\",\"HTTP_SEC_CH_UA_PLATFORM\":\"\"Windows\"\",\"HTTP_ACCEPT\":\"*/*\",\"HTTP_SEC_FETCH_SITE\":\"same-origin\",\"HTTP_SEC_FETCH_MODE\":\"cors\",\"HTTP_SEC_FETCH_DEST\":\"empty\",\"HTTP_REFERER\":\"http://localhost:39153/pages\",\"HTTP_ACCEPT_ENCODING\":\"gzip, deflate, br\",\"HTTP_ACCEPT_LANGUAGE\":\"ru,en;q=0.9\",\"HTTP_COOKIE\":\"auth_token=8ab8911dd109918a0cb9f14d106237c4\",\"REQUEST_TIME_FLOAT\":1659721763.368364,\"REQUEST_TIME\":1659721763}'),(12,NULL,'::1','2022-08-05 20:49:23','{\"DOCUMENT_ROOT\":\"E:\\Projects\\Sites\\donrod-project\",\"REMOTE_ADDR\":\"::1\",\"REMOTE_PORT\":\"9605\",\"SERVER_SOFTWARE\":\"PHP 8.1.5 Development Server\",\"SERVER_PROTOCOL\":\"HTTP/1.1\",\"SERVER_NAME\":\"localhost\",\"SERVER_PORT\":\"39153\",\"REQUEST_URI\":\"/api/items/list.php?show-all&category=3&cart=false\",\"REQUEST_METHOD\":\"GET\",\"SCRIPT_NAME\":\"/api/items/list.php\",\"SCRIPT_FILENAME\":\"E:\\Projects\\Sites\\donrod-project\\api\\items\\list.php\",\"PHP_SELF\":\"/api/items/list.php\",\"QUERY_STRING\":\"show-all&category=3&cart=false\",\"HTTP_HOST\":\"localhost:39153\",\"HTTP_CONNECTION\":\"keep-alive\",\"HTTP_SEC_CH_UA\":\"\" Not A;Brand\";v=\"99\", \"Chromium\";v=\"102\", \"Yandex\";v=\"22\"\",\"HTTP_DNT\":\"1\",\"HTTP_SEC_CH_UA_MOBILE\":\"?0\",\"HTTP_USER_AGENT\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.148 YaBrowser/22.7.2.899 Yowser/2.5 Safari/537.36\",\"HTTP_SEC_CH_UA_PLATFORM\":\"\"Windows\"\",\"HTTP_ACCEPT\":\"*/*\",\"HTTP_SEC_FETCH_SITE\":\"same-origin\",\"HTTP_SEC_FETCH_MODE\":\"cors\",\"HTTP_SEC_FETCH_DEST\":\"empty\",\"HTTP_REFERER\":\"http://localhost:39153/pages\",\"HTTP_ACCEPT_ENCODING\":\"gzip, deflate, br\",\"HTTP_ACCEPT_LANGUAGE\":\"ru,en;q=0.9\",\"HTTP_COOKIE\":\"auth_token=8ab8911dd109918a0cb9f14d106237c4\",\"REQUEST_TIME_FLOAT\":1659721763.419074,\"REQUEST_TIME\":1659721763}'),(13,NULL,'::1','2022-08-05 20:49:24','{\"DOCUMENT_ROOT\":\"E:\\Projects\\Sites\\donrod-project\",\"REMOTE_ADDR\":\"::1\",\"REMOTE_PORT\":\"9614\",\"SERVER_SOFTWARE\":\"PHP 8.1.5 Development Server\",\"SERVER_PROTOCOL\":\"HTTP/1.1\",\"SERVER_NAME\":\"localhost\",\"SERVER_PORT\":\"39153\",\"REQUEST_URI\":\"/api/users/get-class.php\",\"REQUEST_METHOD\":\"GET\",\"SCRIPT_NAME\":\"/api/users/get-class.php\",\"SCRIPT_FILENAME\":\"E:\\Projects\\Sites\\donrod-project\\api\\users\\get-class.php\",\"PHP_SELF\":\"/api/users/get-class.php\",\"HTTP_HOST\":\"localhost:39153\",\"HTTP_CONNECTION\":\"keep-alive\",\"HTTP_SEC_CH_UA\":\"\" Not A;Brand\";v=\"99\", \"Chromium\";v=\"102\", \"Yandex\";v=\"22\"\",\"HTTP_DNT\":\"1\",\"HTTP_SEC_CH_UA_MOBILE\":\"?0\",\"HTTP_USER_AGENT\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.148 YaBrowser/22.7.2.899 Yowser/2.5 Safari/537.36\",\"HTTP_SEC_CH_UA_PLATFORM\":\"\"Windows\"\",\"HTTP_ACCEPT\":\"*/*\",\"HTTP_SEC_FETCH_SITE\":\"same-origin\",\"HTTP_SEC_FETCH_MODE\":\"cors\",\"HTTP_SEC_FETCH_DEST\":\"empty\",\"HTTP_REFERER\":\"http://localhost:39153/pages\",\"HTTP_ACCEPT_ENCODING\":\"gzip, deflate, br\",\"HTTP_ACCEPT_LANGUAGE\":\"ru,en;q=0.9\",\"HTTP_COOKIE\":\"auth_token=8ab8911dd109918a0cb9f14d106237c4\",\"REQUEST_TIME_FLOAT\":1659721764.102927,\"REQUEST_TIME\":1659721764}'),(14,NULL,'::1','2022-08-05 20:49:25','{\"DOCUMENT_ROOT\":\"E:\\Projects\\Sites\\donrod-project\",\"REMOTE_ADDR\":\"::1\",\"REMOTE_PORT\":\"9620\",\"SERVER_SOFTWARE\":\"PHP 8.1.5 Development Server\",\"SERVER_PROTOCOL\":\"HTTP/1.1\",\"SERVER_NAME\":\"localhost\",\"SERVER_PORT\":\"39153\",\"REQUEST_URI\":\"/api/items/list.php?show-all&cart=true\",\"REQUEST_METHOD\":\"GET\",\"SCRIPT_NAME\":\"/api/items/list.php\",\"SCRIPT_FILENAME\":\"E:\\Projects\\Sites\\donrod-project\\api\\items\\list.php\",\"PHP_SELF\":\"/api/items/list.php\",\"QUERY_STRING\":\"show-all&cart=true\",\"HTTP_HOST\":\"localhost:39153\",\"HTTP_CONNECTION\":\"keep-alive\",\"HTTP_SEC_CH_UA\":\"\" Not A;Brand\";v=\"99\", \"Chromium\";v=\"102\", \"Yandex\";v=\"22\"\",\"HTTP_DNT\":\"1\",\"HTTP_SEC_CH_UA_MOBILE\":\"?0\",\"HTTP_USER_AGENT\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.148 YaBrowser/22.7.2.899 Yowser/2.5 Safari/537.36\",\"HTTP_SEC_CH_UA_PLATFORM\":\"\"Windows\"\",\"HTTP_ACCEPT\":\"*/*\",\"HTTP_SEC_FETCH_SITE\":\"same-origin\",\"HTTP_SEC_FETCH_MODE\":\"cors\",\"HTTP_SEC_FETCH_DEST\":\"empty\",\"HTTP_REFERER\":\"http://localhost:39153/pages\",\"HTTP_ACCEPT_ENCODING\":\"gzip, deflate, br\",\"HTTP_ACCEPT_LANGUAGE\":\"ru,en;q=0.9\",\"HTTP_COOKIE\":\"auth_token=8ab8911dd109918a0cb9f14d106237c4\",\"REQUEST_TIME_FLOAT\":1659721765.047676,\"REQUEST_TIME\":1659721765}'),(15,NULL,'::1','2022-08-05 20:52:10','\"/api/users/auth.php\"'),(16,NULL,'::1','2022-08-05 20:52:10','\"/api/items/list.php?categories\"'),(17,NULL,'::1','2022-08-05 20:52:10','\"/api/items/list.php?show-all&category=1&cart=false\"'),(18,NULL,'::1','2022-08-05 20:52:10','\"/api/items/list.php?show-all&category=2&cart=false\"'),(19,NULL,'::1','2022-08-05 20:52:10','\"/api/items/list.php?show-all&category=3&cart=false\"'),(20,1,'::1','2022-08-05 20:53:51','\"/api/users/auth.php\"'),(21,1,'::1','2022-08-05 20:53:51','\"/api/items/list.php?categories\"'),(22,1,'::1','2022-08-05 20:53:51','\"/api/items/list.php?show-all&category=1&cart=false\"'),(23,1,'::1','2022-08-05 20:53:51','\"/api/items/list.php?show-all&category=2&cart=false\"'),(24,1,'::1','2022-08-05 20:53:51','\"/api/items/list.php?show-all&category=3&cart=false\"'),(25,1,'::1','2022-08-05 22:05:14','\"/api/users/auth.php\"'),(26,1,'::1','2022-08-05 22:05:14','\"/api/items/list.php?categories\"'),(27,1,'::1','2022-08-05 22:05:14','\"/api/items/list.php?show-all&category=1&cart=false\"'),(28,1,'::1','2022-08-05 22:05:14','\"/api/items/list.php?show-all&category=2&cart=false\"'),(29,1,'::1','2022-08-05 22:05:14','\"/api/items/list.php?show-all&category=3&cart=false\"'),(30,1,'::1','2022-08-05 22:05:18','\"/api/users/get-class.php\"');
/*!40000 ALTER TABLE `user_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_information`
--

DROP TABLE IF EXISTS `user_information`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_information` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user` int NOT NULL,
  `name` varchar(30) NOT NULL,
  `value` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_information_id_uindex` (`id`),
  KEY `user_information_users_id_fk` (`user`),
  CONSTRAINT `user_information_users_id_fk` FOREIGN KEY (`user`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_information`
--

LOCK TABLES `user_information` WRITE;
/*!40000 ALTER TABLE `user_information` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_information` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_permission`
--

DROP TABLE IF EXISTS `user_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_permission` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор',
  `class` int NOT NULL COMMENT 'Класс пользователей',
  `name` varchar(30) NOT NULL COMMENT 'Название',
  `value` varchar(50) NOT NULL COMMENT 'Значение',
  PRIMARY KEY (`id`),
  KEY `user_permission_user_class_id_fk` (`class`),
  CONSTRAINT `user_permission_user_class_id_fk` FOREIGN KEY (`class`) REFERENCES `user_class` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Разрешения';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_permission`
--

LOCK TABLES `user_permission` WRITE;
/*!40000 ALTER TABLE `user_permission` DISABLE KEYS */;
INSERT INTO `user_permission` VALUES (1,1,'full','access'),(2,2,'items','read,write,add,delete,read-all'),(3,3,'items','read'),(4,4,'items','read'),(5,5,'items','read'),(7,2,'categories','read,write,add,delete'),(8,3,'categories','read'),(9,4,'categories','read'),(10,5,'categories','read'),(12,2,'orders','read,write,add,delete'),(13,3,'orders','read,add'),(14,4,'orders','read,add'),(16,2,'cart','read,write,add,delete'),(17,3,'cart','read,write,add,delete'),(18,4,'cart','read,write,add,delete'),(20,2,'messages','read,write,add,delete'),(22,2,'addons','read,write,add,delete'),(23,3,'addons','read'),(24,4,'addons','read'),(25,5,'addons','read'),(27,2,'crm','access'),(29,2,'rating','read,delete'),(30,3,'rating','add'),(31,4,'rating','add'),(33,2,'address','read,write,add,delete'),(34,3,'address','read,write,add,delete'),(35,4,'address','read,write,add,delete'),(36,2,'orders-all','read,write,add,delete');
/*!40000 ALTER TABLE `user_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) DEFAULT NULL,
  `mail` varchar(100) DEFAULT NULL,
  `pass` varchar(32) DEFAULT NULL,
  `class` int NOT NULL DEFAULT '4' COMMENT 'Тип пользователя',
  PRIMARY KEY (`id`),
  KEY `users_user_class_id_fk` (`class`),
  CONSTRAINT `users_user_class_id_fk` FOREIGN KEY (`class`) REFERENCES `user_class` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb3 COMMENT='Пользователи';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Абдулла','m.m.abdul@mail.ru','Test1234',1),(2,'Администратор','admin@mail.ru','Test1234',2),(3,'ООО \"Компания\"','support@company.ru','Test1234',3),(4,'Василий','vasiliy1983.v@mail.ru','Test1234',4);
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

-- Dump completed on 2022-08-05 22:05:32
