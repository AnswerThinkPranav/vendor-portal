-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: jublprd
-- ------------------------------------------------------
-- Server version	8.0.45

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
-- Temporary view structure for view `doc_details`
--

DROP TABLE IF EXISTS `doc_details`;
/*!50001 DROP VIEW IF EXISTS `doc_details`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `doc_details` AS SELECT 
 1 AS `WEB_ORNO`,
 1 AS `COLLECT_NO`,
 1 AS `DIVISION`,
 1 AS `DISTR_CHAN`,
 1 AS `SALES_ORG`,
 1 AS `REF_DOC_NR`,
 1 AS `REF_DOC_TYPE`,
 1 AS `AGENT_CODE`,
 1 AS `SOLD_TO_CODE`,
 1 AS `ORDER_DATE`,
 1 AS `SOTO_ADDR1`,
 1 AS `TRANSFER_DATE`,
 1 AS `STATUS_DATE`,
 1 AS `SHIP_TO_CODE`,
 1 AS `SHTO_ADDR1`,
 1 AS `TEXT1`,
 1 AS `TEXT2`,
 1 AS `RES1`,
 1 AS `RES2`,
 1 AS `SALES_AREA_CODE`,
 1 AS `CREATE_USERID`,
 1 AS `CREATION_DATE`,
 1 AS `MOD_ID`,
 1 AS `LAST_MOD_DATE`,
 1 AS `STATUS`,
 1 AS `BACKEND_ORNO`,
 1 AS `INCO_TERMS1`,
 1 AS `INCO_TERMS2`,
 1 AS `NET_VALUE`,
 1 AS `DOC_CURRENCY`,
 1 AS `PO_NO`,
 1 AS `REF_DOC_NO`,
 1 AS `PAYMENT_TERMS`,
 1 AS `DISCOUNT_CASH`,
 1 AS `DISCOUNT_PERCENTAGE`,
 1 AS `FREIGHT`,
 1 AS `TEXT3`,
 1 AS `TEXT4`,
 1 AS `CLASS2`,
 1 AS `ORD_REASON`,
 1 AS `PURCH_DATE`,
 1 AS `SO_LINE_NO`,
 1 AS `PROD_CODE`,
 1 AS `PROD_DESC`,
 1 AS `UOM_QTY`,
 1 AS `UOM`,
 1 AS `COMMITED_QTY`,
 1 AS `DESIRED_QTY`,
 1 AS `REQ_DATE`,
 1 AS `PROMISE_FULL_DATE`,
 1 AS `DESIRED_PRICE`,
 1 AS `COMMIT_PRICE`,
 1 AS `ITEM_NET_VALUE`,
 1 AS `CURRENCY`,
 1 AS `PLANT`,
 1 AS `FOC`,
 1 AS `REF_DOC_ITEM`,
 1 AS `ESDI_NOTES`,
 1 AS `SYS_KEY`,
 1 AS `BACK_END_ORDER`,
 1 AS `BACK_END_ITEM`,
 1 AS `L_SHIP_TO`,
 1 AS `INCOTERMS1`,
 1 AS `INCOTERMS2`,
 1 AS `INVOICE`,
 1 AS `BATCH_NO`,
 1 AS `ITEM_CATEGORY`,
 1 AS `ESDH_REQ_DATE_H`,
 1 AS `ESDH_CUST_GRP5`,
 1 AS `ESDH_REF_1`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `dtproperties`
--

DROP TABLE IF EXISTS `dtproperties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dtproperties` (
  `id` int NOT NULL,
  `objectid` int DEFAULT NULL,
  `property` varchar(64) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `uvalue` varchar(255) DEFAULT NULL,
  `lvalue` longblob,
  `version` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dual`
--

DROP TABLE IF EXISTS `dual`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dual` (
  `FLAG` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_acc_stmt_conf_header`
--

DROP TABLE IF EXISTS `ezc_acc_stmt_conf_header`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_acc_stmt_conf_header` (
  `EASCH_ID` decimal(10,0) NOT NULL,
  `EASCH_FROM` date DEFAULT NULL,
  `EASCH_TO` date DEFAULT NULL,
  `EASCH_CREATED_ON` date DEFAULT NULL,
  `EASCH_CREATED_BY` varchar(50) DEFAULT NULL,
  `EASCH_REMARKS` varchar(100) DEFAULT NULL,
  `EASCH_ACTIVE_STATUS` varchar(10) DEFAULT NULL,
  `EASCH_EXT1` varchar(50) DEFAULT NULL,
  `EASCH_EXT2` varchar(50) DEFAULT NULL,
  `EASCH_EXT3` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`EASCH_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_acc_stmt_confirmations`
--

DROP TABLE IF EXISTS `ezc_acc_stmt_confirmations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_acc_stmt_confirmations` (
  `EASC_ID` decimal(10,0) DEFAULT NULL,
  `EASC_VENDOR` varchar(20) DEFAULT NULL,
  `EASC_VENDOR_NAME` varchar(100) DEFAULT NULL,
  `EASC_CONFIRMED_ON` date DEFAULT NULL,
  `EASC_WITH_CONCERN` varchar(2) DEFAULT NULL,
  `EASC_COMMENTS` varchar(1000) DEFAULT NULL,
  `EASC_EXT1` varchar(50) DEFAULT NULL,
  `EASC_EXT2` varchar(50) DEFAULT NULL,
  `EASC_EXT3` varchar(50) DEFAULT NULL,
  KEY `EASC_ID` (`EASC_ID`),
  CONSTRAINT `ezc_acc_stmt_confirmations_ibfk_1` FOREIGN KEY (`EASC_ID`) REFERENCES `ezc_acc_stmt_conf_header` (`EASCH_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_act_stat_by_auth`
--

DROP TABLE IF EXISTS `ezc_act_stat_by_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_act_stat_by_auth` (
  `EASBA_AUTH_KEY` varchar(16) NOT NULL,
  `EASBA_ACTION` decimal(6,0) NOT NULL,
  `EASBA_RESULT_STATUS` decimal(6,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_address`
--

DROP TABLE IF EXISTS `ezc_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_address` (
  `EA_ADDRESS_CODE` varchar(6) NOT NULL,
  `EA_CONTACT_PERSON` varchar(100) DEFAULT NULL,
  `EA_PHONE` varchar(64) DEFAULT NULL,
  `EA_EMAIL` varchar(64) DEFAULT NULL,
  `EA_ADDR_1` varchar(100) DEFAULT NULL,
  `EA_ADDR_2` varchar(100) DEFAULT NULL,
  `EA_ADDR_3` varchar(100) DEFAULT NULL,
  `EA_STREET` varchar(35) DEFAULT NULL,
  `EA_COUNTRY` char(3) DEFAULT NULL,
  `EA_POSTAL_CODE` char(10) DEFAULT NULL,
  `EA_CITY` varchar(64) DEFAULT NULL,
  `EA_DISTRICT` varchar(35) DEFAULT NULL,
  `EA_STATE` varchar(64) DEFAULT NULL,
  `EA_TEL1` char(30) DEFAULT NULL,
  `EA_TEL2` char(16) DEFAULT NULL,
  `EA_FAX` char(30) DEFAULT NULL,
  `EA_PIN` varchar(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_address_info`
--

DROP TABLE IF EXISTS `ezc_address_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_address_info` (
  `EA_NO` decimal(6,0) DEFAULT NULL,
  `EA_LANG` varchar(2) DEFAULT NULL,
  `EA_COMPANY_NAME` varchar(40) DEFAULT NULL,
  `EA_URL` varchar(40) DEFAULT NULL,
  `EA_EMAIL` varchar(40) DEFAULT NULL,
  `EA_ADDRESS1` varchar(40) DEFAULT NULL,
  `EA_ADDRESS2` varchar(40) DEFAULT NULL,
  `EA_CITY` varchar(40) DEFAULT NULL,
  `EA_DISTRICT` varchar(40) DEFAULT NULL,
  `EA_STATE` varchar(40) DEFAULT NULL,
  `EA_COUNTRY` varchar(40) DEFAULT NULL,
  `EA_ZIPCODE` varchar(10) DEFAULT NULL,
  `EA_PHONE1` varchar(20) DEFAULT NULL,
  `EA_PHONE2` varchar(20) DEFAULT NULL,
  `EA_MOBILE` varchar(20) DEFAULT NULL,
  `EA_BUS_DOMAIN` varchar(20) DEFAULT NULL,
  `EA_TYPE` char(1) DEFAULT NULL,
  `EA_FAX` varchar(20) DEFAULT NULL,
  `EA_EXT1` varchar(20) DEFAULT NULL,
  `EA_EXT2` varchar(20) DEFAULT NULL,
  `EA_EXT3` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_adverse_event_info`
--

DROP TABLE IF EXISTS `ezc_adverse_event_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_adverse_event_info` (
  `EAEI_ADVERSE_EVENT_ID` decimal(18,0) NOT NULL,
  `EAEI_LINKED_SR_ID` decimal(18,0) DEFAULT NULL,
  `EAEI_DATE_RECEIVED` datetime DEFAULT NULL,
  `EAEI_STATUS` varchar(10) DEFAULT NULL,
  `EAEI_PVN_OR_ALTERNATIVE_NO` decimal(18,0) DEFAULT NULL,
  `EAEI_DOB` datetime DEFAULT NULL,
  `EAEI_WEIGHT_AT_BIRTH` decimal(18,0) DEFAULT NULL,
  `EAEI_AGE_AT_VACCINATION_IN_MONTHS` decimal(18,0) DEFAULT NULL,
  `EAEI_SEX` char(1) DEFAULT NULL,
  `EAEI_FORM_COMPLETED_DATE` datetime DEFAULT NULL,
  `EAEI_ADVERSE_EVENTS_DESCRIPTION` varchar(1000) DEFAULT NULL,
  `EAEI_ADVERSE_EVENT` varchar(15) DEFAULT NULL,
  `EAEI_PATIENT_DIED_DATE` datetime DEFAULT NULL,
  `EAEI_IS_LIFE_THREAT_ILLNESS` char(1) DEFAULT NULL,
  `EAEI_IS_EMERGENCY_ROOM_OR_DR_VISIT_REQD` char(1) DEFAULT NULL,
  `EAEI_RESULT_PROLONG_HOSPITALIZATION` char(1) DEFAULT NULL,
  `EAEI_RESULT_PERMANENT_DISABILITY` char(1) DEFAULT NULL,
  `EAEI_PATIENT_RECOVERED` char(1) DEFAULT NULL,
  `EAEI_VACCINATION_DATE` datetime DEFAULT NULL,
  `EAEI_ADVERSE_EVENT_ONSET` datetime DEFAULT NULL,
  `EAEI_DIAG_TESTS_LAB_DATA` varchar(1000) DEFAULT NULL,
  `EAEI_VACCINATED_AT` char(1) DEFAULT NULL,
  `EAEI_VACCINE_PURCHASED_WITH` char(1) DEFAULT NULL,
  `EAEI_OTHER_MEDICATIONS` varchar(1024) DEFAULT NULL,
  `EAEI_ILLNESS_AT_VACCINATION_TIME` varchar(1024) DEFAULT NULL,
  `EAEI_PRE_CONDITIONS` varchar(1024) DEFAULT NULL,
  `EAEI_REPORTED_PREVIOUSLY_TO` char(1) DEFAULT NULL,
  `EAEI_MFR_IMMN_PROJ_REPORT_NO` decimal(18,0) DEFAULT NULL,
  `EAEI_MFR_IMMN_PROJ_RECD_DATE` datetime DEFAULT NULL,
  `EAEI_IS_15_DAY_REPORT` char(1) DEFAULT NULL,
  `EAEI_REPORT_TYPE` char(1) DEFAULT NULL,
  `EAEI_ASSIGNED_TO` varchar(10) DEFAULT NULL,
  `EAEI_SUGGESTIONS_TO_CUST` varchar(1024) DEFAULT NULL,
  `EAEI_PATIENT_FIRST_NAME` varchar(50) DEFAULT NULL,
  `EAEI_PATIENT_MIDDLE_INITIAL` char(1) DEFAULT NULL,
  `EAEI_PATIENT_LAST_NAME` varchar(50) DEFAULT NULL,
  `EAEI_PATIENT_ADDRESS1` varchar(100) DEFAULT NULL,
  `EAEI_PATIENT_ADDRESS2` varchar(100) DEFAULT NULL,
  `EAEI_PATIENT_CITY` varchar(64) DEFAULT NULL,
  `EAEI_PATIENT_STATE` varchar(64) DEFAULT NULL,
  `EAEI_PATIENT_ZIP` varchar(10) DEFAULT NULL,
  `EAEI_PATIENT_TELNO` varchar(20) DEFAULT NULL,
  `EAEI_RESP_PHYSICIAN` varchar(50) DEFAULT NULL,
  `EAEI_ADMINISTERED_BY_NAME` varchar(50) DEFAULT NULL,
  `EAEI_ADMINISTERED_BY_ADDRESS1` varchar(100) DEFAULT NULL,
  `EAEI_ADMINISTERED_BY_ADDRESS2` varchar(100) DEFAULT NULL,
  `EAEI_ADMINISTERED_BY_CITY` varchar(64) DEFAULT NULL,
  `EAEI_ADMINISTERED_BY_STATE` varchar(64) DEFAULT NULL,
  `EAEI_ADMINISTERED_BY_ZIP` varchar(10) DEFAULT NULL,
  `EAEI_ADMINISTERED_BY_TELNO` varchar(20) DEFAULT NULL,
  `EAEI_ADMINISTERED_STATE` varchar(50) DEFAULT NULL,
  `EAEI_ADMINISTERED_COUNTRY` varchar(50) DEFAULT NULL,
  `EAEI_FORM_FILLED_BY_NAME` varchar(50) DEFAULT NULL,
  `EAEI_FORM_FILLED_BY_ADDRESS1` varchar(100) DEFAULT NULL,
  `EAEI_FORM_FILLED_BY_ADDRESS2` varchar(100) DEFAULT NULL,
  `EAEI_FORM_FILLED_BY_CITY` varchar(64) DEFAULT NULL,
  `EAEI_FORM_FILLED_BY_STATE` varchar(64) DEFAULT NULL,
  `EAEI_FORM_FILLED_BY_ZIP` varchar(10) DEFAULT NULL,
  `EAEI_FORM_FILLED_BY_TELNO` varchar(20) DEFAULT NULL,
  `EAEI_CREATED_BY` varchar(10) DEFAULT NULL,
  `EAEI_CREATION_DATE` datetime DEFAULT NULL,
  `EAEI_CHANGED_BY` varchar(10) DEFAULT NULL,
  `EAEI_CHANGED_DATE` datetime DEFAULT NULL,
  `EAEI_HOSPITALIZATION_DAYS` decimal(18,0) DEFAULT NULL,
  `EAEI_RELATION_TO_PATIENT` varchar(10) DEFAULT NULL,
  `EAEI_NO_OF_BRO_AND_SIS` decimal(18,0) DEFAULT NULL,
  `EAEI_FORM_FILLED_BY_OCCUPATION` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_agent_customer_details`
--

DROP TABLE IF EXISTS `ezc_agent_customer_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_agent_customer_details` (
  `EACD_ID` decimal(6,0) NOT NULL,
  `EACD_CUST_NAME` varchar(40) DEFAULT NULL,
  `EACD_CUST_PRODUCT` varchar(20) DEFAULT NULL,
  `EACD_CUST_ADDR` varchar(40) DEFAULT NULL,
  `EACD_KEY` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_agreement_header`
--

DROP TABLE IF EXISTS `ezc_agreement_header`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_agreement_header` (
  `EAH_MODEL` varchar(20) NOT NULL,
  `EAH_TEMPLATE_CODE` decimal(6,0) NOT NULL,
  `EAH_TEMPLATE_TYPE` char(1) DEFAULT NULL,
  `EAH_DESC` varchar(100) DEFAULT NULL,
  `EAH_MAINTENANCE_TEMPLATE` decimal(6,0) NOT NULL,
  `EAH_MAIN_TEMPLATE_VERSION` decimal(8,0) NOT NULL,
  `EAH_TERM_ID` decimal(6,0) DEFAULT NULL,
  `EAH_START_DATE` datetime DEFAULT NULL,
  `EAH_END_DATE` datetime DEFAULT NULL,
  `EAH_CURRENT_STATUS` decimal(3,0) DEFAULT NULL,
  `EAH_RENEWAL_TYPE` decimal(3,0) DEFAULT NULL,
  `EAH_INTIMATION_PERIOD` decimal(5,0) DEFAULT NULL,
  `EAH_RENEWAL_METHOD` char(1) DEFAULT NULL,
  `EAH_RENEWAL_PERCENTAGE` decimal(5,2) DEFAULT NULL,
  `EAH_RENEWAL_AMOUNT` decimal(10,2) DEFAULT NULL,
  `EAH_DURATION` decimal(5,0) DEFAULT NULL,
  `EAH_DURATION_UNIT` varchar(10) DEFAULT NULL,
  `EAH_TEMPLATE_INFO` varchar(1000) DEFAULT NULL,
  `EAH_PRINTABLE_TEXT` varchar(1000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_attributes`
--

DROP TABLE IF EXISTS `ezc_attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_attributes` (
  `EA_ROLE_NO` varchar(16) DEFAULT NULL,
  `EA_ATTRIB_ID` decimal(6,0) NOT NULL,
  `EA_LANG` varchar(2) DEFAULT NULL,
  `EA_DESCRIPTION` varchar(255) DEFAULT NULL,
  `EA_CONTAINER` varchar(50) DEFAULT NULL,
  `EA_EZC_STRUCT_FIELD` varchar(255) DEFAULT NULL,
  `EA_TYPE` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_auction_audit_trail`
--

DROP TABLE IF EXISTS `ezc_auction_audit_trail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_auction_audit_trail` (
  `EAAT_AUDIT_ID` int NOT NULL AUTO_INCREMENT,
  `EAAT_DOC_ID` decimal(15,0) DEFAULT NULL,
  `EAAT_USER_ID` varchar(10) DEFAULT NULL,
  `EAAT_TYPE` varchar(10) DEFAULT NULL,
  `EAAT_COMMENTS` varchar(500) DEFAULT NULL,
  `EAAT_DATE` datetime DEFAULT NULL,
  PRIMARY KEY (`EAAT_AUDIT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=57733 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_auction_deliverables`
--

DROP TABLE IF EXISTS `ezc_auction_deliverables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_auction_deliverables` (
  `EAD_AUCTION_ID` decimal(15,0) NOT NULL,
  `EAD_ITEM_ID` decimal(15,0) NOT NULL,
  `EAD_DELIVERY_LINE` decimal(15,0) NOT NULL,
  `EAD_REQUIRED_DATE` date DEFAULT NULL,
  `EAD_REQUIRED_QUANTITY` decimal(12,3) DEFAULT NULL,
  `EAD_EXT1` varchar(20) DEFAULT NULL,
  `EAD_EXT2` varchar(20) DEFAULT NULL,
  `EAD_EXT3` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EAD_AUCTION_ID`,`EAD_ITEM_ID`,`EAD_DELIVERY_LINE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_auction_header`
--

DROP TABLE IF EXISTS `ezc_auction_header`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_auction_header` (
  `EAH_AUCTION_ID` decimal(15,0) NOT NULL,
  `EAH_AUCTION_NAME` varchar(100) DEFAULT NULL,
  `EAH_BUYER_ID` varchar(40) DEFAULT NULL,
  `EAH_BUYER_NAME` varchar(50) DEFAULT NULL,
  `EAH_AUCTION_TYPE` varchar(20) DEFAULT NULL,
  `EAH_EVAL_TYPE` varchar(20) DEFAULT NULL,
  `EAH_CREATION_DATE` date DEFAULT NULL,
  `EAH_START_DATE` datetime DEFAULT NULL,
  `EAH_END_DATE` datetime DEFAULT NULL,
  `EAH_EXTENSION_TIME` decimal(15,0) DEFAULT NULL,
  `EAH_EXTENSIONS` decimal(15,0) DEFAULT NULL,
  `EAH_TIME_LAG` decimal(15,0) DEFAULT NULL,
  `EAH_MIN_BID_VARIANCE` decimal(12,3) DEFAULT NULL,
  `EAH_MAX_BID_VARIANCE` decimal(12,3) DEFAULT NULL,
  `EAH_VARIANCE_TYPE` varchar(20) DEFAULT NULL,
  `EAH_ACKNOWLEDGE_TYPE` varchar(20) DEFAULT NULL,
  `EAH_PAYMENT_TERMS` varchar(40) DEFAULT NULL,
  `EAH_INCO_TERMS` varchar(40) DEFAULT NULL,
  `EAH_AUCTION_STATUS` varchar(20) DEFAULT NULL,
  `EAH_NO_ITEMS` decimal(15,0) DEFAULT NULL,
  `EAH_CURRENCY` varchar(10) DEFAULT NULL,
  `EAH_TARGET_VALUE` decimal(15,0) DEFAULT NULL,
  `EAH_START_VALUE` decimal(15,0) DEFAULT NULL,
  `EAH_FINAL_VALUE` decimal(10,2) DEFAULT NULL,
  `EAH_RULES_EXIST` varchar(40) DEFAULT NULL,
  `EAH_UPLOAD_FILES` varchar(250) DEFAULT NULL,
  `EAH_PHONE1` decimal(15,0) DEFAULT NULL,
  `EAH_PHONE2` decimal(15,0) DEFAULT NULL,
  `EAH_PHONE3` decimal(15,0) DEFAULT NULL,
  `EAH_FLAG1` varchar(10) DEFAULT NULL,
  `EAH_FLAG2` varchar(10) DEFAULT NULL,
  `EAH_EXT1` varchar(20) DEFAULT NULL,
  `EAH_EXT2` varchar(20) DEFAULT NULL,
  `EAH_EXT3` varchar(20) DEFAULT NULL,
  `EAH_PLANT` varchar(5) DEFAULT NULL,
  `EAH_CATEGORY` varchar(10) DEFAULT NULL,
  `EAH_WF_STATUS` varchar(10) DEFAULT NULL,
  `EAH_PO_FLAG` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`EAH_AUCTION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_auction_history`
--

DROP TABLE IF EXISTS `ezc_auction_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_auction_history` (
  `EAH_AUCTION_ID` decimal(15,0) DEFAULT NULL,
  `EAH_SUPPLIER_ID` decimal(15,0) DEFAULT NULL,
  `EAH_ITEM_ID` decimal(15,0) DEFAULT NULL,
  `EAH_AUCTION_COUNTER` decimal(15,0) DEFAULT NULL,
  `EAH_AUCTION_VALUE` decimal(38,15) DEFAULT NULL,
  `EAH_TIME_STAMP` timestamp NULL DEFAULT NULL,
  `EAH_EXT1` varchar(20) DEFAULT NULL,
  `EAH_EXT2` varchar(20) DEFAULT NULL,
  `EAH_EXT3` varchar(20) DEFAULT NULL,
  `EAH_IP_ADDR` varchar(100) DEFAULT NULL,
  UNIQUE KEY `EAHKEY_UNIQUE` (`EAH_AUCTION_ID`,`EAH_ITEM_ID`,`EAH_AUCTION_VALUE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_auction_item`
--

DROP TABLE IF EXISTS `ezc_auction_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_auction_item` (
  `EAI_AUCTION_ID` decimal(15,0) NOT NULL,
  `EAI_ITEM_ID` decimal(15,0) NOT NULL,
  `EAI_ITEM_CODE` varchar(300) DEFAULT NULL,
  `EAI_UOM` varchar(20) DEFAULT NULL,
  `EAI_QUANTITY` decimal(12,3) DEFAULT NULL,
  `EAI_TOLERANCE` decimal(15,0) DEFAULT NULL,
  `EAI_REQ_STATUS` varchar(40) DEFAULT NULL,
  `EAI_INITIAL_PRICE` decimal(12,3) DEFAULT NULL,
  `EAI_TARGET_PRICE` decimal(12,3) DEFAULT NULL,
  `EAI_TARGET_SHOWN` varchar(40) DEFAULT NULL,
  `EAI_FINAL_PRICE` decimal(12,3) DEFAULT NULL,
  `EAI_MIN_VARIANCE` decimal(12,3) DEFAULT NULL,
  `EAI_MAX_VARIANCE` decimal(12,3) DEFAULT NULL,
  `EAI_VARIANCE_TYPE` varchar(20) DEFAULT NULL,
  `EAI_INCO_TERMS1` varchar(40) DEFAULT NULL,
  `EAI_INCO_TERMS2` varchar(40) DEFAULT NULL,
  `EAI_PAYMENT_TERMS` varchar(40) DEFAULT NULL,
  `EAI_IS_SPEC_EXIST` varchar(40) DEFAULT NULL,
  `EAI_IS_FILE_EXIST` varchar(40) DEFAULT NULL,
  `EAI_EXT1` varchar(20) DEFAULT NULL,
  `EAI_EXT2` varchar(20) DEFAULT NULL,
  `EAI_EXT3` varchar(1000) DEFAULT NULL,
  `EAI_MATERIAL` varchar(18) DEFAULT NULL,
  `EAI_BUDGET_PRICE` decimal(12,3) DEFAULT NULL,
  PRIMARY KEY (`EAI_AUCTION_ID`,`EAI_ITEM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_auction_item_conditions`
--

DROP TABLE IF EXISTS `ezc_auction_item_conditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_auction_item_conditions` (
  `EAIC_AUCTION_ID` varchar(20) NOT NULL,
  `EAIC_ITEM_ID` decimal(15,0) NOT NULL,
  `EAIC_SUPPLIER_ID` decimal(15,0) NOT NULL,
  `EAIC_TAX_CODE` varchar(15) NOT NULL,
  `EAIC_TAX_VALUE` varchar(25) DEFAULT NULL,
  `EAIC_TAX_TYPE` varchar(10) DEFAULT NULL,
  `EAIC_CFORM` varchar(5) DEFAULT NULL,
  `EAIC_EXT1` varchar(20) DEFAULT NULL,
  `EAIC_EXT2` varchar(20) DEFAULT NULL,
  `EAIC_EXT3` varchar(20) DEFAULT NULL,
  `EAIC_SEQ_NO` varchar(10) NOT NULL,
  `EAIC_NEG_TAX_VALUE` varchar(25) DEFAULT NULL,
  `EAIC_CURRENCY` varchar(5) DEFAULT NULL,
  `EAIC_EXCH_RATE` decimal(15,4) DEFAULT NULL,
  `EAIC_COND_VEND` varchar(15) DEFAULT NULL,
  `EAIC_EXT4` varchar(20) DEFAULT NULL,
  `EAIC_EXT5` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EAIC_AUCTION_ID`,`EAIC_ITEM_ID`,`EAIC_SUPPLIER_ID`,`EAIC_TAX_CODE`,`EAIC_SEQ_NO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_auction_recommended_items`
--

DROP TABLE IF EXISTS `ezc_auction_recommended_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_auction_recommended_items` (
  `EARI_AUCTION_ID` decimal(15,0) NOT NULL,
  `EARI_SUPPLIER_ID` decimal(15,0) NOT NULL,
  `EARI_ITEM_ID` decimal(15,0) NOT NULL,
  `EARI_PO_QTY` decimal(15,3) DEFAULT NULL,
  `EARI_PO_CR_QTY` decimal(15,3) DEFAULT NULL,
  PRIMARY KEY (`EARI_AUCTION_ID`,`EARI_SUPPLIER_ID`,`EARI_ITEM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_auction_result`
--

DROP TABLE IF EXISTS `ezc_auction_result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_auction_result` (
  `EAR_AUCTION_ID` decimal(15,0) DEFAULT NULL,
  `EAR_SUPPLIER_ID` decimal(15,0) DEFAULT NULL,
  `EAR_ITEM_ID` decimal(15,0) DEFAULT NULL,
  `EAR_REQ_TYPE` varchar(20) DEFAULT NULL,
  `EAR_PRICE` decimal(12,3) DEFAULT NULL,
  `EAR_QUANTITY` decimal(12,3) DEFAULT NULL,
  `EAR_EXT1` varchar(20) DEFAULT NULL,
  `EAR_EXT2` varchar(20) DEFAULT NULL,
  `EAR_EXT3` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_auction_supplier`
--

DROP TABLE IF EXISTS `ezc_auction_supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_auction_supplier` (
  `EAS_AUCTION_ID` decimal(15,0) NOT NULL,
  `EAS_SUPPLIER_ID` decimal(15,0) NOT NULL,
  `EAS_SUPPLIER_CODE` varchar(50) DEFAULT NULL,
  `EAS_SUPPLIER_ALIAS` varchar(40) DEFAULT NULL,
  `EAS_EVAL_FACTOR` decimal(15,0) DEFAULT NULL,
  `EAS_GRANTED_RATIO` decimal(15,0) DEFAULT NULL,
  `EAS_SPLIT_INDICATOR` varchar(20) DEFAULT NULL,
  `EAS_ACKNOWLEDGED_DATE` date DEFAULT NULL,
  `EAS_ACKNOWLEDGE_STATUS` varchar(20) DEFAULT NULL,
  `EAS_REASON_EXISTS` varchar(40) DEFAULT NULL,
  `EAS_INITIAL_QUOTE` decimal(12,3) DEFAULT NULL,
  `EAS_FINAL_QUOTE` decimal(12,3) DEFAULT NULL,
  `EAS_FINAL_RANKING` decimal(15,0) DEFAULT NULL,
  `EAS_EXT1` varchar(40) DEFAULT NULL,
  `EAS_EXT2` varchar(20) DEFAULT NULL,
  `EAS_EXT3` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EAS_AUCTION_ID`,`EAS_SUPPLIER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_audit_log`
--

DROP TABLE IF EXISTS `ezc_audit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_audit_log` (
  `ELS_SYS_NO` decimal(3,0) NOT NULL,
  `ELS_TABLE_NAME` varchar(64) NOT NULL,
  `ELS_DATE` char(20) NOT NULL,
  `ELS_TIME` char(20) DEFAULT NULL,
  `ELS_KEY` char(32) DEFAULT NULL,
  `ELS_OLD_VALUE` varchar(256) DEFAULT NULL,
  `ELS_CHANGED_VALUE` varchar(256) DEFAULT NULL,
  `ELS_OPERATIION_TYPE` char(10) NOT NULL,
  `ELS_CHANGED_BY` char(10) NOT NULL,
  `ELS_TRANSACTION` char(18) DEFAULT NULL,
  `ELS_RECORD_FAILED_FLAG` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_audit_table_list`
--

DROP TABLE IF EXISTS `ezc_audit_table_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_audit_table_list` (
  `EATL_SYS_NO` decimal(3,0) NOT NULL,
  `EATL_TABLE_NAME` varchar(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_auth_desc`
--

DROP TABLE IF EXISTS `ezc_auth_desc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_auth_desc` (
  `EUAD_AUTH_KEY` varchar(16) NOT NULL,
  `EUAD_LANG` char(2) NOT NULL,
  `EUAD_AUTH_DESC` char(48) DEFAULT NULL,
  `EUAD_DELETION_FLAG` char(1) DEFAULT NULL,
  `EUAD_IS_SYS_AUTH` char(1) NOT NULL,
  `EUAD_COMPONENT` varchar(20) DEFAULT NULL,
  `EUAD_BUSINESS_DOMAIN` varchar(20) DEFAULT NULL,
  `EUAD_IS_WF_ENABLED` char(1) DEFAULT NULL,
  `EUAD_TYPE_OF_TRANS` char(1) DEFAULT NULL,
  PRIMARY KEY (`EUAD_AUTH_KEY`,`EUAD_LANG`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_bank_master`
--

DROP TABLE IF EXISTS `ezc_bank_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_bank_master` (
  `EBM_DOC_ID` varchar(10) NOT NULL,
  `EBM_VENDOR` varchar(10) NOT NULL,
  `EBM_COUNTRY_KEY` varchar(3) DEFAULT NULL,
  `EBM_KEY` varchar(15) DEFAULT NULL,
  `EBM_STREET` varchar(35) DEFAULT NULL,
  `EBM_IFSC_CODE` varchar(11) DEFAULT NULL,
  `EBM_BANK_NAME` varchar(60) DEFAULT NULL,
  `EBM_CITY` varchar(35) DEFAULT NULL,
  `ebm_ac_code` varchar(18) NOT NULL,
  `EBM_REGION` varchar(3) DEFAULT NULL,
  `EBM_BRANCH` varchar(40) DEFAULT NULL,
  `EBM_CURRENCY` varchar(5) DEFAULT NULL,
  `EBM_IS_DELETE` varchar(1) DEFAULT NULL,
  `EBM_EXT1` varchar(100) DEFAULT NULL,
  `EBM_EXT2` varchar(100) DEFAULT NULL,
  `EBM_EXT3` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`EBM_DOC_ID`,`EBM_VENDOR`,`ebm_ac_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_bp_level_workflow`
--

DROP TABLE IF EXISTS `ezc_bp_level_workflow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_bp_level_workflow` (
  `EBP_BUSINESS_PARTNER` char(10) DEFAULT NULL,
  `EBP_PROCEDURE_TYPE` char(3) NOT NULL,
  `EBP_STEP_NUMBER` decimal(2,0) NOT NULL,
  `EBP_SEQUENCE_NUMBER` decimal(2,0) DEFAULT NULL,
  `EBP_USER_ID` varchar(10) NOT NULL,
  `EBP_CC_TO` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_buss_partner_areas`
--

DROP TABLE IF EXISTS `ezc_buss_partner_areas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_buss_partner_areas` (
  `EBPA_CLIENT` decimal(6,0) NOT NULL,
  `EBPA_BUSS_PARTNER` char(10) DEFAULT NULL,
  `EBPA_SYS_KEY` varchar(18) NOT NULL,
  `EBPA_USER_ID` char(10) DEFAULT NULL,
  `EBPA_AREA_FLAG` char(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_buss_partner_auth`
--

DROP TABLE IF EXISTS `ezc_buss_partner_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_buss_partner_auth` (
  `EBPA_BUSS_PARTNER` char(10) NOT NULL,
  `EBPA_SYS_NO` decimal(3,0) NOT NULL,
  `EBPA_AUTH_KEY` varchar(128) NOT NULL,
  `EBPA_AUTH_VALUE` varchar(128) DEFAULT NULL,
  `EBPA_ROLE_OR_AUTH` char(1) DEFAULT NULL,
  PRIMARY KEY (`EBPA_BUSS_PARTNER`,`EBPA_SYS_NO`,`EBPA_AUTH_KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_buss_partner_config`
--

DROP TABLE IF EXISTS `ezc_buss_partner_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_buss_partner_config` (
  `EBPC_BUSS_PARTNER` char(10) NOT NULL,
  `EBPC_CATALOG_NO` decimal(6,0) NOT NULL,
  `EBPC_MULTIPLE_SALES_AREAS` char(1) DEFAULT NULL,
  `EBPC_PRICE_SELECTION_FLAG` char(1) DEFAULT NULL,
  `EBPC_UNLIMITED_USERS` char(1) DEFAULT NULL,
  `EBPC_NUMBER_OF_USERS` decimal(10,0) DEFAULT NULL,
  `EPBC_INTRANET_FLAG` char(1) DEFAULT NULL,
  PRIMARY KEY (`EBPC_BUSS_PARTNER`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_buss_partner_params`
--

DROP TABLE IF EXISTS `ezc_buss_partner_params`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_buss_partner_params` (
  `EBPP_BUSS_PARTNER` char(10) NOT NULL,
  `EBPP_KEY` varchar(128) NOT NULL,
  `EBPP_VALUE` varchar(128) NOT NULL,
  PRIMARY KEY (`EBPP_BUSS_PARTNER`,`EBPP_KEY`,`EBPP_VALUE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_buss_partner_xml_params`
--

DROP TABLE IF EXISTS `ezc_buss_partner_xml_params`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_buss_partner_xml_params` (
  `EBPX_CLIENT` decimal(3,0) NOT NULL,
  `EBPX_BUSS_PARTNER` char(10) NOT NULL,
  `EBPX_XML_TRANSACTION_ID` varchar(18) NOT NULL,
  `EBPX_XML_STANDARD_IN` varchar(6) DEFAULT NULL,
  `EBPX_XML_STANDARD_OUT` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_calendar`
--

DROP TABLE IF EXISTS `ezc_calendar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_calendar` (
  `ECAL_CALENDAR_CODE` varchar(6) NOT NULL,
  `ECAL_EFFECTIVE_FROM` datetime NOT NULL,
  `ECAL_NON_WORKING_DAYS` varchar(2048) DEFAULT NULL,
  `ECAL_WORK_WEEK` varchar(2048) DEFAULT NULL,
  `ECAL_NUMBER_HOURS_DAY` decimal(5,2) DEFAULT NULL,
  `ECAL_START_TIME` varchar(10) DEFAULT NULL,
  `ECAL_BREAK_TIME` varchar(10) DEFAULT NULL,
  `ECAL_BREAK_END` varchar(10) DEFAULT NULL,
  `ECAL_ACTIVE_YES_OR_NO` char(1) DEFAULT NULL,
  `ECAL_EFFECTIVE_TO` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_cat_area_defaults`
--

DROP TABLE IF EXISTS `ezc_cat_area_defaults`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_cat_area_defaults` (
  `ECAD_CLIENT` char(5) NOT NULL,
  `ECAD_SYS_KEY` varchar(18) NOT NULL,
  `ECAD_KEY` varchar(18) NOT NULL,
  `ECAD_VALUE` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`ECAD_CLIENT`,`ECAD_SYS_KEY`,`ECAD_KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_catalog_group`
--

DROP TABLE IF EXISTS `ezc_catalog_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_catalog_group` (
  `ECG_CATALOG_NO` decimal(8,0) NOT NULL,
  `ECG_SYS_KEY` varchar(18) NOT NULL,
  `ECG_PRODUCT_GROUP` varchar(18) NOT NULL,
  `ECG_INDEX_INDICATOR` char(1) DEFAULT NULL,
  PRIMARY KEY (`ECG_CATALOG_NO`,`ECG_PRODUCT_GROUP`,`ECG_SYS_KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_certificate_of_analysis`
--

DROP TABLE IF EXISTS `ezc_certificate_of_analysis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_certificate_of_analysis` (
  `EZCA_DOCUMENT_NO` varchar(10) NOT NULL,
  `EZCA_ITEM_NO` varchar(5) NOT NULL,
  `EZCA_LINE_NO` varchar(3) NOT NULL,
  `EZCA_ARNO` varchar(16) DEFAULT NULL,
  `EZCA_DOA` datetime DEFAULT NULL,
  `EZCA_DOMFG` datetime DEFAULT NULL,
  `EZCA_BOXES` varchar(16) DEFAULT NULL,
  `EZCA_SPEC_NO` varchar(16) DEFAULT NULL,
  `EZCA_EXT1` varchar(20) DEFAULT NULL,
  `EZCA_EXT2` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_communication_details`
--

DROP TABLE IF EXISTS `ezc_communication_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_communication_details` (
  `ECD_COMM_NO` decimal(6,0) NOT NULL,
  `ECD_CUST_ID` decimal(6,0) NOT NULL,
  `ECD_COMM_TYPE` varchar(10) DEFAULT NULL,
  `ECD_REC_TYPE` varchar(10) DEFAULT NULL,
  `ECD_COMM_DATE` datetime DEFAULT NULL,
  `ECD_CUST_NAME` varchar(40) DEFAULT NULL,
  `ECD_COMM_SUBJECT` varchar(40) DEFAULT NULL,
  `ECD_COMM_CATEGORY` varchar(10) DEFAULT NULL,
  `ECD_COMM_SHIP_DATE` datetime DEFAULT NULL,
  `ECD_COMM_COURIER` varchar(10) DEFAULT NULL,
  `ECD_COMM_PRODUCT` varchar(30) DEFAULT NULL,
  `ECD_COMM_PROD_QTY` varchar(10) DEFAULT NULL,
  `ECD_COMM_NOTE` varchar(250) DEFAULT NULL,
  `ECD_COMM_STATUS` varchar(5) DEFAULT NULL,
  `ECD_EXT1` varchar(100) DEFAULT NULL,
  `ECD_EXT2` varchar(250) DEFAULT NULL,
  `ECD_EXT3` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_components`
--

DROP TABLE IF EXISTS `ezc_components`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_components` (
  `EC_COMPONENT_MODEL_CODE` decimal(6,0) DEFAULT NULL,
  `EC_COMPONENT_CODE` varchar(10) NOT NULL,
  `EC_INSTRUMENT_CODE` varchar(10) DEFAULT NULL,
  `EC_PARENT_COMP_CODE` varchar(20) DEFAULT NULL,
  `EC_MANUFACTURER_ID` varchar(20) DEFAULT NULL,
  `EC_OEM_SLNO` varchar(50) DEFAULT NULL,
  `EC_INCLD_IN_PAR_WARR` char(1) DEFAULT NULL,
  `EC_WARR_EFF_DATE` datetime DEFAULT NULL,
  `EC_WARR_EXP_DATE` datetime DEFAULT NULL,
  `EC_INSTALLED_DATE` datetime DEFAULT NULL,
  `EC_LIFE_TIME` decimal(6,2) DEFAULT NULL,
  `EC_LIFE_TIME_UNIT` char(3) DEFAULT NULL,
  `EC_EXPIRY_DATE` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_components_models`
--

DROP TABLE IF EXISTS `ezc_components_models`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_components_models` (
  `ECM_COMPONENT_MODEL_CODE` decimal(6,0) NOT NULL,
  `ECM_BINNO` varchar(20) DEFAULT NULL,
  `ECM_LANG` char(2) DEFAULT NULL,
  `ECM_DESCRIPTION` varchar(100) DEFAULT NULL,
  `ECM_TYPE` char(1) DEFAULT NULL,
  `ECM_ENTERPRISE_CODE` varchar(20) DEFAULT NULL,
  `ECM_INCL_IN_PARENT_WARRANTY` char(1) DEFAULT NULL,
  `ECM_MANUFACTURER_ID` varchar(50) DEFAULT NULL,
  `ECM_LIFE_TIME` decimal(6,2) DEFAULT NULL,
  `ECM_LIFE_TIME_UNITS` char(3) DEFAULT NULL,
  `ECM_WARRANTY_TEMPLATE_CODE` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_condition_master`
--

DROP TABLE IF EXISTS `ezc_condition_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_condition_master` (
  `ECM_COND_ID` decimal(6,0) NOT NULL,
  `ECM_RULE_ID` decimal(6,0) DEFAULT NULL,
  `ECM_ATTRIBUTE` decimal(6,0) DEFAULT NULL,
  `ECM_CONDITION_OPERATOR` varchar(2) DEFAULT NULL,
  `ECM_COND_VALUE1` varchar(100) DEFAULT NULL,
  `ECM_COND_VALUE2` varchar(100) DEFAULT NULL,
  `EZC_CONDITION_TYPE` char(1) DEFAULT NULL,
  PRIMARY KEY (`ECM_COND_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_consolidate_terms`
--

DROP TABLE IF EXISTS `ezc_consolidate_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_consolidate_terms` (
  `ECT_TERM_ID` decimal(6,0) NOT NULL,
  `ECT_SERVICE_CATEGORY` decimal(6,0) NOT NULL,
  `ECT_COST_AMT` decimal(10,4) DEFAULT NULL,
  `ECT_SALES_AMT` decimal(10,4) DEFAULT NULL,
  `ECT_ACT_COST_AMT` decimal(10,4) DEFAULT NULL,
  `ECT_ACT_SALES_AMT` decimal(10,4) DEFAULT NULL,
  `ECT_BUDG_COST_AMT` decimal(10,4) DEFAULT NULL,
  `ECT_BUDG_SALES_AMT` decimal(10,4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_contract`
--

DROP TABLE IF EXISTS `ezc_contract`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_contract` (
  `EC_CONTRACT_CODE` decimal(6,0) NOT NULL,
  `EC_DESC` varchar(100) DEFAULT NULL,
  `EC_SCHEDULE_CODE` decimal(6,0) DEFAULT NULL,
  `EC_CONTRACT_TEMPLATE` decimal(6,0) DEFAULT NULL,
  `EC_TERM_ID` decimal(6,0) DEFAULT NULL,
  `EC_START_DATE` datetime DEFAULT NULL,
  `EC_END_DATE` datetime DEFAULT NULL,
  `EC_CURRENT_STATUS` decimal(3,0) DEFAULT NULL,
  `EC_INTIMATION_PERIOD` decimal(5,0) DEFAULT NULL,
  `EC_RENEWAL_TYPE` decimal(3,0) DEFAULT NULL,
  `EC_RENEWAL_PERCENTAGE` decimal(5,2) DEFAULT NULL,
  `EC_RENEWAL_AMT` decimal(10,2) DEFAULT NULL,
  `EC_RENEWAL_METHOD` char(1) DEFAULT NULL,
  `EC_CANCEL_DATE` datetime DEFAULT NULL,
  `EC_CANCEL_REASON` varchar(500) DEFAULT NULL,
  `EC_INTERNAL_TEXT` varchar(500) DEFAULT NULL,
  `EC_CONTRACT_TEXT` varchar(500) DEFAULT NULL,
  `EC_SOLDTO_CUST` varchar(20) DEFAULT NULL,
  `EC_SOLDTO_CUST_ADD1` varchar(50) DEFAULT NULL,
  `EC_SOLDTO_CUST_ADD2` varchar(50) DEFAULT NULL,
  `EC_SOLDTO_CUST_ADD3` varchar(50) DEFAULT NULL,
  `EC_SOLDTO_CITY` varchar(64) DEFAULT NULL,
  `EC_SOLDTO_STATE` varchar(64) DEFAULT NULL,
  `EC_SOLDTO_COUNTRY` varchar(64) DEFAULT NULL,
  `EC_SOLDTO_ZIPCODE` varchar(64) DEFAULT NULL,
  `EC_SOLDTO_CONTACT_PERSON` varchar(50) DEFAULT NULL,
  `EC_SOLDTO_TELNO` varchar(30) DEFAULT NULL,
  `EC_SOLDTO_EMAIL` varchar(64) DEFAULT NULL,
  `EC_INVOICETO_CUST` varchar(20) DEFAULT NULL,
  `EC_INVOICETO_CUST_ADD1` varchar(50) DEFAULT NULL,
  `EC_INVOICETO_CUST_ADD2` varchar(50) DEFAULT NULL,
  `EC_INVOICETO_CUST_ADD3` varchar(50) DEFAULT NULL,
  `EC_INVOICETO_CITY` varchar(64) DEFAULT NULL,
  `EC_INVOICETO_STATE` varchar(64) DEFAULT NULL,
  `EC_INVOICETO_COUNTRY` varchar(64) DEFAULT NULL,
  `EC_INVOICETO_ZIPCODE` varchar(64) DEFAULT NULL,
  `EC_INVOICETO_CONTACT_PERSON` varchar(50) DEFAULT NULL,
  `EC_INVOICETO_TELNO` varchar(30) DEFAULT NULL,
  `EC_INVOICETO_EMAIL` varchar(64) DEFAULT NULL,
  `EC_CREATED_ON` datetime DEFAULT NULL,
  `EC_MODIFIED_ON` datetime DEFAULT NULL,
  `EC_VALUE` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_conversion_factors`
--

DROP TABLE IF EXISTS `ezc_conversion_factors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_conversion_factors` (
  `ECFA_BASE_UNIT` char(3) NOT NULL,
  `ECFA_TRANS_UNIT` char(3) NOT NULL,
  `ECFA_CONV_FACTOR` decimal(12,6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_coverage_terms`
--

DROP TABLE IF EXISTS `ezc_coverage_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_coverage_terms` (
  `ECT_TERM_ID` decimal(6,0) NOT NULL,
  `ECT_DESC` varchar(100) DEFAULT NULL,
  `ECT_SERVICE_CATEGORY` decimal(6,0) NOT NULL,
  `ECT_COST_TYPE` varchar(2) NOT NULL,
  `ECT_SEQUENCE` decimal(2,0) NOT NULL,
  `ECT_START_DATE` datetime DEFAULT NULL,
  `ECT_END_DATE` datetime DEFAULT NULL,
  `ECT_COVERAGE_PERCENTAGE` decimal(5,2) DEFAULT NULL,
  `ECT_COVERAGE_AMT` decimal(10,2) DEFAULT NULL,
  `ECT_COVERAGE_TYPE` char(1) DEFAULT NULL,
  `ECT_COST_AMT` decimal(10,2) DEFAULT NULL,
  `ECT_SALES_AMT` decimal(10,2) DEFAULT NULL,
  `ECT_ACT_COST_AMT` decimal(10,2) DEFAULT NULL,
  `ECT_ACT_SALES_AMT` decimal(10,2) DEFAULT NULL,
  `ECT_BUDG_COST_AMT` decimal(10,2) DEFAULT NULL,
  `ECT_BUDG_SALES_AMT` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_covered_products`
--

DROP TABLE IF EXISTS `ezc_covered_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_covered_products` (
  `ECP_HEADER_CODE` varchar(10) NOT NULL,
  `ECP_HEADER_TYPE` char(1) NOT NULL,
  `ECP_PRODUCT_CODE` varchar(20) NOT NULL,
  `ECP_PRODUCT_TYPE` char(1) DEFAULT NULL,
  `ECP_COVERAGE_START_DATE` datetime DEFAULT NULL,
  `ECP_COVERAGE_END_DATE` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_currency`
--

DROP TABLE IF EXISTS `ezc_currency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_currency` (
  `EC_CURR_KEY` char(5) NOT NULL,
  `EC_ISO_CURR_KEY` char(3) DEFAULT NULL,
  `EC_ALTERNATE_KEY` char(3) DEFAULT NULL,
  `EC_VALID_TO_DATE` char(12) DEFAULT NULL,
  PRIMARY KEY (`EC_CURR_KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_currency_conversion`
--

DROP TABLE IF EXISTS `ezc_currency_conversion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_currency_conversion` (
  `ECC_EXCHANGE_TYPE` char(4) NOT NULL,
  `ECC_FROM_ISO_CURR_KEY` char(3) NOT NULL,
  `ECC_TO_ISO_CURR_KEY` char(3) NOT NULL,
  `ECC_CONVERSION_RATE` decimal(10,4) DEFAULT NULL,
  `ECC_UPDATE_DATE` char(10) DEFAULT NULL,
  `ECC_UPDATE_TIME` char(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_currency_desc`
--

DROP TABLE IF EXISTS `ezc_currency_desc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_currency_desc` (
  `ECD_CURR_KEY` char(5) NOT NULL,
  `ECD_LANG` char(2) NOT NULL,
  `ECD_LONG_DESC` varchar(128) DEFAULT NULL,
  `ECD_SHORT_DESC` varchar(40) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_cust_hierarchy_mapping`
--

DROP TABLE IF EXISTS `ezc_cust_hierarchy_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_cust_hierarchy_mapping` (
  `ECHM_SALES_ORG` varchar(50) DEFAULT NULL,
  `ECHM_STEP` varchar(5) DEFAULT NULL,
  `ECHM_SRC_PARTICIPANT` varchar(20) DEFAULT NULL,
  `ECHM_DEST_PARTICIPANT` varchar(20) DEFAULT NULL,
  `ECHM_EXT1` varchar(10) DEFAULT NULL,
  `ECHM_EXT2` varchar(10) DEFAULT NULL,
  `ECHM_EXT3` varchar(10) DEFAULT NULL,
  `ECHM_EXT4` varchar(10) DEFAULT NULL,
  `ECHM_EXT5` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_customer`
--

DROP TABLE IF EXISTS `ezc_customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_customer` (
  `EC_NO` char(10) NOT NULL,
  `EC_SYS_KEY` varchar(18) NOT NULL,
  `EC_PARTNER_FUNCTION` char(4) NOT NULL,
  `EC_PARTNER_NO` char(10) NOT NULL,
  `EC_ERP_CUST_NO` char(10) NOT NULL,
  `EC_BUSINESS_PARTNER` char(10) NOT NULL,
  `EC_DELETION_FLAG` char(1) NOT NULL,
  UNIQUE KEY `EZC_CUSTOMER_U1` (`EC_NO`,`EC_SYS_KEY`,`EC_PARTNER_FUNCTION`,`EC_PARTNER_NO`,`EC_ERP_CUST_NO`,`EC_BUSINESS_PARTNER`,`EC_DELETION_FLAG`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_customer_addr`
--

DROP TABLE IF EXISTS `ezc_customer_addr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_customer_addr` (
  `ECA_NO` char(10) NOT NULL,
  `ECA_LANG` char(2) NOT NULL,
  `ECA_REFERENCE_NO` decimal(10,0) DEFAULT NULL,
  `ECA_PARTNER_LISTBOX_DESC` char(40) DEFAULT NULL,
  `ECA_NAME` varchar(64) DEFAULT NULL,
  `ECA_COMPANY_NAME` varchar(64) DEFAULT NULL,
  `ECA_PHONE` varchar(64) DEFAULT NULL,
  `ECA_EMAIL` varchar(64) DEFAULT NULL,
  `ECA_WEB_ADDR` varchar(256) DEFAULT NULL,
  `ECA_TITLE` char(15) DEFAULT NULL,
  `ECA_ADDR_1` varchar(64) DEFAULT NULL,
  `ECA_ADDR_2` varchar(64) DEFAULT NULL,
  `ECA_ADDR_3` varchar(64) DEFAULT NULL,
  `ECA_ADDR_4` varchar(64) DEFAULT NULL,
  `ECA_STREET` varchar(35) DEFAULT NULL,
  `ECA_COUNTRY` char(3) DEFAULT NULL,
  `ECA_COUNTRY_CODE` char(3) DEFAULT NULL,
  `ECA_POSTAL_CODE` char(10) DEFAULT NULL,
  `ECA_POBOX_CITY` varchar(35) DEFAULT NULL,
  `ECA_CITY` varchar(64) DEFAULT NULL,
  `ECA_DISTRICT` varchar(35) DEFAULT NULL,
  `ECA_STATE` varchar(64) DEFAULT NULL,
  `ECA_POBOX` char(10) DEFAULT NULL,
  `ECA_TEL1` char(16) DEFAULT NULL,
  `ECA_TEL2` char(16) DEFAULT NULL,
  `ECA_TELEBOX_NO` char(15) DEFAULT NULL,
  `ECA_FAX1` char(16) DEFAULT NULL,
  `ECA_TELETEX` varchar(30) DEFAULT NULL,
  `ECA_TELEX` varchar(30) DEFAULT NULL,
  `ECA_UNLOADING_INDICATOR` char(1) DEFAULT NULL,
  `ECA_TRANSORT_ZONE` char(10) DEFAULT NULL,
  `ECA_JURISDICTION_CODE` char(15) DEFAULT NULL,
  `ECA_PIN` varchar(64) DEFAULT NULL,
  `ECA_COUNTRY1` varchar(64) DEFAULT NULL,
  `ECA_SHIP_ADDR_1` varchar(64) DEFAULT NULL,
  `ECA_SHIP_ADDR_2` varchar(64) DEFAULT NULL,
  `ECA_SHIP_CITY` varchar(64) DEFAULT NULL,
  `ECA_SHIP_STATE` varchar(64) DEFAULT NULL,
  `ECA_SHIP_PIN` varchar(64) DEFAULT NULL,
  `ECA_SHIP_COUNTRY` varchar(64) DEFAULT NULL,
  `ECA_SO_DYN_ADDR_FLAG` char(1) DEFAULT NULL,
  `ECA_ERP_UPDATE_FLAG` char(1) DEFAULT NULL,
  `ECA_IS_BUSINESS_PARTNER` char(1) NOT NULL,
  `ECA_DELETION_FLAG` char(1) DEFAULT NULL,
  PRIMARY KEY (`ECA_NO`,`ECA_LANG`,`ECA_IS_BUSINESS_PARTNER`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_customer_config_data`
--

DROP TABLE IF EXISTS `ezc_customer_config_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_customer_config_data` (
  `ECCD_KEY` varchar(30) DEFAULT NULL,
  `ECCD_CODE` varchar(30) DEFAULT NULL,
  `ECCD_DESC` varchar(200) DEFAULT NULL,
  `ECCD_EXT1` varchar(50) DEFAULT NULL,
  `ECCD_EXT2` varchar(50) DEFAULT NULL,
  `ECCD_EXT3` varchar(50) DEFAULT NULL,
  `ECCD_EXT4` varchar(50) DEFAULT NULL,
  `ECCD_EXT5` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_customer_form_details`
--

DROP TABLE IF EXISTS `ezc_customer_form_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_customer_form_details` (
  `ECFD_DOC_ID` varchar(10) DEFAULT NULL,
  `ECFD_FIELD` varchar(20) DEFAULT NULL,
  `ECFD_VALUE` varchar(100) DEFAULT NULL,
  `ECFD_TAB_NAME` varchar(20) DEFAULT NULL,
  `ECFD_EXT1` varchar(10) DEFAULT NULL,
  `ECFD_EXT2` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_customer_form_header`
--

DROP TABLE IF EXISTS `ezc_customer_form_header`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_customer_form_header` (
  `ECFH_DOC_ID` varchar(10) NOT NULL,
  `ECFH_SALES_ORG` varchar(5) DEFAULT NULL,
  `ECFH_CUST_NAME` varchar(50) DEFAULT NULL,
  `ECFH_CREATED_BY` varchar(10) DEFAULT NULL,
  `ECFH_CREATED_ON` date DEFAULT NULL,
  `ECFH_MODIFIED_BY` varchar(10) DEFAULT NULL,
  `ECFH_MODIFIED_ON` date DEFAULT NULL,
  `ECFH_SAP_CODE` varchar(10) DEFAULT NULL,
  `ECFH_STATUS` varchar(15) DEFAULT NULL,
  `ECFH_EXT1` varchar(100) DEFAULT NULL,
  `ECFH_EXT2` varchar(40) DEFAULT NULL,
  `ECFH_EXT3` varchar(10) DEFAULT NULL,
  `ECFH_NEXT_PARTICIPANT` varchar(100) DEFAULT NULL,
  `ECFH_MASTER_TYPE` varchar(1) DEFAULT NULL,
  `ECFH_PAN_NO` varchar(15) DEFAULT NULL,
  `ECFH_VEN_GRP` varchar(10) DEFAULT NULL,
  `ECFH_VEN_TYPE` varchar(3) DEFAULT NULL,
  `ECFH_PLANT` varchar(5) DEFAULT NULL,
  `ECFH_CATEGORY` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`ECFH_DOC_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_customer_profile`
--

DROP TABLE IF EXISTS `ezc_customer_profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_customer_profile` (
  `ECP_ID` decimal(6,0) NOT NULL,
  `ECP_TITLE` varchar(5) DEFAULT NULL,
  `ECP_NAME` varchar(40) DEFAULT NULL,
  `ECP_HOUSE_NO` varchar(20) DEFAULT NULL,
  `ECP_POSTAL_CODE` varchar(10) DEFAULT NULL,
  `ECP_COUNTRY` varchar(5) DEFAULT NULL,
  `ECP_REGION` varchar(5) DEFAULT NULL,
  `ECP_TEL_NO` varchar(15) DEFAULT NULL,
  `ECP_MOBILE_NO` varchar(15) DEFAULT NULL,
  `ECP_FAX` varchar(15) DEFAULT NULL,
  `ECP_EMAIL` varchar(50) DEFAULT NULL,
  `ECP_TYPE` varchar(10) DEFAULT NULL,
  `ECP_COMPANY_NAME` varchar(40) DEFAULT NULL,
  `ECP_COMPANY_SIZE` varchar(10) DEFAULT NULL,
  `ECP_PROD_CATEGORY` varchar(20) DEFAULT NULL,
  `ECP_PROD_INT` varchar(20) DEFAULT NULL,
  `ECP_EXE_NAME` varchar(40) DEFAULT NULL,
  `ECP_EXE_CONTACT` varchar(15) DEFAULT NULL,
  `ECP_BANK_COUNTRY` varchar(20) DEFAULT NULL,
  `ECP_BANK_KEY` varchar(20) DEFAULT NULL,
  `ECP_BANK_ACCOUNT_NO` varchar(20) DEFAULT NULL,
  `ECP_ACCOUNT_HOLDER` varchar(30) DEFAULT NULL,
  `ECP_STATUS` varchar(30) DEFAULT NULL,
  `ECP_CREATED_ON` date DEFAULT NULL,
  `ECP_MODIFED_ON` date DEFAULT NULL,
  `ECP_MODIFED_BY` varchar(20) DEFAULT NULL,
  `ECP_EXT1` varchar(20) DEFAULT NULL,
  `ECP_EXT2` varchar(20) DEFAULT NULL,
  `ECP_EXT3` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ECP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_default_type_desc`
--

DROP TABLE IF EXISTS `ezc_default_type_desc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_default_type_desc` (
  `EDTD_DEFAULT_TYPE` char(1) NOT NULL,
  `EDTD_LANG` char(2) NOT NULL,
  `EDTD_DESC` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`EDTD_DEFAULT_TYPE`,`EDTD_LANG`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_defaults_desc`
--

DROP TABLE IF EXISTS `ezc_defaults_desc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_defaults_desc` (
  `EUDD_KEY` varchar(16) NOT NULL,
  `EUDD_SYS_KEY` varchar(18) NOT NULL,
  `EUDD_LANG` char(2) NOT NULL,
  `EUDD_DEFAULTS_DESC` char(120) NOT NULL,
  `EUDD_DEFAULT_TYPE` char(1) DEFAULT NULL,
  `EUDD_IS_MASTER` char(1) DEFAULT NULL,
  PRIMARY KEY (`EUDD_KEY`,`EUDD_SYS_KEY`,`EUDD_LANG`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_delegation_info`
--

DROP TABLE IF EXISTS `ezc_delegation_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_delegation_info` (
  `EDI_BUSINESS_PARTNER` char(10) DEFAULT NULL,
  `EDI_ORIGINAL_USER` varchar(10) NOT NULL,
  `EDI_VALID_FROM` varchar(20) NOT NULL,
  `EDI_VALID_TO` varchar(20) DEFAULT NULL,
  `EDI_PROCEDURE_TYPE` char(3) DEFAULT NULL,
  `EDI_DELEGATE_TO_USER` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_delivery_schedules`
--

DROP TABLE IF EXISTS `ezc_delivery_schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_delivery_schedules` (
  `EZDS_DOC_NUMBER` decimal(10,0) NOT NULL,
  `EZDS_ITM_NUMBER` decimal(6,0) NOT NULL,
  `EZDS_SCHED_LINE` decimal(4,0) NOT NULL,
  `EZDS_REQ_DATE` varchar(10) DEFAULT NULL,
  `EZDS_CON_DATE` varchar(10) DEFAULT NULL,
  `EZDS_DATE_TYPE` char(1) DEFAULT NULL,
  `EZDS_REQ_TIME` varchar(10) DEFAULT NULL,
  `EZDS_REQ_QTY` decimal(13,3) DEFAULT NULL,
  `EZDS_CON_QTY` decimal(13,3) DEFAULT NULL,
  `EZDS_REQ_DLV_BL` char(2) DEFAULT NULL,
  `EZDS_SCHED_TYPE` char(2) DEFAULT NULL,
  `EZDS_TP_DATE` varchar(10) DEFAULT NULL,
  `EZDS_MS_DATE` varchar(10) DEFAULT NULL,
  `EZDS_LOAD_DATE` varchar(10) DEFAULT NULL,
  `EZDS_GI_DATE` varchar(10) DEFAULT NULL,
  `EZDS_TP_TIME` varchar(10) DEFAULT NULL,
  `EZDS_MS_TIME` varchar(10) DEFAULT NULL,
  `EZDS_LOAD_TIME` varchar(10) DEFAULT NULL,
  `EZDS_GI_TIME` varchar(10) DEFAULT NULL,
  `EZDS_REFOBJTYPE` varchar(10) DEFAULT NULL,
  `EZDS_EXT1` varchar(10) DEFAULT NULL,
  `EZDS_EXT2` varchar(10) DEFAULT NULL,
  `EZDS_STATUS` char(1) DEFAULT NULL,
  `EZDS_BACK_END_NUMBER` varchar(10) DEFAULT NULL,
  `EZDS_BACK_ITM_NUMBER` varchar(6) DEFAULT NULL,
  `EZDS_BACK_SCHED_LINE` varchar(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_disclaimer_stamp`
--

DROP TABLE IF EXISTS `ezc_disclaimer_stamp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_disclaimer_stamp` (
  `USER_ID` varchar(20) DEFAULT NULL,
  `TIME_STAMP` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_dispatch_header`
--

DROP TABLE IF EXISTS `ezc_dispatch_header`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_dispatch_header` (
  `EDH_ID` decimal(10,0) NOT NULL,
  `EDH_VENDOR` varchar(10) NOT NULL,
  `EDH_PLANT` varchar(4) NOT NULL,
  `EDH_INV_NO` varchar(100) NOT NULL,
  `EDH_INV_DATE` datetime DEFAULT NULL,
  `EDH_INV_VALUE` varchar(18) DEFAULT NULL,
  `EDH_CREATED_BY` varchar(15) DEFAULT NULL,
  `EDH_CREATED_ON` datetime DEFAULT NULL,
  `EDH_MODIFIED_BY` varchar(15) DEFAULT NULL,
  `EDH_MODIFIED_ON` datetime DEFAULT NULL,
  `EDH_STATUS` varchar(20) DEFAULT NULL,
  `EDH_EXT1` varchar(15) DEFAULT NULL,
  `EDH_EXT2` varchar(15) DEFAULT NULL,
  `EDH_EXT3` varchar(15) DEFAULT NULL,
  `EDH_PO_NO` varchar(10) DEFAULT NULL,
  `EDH_MONTH` varchar(2) DEFAULT NULL,
  `EDH_YEAR` varchar(4) DEFAULT NULL,
  `EDH_DOC_TYPE` varchar(15) DEFAULT NULL,
  `EDH_SYSKEY` varchar(6) DEFAULT NULL,
  `EDH_SAP_ID` varchar(15) DEFAULT NULL,
  `EDH_SRV_ENTRY_NO` varchar(10) DEFAULT NULL,
  `EDH_SMARTDOC_STATUS` varchar(10) DEFAULT NULL,
  `EDH_SMARTDOC_STATUS_TEXT` varchar(100) DEFAULT NULL,
  `EDH_SMARTDOC_STATUS_UPDATED_ON` datetime DEFAULT NULL,
  PRIMARY KEY (`EDH_ID`,`EDH_VENDOR`,`EDH_PLANT`,`EDH_INV_NO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_dispatch_items`
--

DROP TABLE IF EXISTS `ezc_dispatch_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_dispatch_items` (
  `EDI_ID` decimal(10,0) NOT NULL,
  `EDI_SERIAL_NO` decimal(4,0) NOT NULL,
  `EDI_DELIVERY_NO` varchar(10) NOT NULL,
  `EDI_ORDER_NO` varchar(20) DEFAULT NULL,
  `EDI_ORDER_DATE` datetime DEFAULT NULL,
  `EDI_MATERIAL` varchar(10) NOT NULL,
  `EDI_MAT_DESC` varchar(40) DEFAULT NULL,
  `EDI_QUANTITY` varchar(18) DEFAULT NULL,
  `EDI_DISPATCH_DATE` datetime DEFAULT NULL,
  `EDI_SOLD_TO` varchar(10) DEFAULT NULL,
  `EDI_SOLD_TO_NAME` varchar(35) DEFAULT NULL,
  `EDI_LOCATION` varchar(50) DEFAULT NULL,
  `EDI_SHIP_TO` varchar(10) DEFAULT NULL,
  `EDI_SHIP_TO_NAME` varchar(35) DEFAULT NULL,
  `EDI_DESTINATION` varchar(100) DEFAULT NULL,
  `EDI_DISTANCE` varchar(18) DEFAULT NULL,
  `EDI_RATE` varchar(18) DEFAULT NULL,
  `EDI_TOTAL` varchar(18) DEFAULT NULL,
  `EDI_PLANT` varchar(4) DEFAULT NULL,
  `EDI_INCO_TERM` varchar(3) DEFAULT NULL,
  `EDI_EXT1` varchar(15) DEFAULT NULL,
  `EDI_EXT2` varchar(15) DEFAULT NULL,
  `EDI_EXT3` varchar(15) DEFAULT NULL,
  `EDI_DESTINATION_OLD` varchar(100) DEFAULT NULL,
  `EDI_DISTANCE_OLD` varchar(18) DEFAULT NULL,
  `EDI_RATE_OLD` varchar(18) DEFAULT NULL,
  `EDI_TOTAL_OLD` varchar(18) DEFAULT NULL,
  `EDI_DLV_ITEM` varchar(6) DEFAULT NULL,
  `EDI_QUANTITY_OLD` varchar(18) DEFAULT NULL,
  `EDI_SHIPMENT_ID` varchar(10) DEFAULT NULL,
  `EDI_CHANGE_FLAG` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`EDI_ID`,`EDI_SERIAL_NO`,`EDI_DELIVERY_NO`,`EDI_MATERIAL`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_dispatchinfo_header`
--

DROP TABLE IF EXISTS `ezc_dispatchinfo_header`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_dispatchinfo_header` (
  `EZDI_DELIVERYNO` varchar(10) NOT NULL,
  `EZDI_DC_NR` varchar(10) DEFAULT NULL,
  `EZDI_DC_DATE` datetime DEFAULT NULL,
  `EZDI_SO_NUM` decimal(10,0) NOT NULL,
  `EZDI_SO_DATE` datetime DEFAULT NULL,
  `EZDI_INV_NUM` varchar(20) DEFAULT NULL,
  `EZDI_INV_DATE` datetime DEFAULT NULL,
  `EZDI_CREATED_BY` varchar(10) DEFAULT NULL,
  `EZDI_CREATED_ON` datetime DEFAULT NULL,
  `EZDI_LAST_MOD_ON` datetime DEFAULT NULL,
  `EZDI_LR_RR_AIR_NR` varchar(30) DEFAULT NULL,
  `EZDI_SHIPMENT_DATE` datetime DEFAULT NULL,
  `EZDI_CARRIER` varchar(50) DEFAULT NULL,
  `EZDI_EXP_ARIVAL_TIME` datetime DEFAULT NULL,
  `EZDI_SOLDTO` varchar(10) NOT NULL,
  `EZDI_SHIPTO` varchar(10) DEFAULT NULL,
  `EZDI_SYSKEY` varchar(18) NOT NULL,
  `EZDI_GOODS_RECEIVED` datetime DEFAULT NULL,
  `EZDI_STATUS` char(1) DEFAULT NULL,
  `EZDI_EXT1` varchar(10) DEFAULT NULL,
  `EZDI_EXT2` varchar(30) DEFAULT NULL,
  `EZDI_TEXT` varchar(3024) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_dispatchinfo_lines`
--

DROP TABLE IF EXISTS `ezc_dispatchinfo_lines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_dispatchinfo_lines` (
  `EZDL_DELIVERYNO` varchar(10) NOT NULL,
  `EZDL_LINE_NR` decimal(10,0) DEFAULT NULL,
  `EZDL_MAT_NR` varchar(18) DEFAULT NULL,
  `EZDL_MAT_DESC` varchar(50) DEFAULT NULL,
  `EZDL_UOM` varchar(5) DEFAULT NULL,
  `EZDL_QTY_SHIPPED` decimal(15,3) DEFAULT NULL,
  `EZDL_RECEIPTS` decimal(15,3) DEFAULT NULL,
  `EZDL_PLANT` varchar(10) DEFAULT NULL,
  `EZDL_BATCHNO` varchar(10) DEFAULT NULL,
  `EZDL_REFNO` varchar(10) DEFAULT NULL,
  `EZDL_LINEREF` decimal(10,0) DEFAULT NULL,
  `EZDL_REMARKS` varchar(1500) DEFAULT NULL,
  `EZDL_EXT1` varchar(10) DEFAULT NULL,
  `EZDL_EXT2` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_dms_url_files`
--

DROP TABLE IF EXISTS `ezc_dms_url_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_dms_url_files` (
  `EDUF_ID` varchar(11) NOT NULL,
  `EDUF_DOC_TYPE` varchar(15) NOT NULL,
  `EDUF_SAP_ID` varchar(15) NOT NULL,
  `EDUF_DMS_DOC_ID` varchar(50) NOT NULL,
  `EDUF_DMS_URL` varchar(1000) DEFAULT NULL,
  `EDUF_FILE_NAME` varchar(100) DEFAULT NULL,
  `EDUF_UPLOAD_STATUS` varchar(10) DEFAULT NULL,
  `EDUF_EXT1` varchar(10) DEFAULT NULL,
  `EDUF_EXT2` varchar(10) DEFAULT NULL,
  `EDUF_EXT3` varchar(10) DEFAULT NULL,
  `EDUF_ATTACHED_BY` varchar(15) DEFAULT NULL,
  `EDUF_ATTACHED_ON` datetime DEFAULT NULL,
  PRIMARY KEY (`EDUF_ID`,`EDUF_DOC_TYPE`,`EDUF_SAP_ID`,`EDUF_DMS_DOC_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_document_comments`
--

DROP TABLE IF EXISTS `ezc_document_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_document_comments` (
  `EDC_DOC_ID` varchar(20) NOT NULL,
  `edc_doc_type` varchar(20) NOT NULL,
  `EDC_COMMENTS` varchar(5000) DEFAULT NULL,
  `EDC_USER_ID` varchar(60) NOT NULL,
  `EDC_DATE` datetime NOT NULL,
  `EDC_EXT1` varchar(50) DEFAULT NULL,
  `EDC_EXT2` varchar(50) DEFAULT NULL,
  `EDC_EXT3` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_document_texts`
--

DROP TABLE IF EXISTS `ezc_document_texts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_document_texts` (
  `EDT_DOCTYPE` varchar(20) NOT NULL,
  `EDT_DOCNO` varchar(20) NOT NULL,
  `EDT_SYSKEY` varchar(18) NOT NULL,
  `EDT_KEY` varchar(20) NOT NULL,
  `EDT_VALUE` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_equip_type_code`
--

DROP TABLE IF EXISTS `ezc_equip_type_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_equip_type_code` (
  `EETC_EQUIP_TYPE_CODE` varchar(6) NOT NULL,
  `EETC_SKILLS` varchar(300) DEFAULT NULL,
  `EETC_RT_OFFSET` decimal(18,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_equipment`
--

DROP TABLE IF EXISTS `ezc_equipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_equipment` (
  `EE_EQUIPMENT_CODE` varchar(10) NOT NULL,
  `EE_BUSS_PARTNER` char(10) DEFAULT NULL,
  `EE_CUSTOMER_NAME` varchar(100) DEFAULT NULL,
  `EE_INSTALL_DATE` datetime DEFAULT NULL,
  `EE_SKILLS` varchar(300) DEFAULT NULL,
  `EE_PREF_ENGINEER` char(10) DEFAULT NULL,
  `EE_WARRANTY_CODE` varchar(20) DEFAULT NULL,
  `EE_WARRANTY_EFF_DATE` datetime DEFAULT NULL,
  `EE_WARRANTY_EXP_DATE` datetime DEFAULT NULL,
  `EE_MANUFACTURER_ID` char(50) DEFAULT NULL,
  `EE_OEM_SLNO` varchar(50) DEFAULT NULL,
  `EE_DERIVED_FROM` varchar(10) DEFAULT NULL,
  `EE_EQUIP_TYPE_CODE` varchar(6) DEFAULT NULL,
  `EE_RT_OFFSET` decimal(18,0) DEFAULT NULL,
  `EE_MODEL_CODE` varchar(20) DEFAULT NULL,
  `EE_CONTACT_PERSON` varchar(100) DEFAULT NULL,
  `EE_DEPARTMENT` varchar(100) DEFAULT NULL,
  `EE_ADDRESS_CODE` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_erp_customer_auth`
--

DROP TABLE IF EXISTS `ezc_erp_customer_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_erp_customer_auth` (
  `EECA_NO` char(10) NOT NULL,
  `EECA_AUTH_KEY` varchar(10) DEFAULT NULL,
  `EECA_AUTH_VALUE` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`EECA_NO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_erp_customer_defaults`
--

DROP TABLE IF EXISTS `ezc_erp_customer_defaults`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_erp_customer_defaults` (
  `EECD_NO` char(10) NOT NULL,
  `EECD_DEFAULTS_KEY` varchar(128) NOT NULL,
  `EECD_DEFAULTS_VALUE` varchar(128) DEFAULT NULL,
  `EECD_SYS_KEY` varchar(18) NOT NULL,
  PRIMARY KEY (`EECD_NO`,`EECD_SYS_KEY`,`EECD_DEFAULTS_KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_erp_validation_routines`
--

DROP TABLE IF EXISTS `ezc_erp_validation_routines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_erp_validation_routines` (
  `EEV_ERP_SYSTEM` varchar(20) NOT NULL,
  `EEV_ERP_VERSION` varchar(20) NOT NULL,
  `EEV_ERP_CONTAINER` varchar(50) DEFAULT NULL,
  `EEV_ERP_STRUCTURE` varchar(50) DEFAULT NULL,
  `EEV_ERP_FIELD` varchar(25) DEFAULT NULL,
  `EEV_ERP_ROUTINE_TYPE` varchar(20) DEFAULT NULL,
  `EEV_ERP_ROUTINE_CLASS` varchar(50) DEFAULT NULL,
  `EEV_ERP_ROUTINE_METHOD` varchar(50) DEFAULT NULL,
  `EEV_CLIENT` decimal(3,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_error_desc`
--

DROP TABLE IF EXISTS `ezc_error_desc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_error_desc` (
  `EED_ERROR_CODE` decimal(6,0) NOT NULL,
  `EED_LANG` char(2) NOT NULL,
  `EED_ERROR_TEXT` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`EED_ERROR_CODE`,`EED_LANG`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_event_obj_history`
--

DROP TABLE IF EXISTS `ezc_event_obj_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_event_obj_history` (
  `EEOH_TIME_STAMP` datetime NOT NULL,
  `EEOH_ACTIVITY_TYPE` char(1) DEFAULT NULL,
  `EEOH_STATUS_BEFORE_CHANGE` varchar(10) DEFAULT NULL,
  `EEOH_STATUS_AFTER_CHANGE` varchar(10) DEFAULT NULL,
  `EEOH_ASSIGNED_TO_USER_BEFORE_CHANGE` char(10) DEFAULT NULL,
  `EEOH_ASSIGNED_TO_USER_AFTER_CHANGE` char(10) DEFAULT NULL,
  `EEOH_INTERNAL_TEXT` varchar(2048) DEFAULT NULL,
  `EEOH_ADVERSE_EVENT_ID` decimal(18,0) NOT NULL,
  `EEOH_EXTERNAL_TEXT` varchar(2048) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_exchange_info`
--

DROP TABLE IF EXISTS `ezc_exchange_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_exchange_info` (
  `EEI_CLIENT` decimal(3,0) NOT NULL,
  `EEI_SYS_NO` decimal(3,0) NOT NULL,
  `EEI_CAT_AREA` varchar(18) NOT NULL,
  `EEI_PUR_REQ` char(10) NOT NULL,
  `EEI_STATUS` char(1) DEFAULT NULL,
  `EEI_MAT_NO` varchar(18) NOT NULL,
  `EEI_MAT_QTY` decimal(6,0) NOT NULL,
  `EEI_VEND_NO` char(10) DEFAULT NULL,
  `EEI_PUR_ORD_NO` char(10) DEFAULT NULL,
  `EEI_CUST_NO` char(10) DEFAULT NULL,
  `EEI_SALES_ORD_NO` char(10) DEFAULT NULL,
  `EEI_CREATED_DATE` char(10) DEFAULT NULL,
  `EEI_CREATED_TIME` char(10) DEFAULT NULL,
  `EEI_CREATED_BY` char(10) DEFAULT NULL,
  `EEI_REF1` varchar(128) DEFAULT NULL,
  `EEI_REF2` varchar(128) DEFAULT NULL,
  `EEI_EXTERNAL_LINK` varchar(256) DEFAULT NULL,
  `EEI_UOM` char(5) DEFAULT NULL,
  `EEI_PRICE` decimal(6,2) DEFAULT NULL,
  `EEI_REQ_DATE` char(10) DEFAULT NULL,
  PRIMARY KEY (`EEI_CLIENT`,`EEI_SYS_NO`,`EEI_CAT_AREA`,`EEI_PUR_REQ`,`EEI_MAT_NO`,`EEI_MAT_QTY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_eyeball_track_info`
--

DROP TABLE IF EXISTS `ezc_eyeball_track_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_eyeball_track_info` (
  `EETI_DOMAIN` char(1) DEFAULT NULL,
  `EETI_SYSKEY` varchar(6) DEFAULT NULL,
  `EETI_VALUE1` varchar(20) DEFAULT NULL,
  `EETI_VALUE2` varchar(20) DEFAULT NULL,
  `EETI_VALUE3` varchar(20) DEFAULT NULL,
  `EETI_SOLDTO` char(10) DEFAULT NULL,
  `EETI_USERID` char(10) DEFAULT NULL,
  `EETI_DATE` datetime DEFAULT NULL,
  `EETI_GROUP` decimal(2,0) DEFAULT NULL,
  `EETI_OPTION` decimal(3,0) DEFAULT NULL,
  `EETI_HITS` decimal(4,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_folder_info`
--

DROP TABLE IF EXISTS `ezc_folder_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_folder_info` (
  `EFI_CLIENT` decimal(3,0) NOT NULL,
  `EFI_FOLDER_ID` decimal(9,0) NOT NULL,
  `EFI_CREATED_BY` char(10) NOT NULL,
  `EFI_LANG` char(2) NOT NULL,
  `EFI_FOLDER_NAME` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_forum`
--

DROP TABLE IF EXISTS `ezc_forum`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_forum` (
  `EFA_CLIENT` decimal(3,0) NOT NULL,
  `EFA_FORUM_ID` char(20) NOT NULL,
  `EFA_MSG_ID` char(18) NOT NULL,
  `EFA_MSG_THREAD` char(32) DEFAULT NULL,
  `EFA_MSG_TYPE` char(3) DEFAULT NULL,
  `EFA_MSG_FLAG` char(1) DEFAULT NULL,
  `EFA_MSG_HEADER` varchar(256) DEFAULT NULL,
  `EFA_MSG_CONTENT1` varchar(2000) DEFAULT NULL,
  `EFA_MSG_CONTENT2` varchar(2000) DEFAULT NULL,
  `EFA_LNK_EXT_INFO` varchar(256) DEFAULT NULL,
  `EFA_CREATED_BY` varchar(10) DEFAULT NULL,
  `EFA_MSG_CREATION_DATE` char(10) DEFAULT NULL,
  `EFA_MSG_CREATION_TIME` char(20) DEFAULT NULL,
  `EFA_DSPL_ID` varchar(64) DEFAULT NULL,
  `EFA_DSPL_LEVEL` decimal(4,0) DEFAULT NULL,
  `EFA_LAST_NUMBER` decimal(9,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_forum_info`
--

DROP TABLE IF EXISTS `ezc_forum_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_forum_info` (
  `EFI_CLIENT` decimal(3,0) NOT NULL,
  `EFI_FORUM_ID` char(20) NOT NULL,
  `EFI_CREATED_BY` char(10) DEFAULT NULL,
  `EFI_FORUM_MODERATOR` char(10) DEFAULT NULL,
  `EFI_LANGUAGE` char(3) NOT NULL,
  `EFI_FORUM_NAME` varchar(256) DEFAULT NULL,
  `EFI_ACCESS_INDICATOR` char(1) DEFAULT NULL,
  `EFI_CREATION_DATE` char(10) DEFAULT NULL,
  `EFI_CREATION_TIME` char(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_forum_subscription`
--

DROP TABLE IF EXISTS `ezc_forum_subscription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_forum_subscription` (
  `EFS_CLIENT` decimal(3,0) NOT NULL,
  `EFS_FORUM_ID` char(20) NOT NULL,
  `EFS_SUB_USER_ID` char(10) NOT NULL,
  `EFS_SUB_DATE` char(10) DEFAULT NULL,
  `EFS_SUB_TIME` char(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_group_auth`
--

DROP TABLE IF EXISTS `ezc_group_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_group_auth` (
  `EGA_GROUP_ID` char(10) NOT NULL,
  `EGA_AUTH_KEY` varchar(10) DEFAULT NULL,
  `EGA_AUTH_VALUE` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`EGA_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_group_defaults`
--

DROP TABLE IF EXISTS `ezc_group_defaults`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_group_defaults` (
  `EGD_GROUP_ID` char(10) NOT NULL,
  `EGD_KEY` varchar(10) DEFAULT NULL,
  `EGD_VALUE` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`EGD_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_hierarchy_structure`
--

DROP TABLE IF EXISTS `ezc_hierarchy_structure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_hierarchy_structure` (
  `EHS_SYS_NO` decimal(3,0) NOT NULL,
  `EHS_LEVEL` decimal(3,0) NOT NULL,
  `EHS_OFFSET` decimal(2,0) NOT NULL,
  PRIMARY KEY (`EHS_SYS_NO`,`EHS_LEVEL`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_job_control`
--

DROP TABLE IF EXISTS `ezc_job_control`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_job_control` (
  `EJC_CLIENT` decimal(6,0) DEFAULT NULL,
  `EJC_BUSS_PARTNER` char(10) DEFAULT NULL,
  `EJC_USER_ID` varchar(10) NOT NULL,
  `EJC_JOB_ID` varchar(25) NOT NULL,
  `EJC_JOB_TYPE` char(3) NOT NULL,
  `EJC_TRANSACTION` varchar(30) NOT NULL,
  `EJC_CREATION_DATE` decimal(6,0) DEFAULT NULL,
  `EJC_CREATION_TIME` decimal(6,0) DEFAULT NULL,
  `EJC_FILE_PATH` varchar(255) DEFAULT NULL,
  `EJC_START_DATE` decimal(6,0) DEFAULT NULL,
  `EJC_START_TIME` decimal(6,0) DEFAULT NULL,
  `EJC_EXPIRY_DATE` decimal(6,0) DEFAULT NULL,
  `EJC_TIME_INTREVAL` decimal(6,0) DEFAULT NULL,
  `EJC_TIME_UNIT` char(2) DEFAULT NULL,
  `EJS_SUBSCRIPTION_FLAG` char(1) DEFAULT NULL,
  `EJS_CONFIRMATION_NEEDED` char(1) DEFAULT NULL,
  `EJS_COMPLETION_NEEDED` char(1) DEFAULT NULL,
  `EJS_RESPONCE_TYPE` char(1) DEFAULT NULL,
  `EJC_STATUS` char(2) DEFAULT NULL,
  `EJS_COMPLETION_TIME` decimal(6,0) DEFAULT NULL,
  `EJS_PRIORITY_CODE` char(2) DEFAULT NULL,
  `EJC_CHANGE_DATE` decimal(6,0) DEFAULT NULL,
  `EJC_CHANGE_TIME` decimal(6,0) DEFAULT NULL,
  `EJC_CHANGED_BY` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_job_description`
--

DROP TABLE IF EXISTS `ezc_job_description`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_job_description` (
  `EJD_JOB_ID` varchar(25) NOT NULL,
  `EJD_JOB_DESCRIPTION` varchar(25) DEFAULT NULL,
  `EJD_JOB_LANGUAGE` char(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_job_history`
--

DROP TABLE IF EXISTS `ezc_job_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_job_history` (
  `EJH_BUSS_PARTNER` char(10) DEFAULT NULL,
  `EJH_CLIENT` char(5) NOT NULL,
  `EJH_USER_ID` varchar(10) NOT NULL,
  `EJH_JOB_ID` varchar(25) NOT NULL,
  `EJH_JOB_TYPE` char(3) DEFAULT NULL,
  `EJH_DATE` varchar(10) DEFAULT NULL,
  `EJH_TIME` varchar(20) DEFAULT NULL,
  `EJH_EXCEPTIONS1` varchar(255) DEFAULT NULL,
  `EJH_EXCEPTIONS2` varchar(255) DEFAULT NULL,
  `EJH_EXCEPTIONS3` varchar(255) DEFAULT NULL,
  `EJH_EXCEPTIONS4` varchar(255) DEFAULT NULL,
  `EJH_EXEC_USER_ID` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_job_params`
--

DROP TABLE IF EXISTS `ezc_job_params`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_job_params` (
  `EJB_BUSINES_PARTNER` char(10) NOT NULL,
  `EJB_CLIENT` char(5) NOT NULL,
  `EJB_USER_ID` char(10) NOT NULL,
  `EJB_JOB_ID` varchar(25) NOT NULL,
  `EJB_JOB_TYPE` char(3) DEFAULT NULL,
  `EJB_PARAMETER_NAME` varchar(25) NOT NULL,
  `EJB_FROM_VALUE` varchar(128) DEFAULT NULL,
  `EJB_TO_VALUE` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_job_schedule`
--

DROP TABLE IF EXISTS `ezc_job_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_job_schedule` (
  `EJS_CLIENT` char(5) DEFAULT NULL,
  `EJS_BUSS_PARTNER` char(10) DEFAULT NULL,
  `EJS_USER_ID` varchar(10) NOT NULL,
  `EJS_JOB_ID` varchar(25) NOT NULL,
  `EJS_JOB_TYPE` char(3) NOT NULL,
  `EJS_TRANSACTION` varchar(30) NOT NULL,
  `EJS_START_DATE` varchar(10) DEFAULT NULL,
  `EJS_START_TIME` varchar(20) DEFAULT NULL,
  `EJS_TIME_INTERVAL` decimal(10,0) DEFAULT NULL,
  `EJS_TIME_UNIT` char(2) DEFAULT NULL,
  `EJS_STATUS` char(2) DEFAULT NULL,
  `EJS_FILE_PATH` varchar(255) DEFAULT NULL,
  `EJS_EXPIRE_DATE` varchar(10) DEFAULT NULL,
  `EJS_SUBSCRIPTION_FLAG` char(1) DEFAULT NULL,
  `EJS_CONFIRMATION_NEEDED` char(1) DEFAULT NULL,
  `EJS_COMPLETION_NEEDED` char(1) DEFAULT NULL,
  `EJS_RESPONCE_TYPE` char(1) DEFAULT NULL,
  `EJS_CHANGE_DATE` varchar(10) DEFAULT NULL,
  `EJS_CHANGE_TIME` varchar(20) DEFAULT NULL,
  `EJS_CHANGED_BY` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_labor_rates`
--

DROP TABLE IF EXISTS `ezc_labor_rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_labor_rates` (
  `ELRT_LABOR_RATE_CODE` varchar(3) NOT NULL,
  `ELRT_LABOR_AMOUNT` decimal(10,2) DEFAULT NULL,
  `ELRT_LABOR_AMOUNT_CURRENCY` varchar(3) DEFAULT NULL,
  `ELRT_LABOR_AMOUNT_UNIT` varchar(3) DEFAULT NULL,
  `ELRT_LABOR_RATE_BASE` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_labor_reqmt`
--

DROP TABLE IF EXISTS `ezc_labor_reqmt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_labor_reqmt` (
  `EZLR_REQMT_ID` decimal(18,0) NOT NULL,
  `EZLR_ORDER_ID` decimal(18,0) NOT NULL,
  `EZLR_OPERATION_ID` decimal(18,0) NOT NULL,
  `EZLR_SKILL_CODE` varchar(6) DEFAULT NULL,
  `EZLR_ESTIMATED_TIME_REQUIRED` decimal(10,2) DEFAULT NULL,
  `EZLR_ESTIMATED_COST_RATE` decimal(14,4) DEFAULT NULL,
  `EZLR_ESTIMATED_SELLING_RATE` decimal(14,4) DEFAULT NULL,
  `EZLR_ACTUAL_TIME` decimal(10,2) DEFAULT NULL,
  `EZLR_ACTUAL_COST_RATE` decimal(14,4) DEFAULT NULL,
  `EZLR_ACTUAL_SELLING_RATE` decimal(14,4) DEFAULT NULL,
  `EZLR_TIME_UNIT` varchar(3) DEFAULT NULL,
  `EZLR_RATE_UNIT` varchar(3) DEFAULT NULL,
  `EZLR_RATE_CURRENCY` varchar(3) DEFAULT NULL,
  `EZLR_REQUIRED_RESOURCE` decimal(18,0) DEFAULT NULL,
  `EZLR_SCHEDULED_DATE` datetime DEFAULT NULL,
  `EZLR_ACTUAL_DATE` datetime DEFAULT NULL,
  `EZLR_STARTED_AT` datetime DEFAULT NULL,
  `EZLR_CLOSED_AT` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_lang_keys`
--

DROP TABLE IF EXISTS `ezc_lang_keys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_lang_keys` (
  `ELK_LANG` char(2) NOT NULL,
  `ELK_ISO_LANG` char(2) NOT NULL,
  `ELK_LANG_DESC` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`ELK_ISO_LANG`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_link_controller`
--

DROP TABLE IF EXISTS `ezc_link_controller`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_link_controller` (
  `ELC_ID` int NOT NULL,
  `ELC_DOC_ID` varchar(20) DEFAULT NULL,
  `ELC_DOC_TYPE` varchar(20) DEFAULT NULL,
  `ELC_USER` varchar(20) DEFAULT NULL,
  `ELC_EMAIL` varchar(5000) DEFAULT NULL,
  `ELC_MAIL_TEXT` mediumtext,
  `ELC_CREATED_ON` datetime DEFAULT NULL,
  `ELC_STATUS` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`ELC_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_log_materials`
--

DROP TABLE IF EXISTS `ezc_log_materials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_log_materials` (
  `ESM_PLANT` varchar(5) NOT NULL,
  `ESM_MATERIAL` varchar(18) NOT NULL,
  `ESM_MATERIAL_DESC` varchar(50) DEFAULT NULL,
  `ESM_TYPE` varchar(50) DEFAULT NULL,
  `ESM_UOM` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`ESM_PLANT`,`ESM_MATERIAL`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_mail_groups`
--

DROP TABLE IF EXISTS `ezc_mail_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_mail_groups` (
  `EMG_GROUPID` varchar(6) NOT NULL,
  `EMG_GROUPDESC` varchar(50) DEFAULT NULL,
  `EMG_HOST` varchar(30) DEFAULT NULL,
  `emg_from` varchar(100) DEFAULT NULL,
  `EMG_DEBUG` varchar(1) DEFAULT NULL,
  `EMG_LOGFILE` varchar(50) DEFAULT NULL,
  `EMG_EXCEPTIONLISTENER` varchar(50) DEFAULT NULL,
  `EMG_SUPPORT_INCOMING` varchar(1) DEFAULT NULL,
  `EMG_INCOMING_PROTOCOL` varchar(6) DEFAULT NULL,
  `EMG_INCOMING_PORT` varchar(6) DEFAULT NULL,
  `EMG_SUPPORT_OUTGOING` varchar(1) DEFAULT NULL,
  `EMG_OUTGOING_PORT` varchar(6) DEFAULT NULL,
  `EMG_JMSENABLED` varchar(1) DEFAULT NULL,
  `EMG_DESTINATION_TYPE` varchar(1) DEFAULT NULL,
  `EMG_PROVIDER_URL` varchar(50) DEFAULT NULL,
  `EMG_CONTEXT_FACTORY` varchar(255) DEFAULT NULL,
  `EMG_DESTINATION_FACTORY` varchar(50) DEFAULT NULL,
  `EMG_DESTINATION_NAME` varchar(50) DEFAULT NULL,
  `EMG_AUTH_REQD` char(1) DEFAULT NULL,
  `EMG_USER_ID` varchar(30) DEFAULT NULL,
  `EMG_PASSWORD` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_main_order_operation`
--

DROP TABLE IF EXISTS `ezc_main_order_operation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_main_order_operation` (
  `EZMOOP_OPERATION_ID` decimal(18,0) NOT NULL,
  `EZMOOP_ORDER_ID` decimal(18,0) NOT NULL,
  `EZMOOP_OPERATION_STATUS` varchar(10) DEFAULT NULL,
  `EZMOOP_OPERATION_TYPE` varchar(10) DEFAULT NULL,
  `EZMOOP_SCHEDULE_START_DATE` datetime DEFAULT NULL,
  `EZMOOP_SCHEDULE_END_DATE` datetime DEFAULT NULL,
  `EZMOOP_PLAN_START_DATE` datetime DEFAULT NULL,
  `EZMOOP_PLAN_END_DATE` datetime DEFAULT NULL,
  `EZMOOP_ACTUAL_START_DATE` datetime DEFAULT NULL,
  `EZMOOP_ACTUAL_END_DATE` datetime DEFAULT NULL,
  `EZMOOP_ESTIMATED_DURATION` decimal(5,2) DEFAULT NULL,
  `EZMOOP_ACTUAL_DURATION` decimal(5,2) DEFAULT NULL,
  `EZMOOP_REMAINING_DURATION` decimal(5,2) DEFAULT NULL,
  `EZMOOP_PRIMARY_ENGINEER` char(10) DEFAULT NULL,
  `EZMOOP_SERVICE_AREA` varchar(3) DEFAULT NULL,
  `EZMOOP_SERVICE_CENTER` varchar(3) DEFAULT NULL,
  `EZMOOP_DURATION_UNIT` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_maint_act_group`
--

DROP TABLE IF EXISTS `ezc_maint_act_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_maint_act_group` (
  `EMAG_GRP_CODE` decimal(6,0) NOT NULL,
  `EMAG_LANG` char(2) DEFAULT NULL,
  `EMAG_DESCRIPTION` varchar(50) DEFAULT NULL,
  `EMAG_GRP_STAGE` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_maint_act_grp_activities`
--

DROP TABLE IF EXISTS `ezc_maint_act_grp_activities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_maint_act_grp_activities` (
  `EMAGA_GRP_CODE` decimal(6,0) DEFAULT NULL,
  `EMAGA_SEQ_NUMBER` decimal(3,0) DEFAULT NULL,
  `EMAGA_OFFSET` decimal(6,0) DEFAULT NULL,
  `EMAGA_ACTIVITY_CODE` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_mainte_activity_skills`
--

DROP TABLE IF EXISTS `ezc_mainte_activity_skills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_mainte_activity_skills` (
  `EMAS_ACTIVITY_CODE` varchar(6) NOT NULL,
  `EMAS_ACTIVITY_STAGE` char(1) NOT NULL,
  `EMAS_SKILLCODE` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_mainte_activity_tools`
--

DROP TABLE IF EXISTS `ezc_mainte_activity_tools`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_mainte_activity_tools` (
  `EMAT_ACTIVITY_CODE` varchar(6) NOT NULL,
  `EMAT_ACTIVITY_STAGE` char(1) NOT NULL,
  `EMAT_SEQ_NUMBER` decimal(5,0) NOT NULL,
  `EMAT_TOOL_CODE` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_mainte_labor_requirements`
--

DROP TABLE IF EXISTS `ezc_mainte_labor_requirements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_mainte_labor_requirements` (
  `EMLR_ACTIVITY_CODE` varchar(6) NOT NULL,
  `EMLR_ACTIVITY_STAGE` char(1) NOT NULL,
  `EMLR_LABOR_CODE` varchar(3) NOT NULL,
  `EMLR_RESOURCES_REQD` decimal(6,2) DEFAULT NULL,
  `EMLR_TIME_REQD` decimal(6,2) DEFAULT NULL,
  `EMLR_TIME_UNIT` char(3) DEFAULT NULL,
  `EMLR_SEQ_NUMBER` decimal(3,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_mainte_mat_requirements`
--

DROP TABLE IF EXISTS `ezc_mainte_mat_requirements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_mainte_mat_requirements` (
  `EMMR_ACTIVITY_CODE` varchar(6) NOT NULL,
  `EMMR_ACTIVITY_STAGE` char(1) NOT NULL,
  `EMMR_SPARE_CODE` decimal(6,0) NOT NULL,
  `EMMR_PROD_CODE` decimal(6,0) NOT NULL,
  `EMMR_PROD_CATEGORY` char(1) DEFAULT NULL,
  `EMMR_QUANTITY` decimal(10,4) DEFAULT NULL,
  `EMMR_QTY_UNIT` char(3) DEFAULT NULL,
  `EMMR_SEQ_NUMBER` decimal(3,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_mainte_other_requirements`
--

DROP TABLE IF EXISTS `ezc_mainte_other_requirements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_mainte_other_requirements` (
  `EMOR_ACTIVITY_CODE` varchar(6) NOT NULL,
  `EMOR_ACTIVITY_STAGE` char(1) NOT NULL,
  `EMOR_SEQ_NUMBER` decimal(5,0) NOT NULL,
  `EMOR_DESC` varchar(100) DEFAULT NULL,
  `EMOR_TYPE` char(1) DEFAULT NULL,
  `EMOR_QTY_REQD` decimal(10,4) DEFAULT NULL,
  `EMOR_QTY_UNIT` char(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_maintenance_activity`
--

DROP TABLE IF EXISTS `ezc_maintenance_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_maintenance_activity` (
  `EMA_ACTIVITY_CODE` varchar(6) NOT NULL,
  `EMA_ACTIVITY_STAGE` char(1) NOT NULL,
  `EMA_LANG` char(2) DEFAULT NULL,
  `EMA_DESC` varchar(100) DEFAULT NULL,
  `EMA_GENERAL_TEXT` varchar(500) DEFAULT NULL,
  `EMA_CHECK_LIST` varchar(500) DEFAULT NULL,
  `EMA_SPECIAL_INSTRUCTIONS` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_maintenance_order`
--

DROP TABLE IF EXISTS `ezc_maintenance_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_maintenance_order` (
  `EMO_ORDER_ID` decimal(18,0) NOT NULL,
  `EMO_ORDER_TYPE` char(1) DEFAULT NULL,
  `EMO_SERREQ_OR_SCHEDULE_ID` decimal(18,0) DEFAULT NULL,
  `EMO_PARENT_ORDER_ID` decimal(18,0) DEFAULT NULL,
  `EMO_INSTRUMENT_CODE` varchar(10) DEFAULT NULL,
  `EMO_RESPONSIBLE_ENGINEER` char(10) DEFAULT NULL,
  `EMO_INSTR_CONTACT_PERSON` varchar(50) DEFAULT NULL,
  `EMO_INSTR_FAILURE_DATE` datetime DEFAULT NULL,
  `EMO_REPORTING_DATE` datetime DEFAULT NULL,
  `EMO_PROBLEM_CODE` varchar(6) DEFAULT NULL,
  `EMO_ORDER_STATUS` varchar(10) DEFAULT NULL,
  `EMO_ORDER_STATUS_DATE` datetime DEFAULT NULL,
  `EMO_LAST_CHANGE_DATE` datetime DEFAULT NULL,
  `EMO_SERVICE_AREA` varchar(3) DEFAULT NULL,
  `EMO_SERVICE_CENTER` varchar(3) DEFAULT NULL,
  `EMO_REQUESTOR_ID` varchar(10) DEFAULT NULL,
  `EMO_TEL_NO` varchar(64) DEFAULT NULL,
  `EMO_SCHEDULE_START_DATE` datetime DEFAULT NULL,
  `EMO_SCHEDULE_END_DATE` datetime DEFAULT NULL,
  `EMO_PLAN_START_DATE` datetime DEFAULT NULL,
  `EMO_PLAN_END_DATE` datetime DEFAULT NULL,
  `EMO_ACTUAL_START_DATE` datetime DEFAULT NULL,
  `EMO_ACTUAL_END_DATE` datetime DEFAULT NULL,
  `EMO_ESTIMATED_DURATION` decimal(5,2) DEFAULT NULL,
  `EMO_REMAINING_DURATION` decimal(5,2) DEFAULT NULL,
  `EMO_ACTUAL_DURATION` decimal(5,2) DEFAULT NULL,
  `EMO_DURATION_UNIT` varchar(10) DEFAULT NULL,
  `EMO_ESTIMATED_AMOUNT` decimal(14,4) DEFAULT NULL,
  `EMO_BUDGETED_AMOUNT` decimal(14,4) DEFAULT NULL,
  `EMO_ACTUAL_AMOUNT` decimal(14,4) DEFAULT NULL,
  `EMO_CURRENCY` varchar(3) DEFAULT NULL,
  `EMO_PLANNER_ID` varchar(10) DEFAULT NULL,
  `EMO_PROJECT_ID` varchar(9) DEFAULT NULL,
  `EMO_ENG_ALLOCATED` varchar(250) DEFAULT NULL,
  `EMO_WORK_CARRIEDOUT_AT` char(1) DEFAULT NULL,
  `EMO_REQUEST_TYPE` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_maintenance_schedule_header`
--

DROP TABLE IF EXISTS `ezc_maintenance_schedule_header`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_maintenance_schedule_header` (
  `EMSH_INSTRUMENT` varchar(10) NOT NULL,
  `EMSH_SCHEDULE_CODE` decimal(6,0) NOT NULL,
  `EMSH_LANG` char(2) DEFAULT NULL,
  `EMSH_DESCRIPTION` varchar(100) DEFAULT NULL,
  `EMSH_REF_DOCUMENT_CODE` decimal(6,0) DEFAULT NULL,
  `EMSH_REF_DOCUMENT_TYPE` char(1) DEFAULT NULL,
  `EMSH_SCHEDULE_STAT` char(1) DEFAULT NULL,
  `EMSH_SCHED_START` datetime DEFAULT NULL,
  `EMSH_SCHED_END` datetime DEFAULT NULL,
  `EMSH_CREATED_BY` varchar(10) DEFAULT NULL,
  `EMSH_MODIFIED_BY` varchar(10) DEFAULT NULL,
  `EMSH_CREATED_ON` datetime DEFAULT NULL,
  `EMSH_MODIFIED_ON` datetime DEFAULT NULL,
  `EMSH_BASE_TEMPLATE` decimal(6,0) DEFAULT NULL,
  `EMSH_BASE_TEMPLATE_VER` decimal(6,0) DEFAULT NULL,
  `EMSH_ORDERS_GENERATED_UPTO` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_maintenance_schedule_lines`
--

DROP TABLE IF EXISTS `ezc_maintenance_schedule_lines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_maintenance_schedule_lines` (
  `EMSL_SCHEDULE_CODE` decimal(6,0) NOT NULL,
  `EMSL_SEQ_NO` decimal(3,0) NOT NULL,
  `EMSL_INC_EXC` char(1) DEFAULT NULL,
  `EMSL_ACT_TYPE` char(1) DEFAULT NULL,
  `EMSL_ACT_OR_GRP_CODE` varchar(20) DEFAULT NULL,
  `EMSL_STATUS` char(1) DEFAULT NULL,
  `EMSL_SCHEDULED_DATE` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_maintenance_template_details`
--

DROP TABLE IF EXISTS `ezc_maintenance_template_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_maintenance_template_details` (
  `EMTHD_CODE` decimal(6,0) NOT NULL,
  `EMTHD_SEQ_NUMBER` decimal(3,0) NOT NULL,
  `EMTHD_TEMPLATE_VERSION` decimal(8,0) NOT NULL,
  `EMTHD_ACT_TYPE` char(1) DEFAULT NULL,
  `EMTHD_ACT_OR_GRP_CODE` decimal(6,0) DEFAULT NULL,
  `EMTHD_OFFSET` decimal(6,0) DEFAULT NULL,
  `EMTHD_IS_MANDATORY` char(1) DEFAULT NULL,
  `EMTHD_REPEAT` decimal(6,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_maintenance_template_header`
--

DROP TABLE IF EXISTS `ezc_maintenance_template_header`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_maintenance_template_header` (
  `EMTH_MODEL` varchar(20) NOT NULL,
  `EMTH_CODE` decimal(6,0) NOT NULL,
  `EMTH_TEMPLATE_VERSION` decimal(8,0) NOT NULL,
  `EMTH_LANG` char(2) DEFAULT NULL,
  `EMTH_DESCRIPTION` varchar(200) DEFAULT NULL,
  `EMTH_DURATION` decimal(6,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_massuser_synch`
--

DROP TABLE IF EXISTS `ezc_massuser_synch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_massuser_synch` (
  `EMS_USERID` varchar(10) DEFAULT NULL,
  `EMS_SOLDTO` varchar(20) DEFAULT NULL,
  `EMS_SYSKEY` varchar(20) DEFAULT NULL,
  `EMS_KEY` varchar(50) DEFAULT NULL,
  `EMS_VALUE` varchar(300) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_master_corp_address`
--

DROP TABLE IF EXISTS `ezc_master_corp_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_master_corp_address` (
  `emca_region` varchar(10) DEFAULT NULL,
  `emca_address` varchar(200) DEFAULT NULL,
  `emca_address1` varchar(200) DEFAULT NULL,
  `emca_address2` varchar(200) DEFAULT NULL,
  `emca_address3` varchar(200) DEFAULT NULL,
  `emca_address4` varchar(200) DEFAULT NULL,
  `emca_address5` varchar(200) DEFAULT NULL,
  `emca_gst_code` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_master_key_values`
--

DROP TABLE IF EXISTS `ezc_master_key_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_master_key_values` (
  `EMKV_MASTER_TYPE` varchar(20) NOT NULL,
  `EMKV_KEY` varchar(10) NOT NULL,
  `EMKV_VALUE` varchar(100) NOT NULL,
  `EMKV_VALUE1` varchar(100) DEFAULT NULL,
  `EMKV_VALUE2` varchar(100) DEFAULT NULL,
  `EMKV_VALUE3` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`EMKV_MASTER_TYPE`,`EMKV_KEY`,`EMKV_VALUE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_master_state_codes`
--

DROP TABLE IF EXISTS `ezc_master_state_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_master_state_codes` (
  `esc_state` varchar(35) DEFAULT NULL,
  `esc_state_code` varchar(2) DEFAULT NULL,
  `esc_code` varchar(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_mat_budget_price`
--

DROP TABLE IF EXISTS `ezc_mat_budget_price`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_mat_budget_price` (
  `EMBP_FIN_YEAR` varchar(8) NOT NULL,
  `EMBP_MONTH` varchar(2) NOT NULL,
  `EMBP_PLANT` varchar(4) NOT NULL,
  `EMBP_MATERIAL` varchar(40) NOT NULL,
  `EMBP_DESCRIPTION` varchar(50) DEFAULT NULL,
  `EMBP_MAT_TYPE` varchar(20) DEFAULT NULL,
  `EMBP_BASIC_PRICE` varchar(15) DEFAULT NULL,
  `EMBP_LANDED_PRICE` varchar(15) DEFAULT NULL,
  `EMBP_FY_START_DATE` datetime DEFAULT NULL,
  `EMBP_FY_END_DATE` datetime DEFAULT NULL,
  `EMBP_EXT1` varchar(15) DEFAULT NULL,
  `EMBP_EXT2` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`EMBP_FIN_YEAR`,`EMBP_MONTH`,`EMBP_PLANT`,`EMBP_MATERIAL`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_material_desc`
--

DROP TABLE IF EXISTS `ezc_material_desc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_material_desc` (
  `EMM_NO` varchar(18) NOT NULL,
  `EMD_LANG` char(2) NOT NULL,
  `EMD_DESC` varchar(120) NOT NULL,
  `EMD_WEB_DESC` varchar(120) DEFAULT NULL,
  `EMD_SPECS1` varchar(256) DEFAULT NULL,
  `EMD_SPECS2` varchar(256) DEFAULT NULL,
  `EMD_SPECS3` varchar(256) DEFAULT NULL,
  `EMD_SPECS4` varchar(256) DEFAULT NULL,
  `EMD_EXTERNAL_URL` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`EMM_NO`,`EMD_LANG`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_material_groups`
--

DROP TABLE IF EXISTS `ezc_material_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_material_groups` (
  `EMG_MAT_NO` varchar(18) NOT NULL,
  `EMG_GROUP_ID` varchar(18) NOT NULL,
  `EMG_SYSTEM_KEY` varchar(18) NOT NULL,
  `EMG_UNIQUE_FLAG` char(1) DEFAULT NULL,
  `EMG_DELETION_FLAG` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_material_mapping`
--

DROP TABLE IF EXISTS `ezc_material_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_material_mapping` (
  `EMM_CUST_NO` varchar(10) DEFAULT NULL,
  `EMM_VEND_NO` varchar(10) DEFAULT NULL,
  `EMM_CUST_MAT_NO` varchar(18) DEFAULT NULL,
  `EMM_VEND_MAT_NO` varchar(18) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_material_master`
--

DROP TABLE IF EXISTS `ezc_material_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_material_master` (
  `EMM_NO` varchar(18) NOT NULL,
  `EMM_UNIT_OF_MEASURE` varchar(10) NOT NULL,
  `EMM_UNIT_PRICE` decimal(11,2) NOT NULL,
  `EMM_IMAGE_FLAG` char(1) DEFAULT NULL,
  `EMM_DELETION_FLAG` char(1) DEFAULT NULL,
  `EMM_AVAIL_QUANTITY` decimal(10,0) DEFAULT NULL,
  `EMM_VARIABLE_PRICE_FLAG` char(1) DEFAULT NULL,
  `EMM_SPECS` varchar(128) DEFAULT NULL,
  `EMM_EXT_NO` varchar(18) DEFAULT NULL,
  `EMM_EAN_UPC_NO` varchar(18) DEFAULT NULL,
  `EMM_CURR_KEY` char(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_material_postings`
--

DROP TABLE IF EXISTS `ezc_material_postings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_material_postings` (
  `EZMP_REQID` varchar(6) NOT NULL,
  `EZMP_REQTYPE` varchar(1) DEFAULT NULL,
  `EZMP_MATDESC` varchar(70) DEFAULT NULL,
  `EZMP_UOM` varchar(3) DEFAULT NULL,
  `EZMP_REQQTY` decimal(15,3) DEFAULT NULL,
  `EZMP_CREATION_DATE` datetime DEFAULT NULL,
  `EZMP_CREATED_BY` varchar(10) DEFAULT NULL,
  `EZMP_ACTIVATION_DATE` datetime DEFAULT NULL,
  `EZMP_CLOSING_DATE` datetime DEFAULT NULL,
  `EZMP_REQDESC` text,
  `EZMP_CURR_STATUS` char(1) DEFAULT NULL,
  `EZMP_REFDOCNO` varchar(10) DEFAULT NULL,
  `EZMP_VISBILITY_LEVEL` char(1) DEFAULT NULL,
  `EZMP_SYSKEY` varchar(18) DEFAULT NULL,
  `EZMP_EXT1` varchar(20) DEFAULT NULL,
  `EZMP_EXT2` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_material_reqmt`
--

DROP TABLE IF EXISTS `ezc_material_reqmt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_material_reqmt` (
  `EZMR_REQMT_ID` decimal(18,0) NOT NULL,
  `EZMR_ORDER_ID` decimal(18,0) NOT NULL,
  `EZMR_OPERATION_ID` decimal(18,0) DEFAULT NULL,
  `EZMR_ITEM` varchar(50) DEFAULT NULL,
  `EZMR_ITEM_TYPE` varchar(20) DEFAULT NULL,
  `EZMR_ESTIMATED_QUANTITY` decimal(10,2) DEFAULT NULL,
  `EZMR_ACTUAL_QUANTITY` decimal(10,2) DEFAULT NULL,
  `EZMR_ESTIMATED_COST_PRICE` decimal(14,4) DEFAULT NULL,
  `EZMR_ACTUAL_COST_PRICE` decimal(14,4) DEFAULT NULL,
  `EZMR_ESTIMATED_SELLING_PRICE` decimal(14,4) DEFAULT NULL,
  `EZMR_ACTUAL_SELLING_PRICE` decimal(14,4) DEFAULT NULL,
  `EZMR_COST_CURRENCY` varchar(3) DEFAULT NULL,
  `EZMR_SELLING_CURRENCY` varchar(3) DEFAULT NULL,
  `EZMR_PRICE_UNIT` varchar(3) DEFAULT NULL,
  `EZMR_QUANTITY_UNIT` varchar(3) DEFAULT NULL,
  `EZMR_SOURCE` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_messages`
--

DROP TABLE IF EXISTS `ezc_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_messages` (
  `EPM_CLIENT` decimal(3,0) NOT NULL,
  `EPM_USER_ID` varchar(10) DEFAULT NULL,
  `EPM_MSG_ID` char(18) NOT NULL,
  `EPM_MSG_TYPE` char(3) NOT NULL,
  `EPM_FOLDER_ID` decimal(9,0) DEFAULT NULL,
  `EPM_PRIORITY_FLAG` char(3) DEFAULT NULL,
  `EPM_MSG_HEADER` varchar(256) DEFAULT NULL,
  `EPM_MSG_CONTENT1` varchar(2000) DEFAULT NULL,
  `EPM_MSG_CONTENT2` varchar(2000) DEFAULT NULL,
  `EPM_LNK_EXT_INFO` varchar(256) DEFAULT NULL,
  `EPM_CREATION_DATE` datetime DEFAULT NULL,
  `EPM_CREATION_TIME` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EPM_CLIENT`,`EPM_MSG_ID`,`EPM_MSG_TYPE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_model`
--

DROP TABLE IF EXISTS `ezc_model`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_model` (
  `EM_MODEL_CODE` varchar(20) NOT NULL,
  `EM_DESCRIPTION` varchar(50) DEFAULT NULL,
  `EM_SKILLS` varchar(300) DEFAULT NULL,
  `EM_WARRANTY_TEMPLATE_CODE` varchar(20) DEFAULT NULL,
  `EM_MANUFACTURER_ID` varchar(50) DEFAULT NULL,
  `EM_EQUIPMENT_TYPE_CODE` varchar(6) DEFAULT NULL,
  `EM_LABOR_RATE_CODE` varchar(3) DEFAULT NULL,
  `EM_ENTERPRISE_CODE` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_model_hierarchies`
--

DROP TABLE IF EXISTS `ezc_model_hierarchies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_model_hierarchies` (
  `EMH_SPARE_MODEL_CODE` decimal(6,0) NOT NULL,
  `EMH_QTY` decimal(6,0) DEFAULT NULL,
  `EMH_PARENT` decimal(6,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_msg_links`
--

DROP TABLE IF EXISTS `ezc_msg_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_msg_links` (
  `EML_CLIENT_ID` decimal(3,0) NOT NULL,
  `EML_MSG_ID` char(18) NOT NULL,
  `EML_EXT_LNK` varchar(600) NOT NULL,
  `EML_REFERENCE` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`EML_CLIENT_ID`,`EML_MSG_ID`,`EML_EXT_LNK`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_news`
--

DROP TABLE IF EXISTS `ezc_news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_news` (
  `EZN_ID` decimal(6,0) NOT NULL,
  `EZN_SYSKEY` varchar(18) NOT NULL,
  `EZN_CREATED_DATE` datetime DEFAULT NULL,
  `EZN_CREATED_BY` varchar(10) DEFAULT NULL,
  `EZN_MODIFIED_BY` varchar(10) DEFAULT NULL,
  `EZN_START_DATE` datetime DEFAULT NULL,
  `EZN_END_DATE` datetime DEFAULT NULL,
  `EZN_GROUP` varchar(10) DEFAULT NULL,
  `EZN_ROLE` varchar(16) DEFAULT NULL,
  `EZN_TYPE` char(1) DEFAULT NULL,
  `EZN_TEXT` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`EZN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_number_ranges`
--

DROP TABLE IF EXISTS `ezc_number_ranges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_number_ranges` (
  `ENR_SITE_NUMBER` decimal(10,0) NOT NULL,
  `ENR_OBJECT` varchar(128) NOT NULL,
  `ENR_OBJECT_TYPE` varchar(128) NOT NULL,
  `ENR_TRANSACTION` varchar(18) NOT NULL,
  `ENR_FROM` decimal(30,0) DEFAULT NULL,
  `ENR_TO` decimal(30,0) DEFAULT NULL,
  `ENR_LAST_NUMBER` decimal(30,0) DEFAULT NULL,
  `ENR_INTERVAL` decimal(30,0) DEFAULT NULL,
  PRIMARY KEY (`ENR_SITE_NUMBER`,`ENR_OBJECT`,`ENR_OBJECT_TYPE`,`ENR_TRANSACTION`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_operation_type`
--

DROP TABLE IF EXISTS `ezc_operation_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_operation_type` (
  `EOTY_OPERATION_TYPE_CODE` varchar(3) NOT NULL,
  `EOTY_LABORRATE_CODE` varchar(3) DEFAULT NULL,
  `EOTY_TOOLKIT_CODE` varchar(3) DEFAULT NULL,
  `EOTY_SKILL_CODES` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_order_history`
--

DROP TABLE IF EXISTS `ezc_order_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_order_history` (
  `EOH_CLIENT` decimal(6,0) NOT NULL,
  `EOH_EZC_ORDER_REF` char(10) NOT NULL,
  `EOH_PO_REF` varchar(20) NOT NULL,
  `EOH_CAT_AREA` varchar(18) NOT NULL,
  `EOH_SYS_NO` decimal(6,0) DEFAULT NULL,
  `EOH_EZC_PARTNER` char(10) DEFAULT NULL,
  `EOH_SELLER_ID` char(10) DEFAULT NULL,
  `EOH_BUYER_ID` char(10) DEFAULT NULL,
  `EOH_ORDER_DATE` char(10) DEFAULT NULL,
  `EOH_ERP_ORDER` char(10) DEFAULT NULL,
  `EOH_CREATION_DATE` char(10) DEFAULT NULL,
  `EOH_CREATION_TIME` char(20) DEFAULT NULL,
  `EOH_CREATED_BY` char(10) DEFAULT NULL,
  `EOH_ORDER_STATUS` char(1) DEFAULT NULL,
  `EOH_ORD_TYPE` char(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_other_reqmt`
--

DROP TABLE IF EXISTS `ezc_other_reqmt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_other_reqmt` (
  `EZOR_REQMT_ID` decimal(18,0) NOT NULL,
  `EZOR_ORDER_ID` decimal(18,0) NOT NULL,
  `EZOR_OPERATION_ID` decimal(18,0) DEFAULT NULL,
  `EZOR_REQUIRMENT_TYPE` varchar(30) DEFAULT NULL,
  `EZOR_TOOL_TYPE` varchar(6) DEFAULT NULL,
  `EZOR_TOOL_CODE` varchar(50) DEFAULT NULL,
  `EZOR_SUBCONTRACTOR_CODE` varchar(6) DEFAULT NULL,
  `EZOR_ESTIMATED_TRAVEL_DISTANCE` decimal(10,2) DEFAULT NULL,
  `EZOR_ESTIMATED_TRAVEL_TIME` decimal(10,2) DEFAULT NULL,
  `EZOR_CHARGE_BY` varchar(10) DEFAULT NULL,
  `EZOR_ESTIMATED_QUANTITY` decimal(10,2) DEFAULT NULL,
  `EZOR_CHARGE_QUANTITY_UNIT` varchar(3) DEFAULT NULL,
  `EZOR_ESTIMATED_TOTAL_COST` decimal(14,4) DEFAULT NULL,
  `EZOR_ESTIMATED_TOTAL_SELLING` decimal(14,4) DEFAULT NULL,
  `EZOR_ESTIMATED_UNIT_COST_RATE` decimal(14,4) DEFAULT NULL,
  `EZOR_ESTIMATED_UNIT_SALES_RATE` decimal(14,4) DEFAULT NULL,
  `EZOR_ACTUAL_QUANTITY` decimal(10,2) DEFAULT NULL,
  `EZOR_ACTUAL_TOTAL_COST_AMNT` decimal(14,4) DEFAULT NULL,
  `EZOR_ACTUAL_TOTAL_SELLING_AMNT` decimal(14,4) DEFAULT NULL,
  `EZOR_ACTUAL_TOTAL_UNIT_COST` decimal(14,4) DEFAULT NULL,
  `EZOR_ACTUAL_UNIT_SALES` decimal(14,4) DEFAULT NULL,
  `EZOR_COST_CURRENCY` varchar(3) DEFAULT NULL,
  `EZOR_SALES_CURRENCY` varchar(3) DEFAULT NULL,
  `EZOR_TRAVEL_TIME_UNIT` varchar(3) DEFAULT NULL,
  `EZOR_DISTANCE_UNIT` varchar(3) DEFAULT NULL,
  `EZOR_SCHEDULED_DATE` datetime DEFAULT NULL,
  `EZOR_ACTUAL_DATE` datetime DEFAULT NULL,
  `EZOR_STARTED_AT` datetime DEFAULT NULL,
  `EZOR_CLOSED_AT` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_otp_store`
--

DROP TABLE IF EXISTS `ezc_otp_store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_otp_store` (
  `EOS_ID` char(36) NOT NULL,
  `EOS_USER_ID` varchar(50) DEFAULT NULL,
  `EOS_OTP` varchar(6) DEFAULT NULL,
  `EOS_CREATED_ON` timestamp NULL DEFAULT NULL,
  `EOS_EXPIRE_TIME` timestamp NULL DEFAULT NULL,
  `EOS_ACTIVE` char(1) NOT NULL,
  `EOS_IP_ADDR` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`EOS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_partial_po_details`
--

DROP TABLE IF EXISTS `ezc_partial_po_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_partial_po_details` (
  `EPPD_DOC_NO` varchar(10) DEFAULT NULL,
  `EPPD_DOC_TYPE` char(1) DEFAULT NULL,
  `EPPD_RFQ_NO` varchar(10) DEFAULT NULL,
  `EPPD_ITEM_NO` varchar(4) DEFAULT NULL,
  `EPPD_PLANT` varchar(5) DEFAULT NULL,
  `EPPD_PO_QTY` decimal(15,3) DEFAULT NULL,
  `EPPD_PEN_QTY` decimal(15,3) DEFAULT NULL,
  `EPPD_CREATED_ON` datetime DEFAULT NULL,
  `EPPD_CREATED_BY` varchar(10) DEFAULT NULL,
  `EPPD_EXT1` varchar(20) DEFAULT NULL,
  `EPPD_EXT2` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_partner_mapping`
--

DROP TABLE IF EXISTS `ezc_partner_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_partner_mapping` (
  `EPM_CLIENT` decimal(3,0) NOT NULL,
  `EPM_VENDOR` char(10) NOT NULL,
  `EPM_ERP_CUST_NO` char(10) NOT NULL,
  `EPM_CAT_AREA` varchar(18) DEFAULT NULL,
  `EPM_EZC_CUST_NO` char(10) DEFAULT NULL,
  PRIMARY KEY (`EPM_CLIENT`,`EPM_VENDOR`,`EPM_ERP_CUST_NO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_partner_queries`
--

DROP TABLE IF EXISTS `ezc_partner_queries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_partner_queries` (
  `EPQ_ID` decimal(15,3) NOT NULL,
  `EPQ_SOLD_TO` varchar(10) NOT NULL,
  `EPQ_TYPE` varchar(15) NOT NULL,
  `EPQ_QUERY` varchar(1000) DEFAULT NULL,
  `EPQ_POSTED_BY` varchar(15) DEFAULT NULL,
  `EPQ_POSTED_ON` datetime DEFAULT NULL,
  `EPQ_REPLY` varchar(1000) DEFAULT NULL,
  `EPQ_REPLIED_BY` varchar(15) DEFAULT NULL,
  `EPQ_REPLIED_ON` datetime DEFAULT NULL,
  `EPQ_STATUS` varchar(10) DEFAULT NULL,
  `EPQ_ATTACHMENTS` char(1) DEFAULT NULL,
  `EPQ_EXT1` varchar(15) DEFAULT NULL,
  `EPQ_EXT2` varchar(15) DEFAULT NULL,
  `EPQ_EXT3` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`EPQ_ID`,`EPQ_TYPE`,`EPQ_SOLD_TO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_personal_messages`
--

DROP TABLE IF EXISTS `ezc_personal_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_personal_messages` (
  `EPMD_CLIENT` decimal(3,0) NOT NULL,
  `EPMD_MSG_ID` char(18) NOT NULL,
  `EPMD_USER_ID` char(10) NOT NULL,
  `EPMD_REC_USER_ID` char(10) NOT NULL,
  `EPMD_FOLDER_ID` decimal(9,0) DEFAULT NULL,
  `EPMD_EXPIRY_DATE` decimal(8,0) DEFAULT NULL,
  `EPMD_EXPIRY_DAYS` decimal(3,0) DEFAULT NULL,
  `EPMD_REMINDER_DATE` decimal(8,0) DEFAULT NULL,
  `EPMD_VIEW_FLAG` char(1) DEFAULT NULL,
  PRIMARY KEY (`EPMD_CLIENT`,`EPMD_MSG_ID`,`EPMD_USER_ID`,`EPMD_REC_USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_plants`
--

DROP TABLE IF EXISTS `ezc_plants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_plants` (
  `EP_PLANT` varchar(8) NOT NULL,
  `EP_NAME1` varchar(35) DEFAULT NULL,
  `EP_NAME2` varchar(35) DEFAULT NULL,
  `EP_ADDRESS` varchar(200) DEFAULT NULL,
  `EP_CITY` varchar(35) DEFAULT NULL,
  `EP_PS_CODE` varchar(10) DEFAULT NULL,
  `EP_STATE` varchar(3) DEFAULT NULL,
  `EP_COUNTRY` varchar(3) DEFAULT NULL,
  `EP_MOBILE` varchar(16) DEFAULT NULL,
  `EP_LANDLINE` varchar(16) DEFAULT NULL,
  `EP_EXT1` varchar(15) DEFAULT NULL,
  `EP_EXT2` varchar(15) DEFAULT NULL,
  `EP_EXT3` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`EP_PLANT`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_po_acknowledgement`
--

DROP TABLE IF EXISTS `ezc_po_acknowledgement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_po_acknowledgement` (
  `EZPA_SYS_KEY` varchar(18) NOT NULL,
  `EZPA_SOLD_TO` varchar(10) NOT NULL,
  `EZPA_DOC_NO` varchar(10) NOT NULL,
  `EZPA_DOC_DATE` datetime DEFAULT NULL,
  `EZPA_DOC_STATUS` char(1) DEFAULT NULL,
  `EZPA_CREATED_ON` datetime DEFAULT NULL,
  `EZPA_CREATED_BY` varchar(15) DEFAULT NULL,
  `EZPA_MODIFIED_ON` datetime DEFAULT NULL,
  `EZPA_HEADER_TEXT` text,
  `EZPA_EXT1` varchar(20) DEFAULT NULL,
  `EZPA_EXT2` varchar(20) DEFAULT NULL,
  `EZPA_EXT3` varchar(20) DEFAULT NULL,
  `EZPA_PLANT` varchar(5) DEFAULT NULL,
  `EZPA_PG_NAME` varchar(100) DEFAULT NULL,
  `EZPA_START_DATE` date DEFAULT NULL,
  `EZPA_END_DATE` date DEFAULT NULL,
  `EZPA_PO_DOC_TYPE` varchar(5) DEFAULT NULL,
  `EZPA_COMP_CODE` varchar(5) DEFAULT NULL,
  `EZPA_SMS_STATUS` char(1) DEFAULT NULL,
  `EZPA_PO_CHANGE` char(1) DEFAULT NULL,
  `EZPA_PUR_ORG` varchar(5) DEFAULT NULL,
  `EZPA_CATEGORY` varchar(10) DEFAULT NULL,
  `EZPA_DOC_VAL` decimal(15,3) DEFAULT NULL,
  PRIMARY KEY (`EZPA_DOC_NO`,`EZPA_SYS_KEY`,`EZPA_SOLD_TO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_po_delivery_schedules`
--

DROP TABLE IF EXISTS `ezc_po_delivery_schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_po_delivery_schedules` (
  `EZPD_DOC_NO` varchar(10) NOT NULL,
  `EZPD_DOC_ITEM_NO` varchar(5) NOT NULL,
  `EZPD_SCHD_LINE` varchar(5) NOT NULL,
  `EZPD_MATERIAL` varchar(18) DEFAULT NULL,
  `EZPD_MATERIAL_DESC` varchar(40) DEFAULT NULL,
  `EZPD_UOM` varchar(5) DEFAULT NULL,
  `EZPD_REQUIRED_QTY` decimal(14,3) DEFAULT NULL,
  `EZPD_COMMITTED_QTY` decimal(14,3) DEFAULT NULL,
  `EZPD_REQUIRED_DATE` datetime DEFAULT NULL,
  `EZPD_COMMITTED_DATE` datetime DEFAULT NULL,
  `EZPD_SYS_KEY` varchar(18) DEFAULT NULL,
  `EZPD_SOLD_TO` varchar(10) DEFAULT NULL,
  `EZPD_EXT1` varchar(20) DEFAULT NULL,
  `EZPD_EXT2` varchar(20) DEFAULT NULL,
  `EZPD_EXT3` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EZPD_DOC_NO`,`EZPD_DOC_ITEM_NO`,`EZPD_SCHD_LINE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_po_prodplan_header`
--

DROP TABLE IF EXISTS `ezc_po_prodplan_header`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_po_prodplan_header` (
  `EPPH_SYS_KEY` varchar(18) NOT NULL,
  `EPPH_SOLD_TO` varchar(10) NOT NULL,
  `EPPH_DOC_NO` varchar(10) NOT NULL,
  `EPPH_DOC_DATE` datetime DEFAULT NULL,
  `EPPH_DOC_STATUS` char(1) DEFAULT NULL,
  `EPPH_CREATED_ON` datetime DEFAULT NULL,
  `EPPH_CREATED_BY` varchar(21) DEFAULT NULL,
  `EPPH_MODIFIED_ON` datetime DEFAULT NULL,
  `EPPH_PLANT` varchar(5) DEFAULT NULL,
  `EPPH_PUR_ORG` varchar(5) DEFAULT NULL,
  `EPPH_PUR_GRP` varchar(5) DEFAULT NULL,
  `EPPH_COMP_CODE` varchar(5) DEFAULT NULL,
  `EPPH_PO_DOC_TYPE` varchar(5) DEFAULT NULL,
  `EPPH_EXT1` varchar(20) DEFAULT NULL,
  `EPPH_EXT2` varchar(20) DEFAULT NULL,
  `EPPH_EXT3` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EPPH_DOC_NO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_po_prodplan_items`
--

DROP TABLE IF EXISTS `ezc_po_prodplan_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_po_prodplan_items` (
  `EPPI_DOC_NO` varchar(10) NOT NULL,
  `EPPI_LINE_NO` varchar(5) NOT NULL,
  `EPPI_MATERIAL` varchar(40) DEFAULT NULL,
  `EPPI_MAT_DESC` varchar(100) DEFAULT NULL,
  `EPPI_UOM` varchar(5) DEFAULT NULL,
  `EPPI_QTY` double DEFAULT NULL,
  `EPPI_PLANT` varchar(5) DEFAULT NULL,
  `EPPI_PR_NO` varchar(10) DEFAULT NULL,
  `EPPI_PR_ITEM` varchar(5) DEFAULT NULL,
  `EPPI_NET_PRICE` double DEFAULT NULL,
  PRIMARY KEY (`EPPI_DOC_NO`,`EPPI_LINE_NO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_po_prodplan_schedules`
--

DROP TABLE IF EXISTS `ezc_po_prodplan_schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_po_prodplan_schedules` (
  `EPPS_DOC_NO` varchar(10) NOT NULL,
  `EPPS_LINE_NO` varchar(5) NOT NULL,
  `EPPS_SCHD_NO` varchar(5) NOT NULL,
  `EPPS_QTY` double DEFAULT NULL,
  `EPPS_SCHD_WEEK` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`EPPS_DOC_NO`,`EPPS_LINE_NO`,`EPPS_SCHD_NO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_post_material_responses`
--

DROP TABLE IF EXISTS `ezc_post_material_responses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_post_material_responses` (
  `EZMR_REQID` varchar(6) NOT NULL,
  `EZMR_SOLDTO` varchar(10) NOT NULL,
  `EZMR_SYSKEY` varchar(18) NOT NULL,
  `EZMR_RESPONSE_BY` varchar(20) DEFAULT NULL,
  `EZMR_RESPONSE_DATE` datetime DEFAULT NULL,
  `EZMR_RESPONSE_DESC` text,
  `EZMR_EXT1` varchar(20) DEFAULT NULL,
  `EZMR_EXT2` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_prior_ae_info`
--

DROP TABLE IF EXISTS `ezc_prior_ae_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_prior_ae_info` (
  `EPAI_EVENT_ON` char(1) DEFAULT NULL,
  `EPAI_EVENT_DESCRIPTION` varchar(200) DEFAULT NULL,
  `EPAI_ONSET_AGE` decimal(18,0) DEFAULT NULL,
  `EPAI_VACCINE_TYPE` varchar(50) DEFAULT NULL,
  `EPAI_DOSE_NO_IN_SERIES` decimal(18,0) DEFAULT NULL,
  `EPAI_ADVERSE_EVENT_ID` decimal(18,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_prior_vaccination_history`
--

DROP TABLE IF EXISTS `ezc_prior_vaccination_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_prior_vaccination_history` (
  `EPVH_VACC_ID` decimal(18,0) NOT NULL,
  `EPVH_VACCINE_TYPE` varchar(50) DEFAULT NULL,
  `EPVH_MANUFACTURER` varchar(50) DEFAULT NULL,
  `EPVH_LOT` varchar(20) DEFAULT NULL,
  `EPVH_ROUTE_OR_SITE` varchar(100) DEFAULT NULL,
  `EPVH_NO_OF_PREV_DOSES` decimal(18,0) DEFAULT NULL,
  `EPVH_VACCINATION_DATE` datetime DEFAULT NULL,
  `EPVH_RECORD_TYPE` char(1) DEFAULT NULL,
  `EPVH_VACCINE_INFO_ON_VACCINATED_DATE` varchar(2048) DEFAULT NULL,
  `EPVH_VACCINE_INFO_BEFORE_VACCINATED_DATE` varchar(2048) DEFAULT NULL,
  `EPVH_ADVERSE_EVENT_ID` decimal(18,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_priority`
--

DROP TABLE IF EXISTS `ezc_priority`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_priority` (
  `EPRI_PRIORITY_CODE` varchar(3) NOT NULL,
  `EPRI_DEFAULT_RESP_TIME` varchar(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_problem`
--

DROP TABLE IF EXISTS `ezc_problem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_problem` (
  `EZPR_CATEGORY_ID` varchar(6) DEFAULT NULL,
  `EZPR_CODE` varchar(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_problem_categories`
--

DROP TABLE IF EXISTS `ezc_problem_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_problem_categories` (
  `EPC_CATEGORY_ID` varchar(6) NOT NULL,
  `EPC_DESCRIPTION` varchar(50) DEFAULT NULL,
  `EPC_EQUIP_TYPES` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_procedure_types`
--

DROP TABLE IF EXISTS `ezc_procedure_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_procedure_types` (
  `EPT_PROCEDURE_TYPE` char(3) NOT NULL,
  `EPT_LANGUAGE` char(2) NOT NULL,
  `EPT_DESCRIPTION` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_product_catalog`
--

DROP TABLE IF EXISTS `ezc_product_catalog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_product_catalog` (
  `EPC_NO` decimal(8,0) NOT NULL,
  `EPC_LANG` char(2) NOT NULL,
  `EPC_NAME` varchar(120) NOT NULL,
  `EPC_BUSS_INDICATOR` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_product_group`
--

DROP TABLE IF EXISTS `ezc_product_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_product_group` (
  `EPG_NO` varchar(18) NOT NULL,
  `EPG_SYS_NO` decimal(3,0) NOT NULL,
  `EPG_GROUP_LEVEL` decimal(3,0) NOT NULL,
  `EPG_DELETION_FLAG` char(1) DEFAULT NULL,
  `EPG_GLOBAL_VIEW_FLAG` char(1) DEFAULT NULL,
  `EPG_GIF_FLAG` char(1) DEFAULT NULL,
  `EPG_NO_OF_ITEMS` decimal(3,0) DEFAULT NULL,
  `EPG_TERMINAL_FLAG` char(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_product_group_desc`
--

DROP TABLE IF EXISTS `ezc_product_group_desc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_product_group_desc` (
  `EPG_NO` varchar(18) NOT NULL,
  `EPGD_LANG` char(2) NOT NULL,
  `EPGD_DESC` varchar(120) NOT NULL,
  `EPGD_WEB_DESC` varchar(120) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_projection_header`
--

DROP TABLE IF EXISTS `ezc_projection_header`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_projection_header` (
  `EZPR_PROJECTIONID` varchar(10) NOT NULL,
  `EZPR_USERID` varchar(10) DEFAULT NULL,
  `EZPR_USERTYPE` varchar(10) DEFAULT NULL,
  `EZPR_DOE` datetime DEFAULT NULL,
  `EZPR_PERIOD_START_DATE` datetime DEFAULT NULL,
  `EZPR_PERIOD_END_DATE` datetime DEFAULT NULL,
  `EZPR_PERIODS` decimal(2,0) DEFAULT NULL,
  `EZPR_SYSKEY` varchar(18) NOT NULL,
  `EZPR_SOLDTO` varchar(10) NOT NULL,
  `EZPR_ADDITIONAL1` varchar(30) DEFAULT NULL,
  `EZPR_ADDITIONAL2` varchar(30) DEFAULT NULL,
  `EZPR_ADDITIONAL3` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_projection_lines`
--

DROP TABLE IF EXISTS `ezc_projection_lines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_projection_lines` (
  `EZPR_PROJECTIONID` varchar(10) DEFAULT NULL,
  `EZPR_STATUS` char(1) DEFAULT NULL,
  `EZPR_PRODUCT` varchar(18) DEFAULT NULL,
  `EZPR_PACK` varchar(5) DEFAULT NULL,
  `EZPR_VALUES` varchar(256) DEFAULT NULL,
  `EZPR_PRICES` varchar(256) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_qcf_comments`
--

DROP TABLE IF EXISTS `ezc_qcf_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_qcf_comments` (
  `EQC_CODE` varchar(10) NOT NULL,
  `EQC_COMMENT_NO` varchar(10) NOT NULL,
  `EQC_USER` varchar(50) DEFAULT NULL,
  `EQC_DATE` datetime DEFAULT NULL,
  `EQC_COMMENTS` longtext,
  `EQC_EXT1` varchar(300) DEFAULT NULL,
  `EQC_EXT2` varchar(300) DEFAULT NULL,
  `EQC_EXT3` longtext,
  `EQC_DEST_USER` varchar(50) DEFAULT NULL,
  `EQC_TYPE` varchar(10) DEFAULT NULL,
  `EQC_QUERY_MAP` varchar(10) DEFAULT NULL,
  `EQC_ITEM_NO` varchar(10) DEFAULT NULL,
  `EQC_REASON_CODE` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`EQC_CODE`,`EQC_COMMENT_NO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_recon_account_group_mapping`
--

DROP TABLE IF EXISTS `ezc_recon_account_group_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_recon_account_group_mapping` (
  `ERAGM_ACCOUNT_GROUP` varchar(10) DEFAULT NULL,
  `ERAGM_RECON_ACCOUNT` varchar(10) DEFAULT NULL,
  `ERAGM_ACCOUNT_GROUP_DESC` varchar(100) DEFAULT NULL,
  `ERAGM_RECON_ACCOUNT_DESC` varchar(100) DEFAULT NULL,
  `ERAGM_EXT1` varchar(100) DEFAULT NULL,
  `ERAGM_EXT2` varchar(100) DEFAULT NULL,
  `ERAGM_EXT3` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_report_exec_store`
--

DROP TABLE IF EXISTS `ezc_report_exec_store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_report_exec_store` (
  `ERS_COUNTER` decimal(5,0) NOT NULL,
  `ERS_REPORT_NO` decimal(10,0) DEFAULT NULL,
  `ERS_SPOOL_NO` varchar(20) DEFAULT NULL,
  `ERS_SYSTEM_NO` decimal(3,0) NOT NULL,
  `ERS_USER_ID` varchar(10) DEFAULT NULL,
  `ERS_CREATION_DATE` varchar(10) DEFAULT NULL,
  `ERS_CREATION_TIME` varchar(10) DEFAULT NULL,
  `ERS_REPORT_PATH` varchar(128) DEFAULT NULL,
  `ERS_VIEW_FLAG` char(1) DEFAULT NULL,
  `ERS_EMAIL` varchar(128) DEFAULT NULL,
  `ERS_REPORT_FORMAT` char(1) DEFAULT NULL,
  `ERS_EXT1` varchar(20) DEFAULT NULL,
  `ERS_EXT2` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_report_info`
--

DROP TABLE IF EXISTS `ezc_report_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_report_info` (
  `ERI_REPORT_NO` decimal(10,0) NOT NULL,
  `ERI_SYSTEM_NO` decimal(3,0) NOT NULL,
  `ERI_REPORT_NAME` varchar(64) NOT NULL,
  `ERI_REPORT_DESC` varchar(128) DEFAULT NULL,
  `ERI_LANG` char(2) DEFAULT NULL,
  `ERI_REPORT_TYPE` decimal(3,0) DEFAULT NULL,
  `ERI_EXEC_TYPE` char(1) DEFAULT NULL,
  `ERI_VISIBLE_LEVEL` char(1) DEFAULT NULL,
  `ERI_BUSINESS_DOMAIN` char(1) DEFAULT NULL,
  `ERI_REPORT_STATUS` char(1) DEFAULT NULL,
  `ERI_EXT1` varchar(20) DEFAULT NULL,
  `ERI_EXT2` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_report_params`
--

DROP TABLE IF EXISTS `ezc_report_params`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_report_params` (
  `ERP_REPORT_NO` decimal(10,0) NOT NULL,
  `ERP_PARAM_NO` decimal(3,0) NOT NULL,
  `ERP_PARAM_NAME` varchar(18) NOT NULL,
  `ERP_PARAM_DESC` varchar(128) DEFAULT NULL,
  `ERP_PARAM_TYPE` char(1) DEFAULT NULL,
  `ERP_DATA_TYPE` varchar(5) DEFAULT NULL,
  `ERP_LENGTH` decimal(5,0) DEFAULT NULL,
  `ERP_IS_MANDATORY` char(1) DEFAULT NULL,
  `ERP_IS_CUSTOMER` char(1) DEFAULT NULL,
  `ERP_IS_HIDDEN` char(1) DEFAULT NULL,
  `ERP_CHK_DEFAULTS` char(1) DEFAULT NULL,
  `ERP_METHOD_NAME` varchar(40) DEFAULT NULL,
  `ERP_EXT1` varchar(20) DEFAULT NULL,
  `ERP_EXT2` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_report_values`
--

DROP TABLE IF EXISTS `ezc_report_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_report_values` (
  `ERV_REPORT_NO` decimal(10,0) DEFAULT NULL,
  `ERV_PARAM_NO` decimal(3,0) DEFAULT NULL,
  `ERV_PARAM_VALUE` varchar(64) DEFAULT NULL,
  `ERV_PARAM_VALUE_HIGH` varchar(64) DEFAULT NULL,
  `ERV_RETRIEVAL_MODE` char(1) DEFAULT NULL,
  `ERV_OPERATOR` char(2) DEFAULT NULL,
  `ERV_EXT1` varchar(20) DEFAULT NULL,
  `ERV_EXT2` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_response_time`
--

DROP TABLE IF EXISTS `ezc_response_time`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_response_time` (
  `ERSP_RESPONSE_TIME_CODE` varchar(3) NOT NULL,
  `ERSP_TIME_VALUE` decimal(3,0) DEFAULT NULL,
  `ERSP_TIME_UNIT` varchar(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_rfq_conditions`
--

DROP TABLE IF EXISTS `ezc_rfq_conditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_rfq_conditions` (
  `ERC_RFQ_NO` varchar(10) NOT NULL,
  `ERC_CONDITION_ID` varchar(10) NOT NULL,
  `ERC_CONDITION_VAL` varchar(10) DEFAULT NULL,
  `ERC_PER` varchar(3) DEFAULT NULL,
  `ERC_CURRENCY` varchar(5) DEFAULT NULL,
  `ERC_UOM` varchar(3) DEFAULT NULL,
  `ERC_EXT1` varchar(10) DEFAULT NULL,
  `ERC_EXT2` varchar(10) DEFAULT NULL,
  `ERC_EXT3` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`ERC_RFQ_NO`,`ERC_CONDITION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_rfq_details`
--

DROP TABLE IF EXISTS `ezc_rfq_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_rfq_details` (
  `ERD_RFQ_NO` varchar(10) NOT NULL,
  `ERD_LINE_NO` decimal(3,0) NOT NULL,
  `ERD_COUNTER` decimal(3,0) NOT NULL,
  `ERD_MATERIAL` varchar(18) DEFAULT NULL,
  `ERD_MATERIAL_DESC` varchar(50) DEFAULT NULL,
  `ERD_UOM` varchar(10) DEFAULT NULL,
  `ERD_DELIVERY_DATE` datetime DEFAULT NULL,
  `ERD_QUANTITY` decimal(15,3) DEFAULT NULL,
  `ERD_ORDER_UNIT` varchar(10) DEFAULT NULL,
  `ERD_PR_CREATED_BY` varchar(15) DEFAULT NULL,
  `ERD_PO_NO` varchar(10) DEFAULT NULL,
  `ERD_PO_QTY` decimal(15,3) DEFAULT NULL,
  `ERD_BUDGET_PRICE` decimal(15,4) DEFAULT NULL,
  `ERD_MRP_PRICE` decimal(15,4) DEFAULT NULL,
  `ERD_PRICE` decimal(15,4) DEFAULT NULL,
  `ERD_REMARKS` varchar(4000) DEFAULT NULL,
  `ERD_PLANT` varchar(4) DEFAULT NULL,
  `ERD_ACC_CAT` char(10) DEFAULT NULL,
  `ERD_ITEM_CAT` char(10) DEFAULT NULL,
  `ERD_EXT1` varchar(2000) DEFAULT NULL,
  `ERD_EXT2` varchar(2000) DEFAULT NULL,
  `ERD_EXT3` varchar(4000) DEFAULT NULL,
  `ERD_CURRENCY` varchar(5) DEFAULT NULL,
  `ERD_EXCH_RATE` decimal(15,4) DEFAULT NULL,
  `ERD_LEAD_DAYS` varchar(3) DEFAULT NULL,
  `ERD_VEND_GST` varchar(20) DEFAULT NULL,
  `ERD_SAP_GST` varchar(20) DEFAULT NULL,
  `ERD_VEND_HSN_CODE` varchar(20) DEFAULT NULL,
  `ERD_SAP_HSN_CODE` varchar(20) DEFAULT NULL,
  `ERD_QUERY` varchar(20) DEFAULT NULL,
  `ERD_STATUS` char(1) DEFAULT NULL,
  `ERD_WARRANTY` varchar(500) DEFAULT NULL,
  `ERD_DOC_TYPE` varchar(10) DEFAULT NULL,
  `ERD_MAT_GRP` varchar(50) DEFAULT NULL,
  `ERD_PO_CR_QTY` decimal(15,3) NOT NULL DEFAULT '0.000',
  PRIMARY KEY (`ERD_RFQ_NO`,`ERD_LINE_NO`,`ERD_COUNTER`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_rfq_header`
--

DROP TABLE IF EXISTS `ezc_rfq_header`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_rfq_header` (
  `ERH_RFQ_NO` varchar(10) NOT NULL,
  `ERH_COLLETIVE_RFQ_NO` varchar(10) NOT NULL,
  `ERH_SYS_KEY` varchar(18) NOT NULL,
  `ERH_SOLD_TO` varchar(15) DEFAULT NULL,
  `ERH_STATUS` char(1) DEFAULT NULL,
  `ERH_RFQ_DATE` datetime DEFAULT NULL,
  `ERH_VALID_UPTO` datetime DEFAULT NULL,
  `ERH_CREATED_BY` varchar(10) DEFAULT NULL,
  `ERH_CREATED_ON` datetime DEFAULT NULL,
  `ERH_MODIFIED_BY` varchar(10) DEFAULT NULL,
  `ERH_MODIFIED_ON` datetime DEFAULT NULL,
  `ERH_PUR_ORG` varchar(20) DEFAULT NULL,
  `ERH_PUR_GRP` varchar(20) DEFAULT NULL,
  `ERH_VENDOR_TYPE` varchar(10) DEFAULT NULL,
  `ERH_AGENT_CODE` varchar(10) DEFAULT NULL,
  `ERH_RELEASE_INDICATOR` char(1) DEFAULT NULL,
  `ERH_RANK_STATUS` varchar(3) DEFAULT NULL,
  `ERH_EXT1` varchar(3000) DEFAULT NULL,
  `ERH_EXT2` varchar(250) DEFAULT NULL,
  `ERH_EXT3` text,
  `ERH_PR_NO` varchar(3000) DEFAULT NULL,
  `ERH_PRICE_VALID` datetime DEFAULT NULL,
  `ERH_PO_NO` varchar(10) DEFAULT NULL,
  `ERH_PO_OR_CON` char(1) DEFAULT NULL,
  `ERH_PR_ITEM_NO` varchar(5) DEFAULT NULL,
  `ERH_VAL_TYPE` varchar(10) DEFAULT NULL,
  `ERH_TAX_CODE` varchar(2) DEFAULT NULL,
  `ERH_ORDER_UNIT` varchar(3) DEFAULT NULL,
  `ERH_PAYMENT_TERMS` varchar(10) DEFAULT NULL,
  `ERH_INCO_TERMS1` varchar(10) DEFAULT NULL,
  `ERH_PR_TEXT` varchar(5000) DEFAULT NULL,
  `ERH_INCO_TERMS2` varchar(50) DEFAULT NULL,
  `ERH_SAVE_FLG` varchar(1) DEFAULT NULL,
  `ERH_MAT_TYPE` varchar(20) DEFAULT NULL,
  `ERH_PERCENTAGE` varchar(20) DEFAULT NULL,
  `ERH_LEAD_DAYS` varchar(20) DEFAULT NULL,
  `ERH_RANK` varchar(20) DEFAULT NULL,
  `ERH_REASON` varchar(40) DEFAULT NULL,
  `ERH_LD_STATUS` char(1) DEFAULT NULL,
  `ERH_LD_CLAUSE` varchar(500) DEFAULT NULL,
  `ERH_PG_STATUS` char(1) DEFAULT NULL,
  `ERH_PG_CLAUSE` varchar(500) DEFAULT NULL,
  `ERH_PLANT` varchar(4) DEFAULT NULL,
  `ERH_COMP_CODE` varchar(4) DEFAULT NULL,
  `ERH_CATEGORY` varchar(10) DEFAULT NULL,
  `ERH_WF_STATUS` varchar(10) DEFAULT NULL,
  `ERH_FINAL_VALUE` decimal(12,2) DEFAULT NULL,
  `ERH_REC_VALUE` decimal(12,2) DEFAULT NULL,
  `ERH_PO_FLAG` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`ERH_RFQ_NO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_rfq_item_conditions`
--

DROP TABLE IF EXISTS `ezc_rfq_item_conditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_rfq_item_conditions` (
  `ERIC_VENDOR` varchar(15) NOT NULL,
  `ERIC_RFQ_NO` varchar(20) NOT NULL,
  `ERIC_LINE_NO` decimal(3,0) NOT NULL,
  `ERIC_TAX_CODE` varchar(15) NOT NULL,
  `ERIC_TAX_VALUE` varchar(25) DEFAULT NULL,
  `ERIC_TAX_TYPE` varchar(10) DEFAULT NULL,
  `ERIC_CFORM` varchar(5) DEFAULT NULL,
  `ERIC_EXT1` varchar(20) DEFAULT NULL,
  `ERIC_EXT2` varchar(20) DEFAULT NULL,
  `ERIC_EXT3` varchar(20) DEFAULT NULL,
  `ERIC_SEQ_NO` varchar(10) NOT NULL,
  `ERIC_NEG_TAX_VALUE` varchar(25) DEFAULT NULL,
  `ERIC_CURRENCY` varchar(5) DEFAULT NULL,
  `ERIC_EXCH_RATE` decimal(15,4) DEFAULT NULL,
  `ERIC_COND_VEND` varchar(15) DEFAULT NULL,
  `ERIC_EXT4` varchar(20) DEFAULT NULL,
  `ERIC_EXT5` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ERIC_VENDOR`,`ERIC_RFQ_NO`,`ERIC_LINE_NO`,`ERIC_TAX_CODE`,`ERIC_SEQ_NO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_rfq_pos`
--

DROP TABLE IF EXISTS `ezc_rfq_pos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_rfq_pos` (
  `ERP_RFQ_NO` varchar(10) NOT NULL,
  `ERP_RFQ_LINE_NO` varchar(5) NOT NULL,
  `ERP_PR_NO` varchar(10) NOT NULL,
  `ERP_PR_ITEM` varchar(5) NOT NULL,
  `ERP_PO_NO` varchar(10) NOT NULL,
  `ERP_PO_ITEM` varchar(5) NOT NULL,
  `ERP_QUANTITY` decimal(15,3) DEFAULT NULL,
  `ERP_TYPE` varchar(1) DEFAULT NULL,
  `ERP_SUP_ID` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`ERP_RFQ_NO`,`ERP_RFQ_LINE_NO`,`ERP_PR_NO`,`ERP_PR_ITEM`,`ERP_PO_NO`,`ERP_PO_ITEM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_rfq_prs`
--

DROP TABLE IF EXISTS `ezc_rfq_prs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_rfq_prs` (
  `ERP_QCF_NO` varchar(10) NOT NULL,
  `ERP_RFQ_LINE_NO` varchar(5) NOT NULL,
  `ERP_PR_NO` varchar(10) NOT NULL,
  `ERP_PR_ITEM` varchar(5) NOT NULL,
  `ERP_PR_QTY` decimal(15,3) DEFAULT NULL,
  `ERP_PR_OPEN_QTY` decimal(15,3) DEFAULT NULL,
  `ERP_PR_DEL_DATE` date DEFAULT NULL,
  `ERP_PR_TYPE` varchar(4) DEFAULT NULL,
  `ERP_PR_REL_DATE` date DEFAULT NULL,
  PRIMARY KEY (`ERP_QCF_NO`,`ERP_RFQ_LINE_NO`,`ERP_PR_NO`,`ERP_PR_ITEM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_rfq_quote_history`
--

DROP TABLE IF EXISTS `ezc_rfq_quote_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_rfq_quote_history` (
  `ERQH_VENDOR` varchar(15) NOT NULL,
  `ERQH_RFQ_NO` varchar(20) NOT NULL,
  `ERQH_LINE_NO` decimal(3,0) NOT NULL,
  `ERQH_COUNTER` decimal(3,0) NOT NULL,
  `ERQH_COND_CODE` varchar(15) NOT NULL,
  `ERQH_SEQ_NO` varchar(10) NOT NULL,
  `ERQH_COND_VALUE` varchar(25) DEFAULT NULL,
  `ERQH_COND_TYPE` varchar(10) DEFAULT NULL,
  `ERQH_COND_TOT_VALUE` varchar(25) DEFAULT NULL,
  `ERQH_ENTERED_BY` varchar(25) DEFAULT NULL,
  `ERQH_ENTERED_ON` datetime DEFAULT NULL,
  `ERQH_CFORM` varchar(5) DEFAULT NULL,
  `ERQH_QUOTE_FLAG` varchar(10) DEFAULT NULL,
  `ERQH_EXT1` varchar(20) DEFAULT NULL,
  `ERQH_EXT2` varchar(20) DEFAULT NULL,
  `ERQH_EXT3` varchar(20) DEFAULT NULL,
  `EQRH_CURRENCY` varchar(5) DEFAULT NULL,
  `EQRH_EXCH_RATE` decimal(15,3) DEFAULT NULL,
  `EQRH_COND_VEND` varchar(15) DEFAULT NULL,
  `EQRH_EXT4` varchar(20) DEFAULT NULL,
  `EQRH_EXT5` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ERQH_VENDOR`,`ERQH_RFQ_NO`,`ERQH_LINE_NO`,`ERQH_COUNTER`,`ERQH_COND_CODE`,`ERQH_SEQ_NO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_rfq_services`
--

DROP TABLE IF EXISTS `ezc_rfq_services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_rfq_services` (
  `ERS_SRV_PR` varchar(10) NOT NULL,
  `ERS_SRV_PR_ITEM` decimal(3,0) NOT NULL,
  `ERS_SRV_LINE` decimal(4,0) NOT NULL,
  `ERS_SRV_PKG` varchar(10) DEFAULT NULL,
  `ERS_SRV_RFQ` varchar(10) NOT NULL,
  `ERS_SRV_RFQ_ITEM` decimal(3,0) NOT NULL,
  `ERS_SRV_ACT` varchar(18) DEFAULT NULL,
  `ERS_SRV_DESC` varchar(50) DEFAULT NULL,
  `ERS_SRV_ITEM_TEXT` varchar(2000) DEFAULT NULL,
  `ERS_SRV_LINE_TEXT` varchar(2000) DEFAULT NULL,
  `ERS_SRV_QTY` decimal(15,3) DEFAULT NULL,
  `ERS_SRV_UOM` varchar(10) DEFAULT NULL,
  `ERS_SRV_CURR` varchar(5) DEFAULT NULL,
  `ERS_SRV_PRICE` decimal(15,4) DEFAULT NULL,
  `ERS_SRV_SAC` varchar(10) DEFAULT NULL,
  `ERS_SRV_GST` varchar(10) DEFAULT NULL,
  `ERS_SRV_EXT1` varchar(20) DEFAULT NULL,
  `ERS_SRV_EXT2` varchar(20) DEFAULT NULL,
  `ERS_SRV_EXT3` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ERS_SRV_PR`,`ERS_SRV_PR_ITEM`,`ERS_SRV_LINE`,`ERS_SRV_RFQ`,`ERS_SRV_RFQ_ITEM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_rfq_services_history`
--

DROP TABLE IF EXISTS `ezc_rfq_services_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_rfq_services_history` (
  `ERSH_SRV_RFQ` varchar(10) NOT NULL,
  `ERSH_SRV_RFQ_ITEM` decimal(3,0) NOT NULL,
  `ERSH_SRV_LINE` decimal(4,0) NOT NULL,
  `ERSH_SRV_COUNTER` decimal(3,0) NOT NULL,
  `ERSH_SRV_QTY` decimal(15,3) DEFAULT NULL,
  `ERSH_SRV_CURR` varchar(5) DEFAULT NULL,
  `ERSH_SRV_PRICE` decimal(15,4) DEFAULT NULL,
  `ERSH_SRV_SAC` varchar(10) DEFAULT NULL,
  `ERSH_SRV_GST` varchar(10) DEFAULT NULL,
  `ERSH_SRV_EXT1` varchar(20) DEFAULT NULL,
  `ERSH_SRV_EXT2` varchar(20) DEFAULT NULL,
  `ERSH_SRV_EXT3` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ERSH_SRV_RFQ`,`ERSH_SRV_RFQ_ITEM`,`ERSH_SRV_LINE`,`ERSH_SRV_COUNTER`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_role_auth`
--

DROP TABLE IF EXISTS `ezc_role_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_role_auth` (
  `ERA_ROLE_NR` varchar(16) NOT NULL,
  `ERA_SYS_NO` decimal(3,0) NOT NULL,
  `ERA_AUTH_KEY` varchar(16) NOT NULL,
  `ERA_AUTH_VALUE` varchar(128) DEFAULT NULL,
  `ERA_ACTIONS_OR_STATUSES` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`ERA_ROLE_NR`,`ERA_SYS_NO`,`ERA_AUTH_KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_roles_by_user`
--

DROP TABLE IF EXISTS `ezc_roles_by_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_roles_by_user` (
  `ERBU_USER_ID` char(10) DEFAULT NULL,
  `ERBU_SYSTEM_KEY` decimal(3,0) DEFAULT NULL,
  `ERBU_ROLE` decimal(3,0) DEFAULT NULL,
  UNIQUE KEY `ERBU_USER_ID` (`ERBU_USER_ID`,`ERBU_SYSTEM_KEY`,`ERBU_ROLE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_rolling_forecast`
--

DROP TABLE IF EXISTS `ezc_rolling_forecast`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_rolling_forecast` (
  `ERF_PRODUCT` varchar(18) DEFAULT NULL,
  `ERF_PACK` varchar(10) DEFAULT NULL,
  `ERF_SYSKEY` varchar(18) DEFAULT NULL,
  `ERF_SOLDTO` varchar(18) DEFAULT NULL,
  `ERF_USERID` varchar(18) DEFAULT NULL,
  `ERF_YEAR` decimal(4,0) DEFAULT NULL,
  `ERF_PERIOD1` decimal(14,2) DEFAULT NULL,
  `ERF_PERIOD2` decimal(14,2) DEFAULT NULL,
  `ERF_PERIOD3` decimal(14,2) DEFAULT NULL,
  `ERF_PERIOD4` decimal(14,2) DEFAULT NULL,
  `ERF_PERIOD5` decimal(14,2) DEFAULT NULL,
  `ERF_PERIOD6` decimal(14,2) DEFAULT NULL,
  `ERF_PERIOD7` decimal(14,2) DEFAULT NULL,
  `ERF_PERIOD8` decimal(14,2) DEFAULT NULL,
  `ERF_PERIOD9` decimal(14,2) DEFAULT NULL,
  `ERF_PERIOD10` decimal(14,2) DEFAULT NULL,
  `ERF_PERIOD11` decimal(14,2) DEFAULT NULL,
  `ERF_PERIOD12` decimal(14,2) DEFAULT NULL,
  `ERF_PERIOD13` decimal(14,2) DEFAULT NULL,
  `ERF_PERIOD14` decimal(14,2) DEFAULT NULL,
  `ERF_PERIOD15` decimal(14,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_saledoc_mails`
--

DROP TABLE IF EXISTS `ezc_saledoc_mails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_saledoc_mails` (
  `ESM_PRODUCT_CODE` varchar(18) DEFAULT NULL,
  `ESM_TO` varchar(1024) DEFAULT NULL,
  `ESM_CC` varchar(1024) DEFAULT NULL,
  `ESM_EDD` varchar(1024) DEFAULT NULL,
  `ESM_PLANT` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_sales_doc_header`
--

DROP TABLE IF EXISTS `ezc_sales_doc_header`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_sales_doc_header` (
  `ESDH_DOC_NUMBER` char(10) NOT NULL,
  `ESDH_SYS_KEY` varchar(18) NOT NULL,
  `ESDH_DOC_TYPE` char(4) NOT NULL,
  `ESDH_CREATE_ON` datetime NOT NULL,
  `ESDH_CREATED_BY` char(10) DEFAULT NULL,
  `ESDH_MODIFIED_BY` char(10) DEFAULT NULL,
  `ESDH_MODIFIED_ON` datetime DEFAULT NULL,
  `ESDH_BACK_END_ORDER` varchar(18) DEFAULT NULL,
  `ESDH_ORDER_DATE` datetime DEFAULT NULL,
  `ESDH_TRANSFER_DATE` datetime DEFAULT NULL,
  `ESDH_STATUS_DATE` datetime DEFAULT NULL,
  `ESDH_RES1` varchar(12) DEFAULT NULL,
  `ESDH_RES2` varchar(3072) DEFAULT NULL,
  `ESDH_DEL_FLAG` char(1) DEFAULT NULL,
  `ESDH_COLLECT_NO` varchar(10) DEFAULT NULL,
  `ESDH_SALES_ORG` char(4) DEFAULT NULL,
  `ESDH_DISTR_CHAN` char(2) DEFAULT NULL,
  `ESDH_DIVISION` char(2) DEFAULT NULL,
  `ESDH_SALES_GRP` char(3) DEFAULT NULL,
  `ESDH_SALES_OFF` char(4) DEFAULT NULL,
  `ESDH_REQ_DATE_H` datetime DEFAULT NULL,
  `ESDH_DATE_TYPE` char(1) DEFAULT NULL,
  `ESDH_DOC_CURRENCY` varchar(6) DEFAULT NULL,
  `ESDH_NET_VALUE` decimal(16,6) DEFAULT NULL,
  `ESDH_PO_NO` varchar(20) DEFAULT NULL,
  `ESDH_REF_DOC_NO` varchar(10) DEFAULT NULL,
  `ESDH_PURCH_NO` char(20) DEFAULT NULL,
  `ESDH_PURCH_DATE` datetime DEFAULT NULL,
  `ESDH_PO_METHOD` char(4) DEFAULT NULL,
  `ESDH_PO_SUPPLEM` char(4) DEFAULT NULL,
  `ESDH_REF_1` varchar(20) DEFAULT NULL,
  `ESDH_NAME` varchar(30) DEFAULT NULL,
  `ESDH_TELEPHONE` varchar(16) DEFAULT NULL,
  `ESDH_PRICE_GRP` char(2) DEFAULT NULL,
  `ESDH_CUST_GROUP` char(2) DEFAULT NULL,
  `ESDH_SALES_DIST` char(6) DEFAULT NULL,
  `ESDH_PRICE_LIST` char(2) DEFAULT NULL,
  `ESDH_INCOTERMS1` char(3) DEFAULT NULL,
  `ESDH_INCOTERMS2` varchar(28) DEFAULT NULL,
  `ESDH_PMNTTRMS` char(4) DEFAULT NULL,
  `ESDH_DLV_BLOCK` char(2) DEFAULT NULL,
  `ESDH_BILL_BLOCK` char(2) DEFAULT NULL,
  `ESDH_ORD_REASON` char(3) DEFAULT NULL,
  `ESDH_COMPL_DLV` char(1) DEFAULT NULL,
  `ESDH_PRICE_DATE` datetime DEFAULT NULL,
  `ESDH_QT_VALID_F` char(10) DEFAULT NULL,
  `ESDH_QT_VALID_T` char(10) DEFAULT NULL,
  `ESDH_CT_VALID_F` datetime DEFAULT NULL,
  `ESDH_CT_VALID_T` datetime DEFAULT NULL,
  `ESDH_CUST_GRP1` char(3) DEFAULT NULL,
  `ESDH_CUST_GRP2` char(3) DEFAULT NULL,
  `ESDH_CUST_GRP3` char(3) DEFAULT NULL,
  `ESDH_CUST_GRP4` char(3) DEFAULT NULL,
  `ESDH_CUST_GRP5` char(3) DEFAULT NULL,
  `ESDH_STATUS` varchar(15) DEFAULT NULL,
  `ESDH_SOLD_TO` char(10) DEFAULT NULL,
  `ESDH_SOLDTO_ADDR_1` varchar(64) DEFAULT NULL,
  `ESDH_SOLDTO_ADDR_2` varchar(64) DEFAULT NULL,
  `ESDH_SOLDTO_ADDR_3` varchar(64) DEFAULT NULL,
  `ESDH_SOLDTO_COUNTRY` char(3) DEFAULT NULL,
  `ESDH_SOLDTO_STATE` varchar(64) DEFAULT NULL,
  `ESDH_SOLDTO_PIN` varchar(64) DEFAULT NULL,
  `ESDH_SHIP_TO` char(10) DEFAULT NULL,
  `ESDH_SHIPTO_ADDR_1` varchar(64) DEFAULT NULL,
  `ESDH_SHIPTO_ADDR_2` varchar(64) DEFAULT NULL,
  `ESDH_SHIPTO_ADDR_3` varchar(64) DEFAULT NULL,
  `ESDH_SHIPTO_COUNTRY` char(3) DEFAULT NULL,
  `ESDH_SHIPTO_STATE` varchar(64) DEFAULT NULL,
  `ESDH_SHIPTO_PIN` varchar(64) DEFAULT NULL,
  `ESDH_TEXT1` text,
  `ESDH_TEXT2` varchar(1024) DEFAULT NULL,
  `ESDH_REF_DOC` varchar(40) DEFAULT NULL,
  `ESDH_AGENT_CODE` varchar(10) DEFAULT NULL,
  `ESDH_TYPE` char(1) DEFAULT NULL,
  `ESDH_DISCOUNT_CASH` decimal(10,2) DEFAULT NULL,
  `ESDH_DISCOUNT_PERCENTAGE` decimal(2,0) DEFAULT NULL,
  `EDSH_FREIGHT` varchar(10) DEFAULT NULL,
  `EDSH_TEXT3` varchar(1024) DEFAULT NULL,
  `ESDH_CLASS2` char(1) DEFAULT NULL,
  `ESDH_TEXT4` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`ESDH_DOC_NUMBER`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_sales_doc_items`
--

DROP TABLE IF EXISTS `ezc_sales_doc_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_sales_doc_items` (
  `ESDI_SALES_DOC` char(10) NOT NULL,
  `ESDI_SYS_KEY` varchar(18) NOT NULL,
  `ESDI_SALES_DOC_ITEM` decimal(6,0) NOT NULL,
  `ESDI_MATERIAL` varchar(18) DEFAULT NULL,
  `ESDI_PRICING_REF_MAT` varchar(18) DEFAULT NULL,
  `ESDI_BATCH_NO` varchar(10) DEFAULT NULL,
  `ESDI_MATERIAL_GROUP` varchar(9) DEFAULT NULL,
  `ESDI_SHORT_TEXT` varchar(100) DEFAULT NULL,
  `ESDI_REQ_DATE` datetime DEFAULT NULL,
  `ESDI_PROMISE_DATE` datetime DEFAULT NULL,
  `ESDI_DESIRED_PRICE` decimal(20,10) DEFAULT NULL,
  `ESDI_COMMITED_PRICE` decimal(20,10) DEFAULT NULL,
  `ESDI_DEL_FLAG` char(1) DEFAULT NULL,
  `ESDI_ITEM_CATEGORY` varchar(4) DEFAULT NULL,
  `ESDI_ITEM_TYPE` char(1) DEFAULT NULL,
  `ESDI_RELEVENT_FOR_DELIVRY` char(1) DEFAULT NULL,
  `ESDI_RELEVANT_FOR_BILLING` char(1) DEFAULT NULL,
  `ESDI_REASON_FOR_REJECTION` char(2) DEFAULT NULL,
  `ESDI_PRODUCT_GROUP` varchar(18) DEFAULT NULL,
  `ESDI_OUTLINE_AGR_VAL` decimal(13,2) DEFAULT NULL,
  `ESDI_QTY_IN_SALES_UNIT` decimal(13,0) DEFAULT NULL,
  `ESDI_SALES_UNIT` char(3) DEFAULT NULL,
  `ESDI_CONV_FACTOR_SU_TO_BU` decimal(5,0) DEFAULT NULL,
  `ESDI_BASE_UNIT_OF_MEASURE` char(3) DEFAULT NULL,
  `ESDI_QTY_IN_BASE_UNIT` decimal(13,0) DEFAULT NULL,
  `ESDI_ITEM_NO_OF_CUSTOMER` decimal(6,0) DEFAULT NULL,
  `ESDI_CUSTOMER_MAT` char(18) DEFAULT NULL,
  `ESDI_DIVISION` char(2) DEFAULT NULL,
  `ESDI_BUSS_AREA` char(4) DEFAULT NULL,
  `ESDI_NET_VAL_OF_ORDER` decimal(15,0) DEFAULT NULL,
  `ESDI_DOC_CURRENCY` char(5) DEFAULT NULL,
  `ESDI_BATCH_SPLIT_ALLOWED` char(1) DEFAULT NULL,
  `ESDI_REQ_QTY` decimal(15,3) DEFAULT NULL,
  `ESDI_CONFIRMED_QTY` decimal(15,3) DEFAULT NULL,
  `ESDI_DELIVERY_PRIORITY_PLANT` char(4) DEFAULT NULL,
  `ESDI_PLANT` char(4) DEFAULT NULL,
  `ESDI_STORAGE_LOC` char(4) DEFAULT NULL,
  `ESDI_SHIPPING_POINT` char(4) DEFAULT NULL,
  `ESDI_DATE_RECORD_CREATED` char(10) DEFAULT NULL,
  `ESDI_CREATED_BY` char(10) DEFAULT NULL,
  `ESDI_NET_PRICE` decimal(15,3) DEFAULT NULL,
  `ESDI_CASH_DISCOUNT_INDICATOR` char(1) DEFAULT NULL,
  `ESDI_AVAIL_CHECK_GROUP` char(2) DEFAULT NULL,
  `ESDI_PRICING_GROUP` char(2) DEFAULT NULL,
  `ESDI_ACCOUNT_ASSIGN_GROUP` char(2) DEFAULT NULL,
  `ESDI_REASON_MAT_SUBSTITUTION` varchar(40) DEFAULT NULL,
  `ESDI_STATISTICAL_VALUES` char(1) DEFAULT NULL,
  `ESDI_STATISTICS_DATED` char(10) DEFAULT NULL,
  `ESDI_BUSS_TRANSACTION_TYPE` char(4) DEFAULT NULL,
  `ESDI_PREFERENCE_IND_EXP_IMP` char(1) DEFAULT NULL,
  `ESDI_MAT_FREIGHT_GROUP` char(8) DEFAULT NULL,
  `ESDI_FOC` decimal(2,0) DEFAULT NULL,
  `ESDI_REF_DOC_ITEM` decimal(6,0) DEFAULT NULL,
  `ESDI_NOTES` text,
  `ESDI_BACK_END_ORDER` varchar(18) DEFAULT NULL,
  `ESDI_SALES_ORG` char(4) DEFAULT NULL,
  `ESDI_DISTR_CHAN` char(2) DEFAULT NULL,
  `ESDI_BACK_END_ITEM` varchar(6) DEFAULT NULL,
  `ESDI_SHIP_TO` char(10) DEFAULT NULL,
  `ESDI_DLV_BLOCK` char(1) DEFAULT NULL,
  `ESDI_INCOTERMS1` char(3) DEFAULT NULL,
  `ESDI_INCOTERMS2` varchar(28) DEFAULT NULL,
  `ESDI_REMARKS` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`ESDI_SALES_DOC`,`ESDI_SALES_DOC_ITEM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_sales_doc_partners`
--

DROP TABLE IF EXISTS `ezc_sales_doc_partners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_sales_doc_partners` (
  `ESDP_SALES_DOC` varchar(10) NOT NULL,
  `ESDP_SALES_AREA` varchar(18) NOT NULL,
  `ESDP_PARTNER_FUNCTION` varchar(4) NOT NULL,
  `ESDP_PARTNER_NUMBER` varchar(10) NOT NULL,
  `ESDP_EZC_CUSTOMER_NUMBER` varchar(10) NOT NULL,
  `ESDP_ERP_CUSTOMER_NUMBER` varchar(10) NOT NULL,
  `ESDP_ITM_NUMBER` decimal(6,0) DEFAULT NULL,
  `ESDP_TITLE` varchar(15) DEFAULT NULL,
  `ESDP_NAME` varchar(35) DEFAULT NULL,
  `ESDP_NAME_2` varchar(35) DEFAULT NULL,
  `ESDP_NAME_3` varchar(35) DEFAULT NULL,
  `ESDP_NAME_4` varchar(35) DEFAULT NULL,
  `ESDP_STREET` varchar(35) DEFAULT NULL,
  `ESDP_COUNTRY` varchar(3) DEFAULT NULL,
  `ESDP_POSTL_CODE` varchar(10) DEFAULT NULL,
  `ESDP_CITY` varchar(35) DEFAULT NULL,
  `ESDP_DISTRICT` varchar(35) DEFAULT NULL,
  `ESDP_REGION` varchar(3) DEFAULT NULL,
  `ESDP_PO_BOX` varchar(10) DEFAULT NULL,
  `ESDP_TELEPHONE` varchar(16) DEFAULT NULL,
  `ESDP_TELEPHONE2` varchar(16) DEFAULT NULL,
  `ESDP_FAX_NUMBER` varchar(31) DEFAULT NULL,
  `ESDP_TELETEX_NO` varchar(30) DEFAULT NULL,
  `ESDP_TELEX_NO` varchar(30) DEFAULT NULL,
  `ESDP_UNLOAD_PT` varchar(25) DEFAULT NULL,
  `ESDP_TRANSPZONE` varchar(10) DEFAULT NULL,
  `ESDP_TAXJURCODE` varchar(15) DEFAULT NULL,
  `ESDP_BACK_END_NUMBER` varchar(10) DEFAULT NULL,
  `ESDP_BACK_ITM_NUMBER` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_sample_materials`
--

DROP TABLE IF EXISTS `ezc_sample_materials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_sample_materials` (
  `EZSM_SAMPLE_ID` decimal(6,0) NOT NULL,
  `EZSM_MATERIAL_ID` decimal(6,0) DEFAULT NULL,
  `EZSM_SOLDTO` varchar(10) DEFAULT NULL,
  `EZSM_SYSKEY` varchar(18) DEFAULT NULL,
  `EZSM_PO_NO` varchar(10) DEFAULT NULL,
  `EZSM_PO_DATE` datetime DEFAULT NULL,
  `EZSM_IS_MATSPECS` char(1) DEFAULT NULL,
  `EZSM_SUBMISSION_DATE` datetime DEFAULT NULL,
  `EZSM_MS_ADDR_ID` decimal(6,0) DEFAULT NULL,
  `EZSM_SUPP_ADDR_ID` decimal(6,0) DEFAULT NULL,
  `EZSM_SHIPMENT_ID` decimal(6,0) DEFAULT NULL,
  `EZSM_FILES_ATTACHED` char(1) DEFAULT NULL,
  `EZSM_UPLOAD_ID` decimal(6,0) DEFAULT NULL,
  `EZSM_EXT1` varchar(20) DEFAULT NULL,
  `EZSM_EXT2` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_sec_sales_info_details`
--

DROP TABLE IF EXISTS `ezc_sec_sales_info_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_sec_sales_info_details` (
  `EZSD_STMT_ID` decimal(12,0) NOT NULL,
  `EZSD_MAT_NO` varchar(18) NOT NULL,
  `EZSD_PACK` varchar(5) DEFAULT NULL,
  `EZSD_PRICE` decimal(12,3) DEFAULT NULL,
  `EZSD_MATGRP` varchar(5) DEFAULT NULL,
  `EZSD_MONTH` decimal(2,0) DEFAULT NULL,
  `EZSD_YEAR` decimal(4,0) DEFAULT NULL,
  `EZSD_DIVISION` varchar(2) DEFAULT NULL,
  `EZSD_DISTRCH` varchar(2) DEFAULT NULL,
  `EZSD_SALESORG` varchar(4) DEFAULT NULL,
  `EZSD_OPEN_STOCK` decimal(15,3) DEFAULT NULL,
  `EZSD_RECEIPTS` decimal(15,3) DEFAULT NULL,
  `EZSD_RECEIPTS_FRS` decimal(15,3) DEFAULT NULL,
  `EZSD_RECEIPTS_BONUS` decimal(15,3) DEFAULT NULL,
  `EZSD_OTH_RECEIPTS` decimal(15,3) DEFAULT NULL,
  `EZSD_TOTAL_STOCK` decimal(15,3) DEFAULT NULL,
  `EZSD_SALES` decimal(15,3) DEFAULT NULL,
  `EZSD_OTH_ISSUES` decimal(15,3) DEFAULT NULL,
  `EZSD_CLOSE_STOCK` decimal(15,3) DEFAULT NULL,
  `EZSD_IN_TRANSIT` decimal(15,3) DEFAULT NULL,
  `EZSD_IN_TRANSIT_FRS` decimal(15,3) DEFAULT NULL,
  `EZSD_IN_TRANSIT_BONUS` decimal(15,3) DEFAULT NULL,
  `EZSD_SALES_ADJ` decimal(15,3) DEFAULT NULL,
  `EZSD_DEVOLUTION` decimal(15,3) DEFAULT NULL,
  `EZSD_PLANT` char(4) DEFAULT NULL,
  `EZSD_FLAG1` char(1) DEFAULT NULL,
  `EZSD_FLAG2` char(2) DEFAULT NULL,
  `EZSD_TEXT1` char(1) DEFAULT NULL,
  `EZSD_TEXT2` char(200) DEFAULT NULL,
  `EZSD_EXT1` varchar(20) DEFAULT NULL,
  `EZSD_EXT2` varchar(20) DEFAULT NULL,
  `EZSD_EXT3` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_sec_sales_info_header`
--

DROP TABLE IF EXISTS `ezc_sec_sales_info_header`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_sec_sales_info_header` (
  `EZSH_SOLDTO` varchar(18) NOT NULL,
  `EZSH_MONTH` decimal(2,0) NOT NULL,
  `EZSH_YEAR` decimal(4,0) NOT NULL,
  `EZSH_SYSKEY` varchar(10) NOT NULL,
  `EZSH_USERID` varchar(10) DEFAULT NULL,
  `EZSH_USERTYPE` char(1) DEFAULT NULL,
  `EZSH_SALES_OFFICE` char(4) DEFAULT NULL,
  `EzSH_SALES_GRP` char(20) DEFAULT NULL,
  `EZSH_PLANT` char(4) DEFAULT NULL,
  `EZSH_STATUS` char(1) DEFAULT NULL,
  `EZSH_SALES_DIST` char(6) DEFAULT NULL,
  `EZSH_STMT_ID` decimal(12,0) DEFAULT NULL,
  `EZSH_CREATED_ON` datetime DEFAULT NULL,
  `EZSH_CHANGED_ON` datetime DEFAULT NULL,
  `EZSH_LAST_MOD_BY` varchar(10) DEFAULT NULL,
  `EZSH_LAST_MODBY_USERTYPE` char(2) DEFAULT NULL,
  `EZSH_TEXT2` varchar(200) DEFAULT NULL,
  `EZSH_EXT1` varchar(20) DEFAULT NULL,
  `EZSH_EXT2` varchar(20) DEFAULT NULL,
  `EZSH_TEXT1` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_sec_sales_view`
--

DROP TABLE IF EXISTS `ezc_sec_sales_view`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_sec_sales_view` (
  `EZSH_SOLDTO` varchar(18) NOT NULL,
  `EZSH_SYSKEY` varchar(10) NOT NULL,
  `EZSH_USERID` varchar(10) DEFAULT NULL,
  `EZSH_USERTYPE` char(1) DEFAULT NULL,
  `EZSH_SALES_OFFICE` char(4) DEFAULT NULL,
  `EzSH_SALES_GRP` char(20) DEFAULT NULL,
  `EZSH_STATUS` char(1) DEFAULT NULL,
  `EZSH_SALES_DIST` char(6) DEFAULT NULL,
  `EZSH_CREATED_ON` datetime DEFAULT NULL,
  `EZSH_CHANGED_ON` datetime DEFAULT NULL,
  `EZSH_LAST_MOD_BY` varchar(10) DEFAULT NULL,
  `EZSH_LAST_MODBY_USERTYPE` char(2) DEFAULT NULL,
  `EZSH_STMT_ID` decimal(12,0) DEFAULT NULL,
  `EZSH_TEXT1` char(1) DEFAULT NULL,
  `EZSH_TEXT2` varchar(200) DEFAULT NULL,
  `EZSH_EXT1` varchar(20) DEFAULT NULL,
  `EZSH_EXT2` varchar(20) DEFAULT NULL,
  `EZSD_STMT_ID` decimal(12,0) NOT NULL,
  `EZSD_MAT_NO` varchar(18) NOT NULL,
  `EZSD_PACK` varchar(5) DEFAULT NULL,
  `EZSD_PRICE` decimal(12,3) DEFAULT NULL,
  `EZSD_MATGRP` varchar(5) DEFAULT NULL,
  `EZSD_MONTH` decimal(2,0) DEFAULT NULL,
  `EZSD_YEAR` decimal(4,0) DEFAULT NULL,
  `EZSD_DIVISION` varchar(2) DEFAULT NULL,
  `EZSD_DISTRCH` varchar(2) DEFAULT NULL,
  `EZSD_SALESORG` varchar(4) DEFAULT NULL,
  `EZSD_OPEN_STOCK` decimal(15,3) DEFAULT NULL,
  `EZSD_RECEIPTS` decimal(15,3) DEFAULT NULL,
  `EZSD_RECEIPTS_FRS` decimal(15,3) DEFAULT NULL,
  `EZSD_RECEIPTS_BONUS` decimal(15,3) DEFAULT NULL,
  `EZSD_OTH_RECEIPTS` decimal(15,3) DEFAULT NULL,
  `EZSD_TOTAL_STOCK` decimal(15,3) DEFAULT NULL,
  `EZSD_SALES` decimal(15,3) DEFAULT NULL,
  `EZSD_OTH_ISSUES` decimal(15,3) DEFAULT NULL,
  `EZSD_CLOSE_STOCK` decimal(15,3) DEFAULT NULL,
  `EZSD_IN_TRANSIT` decimal(15,3) DEFAULT NULL,
  `EZSD_IN_TRANSIT_FRS` decimal(15,3) DEFAULT NULL,
  `EZSD_IN_TRANSIT_BONUS` decimal(15,3) DEFAULT NULL,
  `EZSD_SALES_ADJ` decimal(15,3) DEFAULT NULL,
  `EZSD_DEVOLUTION` decimal(15,3) DEFAULT NULL,
  `EZSD_PLANT` char(4) DEFAULT NULL,
  `EZSD_FLAG1` char(1) DEFAULT NULL,
  `EZSD_FLAG2` char(2) DEFAULT NULL,
  `EZSD_TEXT1` char(1) DEFAULT NULL,
  `EZSD_TEXT2` char(200) DEFAULT NULL,
  `EZSD_EXT1` varchar(20) DEFAULT NULL,
  `EZSD_EXT2` varchar(20) DEFAULT NULL,
  `EZSD_EXT3` varchar(20) DEFAULT NULL,
  `EMD_DESC` varchar(120) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_service_area`
--

DROP TABLE IF EXISTS `ezc_service_area`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_service_area` (
  `ESAR_SERVICE_AREA_CODE` varchar(3) NOT NULL,
  `ESAR_ZIP_CODE_START` varchar(5) DEFAULT NULL,
  `ESAR_ZIP_CODE_END` varchar(5) DEFAULT NULL,
  `ESAR_MAIN_SRVAREA_CODE` varchar(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_service_category`
--

DROP TABLE IF EXISTS `ezc_service_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_service_category` (
  `ESC_CATEGORY` decimal(6,0) NOT NULL,
  `ESC_LANG` char(2) NOT NULL,
  `ESC_DESC` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_service_center`
--

DROP TABLE IF EXISTS `ezc_service_center`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_service_center` (
  `ESCN_SERVICE_CENTER_CODE` varchar(3) NOT NULL,
  `ESCN_SERVICE_AREA_CODES` varchar(3) DEFAULT NULL,
  `ESCN_MAIN_SRV_CEN_CODE` varchar(3) DEFAULT NULL,
  `ESCN_ADDRESS_CODE` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_service_engineer`
--

DROP TABLE IF EXISTS `ezc_service_engineer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_service_engineer` (
  `ESRE_ENGINEER_ID` char(10) NOT NULL,
  `ESRE_FIRST_NAME` varchar(60) DEFAULT NULL,
  `ESRE_LAST_NAME` varchar(60) DEFAULT NULL,
  `ESRE_SERVICE_CENTER` varchar(3) DEFAULT NULL,
  `ESRE_CALENDAR_CODE` varchar(6) DEFAULT NULL,
  `ESRE_PAGER_NUMBER` varchar(30) DEFAULT NULL,
  `ESRE_MOBILE_NUMBER` varchar(30) DEFAULT NULL,
  `ESRE_RESIDENCE_PHONE` varchar(64) DEFAULT NULL,
  `ESRE_EMAIL` varchar(64) DEFAULT NULL,
  `ESRE_LABOR_RATE_CODE` varchar(3) DEFAULT NULL,
  `ESRE_BUSS_AREA` decimal(6,0) DEFAULT NULL,
  `ESRE_SUPERVISOR_CODE` char(10) DEFAULT NULL,
  `ESRE_ADDRESS_CODE` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_service_materials`
--

DROP TABLE IF EXISTS `ezc_service_materials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_service_materials` (
  `ESM_PLANT` varchar(5) NOT NULL,
  `ESM_MATERIAL` varchar(18) NOT NULL,
  `ESM_MATERIAL_DESC` varchar(50) DEFAULT NULL,
  `ESM_TYPE` varchar(10) DEFAULT NULL,
  `ESM_UOM` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`ESM_PLANT`,`ESM_MATERIAL`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_service_request`
--

DROP TABLE IF EXISTS `ezc_service_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_service_request` (
  `EZSR_REQ_ID` varchar(10) NOT NULL,
  `EZSR_CREATION_DATE` datetime DEFAULT NULL,
  `EZSR_CREATED_BY` char(10) DEFAULT NULL,
  `EZSR_SOURCE` varchar(10) DEFAULT NULL,
  `EZSR_EMERGENCY_REQUEST` char(1) DEFAULT NULL,
  `EZSR_FOLLOW_REQUEST_ID` varchar(9) DEFAULT NULL,
  `EZSR_FOLLOW_MAINTAIN_ORDER_ID` varchar(9) DEFAULT NULL,
  `EZSR_STATUS` varchar(20) DEFAULT NULL,
  `EZSR_STATUS_DATE` datetime DEFAULT NULL,
  `EZSR_RESP_ENGINEER` char(10) DEFAULT NULL,
  `EZSR_RESP_SERVICE_CENTER` varchar(3) DEFAULT NULL,
  `EZSR_WAIT` char(1) DEFAULT NULL,
  `EZSR_WAIT_REASON` varchar(132) DEFAULT NULL,
  `EZSR_CUST_CODE` char(10) DEFAULT NULL,
  `EZSR_CUST_ADD1` varchar(100) DEFAULT NULL,
  `EZSR_CUST_ADD2` varchar(100) DEFAULT NULL,
  `EZSR_CUST_ADD3` varchar(100) DEFAULT NULL,
  `EZSR_CITY` varchar(64) DEFAULT NULL,
  `EZSR_STATE` varchar(64) DEFAULT NULL,
  `EZSR_COUNTRY` varchar(64) DEFAULT NULL,
  `EZSR_ZIPCODE` varchar(10) DEFAULT NULL,
  `EZSR_CONTACT_PERSON` varchar(100) DEFAULT NULL,
  `EZSR_TELNO` varchar(64) DEFAULT NULL,
  `EZSR_SERVICE_AREA` varchar(3) DEFAULT NULL,
  `EZSR_SERVICE_CENTER` varchar(3) DEFAULT NULL,
  `EZSR_EQUIP_CODE` varchar(10) DEFAULT NULL,
  `EZSR_EQUIP_SL_NO` varchar(50) DEFAULT NULL,
  `EZSR_EQUIP_CONDITION` varchar(10) DEFAULT NULL,
  `EZSR_APPT_START_TIME` varchar(10) DEFAULT NULL,
  `EZSR_APPT_END_TIME` varchar(10) DEFAULT NULL,
  `EZSR_SHORT_DESC` varchar(1024) DEFAULT NULL,
  `EZSR_PROBLEM_CODE` varchar(6) DEFAULT NULL,
  `EZSR_PRIORITY` varchar(10) DEFAULT NULL,
  `EZSR_EXPECTED_RESPONSE_TIME` varchar(3) DEFAULT NULL,
  `EZSR_LONG_DESC` varchar(2048) DEFAULT NULL,
  `EZSR_ACTUAL_DURATION` decimal(5,2) DEFAULT NULL,
  `EZSR_ACTUAL_DURATION_UNIT` varchar(5) DEFAULT NULL,
  `EZSR_SOLUTION_CODE` varchar(6) DEFAULT NULL,
  `EZSR_DESC_TEXT` varchar(250) DEFAULT NULL,
  `EZSR_SOLUTION_DATE` varchar(10) DEFAULT NULL,
  `EZSR_ERP_REQ_ID` varchar(9) DEFAULT NULL,
  `EZSR_PLAN_ENGINE_REQ_ID` varchar(9) DEFAULT NULL,
  `EZSR_EXP_RESPONSE_TIME` decimal(18,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_service_request_desc`
--

DROP TABLE IF EXISTS `ezc_service_request_desc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_service_request_desc` (
  `ESRD_LANGUAGE` varchar(2) DEFAULT NULL,
  `ESRD_SER_REQ_ID` varchar(10) DEFAULT NULL,
  `ESRD_SR_DESC` varchar(50) DEFAULT NULL,
  `ESRD_WAIT_REASON` varchar(132) DEFAULT NULL,
  `ESRD_SR_GEN_TXT` varchar(2048) DEFAULT NULL,
  `ESRD_PROBLEM_DESC` varchar(2048) DEFAULT NULL,
  `ESRD_SOLUTION_DESC` varchar(2048) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_service_versions`
--

DROP TABLE IF EXISTS `ezc_service_versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_service_versions` (
  `ESVE_CODE_TYPE` char(2) NOT NULL,
  `ESVE_VERSION_ID` decimal(8,0) NOT NULL,
  `ESVE_LANG` char(2) NOT NULL,
  `ESVE_DESCRIPTION` varchar(100) DEFAULT NULL,
  `ESVE_TEXT` varchar(500) DEFAULT NULL,
  `ESVE_EFFECT_FROM` datetime DEFAULT NULL,
  `ESVE_CREATED_BY` char(10) DEFAULT NULL,
  `ESVE_CREATED_ON` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_shipment_conditions`
--

DROP TABLE IF EXISTS `ezc_shipment_conditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_shipment_conditions` (
  `EZSC_SH_ID` decimal(6,0) NOT NULL,
  `EZSC_LINE_NR` decimal(3,0) NOT NULL,
  `EZSC_COND_TYPE` varchar(50) NOT NULL,
  `EZSC_COND_VALUE` decimal(18,2) DEFAULT NULL,
  `EZSC_QTY_SHIPPED` decimal(15,3) DEFAULT NULL,
  `EZSC_PER_VAL` decimal(18,2) DEFAULT NULL,
  `EZSC_EXT1` varchar(10) DEFAULT NULL,
  `EZSC_EXT2` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`EZSC_SH_ID`,`EZSC_LINE_NR`,`EZSC_COND_TYPE`),
  CONSTRAINT `EZC_SHIPMENT_CONDITIONS_FK` FOREIGN KEY (`EZSC_SH_ID`) REFERENCES `ezc_shipment_header` (`EZSH_SH_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_shipment_header`
--

DROP TABLE IF EXISTS `ezc_shipment_header`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_shipment_header` (
  `EZSH_PO_NUM` varchar(10) NOT NULL,
  `EZSH_SH_ID` decimal(6,0) NOT NULL,
  `EZSH_DOC_TYPE` char(1) DEFAULT NULL,
  `EZSH_PO_DATE` datetime DEFAULT NULL,
  `EZSH_DC_NR` varchar(30) DEFAULT NULL,
  `EZSH_DC_DATE` datetime DEFAULT NULL,
  `EZSH_PO_REV` varchar(2) DEFAULT NULL,
  `EZSH_INV_NUM` varchar(20) DEFAULT NULL,
  `EZSH_INV_DATE` datetime DEFAULT NULL,
  `EZSH_CREATED_BY` varchar(10) DEFAULT NULL,
  `EZSH_CREATED_ON` datetime DEFAULT NULL,
  `EZSH_LAST_MOD_ON` datetime DEFAULT NULL,
  `EZSH_LR_RR_AIR_NR` varchar(30) DEFAULT NULL,
  `EZSH_SHIPMENT_DATE` datetime DEFAULT NULL,
  `EZSH_CARRIER` varchar(50) DEFAULT NULL,
  `EZSH_EXP_ARIVAL_TIME` datetime DEFAULT NULL,
  `EZSH_STATUS` char(1) DEFAULT NULL,
  `EZSH_TEXT` text,
  `EZSH_FILES_ATTACHED` char(1) DEFAULT NULL,
  `EZSH_UPLOAD_ID` decimal(6,0) DEFAULT NULL,
  `EZSH_SYS_KEY` varchar(18) DEFAULT NULL,
  `EZSH_SOLD_TO` varchar(10) DEFAULT NULL,
  `EZSH_EXT1` varchar(20) DEFAULT NULL,
  `EZSH_EXT2` varchar(20) DEFAULT NULL,
  `EZSH_EXT3` varchar(20) DEFAULT NULL,
  `EZSH_INV_VALUE` decimal(18,2) DEFAULT NULL,
  `EZSH_CURRENCY` varchar(3) DEFAULT NULL,
  `EZSH_SAP_INV_NUM` varchar(20) DEFAULT NULL,
  `EZSH_SAP_INV_AMOUNT` decimal(18,0) DEFAULT NULL,
  `EZSH_SAP_INV_DATE` datetime DEFAULT NULL,
  `EZSH_GR_NUMBER1` varchar(10) DEFAULT NULL,
  `EZSH_GR_DATE1` date DEFAULT NULL,
  `EZSH_GR_NUMBER2` varchar(10) DEFAULT NULL,
  `EZSH_GR_DATE2` datetime DEFAULT NULL,
  `EZSH_GR_STATUS` varchar(1) DEFAULT NULL,
  `EZSH_PUR_GRP` varchar(5) DEFAULT NULL,
  `EZSH_PLANT` varchar(5) DEFAULT NULL,
  `EZSH_CONTACT_NUM` varchar(20) DEFAULT NULL,
  `EZSH_GROSS_VAL` decimal(15,3) DEFAULT NULL,
  `EZSH_TAX_VAL` decimal(15,3) DEFAULT NULL,
  `EZSH_NET_VAL` decimal(15,3) DEFAULT NULL,
  `EZSH_SAP_ID` varchar(15) DEFAULT NULL,
  `EZSH_TRANSACTION_STATUS` varchar(20) DEFAULT NULL,
  `EZSH_APPROVER` varchar(10) DEFAULT NULL,
  `EZSH_APPROVAL_STATUS` varchar(10) DEFAULT NULL,
  `EZSH_INV_TYPE` varchar(10) DEFAULT NULL,
  `EZSH_SMARTDOC_STATUS` varchar(10) DEFAULT NULL,
  `EZSH_SMARTDOC_STATUS_TEXT` varchar(100) DEFAULT NULL,
  `EZSH_SMARTDOC_STATUS_UPDATED_ON` datetime DEFAULT NULL,
  `EZSH_EW_BILL_NO` varchar(30) DEFAULT NULL,
  `EZSH_EW_BILL_DATE` datetime DEFAULT NULL,
  `EZSH_LR_NUMBER` varchar(30) DEFAULT NULL,
  `EZSH_TRIP_SHEET` varchar(30) DEFAULT NULL,
  `EZSH_GATE_ENTRY` varchar(30) DEFAULT NULL,
  `EZSH_PARK_STS` varchar(1) DEFAULT NULL,
  `EZSH_PARK_DOC` varchar(10) DEFAULT NULL,
  `EZSH_PARK_DATE` date DEFAULT NULL,
  `EZSH_NO_TAX_MISC` decimal(18,2) DEFAULT NULL,
  `EZSH_TAX_MISC` decimal(18,2) DEFAULT NULL,
  `EZSH_TAX_FRT` decimal(18,2) DEFAULT NULL,
  `EZSH_NON_TAX_FRT` decimal(18,2) DEFAULT NULL,
  `EZSH_OTH_FRT` decimal(18,2) DEFAULT NULL,
  `EZSH_PUR_ORG` varchar(5) DEFAULT NULL,
  `EZSH_FRT_PARK_STS` varchar(1) DEFAULT NULL,
  `EZSH_FRT_PARK_DOC` varchar(10) DEFAULT NULL,
  `EZSH_FRT_PARK_DATE` date DEFAULT NULL,
  `EZSH_PARK_ATTACH` varchar(1) DEFAULT NULL,
  UNIQUE KEY `EZC_SHIPMENT_HEADER_UK` (`EZSH_SH_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_shipment_lines`
--

DROP TABLE IF EXISTS `ezc_shipment_lines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_shipment_lines` (
  `EZSL_SH_ID` decimal(6,0) NOT NULL,
  `EZSL_LINE_NR` decimal(3,0) NOT NULL,
  `EZSL_MAT_NR` varchar(20) DEFAULT NULL,
  `EZSL_MAT_DESC` varchar(50) DEFAULT NULL,
  `EZSL_UOM_QTY` varchar(10) DEFAULT NULL,
  `EZSL_QTY_SHIPPED` decimal(15,3) DEFAULT NULL,
  `EZSL_FILES_ATTACHED` char(1) DEFAULT NULL,
  `EZSL_UPLOAD_ID` decimal(6,0) DEFAULT NULL,
  `EZSL_EXT1` varchar(50) DEFAULT NULL,
  `EZSL_EXT2` varchar(20) DEFAULT NULL,
  `EZSL_CURRENCY` varchar(3) DEFAULT NULL,
  `EZSL_PRICE` decimal(15,3) DEFAULT NULL,
  `EZSL_VALUE` decimal(15,3) DEFAULT NULL,
  `EZSL_PLANT` varchar(4) DEFAULT NULL,
  `EZSL_STORAGE_LOC` varchar(4) DEFAULT NULL,
  `EZSL_REF_DOC_NR` varchar(10) DEFAULT NULL,
  `EZSL_REF_DOC_ITEM` decimal(18,0) DEFAULT NULL,
  `EZSL_REF_DOC_DATE` datetime DEFAULT NULL,
  `EZSL_REF_SH_ID` decimal(18,0) DEFAULT NULL,
  `EZSL_PO_NUM` varchar(10) DEFAULT NULL,
  `EZSL_PO_ITEM` decimal(18,0) DEFAULT NULL,
  `EZSL_EXT3` text,
  `EZSL_QTY_RECEIVED` decimal(15,3) DEFAULT NULL,
  `EZSL_REASON_EXISTS` varchar(5) DEFAULT NULL,
  `EZSL_SCHD_QTY` decimal(15,3) DEFAULT NULL,
  `EZSL_GR_QTY` decimal(15,3) DEFAULT NULL,
  `EZSL_IBD_QTY` decimal(15,3) DEFAULT NULL,
  `EZSL_GROSS_VAL` decimal(15,3) DEFAULT NULL,
  `EZSL_TAX_VAL` decimal(15,3) DEFAULT NULL,
  `EZSL_NET_VAL` decimal(15,3) DEFAULT NULL,
  `EZSL_EXT4` varchar(10) DEFAULT NULL,
  `EZSL_EXT5` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`EZSL_SH_ID`,`EZSL_LINE_NR`),
  CONSTRAINT `EZC_SHIPMENT_LINES_FK` FOREIGN KEY (`EZSL_SH_ID`) REFERENCES `ezc_shipment_header` (`EZSH_SH_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_shipment_schedules`
--

DROP TABLE IF EXISTS `ezc_shipment_schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_shipment_schedules` (
  `EZSD_SH_ID` decimal(6,0) NOT NULL,
  `EZSD_LINE_NR` decimal(3,0) NOT NULL,
  `EZSD_SCHD_LINE` decimal(3,0) NOT NULL,
  `EZSD_BATCH` varchar(16) DEFAULT NULL,
  `EZSD_MFG_DATE` datetime DEFAULT NULL,
  `EZSD_EXP_DATE` datetime DEFAULT NULL,
  `EZSD_BATCH_QTY` decimal(15,3) DEFAULT NULL,
  `EZSD_FILES_ATTACHED` char(1) DEFAULT NULL,
  `EZSD_UPLOAD_ID` decimal(6,0) DEFAULT NULL,
  `EZSD_EXT1` varchar(20) DEFAULT NULL,
  `EZSD_EXT2` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EZSD_SH_ID`,`EZSD_LINE_NR`,`EZSD_SCHD_LINE`),
  CONSTRAINT `EZC_SHIPMENT_DELV_SCHEDULES_FK` FOREIGN KEY (`EZSD_SH_ID`) REFERENCES `ezc_shipment_header` (`EZSH_SH_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_site_globals`
--

DROP TABLE IF EXISTS `ezc_site_globals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_site_globals` (
  `ESG_SITE_NO` decimal(3,0) NOT NULL,
  `ESG_OUTSIDE_CATALOG` decimal(8,0) DEFAULT NULL,
  `ESG_AUDIT_LOG_ON_OFF_FLAG` char(1) DEFAULT NULL,
  `ESG_SYNC_TRACE_FLAG` char(1) DEFAULT NULL,
  `ESG_SCH_TIME_MAT_SYNC` char(10) DEFAULT NULL,
  `ESG_SCH_TIME_CUST_SYNC` char(10) DEFAULT NULL,
  `ESG_MAX_NUMBER` decimal(6,0) DEFAULT NULL,
  `ESG_MULTIPLE_SYSTEMS_ALLOWED` decimal(1,0) DEFAULT NULL,
  `ESG_MULTIPLE_SALES_AREAS` decimal(1,0) DEFAULT NULL,
  `ESG_MAX_BUSS_USERS` decimal(6,0) DEFAULT NULL,
  `ESG_MAX_INTRANET_USERS` decimal(6,0) DEFAULT NULL,
  `ESG_MAX_INTERNET_USERS` decimal(6,0) DEFAULT NULL,
  `ESG_UNLIMITED_BUSS_USERS` char(1) DEFAULT NULL,
  `ESG_UNLIMITED_INTRANET_USERS` char(1) DEFAULT NULL,
  `ESG_UNLIMITED_INTERNET_USERS` char(1) DEFAULT NULL,
  `ESG_BASE_ERP_SYS_NO` decimal(3,0) DEFAULT NULL,
  `EZG_CUST_VALID_FLAG` char(1) DEFAULT NULL,
  PRIMARY KEY (`ESG_SITE_NO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_skills_for_srveng`
--

DROP TABLE IF EXISTS `ezc_skills_for_srveng`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_skills_for_srveng` (
  `ESFE_SERVICE_ENGINEER_CODE` char(10) NOT NULL,
  `ESFE_SKILL_CODES` varchar(300) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_smartdoc_ids`
--

DROP TABLE IF EXISTS `ezc_smartdoc_ids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_smartdoc_ids` (
  `ESI_PORTAL_ID` varchar(10) DEFAULT NULL,
  `ESI_SMART_DOC_ID` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_sms_otp`
--

DROP TABLE IF EXISTS `ezc_sms_otp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_sms_otp` (
  `ESO_USER_ID` varchar(15) NOT NULL,
  `ESO_OTP` varchar(10) NOT NULL,
  `ESO_OTP_FOR` varchar(20) NOT NULL,
  `ESO_MOBILE_NO` varchar(12) NOT NULL,
  `ESO_VENDOR` varchar(10) DEFAULT NULL,
  `ESO_VALID_FROM` datetime NOT NULL,
  `ESO_VALID_TO` datetime DEFAULT NULL,
  `ESO_EXT1` varchar(100) DEFAULT NULL,
  `ESO_EXT2` varchar(100) DEFAULT NULL,
  `ESO_EXT3` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ESO_USER_ID`,`ESO_OTP`,`ESO_OTP_FOR`,`ESO_MOBILE_NO`,`ESO_VALID_FROM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_so_dyn_partner`
--

DROP TABLE IF EXISTS `ezc_so_dyn_partner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_so_dyn_partner` (
  `ESDP_SO_N0` char(10) NOT NULL,
  `ESDP_SHIP_TO_CUST` char(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_solution`
--

DROP TABLE IF EXISTS `ezc_solution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_solution` (
  `EZSN_CODE` varchar(6) NOT NULL,
  `EZSN_SEQNO` decimal(4,0) NOT NULL,
  `EZSN_STEPS` varchar(2048) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_spare_models`
--

DROP TABLE IF EXISTS `ezc_spare_models`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_spare_models` (
  `ESM_INSTRUMENT_MODEL` varchar(20) NOT NULL,
  `ESM_SPARE_MODEL_CODE` decimal(6,0) NOT NULL,
  `ESM_LANG` char(2) DEFAULT NULL,
  `ESM_DESCRIPTION` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_spareparts_by_location`
--

DROP TABLE IF EXISTS `ezc_spareparts_by_location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_spareparts_by_location` (
  `ESBL_PART_ID` varchar(18) NOT NULL,
  `ESBL_ADDRESS_CODE` varchar(6) NOT NULL,
  `ESBL_UOM` varchar(10) NOT NULL,
  `ESBL_BATCH` varchar(10) NOT NULL,
  `ESBL_ISSUED_QUANTITY` decimal(18,0) DEFAULT NULL,
  `ESBL_QUANTITY_ONHAND` decimal(18,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_stock_movement_log`
--

DROP TABLE IF EXISTS `ezc_stock_movement_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_stock_movement_log` (
  `ESM_PART_ID` varchar(18) NOT NULL,
  `ESM_UOM_SKU` varchar(10) DEFAULT NULL,
  `ESM_DATE` datetime NOT NULL,
  `ESM_QTY` decimal(18,0) DEFAULT NULL,
  `ESM_FROM` varchar(6) DEFAULT NULL,
  `ESM_TO` varchar(6) DEFAULT NULL,
  `ESM_MOVED_BY` varchar(10) DEFAULT NULL,
  `ESM_AUTHORIZED_BY` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_stockinfo`
--

DROP TABLE IF EXISTS `ezc_stockinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_stockinfo` (
  `EZS_INVSTMTID` decimal(12,0) NOT NULL,
  `EZS_USERID` varchar(10) DEFAULT NULL,
  `EZS_PRODUCT` varchar(18) DEFAULT NULL,
  `EZS_PACK` varchar(5) DEFAULT NULL,
  `EZS_MONTH` varchar(12) DEFAULT NULL,
  `EZS_YEAR` decimal(4,0) DEFAULT NULL,
  `EZS_OPENBAL` decimal(15,3) DEFAULT NULL,
  `EZS_RECEIPTS` decimal(15,3) DEFAULT NULL,
  `EZS_SALES` decimal(15,3) DEFAULT NULL,
  `EZS_CLOSEBAL` decimal(15,3) DEFAULT NULL,
  `EZS_INTRANSIT` decimal(15,3) DEFAULT NULL,
  `EZS_SALESADJ` decimal(15,3) DEFAULT NULL,
  `EZS_DEVOLUTION` decimal(15,3) DEFAULT NULL,
  `EZS_TEXT1` varchar(55) DEFAULT NULL,
  `EZS_TEXT2` varchar(55) DEFAULT NULL,
  `EZS_TEXT3` varchar(1500) DEFAULT NULL,
  `EZS_PRICE` decimal(12,2) DEFAULT NULL,
  `EZS_SYSKEY` varchar(18) NOT NULL,
  `EZS_SOLDTO` varchar(10) NOT NULL,
  `EZS_CREATE_DATE` datetime DEFAULT NULL,
  `EZS_RET_CO` decimal(15,3) DEFAULT NULL,
  `EZS_RET_MAR` decimal(15,3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_sys_admin_messges`
--

DROP TABLE IF EXISTS `ezc_sys_admin_messges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_sys_admin_messges` (
  `ESAM_CLIENT` decimal(3,0) NOT NULL,
  `ESAM_ADMIN_USER_ID` varchar(10) NOT NULL,
  `ESAM_MSG_ID` char(18) NOT NULL,
  `ESAM_MSG_TYPE` char(3) NOT NULL,
  `ESAM_PRIORITY_FLAG` char(3) DEFAULT NULL,
  `ESAM_MSG_HEADER` varchar(256) DEFAULT NULL,
  `ESAM_MSG_CONTENT1` varchar(256) DEFAULT NULL,
  `ESAM_MSG_CONTENT2` varchar(256) DEFAULT NULL,
  `ESAM_MSG_CONTENT3` varchar(256) DEFAULT NULL,
  `ESAM_MSG_CONTENT4` varchar(256) DEFAULT NULL,
  `ESAM_LNK_EXT_INFO` varchar(32) DEFAULT NULL,
  `ESAM_CREATION_DATE` char(10) DEFAULT NULL,
  `ESAM_CREATION_TIME` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ESAM_CLIENT`,`ESAM_ADMIN_USER_ID`,`ESAM_MSG_ID`,`ESAM_MSG_TYPE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_system_auth`
--

DROP TABLE IF EXISTS `ezc_system_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_system_auth` (
  `ESA_SYS_NO` decimal(3,0) NOT NULL,
  `ESA_AUTH_KEY` varchar(128) NOT NULL,
  `ESA_AUTH_VALUE` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`ESA_SYS_NO`,`ESA_AUTH_KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_system_defaults`
--

DROP TABLE IF EXISTS `ezc_system_defaults`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_system_defaults` (
  `ESD_SYS_NO` decimal(3,0) NOT NULL,
  `ESD_KEY` varchar(10) DEFAULT NULL,
  `ESD_VALUE` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`ESD_SYS_NO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_system_desc`
--

DROP TABLE IF EXISTS `ezc_system_desc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_system_desc` (
  `ESD_SYS_NO` decimal(3,0) NOT NULL,
  `ESD_LANG` char(2) NOT NULL,
  `ESD_SYS_DESC` varchar(128) DEFAULT NULL,
  `ESD_SYS_TYPE` decimal(4,0) NOT NULL,
  PRIMARY KEY (`ESD_SYS_NO`,`ESD_LANG`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_system_group_link`
--

DROP TABLE IF EXISTS `ezc_system_group_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_system_group_link` (
  `ESGL_GROUP_ID` decimal(3,0) NOT NULL,
  `ESGL_SYS_NO` decimal(3,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_system_key_desc`
--

DROP TABLE IF EXISTS `ezc_system_key_desc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_system_key_desc` (
  `ESKD_SYS_KEY` varchar(18) NOT NULL,
  `ESKD_LANG` char(2) NOT NULL,
  `ESKD_SYS_KEY_DESC` varchar(128) DEFAULT NULL,
  `ESKD_SUPP_CUST_FLAG` char(1) DEFAULT NULL,
  `ESKD_SYNC_FLAG` char(1) DEFAULT NULL,
  `ESKD_SYS_NO` decimal(6,0) DEFAULT NULL,
  PRIMARY KEY (`ESKD_SYS_KEY`,`ESKD_LANG`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_system_transaction_link`
--

DROP TABLE IF EXISTS `ezc_system_transaction_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_system_transaction_link` (
  `ESTL_SYS_NO` decimal(3,0) NOT NULL,
  `ESTL_TRANSACTION` varchar(30) DEFAULT NULL,
  `ESTL_AUDIT_FLAG` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_system_type_defaults`
--

DROP TABLE IF EXISTS `ezc_system_type_defaults`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_system_type_defaults` (
  `ESTD_SYS_TYPE` decimal(4,0) NOT NULL,
  `ESTD_LANG` char(2) NOT NULL,
  `ESTD_DEFAULT_KEY` varchar(16) NOT NULL,
  `ESTD_DEFAULT_TYPE` char(1) NOT NULL,
  `ESTD_DEFAULT_DESC` varchar(128) NOT NULL,
  `ESTD_SUPP_CUST_FLAG` char(1) NOT NULL,
  PRIMARY KEY (`ESTD_SYS_TYPE`,`ESTD_DEFAULT_KEY`,`ESTD_SUPP_CUST_FLAG`,`ESTD_LANG`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_system_types`
--

DROP TABLE IF EXISTS `ezc_system_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_system_types` (
  `EST_SYS_TYPE` decimal(4,0) NOT NULL,
  `EST_LANG` char(2) NOT NULL,
  `EST_DESC` varchar(128) DEFAULT NULL,
  `EST_VERSION` varchar(6) DEFAULT NULL,
  PRIMARY KEY (`EST_SYS_TYPE`,`EST_LANG`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_transaction_table_link`
--

DROP TABLE IF EXISTS `ezc_transaction_table_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_transaction_table_link` (
  `ETTL_SYS_NO` decimal(3,0) NOT NULL,
  `ETTL_TRANSACTION` varchar(30) NOT NULL,
  `ETTL_TABLE_NAME` varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_trax_messages`
--

DROP TABLE IF EXISTS `ezc_trax_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_trax_messages` (
  `ETM_CLIENT` decimal(3,0) NOT NULL,
  `ETM_TRAN_ID` varchar(18) NOT NULL,
  `ETM_MSG_ID` char(18) NOT NULL,
  `ETM_MSG_TYPE` char(3) NOT NULL,
  `ETM_USER_ID` varchar(10) NOT NULL,
  `ETM_FOLDER_ID` decimal(9,0) DEFAULT NULL,
  `ETM_PRIORITY_FLAG` char(3) DEFAULT NULL,
  `ETM_PROCESS_TIME` char(20) DEFAULT NULL,
  `ETM_IS_PROCESSED` char(1) DEFAULT NULL,
  `ETM_MSG_STATUS` char(1) DEFAULT NULL,
  `ETM_MSG_HEADER` varchar(256) DEFAULT NULL,
  `ETM_MSG_CONTENT1` varchar(2000) DEFAULT NULL,
  `ETM_LNK_EXT_INFO` varchar(256) DEFAULT NULL,
  `ETM_CREATION_DATE` char(10) DEFAULT NULL,
  `ETM_CREATION_TIME` varchar(20) DEFAULT NULL,
  `ETM_CREATED_BY` char(10) DEFAULT NULL,
  `ETM_PROCESSED_DATE` char(10) DEFAULT NULL,
  `ETM_PROCESSED_TIME` varchar(20) DEFAULT NULL,
  `ETM_SYS_NO` decimal(6,0) DEFAULT NULL,
  `ETM_CAT_AREA` varchar(18) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_units`
--

DROP TABLE IF EXISTS `ezc_units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_units` (
  `EUNI_UNIT_CODE` char(3) NOT NULL,
  `EUNI_BASIC_TYPE` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_upload_docs`
--

DROP TABLE IF EXISTS `ezc_upload_docs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_upload_docs` (
  `EUD_UPLOAD_NO` decimal(6,0) NOT NULL,
  `EUD_SYSKEY` varchar(6) DEFAULT NULL,
  `EUD_OBJECT_TYPE` varchar(10) DEFAULT NULL,
  `EUD_OBJECT_NO` varchar(20) DEFAULT NULL,
  `EUD_STATUS` varchar(16) DEFAULT NULL,
  `EUD_CREATED_ON` datetime DEFAULT NULL,
  `EUD_CREATED_BY` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`EUD_UPLOAD_NO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_upload_document`
--

DROP TABLE IF EXISTS `ezc_upload_document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_upload_document` (
  `EUD_DOC_NO` varchar(15) NOT NULL,
  `EUD_ITEM_NO` varchar(10) NOT NULL,
  `EUD_DOC_TYPE` varchar(100) NOT NULL,
  `EUD_FILE_NAME` varchar(255) NOT NULL,
  `EUD_SERVER_FILE_NAME` varchar(255) DEFAULT NULL,
  `EUD_EXT1` varchar(100) DEFAULT NULL,
  `EUD_EXT2` varchar(100) DEFAULT NULL,
  `EUD_EXT3` varchar(200) DEFAULT NULL,
  `EUD_EXT4` varchar(200) DEFAULT NULL,
  `EUD_EXT5` varchar(200) DEFAULT NULL,
  `EUD_UPLOADED_ON` date DEFAULT NULL,
  `EUD_UPLOADED_BY` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`EUD_DOC_NO`,`EUD_ITEM_NO`,`EUD_DOC_TYPE`,`EUD_FILE_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_upload_files`
--

DROP TABLE IF EXISTS `ezc_upload_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_upload_files` (
  `EUF_DOC_ID` varchar(11) DEFAULT NULL,
  `EUF_ATTACHED_BY` varchar(10) DEFAULT NULL,
  `EUF_ATTACHED_DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `EUF_FILE_DESCRTIPTION` varchar(100) DEFAULT NULL,
  `EUF_CLIENT_FILE_NAME` varchar(100) DEFAULT NULL,
  `EUF_SERVER_FILE_NAME` varchar(800) DEFAULT NULL,
  `EUF_EXT1` varchar(100) DEFAULT NULL,
  `EUF_EXT2` varchar(500) DEFAULT NULL,
  `EUF_EXT3` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_uploaddoc_files`
--

DROP TABLE IF EXISTS `ezc_uploaddoc_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_uploaddoc_files` (
  `EUF_UPLOAD_NO` decimal(6,0) DEFAULT NULL,
  `EUF_TYPE` varchar(20) DEFAULT NULL,
  `EUF_CLIENT_FILE_NAME` varchar(100) DEFAULT NULL,
  `EUF_SERVER_FILE_NAME` varchar(200) DEFAULT NULL,
  KEY `EZC_UPLOADDOC_FILES_FK2` (`EUF_UPLOAD_NO`),
  CONSTRAINT `EZC_UPLOADDOC_FILES_FK2` FOREIGN KEY (`EUF_UPLOAD_NO`) REFERENCES `ezc_upload_docs` (`EUD_UPLOAD_NO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_user_auth`
--

DROP TABLE IF EXISTS `ezc_user_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_user_auth` (
  `EUA_USER_ID` char(10) NOT NULL,
  `EUA_SYS_NO` decimal(3,0) NOT NULL,
  `EUA_AUTH_KEY` varchar(16) NOT NULL,
  `EUA_AUTH_VALUE` varchar(128) DEFAULT NULL,
  `EUA_ROLE_OR_AUTH` char(1) DEFAULT NULL,
  PRIMARY KEY (`EUA_USER_ID`,`EUA_SYS_NO`,`EUA_AUTH_KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_user_def_key_values`
--

DROP TABLE IF EXISTS `ezc_user_def_key_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_user_def_key_values` (
  `EUDKV_USER_ID` varchar(20) NOT NULL,
  `EUDKV_SYS_KEY` varchar(6) NOT NULL,
  `EUDKV_KEY` varchar(10) NOT NULL,
  `EUDKV_VALUE` varchar(20) NOT NULL,
  `EUDKV_EXT1` varchar(15) DEFAULT NULL,
  `EUDKV_EXT2` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`EUDKV_USER_ID`,`EUDKV_SYS_KEY`,`EUDKV_KEY`,`EUDKV_VALUE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_user_def_key_values_temp`
--

DROP TABLE IF EXISTS `ezc_user_def_key_values_temp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_user_def_key_values_temp` (
  `EUDKV_USER_ID` varchar(20) NOT NULL,
  `EUDKV_SYS_KEY` varchar(6) NOT NULL,
  `EUDKV_KEY` varchar(10) NOT NULL,
  `EUDKV_VALUE` varchar(20) NOT NULL,
  `EUDKV_EXT1` varchar(15) DEFAULT NULL,
  `EUDKV_EXT2` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`EUDKV_USER_ID`,`EUDKV_SYS_KEY`,`EUDKV_KEY`,`EUDKV_VALUE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_user_defaults`
--

DROP TABLE IF EXISTS `ezc_user_defaults`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_user_defaults` (
  `EUD_USER_ID` char(10) NOT NULL,
  `EUD_SYS_KEY` varchar(18) NOT NULL,
  `EUD_CUST_NO` char(10) DEFAULT NULL,
  `EUD_KEY` varchar(16) NOT NULL,
  `EUD_VALUE` varchar(500) DEFAULT NULL,
  `EUD_DEFAULT_FLAG` char(1) DEFAULT NULL,
  `EUD_IS_USERA_KEY` char(1) DEFAULT NULL,
  UNIQUE KEY `EZC_USER_DEFAULTS_U1` (`EUD_USER_ID`,`EUD_SYS_KEY`,`EUD_KEY`,`EUD_VALUE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_user_groups`
--

DROP TABLE IF EXISTS `ezc_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_user_groups` (
  `EUG_ID` decimal(3,0) NOT NULL,
  `EUG_SYS_NO` decimal(3,0) NOT NULL,
  `EUG_NAME` varchar(60) NOT NULL,
  `EUG_VALIDATION_TYPE` decimal(1,0) NOT NULL,
  `EUG_CONNECT_TYPE` decimal(1,0) NOT NULL,
  `EUG_HISTORY_READ` decimal(1,0) NOT NULL,
  `EUG_MATERIAL_ACCESS` decimal(1,0) NOT NULL,
  `EUG_CUST_INFO_ACCESS` decimal(1,0) NOT NULL,
  `EUG_DB_MEM_CACHE` decimal(1,0) NOT NULL,
  `EUG_DATA_SYNC_TYPE` decimal(1,0) NOT NULL,
  `EUG_HISTORY_WRITE` decimal(1,0) NOT NULL,
  `EUG_R3_HOST` varchar(75) DEFAULT NULL,
  `EUG_R3_SYS_NO` decimal(3,0) NOT NULL,
  `EUG_R3_GATEWAY_HOST` varchar(32) DEFAULT NULL,
  `EUG_R3_SYS_NAME` varchar(128) DEFAULT NULL,
  `EUG_R3_GROUP_NAME` varchar(64) DEFAULT NULL,
  `EUG_R3_MSG_SERVER` varchar(64) DEFAULT NULL,
  `EUG_R3_LOAD_BALANCE` char(1) DEFAULT NULL,
  `EUG_R3_CHECK_AUTH` char(1) DEFAULT NULL,
  `EUG_R3_CODE_PAGE` decimal(4,0) DEFAULT NULL,
  `EUG_R3_LANG` char(2) NOT NULL,
  `EUG_R3_CLIENT` char(3) NOT NULL,
  `EUG_R3_USER_ID` varchar(16) NOT NULL,
  `EUG_R3_PASSWD` varchar(16) NOT NULL,
  `EUG_R3_NO_OF_CONN` decimal(3,0) DEFAULT NULL,
  `EUG_DB_NO_OF_CONN` decimal(3,0) DEFAULT NULL,
  `EUG_R3_NO_OF_RETRY` decimal(3,0) DEFAULT NULL,
  `EUG_DB_NO_OF_RETRY` decimal(3,0) DEFAULT NULL,
  `EUG_TRANSACTION_AUTO_RETRY` decimal(3,0) DEFAULT NULL,
  `EUG_CONN_LOG` char(1) DEFAULT NULL,
  `EUG_AUTO_CORRECTION_YESNO` char(1) DEFAULT NULL,
  `EUG_LOGSIZE` decimal(3,0) DEFAULT NULL,
  `EUG_LOGFILE_PATH` varchar(40) DEFAULT NULL,
  `EUG_XML_EXCHANGE_PATH` varchar(40) DEFAULT NULL,
  `EUG_CONN_EXIST` char(1) DEFAULT NULL,
  PRIMARY KEY (`EUG_ID`,`EUG_SYS_NO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_user_plants`
--

DROP TABLE IF EXISTS `ezc_user_plants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_user_plants` (
  `EUP_USER` varchar(20) NOT NULL,
  `EUP_PLANT` varchar(5) NOT NULL,
  `EUP_PURORG` varchar(5) NOT NULL,
  `EUP_SYSKEY` varchar(6) NOT NULL,
  `EUP_EXT1` varchar(10) DEFAULT NULL,
  `EUP_EXT2` varchar(10) DEFAULT NULL,
  `EUP_EXT3` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`EUP_USER`,`EUP_PLANT`,`EUP_PURORG`,`EUP_SYSKEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_user_product_favorites`
--

DROP TABLE IF EXISTS `ezc_user_product_favorites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_user_product_favorites` (
  `EPF_USER_ID` char(10) NOT NULL,
  `EPF_SYS_KEY` varchar(18) NOT NULL,
  `EPF_FAVOURITE_GROUP` varchar(18) NOT NULL,
  `EPF_MAT_NO` varchar(18) NOT NULL,
  `EPF_PRODUCT_SEQUENCE` decimal(10,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_user_product_group_fav`
--

DROP TABLE IF EXISTS `ezc_user_product_group_fav`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_user_product_group_fav` (
  `EPGF_USER_ID` varchar(10) NOT NULL,
  `EPGF_SYS_NO` decimal(3,0) NOT NULL,
  `EPGF_PRODUCT_GROUP` varchar(18) NOT NULL,
  `EPGF_PRODUCT_GROUP_SEQUENCE` decimal(10,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_user_roles`
--

DROP TABLE IF EXISTS `ezc_user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_user_roles` (
  `EUR_ROLE_NR` varchar(16) NOT NULL,
  `EUR_ROLE_TYPE` char(1) DEFAULT NULL,
  `EUR_LANGUAGE` char(2) NOT NULL,
  `EUR_ROLE_DESCRIPTION` varchar(30) DEFAULT NULL,
  `EUR_DELETED_FLAG` char(1) DEFAULT NULL,
  `EUR_COMPONENT` varchar(20) DEFAULT NULL,
  `EUR_BUS_DOMAIN` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EUR_ROLE_NR`,`EUR_LANGUAGE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_users`
--

DROP TABLE IF EXISTS `ezc_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_users` (
  `EU_ID` char(10) NOT NULL,
  `EU_DELETION_FLAG` char(1) NOT NULL,
  `EU_FIRST_NAME` varchar(60) NOT NULL,
  `EU_MIDDLE_INITIAL` varchar(3) DEFAULT NULL,
  `EU_LAST_NAME` varchar(60) NOT NULL,
  `EU_EMAIL` varchar(200) DEFAULT NULL,
  `EU_CREATED_DATE` char(10) DEFAULT NULL,
  `EU_CHANGED_DATE` char(10) DEFAULT NULL,
  `EU_CHANGED_BY` char(10) DEFAULT NULL,
  `EU_VALID_TO_DATE` char(10) DEFAULT NULL,
  `EU_LAST_LOGIN_TIME` char(20) DEFAULT NULL,
  `EU_LAST_LOGIN_DATE` char(10) DEFAULT NULL,
  `EU_PASSWORD` varchar(512) NOT NULL,
  `EU_TYPE` decimal(1,0) NOT NULL,
  `EUG_ID` decimal(3,0) NOT NULL,
  `EU_BUSINESS_PARTNER` char(10) NOT NULL,
  `EU_IS_BUILT_IN_USER` char(1) DEFAULT NULL,
  `EU_CURRENT_NUMBER` decimal(10,0) DEFAULT NULL,
  `EU_CONTACT_NO` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`EU_ID`,`EU_DELETION_FLAG`),
  UNIQUE KEY `EZC_USERS_U1` (`EU_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_value_mapping`
--

DROP TABLE IF EXISTS `ezc_value_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_value_mapping` (
  `MAP_TYPE` varchar(20) NOT NULL,
  `VALUE1` varchar(50) NOT NULL,
  `VALUE2` varchar(500) NOT NULL,
  PRIMARY KEY (`MAP_TYPE`,`VALUE1`,`VALUE2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_vend_bank_details`
--

DROP TABLE IF EXISTS `ezc_vend_bank_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_vend_bank_details` (
  `EVBD_DOC_ID` varchar(10) NOT NULL,
  `EVBD_VENDOR` varchar(10) NOT NULL,
  `EVBD_ACCOUNT_NUM` varchar(18) NOT NULL,
  `EVBD_ACCOUNT_NAME` varchar(25) DEFAULT NULL,
  `EVBD_COUNTRY_KEY` varchar(3) DEFAULT NULL,
  `EVBD_KEY` varchar(15) DEFAULT NULL,
  `EVBD_VALID_FROM` datetime DEFAULT NULL,
  `EVBD_VALID_TO` datetime DEFAULT NULL,
  `EVBD_IS_DELETE` varchar(1) DEFAULT NULL,
  `EVBD_SERIAL_NO` varchar(10) DEFAULT NULL,
  `EVBD_EXT1` varchar(100) DEFAULT NULL,
  `EVBD_EXT2` varchar(100) DEFAULT NULL,
  `EVBD_EXT3` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`EVBD_DOC_ID`,`EVBD_VENDOR`,`EVBD_ACCOUNT_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_vend_company_data`
--

DROP TABLE IF EXISTS `ezc_vend_company_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_vend_company_data` (
  `EVCD_DOC_ID` varchar(10) NOT NULL,
  `EVCD_VENDOR` varchar(10) NOT NULL,
  `EVCD_COMP_CODE` varchar(4) NOT NULL,
  `EVCD_MINORITY_IND` varchar(3) DEFAULT NULL,
  `EVCD_PAY_TERMS` varchar(4) DEFAULT NULL,
  `EVCD_HOUSE_BANK` varchar(5) DEFAULT NULL,
  `EVCD_CREATION_DATE` datetime DEFAULT NULL,
  `EVCD_PAY_METHOD` varchar(10) DEFAULT NULL,
  `EVCD_SCHEMA_GROUP` varchar(2) DEFAULT NULL,
  `EVCD_CERTIFICATE_DATE` varchar(10) DEFAULT NULL,
  `EVCD_DOCUMENT_STR` varchar(20) DEFAULT NULL,
  `EVCD_EXT1` varchar(200) DEFAULT NULL,
  `EVCD_EXT2` varchar(100) DEFAULT NULL,
  `EVCD_EXT3` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`EVCD_DOC_ID`,`EVCD_VENDOR`,`EVCD_COMP_CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_vend_contact_person`
--

DROP TABLE IF EXISTS `ezc_vend_contact_person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_vend_contact_person` (
  `EVCP_DOC_ID` varchar(10) NOT NULL,
  `EVCP_VENDOR` varchar(10) NOT NULL,
  `EVCP_CONTACT_PERSSON` varchar(35) NOT NULL,
  `EVCP_EXT1` varchar(30) DEFAULT NULL,
  `EVCP_EXT2` varchar(100) DEFAULT NULL,
  `EVCP_EXT3` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`EVCP_DOC_ID`,`EVCP_VENDOR`,`EVCP_CONTACT_PERSSON`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_vend_emals`
--

DROP TABLE IF EXISTS `ezc_vend_emals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_vend_emals` (
  `EVE_DOC_ID` varchar(10) NOT NULL,
  `EVE_VENDOR` varchar(10) NOT NULL,
  `EVE_ADDR_NR` varchar(10) NOT NULL,
  `EVE_EMAIL` varchar(241) NOT NULL,
  PRIMARY KEY (`EVE_DOC_ID`,`EVE_VENDOR`,`EVE_ADDR_NR`,`EVE_EMAIL`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_vend_excise_data`
--

DROP TABLE IF EXISTS `ezc_vend_excise_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_vend_excise_data` (
  `EVED_DOC_ID` varchar(10) NOT NULL,
  `EVED_VENDOR` varchar(10) NOT NULL,
  `EVED_SRV_TAX` varchar(40) NOT NULL,
  `EVED_EXC_REG_NO` varchar(40) DEFAULT NULL,
  `EVED_EXC_DIV` varchar(60) DEFAULT NULL,
  `EVED_VAT` varchar(40) DEFAULT NULL,
  `EVED_CST` varchar(40) DEFAULT NULL,
  `EVED_ECC_NO` varchar(40) DEFAULT NULL,
  `EVED_EX_RANGE` varchar(60) DEFAULT NULL,
  `EVED_EX_COMM` varchar(60) DEFAULT NULL,
  `EVED_PAN_NO` varchar(40) DEFAULT NULL,
  `EVED_VEND_TYPE` varchar(5) DEFAULT NULL,
  `EVED_MINORITY_IND` varchar(2) DEFAULT NULL,
  `EVED_GST` varchar(15) DEFAULT NULL,
  `EVED_CLASSIFICATION` varchar(2) DEFAULT NULL,
  `EVED_CERTIFICATE_DATE` datetime DEFAULT NULL,
  PRIMARY KEY (`EVED_DOC_ID`,`EVED_VENDOR`,`EVED_SRV_TAX`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_vend_fax`
--

DROP TABLE IF EXISTS `ezc_vend_fax`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_vend_fax` (
  `EVF_DOC_ID` varchar(10) NOT NULL,
  `EVF_VENDOR` varchar(10) NOT NULL,
  `EVF_ADDR_NR` varchar(10) NOT NULL,
  `EVF_FAX` varchar(30) NOT NULL,
  `EVF_FAX_EXTENS` varchar(10) DEFAULT NULL,
  `EVF_COUNTRY` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`EVF_DOC_ID`,`EVF_VENDOR`,`EVF_ADDR_NR`,`EVF_FAX`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_vend_gen_data`
--

DROP TABLE IF EXISTS `ezc_vend_gen_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_vend_gen_data` (
  `EVGD_VENDOR` varchar(10) NOT NULL,
  `EVGD_CREATED_ON` datetime DEFAULT NULL,
  `EVGD_DEL_FLAG` varchar(1) DEFAULT NULL,
  `EVGD_BLOCK_FLAG` varchar(1) DEFAULT NULL,
  `EVGD_INDR_KEY` varchar(4) DEFAULT NULL,
  `EVGD_TITLE` varchar(15) DEFAULT NULL,
  `EVGD_NAME` varchar(35) DEFAULT NULL,
  `EVGD_NAME1` varchar(35) DEFAULT NULL,
  `EVGD_NAME2` varchar(35) DEFAULT NULL,
  `EVGD_NAME3` varchar(35) DEFAULT NULL,
  `EVGD_NAME4` varchar(35) DEFAULT NULL,
  `EVGD_ADDR1` varchar(40) DEFAULT NULL,
  `EVGD_ADDR2` varchar(40) DEFAULT NULL,
  `EVGD_ADDR3` varchar(40) DEFAULT NULL,
  `EVGD_ADDR4` varchar(40) DEFAULT NULL,
  `EVGD_CITY` varchar(40) DEFAULT NULL,
  `EVGD_DISTRICT` varchar(40) DEFAULT NULL,
  `EVGD_POSTAL_CODE` varchar(10) DEFAULT NULL,
  `EVGD_REGION` varchar(3) DEFAULT NULL,
  `EVGD_COUNTRY` varchar(3) DEFAULT NULL,
  `EVGD_ACC_GROUP` varchar(4) DEFAULT NULL,
  `EVGD_TELEPHONE1` varchar(16) DEFAULT NULL,
  `EVGD_TELEPHONE2` varchar(16) DEFAULT NULL,
  `EVGD_MOBILE` varchar(16) DEFAULT NULL,
  `EVGD_FAX` varchar(16) DEFAULT NULL,
  `EVGD_EMAIL` varchar(241) DEFAULT NULL,
  `EVCD_GST_NO` varchar(40) DEFAULT NULL,
  `EVCD_PAN_NO` varchar(40) DEFAULT NULL,
  `EVCD_CURRENCY` varchar(5) DEFAULT NULL,
  `EVGD_VEN_CLASS` varchar(1) DEFAULT NULL,
  `EVGD_TAX_JUTIS` varchar(15) DEFAULT NULL,
  `EVGD_CUSTOMER_NO` varchar(10) DEFAULT NULL,
  `EVGD_EXT1` varchar(20) DEFAULT NULL,
  `EVGD_EXT2` varchar(20) DEFAULT NULL,
  `EVGD_EXT3` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EVGD_VENDOR`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_vend_general_data`
--

DROP TABLE IF EXISTS `ezc_vend_general_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_vend_general_data` (
  `EVGD_DOC_ID` varchar(10) NOT NULL,
  `EVGD_VENDOR` varchar(10) NOT NULL,
  `EVGD_ACC_GRP` varchar(4) DEFAULT NULL,
  `EVGD_TITLE` char(15) DEFAULT NULL,
  `EVGD_VEND_TYPE` char(5) DEFAULT NULL,
  `EVGD_STATUS` char(15) DEFAULT NULL,
  `EVGD_NAME1` varchar(35) DEFAULT NULL,
  `EVGD_NAME2` varchar(35) DEFAULT NULL,
  `EVGD_NAME3` varchar(35) DEFAULT NULL,
  `EVGD_NAME4` varchar(35) DEFAULT NULL,
  `EVGD_STREET` varchar(60) DEFAULT NULL,
  `EVGD_HOUSE_NUM` varchar(10) DEFAULT NULL,
  `EVGD_CITY` varchar(35) DEFAULT NULL,
  `EVGD_DISTRICT` varchar(35) DEFAULT NULL,
  `EVGD_STATE` varchar(3) DEFAULT NULL,
  `EVGD_COUNTRY` varchar(3) DEFAULT NULL,
  `EVGD_PIN` varchar(10) DEFAULT NULL,
  `EVGD_LANDLINE` varchar(16) DEFAULT NULL,
  `EVGD_FAX` varchar(31) DEFAULT NULL,
  `EVGD_MOBILE` varchar(16) DEFAULT NULL,
  `EVGD_EMAIL` varchar(241) DEFAULT NULL,
  `EVGD_ADDR_NR` varchar(10) DEFAULT NULL,
  `EVGD_MODIFIED_BY` varchar(15) DEFAULT NULL,
  `EVGD_MODIFIED_ON` datetime DEFAULT NULL,
  `EVGD_SEARCH_TERM` varchar(20) DEFAULT NULL,
  `EVGD_PURPOSE` varchar(200) DEFAULT NULL,
  `EVGD_PAYMENT_METHOD` varchar(1) DEFAULT NULL,
  `EVGD_RECON_ACCOUNT` varchar(10) DEFAULT NULL,
  `EVGD_DOCUMENT_STR` varchar(20) DEFAULT NULL,
  `EVGD_EXT1` varchar(100) DEFAULT NULL,
  `EVGD_EXT2` varchar(200) DEFAULT NULL,
  `EVGD_EXT3` varchar(50) DEFAULT NULL,
  `EVGD_SAP_VENDOR` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`EVGD_DOC_ID`,`EVGD_VENDOR`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_vend_partners`
--

DROP TABLE IF EXISTS `ezc_vend_partners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_vend_partners` (
  `EVP_DOC_ID` varchar(10) NOT NULL,
  `EVP_VENDOR` varchar(10) NOT NULL,
  `EVP_PUR_ORG` varchar(4) NOT NULL,
  `EVP_PLANT` varchar(4) NOT NULL,
  `EVP_PARTNER_FUN` varchar(2) DEFAULT NULL,
  `EVP_PARTNER_NUM` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`EVP_DOC_ID`,`EVP_VENDOR`,`EVP_PUR_ORG`,`EVP_PLANT`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_vend_pur_org_data`
--

DROP TABLE IF EXISTS `ezc_vend_pur_org_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_vend_pur_org_data` (
  `EVPOD_DOC_ID` varchar(10) NOT NULL,
  `EVPOD_VENDOR` varchar(10) NOT NULL,
  `EVPOD_PUR_ORG` varchar(4) NOT NULL,
  `EVPOD_GR_INV_IND` char(1) DEFAULT NULL,
  `EVPOD_SRV_INV_IND` char(1) DEFAULT NULL,
  `EVPOD_CURRENCY` char(5) DEFAULT NULL,
  PRIMARY KEY (`EVPOD_DOC_ID`,`EVPOD_VENDOR`,`EVPOD_PUR_ORG`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_vend_telephones`
--

DROP TABLE IF EXISTS `ezc_vend_telephones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_vend_telephones` (
  `EVT_DOC_ID` varchar(10) NOT NULL,
  `EVT_VENDOR` varchar(10) NOT NULL,
  `EVT_ADDR_NR` varchar(10) NOT NULL,
  `EVT_TELE_PH` varchar(30) NOT NULL,
  `EVT_TELE_EXTENS` varchar(10) DEFAULT NULL,
  `EVT_COUNTRY` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`EVT_DOC_ID`,`EVT_VENDOR`,`EVT_ADDR_NR`,`EVT_TELE_PH`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_vendor_confirmation`
--

DROP TABLE IF EXISTS `ezc_vendor_confirmation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_vendor_confirmation` (
  `EVC_VENDOR` varchar(10) NOT NULL,
  `EVC_IS_CONFIRMED` varchar(3) NOT NULL,
  `EVC_CONFIRMED_ON` datetime NOT NULL,
  `EVC_EXT1` varchar(100) DEFAULT NULL,
  `EVC_EXT2` varchar(500) DEFAULT NULL,
  `EVC_EXT3` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`EVC_VENDOR`,`EVC_IS_CONFIRMED`,`EVC_CONFIRMED_ON`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_vendor_creation_workflow`
--

DROP TABLE IF EXISTS `ezc_vendor_creation_workflow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_vendor_creation_workflow` (
  `EVCW_KEY` varchar(50) DEFAULT NULL,
  `EVCW_STEP` varchar(5) DEFAULT NULL,
  `EVCW_PARTICIPANT` varchar(50) DEFAULT NULL,
  `EVCW_EXT1` varchar(100) DEFAULT NULL,
  `EVCW_EXT2` varchar(100) DEFAULT NULL,
  `EVCW_EXT3` varchar(100) DEFAULT NULL,
  `EVCW_EXT4` varchar(100) DEFAULT NULL,
  `EVCW_EXT5` varchar(100) DEFAULT NULL,
  `EVCW_AREA` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_vendor_profile`
--

DROP TABLE IF EXISTS `ezc_vendor_profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_vendor_profile` (
  `EZVP_SOLDTO` varchar(10) NOT NULL,
  `EZVP_SYSKEY` varchar(18) NOT NULL,
  `EZVP_CONTACT_PERSON` varchar(64) DEFAULT NULL,
  `EZVP_DESIGNATION` varchar(64) DEFAULT NULL,
  `EZVP_PHONE1` varchar(20) DEFAULT NULL,
  `EZVP_PHONE2` varchar(20) DEFAULT NULL,
  `EZVP_FAX` varchar(20) DEFAULT NULL,
  `EZVP_EMAIL` varchar(64) DEFAULT NULL,
  `EZVP_SALETAX_REGN` varchar(64) DEFAULT NULL,
  `EZVP_CEXCISE_REGN` varchar(64) DEFAULT NULL,
  `EZVP_DRUGLIC_NO` varchar(64) DEFAULT NULL,
  `EZVP_DMF_NO` varchar(64) DEFAULT NULL,
  `EZVP_PROD_CAPACITY` varchar(64) DEFAULT NULL,
  `EZVP_TURNOVER` varchar(64) DEFAULT NULL,
  `EZVP_MS1_ADDR_ID` decimal(6,0) DEFAULT NULL,
  `EZVP_MS2_ADDR_ID` decimal(6,0) DEFAULT NULL,
  `EZVP_MS3_ADDR_ID` decimal(6,0) DEFAULT NULL,
  `EZVP_IS_COMP_DET` char(1) DEFAULT NULL,
  `EZVP_EXT1` varchar(10) DEFAULT NULL,
  `EZVP_EXT2` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`EZVP_SYSKEY`,`EZVP_SOLDTO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_vendor_questionnaire`
--

DROP TABLE IF EXISTS `ezc_vendor_questionnaire`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_vendor_questionnaire` (
  `EZVQ_MATERIAL_ID` decimal(6,0) NOT NULL,
  `EZVQ_SOLDTO` varchar(10) DEFAULT NULL,
  `EZVQ_SYSKEY` varchar(18) DEFAULT NULL,
  `EZVQ_MATERIAL_DESC` varchar(70) DEFAULT NULL,
  `EZVQ_COMPANY_ADDR_ID` decimal(6,0) DEFAULT NULL,
  `EZVQ_MKT_CONT_NAME` varchar(64) DEFAULT NULL,
  `EZVQ_MKT_CONT_DESIG` varchar(64) DEFAULT NULL,
  `EZVQ_MKT_CONT_PH1` varchar(20) DEFAULT NULL,
  `EZVQ_MKT_CONT_PH2` varchar(20) DEFAULT NULL,
  `EZVQ_MKT_CONT_FAX` varchar(20) DEFAULT NULL,
  `EZVQ_MKT_CONT_EMAIL` varchar(64) DEFAULT NULL,
  `EZVQ_QA_CONT_NAME` varchar(64) DEFAULT NULL,
  `EZVQ_QA_CONT_DESIG` varchar(64) DEFAULT NULL,
  `EZVQ_QA_CONT_PH1` varchar(20) DEFAULT NULL,
  `EZVQ_QA_CONT_PH2` varchar(20) DEFAULT NULL,
  `EZVQ_QA_CONT_FAX` varchar(20) DEFAULT NULL,
  `EZVQ_QA_CONT_EMAIL` varchar(64) DEFAULT NULL,
  `EZVQ_MFG_CAPACITY` varchar(64) DEFAULT NULL,
  `EZVQ_TOT_CAPACITY` varchar(64) DEFAULT NULL,
  `EZVQ_PCTG_SUPPLY` varchar(10) DEFAULT NULL,
  `EZVQ_IS_PRIME_MFR` char(1) DEFAULT NULL,
  `EZVQ_IS_OTHER_DET` char(1) DEFAULT NULL,
  `EZVQ_IS_CERTIFIED` char(1) DEFAULT NULL,
  `EZVQ_CERT_UPLOAD_ID` decimal(6,0) DEFAULT NULL,
  `EZVQ_ISO` char(1) DEFAULT NULL,
  `EZVQ_WHO` char(1) DEFAULT NULL,
  `EZVQ_GMP` char(1) DEFAULT NULL,
  `EZVQ_FDA` char(1) DEFAULT NULL,
  `EZVQ_OTHER` varchar(64) DEFAULT NULL,
  `EZVQ_EMP_TRAINING` char(1) DEFAULT NULL,
  `EZVQ_HOUSE_KEEPING` char(1) DEFAULT NULL,
  `EZVQ_EQ_DEDICATED` char(1) DEFAULT NULL,
  `EZVQ_EQ_MULTI_PUR` char(1) DEFAULT NULL,
  `EZVQ_EQ_WP_MAINT` char(1) DEFAULT NULL,
  `EZVQ_EQ_WP_CLEAN` char(1) DEFAULT NULL,
  `EZVQ_EQ_WP_CALIB` char(1) DEFAULT NULL,
  `EZVQ_EQ_ABV_DOC` char(1) DEFAULT NULL,
  `EZVQ_MFR_TSE_CERT` char(1) DEFAULT NULL,
  `EZVQ_MFR_IS_PENCILLINS` char(1) DEFAULT NULL,
  `EZVQ_MFR_IS_ST_OP_PROC` char(1) DEFAULT NULL,
  `EZVQ_MFR_IS_ABNORMAL` char(1) DEFAULT NULL,
  `EZVQ_QC_TESTPROC` char(1) DEFAULT NULL,
  `EZVQ_QC_SPECS` char(1) DEFAULT NULL,
  `EZVQ_QC_STAT_METHODS` char(1) DEFAULT NULL,
  `EZVQ_SHE_ISO_ADAPTED` char(1) DEFAULT NULL,
  `EZVQ_SHE_WATER_ACT` char(1) DEFAULT NULL,
  `EZVQ_SHE_AIR_ACT` char(1) DEFAULT NULL,
  `EZVQ_SHE_WASTE_MGMT` char(1) DEFAULT NULL,
  `EZVQ_MISC_TEST` char(1) DEFAULT NULL,
  `EZVQ_MISC_CERT` char(1) DEFAULT NULL,
  `EZVQ_MISC_SOP` char(1) DEFAULT NULL,
  `EZVQ_EXT1` varchar(10) DEFAULT NULL,
  `EZVQ_EXT2` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_vendor_reg_details`
--

DROP TABLE IF EXISTS `ezc_vendor_reg_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_vendor_reg_details` (
  `EVRD_ID` decimal(6,0) DEFAULT NULL,
  `EVRD_NAME` varchar(40) DEFAULT NULL,
  `EVRD_HOUSE_NO` varchar(20) DEFAULT NULL,
  `EVRD_POSTAL_CODE` varchar(10) DEFAULT NULL,
  `EVRD_ADDRESS_COUNTRY` varchar(5) DEFAULT NULL,
  `EVRD_REGION` varchar(5) DEFAULT NULL,
  `EVRD_TEL_NO` varchar(15) DEFAULT NULL,
  `EVRD_MOBILE_NO` varchar(15) DEFAULT NULL,
  `EVRD_FAX` varchar(15) DEFAULT NULL,
  `EVRD_EMAIL` varchar(50) DEFAULT NULL,
  `EVRD_ECC_NO` varchar(30) DEFAULT NULL,
  `EVRD_EXCISE_REG_NO` varchar(20) DEFAULT NULL,
  `EVRD_EXCISE_RANGE` varchar(20) DEFAULT NULL,
  `EVRD_EXCISE_DIV` varchar(20) DEFAULT NULL,
  `EVRD_PAN_NO` varchar(20) DEFAULT NULL,
  `EVRD_VAT_REG_NO` varchar(20) DEFAULT NULL,
  `EVRD_BANK_COUNTRY` varchar(20) DEFAULT NULL,
  `EVRD_BANK_KEY` varchar(20) DEFAULT NULL,
  `EVRD_BANK_ACCOUNT_NO` varchar(20) DEFAULT NULL,
  `EVRD_ACCOUNT_HOLDER` varchar(30) DEFAULT NULL,
  `EVRD_FIRST_NAME` varchar(30) DEFAULT NULL,
  `EVRD_SECOND_NAME` varchar(30) DEFAULT NULL,
  `EVRD_PERSONAL_TEL_NO` varchar(20) DEFAULT NULL,
  `EVRD_STATUS` varchar(30) DEFAULT NULL,
  `EVRD_CREATED_ON` date DEFAULT NULL,
  `EVRD_MODIFED_ON` date DEFAULT NULL,
  `EVRD_MODIFED_BY` varchar(20) DEFAULT NULL,
  `EVRD_EXT1` varchar(20) DEFAULT NULL,
  `EVRD_EXT2` varchar(20) DEFAULT NULL,
  `EVRD_EXT3` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_vendor_timestamp`
--

DROP TABLE IF EXISTS `ezc_vendor_timestamp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_vendor_timestamp` (
  `EZVT_AUTH_KEY` varchar(16) DEFAULT NULL,
  `EZVT_SYSKEY` varchar(18) DEFAULT NULL,
  `EZVT_SOLDTO` varchar(20) DEFAULT NULL,
  `EZVT_DOC_DATE` datetime DEFAULT NULL,
  `EZVT_EXT1` varchar(10) DEFAULT NULL,
  `EZVT_EXT2` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_view_history`
--

DROP TABLE IF EXISTS `ezc_view_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_view_history` (
  `EVH_CLIENT` decimal(8,0) NOT NULL,
  `EVH_MEG_ID` char(18) NOT NULL,
  `EVH_USER_ID` char(10) NOT NULL,
  `EVH_VIEW_DATE` char(10) DEFAULT NULL,
  `EVH_VIEW_TIME` char(20) DEFAULT NULL,
  `EVH_EXPIRY_DATE` char(10) DEFAULT NULL,
  `EVH_REMINDER_DATE` char(10) DEFAULT NULL,
  PRIMARY KEY (`EVH_CLIENT`,`EVH_MEG_ID`,`EVH_USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_warranty_header`
--

DROP TABLE IF EXISTS `ezc_warranty_header`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_warranty_header` (
  `EWH_WARRANTY_CODE` decimal(6,0) NOT NULL,
  `EWH_LANG` char(2) NOT NULL,
  `EWH_DESC` varchar(100) DEFAULT NULL,
  `EWH_SCHEDULE_CODE` decimal(6,0) DEFAULT NULL,
  `EWH_CONTRACT_TEMPLATE` decimal(6,0) DEFAULT NULL,
  `EWH_TERM_ID` decimal(6,0) DEFAULT NULL,
  `EWH_START_DATE` datetime DEFAULT NULL,
  `EWH_END_DATE` datetime DEFAULT NULL,
  `EWH_CURRENT_STATUS` decimal(6,0) DEFAULT NULL,
  `EWH_CUST_CODE` char(10) DEFAULT NULL,
  `EWH_CONTACT_PERSON` varchar(50) DEFAULT NULL,
  `EWH_CUST_ADD1` varchar(50) DEFAULT NULL,
  `EWH_CUST_ADD2` varchar(50) DEFAULT NULL,
  `EWH_CUST_ADD3` varchar(50) DEFAULT NULL,
  `EWH_CITY` varchar(64) DEFAULT NULL,
  `EWH_STATE` varchar(64) DEFAULT NULL,
  `EWH_COUNTRY` varchar(64) DEFAULT NULL,
  `EWH_ZIPCODE` varchar(10) DEFAULT NULL,
  `EWH_TELNO` varchar(30) DEFAULT NULL,
  `EWH_EMAIL` varchar(64) DEFAULT NULL,
  `EWH_WARRANTY_TEXT` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_warranty_template`
--

DROP TABLE IF EXISTS `ezc_warranty_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_warranty_template` (
  `EWT_WARRANTY_TEMPLATE_CODE` decimal(6,0) NOT NULL,
  `EWT_MODEL` varchar(20) DEFAULT NULL,
  `EWT_LANG` char(2) NOT NULL,
  `EWT_DESCRIPTION` varchar(50) DEFAULT NULL,
  `EWT_MAINTENANCE_TEMPLATE` decimal(6,0) DEFAULT NULL,
  `EWT_MAIN_TEMPLATE_VERSION` decimal(8,0) DEFAULT NULL,
  `EWT_DURATION` decimal(5,0) DEFAULT NULL,
  `EWT_DURATION_UNIT` varchar(10) DEFAULT NULL,
  `EWT_EFFECT_FROM` datetime DEFAULT NULL,
  `EWT_EXPIRES_ON` datetime DEFAULT NULL,
  `EWT_TERM_ID` decimal(6,0) DEFAULT NULL,
  `EWT_WARRANTY_TEXT` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_web_stats`
--

DROP TABLE IF EXISTS `ezc_web_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_web_stats` (
  `EWS_USER_ID` char(10) DEFAULT NULL,
  `EWS_SYSKEY` varchar(18) DEFAULT NULL,
  `EWS_SOLD_TO` varchar(18) DEFAULT NULL,
  `EWS_IP` varchar(15) DEFAULT NULL,
  `EWS_LOGGED_IN` datetime DEFAULT NULL,
  `EWS_LOGGED_OUT` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_wf_actions`
--

DROP TABLE IF EXISTS `ezc_wf_actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_wf_actions` (
  `EWA_CODE` decimal(6,0) NOT NULL,
  `EWA_LANG` char(2) DEFAULT NULL,
  `EWA_DESCRIPTION` varchar(255) DEFAULT NULL,
  `EWA_DIRECTION` varchar(6) DEFAULT NULL,
  `EWA_AVAILABILITY_CONDITION` varchar(255) DEFAULT NULL,
  `EWA_STATORACTION` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`EWA_CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_wf_audit_trail`
--

DROP TABLE IF EXISTS `ezc_wf_audit_trail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_wf_audit_trail` (
  `EWAT_AUDIT_NO` varchar(10) DEFAULT NULL,
  `EWAT_DOC_ID` varchar(10) DEFAULT NULL,
  `EWAT_TYPE` varchar(15) DEFAULT NULL,
  `EWAT_SOURCE_PARTICIPANT` varchar(20) DEFAULT NULL,
  `EWAT_SOURCE_PARTICIPANT_TYPE` char(1) DEFAULT NULL,
  `EWAT_DEST_PARTICIPANT` varchar(20) DEFAULT NULL,
  `EWAT_DEST_PARTICIPANT_TYPE` char(1) DEFAULT NULL,
  `EWAT_COMMENTS` varchar(500) DEFAULT NULL,
  `EWAT_DATE` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_wf_auditlog`
--

DROP TABLE IF EXISTS `ezc_wf_auditlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_wf_auditlog` (
  `EWA_DOC_NO` varchar(10) DEFAULT NULL,
  `EWA_DOC_CAT` varchar(10) DEFAULT NULL,
  `EWA_REJECT_PERIOD` decimal(5,0) DEFAULT NULL,
  `EWA_QUERY_PERIOD` decimal(5,0) DEFAULT NULL,
  `EWA_ELAPSED_PERIOD` decimal(5,0) DEFAULT NULL,
  `EWA_ACTION_ON` datetime DEFAULT NULL,
  `EWA_ACTION_BY` varchar(10) DEFAULT NULL,
  `EWA_AUDIT_NO` varchar(10) DEFAULT NULL,
  `EWA_LINE_TYPE` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_wf_defaults_map`
--

DROP TABLE IF EXISTS `ezc_wf_defaults_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_wf_defaults_map` (
  `EWDM_DEPT` varchar(10) NOT NULL,
  `EWDM_PLANT` varchar(5) NOT NULL,
  `EWDM_KEY` varchar(10) NOT NULL,
  `EWDM_VALUE` varchar(10) NOT NULL,
  PRIMARY KEY (`EWDM_DEPT`,`EWDM_PLANT`,`EWDM_KEY`,`EWDM_VALUE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_wf_delegation_conditions`
--

DROP TABLE IF EXISTS `ezc_wf_delegation_conditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_wf_delegation_conditions` (
  `EWDC_DELEGATION_ID` varchar(20) NOT NULL,
  `EWDC_CONDITION_ID` decimal(6,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_wf_delegation_info`
--

DROP TABLE IF EXISTS `ezc_wf_delegation_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_wf_delegation_info` (
  `EWDI_TEMPLATE_CODE` decimal(6,0) DEFAULT NULL,
  `EWDI_DELEGATION_ID` varchar(20) NOT NULL,
  `EWDI_DELEGATION_DESC` varchar(50) NOT NULL,
  `EWDI_SOURCE_PARTICIPANT` varchar(10) DEFAULT NULL,
  `EWDI_SOURCE_PARTICIPANT_TYPE` char(1) DEFAULT NULL,
  `EWDI_DEST_PARTICIPANT` varchar(10) DEFAULT NULL,
  `EWDI_DEST_PARTICIPANT_TYPE` char(1) DEFAULT NULL,
  `EWDI_VALID_FROM` datetime DEFAULT NULL,
  `EWDI_VALID_TO` datetime DEFAULT NULL,
  `EWDI_CONDITION_ID` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_wf_doc_history_details`
--

DROP TABLE IF EXISTS `ezc_wf_doc_history_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_wf_doc_history_details` (
  `EWDHD_KEY` decimal(9,0) DEFAULT NULL,
  `EWDHD_WF_STATUS` varchar(20) DEFAULT NULL,
  `EWDHD_WF_ACTION` decimal(6,0) DEFAULT NULL,
  `EWDHD_ACTION_ON` datetime DEFAULT NULL,
  `EWDHD_ACTION_BY` char(10) DEFAULT NULL,
  `EWDHD_THIS_STEP` decimal(6,0) DEFAULT NULL,
  `EWDHD_COMMENTS` varchar(1024) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_wf_doc_history_header`
--

DROP TABLE IF EXISTS `ezc_wf_doc_history_header`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_wf_doc_history_header` (
  `EWDHH_AUTH_KEY` varchar(16) NOT NULL,
  `EWDHH_DOC_ID` varchar(20) NOT NULL,
  `EWDHH_SYSKEY` varchar(6) DEFAULT NULL,
  `EWDHH_SOLD_TO` varchar(20) DEFAULT NULL,
  `EWDHH_TEMPLATE_CODE` decimal(6,0) DEFAULT NULL,
  `EWDHH_KEY` decimal(9,0) DEFAULT NULL,
  `EWDHH_DOC_DATE` datetime DEFAULT NULL,
  `EWDHH_WF_STATUS` varchar(20) DEFAULT NULL,
  `EWDHH_CREATED_ON` datetime DEFAULT NULL,
  `EWDHH_MODIFIED_ON` datetime DEFAULT NULL,
  `EWDHH_CREATED_BY` char(10) DEFAULT NULL,
  `EWDHH_MODIFIED_BY` char(10) DEFAULT NULL,
  `EWDHH_CURRENT_STEP` decimal(6,0) DEFAULT NULL,
  `EWDHH_NEXT_PARTICIPANT` varchar(20) DEFAULT NULL,
  `EWDHH_PARTICIPANT_TYPE` char(1) DEFAULT NULL,
  `EWDHH_REF1` varchar(100) DEFAULT NULL,
  `EWDHH_REF2` varchar(250) DEFAULT NULL,
  `EWDHH_NEXT_D_PARTICIPANT` varchar(30) DEFAULT NULL,
  `EWDHH_D_PARTICIPANT_TYPE` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`EWDHH_AUTH_KEY`,`EWDHH_DOC_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_wf_doc_status_view`
--

DROP TABLE IF EXISTS `ezc_wf_doc_status_view`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_wf_doc_status_view` (
  `EZPA_SYS_KEY` varchar(18) NOT NULL,
  `EZPA_SOLD_TO` varchar(10) NOT NULL,
  `EZPA_DOC_NO` varchar(10) NOT NULL,
  `EZPA_DOC_DATE` datetime DEFAULT NULL,
  `EZPA_DOC_STATUS` char(1) DEFAULT NULL,
  `EZPA_CREATED_ON` datetime DEFAULT NULL,
  `EZPA_CREATED_BY` varchar(10) DEFAULT NULL,
  `EZPA_MODIFIED_ON` datetime DEFAULT NULL,
  `EZPA_HEADER_TEXT` text,
  `EZPA_EXT1` varchar(20) DEFAULT NULL,
  `EZPA_EXT2` varchar(20) DEFAULT NULL,
  `EZPA_EXT3` varchar(20) DEFAULT NULL,
  `EWDHH_AUTH_KEY` varchar(16) DEFAULT NULL,
  `EWDHH_DOC_ID` varchar(20) DEFAULT NULL,
  `EWDHH_SYSKEY` varchar(6) DEFAULT NULL,
  `EWDHH_SOLD_TO` varchar(20) DEFAULT NULL,
  `EWDHH_TEMPLATE_CODE` decimal(6,0) DEFAULT NULL,
  `EWDHH_KEY` decimal(9,0) DEFAULT NULL,
  `EWDHH_DOC_DATE` datetime DEFAULT NULL,
  `EWDHH_WF_STATUS` varchar(20) DEFAULT NULL,
  `EWDHH_CREATED_ON` datetime DEFAULT NULL,
  `EWDHH_MODIFIED_ON` datetime DEFAULT NULL,
  `EWDHH_CREATED_BY` char(10) DEFAULT NULL,
  `EWDHH_MODIFIED_BY` char(10) DEFAULT NULL,
  `EWDHH_CURRENT_STEP` decimal(6,0) DEFAULT NULL,
  `EWDHH_NEXT_PARTICIPANT` varchar(20) DEFAULT NULL,
  `EWDHH_PARTICIPANT_TYPE` char(1) DEFAULT NULL,
  `EWDHH_REF1` varchar(100) DEFAULT NULL,
  `EWDHH_REF2` varchar(250) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_wf_escalation`
--

DROP TABLE IF EXISTS `ezc_wf_escalation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_wf_escalation` (
  `EWE_CODE` decimal(6,0) NOT NULL,
  `EWE_LANG` char(2) DEFAULT NULL,
  `EWE_DESCRIPTION` varchar(50) DEFAULT NULL,
  `EWE_LEVEL` varchar(2) DEFAULT NULL,
  `EWE_TEMPLATE` decimal(6,0) DEFAULT NULL,
  `EWE_GROUP_ID` varchar(10) DEFAULT NULL,
  `EWE_ROLE_ID` varchar(10) DEFAULT NULL,
  `EWE_USER_ID` char(10) DEFAULT NULL,
  `EWE_DURATION` decimal(20,0) DEFAULT NULL,
  `EWE_TYPE` char(1) DEFAULT NULL,
  `EWE_MOVE` varchar(6) DEFAULT NULL,
  `EWE_DOC_TYPE` varchar(20) DEFAULT NULL,
  `EWE_SYSKEY` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_wf_key_map`
--

DROP TABLE IF EXISTS `ezc_wf_key_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_wf_key_map` (
  `EWKM_DOC_TYPE` varchar(4) NOT NULL,
  `EWKM_COMP_CODE` varchar(5) NOT NULL,
  `EWKM_PLANT` varchar(5) NOT NULL,
  `EWKM_CATEGORY` varchar(10) NOT NULL,
  `EWKM_TEMPLATE` int DEFAULT NULL,
  PRIMARY KEY (`EWKM_DOC_TYPE`,`EWKM_COMP_CODE`,`EWKM_PLANT`,`EWKM_CATEGORY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_wf_orgonagram`
--

DROP TABLE IF EXISTS `ezc_wf_orgonagram`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_wf_orgonagram` (
  `EWO_CODE` decimal(6,0) NOT NULL,
  `EWO_SYSKEY` varchar(18) DEFAULT NULL,
  `EWO_LANG` char(2) DEFAULT NULL,
  `EWO_TEMPLATE` decimal(6,0) DEFAULT NULL,
  `EWO_DESCRIPTION` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`EWO_CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_wf_orgonagram_details`
--

DROP TABLE IF EXISTS `ezc_wf_orgonagram_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_wf_orgonagram_details` (
  `EWOD_CODE` decimal(6,0) NOT NULL,
  `EWOD_LEVEL` decimal(3,0) NOT NULL,
  `EWOD_PARTICIPANT_TYPE` char(1) DEFAULT NULL,
  `EWOD_PARTICIPANT` varchar(20) NOT NULL,
  `EWOD_LANG` char(2) DEFAULT NULL,
  `EWOD_DESCRIPTION` varchar(100) DEFAULT NULL,
  `EWOD_PARENT` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_wf_pricing_conditions`
--

DROP TABLE IF EXISTS `ezc_wf_pricing_conditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_wf_pricing_conditions` (
  `EWPC_TEMPLATE` int NOT NULL,
  `EWPC_LEVEL` int NOT NULL,
  `EWPC_ROLE` varchar(20) NOT NULL,
  `EWPC_GROUP` varchar(20) NOT NULL,
  `EWPC_QCF_FLAG` varchar(5) DEFAULT NULL,
  `EWPC_QCF_RELEASE` bigint DEFAULT NULL,
  PRIMARY KEY (`EWPC_ROLE`,`EWPC_TEMPLATE`,`EWPC_LEVEL`,`EWPC_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_wf_pricing_conditions_ss`
--

DROP TABLE IF EXISTS `ezc_wf_pricing_conditions_ss`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_wf_pricing_conditions_ss` (
  `EWPC_TEMPLATE` int NOT NULL,
  `EWPC_LEVEL` int NOT NULL,
  `EWPC_ROLE` varchar(20) NOT NULL,
  `EWPC_GROUP` varchar(20) NOT NULL,
  `EWPC_QCF_FLAG` varchar(5) DEFAULT NULL,
  `EWPC_QCF_RELEASE` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_wf_role_rules`
--

DROP TABLE IF EXISTS `ezc_wf_role_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_wf_role_rules` (
  `EWRC_ROLENR` varchar(16) DEFAULT NULL,
  `EWRC_AUTHKEY` varchar(16) DEFAULT NULL,
  `EWRC_RULE_ID` decimal(6,0) NOT NULL,
  `EWRC_DESCRITPION` varchar(255) DEFAULT NULL,
  `EWRC_CONDITIONS` varchar(255) DEFAULT NULL,
  `EWRC_CONDITION_TEXT` varchar(1024) DEFAULT NULL,
  `EWRC_RESULT` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`EWRC_RULE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_wf_template_code`
--

DROP TABLE IF EXISTS `ezc_wf_template_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_wf_template_code` (
  `EWTC_CODE` decimal(6,0) NOT NULL,
  `EWTC_LANG` char(2) NOT NULL,
  `EWTC_DESC` varchar(255) DEFAULT NULL,
  `EWTC_AUTH_KEY` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`EWTC_CODE`,`EWTC_LANG`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_wf_template_steps`
--

DROP TABLE IF EXISTS `ezc_wf_template_steps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_wf_template_steps` (
  `EWTS_CODE` decimal(6,0) NOT NULL,
  `EWTS_STEP` decimal(6,0) NOT NULL,
  `EWTS_STEP_DESC` varchar(100) DEFAULT NULL,
  `EWTS_ROLE` varchar(16) DEFAULT NULL,
  `EWTS_OWNER_PARTICIPANT` varchar(20) DEFAULT NULL,
  `EWTS_OWNER_PARTICIPANT_TYPE` char(1) DEFAULT NULL,
  `EWTS_FYI_PARTICIPANT` varchar(20) DEFAULT NULL,
  `EWTS_FYI_PARTICIPANT_TYPE` char(1) DEFAULT NULL,
  `EWTS_IS_MANDATORY` char(1) DEFAULT NULL,
  PRIMARY KEY (`EWTS_CODE`,`EWTS_STEP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_wf_workgroup_users`
--

DROP TABLE IF EXISTS `ezc_wf_workgroup_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_wf_workgroup_users` (
  `EWWU_GROUP` varchar(10) NOT NULL,
  `EWWU_USER` varchar(10) NOT NULL,
  `EWWU_SYSKEY` varchar(20) NOT NULL,
  `EWWU_SOLD_TO` varchar(20) NOT NULL,
  `EWWU_EFFECTIVE_FROM` datetime DEFAULT NULL,
  `EWWU_EFFECTIVE_TO` datetime DEFAULT NULL,
  PRIMARY KEY (`EWWU_GROUP`,`EWWU_USER`,`EWWU_SYSKEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_wf_workgroups`
--

DROP TABLE IF EXISTS `ezc_wf_workgroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_wf_workgroups` (
  `EWW_ROLE_NO` varchar(16) DEFAULT NULL,
  `EWW_GROUP` varchar(10) NOT NULL,
  `EWW_LANG` char(2) NOT NULL,
  `EWW_TYPE` varchar(6) DEFAULT NULL,
  `EWW_DESCRIPTION` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`EWW_GROUP`,`EWW_LANG`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_workflow_procedure`
--

DROP TABLE IF EXISTS `ezc_workflow_procedure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_workflow_procedure` (
  `EWP_PROCEDURE_TYPE` char(3) NOT NULL,
  `EWP_STEP_NUMBER` decimal(2,0) NOT NULL,
  `EWP_CAUSE_ACTION` varchar(100) DEFAULT NULL,
  `EWP_USER_ROLE` varchar(10) DEFAULT NULL,
  `EWP_COPY_TO_ROLE` varchar(30) DEFAULT NULL,
  `EWP_MANDATORY_STEP` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_xml_doctype`
--

DROP TABLE IF EXISTS `ezc_xml_doctype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_xml_doctype` (
  `EXD_XML_DOCTYPE` varchar(2) NOT NULL,
  `EXD_XML_DOCTYPE_DESPRIPTION` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_xml_erp_mapping`
--

DROP TABLE IF EXISTS `ezc_xml_erp_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_xml_erp_mapping` (
  `EXE_XML_STANDARD` varchar(6) NOT NULL,
  `EXE_XML_DOCTYPE` varchar(2) NOT NULL,
  `EXE_XML_EZC_CONTAINER` varchar(50) DEFAULT NULL,
  `EXE_XML_EZC_STRUCTURE` varchar(50) DEFAULT NULL,
  `EXE_XML_EZC_STRUCTURE_FIELDS` varchar(25) DEFAULT NULL,
  `EXE_XML_EZC_FIELDTYPE` varchar(25) DEFAULT NULL,
  `EXE_XML_ELEMENT` varchar(100) DEFAULT NULL,
  `EXE_XML_ATTRIBUTE` varchar(100) DEFAULT NULL,
  `EXE_XML_DATA_TYPE` varchar(20) DEFAULT NULL,
  `EXE_XML_PARENT_ELEMENT` varchar(100) DEFAULT NULL,
  `EXE_ERP_SYSTEM` varchar(20) DEFAULT NULL,
  `EXE_ERP_VERSION` varchar(20) DEFAULT NULL,
  `EXE_STRUCTURE_FLAG` char(1) DEFAULT NULL,
  `EXE_XML_RES1` varchar(50) DEFAULT NULL,
  `EXE_ERP_MANDATORY` char(1) DEFAULT NULL,
  `EXE_XML_ERP_CLASS` char(50) DEFAULT NULL,
  `EXE_XML_SEQUENCE_ID` decimal(6,0) NOT NULL,
  `EXE_CLIENT` decimal(3,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_xml_method_mapping`
--

DROP TABLE IF EXISTS `ezc_xml_method_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_xml_method_mapping` (
  `EXM_XML_STANDARD` varchar(6) NOT NULL,
  `EXM_XML_DOCTYPE` varchar(2) NOT NULL,
  `EXM_XML_TRANSACTION_ID` varchar(18) NOT NULL,
  `EXM_ERP_SYSTEM` varchar(20) NOT NULL,
  `EXM_ERP_VERSION` varchar(20) NOT NULL,
  `EXM_ERP_CLASS` varchar(100) DEFAULT NULL,
  `EXM_ERP_METHOD` varchar(100) DEFAULT NULL,
  `EXM_ERP_RETURN` varchar(100) DEFAULT NULL,
  `EXM_SYSTEM_TYPE` varchar(20) NOT NULL,
  `EXM_PACKAGE` varchar(256) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezc_xml_standard`
--

DROP TABLE IF EXISTS `ezc_xml_standard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezc_xml_standard` (
  `EXS_XML_STANDARD` varchar(6) NOT NULL,
  `EXS_XML_STANDARD_DESPRIPTION` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezcser_labor_reqmt_desc`
--

DROP TABLE IF EXISTS `ezcser_labor_reqmt_desc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezcser_labor_reqmt_desc` (
  `EMLRD_LANGUAGE` varchar(2) DEFAULT NULL,
  `EMLRD_REQMT_ID` decimal(18,0) DEFAULT NULL,
  `EMLRD_REQMT_DESC` varchar(1024) DEFAULT NULL,
  `EMLRD_MO_ID` decimal(18,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezcser_material_reqmt_desc`
--

DROP TABLE IF EXISTS `ezcser_material_reqmt_desc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezcser_material_reqmt_desc` (
  `EMMRD_LANGUAGE` varchar(2) DEFAULT NULL,
  `EMMRD_REQMT_ID` decimal(18,0) DEFAULT NULL,
  `EMMRD_REQMT_DESC` varchar(1024) DEFAULT NULL,
  `EMMRD_MO_ID` decimal(18,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezcser_mo_operation_desc`
--

DROP TABLE IF EXISTS `ezcser_mo_operation_desc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezcser_mo_operation_desc` (
  `EMOPD_LANGUAGE` varchar(2) DEFAULT NULL,
  `EMOPD_MOOP_ID` decimal(18,0) DEFAULT NULL,
  `EMOPD_MO_ID` decimal(18,0) DEFAULT NULL,
  `EMOPD_MOOP_DESC` varchar(50) DEFAULT NULL,
  `EMOPD_MO_PROB_TXT` varchar(2048) DEFAULT NULL,
  `EMOPD_MO_SAFETY_PREC` varchar(2048) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezcser_morder_desc`
--

DROP TABLE IF EXISTS `ezcser_morder_desc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezcser_morder_desc` (
  `EMOD_LANGUAGE` varchar(2) DEFAULT NULL,
  `EMOD_MO_ID` decimal(18,0) DEFAULT NULL,
  `EMOD_MO_DESC` varchar(50) DEFAULT NULL,
  `EMOD_MO_EQP_COND` varchar(2048) DEFAULT NULL,
  `EMOD_MO_PROB_TXT` varchar(2048) DEFAULT NULL,
  `EMOD_MO_SAFETY_PREC` varchar(2048) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezcser_mtab_desc`
--

DROP TABLE IF EXISTS `ezcser_mtab_desc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezcser_mtab_desc` (
  `ETDESC_TAB_TYPE` decimal(2,0) NOT NULL,
  `ETDESC_LANGUAGE` varchar(2) NOT NULL,
  `ETDESC_CODE` varchar(10) NOT NULL,
  `ETDESC_DESCRIPTION` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ezcser_other_reqmt_desc`
--

DROP TABLE IF EXISTS `ezcser_other_reqmt_desc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ezcser_other_reqmt_desc` (
  `EMORD_LANGUAGE` varchar(2) DEFAULT NULL,
  `EMORD_REQMT_ID` decimal(18,0) DEFAULT NULL,
  `EMORD_REQMT_DESC` varchar(1024) DEFAULT NULL,
  `EMORD_MO_ID` decimal(18,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `mat_details`
--

DROP TABLE IF EXISTS `mat_details`;
/*!50001 DROP VIEW IF EXISTS `mat_details`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `mat_details` AS SELECT 
 1 AS `EMM_NO`,
 1 AS `EMD_DESC`,
 1 AS `EMM_UNIT_OF_MEASURE`,
 1 AS `EMG_SYSTEM_KEY`,
 1 AS `EMG_GROUP_ID`,
 1 AS `EMM_EAN_UPC_NO`,
 1 AS `ECG_CATALOG_NO`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `salesorder`
--

DROP TABLE IF EXISTS `salesorder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `salesorder` (
  `DOC_TYPE` char(4) NOT NULL,
  `EXTORDNO` char(10) NOT NULL,
  `SAPORDNO` char(10) DEFAULT NULL,
  `SOLDTO` char(10) NOT NULL,
  `PONUMBER` char(10) NOT NULL,
  `STATUS` char(1) NOT NULL,
  `PROCESSED` date NOT NULL,
  PRIMARY KEY (`EXTORDNO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Final view structure for view `doc_details`
--

/*!50001 DROP VIEW IF EXISTS `doc_details`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `doc_details` AS select `a`.`ESDH_DOC_NUMBER` AS `WEB_ORNO`,`a`.`ESDH_COLLECT_NO` AS `COLLECT_NO`,`a`.`ESDH_DIVISION` AS `DIVISION`,`a`.`ESDH_DISTR_CHAN` AS `DISTR_CHAN`,`a`.`ESDH_SALES_ORG` AS `SALES_ORG`,`a`.`ESDH_REF_DOC` AS `REF_DOC_NR`,`a`.`ESDH_DOC_TYPE` AS `REF_DOC_TYPE`,`a`.`ESDH_AGENT_CODE` AS `AGENT_CODE`,`a`.`ESDH_SOLD_TO` AS `SOLD_TO_CODE`,`a`.`ESDH_ORDER_DATE` AS `ORDER_DATE`,`a`.`ESDH_SOLDTO_ADDR_1` AS `SOTO_ADDR1`,`a`.`ESDH_TRANSFER_DATE` AS `TRANSFER_DATE`,`a`.`ESDH_STATUS_DATE` AS `STATUS_DATE`,`a`.`ESDH_SHIP_TO` AS `SHIP_TO_CODE`,`a`.`ESDH_SHIPTO_ADDR_1` AS `SHTO_ADDR1`,`a`.`ESDH_TEXT1` AS `TEXT1`,`a`.`ESDH_TEXT2` AS `TEXT2`,`a`.`ESDH_RES1` AS `RES1`,`a`.`ESDH_RES2` AS `RES2`,`a`.`ESDH_SYS_KEY` AS `SALES_AREA_CODE`,`a`.`ESDH_CREATED_BY` AS `CREATE_USERID`,`a`.`ESDH_CREATE_ON` AS `CREATION_DATE`,`a`.`ESDH_MODIFIED_BY` AS `MOD_ID`,`a`.`ESDH_MODIFIED_ON` AS `LAST_MOD_DATE`,`a`.`ESDH_STATUS` AS `STATUS`,`a`.`ESDH_BACK_END_ORDER` AS `BACKEND_ORNO`,`a`.`ESDH_INCOTERMS1` AS `INCO_TERMS1`,`a`.`ESDH_INCOTERMS2` AS `INCO_TERMS2`,`a`.`ESDH_NET_VALUE` AS `NET_VALUE`,`a`.`ESDH_DOC_CURRENCY` AS `DOC_CURRENCY`,`a`.`ESDH_PO_NO` AS `PO_NO`,`a`.`ESDH_REF_DOC_NO` AS `REF_DOC_NO`,`a`.`ESDH_PMNTTRMS` AS `PAYMENT_TERMS`,`a`.`ESDH_DISCOUNT_CASH` AS `DISCOUNT_CASH`,`a`.`ESDH_DISCOUNT_PERCENTAGE` AS `DISCOUNT_PERCENTAGE`,`a`.`EDSH_FREIGHT` AS `FREIGHT`,`a`.`EDSH_TEXT3` AS `TEXT3`,`a`.`ESDH_TEXT4` AS `TEXT4`,`a`.`ESDH_CLASS2` AS `CLASS2`,`a`.`ESDH_ORD_REASON` AS `ORD_REASON`,`a`.`ESDH_PURCH_DATE` AS `PURCH_DATE`,`b`.`ESDI_SALES_DOC_ITEM` AS `SO_LINE_NO`,`b`.`ESDI_MATERIAL` AS `PROD_CODE`,`b`.`ESDI_SHORT_TEXT` AS `PROD_DESC`,`b`.`ESDI_QTY_IN_SALES_UNIT` AS `UOM_QTY`,`b`.`ESDI_SALES_UNIT` AS `UOM`,`b`.`ESDI_CONFIRMED_QTY` AS `COMMITED_QTY`,`b`.`ESDI_REQ_QTY` AS `DESIRED_QTY`,`b`.`ESDI_REQ_DATE` AS `REQ_DATE`,`b`.`ESDI_PROMISE_DATE` AS `PROMISE_FULL_DATE`,`b`.`ESDI_DESIRED_PRICE` AS `DESIRED_PRICE`,`b`.`ESDI_COMMITED_PRICE` AS `COMMIT_PRICE`,`b`.`ESDI_NET_VAL_OF_ORDER` AS `ITEM_NET_VALUE`,`b`.`ESDI_DOC_CURRENCY` AS `CURRENCY`,`b`.`ESDI_PLANT` AS `PLANT`,`b`.`ESDI_FOC` AS `FOC`,`b`.`ESDI_REF_DOC_ITEM` AS `REF_DOC_ITEM`,`b`.`ESDI_NOTES` AS `ESDI_NOTES`,`b`.`ESDI_SYS_KEY` AS `SYS_KEY`,`b`.`ESDI_BACK_END_ORDER` AS `BACK_END_ORDER`,`b`.`ESDI_BACK_END_ITEM` AS `BACK_END_ITEM`,`b`.`ESDI_SHIP_TO` AS `L_SHIP_TO`,`b`.`ESDI_INCOTERMS1` AS `INCOTERMS1`,`b`.`ESDI_INCOTERMS2` AS `INCOTERMS2`,`b`.`ESDI_REASON_MAT_SUBSTITUTION` AS `INVOICE`,`b`.`ESDI_BATCH_NO` AS `BATCH_NO`,`b`.`ESDI_ITEM_CATEGORY` AS `ITEM_CATEGORY`,`a`.`ESDH_REQ_DATE_H` AS `ESDH_REQ_DATE_H`,`a`.`ESDH_CUST_GRP5` AS `ESDH_CUST_GRP5`,`a`.`ESDH_REF_1` AS `ESDH_REF_1` from (`ezc_sales_doc_header` `a` join `ezc_sales_doc_items` `b`) where ((`a`.`ESDH_DOC_NUMBER` = `b`.`ESDI_SALES_DOC`) and (`b`.`ESDI_DEL_FLAG` = 'N')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `mat_details`
--

/*!50001 DROP VIEW IF EXISTS `mat_details`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `mat_details` AS select distinct `a`.`EMM_NO` AS `EMM_NO`,`a`.`EMD_DESC` AS `EMD_DESC`,`b`.`EMM_UNIT_OF_MEASURE` AS `EMM_UNIT_OF_MEASURE`,`c`.`EMG_SYSTEM_KEY` AS `EMG_SYSTEM_KEY`,`c`.`EMG_GROUP_ID` AS `EMG_GROUP_ID`,`b`.`EMM_EAN_UPC_NO` AS `EMM_EAN_UPC_NO`,`d`.`ECG_CATALOG_NO` AS `ECG_CATALOG_NO` from (((`ezc_material_desc` `a` join `ezc_material_master` `b`) join `ezc_material_groups` `c`) join `ezc_catalog_group` `d`) where ((`a`.`EMM_NO` = `b`.`EMM_NO`) and (`a`.`EMM_NO` = `c`.`EMG_MAT_NO`) and (`c`.`EMG_DELETION_FLAG` = 'N') and (`c`.`EMG_GROUP_ID` = `d`.`ECG_PRODUCT_GROUP`) and (`a`.`EMD_LANG` = 'EN')) */;
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

-- Dump completed on 2026-08-05 15:25:50