-- phpMyAdmin SQL Dump
-- version 4.8.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: 19-Set-2018 às 04:44
-- Versão do servidor: 10.1.33-MariaDB
-- PHP Version: 7.2.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_ecommerce`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_addresses_save` (`pidaddress` INT(11), `pidperson` INT(11), `pdesaddress` VARCHAR(128), `pdesnumber` VARCHAR(16), `pdescomplement` VARCHAR(32), `pdescity` VARCHAR(32), `pdesstate` VARCHAR(32), `pdescountry` VARCHAR(32), `pdeszipcode` CHAR(8), `pdesdistrict` VARCHAR(32))  BEGIN

	IF pidaddress > 0 THEN
		
		UPDATE tb_addresses
        SET
			idperson = pidperson,
            desaddress = pdesaddress,
            desnumber = pdesnumber,
            descomplement = pdescomplement,
            descity = pdescity,
            desstate = pdesstate,
            descountry = pdescountry,
            deszipcode = pdeszipcode, 
            desdistrict = pdesdistrict
		WHERE idaddress = pidaddress;
        
    ELSE
		
		INSERT INTO tb_addresses (idperson, desaddress, desnumber, descomplement, descity, desstate, descountry, deszipcode, desdistrict)
        VALUES(pidperson, pdesaddress, pdesnumber, pdescomplement, pdescity, pdesstate, pdescountry, pdeszipcode, pdesdistrict);
        
        SET pidaddress = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_addresses WHERE idaddress = pidaddress;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_carts_save` (`pidcart` INT, `pdessessionid` VARCHAR(64), `piduser` INT, `pdeszipcode` CHAR(8), `pvlfreight` DECIMAL(10,2), `pnrdays` INT)  BEGIN

    IF pidcart > 0 THEN
        
        UPDATE tb_carts
        SET
            dessessionid = pdessessionid,
            iduser = piduser,
            deszipcode = pdeszipcode,
            vlfreight = pvlfreight,
            nrdays = pnrdays
        WHERE idcart = pidcart;
        
    ELSE
        
        INSERT INTO tb_carts (dessessionid, iduser, deszipcode, vlfreight, nrdays)
        VALUES(pdessessionid, piduser, pdeszipcode, pvlfreight, pnrdays);
        
        SET pidcart = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_carts WHERE idcart = pidcart;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_categories_save` (`pidcategory` INT, `pdescategory` VARCHAR(64))  BEGIN
	
	IF pidcategory > 0 THEN
		
		UPDATE tb_categories
        SET descategory = pdescategory
        WHERE idcategory = pidcategory;
        
    ELSE
		
		INSERT INTO tb_categories (descategory) VALUES(pdescategory);
        
        SET pidcategory = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_categories WHERE idcategory = pidcategory;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_orders_save` (`pidorder` INT, `pidcart` INT(11), `piduser` INT(11), `pidstatus` INT(11), `pidaddress` INT(11), `pvltotal` DECIMAL(10,2))  BEGIN
	
	IF pidorder > 0 THEN
		
		UPDATE tb_orders
        SET
			idcart = pidcart,
            iduser = piduser,
            idstatus = pidstatus,
            idaddress = pidaddress,
            vltotal = pvltotal
		WHERE idorder = pidorder;
        
    ELSE
    
		INSERT INTO tb_orders (idcart, iduser, idstatus, idaddress, vltotal)
        VALUES(pidcart, piduser, pidstatus, pidaddress, pvltotal);
		
		SET pidorder = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * 
    FROM tb_orders a
    INNER JOIN tb_ordersstatus b USING(idstatus)
    INNER JOIN tb_carts c USING(idcart)
    INNER JOIN tb_users d ON d.iduser = a.iduser
    INNER JOIN tb_addresses e USING(idaddress)
    WHERE idorder = pidorder;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_products_save` (`pidproduct` INT(11), `pdesproduct` VARCHAR(64), `pvlprice` DECIMAL(10,2), `pvlwidth` DECIMAL(10,2), `pvlheight` DECIMAL(10,2), `pvllength` DECIMAL(10,2), `pvlweight` DECIMAL(10,2), `pdesurl` VARCHAR(128))  BEGIN
	
	IF pidproduct > 0 THEN
		
		UPDATE tb_products
        SET 
			desproduct = pdesproduct,
            vlprice = pvlprice,
            vlwidth = pvlwidth,
            vlheight = pvlheight,
            vllength = pvllength,
            vlweight = pvlweight,
            desurl = pdesurl
        WHERE idproduct = pidproduct;
        
    ELSE
		
		INSERT INTO tb_products (desproduct, vlprice, vlwidth, vlheight, vllength, vlweight, desurl) 
        VALUES(pdesproduct, pvlprice, pvlwidth, pvlheight, pvllength, pvlweight, pdesurl);
        
        SET pidproduct = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_products WHERE idproduct = pidproduct;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_userspasswordsrecoveries_create` (`piduser` INT, `pdesip` VARCHAR(45))  BEGIN
	
	INSERT INTO tb_userspasswordsrecoveries (iduser, desip)
    VALUES(piduser, pdesip);
    
    SELECT * FROM tb_userspasswordsrecoveries
    WHERE idrecovery = LAST_INSERT_ID();
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usersupdate_save` (`piduser` INT, `pdesperson` VARCHAR(64), `pdeslogin` VARCHAR(64), `pdespassword` VARCHAR(256), `pdesemail` VARCHAR(128), `pnrphone` BIGINT, `pinadmin` TINYINT)  BEGIN
	
    DECLARE vidperson INT;
    
	SELECT idperson INTO vidperson
    FROM tb_users
    WHERE iduser = piduser;
    
    UPDATE tb_persons
    SET 
		desperson = pdesperson,
        desemail = pdesemail,
        nrphone = pnrphone
	WHERE idperson = vidperson;
    
    UPDATE tb_users
    SET
		deslogin = pdeslogin,
        despassword = pdespassword,
        inadmin = pinadmin
	WHERE iduser = piduser;
    
    SELECT * FROM tb_users a INNER JOIN tb_persons b USING(idperson) WHERE a.iduser = piduser;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_users_delete` (`piduser` INT)  BEGIN
    
    DECLARE vidperson INT;
    
    SET FOREIGN_KEY_CHECKS = 0;
	
	SELECT idperson INTO vidperson
    FROM tb_users
    WHERE iduser = piduser;
	
    DELETE FROM tb_addresses WHERE idperson = vidperson;
    DELETE FROM tb_addresses WHERE idaddress IN(SELECT idaddress FROM tb_orders WHERE iduser = piduser);
	DELETE FROM tb_persons WHERE idperson = vidperson;
    
    DELETE FROM tb_userslogs WHERE iduser = piduser;
    DELETE FROM tb_userspasswordsrecoveries WHERE iduser = piduser;
    DELETE FROM tb_orders WHERE iduser = piduser;
    DELETE FROM tb_cartsproducts WHERE idcart IN(SELECT idcart FROM tb_carts WHERE iduser = piduser);
    DELETE FROM tb_carts WHERE iduser = piduser;
    DELETE FROM tb_users WHERE iduser = piduser;
    
    SET FOREIGN_KEY_CHECKS = 1;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_users_save` (`pdesperson` VARCHAR(64), `pdeslogin` VARCHAR(64), `pdespassword` VARCHAR(256), `pdesemail` VARCHAR(128), `pnrphone` BIGINT, `pinadmin` TINYINT)  BEGIN
	
    DECLARE vidperson INT;
    
	INSERT INTO tb_persons (desperson, desemail, nrphone)
    VALUES(pdesperson, pdesemail, pnrphone);
    
    SET vidperson = LAST_INSERT_ID();
    
    INSERT INTO tb_users (idperson, deslogin, despassword, inadmin)
    VALUES(vidperson, pdeslogin, pdespassword, pinadmin);
    
    SELECT * FROM tb_users a INNER JOIN tb_persons b USING(idperson) WHERE a.iduser = LAST_INSERT_ID();
    
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_addresses`
--

CREATE TABLE `tb_addresses` (
  `idaddress` int(11) NOT NULL,
  `idperson` int(11) NOT NULL,
  `desaddress` varchar(128) NOT NULL,
  `desnumber` varchar(16) NOT NULL,
  `descomplement` varchar(32) DEFAULT NULL,
  `descity` varchar(32) NOT NULL,
  `desstate` varchar(32) NOT NULL,
  `descountry` varchar(32) NOT NULL,
  `deszipcode` char(8) NOT NULL,
  `desdistrict` varchar(32) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_addresses`
