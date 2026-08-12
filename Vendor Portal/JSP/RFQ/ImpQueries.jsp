RFQ(s) added under QCF: 3050000061

1.RFQ:7000000597 created sucessfully against the vendor: TLC PHARMA TECH[801542]

2.RFQ:7000000598 created sucessfully against the vendor: 3A ANALYTIKS[310149]


File PATH:
============

Temp File:
==========
D:\EZC\EzUpload\300\8202F61FAC45FA2CF403D6D51675917C\H

File path:
===========
D:\EZC\EzCom\Upload\300\QCF\3150000007\H\


===================

SELECT ERH_RFQ_NO,ERD_LINE_NO,ERH_STATUS,ERH_CREATED_ON,ERH_COLLETIVE_RFQ_NO,ERD_EXT1,ERH_SOLD_TO,ERD_MATERIAL,ERD_PRICE,ERH_PAYMENT_TERMS,ERH_INCO_TERMS1,
ERH_SAVE_FLG,ERH_VALID_UPTO,ERH_MODIFIED_ON FROM EZC_RFQ_HEADER A,EZC_RFQ_DETAILS B WHERE A.ERH_RFQ_NO= B.ERD_RFQ_NO 
AND ERH_STATUS IN('P','R','Y','S')
AND A.ERH_CREATED_ON BETWEEN STR_TO_DATE('26/04/2022 00:00','%d/%m/%Y %H:%i') AND STR_TO_DATE('26/04/2022 23:59','%d/%m/%Y %H:%i');


=========================

SELECT DISTINCT EC_NO,ECA_NAME,EC_SYS_KEY,ESKD_SYS_KEY_DESC,EC_PARTNER_NO,EC_BUSINESS_PARTNER,ECA_REFERENCE_NO,ECA_COMPANY_NAME,ECA_PHONE,ECA_ADDR_1,ECA_COUNTRY,ECA_CITY,ECA_STATE,ECA_PIN,ECA_SHIP_CITY,ECA_IS_BUSINESS_PARTNER  FROM EZC_CUSTOMER A, EZC_CUSTOMER_ADDR B,EZC_SYSTEM_KEY_DESC WHERE EC_NO=ECA_NO AND A.EC_SYS_KEY IN ('999800') AND EC_PARTNER_FUNCTION IN ('VN') AND  EC_ERP_CUST_NO  IN ('0000303946') AND EC_SYS_KEY = ESKD_SYS_KEY

Insert into EZC_CUSTOMER (EC_NO ,EC_SYS_KEY,EC_PARTNER_FUNCTION,EC_PARTNER_NO, EC_ERP_CUST_NO, EC_BUSINESS_PARTNER, EC_DELETION_FLAG) values('105224','999800','PI','0000303946','0000303946','40840','N')

insert into EZC_USERS (EU_ID ,EU_DELETION_FLAG , EU_FIRST_NAME, EU_MIDDLE_INITIAL, EU_LAST_NAME, EU_EMAIL, EU_CREATED_DATE, EU_CHANGED_DATE, EU_CHANGED_BY, EU_VALID_TO_DATE, EU_LAST_LOGIN_TIME, EU_LAST_LOGIN_DATE, EU_PASSWORD, EU_TYPE, EUG_ID, EU_BUSINESS_PARTNER, EU_IS_BUILT_IN_USER, EU_CONTACT_NO) values ('303946','N','SILICYCLE','','','hchowdary@answerthink.com','09/06/2022','09/06/2022','EZCADMIN','01/31/01','16:46:35','09/06/2022','U+w{Q:B.I+I+E}q=5{a]n@e?', 3, 0, '40840','N','418-874-0054')

select * from EZC_USER_DEFAULTS  where EUD_USER_ID = '303946' and EUD_SYS_KEY = '999800' and EUD_KEY = 'SOLDTOPARTY' and EUD_DEFAULT_FLAG = 'N' and EUD_VALUE = '0000303946' 

Insert into EZC_USER_DEFAULTS (EUD_USER_ID, EUD_SYS_KEY, EUD_KEY, EUD_VALUE, EUD_DEFAULT_FLAG) values ('303946','999800','SOLDTOPARTY','0000303946','N')

select * from EZC_USER_AUTH where EUA_USER_ID = '303946' and EUA_SYS_NO = 0 and EUA_AUTH_KEY = 'VENDOR_SYS_IND' 
Insert into EZC_USER_AUTH (EUA_USER_ID, EUA_SYS_NO , EUA_AUTH_KEY, EUA_AUTH_VALUE, EUA_ROLE_OR_AUTH) values('303946', 0, 'VENDOR_SYS_IND', 'Vemdpr System Independant Role', 'R')


