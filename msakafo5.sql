-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Client :  127.0.0.1
-- Généré le :  Jeu 14 Février 2019 à 11:55
-- Version du serveur :  5.6.17
-- Version de PHP :  5.5.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de données :  `msakafo5`
--

-- --------------------------------------------------------

--
-- Structure de la table `client`
--

CREATE TABLE IF NOT EXISTS `client` (
  `client_id` int(10) NOT NULL AUTO_INCREMENT,
  `numero` int(10) NOT NULL,
  `pin` int(10) NOT NULL,
  `ville_id` int(10) NOT NULL,
  `client_pesudo` varchar(20) NOT NULL,
  PRIMARY KEY (`client_id`),
  KEY `FKclient674724` (`ville_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Contenu de la table `client`
--

INSERT INTO `client` (`client_id`, `numero`, `pin`, `ville_id`, `client_pesudo`) VALUES
(1, 327689000, 808080, 1, 'Ndrema'),
(2, 345678900, 909034, 2, 'Bakoly'),
(3, 342567899, 343456, 3, 'Samy');

-- --------------------------------------------------------

--
-- Structure de la table `commande_client`
--

CREATE TABLE IF NOT EXISTS `commande_client` (
  `commande_id` int(10) NOT NULL AUTO_INCREMENT,
  `commande` varchar(20) DEFAULT NULL,
  `commande_client_date` datetime NOT NULL,
  `datelivraison` datetime NOT NULL,
  `lieulivraison` varchar(20) NOT NULL,
  `commande_cli_commentaire` text NOT NULL,
  `Status` varchar(255) DEFAULT NULL,
  `status_paiement` varchar(16) DEFAULT NULL,
  `client_id` int(10) DEFAULT NULL,
  PRIMARY KEY (`commande_id`),
  KEY `FKcommande_c773995` (`client_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

--
-- Contenu de la table `commande_client`
--

INSERT INTO `commande_client` (`commande_id`, `commande`, `commande_client_date`, `datelivraison`, `lieulivraison`, `commande_cli_commentaire`, `Status`, `status_paiement`, `client_id`) VALUES
(1, 'C.20190202.1', '2019-02-02 14:16:00', '2019-02-02 14:19:00', 'Ambatoroka', 'RAS', 'livré', 'payé', 1),
(2, 'C.20190211.2', '2019-02-11 08:04:00', '2019-02-11 08:45:00', 'Ankadimbahoaka', 'RAS', 'en cours', 'non payé', 2),
(3, 'C.20190211.3', '2019-02-11 10:15:00', '2019-02-11 10:30:00', 'Androndra', 'RAS', 'en cours', 'non payé', 3),
(4, 'C.20190211.4', '2019-02-11 10:20:00', '2019-02-11 10:45:00', 'Ambatoroka', 'RAS', 'annulé', 'non payé', 3),
(7, 'C02019-02-14 00:00:0', '2019-02-14 00:00:00', '2019-02-15 00:00:00', 'Beravina', 'asa', 'non', 'non', 1);

--
-- Déclencheurs `commande_client`
--
DROP TRIGGER IF EXISTS `insert_commande`;
DELIMITER //
CREATE TRIGGER `insert_commande` BEFORE INSERT ON `commande_client`
 FOR EACH ROW SET 
NEW.commande = CONCAT("C",NEW.commande_id,NEW.commande_client_date)
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `commande_contenu`
--

CREATE TABLE IF NOT EXISTS `commande_contenu` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `qty_cmd` int(10) NOT NULL,
  `plat_id` int(10) NOT NULL,
  `commande_id` int(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKcommande_c712650` (`plat_id`),
  KEY `FKcommande_c650937` (`commande_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=14 ;

--
-- Contenu de la table `commande_contenu`
--

INSERT INTO `commande_contenu` (`id`, `qty_cmd`, `plat_id`, `commande_id`) VALUES
(13, 5, 5, 1);

--
-- Déclencheurs `commande_contenu`
--
DROP TRIGGER IF EXISTS `sortie`;
DELIMITER //
CREATE TRIGGER `sortie` AFTER INSERT ON `commande_contenu`
 FOR EACH ROW UPDATE produit,ingredient,commande_contenu,type_mouvement  set produit.qty_prd = produit.qty_prd - (ingredient.qty_prd * commande_contenu.qty_cmd) WHERE ( commande_contenu.plat_id = ingredient.plat_id  and produit.produit_id = ingredient.produit_id and  type_mouvement.type_mvt_id = 2)
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `commande_produit`
--

CREATE TABLE IF NOT EXISTS `commande_produit` (
  `commande_produit_id` varchar(50) NOT NULL,
  `commande_produit_date` datetime DEFAULT NULL,
  `produit_id` int(10) NOT NULL,
  `qty_prd` double DEFAULT NULL,
  `unite_abb` varchar(4) DEFAULT NULL,
  `pu` int(7) DEFAULT NULL,
  PRIMARY KEY (`commande_produit_id`),
  KEY `FKcommande_p632980` (`produit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `commande_produit`
--

INSERT INTO `commande_produit` (`commande_produit_id`, `commande_produit_date`, `produit_id`, `qty_prd`, `unite_abb`, `pu`) VALUES
('', '2019-02-14 00:00:00', 1, 120, 'kg', 1200),
('P01', '2019-02-02 12:52:00', 1, 20, 'kg', 1600),
('P02', '2019-02-02 13:05:00', 2, 4, 'pqt', 200);

--
-- Déclencheurs `commande_produit`
--
DROP TRIGGER IF EXISTS `entree`;
DELIMITER //
CREATE TRIGGER `entree` AFTER INSERT ON `commande_produit`
 FOR EACH ROW UPDATE commande_produit,produit,type_mouvement  set produit.qty_prd = produit.qty_prd + commande_produit.qty_prd WHERE ( commande_produit.produit_id = produit.produit_id and  type_mouvement.type_mvt_id = 1)
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `gestionnaire`
--

CREATE TABLE IF NOT EXISTS `gestionnaire` (
  `gestionnaire_id` int(10) NOT NULL AUTO_INCREMENT,
  `gestionnaire_pseudo` varchar(20) NOT NULL,
  `gestionnaire_password` varchar(10) NOT NULL,
  `ville_id` int(10) NOT NULL,
  PRIMARY KEY (`gestionnaire_id`),
  KEY `FKgestionnai21846` (`ville_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `ingredient`
--

CREATE TABLE IF NOT EXISTS `ingredient` (
  `ingredient_id` int(10) NOT NULL AUTO_INCREMENT,
  `produit_id` int(10) DEFAULT NULL,
  `qty_prd` double NOT NULL,
  `unite_id` int(10) NOT NULL,
  `plat_id` int(10) DEFAULT NULL,
  PRIMARY KEY (`ingredient_id`),
  KEY `FKingredient751985` (`produit_id`),
  KEY `FKingredient412112` (`plat_id`),
  KEY `FKingredient685167` (`unite_id`),
  KEY `plat_id` (`plat_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

--
-- Contenu de la table `ingredient`
--

INSERT INTO `ingredient` (`ingredient_id`, `produit_id`, `qty_prd`, `unite_id`, `plat_id`) VALUES
(5, 3, 1, 2, 5),
(6, 1, 8, 4, 5),
(7, 1, 1, 1, 4);

-- --------------------------------------------------------

--
-- Structure de la table `livreur`
--

CREATE TABLE IF NOT EXISTS `livreur` (
  `livreur_id` int(10) NOT NULL AUTO_INCREMENT,
  `livreur_pseudo` varchar(25) NOT NULL,
  `livreur_contact` int(10) NOT NULL,
  `ville_id` int(10) NOT NULL,
  PRIMARY KEY (`livreur_id`),
  KEY `FKlivreur899837` (`ville_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Contenu de la table `livreur`
--

INSERT INTO `livreur` (`livreur_id`, `livreur_pseudo`, `livreur_contact`, `ville_id`) VALUES
(1, 'Rabe', 341323245, 2),
(2, 'Bary', 325678900, 3),
(3, 'Phine', 329087656, 1);

-- --------------------------------------------------------

--
-- Structure de la table `mouvement_prd`
--

CREATE TABLE IF NOT EXISTS `mouvement_prd` (
  `mvt_id` varchar(50) NOT NULL,
  `mvt_date` datetime DEFAULT NULL,
  `type_mvt_id` decimal(18,0) NOT NULL,
  `produit_id` int(10) NOT NULL,
  `qty_prd` double DEFAULT NULL,
  `unite_abb` varchar(4) DEFAULT NULL,
  `isValidate` int(1) DEFAULT NULL,
  `mvt_commentaire` text,
  PRIMARY KEY (`mvt_id`),
  KEY `FKmouvement_562163` (`produit_id`),
  KEY `FKmouvement_669705` (`type_mvt_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `mouvement_prd`
--

INSERT INTO `mouvement_prd` (`mvt_id`, `mvt_date`, `type_mvt_id`, `produit_id`, `qty_prd`, `unite_abb`, `isValidate`, `mvt_commentaire`) VALUES
('1', '2019-02-04 21:29:00', '1', 1, 100, 'kg', 0, 'non validé'),
('2', '2019-02-11 06:13:00', '1', 2, 5, 'pqt', 0, NULL),
('3', '2019-02-11 08:05:00', '2', 1, 250, 'g', 1, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `plat`
--

CREATE TABLE IF NOT EXISTS `plat` (
  `plat_id` int(10) NOT NULL AUTO_INCREMENT,
  `plat_nom` varchar(30) NOT NULL,
  `plat_desc` text NOT NULL,
  `plat_prix` int(10) NOT NULL,
  `plat_img` varchar(100) DEFAULT NULL,
  `categorie_id` int(10) DEFAULT NULL,
  `plat_status` varchar(20) DEFAULT NULL,
  `ville_id` int(10) NOT NULL,
  PRIMARY KEY (`plat_id`),
  KEY `FKplat701476` (`categorie_id`),
  KEY `FKplat139565` (`ville_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Contenu de la table `plat`
--

INSERT INTO `plat` (`plat_id`, `plat_nom`, `plat_desc`, `plat_prix`, `plat_img`, `categorie_id`, `plat_status`, `ville_id`) VALUES
(1, 'Filet de saumon', 'poisson d''eau douce fumé', 10000, NULL, 3, 'disponible', 3),
(2, 'Brochette de poulet', '3 pièces garni de salade', 4500, NULL, 4, 'disponible', 3),
(4, 'Brownies', 'gâteau au chocolat', 4000, NULL, 1, 'disponible', 2),
(5, 'Escalope ', 'tranche de viande rouge avec bol renversé', 5000, NULL, 3, 'disponible', 1);

-- --------------------------------------------------------

--
-- Structure de la table `plat_categorie`
--

CREATE TABLE IF NOT EXISTS `plat_categorie` (
  `categorie_id` int(10) NOT NULL AUTO_INCREMENT,
  `categorie_nom` varchar(10) NOT NULL,
  `categorie_desc` text NOT NULL,
  PRIMARY KEY (`categorie_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Contenu de la table `plat_categorie`
--

INSERT INTO `plat_categorie` (`categorie_id`, `categorie_nom`, `categorie_desc`) VALUES
(1, 'Dessert', 'Viennoiserie'),
(2, 'Crudité', 'mélange de légumes crus'),
(3, 'Résistance', 'Plat principal'),
(4, 'Fritures', 'différents snacks associés');

-- --------------------------------------------------------

--
-- Structure de la table `produit`
--

CREATE TABLE IF NOT EXISTS `produit` (
  `produit_id` int(10) NOT NULL AUTO_INCREMENT,
  `produit_nom` varchar(25) NOT NULL,
  `qty_prd` double DEFAULT NULL,
  `unite_id` int(10) NOT NULL,
  `produit_desc` text NOT NULL,
  PRIMARY KEY (`produit_id`),
  KEY `FKproduit749886` (`unite_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Contenu de la table `produit`
--

INSERT INTO `produit` (`produit_id`, `produit_nom`, `qty_prd`, `unite_id`, `produit_desc`) VALUES
(1, 'Farine', 180, 1, 'farine de blé en sac de 10'),
(2, 'Chocolat', 14, 4, 'minichoco en pacquet de 10'),
(3, 'Lait', 15, 2, 'lait de vache en bidon de 5 litre'),
(4, 'Oeuf', 10, 4, 'oeufs en paquet de 10');

-- --------------------------------------------------------

--
-- Structure de la table `type_mouvement`
--

CREATE TABLE IF NOT EXISTS `type_mouvement` (
  `type_mvt_id` decimal(18,0) NOT NULL,
  `mvt_prd_id` int(11) DEFAULT NULL,
  `type_mvt_nom` varchar(6) DEFAULT NULL,
  `coefficient` decimal(18,0) DEFAULT NULL,
  PRIMARY KEY (`type_mvt_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `type_mouvement`
--

INSERT INTO `type_mouvement` (`type_mvt_id`, `mvt_prd_id`, `type_mvt_nom`, `coefficient`) VALUES
('1', NULL, 'Entrée', '1'),
('2', NULL, 'Sortie', '-1');

-- --------------------------------------------------------

--
-- Structure de la table `unite_de_mesure`
--

CREATE TABLE IF NOT EXISTS `unite_de_mesure` (
  `unite_id` int(10) NOT NULL AUTO_INCREMENT,
  `unite_nom` varchar(10) NOT NULL,
  `unite_abb` varchar(4) NOT NULL,
  PRIMARY KEY (`unite_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Contenu de la table `unite_de_mesure`
--

INSERT INTO `unite_de_mesure` (`unite_id`, `unite_nom`, `unite_abb`) VALUES
(1, 'kilogramme', 'kg'),
(2, 'litre', 'l'),
(3, 'gramme', 'g'),
(4, 'pacquet', 'pqt');

-- --------------------------------------------------------

--
-- Structure de la table `ville`
--

CREATE TABLE IF NOT EXISTS `ville` (
  `ville_id` int(10) NOT NULL AUTO_INCREMENT,
  `ville_nom` varchar(20) NOT NULL,
  `ville_status` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ville_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Contenu de la table `ville`
--

INSERT INTO `ville` (`ville_id`, `ville_nom`, `ville_status`) VALUES
(1, 'Ambatobe', 'accessible'),
(2, 'Antsira', 'accessible'),
(3, 'Ampefy', 'accessible'),
(4, 'Anjepy', 'non accessible');

--
-- Contraintes pour les tables exportées
--

--
-- Contraintes pour la table `client`
--
ALTER TABLE `client`
  ADD CONSTRAINT `FKclient674724` FOREIGN KEY (`ville_id`) REFERENCES `ville` (`ville_id`);

--
-- Contraintes pour la table `commande_client`
--
ALTER TABLE `commande_client`
  ADD CONSTRAINT `FKcommande_c773995` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `commande_contenu`
--
ALTER TABLE `commande_contenu`
  ADD CONSTRAINT `FKcommande_c650937` FOREIGN KEY (`commande_id`) REFERENCES `commande_client` (`commande_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FKcommande_c712650` FOREIGN KEY (`plat_id`) REFERENCES `plat` (`plat_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `commande_produit`
--
ALTER TABLE `commande_produit`
  ADD CONSTRAINT `FKcommande_p632980` FOREIGN KEY (`produit_id`) REFERENCES `produit` (`produit_id`);

--
-- Contraintes pour la table `gestionnaire`
--
ALTER TABLE `gestionnaire`
  ADD CONSTRAINT `FKgestionnai21846` FOREIGN KEY (`ville_id`) REFERENCES `ville` (`ville_id`);

--
-- Contraintes pour la table `ingredient`
--
ALTER TABLE `ingredient`
  ADD CONSTRAINT `FKingredient412112` FOREIGN KEY (`plat_id`) REFERENCES `plat` (`plat_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FKingredient685167` FOREIGN KEY (`unite_id`) REFERENCES `unite_de_mesure` (`unite_id`),
  ADD CONSTRAINT `FKingredient751985` FOREIGN KEY (`produit_id`) REFERENCES `produit` (`produit_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `livreur`
--
ALTER TABLE `livreur`
  ADD CONSTRAINT `FKlivreur899837` FOREIGN KEY (`ville_id`) REFERENCES `ville` (`ville_id`);

--
-- Contraintes pour la table `mouvement_prd`
--
ALTER TABLE `mouvement_prd`
  ADD CONSTRAINT `FKmouvement_562163` FOREIGN KEY (`produit_id`) REFERENCES `produit` (`produit_id`),
  ADD CONSTRAINT `FKmouvement_669705` FOREIGN KEY (`type_mvt_id`) REFERENCES `type_mouvement` (`type_mvt_id`);

--
-- Contraintes pour la table `plat`
--
ALTER TABLE `plat`
  ADD CONSTRAINT `FKplat139565` FOREIGN KEY (`ville_id`) REFERENCES `ville` (`ville_id`),
  ADD CONSTRAINT `FKplat701476` FOREIGN KEY (`categorie_id`) REFERENCES `plat_categorie` (`categorie_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `produit`
--
ALTER TABLE `produit`
  ADD CONSTRAINT `FKproduit749886` FOREIGN KEY (`unite_id`) REFERENCES `unite_de_mesure` (`unite_id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