--

INSERT INTO `tb_addresses` (`idaddress`, `idperson`, `desaddress`, `desnumber`, `descomplement`, `descity`, `desstate`, `descountry`, `deszipcode`, `desdistrict`, `dtregister`) VALUES
(1, 12, 'Rua: Romeu Alves De Freitas, Casa, Casa, Casa, Casa, Casa, Casa', '333', 'Casa', 'Miguelópolis', 'SP', 'Brasil', '14530000', 'Sao Francisco', '2018-09-19 02:18:18'),
(2, 1, 'Rua Jose', '434335', 'Casa', 'Miguelópolis', 'SP', 'Brasil', '14530000', 'Maria Aparecida', '2018-09-19 02:21:37'),
(4, 12, 'Rua: Romeu Alves De Freitas,', '204', 'Casa', 'Miguelópolis', 'SP', 'Brasil', '14530000', 'Sao Francisco', '2018-09-19 02:38:45');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_carts`
--

CREATE TABLE `tb_carts` (
  `idcart` int(11) NOT NULL,
  `dessessionid` varchar(64) NOT NULL,
  `iduser` int(11) DEFAULT NULL,
  `deszipcode` char(8) DEFAULT NULL,
  `vlfreight` decimal(10,2) DEFAULT NULL,
  `nrdays` int(11) DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_carts`