INSERT INTO EZC_WF_WORKGROUP_USERS (EWWU_GROUP, EWWU_USER,EWWU_SYSKEY,EWWU_SOLD_TO,EWWU_EFFECTIVE_FROM, EWWU_EFFECTIVE_TO)  VALUES ('VENDOR','303946','999800','0000303946',STR_TO_DATE('01/01/2000','%d/%m/%Y'),STR_TO_DATE('01/01/2999','%d/%m/%Y'))


select * from EZC_CUSTOMER;

select * from EZC_USERS;

select * from EZC_USER_DEFAULTS;

select * from EZC_USER_AUTH;

select * from EZC_WF_WORKGROUP_USERS;

logo

Queries to send back vendor once vendor has posted to sap
-------------------------------------------

select * from ezc_customer_form_header where ECFH_DOC_ID in ('712120');
--UPDATE `jublqa`.`ezc_customer_form_header` SET `ECFH_MODIFIED_BY` = 'SSETH', `ECFH_SAP_CODE` = '', `ECFH_STATUS` = 'SUBMITTED' WHERE (`ECFH_DOC_ID` = '712120');

select * from ezc_wf_doc_history_header where EWDHH_DOC_ID in ('712120');
--UPDATE `jublqa`.`ezc_wf_doc_history_header` SET `EWDHH_WF_STATUS` = 'SUBMITTED', `EWDHH_MODIFIED_BY` = 'SSETH', `EWDHH_CURRENT_STEP` = '6', `EWDHH_NEXT_PARTICIPANT` = 'FIHEAD' WHERE (`EWDHH_AUTH_KEY` = 'VNR') and (`EWDHH_DOC_ID` = '712120');

select * from ezc_wf_audit_trail where EWAT_DOC_ID in ('712120') and EWAT_SOURCE_PARTICIPANT='NPANDEY'
--delete from ezc_wf_audit_trail where EWAT_DOC_ID in ('712120') and EWAT_SOURCE_PARTICIPANT='NPANDEY'

select * from ezc_document_comments where EDC_DOC_ID='712120' and EDC_USER_ID='NPANDEY'
--delete from ezc_document_comments where EDC_DOC_ID='712120' and EDC_USER_ID='NPANDEY';
=======================================================================

D:\apache-tomee-webprofile-1.7.2\work\Catalina\localhost\JUBL\org\apache\jsp\EzCommerce\EzVendor\Vendor2\JSPs\RFQ\ezQuotationSave_jsp.java

====================================

comments

auction








Select user from mysql.user;

select STR_TO_DATE('04/01/2023','%m/%d/%Y') from ezc_users WHERE STR_TO_DATE(EU_CREATED_DATE,'%m/%d/%Y') ;
select eu_id,EU_FIRST_NAME,EWWU_GROUP,EU_CREATED_DATE,EU_VALID_TO_DATE from ezc_users,ezc_wf_workgroup_users 
where eu_id=EWWU_USER AND EU_TYPE = '2' and EU_DELETION_FLAG = 'N' order by EU_CREATED_DATE asc;


SELECT  DATE_FORMAT(EAH_CREATION_DATE,'%d/%m/%Y %h:%i:%s %p')  CREATION_DATE,DATE_FORMAT(EAH_START_DATE,'%d/%m/%Y %h:%i:%s %p')  START_DATE,DATE_FORMAT(EAH_END_DATE,'%d/%m/%Y %h:%i:%s %p')  END_DATE,A.*,B.* FROM EZC_AUCTION_HEADER A,EZC_AUCTION_SUPPLIER B where A.EAH_AUCTION_ID=B.EAS_AUCTION_ID AND EAS_ACKNOWLEDGE_STATUS IN ('A','N','R') AND A.EAH_CREATION_DATE BETWEEN STR_TO_DATE('01/01/2024','%d/%m/%Y %H:%i') AND STR_TO_DATE('01/04/2024','%d/%m/%Y %H:%i') AND CONCAT(A.EAH_PLANT,'#',A.EAH_CATEGORY) IN ('1002#EXT_MFG','1008#EXT_MFG','1012#ENG_SER','3001#ENG_SER','3001#EXT_MFG','3001#RM_PM','3002#EXT_MFG','3002#RM_PM','4410#EXT_MFG','4410#RM_PM','4470#EXT_MFG','4480#EXT_MFG','1002#EXT_MFG','1008#EXT_MFG','1012#ENG_SER','3001#ENG_SER','3001#EXT_MFG','3001#RM_PM','3002#EXT_MFG','3002#RM_PM','4410#EXT_MFG','4410#RM_PM','4470#EXT_MFG','4480#EXT_MFG') ORDER BY EAH_AUCTION_ID  DESC;
select eu_id,EU_FIRST_NAME,EWWU_GROUP,EU_CREATED_DATE,EU_VALID_TO_DATE from 
ezc_users,ezc_wf_workgroup_users where eu_id=EWWU_USER AND EU_DELETION_FLAG = 'B';
select distinct(EWWU_USER) from ezc_wf_workgroup_users,ezc_users where EWWU_USER=eu_id and EWWU_SYSKEY = '999800' and eu_type = '2';

