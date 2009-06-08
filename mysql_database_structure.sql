-- MySQL dump 10.10
--
-- Host: 192.168.2.2    Database: edgarapi_live
-- ------------------------------------------------------
-- Server version	5.0.75-0ubuntu10.2-log

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
-- Table structure for table `_croc_company_matches`
--

DROP TABLE IF EXISTS `_croc_company_matches`;
CREATE TABLE `_croc_company_matches` (
  `id` int(11) NOT NULL auto_increment,
  `name1` varchar(255) default NULL,
  `name2` varchar(255) default NULL,
  `score` decimal(5,2) default NULL,
  `id_a` varchar(25) default NULL,
  `id_b` varchar(25) default NULL,
  `match_type` varchar(10) default NULL,
  `match` int(1) default '0',
  PRIMARY KEY  (`id`),
  KEY `id1` (`name1`),
  KEY `id2` (`name2`),
  KEY `score` (`score`)
) ENGINE=MyISAM AUTO_INCREMENT=1374 DEFAULT CHARSET=latin1;


--
-- Table structure for table `api_requests`
--

DROP TABLE IF EXISTS `api_requests`;
CREATE TABLE `api_requests` (
  `id` int(11) NOT NULL auto_increment,
  `api_key` varchar(60) default NULL,
  `url` varchar(100) NOT NULL,
  `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `ip_address` varchar(100) NOT NULL,
  `limit` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `timestamp` (`timestamp`),
  KEY `key` (`api_key`),
  KEY `ip_address` (`ip_address`)
) ENGINE=MyISAM AUTO_INCREMENT=91167 DEFAULT CHARSET=latin1;

--
-- Table structure for table `bad_locations`
--

DROP TABLE IF EXISTS `bad_locations`;
CREATE TABLE `bad_locations` (
  `id` int(11) NOT NULL auto_increment,
  `company` varchar(300) NOT NULL,
  `location` varchar(300) NOT NULL,
  `filing_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `filing_id` (`filing_id`)
) ENGINE=MyISAM AUTO_INCREMENT=50861 DEFAULT CHARSET=latin1;

--
-- Table structure for table `bigram_freq`
--