--

INSERT INTO `tb_carts` (`idcart`, `dessessionid`, `iduser`, `deszipcode`, `vlfreight`, `nrdays`, `dtregister`) VALUES
(1, '8hcko3j7hmgp8sv7ggnseueupv', NULL, '22041080', NULL, 2, '2017-09-04 18:50:50'),
(2, 'm8iq807es95o2hj1a30772df1d', NULL, '21615338', '72.92', 2, '2017-09-06 13:12:50'),
(3, 'cl1s6p6ti29vns970emmbhe7tb', 7, NULL, NULL, NULL, '2017-09-06 13:46:15'),
(4, 'a8frnbabuqu60gguivlmrpagin', NULL, '01310100', '61.12', 1, '2017-09-08 11:39:01'),
(5, '51jglmd9n3cdirc1ah75m31pt1', NULL, NULL, NULL, NULL, '2017-09-14 11:26:39'),
(6, 'tlvjs3tas1bml5uit8b5qgjn9l', NULL, '01310100', '42.79', 1, '2017-09-21 13:18:21'),
(7, 'ej7nkq9o1s7oc814gt7oukvnd3', NULL, NULL, NULL, NULL, '2018-09-13 20:39:39'),
(8, 'r41hp97gsl8h1n5ibq34b5n7ej', NULL, '', NULL, NULL, '2018-09-17 18:30:59'),
(9, '4om90oh1igngn3corhj1ldac4b', NULL, NULL, NULL, NULL, '2018-09-17 18:52:35'),
(10, 'lo0065kv24i701tn7b60snodhf', NULL, NULL, NULL, NULL, '2018-09-17 22:11:22'),
(11, 'pk9kk4rkio20sle7mnkvdg732l', NULL, NULL, NULL, NULL, '2018-09-18 21:51:54'),
(12, 'pnjr9qj7p7utppmf0mg8r692qt', NULL, '', NULL, NULL, '2018-09-18 22:05:48'),
(13, 'eknsvaamv1cag2dc654hh7hgg9', NULL, '1453000', '68.48', 1, '2018-09-18 22:35:06'),
(14, 'kfts2h22v6b45r9m9jl8nd3s09', NULL, '14530000', '81.48', 3, '2018-09-19 01:51:20'),
(15, '2e00gqqpmchi4ju80q205kgtmt', NULL, '14530000', '81.48', 3, '2018-09-19 02:03:47'),
(16, 'blf0eeb1onpotv58tnce2vg8mb', NULL, '1453000', '0.00', 0, '2018-09-19 02:08:51'),
(17, 't2sojv3p89c9dhhos7t794mscd', NULL, NULL, NULL, NULL, '2018-09-19 02:10:40'),
(18, 'a6q53lebpjkadqdc00ba3scdqd', NULL, NULL, NULL, NULL, '2018-09-19 02:17:55'),
(19, 'ilokri1r54e36e2uapkosfr5e6', NULL, '14530000', '135.08', 3, '2018-09-19 02:20:21');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_cartsproducts`
--

CREATE TABLE `tb_cartsproducts` (
  `idcartproduct` int(11) NOT NULL,
  `idcart` int(11) NOT NULL,
  `idproduct` int(11) NOT NULL,
  `dtremoved` datetime DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_cartsproducts`