select * from ezc_users where  EU_EMAIL =  'kathyayani.pasapula@thehackettgroup.com' and eu_type = '2';
select * from ezc_users where EU_DELETION_FLAG = 'N' and STR_TO_DATE(EU_CREATED_DATE,'%m/%d/%Y')  between STR_TO_DATE('04/01/2023','%m/%d/%Y') and STR_TO_DATE('03/31/2024','%m/%d/%Y');
select * from ezc_qcf_comments where EQC_CODE = '713706';
select * from ezc_user_def_key_values where EUDKV_USER_ID in ('MSINGH4');
select ECFH_DOC_ID, ECFH_CUST_NAME, ECFH_CREATED_BY, ECFH_CREATED_ON, ECFH_EXT1, ECFH_PLANT, ECFH_STATUS from ezc_customer_form_header where ECFH_EXT1 in ('4500','9000','7300','7501','4101') order by ECFH_CREATED_ON asc;

select EU_ID,EU_EMAIL,EU_FIRST_NAME from ezc_users,ezc_wf_workgroup_users where eu_id = EWWU_USER and eu_type = '2' and EU_DELETION_FLAG = 'N' 
 and EWWU_SYSKEY not in ('999800') order by eu_id asc;

 
select * from ezc_user_auth where EUA_USER_ID in ('AKSHARMA','JPAREKH','JSOOD','KUMARR','SMANSI','GPERFETTI','JAIDEVR','CPGAPPR','BTHOMAS','NJAIN','NPANDEY','ATHAKUR1','DSUDHAKAR','NYADAV','PANAND','RAMESHKP','RHOON','AANITHA','AJHA','AKUMARI','AMANJULA','BHARUN','BHUPENDRAS','CHETHANNS','DHARSHANKP','DSINGH3','GINESHP','GPANWAR','HCHAUDHARY','KARTHIKG','KHADAKS','KSMITHA','KVASHISTHA','MJGIRISH','MKUMAR7','MSIKARWAR','MSINGH4','NITHINSR','PRAJAKUMAR','RASHMIHP','RAVIH','RKHAN','SANTHOSHA1','SATENDRAS','SHRINS','SKUMAR3','SRINIVASRE','SVANDANA','TEST_RRK','YUVARAJN','PSINGH4','SSETH','ANUJJ','DEBAMOYM','DSATAPATHY','GIRISHB','GSAURABH','JYOTIM','KJAIN','MAGGARWAL','MSINGH8','NGARG','PARORA','ABARUAH','AVERMA','DNITISH','JAGDISHM','NJAISWAL','PKUMAR','PMISRA','PRAVEENK','SCHAUDHARY','SHWETAM','STHOMAS','SUNDERG','SYADAV2','TUSHARM','VAIBHAVS','ADWIVEDI','NARESHK','NGUPTA1','AGUPTA4','ASHISHJ','CSINGH','DJAISWAL','LSINGH2','NAMRUTKAR','NAVEENK','NVSHARMA','PSHARMA3','RSHARMA2','RTHAKUR1','TMAHESHWAR');

select * from ezc_user_def_key_values where EUDKV_USER_ID = 'PRAVEENK';

select * from qrtz_triggers;

select EWS_USER_ID,eu_email,EU_DELETION_FLAG,max(EWS_LOGGED_IN) from ezc_web_stats,ezc_users where
 ezc_web_stats.EWS_USER_ID=ezc_users.EU_ID and ezc_users.EU_TYPE = '2' and ezc_wf_workgroup_users.EWWU_USER in 
 (select ezc_users.EU_ID from ezc_users,ezc_wf_workgroup_users where ezc_users.EU_ID=ezc_wf_workgroup_users.EWWU_USER
 and ezc_wf_workgroup_users.EWWU_SYSKEY = '999800') 
 group by ezc_web_stats.EWS_USER_ID order by ezc_web_stats.EWS_USER_ID asc;
 
 select distinct(ewwu_user) from ezc_wf_workgroup_users,ezc_users where EWWU_USER=eu_id and EWWU_SYSKEY not in ('999800') and eu_type = '2';
 
select * from ezc_userS where eu_id IN  ('312388');

select * from ezc_user_def_key_values where EUDKV_USER_ID = 'GPERFETTI';
select * from ezc_wf_workgroup_users where EWWU_GROUP = 'CEO';
select * from ezc_wf_pricing_conditions where EWPC_TEMPLATE in ('2006') and ewpc_role = 'CEO';

