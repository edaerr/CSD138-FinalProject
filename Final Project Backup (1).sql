-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: midterm_icecream_db
-- ------------------------------------------------------
-- Server version	8.0.43

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
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `customer_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `status` varchar(10) NOT NULL DEFAULT 'ACTIVE',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `UQ_customers_email` (`email`),
  CONSTRAINT `CK_customers_status` CHECK ((`status` in (_utf8mb3'ACTIVE',_utf8mb3'INACTIVE')))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'Reza','Safari','reza.safari@example.com','206-555-1001','INACTIVE','2025-12-09 18:37:50'),(2,'Eda','Er','eda.er@example.com','206-555-1002','ACTIVE','2025-12-09 18:37:50'),(3,'Sam','Lee','sam.lee@example.com','206-555-1003','ACTIVE','2025-12-09 18:37:50'),(4,'Nora','Kim','nora.kim@example.com','206-555-1004','ACTIVE','2025-12-09 18:37:50'),(5,'Omar','Ali','omar.ali@example.com','206-555-1005','ACTIVE','2025-12-09 18:37:50'),(6,'Liam','Wright','liam.wright@example.com','206-555-1006','ACTIVE','2025-12-09 18:37:50'),(7,'Ella','Price','ella.price@example.com','206-555-1007','ACTIVE','2025-12-09 18:37:50'),(8,'Zoe','Rivera','zoe.rivera@example.com','206-555-1008','ACTIVE','2025-12-09 18:37:50'),(9,'Kai','Johnson','kai.johnson@example.com','206-555-1009','INACTIVE','2025-12-09 18:37:50'),(10,'Mila','Young','mila.young@example.com','206-555-1010','ACTIVE','2025-12-09 18:37:50');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `employee_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `role` varchar(20) NOT NULL,
  `hire_date` date NOT NULL,
  `hourly_rate` decimal(6,2) NOT NULL,
  PRIMARY KEY (`employee_id`),
  UNIQUE KEY `UQ_employees_email` (`email`),
  CONSTRAINT `CK_employees_pay` CHECK ((`hourly_rate` > 0)),
  CONSTRAINT `CK_employees_role` CHECK ((`role` in (_utf8mb3'CASHIER',_utf8mb3'MANAGER',_utf8mb3'STAFFER')))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
INSERT INTO `employees` VALUES (1,'Ava','Nguyen','ava.nguyen@sweetscoops.local','MANAGER','2023-01-10',28.50),(2,'Leo','Martinez','leo.martinez@sweetscoops.local','CASHIER','2024-03-02',20.25),(3,'Maya','Singh','maya.singh@sweetscoops.local','STAFFER','2024-04-15',18.75),(4,'Noah','Brooks','noah.brooks@sweetscoops.local','STAFFER','2024-05-21',18.25),(5,'Ivy','Chen','ivy.chen@sweetscoops.local','CASHIER','2024-06-05',19.50);
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `order_item_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  `unit_price` decimal(6,2) NOT NULL,
  PRIMARY KEY (`order_item_id`),
  UNIQUE KEY `UQ_order_items_order_product` (`order_id`,`product_id`),
  KEY `FK_order_items_products` (`product_id`),
  KEY `idx_order_items_order_product` (`order_id`,`product_id`),
  CONSTRAINT `FK_order_items_orders` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_order_items_products` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `CK_order_items_price` CHECK ((`unit_price` > 0)),
  CONSTRAINT `CK_order_items_qty` CHECK ((`quantity` between 1 and 20))
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (1,1,1,2,3.50),(2,1,6,1,1.25),(3,2,9,1,7.50),(4,3,10,1,6.95),(5,3,7,1,0.50),(6,4,11,1,5.25),(7,5,5,1,4.25),(8,5,6,1,1.25),(9,5,8,1,0.95),(10,6,12,1,4.95),(11,7,2,1,3.75),(12,7,6,1,1.25),(13,8,3,1,3.75),(14,8,7,1,0.50),(15,9,4,1,3.95),(16,10,10,1,6.95),(17,11,1,1,3.50),(18,11,8,1,0.95),(19,12,2,1,3.75);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `employee_id` int NOT NULL,
  `order_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(12) NOT NULL DEFAULT 'NEW',
  PRIMARY KEY (`order_id`),
  KEY `idx_orders_customer_id` (`customer_id`),
  KEY `idx_orders_employee_id` (`employee_id`),
  CONSTRAINT `FK_orders_customers` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `FK_orders_employees` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `CK_orders_status` CHECK ((`status` in (_utf8mb4'NEW',_utf8mb4'PAID',_utf8mb4'CANCELLED')))
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,1,1,'2025-10-01 13:05:00','PAID'),(2,2,2,'2025-10-01 13:10:00','PAID'),(3,3,2,'2025-10-02 11:00:00','PAID'),(4,4,3,'2025-10-02 19:15:00','PAID'),(5,5,4,'2025-10-03 12:40:00','PAID'),(6,6,5,'2025-10-03 20:20:00','PAID'),(7,7,2,'2025-10-04 14:55:00','PAID'),(8,8,3,'2025-10-04 15:05:00','PAID'),(9,9,4,'2025-10-05 10:20:00','CANCELLED'),(10,10,5,'2025-10-05 16:45:00','PAID'),(11,1,2,'2025-10-06 12:30:00','PAID'),(12,2,1,'2025-10-06 12:45:00','NEW');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  `category` varchar(30) NOT NULL,
  `price` decimal(6,2) NOT NULL,
  `is_active` tinyint NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`),
  UNIQUE KEY `UQ_products_name` (`name`),
  KEY `idx_products_category` (`category`),
  CONSTRAINT `CK_products_price` CHECK ((`price` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'Vanilla Scoop','Scoop',3.50,1,'2025-12-09 18:37:50'),(2,'Chocolate Scoop','Scoop',3.75,1,'2025-12-09 18:37:50'),(3,'Strawberry Scoop','Scoop',3.75,1,'2025-12-09 18:37:50'),(4,'Mint Chip Scoop','Scoop',3.95,1,'2025-12-09 18:37:50'),(5,'Cookie Dough Scoop','Scoop',4.25,1,'2025-12-09 18:37:50'),(6,'Waffle Cone','AddOn',1.25,1,'2025-12-09 18:37:50'),(7,'Sprinkles','AddOn',0.50,1,'2025-12-09 18:37:50'),(8,'Hot Fudge','AddOn',0.95,1,'2025-12-09 18:37:50'),(9,'Banana Split','Sundae',7.50,1,'2025-12-09 18:37:50'),(10,'Brownie Sundae','Sundae',6.95,1,'2025-12-09 18:37:50'),(11,'Milkshake Vanilla','Drink',5.25,1,'2025-12-09 18:37:50'),(12,'Affogato','Drink',4.95,1,'2025-12-09 18:37:50');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_active_customers`
--

DROP TABLE IF EXISTS `vw_active_customers`;
/*!50001 DROP VIEW IF EXISTS `vw_active_customers`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_active_customers` AS SELECT 
 1 AS `customer_id`,
 1 AS `first_name`,
 1 AS `last_name`,
 1 AS `status`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vw_active_customers`
--

/*!50001 DROP VIEW IF EXISTS `vw_active_customers`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_active_customers` AS select `customers`.`customer_id` AS `customer_id`,`customers`.`first_name` AS `first_name`,`customers`.`last_name` AS `last_name`,`customers`.`status` AS `status` from `customers` where (`customers`.`status` = 'ACTIVE') */;
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

-- Dump completed on 2025-12-09 18:41:08