--

INSERT INTO `tb_cartsproducts` (`idcartproduct`, `idcart`, `idproduct`, `dtremoved`, `dtregister`) VALUES
(1, 1, 2, '2017-09-04 15:51:33', '2017-09-04 18:51:14'),
(2, 1, 2, '2017-09-04 15:52:09', '2017-09-04 18:51:31'),
(3, 1, 4, '2017-09-04 15:53:42', '2017-09-04 18:53:36'),
(4, 1, 4, '2017-09-04 15:54:11', '2017-09-04 18:53:40'),
(5, 1, 2, '2017-09-04 16:32:57', '2017-09-04 18:54:01'),
(6, 1, 2, '2017-09-04 16:33:04', '2017-09-04 19:31:05'),
(7, 1, 2, '2017-09-04 16:41:33', '2017-09-04 19:32:59'),
(8, 1, 2, '2017-09-04 16:41:38', '2017-09-04 19:33:02'),
(9, 1, 2, NULL, '2017-09-04 19:39:39'),
(10, 2, 2, '2017-09-06 10:21:57', '2017-09-06 13:20:44'),
(11, 2, 4, NULL, '2017-09-06 13:42:37'),
(12, 2, 4, NULL, '2017-09-06 15:28:56'),
(13, 4, 4, '2017-09-08 09:39:01', '2017-09-08 11:39:01'),
(14, 4, 4, NULL, '2017-09-08 12:27:38'),
(15, 4, 4, NULL, '2017-09-08 12:38:57'),
(16, 6, 4, NULL, '2017-09-21 13:59:32'),
(17, 7, 7, NULL, '2018-09-13 20:40:09'),
(18, 8, 7, NULL, '2018-09-17 18:31:03'),
(19, 8, 10, NULL, '2018-09-17 18:35:45'),
(20, 9, 10, NULL, '2018-09-17 18:52:41'),
(21, 10, 10, NULL, '2018-09-17 22:11:35'),
(22, 11, 14, NULL, '2018-09-18 21:52:49'),
(23, 12, 16, NULL, '2018-09-18 22:28:06'),
(24, 12, 20, NULL, '2018-09-18 22:28:17'),
(25, 13, 15, '2018-09-18 20:21:36', '2018-09-18 22:36:41'),
(26, 13, 17, '2018-09-18 20:22:53', '2018-09-18 23:21:42'),
(27, 13, 22, NULL, '2018-09-18 23:22:47'),
(28, 14, 19, NULL, '2018-09-19 01:51:34'),
(29, 15, 19, NULL, '2018-09-19 02:03:51'),
(30, 16, 18, NULL, '2018-09-19 02:09:06'),
(31, 17, 16, NULL, '2018-09-19 02:10:50'),
(32, 18, 17, NULL, '2018-09-19 02:17:59'),
(33, 19, 18, '2018-09-18 23:23:41', '2018-09-19 02:21:10'),
(34, 19, 18, '2018-09-18 23:24:45', '2018-09-19 02:24:26'),
(35, 19, 17, '2018-09-18 23:25:18', '2018-09-19 02:24:50'),
(36, 19, 15, '2018-09-18 23:25:22', '2018-09-19 02:25:13'),
(37, 19, 16, NULL, '2018-09-19 02:25:42');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_categories`
--

CREATE TABLE `tb_categories` (
  `idcategory` int(11) NOT NULL,
  `descategory` varchar(32) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_categories`
--

INSERT INTO `tb_categories` (`idcategory`, `descategory`, `dtregister`) VALUES
(5, 'Pneus', '2018-09-17 18:34:37'),
(6, 'Farol', '2018-09-18 22:26:57');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_orders`
--

CREATE TABLE `tb_orders` (
  `idorder` int(11) NOT NULL,
  `idcart` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `idstatus` int(11) NOT NULL,
  `idaddress` int(11) NOT NULL,
  `vltotal` decimal(10,2) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_orders`
--