select * from ezc_wf_doc_history_header where EWDHH_MODIFIED_BY IN  ('JUBLBUYER','CPGAPPR');


desc ezc_customer_form_details;
select * from ezc_web_stats where EWS_USER_ID = 'CPGAPPR';


select * from ezc_web_stats where EWS_USER_ID in (select eu_id from ezc_users where EU_DELETION_FLAG = 'B' and  EU_TYPE = '2' and 
STR_TO_DATE(EU_CREATED_DATE,'%m/%d/%Y')  between STR_TO_DATE('04/01/2023','%m/%d/%Y') 
and STR_TO_DATE('03/31/2024','%m/%d/%Y'));

select eu_id,eu_email,EU_FIRST_NAME,EUDKV_KEY,EUDKV_VALUE from ezc_users,ezc_user_def_key_values where eu_id = EUDKV_USER_ID and eu_type = '2' 
and EU_DELETION_FLAG = 'N' and eu_id not in ('ABOUTELDJA','ALEXANDERW','ALGOLDBERG','ANGELAM','ASTONGE','BFMOLDEN','BRJACK','CHRISTIANA','CHSEAN','CJENNIFER','CJFOOTE','CNICHOLAS','CRYSTALB','DROGERS','EDUVAL','EMILYMD','FKRISTEN','FOROMAN','GASHTON','GHASSAN','GLAURENT','JGASKIN','JMRUIZ','KBEAUCHEMI','KBELINDA','KDESAI','KLERNER','KLISA','KMBDURGAN','KNICOLE','KPAUL','KSACHIN','LCIERRRA','LGRUGER','LJLYLE','LJOHN','LWANDA','MBOUNDS','MCERIC','MKATHLEEN','MSMITH','MSOULIERES','NICKPL','RBENRAIS','RILEYCH','RROBERT','SABRIGHT','SCHROBERT','SMITCHELL1','SUNGUR','TAYLORS','TDHALL','TJWOLF','VILASS','ZTIZI','BKAMAL','CDANIELS','GSECONDI','GTUTEJA','KKHAITAN','MAGUPTA2','NSINGLA','TKASIMTSEV','AEERICH','CCPIERCE','CELIAOP','CPETER','CTHIBAULT','DLPAYTON','GHMICHAEL','GWILLIAM','IELIZABETH','INANDI','JLBEELER','JOSEPHL','JVCHERNYAV','JWILKINSON','JWKING','MBRIEN','MDAOUST','MSMOSS','PLYNCH','SIDHARTHAR','TFONZO','WDONALD','GRNATARAJ','HVAGHELA','SSHRIVASTA','AEROS','AKMODUPE','AREINER','CAUNRUH','DWARNER','EBENEVENTO','EKROENCKE','FRAJPUT','GPARRAGA','HMBLACK','HSWILSON','JTWIETMEYE','KHOQUE','KMAINOR','MTORRES','RMARINO','TESTUSER','DCOSGOOD','ETURCOTTE','KMIKEROVA2','MBERNARD','SVANHEESBE','TPANKAJ','KCOOPER','VBAJPAI');


select distinct(EWWU_USER) from ezc_wf_workgroup_users,ezc_users where EWWU_USER = eu_id and EWWU_SYSKEY not in ('999800') and EU_DELETION_FLAG = 'N' and eu_type = '2';


 select eu_id,eu_email,EU_DELETION_FLAG,EU_FIRST_NAME,max(EWS_LOGGED_IN) from ezc_users INNER JOIN ezc_web_stats ON 
 ezc_users.eu_id = ezc_web_stats.EWS_USER_ID INNER JOIN ezc_wf_workgroup_users ON 
 ezc_web_stats.EWS_USER_ID = ezc_wf_workgroup_users.EWWU_USER where EU_TYPE = '2' and EWWU_SYSKEY = '999800' group by EWS_USER_ID order by EWS_USER_ID;

select * from ezc_users,ezc_wf_workgroup_users where eu_id=EWWU_USER  and eu_type = '2'  AND EWWU_SYSKEY = '999800' ORDER BY EWWU_USER;
select eu_id,EU_FIRST_NAME,EWWU_GROUP,EU_CREATED_DATE,EU_VALID_TO_DATE from ezc_users,ezc_wf_workgroup_users where eu_id = EWWU_USER and 
EWWU_SYSKEY = '999800' and STR_TO_DATE(EU_CREATED_DATE,'%m/%d/%Y')  between STR_TO_DATE('04/01/2023','%m/%d/%Y') 
and STR_TO_DATE('03/31/2024','%m/%d/%Y') and EWWU_GROUP IN ('VENDOR') ORDER BY EU_CREATED_DATE DESC;

 select EUA_USER_ID,EUA_AUTH_KEY,EUA_AUTH_VALUE from ezc_user_auth LEFT JOIN ezc_wf_workgroup_users ON 
 ezc_user_auth.EUA_USER_ID=ezc_wf_workgroup_users.EWWU_USER LEFT JOIN EZC_USERS ON ezc_user_auth.EUA_USER_ID UNION