DROP TABLE IF EXISTS `bigram_freq`;
CREATE TABLE `bigram_freq` (
  `bigram` varchar(255) NOT NULL,
  `count` int(11) default NULL,
  `weight` float default NULL,
  PRIMARY KEY  (`bigram`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `cik_name_lookup`
--

DROP TABLE IF EXISTS `cik_name_lookup`;
CREATE TABLE `cik_name_lookup` (
  `row_id` int(11) NOT NULL auto_increment,
  `edgar_name` varchar(255) default NULL,
  `cik` int(11) default NULL,
  `match_name` varchar(255) default NULL,
  PRIMARY KEY  (`row_id`),
  KEY `edgarname` (`edgar_name`),
  KEY `edgarid` (`cik`),
  KEY `match_name` (`match_name`),
  KEY `cik` (`cik`)
) ENGINE=MyISAM AUTO_INCREMENT=405631 DEFAULT CHARSET=utf8 COMMENT='all known names from file cik.coleft.c';

--
-- Table structure for table `companies`
--

DROP TABLE IF EXISTS `companies`;
CREATE TABLE `companies` (
  `row_id` int(11) NOT NULL auto_increment,
  `cw_id` varchar(25) default NULL,
  `cik` int(11) default NULL,
  `company_name` varchar(255) default NULL,
  `irs_number` int(11) default NULL,
  `best_location_id` int(11) default NULL,
  `sic_category` int(11) default NULL,
  `industry_name` varchar(100) default NULL,
  `sic_sector` char(4) default NULL,
  `sector_name` varchar(100) default NULL,
  `source_type` varchar(25) default NULL,
  `source_id` int(11) default NULL,
  `num_parents` int(11) default NULL,
  `num_children` int(11) default NULL,
  `top_parent_id` varchar(25) default NULL,
  `most_recent_year` int(11) default NULL,
  `least_recent_year` int(11) default NULL,
  `best_filing_id` int(11) default NULL,
  KEY `row_index` (`row_id`),
  KEY `nameindex` (`company_name`),
  KEY `irsindex` (`irs_number`),
  KEY `sicindex` (`sic_category`),
  KEY `sourceindex` (`source_type`),
  KEY `cikindex` (`cik`),
  KEY `cw_id_index` (`cw_id`),
  KEY `top_parent_id` (`top_parent_id`)
) ENGINE=MyISAM AUTO_INCREMENT=236648 DEFAULT CHARSET=utf8 COMMENT='table of entities that we treat as independent companies';

--
-- Table structure for table `company_filings`
--

DROP TABLE IF EXISTS `company_filings`;
CREATE TABLE `company_filings` (
  `cw_id` varchar(30) NOT NULL,
  `filing_id` int(11) NOT NULL,
  `company_is_filer` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  USING BTREE (`cw_id`,`filing_id`),
  KEY `filing_id` (`filing_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `company_locations`
--

DROP TABLE IF EXISTS `company_locations`;
CREATE TABLE `company_locations` (
  `location_id` int(11) NOT NULL auto_increment,
  `cw_id` varchar(25) NOT NULL,
  `date` date default NULL,
  `type` varchar(15) default NULL,
  `raw_address` varchar(500) default NULL,
  `street_1` varchar(300) default NULL,
  `street_2` varchar(300) default NULL,
  `city` varchar(100) default NULL,
  `state` varchar(40) default NULL,
  `postal_code` varchar(11) default NULL,
  `country` varchar(100) default NULL,
  `country_code` char(2) default NULL,
  `subdiv_code` char(3) default NULL,
  PRIMARY KEY  (`location_id`),
  KEY `cwindex` (`cw_id`),
  KEY `country_code` (`country_code`),
  KEY `subdiv_code` (`subdiv_code`)
) ENGINE=MyISAM AUTO_INCREMENT=297724 DEFAULT CHARSET=utf8 COMMENT='allows each company to have multiple locations associated wi';

--
-- Table structure for table `company_names`
--

DROP TABLE IF EXISTS `company_names`;
CREATE TABLE `company_names` (
  `name_id` int(11) NOT NULL auto_increment,
  `cw_id` varchar(25) NOT NULL,
  `name` varchar(300) default NULL,
  `date` date default NULL,
  `source` varchar(30) NOT NULL,
  `source_row_id` int(11) NOT NULL,
  PRIMARY KEY  (`name_id`),
  KEY `cwidindex` (`cw_id`),
  KEY `name_index` (`name`),
  KEY `dateindex` (`date`),
  FULLTEXT KEY `full` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=342976 DEFAULT CHARSET=utf8 COMMENT='This table allows for each company to have multiple name var';

--
-- Table structure for table `company_relations`
--

DROP TABLE IF EXISTS `company_relations`;
CREATE TABLE `company_relations` (
  `relation_id` int(11) NOT NULL auto_increment COMMENT 'not the same a s relationship_id',
  `source_cw_id` varchar(25) default NULL,
  `target_cw_id` varchar(25) default NULL,
  `relation_type` varchar(25) default NULL,
  `relation_origin` varchar(25) default NULL,
  `origin_id` int(11) default NULL,
  PRIMARY KEY  (`relation_id`),
  KEY `source` (`source_cw_id`),
  KEY `targer` (`target_cw_id`),
  KEY `originid` (`origin_id`)
) ENGINE=MyISAM AUTO_INCREMENT=160829 DEFAULT CHARSET=utf8;

--
-- Table structure for table `country_adjectives`
--

DROP TABLE IF EXISTS `country_adjectives`;
CREATE TABLE `country_adjectives` (
  `id` int(11) NOT NULL auto_increment,
  `Name` varchar(600) default NULL,
  `Adjective` varchar(600) default NULL,
  `country_code` char(2) default NULL,
  `subdiv_code` char(3) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=281 DEFAULT CHARSET=latin1;

--
-- Table structure for table `croc_companies`
--

DROP TABLE IF EXISTS `croc_companies`;
CREATE TABLE `croc_companies` (
  `row_id` int(11) NOT NULL auto_increment,
  `croc_company_id` varchar(255) default NULL,
  `croc_company_name` varchar(255) default NULL,
  `cik` int(11) default NULL,
  `has_sec_21` tinyint(1) default NULL,
  `parsed_badly` tinyint(1) default NULL,
  `cw_id` varchar(20) default NULL,
  PRIMARY KEY  (`row_id`),
  KEY `companyid` (`croc_company_id`),
  KEY `companyname` (`croc_company_name`)
) ENGINE=MyISAM AUTO_INCREMENT=1281 DEFAULT CHARSET=utf8 COMMENT='dump of companies corpwatch is interested in as of 2009-1-15';

--
-- Table structure for table `cw_id_lookup`
--

DROP TABLE IF EXISTS `cw_id_lookup`;
CREATE TABLE `cw_id_lookup` (
  `cw_id` varchar(25) collate latin1_general_ci NOT NULL default '',
  `company_name` varchar(255) collate latin1_general_ci default NULL,
  `cik` int(11) default NULL,
  `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`cw_id`),
  KEY `company_name` (`company_name`),
  KEY `cik` (`cik`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Table structure for table `filers`
--

DROP TABLE IF EXISTS `filers`;
CREATE TABLE `filers` (
  `filer_id` int(11) NOT NULL auto_increment,
  `filing_id` int(11) NOT NULL,
  `cik` int(11) default NULL,
  `irs_number` int(11) default NULL,
  `conformed_name` varchar(300) character set latin1 default NULL,
  `fiscal_year_end` smallint(6) default NULL,
  `sic_code` int(11) default NULL,
  `business_street_1` varchar(300) character set latin1 default NULL,
  `business_street_2` varchar(300) character set latin1 default NULL,
  `business_city` varchar(100) character set latin1 default NULL,
  `business_state` varchar(40) character set latin1 default NULL,
  `business_zip` varchar(11) character set latin1 default NULL,
  `mail_street_1` varchar(300) character set latin1 default NULL,
  `mail_street_2` varchar(300) character set latin1 default NULL,
  `mail_city` varchar(100) character set latin1 default NULL,
  `mail_state` varchar(40) character set latin1 default NULL,
  `mail_zip` varchar(11) character set latin1 default NULL,
  `form_type` varchar(10) character set latin1 default NULL,
  `sec_act` varchar(30) character set latin1 default NULL,
  `sec_file_number` varchar(30) character set latin1 default NULL,
  `film_number` int(11) default NULL,
  `former_name` varchar(300) character set latin1 default NULL,
  `name_change_date` varchar(15) character set latin1 default NULL,
  `state_of_incorporation` varchar(40) character set latin1 default NULL,
  `business_phone` varchar(30) character set latin1 default NULL,
  `match_name` varchar(300) default NULL,
  `incorp_country_code` char(2) character set latin1 default NULL,
  `incorp_subdiv_code` char(3) character set latin1 default NULL,
  `cw_id` varchar(25) character set latin1 default NULL,
  PRIMARY KEY  (`filer_id`),
  KEY `clean_name` (`match_name`),
  KEY `cik` (`cik`),
  KEY `corp_country` (`incorp_country_code`),
  KEY `corp_subdiv` (`incorp_subdiv_code`),
  KEY `cw_id` (`cw_id`)
) ENGINE=MyISAM AUTO_INCREMENT=72173 DEFAULT CHARSET=utf8;

--
-- Table structure for table `filing_tables`
--

DROP TABLE IF EXISTS `filing_tables`;
CREATE TABLE `filing_tables` (
  `filing_table_id` int(11) NOT NULL auto_increment,
  `filing_id` int(11) NOT NULL default '0',
  `table_num` int(11) NOT NULL default '0',
  `num_rows` int(11) NOT NULL default '0',
  `num_cols` int(11) NOT NULL default '0',
  `headers` varchar(600) character set latin1 NOT NULL default '0',
  `parsed` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`filing_table_id`),
  KEY `filing_id` (`filing_id`),
  KEY `table_num` (`table_num`)
) ENGINE=MyISAM AUTO_INCREMENT=2625 DEFAULT CHARSET=utf8;

--
-- Table structure for table `filings`
--

DROP TABLE IF EXISTS `filings`;
CREATE TABLE `filings` (
  `filing_id` int(11) NOT NULL auto_increment,
  `filing_date` date NOT NULL,
  `type` varchar(36) NOT NULL,
  `company_name` varchar(300) default NULL,
  `filename` varchar(300) NOT NULL,
  `cik` int(11) NOT NULL,
  `has_sec21` tinyint(1) NOT NULL default '0',
  `year` smallint(6) NOT NULL,
  `quarter` tinyint(4) NOT NULL,
  `has_html` tinyint(1) NOT NULL default '0',
  `num_tables` int(11) NOT NULL default '0',
  `num_rows` int(11) NOT NULL default '0',
  `tables_parsed` int(11) NOT NULL default '0',
  `rows_parsed` int(11) NOT NULL default '0',
  `period_of_report` int(11) default NULL,
  `date_filed` int(11) default NULL,
  `date_changed` int(11) default NULL,
  `sec_21_url` varchar(255) default NULL,
  PRIMARY KEY  (`filing_id`),
  KEY `has_sec21` (`has_sec21`),
  KEY `filename` (`filename`),
  KEY `type` (`type`),
  KEY `quarter` (`quarter`),
  KEY `year` (`year`),
  KEY `cik` (`cik`),
  KEY `name` (`company_name`)
) ENGINE=MyISAM AUTO_INCREMENT=1014729 DEFAULT CHARSET=latin1;

--
-- Table structure for table `fortune1000`
--

DROP TABLE IF EXISTS `fortune1000`;
CREATE TABLE `fortune1000` (
  `id` int(11) NOT NULL auto_increment,
  `Rank` varchar(600) default NULL,
  `Name` varchar(600) default NULL,
  `Revenue` varchar(600) default NULL,
  `Profit` varchar(600) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1001 DEFAULT CHARSET=latin1;

--
-- Table structure for table `no_relationship_filings`
--

DROP TABLE IF EXISTS `no_relationship_filings`;
CREATE TABLE `no_relationship_filings` (
  `id` int(11) NOT NULL auto_increment,
  `filing_id` varchar(600) default NULL,
  `cik` varchar(600) default NULL,
  `company_name` varchar(600) default NULL,
  `code` varchar(600) default NULL,
  `blank` varchar(600) default NULL,
  `1___none` varchar(600) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=420 DEFAULT CHARSET=latin1;

--
-- Table structure for table `not_company_names`
--

DROP TABLE IF EXISTS `not_company_names`;
CREATE TABLE `not_company_names` (
  `name` varchar(250) NOT NULL,
  PRIMARY KEY  (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `parsing_stop_terms`
--

DROP TABLE IF EXISTS `parsing_stop_terms`;
CREATE TABLE `parsing_stop_terms` (
  `term` varchar(250) NOT NULL,
  PRIMARY KEY  (`term`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `parsing_tests`
--

DROP TABLE IF EXISTS `parsing_tests`;
CREATE TABLE `parsing_tests` (
  `id` int(11) NOT NULL auto_increment,
  `cik` varchar(600) default NULL,
  `has_hierarchy` varchar(600) default NULL,
  `has_multiple_values` varchar(600) default NULL,
  `has_percentage` varchar(600) default NULL,
  `notes` varchar(600) default NULL,
  `assumed_name` varchar(600) default NULL,
  `original_companies` int(11) NOT NULL,
  `matched_companies` int(11) NOT NULL,
  `orphaned_original_companies` int(11) NOT NULL,
  `orphaned_relationship_companies` int(11) NOT NULL,
  `orphaned_original_companies_no_location` int(11) NOT NULL,
  `relationship_companies` int(11) NOT NULL,
  `mismatched_locations` int(11) NOT NULL,
  `filing_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=27 DEFAULT CHARSET=latin1;

--
-- Table structure for table `region_codes`
--

DROP TABLE IF EXISTS `region_codes`;
CREATE TABLE `region_codes` (
  `code` char(2) NOT NULL default '',
  `region_name` varchar(100) default NULL,
  `type` varchar(25) default NULL,
  `country_code` char(2) default NULL,
  `subdiv_code` char(3) default NULL,
  PRIMARY KEY  (`code`),
  KEY `regionname` (`region_name`),
  KEY `contrycode` (`country_code`),
  KEY `subdiv` (`subdiv_code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='country and state codes as used in the edgar db';

--
-- Table structure for table `relationships`
--

DROP TABLE IF EXISTS `relationships`;
CREATE TABLE `relationships` (
  `relationship_id` int(11) NOT NULL auto_increment,
  `company_name` varchar(300) default NULL,
  `location` varchar(200) NOT NULL,
  `filing_id` int(11) NOT NULL,
  `country_code` char(2) character set latin1 default NULL,
  `subdiv_code` char(3) character set latin1 default NULL,
  `clean_company` varchar(300) default NULL,
  `cik` int(11) default NULL,
  `ignore_record` tinyint(1) default '0',
  `parse_method` varchar(100) default NULL,
  `hierarchy` int(11) default '0',
  `percent` int(11) default NULL,
  `parent_cw_id` varchar(25) default NULL,
  `cw_id` varchar(25) default NULL,
  PRIMARY KEY  (`relationship_id`),
  KEY `location` (`location`),
  KEY `country` (`country_code`),
  KEY `subdiv` (`subdiv_code`),
  KEY `clean_company` (`clean_company`),
  KEY `cik` (`cik`),
  KEY `filing_id` (`filing_id`),
  KEY `cw_id` (`cw_id`),
  KEY `parent_cw_id` (`parent_cw_id`)
) ENGINE=MyISAM AUTO_INCREMENT=167819 DEFAULT CHARSET=utf8;

--
-- Table structure for table `sic_codes`
--

DROP TABLE IF EXISTS `sic_codes`;
CREATE TABLE `sic_codes` (
  `sic_code` char(4) NOT NULL,
  `industry_name` varchar(100) default NULL,
  `sic_sector` char(4) default NULL,
  PRIMARY KEY  (`sic_code`),
  KEY `sic_sector` (`sic_sector`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `sic_sectors`
--

DROP TABLE IF EXISTS `sic_sectors`;
CREATE TABLE `sic_sectors` (
  `sic_sector` char(4) NOT NULL,
  `sector_name` varchar(100) default NULL,
  `sector_group` int(11) default NULL,
  `sector_group_name` varchar(100) default NULL,
  PRIMARY KEY  (`sic_sector`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `stock_codes`
--

DROP TABLE IF EXISTS `stock_codes`;
CREATE TABLE `stock_codes` (
  `stock_name` varchar(255) default NULL,
  `ticker_code` char(5) NOT NULL,
  `exchange` char(6) default NULL,
  `cw_id` varchar(20) default NULL,
  PRIMARY KEY  (`ticker_code`),
  KEY `name` (`stock_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='comp nams and tick symbol from google';

--
-- Table structure for table `un_countries`
--

DROP TABLE IF EXISTS `un_countries`;
CREATE TABLE `un_countries` (
  `country_code` char(2) NOT NULL,
  `country_name` varchar(255) default NULL,
  `row_id` int(11) NOT NULL auto_increment,
  `latitude` double default NULL,
  `longitude` double default NULL,
  PRIMARY KEY  (`row_id`),
  KEY `countrycode` (`country_code`),
  KEY `countryname` (`country_name`)
) ENGINE=MyISAM AUTO_INCREMENT=245 DEFAULT CHARSET=utf8 COMMENT='countries from unlocode standard';

--
-- Table structure for table `un_country_aliases`
--

DROP TABLE IF EXISTS `un_country_aliases`;
CREATE TABLE `un_country_aliases` (
  `country_code` char(2) default NULL,
  `country_name` varchar(255) NOT NULL default '',
  `subdiv_code` char(3) default NULL,
  PRIMARY KEY  (`country_name`),
  KEY `countrycode` (`country_code`),
  KEY `country_name` (`country_name`),
  KEY `subdivcode` (`subdiv_code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='alternate wordings of country names';

--
-- Table structure for table `un_country_subdivisions`
--

DROP TABLE IF EXISTS `un_country_subdivisions`;
CREATE TABLE `un_country_subdivisions` (
  `country_code` char(2) default NULL,
  `subdivision_code` char(3) default NULL,
  `subdivision_name` varchar(255) default NULL,
  `remarks` varchar(255) default NULL,
  `row_id` int(11) NOT NULL auto_increment,
  `dupe` tinyint(1) NOT NULL default '0',
  `latitude` double default NULL,
  `longitude` double default NULL,
  PRIMARY KEY  (`row_id`),
  KEY `countycode` (`country_code`),
  KEY `subdiv` (`subdivision_code`),
  KEY `subdivname` (`subdivision_name`)
) ENGINE=MyISAM AUTO_INCREMENT=968 DEFAULT CHARSET=utf8;

--
-- Table structure for table `unlocode`
--

DROP TABLE IF EXISTS `unlocode`;
CREATE TABLE `unlocode` (
  `loc_id` int(11) NOT NULL auto_increment,
  `country_code` char(2) NOT NULL,
  `loc_code` char(3) default NULL,
  `location_name_diacrit` varchar(255) default NULL,
  `location_name` varchar(255) default NULL,
  `subdivision_code` char(3) default NULL,
  `function` char(8) default NULL,
  `status` char(2) default NULL,
  `date` char(4) default NULL,
  `iata_code` char(3) default NULL,
  `coordinates` char(15) default NULL,
  `remarks` varchar(100) default NULL,
  PRIMARY KEY  (`loc_id`),
  KEY `locname` (`location_name`),
  KEY `locnamedi` (`location_name_diacrit`),
  KEY `loccode` (`loc_code`),
  KEY `country` (`country_code`)
) ENGINE=MyISAM AUTO_INCREMENT=57093 DEFAULT CHARSET=utf8;

--
-- Table structure for table `word_freq`
--

DROP TABLE IF EXISTS `word_freq`;
CREATE TABLE `word_freq` (
  `word` varchar(255) NOT NULL,
  `count` int(11) default NULL,
  `weight` float default NULL,
  PRIMARY KEY  (`word`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='counts of word occurences in the list of edgar entity names';
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2009-06-08  4:51:33