INSERT INTO `tb_orders` (`idorder`, `idcart`, `iduser`, `idstatus`, `idaddress`, `vltotal`, `dtregister`) VALUES
(1, 18, 12, 1, 1, '279.00', '2018-09-19 02:18:18'),
(2, 19, 1, 1, 2, '105.99', '2018-09-19 02:21:37'),
(4, 19, 12, 1, 4, '705.07', '2018-09-19 02:38:47');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_ordersstatus`
--

CREATE TABLE `tb_ordersstatus` (
  `idstatus` int(11) NOT NULL,
  `desstatus` varchar(32) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_ordersstatus`
--

INSERT INTO `tb_ordersstatus` (`idstatus`, `desstatus`, `dtregister`) VALUES
(1, 'Em Aberto', '2017-03-13 03:00:00'),
(2, 'Aguardando Pagamento', '2017-03-13 03:00:00'),
(3, 'Pago', '2017-03-13 03:00:00'),
(4, 'Entregue', '2017-03-13 03:00:00');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_persons`
--

CREATE TABLE `tb_persons` (
  `idperson` int(11) NOT NULL,
  `desperson` varchar(64) NOT NULL,
  `desemail` varchar(128) DEFAULT NULL,
  `nrphone` bigint(20) DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_persons`
--

INSERT INTO `tb_persons` (`idperson`, `desperson`, `desemail`, `nrphone`, `dtregister`) VALUES
(1, 'João Rangel', 'admin@hcode.com.br', 2147483647, '2017-03-01 03:00:00'),
(7, 'Suporte', 'suporte@hcode.com.br', 1112345678, '2017-03-15 16:10:27'),
(8, '', '', 0, '2017-09-04 20:43:40'),
(9, 'Joao', 'joao@hcode.com.br', 12345678, '2017-09-04 20:50:02'),
(10, 'Hcode', 'suporte@hcode.com.br', 1112345678, '2017-09-06 14:32:15'),
(11, 'MATHEUS BATISTA DE ARAUJO PEREIRA', 'matheus147ka9@gmail.com', 16993282517, '2018-09-17 18:31:23'),
(12, 'matheus', 'matheusbatistaap@hotmail.com', 551638352628, '2018-09-17 22:11:58'),
(13, 'Joao das Neves', 'joao@gmail.com', 123556, '2018-09-18 21:53:17'),
(14, 'Maria', 'matheus147ka@gmail.com', 16993282517, '2018-09-19 00:11:32');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_products`
--

CREATE TABLE `tb_products` (
  `idproduct` int(11) NOT NULL,
  `desproduct` varchar(64) NOT NULL,
  `vlprice` decimal(10,2) NOT NULL,
  `vlwidth` decimal(10,2) NOT NULL,
  `vlheight` decimal(10,2) NOT NULL,
  `vllength` decimal(10,2) NOT NULL,
  `vlweight` decimal(10,2) NOT NULL,
  `desurl` varchar(128) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_products`
--

INSERT INTO `tb_products` (`idproduct`, `desproduct`, `vlprice`, `vlwidth`, `vlheight`, `vllength`, `vlweight`, `desurl`, `dtregister`) VALUES
(15, 'Pneu Pirelli Aro 14 Cinturato P4 175/65R14 82T - Original Chevro', '230.00', '10.00', '12.00', '14.00', '20.00', 'pneu-pirelli', '2018-09-18 22:07:02'),
(16, 'Pneus Goodyear aro 15 4 unidades', '569.99', '12.00', '10.10', '13.00', '20.00', 'pneus-4unid', '2018-09-18 22:08:29'),
(17, 'Pneu Aro 17â€ Pirelli 215/50R17 91V - Cinturato P7', '279.00', '10.20', '12.00', '13.00', '22.00', 'pneu-17', '2018-09-18 22:12:22'),
(18, 'Farol Mascara Negra Gol Saveiro Parati G3 2000 a 2005', '105.99', '9.00', '8.90', '10.90', '14.00', 'farol-1', '2018-09-18 22:19:25'),
(19, 'Farol Uno Fiorino 2004 - 2014 Pit Bull Pisca Embutido', '59.90', '12.00', '9.00', '8.90', '13.00', 'farol-2', '2018-09-18 22:21:02'),
(20, 'Farol Astra Hatch Sedan 2003 - 2012 MÃ¡scara Cromada Foco Duplo', '119.99', '9.00', '7.50', '9.90', '13.60', 'farol-3', '2018-09-18 22:25:15'),
(22, 'teste', '99.90', '12.00', '12.00', '12.00', '13.00', 'teste', '2018-09-18 23:22:28');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_productscategories`
--

CREATE TABLE `tb_productscategories` (
  `idcategory` int(11) NOT NULL,
  `idproduct` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_productscategories`