select EUA_USER_ID,EUA_AUTH_KEY,EUA_AUTH_VALUE from ezc_user_auth LEFT JOIN ezc_wf_workgroup_users ON 
 ezc_user_auth.EUA_USER_ID=ezc_wf_workgroup_users.EWWU_USER LEFT JOIN EZC_USERS ON ezc_user_auth.EUA_USER_ID 
  where EU_TYPE = '2' and EWWU_SYSKEY = '999800' group by EUA_USER_ID order by EUA_USER_ID;
  
  
 SELECT EUA_USER_ID,EUA_SYS_NO,EUA_AUTH_KEY,EUA_AUTH_VALUE,EUA_ROLE_OR_AUTH FROM 
 ezc_user_auth,ezc_wf_workgroup_users,ezc_users WHERE ezc_user_auth.EUA_USER_ID=ezc_wf_workgroup_users.EWWU_USER and 
 ezc_wf_workgroup_users.EWWU_USER=ezc_users.EU_ID AND EWWU_SYSKEY = '999800' AND EU_TYPE = '2' AND EU_DELETION_FLAG = 'N';
 
 select EWS_USER_ID,EU_FIRST_NAME,EWWU_SYSKEY,EWS_LOGGED_IN,EWS_LOGGED_OUT from ezc_web_stats,ezc_users,ezc_wf_workgroup_users 
 where ezc_web_stats.EWS_USER_ID=ezc_users.EU_ID and ezc_users.EU_ID=ezc_wf_workgroup_users.EWWU_USER and EWWU_SYSKEY not in ('999800') 
 AND EU_TYPE = '2' and  EWS_LOGGED_IN between '2024-04-01' and '2024-07-31' order by EWS_USER_ID asc;
 
 
 select EWWU_USER,EU_FIRST_NAME,EU_EMAIL,EWWU_SYSKEY from ezc_users,ezc_wf_workgroup_users where eu_id = EWWU_USER and eu_type = '2' and EU_DELETION_FLAG = 'N' and EWWU_SYSKEY not in ('999800') order by EWWU_USER asc;
 
 SELECT DISTINCT ERH_PO_FLAG,ERH_COLLETIVE_RFQ_NO,(SELECT COUNT(Z.ERH_SOLD_TO) FROM ezc_rfq_header Z where z.ERH_COLLETIVE_RFQ_NO=A.ERH_COLLETIVE_RFQ_NO ) AS TOTVEND, (SELECT COUNT(Z.ERH_SOLD_TO) FROM ezc_rfq_header Z where z.ERH_COLLETIVE_RFQ_NO=A.ERH_COLLETIVE_RFQ_NO AND ERH_STATUS IN ('S','P','Y')) AS QTVEND,ERH_EXT2,ERH_PLANT,ERH_FINAL_VALUE,EWDHH_CREATED_ON,EWDHH_MODIFIED_ON,EWDHH_CREATED_BY,EWDHH_WF_STATUS,EWDHH_NEXT_PARTICIPANT,NEXT_PART FROM  EZC_RFQ_HEADER A INNER JOIN EZC_WF_DOC_HISTORY_HEADER B ON A.ERH_COLLETIVE_RFQ_NO=B.EWDHH_DOC_ID LEFT OUTER JOIN (SELECT EWWU_GROUP,GROUP_CONCAT(CONCAT(EU_ID,'[',EU_FIRST_NAME,']')) AS NEXT_PART  FROM EZC_WF_WORKGROUP_USERS,EZC_USERS WHERE EWWU_USER=EU_ID  AND EWWU_USER IN (SELECT EUDKV_USER_ID FROM EZC_USER_DEF_KEY_VALUES WHERE EUDKV_KEY='CATEGORY' AND EUDKV_VALUE IN ('1002#ENG_SER','1002#LOG','1004#ENG_SER','1004#LOG','1008#ENG_SER','1008#LOG','1012#ENG_SER','1012#LOG','3001#ENG_SER','3001#LOG','3002#ENG_SER','3002#LOG','4410#ENG_SER','4410#LOG','4470#ENG_SER','4470#LOG','4480#ENG_SER','4480#LOG','1002#ENG_SER','1002#LOG','1004#ENG_SER','1004#LOG','1008#ENG_SER','1008#LOG','1012#ENG_SER','1012#LOG','3001#ENG_SER','3001#LOG','3002#ENG_SER','3002#LOG','4410#ENG_SER','4410#LOG','4470#ENG_SER','4470#LOG','4480#ENG_SER','4480#LOG')) GROUP BY EWWU_GROUP) AS C ON B.EWDHH_NEXT_PARTICIPANT=C.EWWU_GROUP  WHERE  CONCAT(ERH_PLANT,'#',A.ERH_CATEGORY) IN ('1002#ENG_SER','1002#LOG','1004#ENG_SER','1004#LOG','1008#ENG_SER','1008#LOG','1012#ENG_SER','1012#LOG','3001#ENG_SER','3001#LOG','3002#ENG_SER','3002#LOG','4410#ENG_SER','4410#LOG','4470#ENG_SER','4470#LOG','4480#ENG_SER','4480#LOG','1002#ENG_SER','1002#LOG','1004#ENG_SER','1004#LOG','1008#ENG_SER','1008#LOG','1012#ENG_SER','1012#LOG','3001#ENG_SER','3001#LOG','3002#ENG_SER','3002#LOG','4410#ENG_SER','4410#LOG','4470#ENG_SER','4470#LOG','4480#ENG_SER','4480#LOG') AND B.EWDHH_WF_STATUS IN ('SUBMITTED') AND B.EWDHH_CREATED_ON BETWEEN STR_TO_DATE('01/04/2023 12:01','%d/%m/%Y %H:%i') AND STR_TO_DATE('11/06/2024 23:59','%d/%m/%Y %H:%i');


select *  from ezc_master_key_values where EMKV_MASTER_TYPE='V_COUNTRY' and EMKV_VALUE1= 'HS';

select * from ezc_customer_form_header;

select * from ezc_qcf_comments where EQC_CODE = '713876' and eqc_user = 'RAVIH' and EQC_COMMENT_NO not in ('1');


=====================
NA STATS
=======

select distinct(ECFH_SALES_ORG) from ezc_customer_form_header;
select * from ezc_customer_form_header where ECFH_SALES_ORG='9000';
select  distinct(ERH_PUR_ORG) from ezc_rfq_header where  ERH_PUR_ORG
select distinct(EAH_PLANT) from ezc_auction_header where  ERH_PUR_ORG

===========
While sending RFQ template from AT portal  to the vendor to upload the data in the initial stage vendor has been categorized has Packing material Vendor, while the data gone to Finance Corporate, Recon account has been selected since no seperate catogory of the vendor is available for Packing material , Hence Raw material Recon account has been selected since it is considered common for both Raw material and Packing material, Once the vendor code is approved by default the vendor code will be created in  Packing material Vendor code series only 

'714508', '3', 'KSMITHA', '2025-03-08 08:16:16', 'While sending RFQ template from AT portal  to the vendor to upload the data in the initial stage vendor has been categorized has Packing material Vendor, while the data gone to Finance Corporate, Recon account has been selected since no seperate catogory of the vendor is available for Packing material , Hence Raw material Recon account has been selected since it is considered common for both Raw material and Packing material, Once the vendor code is approved by default the vendor code will be created in  Packing material Vendor code series only ', '', 'VNR', '', 'DSUDHAKAR', 'REPLY', '-1', '', ''

 
 
Audit 2025

============

JGL Users
===========
select EWWU_USER,EU_FIRST_NAME,EU_EMAIL,EU_CREATED_DATE from ezc_users,ezc_wf_workgroup_users where eu_id = EWWU_USER and 
eu_type = '2' and EU_DELETION_FLAG = 'N' and EWWU_SYSKEY in ('999800') order by STR_TO_DATE(EU_CREATED_DATE,'%m/%d/%Y') desc;

North America Users
===========
select EWWU_USER,EU_FIRST_NAME,EU_EMAIL,EU_CREATED_DATE from ezc_users,ezc_wf_workgroup_users where eu_id = EWWU_USER and 
eu_type = '2' and EU_DELETION_FLAG = 'N' and EWWU_SYSKEY not in ('999800') order by STR_TO_DATE(EU_CREATED_DATE,'%m/%d/%Y') desc;
  
  
 ======================
 
 RFQ ITEM UPDATE:
 =================
 
 
 select * from ezc_rfq_prs where ERP_QCF_NO = '3050001895' and ERP_RFQ_LINE_NO = '20';
 select * from ezc_rfq_quote_history where ERQH_RFQ_NO in (select ERH_RFQ_NO from ezc_rfq_header where ERH_COLLETIVE_RFQ_NO = '3050001895') and ERQH_LINE_NO = '20';
 select * from ezc_rfq_item_conditions where ERIC_RFQ_NO in (select ERH_RFQ_NO from ezc_rfq_header where ERH_COLLETIVE_RFQ_NO = '3050001895') and ERIC_LINE_NO = '30';
 select * from ezc_rfq_details where ERD_RFQ_NO in (select ERH_RFQ_NO from ezc_rfq_header where ERH_COLLETIVE_RFQ_NO = '3050001895') and ERD_LINE_NO = '30';
 select * from ezc_rfq_header where ERH_COLLETIVE_RFQ_NO = '3050001895';
 
 
 --update ezc_rfq_quote_history set  ERQH_LINE_NO='90' where ERQH_RFQ_NO in (select ERH_RFQ_NO from ezc_rfq_header where ERH_COLLETIVE_RFQ_NO = '3050001895') and ERQH_LINE_NO = '100';
 --update ezc_rfq_item_conditions set  ERIC_LINE_NO='90' where ERIC_RFQ_NO in (select ERH_RFQ_NO from ezc_rfq_header where ERH_COLLETIVE_RFQ_NO = '3050001895') and ERIC_LINE_NO = '100';