--

INSERT INTO `tb_productscategories` (`idcategory`, `idproduct`) VALUES
(4, 9),
(4, 11),
(4, 12),
(5, 10),
(5, 13),
(5, 14),
(6, 18),
(6, 19),
(6, 20);

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_users`
--

CREATE TABLE `tb_users` (
  `iduser` int(11) NOT NULL,
  `idperson` int(11) NOT NULL,
  `deslogin` varchar(64) NOT NULL,
  `despassword` varchar(256) NOT NULL,
  `inadmin` tinyint(4) NOT NULL DEFAULT '0',
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_users`
--

INSERT INTO `tb_users` (`iduser`, `idperson`, `deslogin`, `despassword`, `inadmin`, `dtregister`) VALUES
(1, 1, 'admin', '$2y$12$jA1/udwFwkFeNsUF6q1lxuwGJ3KAruG/zC.OvGQFjNBXL.0mxWAz.', 1, '2017-03-13 03:00:00'),
(7, 7, 'suporte', '$2y$12$0HoqGJEa8UPrgQPYvDbjgOmnnnFXCVMehIRgM0zuPD87VM85Ykwjq', 1, '2017-03-15 16:10:27'),
(8, 8, '', '$2y$12$aEeuHG8QdmmcU1cZy.CLb.d8ffjQ4H0fGiNM.51ua9QYgYce.nVWG', 0, '2017-09-04 20:43:40'),
(9, 9, 'joao@hcode.com.br', '$2y$12$Dz4iQ1CNYCGcOz9OVUoBXu7G7jnhfHcCFBj8l0kz7VPQcA2D.2Llu', 0, '2017-09-04 20:50:02'),
(10, 10, 'suporte@hcode.com.br', '$2y$12$U1J8BTm4LHRVg8s9I9icneryymudMIdS51hBeIa0w60P8D4VRSs/m', 1, '2017-09-06 14:32:15'),
(11, 11, 'matheus147ka9@gmail.com', '$2y$12$zcxdp8ZP6V1sfkRLc7GJq.sx/juiHUJ2TcwXh1F90c6FcPZiLYFmi', 0, '2018-09-17 18:31:23'),
(12, 12, 'matheusbatistaap@hotmail.com', '$2y$12$QUXoNGH122lOvbnEgBAxK.rePNRKhcoz1kEtaLPK5x2TEqGZZ0Uxa', 0, '2018-09-17 22:11:59'),
(13, 13, 'joao@gmail.com', '$2y$12$F.56NQbP05yPebxgoYXZM.u5C4XESmZ3VErWVzhE616kIwOFZrhuW', 0, '2018-09-18 21:53:18'),
(14, 14, 'matheus147ka@gmail.com', '$2y$12$R/n.YmirNWkrFMxAayQEqO9dZvkde/RIhs4BGS0jS1.Iws2S95l3m', 0, '2018-09-19 00:11:32');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_userslogs`
--

CREATE TABLE `tb_userslogs` (
  `idlog` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `deslog` varchar(128) NOT NULL,
  `desip` varchar(45) NOT NULL,
  `desuseragent` varchar(128) NOT NULL,
  `dessessionid` varchar(64) NOT NULL,
  `desurl` varchar(128) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_userspasswordsrecoveries`
--

CREATE TABLE `tb_userspasswordsrecoveries` (
  `idrecovery` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `desip` varchar(45) NOT NULL,
  `dtrecovery` datetime DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_userspasswordsrecoveries`
--

INSERT INTO `tb_userspasswordsrecoveries` (`idrecovery`, `iduser`, `desip`, `dtrecovery`, `dtregister`) VALUES
(1, 7, '127.0.0.1', NULL, '2017-03-15 16:10:59'),
(2, 7, '127.0.0.1', '2017-03-15 13:33:45', '2017-03-15 16:11:18'),
(3, 7, '127.0.0.1', '2017-03-15 13:37:35', '2017-03-15 16:37:12'),
(4, 7, '127.0.0.1', NULL, '2017-09-06 13:44:34'),
(5, 7, '127.0.0.1', '2017-09-06 10:45:54', '2017-09-06 13:45:28'),
(6, 12, '127.0.0.1', NULL, '2018-09-19 02:11:08');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tb_addresses`
--
ALTER TABLE `tb_addresses`
  ADD PRIMARY KEY (`idaddress`),
  ADD KEY `fk_addresses_persons_idx` (`idperson`);

--
-- Indexes for table `tb_carts`
--
ALTER TABLE `tb_carts`
  ADD PRIMARY KEY (`idcart`),
  ADD KEY `FK_carts_users_idx` (`iduser`);

--
-- Indexes for table `tb_cartsproducts`
--
ALTER TABLE `tb_cartsproducts`
  ADD PRIMARY KEY (`idcartproduct`),
  ADD KEY `FK_cartsproducts_carts_idx` (`idcart`),
  ADD KEY `fk_cartsproducts_products_idx` (`idproduct`);

--
-- Indexes for table `tb_categories`
--
ALTER TABLE `tb_categories`
  ADD PRIMARY KEY (`idcategory`);

--
-- Indexes for table `tb_orders`
--
ALTER TABLE `tb_orders`
  ADD PRIMARY KEY (`idorder`),
  ADD KEY `FK_orders_users_idx` (`iduser`),
  ADD KEY `fk_orders_ordersstatus_idx` (`idstatus`),
  ADD KEY `fk_orders_carts_idx` (`idcart`),
  ADD KEY `fk_orders_addresses_idx` (`idaddress`);

--
-- Indexes for table `tb_ordersstatus`
--
ALTER TABLE `tb_ordersstatus`
  ADD PRIMARY KEY (`idstatus`);

--
-- Indexes for table `tb_persons`
--
ALTER TABLE `tb_persons`
  ADD PRIMARY KEY (`idperson`);

--
-- Indexes for table `tb_products`
--
ALTER TABLE `tb_products`
  ADD PRIMARY KEY (`idproduct`);

--
-- Indexes for table `tb_productscategories`
--
ALTER TABLE `tb_productscategories`
  ADD PRIMARY KEY (`idcategory`,`idproduct`),
  ADD KEY `fk_productscategories_products_idx` (`idproduct`);

--
-- Indexes for table `tb_users`
--
ALTER TABLE `tb_users`
  ADD PRIMARY KEY (`iduser`),
  ADD KEY `FK_users_persons_idx` (`idperson`);

--
-- Indexes for table `tb_userslogs`
--
ALTER TABLE `tb_userslogs`
  ADD PRIMARY KEY (`idlog`),
  ADD KEY `fk_userslogs_users_idx` (`iduser`);

--
-- Indexes for table `tb_userspasswordsrecoveries`
--
ALTER TABLE `tb_userspasswordsrecoveries`
  ADD PRIMARY KEY (`idrecovery`),
  ADD KEY `fk_userspasswordsrecoveries_users_idx` (`iduser`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tb_addresses`
--
ALTER TABLE `tb_addresses`
  MODIFY `idaddress` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tb_carts`
--
ALTER TABLE `tb_carts`
  MODIFY `idcart` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `tb_cartsproducts`
--
ALTER TABLE `tb_cartsproducts`
  MODIFY `idcartproduct` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `tb_categories`
--
ALTER TABLE `tb_categories`
  MODIFY `idcategory` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `tb_orders`
--
ALTER TABLE `tb_orders`
  MODIFY `idorder` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tb_ordersstatus`
--
ALTER TABLE `tb_ordersstatus`
  MODIFY `idstatus` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tb_persons`
--
ALTER TABLE `tb_persons`
  MODIFY `idperson` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `tb_products`
--
ALTER TABLE `tb_products`
  MODIFY `idproduct` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `tb_users`
--
ALTER TABLE `tb_users`
  MODIFY `iduser` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `tb_userslogs`
--
ALTER TABLE `tb_userslogs`
  MODIFY `idlog` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tb_userspasswordsrecoveries`
--
ALTER TABLE `tb_userspasswordsrecoveries`
  MODIFY `idrecovery` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Limitadores para a tabela `tb_addresses`
--
ALTER TABLE `tb_addresses`
  ADD CONSTRAINT `fk_addresses_persons` FOREIGN KEY (`idperson`) REFERENCES `tb_persons` (`idperson`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_carts`
--
ALTER TABLE `tb_carts`
  ADD CONSTRAINT `fk_carts_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