--update ezc_rfq_details set ERD_LINE_NO = '90' where ERD_RFQ_NO in (select ERH_RFQ_NO from ezc_rfq_header where ERH_COLLETIVE_RFQ_NO = '3050001895') and ERD_LINE_NO = '100';
 
 
 
 AUCTION UPDATE:
 =================
 select * from ezc_auction_header where EAH_AUCTION_ID='2366';
  select * from ezc_auction_history where EAH_AUCTION_ID='2366' and EAH_AUCTION_value='950000.000000000000000';
 --update ezc_auction_history set eah_auction_value='96000.000000000000000' where EAH_AUCTION_ID='2366' and EAH_AUCTION_value='950000.000000000000000';
 
 
 Retrieve active Vendors and Internal Users:
 ===========================================
 
select distinct EU_ID,EU_FIRST_NAME,EU_EMAIL from ezc_users,ezc_user_defaults  
where EU_ID=EUD_USER_ID AND  EU_DELETION_FLAG IN ('N') AND EU_TYPE IN ('3','4') AND EU_EMAIL NOT IN ('');

select distinct EU_ID,EU_FIRST_NAME,EU_EMAIL from ezc_users,ezc_user_defaults  
where EU_ID=EUD_USER_ID AND  EU_DELETION_FLAG IN ('N') AND EU_TYPE IN ('2') AND EU_EMAIL NOT IN ('');

Auction End Time Extension:
============================

In EZC_AUCTION_HEADER, 
-> edit EAH_END_DATE, 
-> edit EAH_AUCTION as 'E'

Multi-Factor Authentication- Unblocking User:
=============================================

select * from ezc_otp_store where EOS_USER_ID='pnegi' order by EOS_EXPIRE_TIME desc;
-> Edit EOS_ACTIVE as 'Y' for the first Row.

Retreving all OTP blocked users for the current day:
====================================================

with RankedOTPs AS (select EOS_USER_ID,EOS_ACTIVE,EOS_EXPIRE_TIME, row_number() over (partition by EOS_USER_ID 
order by EOS_EXPIRE_TIME desc) AS rn from EZC_OTP_STORE where DATE(EOS_EXPIRE_TIME)=CURDATE()) 
select EOS_USER_ID from RankedOTPs where rn <= 3 GROUP BY EOS_USER_ID HAVING COUNT(*) = 3 AND SUM(CASE WHEN EOS_ACTIVE='N' 
THEN 1 ELSE 0 END) = 3;

Retrieving portal logged in user in last six months
======================================================
Getting NA Users:
select distint(ebpa_user_id) from ezc_buss_partner_areas where EBPA_USER_ID in (select EU_ID from ezc_users where EU_TYPE='2' and EU_DELETION_FLAG not in ('B')) and EBPA_SYS_KEY not in ('999800');
Getting India Users
select distinct(EBPA_USER_ID) from ezc_buss_partner_areas where EBPA_USER_ID in (select EU_ID from ezc_users where EU_TYPE='2' and EU_DELETION_FLAG not in ('B')) and EBPA_SYS_KEY in ('999800');
For NA::::::
	select distinct(EWS_USER_ID) from ezc_web_stats where EWS_LOGGED_IN between '2025-04-01 00:00:00' and NOW() and EWS_USER_ID in ('FRAJPUT','RMARINO','GPARRAGA','EBENEVENTO','KHOQUE','HVAGHELA','MBERNARD','KKHAITAN','EKROENCKE','SSHRIVASTA','SVANHEESBE','GTUTEJA','DWARNER','INANDI','KLERNER','KBEAUCHEMI','GASHTON','HSWILSON','GRNATARAJ','DCOSGOOD','NSINGLA','BFMOLDEN','JLBEELER','KBELINDA','FKRISTEN','MBRIEN','GHASSAN','RBENRAIS','ABOUTELDJA','ZTIZI','MDAOUST','ASTONGE','MSOULIERES','KNICOLE','SUNGUR','TFONZO','ETURCOTTE','GSECONDI','DROGERS','JWILKINSON','LJOHN','GWILLIAM','LWANDA','GLAURENT','IELIZABETH','MBOUNDS','RILEYCH','NICKPL','CHRISTIANA','KLISA','KSACHIN','VILASS','CRYSTALB','EMILYMD','KDESAI','KPAUL','SIDHARTHAR','MKATHLEEN','ALEXANDERW','RROBERT','LCIERRRA','ANGELAM','LJLYLE','AEERICH','JMRUIZ','CHSEAN','GHMICHAEL','JGASKIN','TAYLORS','CELIAOP','SCHROBERT','CJENNIFER','CPETER','MSMITH','CJFOOTE','MSMOSS','FOROMAN','ALGOLDBERG','JWKING','HMBLACK','CAUNRUH','CCPIERCE','KMIKEROVA2','MAGUPTA2','KMBDURGAN','TDHALL','TJWOLF','JVCHERNYAV','SABRIGHT','BRJACK','JOSEPHL','LGRUGER','CNICHOLAS','WDONALD','MCERIC','SMITCHELL1','DLPAYTON','KCOOPER','VBAJPAI','CDANIELS','AEROS','EDUVAL','CTHIBAULT','BKAMAL','TKASIMTSEV','KMAINOR','TPANKAJ','MTORRES','JPALMA','BBELLAMY','MSONI','SCMCREATOR','FKEVIN','GAVINASH','OSCARCO');
For India::::::
	select distinct(EWS_USER_ID) from ezc_web_stats where EWS_LOGGED_IN between '2025-04-01 00:00:00' and NOW() and EWS_USER_ID in ('PNEGI','PANAND','DEBAMOYM','SSETH','JSOOD','ATHAKUR1','DSINGH3','SATENDRAS','RHOON','ANUJJ','PARORA','MKUMAR3','KVASHISTHA','AJHA','NGARG','STHOMAS','AKUMARI','AANITHA','BHARUN','MJGIRISH','RKHAN','GIRISHB','NARAYANK','SRINIVASRE','RAMESHKP','KSMITHA','MKUMAR7','YUVARAJN','DSUDHAKAR','NJAISWAL','TUSHARM','AVERMA','KARTHIKG','KUMARR','GINESHP','AUDITTEAM','NVSHARMA','ASHISHJ','PSHARMA3','RSHARMA2','RTHAKUR1','LSINGH2','DJAISWAL','NAVEENK','ADWIVEDI','AGUPTA4','TMAHESHWAR','KHADAKS','SUNDERG','JAGDISHM','GPERFETTI','NJAIN','BTHOMAS','CSINGH','NAMRUTKAR','SESSIONUSR','NITHINSR','TEST_RRK','GKUMAR7','ABARUAH','NGUPTA1','DELOITTE','AMANJULA','NYADAV','MAGGARWAL','RAVIH','JAIDEVR','JYOTIM','DSATAPATHY','KJAIN','PRAVEENK','AKSHARMA','NARESHK','MSIKARWAR','SYADAV2','GPANWAR','SANTHOSHA1','MSINGH4','SMANSI','SKUMAR3','JPAREKH','GSAURABH','BHUPENDRAS','SCHAUDHARY','VAIBHAVS','AKUMAR','RARUL','SAGGARWAL','VJAGADEESH','DRAO','KASHISH','HPRANESH','BNSANJAY','VINODP','AKUMAR24','VGUPTA','BMUKUL','USINGH1','AMOHNOT','KGUPTA','SPATHAK','ASINGHAL','JRATHI','BHASKARB','PKUMAR11','LBAUDIT','FIAUDIT','SHDAUDIT','LOKESHAM','RAJESHDR','SRIDHARA','MAKINSANMI','AMRIENER','VSHARMA2','ANUSHREEP','HSHANKAR','BSTAKKAR','SUNNYG');
	
	
	
	
	
	
	
	***************************************************************************************************************************************************
	Vendor Deletion Quries- 30-01-26
	
*********************************************************************************************************
select * from ezc_users where EU_ID='715199';
select * from ezc_user_auth where EUA_USER_ID='715199';
select * from ezc_user_defaults where EUD_USER_ID='715199';
select * from ezc_wf_workgroup_users where EWWU_USER='715199';
select * from ezc_customer_form_header where ECFH_DOC_ID='715199';
select * from ezc_customer_form_details where ECFD_DOC_ID='715199';
select * from ezc_wf_doc_history_header where EWDHH_DOC_ID='715199';
select * from ezc_document_comments where EDC_DOC_ID='715199';
