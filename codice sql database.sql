-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Trasporto_Ferroviario_Alta_Velocita
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `Trasporto_Ferroviario_Alta_Velocita` ;

-- -----------------------------------------------------
-- Schema Trasporto_Ferroviario_Alta_Velocita
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Trasporto_Ferroviario_Alta_Velocita` DEFAULT CHARACTER SET utf8 ;
USE `Trasporto_Ferroviario_Alta_Velocita` ;

-- -----------------------------------------------------
-- Table `Trasporto_Ferroviario_Alta_Velocita`.`Azienda`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Azienda` ;

CREATE TABLE IF NOT EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Azienda` (
  `Partita_IVA` VARCHAR(11) NOT NULL,
  `Recapito` VARCHAR(45) NOT NULL,
  `Ragione_Sociale` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Partita_IVA`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `Recapito_UNIQUE` ON `Trasporto_Ferroviario_Alta_Velocita`.`Azienda` (`Recapito` ASC) VISIBLE;

CREATE UNIQUE INDEX `Ragione_Sociale_UNIQUE` ON `Trasporto_Ferroviario_Alta_Velocita`.`Azienda` (`Ragione_Sociale` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Trasporto_Ferroviario_Alta_Velocita`.`Locomotrice`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Locomotrice` ;

CREATE TABLE IF NOT EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Locomotrice` (
  `Id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Marca` VARCHAR(45) NOT NULL,
  `Modello` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Trasporto_Ferroviario_Alta_Velocita`.`Treno_Passeggeri`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Treno_Passeggeri` ;

CREATE TABLE IF NOT EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Treno_Passeggeri` (
  `Matricola` VARCHAR(4) NOT NULL,
  `Numero_Vagoni` INT UNSIGNED NOT NULL,
  `Data_di_Acquisto` DATE NOT NULL,
  `Locomotrice` INT UNSIGNED NOT NULL,
  `Numero_Carrozze_I_Classe` INT UNSIGNED NOT NULL,
  `Numero_Carrozze_II_Classe` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Matricola`),
  CONSTRAINT `fk_Treno_Passeggeri_1`
    FOREIGN KEY (`Locomotrice`)
    REFERENCES `Trasporto_Ferroviario_Alta_Velocita`.`Locomotrice` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Treno_Passeggeri_1_idx` ON `Trasporto_Ferroviario_Alta_Velocita`.`Treno_Passeggeri` (`Locomotrice` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Trasporto_Ferroviario_Alta_Velocita`.`Vagone_Passeggeri`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Vagone_Passeggeri` ;

CREATE TABLE IF NOT EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Vagone_Passeggeri` (
  `Id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Marca` VARCHAR(45) NOT NULL,
  `Modello` VARCHAR(45) NOT NULL,
  `Classe` ENUM('1', '2') NOT NULL,
  `Numero_Massimo_di_Passeggeri` INT UNSIGNED NOT NULL,
  `Treno` VARCHAR(4) NOT NULL,
  PRIMARY KEY (`Id`),
  CONSTRAINT `fk_Vagone_Passeggeri_1`
    FOREIGN KEY (`Treno`)
    REFERENCES `Trasporto_Ferroviario_Alta_Velocita`.`Treno_Passeggeri` (`Matricola`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Vagone_Passeggeri_1_idx` ON `Trasporto_Ferroviario_Alta_Velocita`.`Vagone_Passeggeri` (`Treno` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Trasporto_Ferroviario_Alta_Velocita`.`Posto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Posto` ;

CREATE TABLE IF NOT EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Posto` (
  `Numero` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Vagone_Passeggeri` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Numero`, `Vagone_Passeggeri`),
  CONSTRAINT `fk_Posto_1`
    FOREIGN KEY (`Vagone_Passeggeri`)
    REFERENCES `Trasporto_Ferroviario_Alta_Velocita`.`Vagone_Passeggeri` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Posto_1_idx` ON `Trasporto_Ferroviario_Alta_Velocita`.`Posto` (`Vagone_Passeggeri` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Trasporto_Ferroviario_Alta_Velocita`.`Stazione`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Stazione` ;

CREATE TABLE IF NOT EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Stazione` (
  `Codice` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(45) NOT NULL,
  `Citta` VARCHAR(45) NOT NULL,
  `Provincia` VARCHAR(2) NOT NULL,
  PRIMARY KEY (`Codice`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Trasporto_Ferroviario_Alta_Velocita`.`Tratta`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Tratta` ;

CREATE TABLE IF NOT EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Tratta` (
  `Codice` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Capolinea_di_Partenza` INT UNSIGNED NOT NULL,
  `Capolinea_di_Arrivo` INT UNSIGNED NOT NULL,
  `Orario_Partenza` TIME NOT NULL,
  `Orario_Arrivo` TIME NOT NULL,
  PRIMARY KEY (`Codice`),
  CONSTRAINT `fk_Tratta_1`
    FOREIGN KEY (`Capolinea_di_Partenza`)
    REFERENCES `Trasporto_Ferroviario_Alta_Velocita`.`Stazione` (`Codice`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Tratta_2`
    FOREIGN KEY (`Capolinea_di_Arrivo`)
    REFERENCES `Trasporto_Ferroviario_Alta_Velocita`.`Stazione` (`Codice`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Tratta_1_idx` ON `Trasporto_Ferroviario_Alta_Velocita`.`Tratta` (`Capolinea_di_Partenza` ASC) VISIBLE;

CREATE INDEX `fk_Tratta_2_idx` ON `Trasporto_Ferroviario_Alta_Velocita`.`Tratta` (`Capolinea_di_Arrivo` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Trasporto_Ferroviario_Alta_Velocita`.`Corsa`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Corsa` ;

CREATE TABLE IF NOT EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Corsa` (
  `Data` DATE NOT NULL,
  `Tratta` INT UNSIGNED NOT NULL,
  `Orario_Effettivo_di_Partenza` DATETIME NULL,
  `Orario_Effettivo_di_Arrivo` DATETIME NULL,
  PRIMARY KEY (`Data`, `Tratta`),
  CONSTRAINT `fk_Corsa_1`
    FOREIGN KEY (`Tratta`)
    REFERENCES `Trasporto_Ferroviario_Alta_Velocita`.`Tratta` (`Codice`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Corsa_1_idx` ON `Trasporto_Ferroviario_Alta_Velocita`.`Corsa` (`Tratta` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Trasporto_Ferroviario_Alta_Velocita`.`Corsa_Treno_Passeggeri`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Corsa_Treno_Passeggeri` ;

CREATE TABLE IF NOT EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Corsa_Treno_Passeggeri` (
  `Data_Corsa` DATE NOT NULL,
  `Tratta` INT UNSIGNED NOT NULL,
  `Treno_Passeggeri` VARCHAR(4) NOT NULL,
  PRIMARY KEY (`Data_Corsa`, `Tratta`),
  CONSTRAINT `fk_Corsa_Treno_Passeggeri_1`
    FOREIGN KEY (`Data_Corsa` , `Tratta`)
    REFERENCES `Trasporto_Ferroviario_Alta_Velocita`.`Corsa` (`Data` , `Tratta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Corsa_Treno_Passeggeri_2`
    FOREIGN KEY (`Treno_Passeggeri`)
    REFERENCES `Trasporto_Ferroviario_Alta_Velocita`.`Treno_Passeggeri` (`Matricola`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Corsa_Treno_Passeggeri_2_idx` ON `Trasporto_Ferroviario_Alta_Velocita`.`Corsa_Treno_Passeggeri` (`Treno_Passeggeri` ASC) INVISIBLE;


-- -----------------------------------------------------
-- Table `Trasporto_Ferroviario_Alta_Velocita`.`Biglietto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Biglietto` ;

CREATE TABLE IF NOT EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Biglietto` (
  `Codice_di_prenotazione` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Numero_Posto` INT UNSIGNED NOT NULL,
  `Vagone_Passeggeri` INT UNSIGNED NOT NULL,
  `Data_Corsa` DATE NOT NULL,
  `Tratta` INT UNSIGNED NOT NULL,
  `Status` ENUM('non-convalidato', 'convalidato') NULL DEFAULT 'non-convalidato',
  `Codice_Fiscale` VARCHAR(16) NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  `Cognome` VARCHAR(45) NOT NULL,
  `Data_di_nascita` DATE NOT NULL,
  `Numero_CC` VARCHAR(16) NOT NULL,
  PRIMARY KEY (`Codice_di_prenotazione`),
  CONSTRAINT `fk_Biglietto_1`
    FOREIGN KEY (`Numero_Posto` , `Vagone_Passeggeri`)
    REFERENCES `Trasporto_Ferroviario_Alta_Velocita`.`Posto` (`Numero` , `Vagone_Passeggeri`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Biglietto_2`
    FOREIGN KEY (`Data_Corsa` , `Tratta`)
    REFERENCES `Trasporto_Ferroviario_Alta_Velocita`.`Corsa_Treno_Passeggeri` (`Data_Corsa` , `Tratta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Biglietto_1_idx` ON `Trasporto_Ferroviario_Alta_Velocita`.`Biglietto` (`Numero_Posto` ASC, `Vagone_Passeggeri` ASC) VISIBLE;

CREATE INDEX `fk_Biglietto_2_idx` ON `Trasporto_Ferroviario_Alta_Velocita`.`Biglietto` (`Data_Corsa` ASC, `Tratta` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Trasporto_Ferroviario_Alta_Velocita`.`Lavoratore`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Lavoratore` ;

CREATE TABLE IF NOT EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Lavoratore` (
  `Codice_Fiscale` VARCHAR(16) NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  `Cognome` VARCHAR(45) NOT NULL,
  `Data_di_Nascita` DATE NOT NULL,
  `Citta_di_Nascita` VARCHAR(45) NOT NULL,
  `Ruolo` ENUM('capotreno', 'conducente') NOT NULL,
  `Provincia_di_Nascita` VARCHAR(2) NOT NULL,
  PRIMARY KEY (`Codice_Fiscale`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Trasporto_Ferroviario_Alta_Velocita`.`Report_sui_turni`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Report_sui_turni` ;

CREATE TABLE IF NOT EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Report_sui_turni` (
  `Lavoratore` VARCHAR(16) NOT NULL,
  `Data` DATE NOT NULL,
  `Testo_Rapporto` VARCHAR(500) NOT NULL,
  PRIMARY KEY (`Lavoratore`, `Data`),
  CONSTRAINT `fk_Report_sui_turni_1`
    FOREIGN KEY (`Lavoratore`)
    REFERENCES `Trasporto_Ferroviario_Alta_Velocita`.`Lavoratore` (`Codice_Fiscale`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Trasporto_Ferroviario_Alta_Velocita`.`Corsa_Report`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Corsa_Report` ;

CREATE TABLE IF NOT EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Corsa_Report` (
  `Numero` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Lavoratore` VARCHAR(16) NOT NULL,
  `Data_Report` DATE NOT NULL,
  `Data_Corsa` DATE NOT NULL,
  `Tratta` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Numero`, `Lavoratore`, `Data_Report`),
  CONSTRAINT `fk_Corsa_Report_1`
    FOREIGN KEY (`Lavoratore` , `Data_Report`)
    REFERENCES `Trasporto_Ferroviario_Alta_Velocita`.`Report_sui_turni` (`Lavoratore` , `Data`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Corsa_Report_2`
    FOREIGN KEY (`Data_Corsa` , `Tratta`)
    REFERENCES `Trasporto_Ferroviario_Alta_Velocita`.`Corsa` (`Data` , `Tratta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Corsa_Report_2_idx` ON `Trasporto_Ferroviario_Alta_Velocita`.`Corsa_Report` (`Data_Corsa` ASC, `Tratta` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Trasporto_Ferroviario_Alta_Velocita`.`Treno_Merci`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Treno_Merci` ;

CREATE TABLE IF NOT EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Treno_Merci` (
  `Matricola` VARCHAR(4) NOT NULL,
  `Numero_Vagoni` INT UNSIGNED NOT NULL,
  `Data_di_Acquisto` DATE NOT NULL,
  `Locomotrice` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Matricola`),
  CONSTRAINT `fk_Treno_Merci_1`
    FOREIGN KEY (`Locomotrice`)
    REFERENCES `Trasporto_Ferroviario_Alta_Velocita`.`Locomotrice` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Treno_Merci_1_idx` ON `Trasporto_Ferroviario_Alta_Velocita`.`Treno_Merci` (`Locomotrice` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Trasporto_Ferroviario_Alta_Velocita`.`Corsa_Treno_Merci`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Corsa_Treno_Merci` ;

CREATE TABLE IF NOT EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Corsa_Treno_Merci` (
  `Data_Corsa` DATE NOT NULL,
  `Tratta` INT UNSIGNED NOT NULL,
  `Treno_Merci` VARCHAR(4) NOT NULL,
  PRIMARY KEY (`Data_Corsa`, `Tratta`),
  CONSTRAINT `fk_Corsa_Treno_Merci_1`
    FOREIGN KEY (`Data_Corsa` , `Tratta`)
    REFERENCES `Trasporto_Ferroviario_Alta_Velocita`.`Corsa` (`Data` , `Tratta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Corsa_Treno_Merci_2`
    FOREIGN KEY (`Treno_Merci`)
    REFERENCES `Trasporto_Ferroviario_Alta_Velocita`.`Treno_Merci` (`Matricola`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Corsa_Treno_Merci_2_idx` ON `Trasporto_Ferroviario_Alta_Velocita`.`Corsa_Treno_Merci` (`Treno_Merci` ASC) INVISIBLE;

CREATE UNIQUE INDEX `fk_Corsa_Treno_Merci_1_idx` ON `Trasporto_Ferroviario_Alta_Velocita`.`Corsa_Treno_Merci` (`Data_Corsa` ASC, `Tratta` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Trasporto_Ferroviario_Alta_Velocita`.`Ferma`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Ferma` ;

CREATE TABLE IF NOT EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Ferma` (
  `Orario_Partenza` TIME NOT NULL,
  `Orario_Arrivo` TIME NOT NULL,
  `Tratta` INT UNSIGNED NOT NULL,
  `Stazione` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Tratta`, `Stazione`),
  CONSTRAINT `fk_Ferma_1`
    FOREIGN KEY (`Tratta`)
    REFERENCES `Trasporto_Ferroviario_Alta_Velocita`.`Tratta` (`Codice`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Ferma_2`
    FOREIGN KEY (`Stazione`)
    REFERENCES `Trasporto_Ferroviario_Alta_Velocita`.`Stazione` (`Codice`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Ferma_2_idx` ON `Trasporto_Ferroviario_Alta_Velocita`.`Ferma` (`Stazione` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Trasporto_Ferroviario_Alta_Velocita`.`Report_Manutenzione_Locomotrice`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Report_Manutenzione_Locomotrice` ;

CREATE TABLE IF NOT EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Report_Manutenzione_Locomotrice` (
  `Locomotrice` INT UNSIGNED NOT NULL,
  `Testo` VARCHAR(200) NOT NULL,
  `Timestamp` TIMESTAMP NOT NULL,
  PRIMARY KEY (`Locomotrice`, `Timestamp`),
  CONSTRAINT `fk_Report_Manutenzione_Locomotrice_1`
    FOREIGN KEY (`Locomotrice`)
    REFERENCES `Trasporto_Ferroviario_Alta_Velocita`.`Locomotrice` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Trasporto_Ferroviario_Alta_Velocita`.`Vagone_Merci`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Vagone_Merci` ;

CREATE TABLE IF NOT EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Vagone_Merci` (
  `Id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Marca` VARCHAR(45) NOT NULL,
  `Modello` VARCHAR(45) NOT NULL,
  `Portata` INT UNSIGNED NOT NULL,
  `Treno` VARCHAR(4) NOT NULL,
  PRIMARY KEY (`Id`),
  CONSTRAINT `fk_Vagone_Merci_1`
    FOREIGN KEY (`Treno`)
    REFERENCES `Trasporto_Ferroviario_Alta_Velocita`.`Treno_Merci` (`Matricola`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Vagone_Merci_1_idx` ON `Trasporto_Ferroviario_Alta_Velocita`.`Vagone_Merci` (`Treno` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Trasporto_Ferroviario_Alta_Velocita`.`Report_Manutenzione_Vagone_Merci`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Report_Manutenzione_Vagone_Merci` ;

CREATE TABLE IF NOT EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Report_Manutenzione_Vagone_Merci` (
  `Vagone_Merci` INT UNSIGNED NOT NULL,
  `Testo` VARCHAR(200) NOT NULL,
  `Timestamp` TIMESTAMP NOT NULL,
  PRIMARY KEY (`Vagone_Merci`, `Timestamp`),
  CONSTRAINT `fk_Report_Manutenzione_Vagone_Merci_1`
    FOREIGN KEY (`Vagone_Merci`)
    REFERENCES `Trasporto_Ferroviario_Alta_Velocita`.`Vagone_Merci` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Trasporto_Ferroviario_Alta_Velocita`.`Report_Manutenzione_Vagone_Passeggeri`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Report_Manutenzione_Vagone_Passeggeri` ;

CREATE TABLE IF NOT EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Report_Manutenzione_Vagone_Passeggeri` (
  `Vagone_Passeggeri` INT UNSIGNED NOT NULL,
  `Testo` VARCHAR(200) NOT NULL,
  `Timestamp` TIMESTAMP NOT NULL,
  PRIMARY KEY (`Vagone_Passeggeri`, `Timestamp`),
  CONSTRAINT `fk_Report_Manutenzione_Vagone_Passeggeri_1`
    FOREIGN KEY (`Vagone_Passeggeri`)
    REFERENCES `Trasporto_Ferroviario_Alta_Velocita`.`Vagone_Passeggeri` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Trasporto_Ferroviario_Alta_Velocita`.`Spedizione`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Spedizione` ;

CREATE TABLE IF NOT EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Spedizione` (
  `Azienda_Mittente` VARCHAR(11) NOT NULL,
  `Azienda_Destinataria` VARCHAR(11) NOT NULL,
  `Merce` VARCHAR(45) NOT NULL,
  `Massa_Complessiva` INT UNSIGNED NOT NULL,
  `Vagone_Merci` INT UNSIGNED NOT NULL,
  `Data_Corsa` DATE NOT NULL,
  `Tratta` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Tratta`, `Data_Corsa`, `Vagone_Merci`),
  CONSTRAINT `fk_Spedizione_1`
    FOREIGN KEY (`Azienda_Mittente`)
    REFERENCES `Trasporto_Ferroviario_Alta_Velocita`.`Azienda` (`Partita_IVA`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Spedizione_2`
    FOREIGN KEY (`Azienda_Destinataria`)
    REFERENCES `Trasporto_Ferroviario_Alta_Velocita`.`Azienda` (`Partita_IVA`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Spedizione_3`
    FOREIGN KEY (`Vagone_Merci`)
    REFERENCES `Trasporto_Ferroviario_Alta_Velocita`.`Vagone_Merci` (`Id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Spedizione_4`
    FOREIGN KEY (`Tratta` , `Data_Corsa`)
    REFERENCES `Trasporto_Ferroviario_Alta_Velocita`.`Corsa` (`Tratta` , `Data`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Spedizione_1_idx` ON `Trasporto_Ferroviario_Alta_Velocita`.`Spedizione` (`Azienda_Mittente` ASC) VISIBLE;

CREATE INDEX `fk_Spedizione_2_idx` ON `Trasporto_Ferroviario_Alta_Velocita`.`Spedizione` (`Azienda_Destinataria` ASC) INVISIBLE;

CREATE INDEX `fk_Spedizione_3_idx` ON `Trasporto_Ferroviario_Alta_Velocita`.`Spedizione` (`Vagone_Merci` ASC) INVISIBLE;


-- -----------------------------------------------------
-- Table `Trasporto_Ferroviario_Alta_Velocita`.`Turno`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Turno` ;

CREATE TABLE IF NOT EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Turno` (
  `Lavoratore` VARCHAR(4) NOT NULL,
  `Data_Corsa` DATE NOT NULL,
  `Tratta` INT UNSIGNED NOT NULL,
  `Copertura` ENUM('coperto', 'malattia') NULL DEFAULT 'coperto',
  PRIMARY KEY (`Lavoratore`, `Data_Corsa`, `Tratta`),
  CONSTRAINT `fk_Turno_1`
    FOREIGN KEY (`Lavoratore`)
    REFERENCES `Trasporto_Ferroviario_Alta_Velocita`.`Lavoratore` (`Codice_Fiscale`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Turno_2`
    FOREIGN KEY (`Data_Corsa` , `Tratta`)
    REFERENCES `Trasporto_Ferroviario_Alta_Velocita`.`Corsa` (`Data` , `Tratta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Turno_2_idx` ON `Trasporto_Ferroviario_Alta_Velocita`.`Turno` (`Data_Corsa` ASC, `Tratta` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Trasporto_Ferroviario_Alta_Velocita`.`Utenti`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Utenti` ;

CREATE TABLE IF NOT EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Utenti` (
  `Username` VARCHAR(45) NOT NULL,
  `Password` CHAR(32) NOT NULL,
  `Ruolo` ENUM('Gestore_del_servizio', 'Lavoratore', 'Addetto_alla_manutenzione', 'Controllore', 'Acquirente') NOT NULL,
  PRIMARY KEY (`Username`))
ENGINE = InnoDB;

USE `Trasporto_Ferroviario_Alta_Velocita` ;

-- -----------------------------------------------------
-- procedure acquista_biglietto
-- -----------------------------------------------------

USE `Trasporto_Ferroviario_Alta_Velocita`;
DROP procedure IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`acquista_biglietto`;

DELIMITER $$
USE `Trasporto_Ferroviario_Alta_Velocita`$$
CREATE PROCEDURE `acquista_biglietto` (IN var_Data_Corsa date, IN var_Tratta int, IN var_Classe int, IN var_Codice_Fiscale varchar(16), IN var_Nome varchar(45), IN var_Cognome varchar(45), IN var_Data_di_nascita date, in var_Numero_CC varchar(16))
BEGIN
	declare var_treno varchar(4);
    declare var_biglietto_id int;
    
	set transaction isolation level repeatable read;
	start transaction;
    
    -- troviamo il treno che percorre la corsa specificata
	select `Treno_Passeggeri`
    from `Corsa_Treno_Passeggeri`
    where Corsa_Treno_Passeggeri.Data_Corsa = var_Data_Corsa
    and Corsa_Treno_Passeggeri.Tratta = var_Tratta
    into var_treno;
    
    select @var_Posto := Posto.`Numero`, @var_Vagone := Posto.`Vagone_Passeggeri`
    from `Posto` join Vagone_Passeggeri on Posto.Vagone_Passeggeri = Vagone_Passeggeri.Id join Treno_Passeggeri on Vagone_Passeggeri.Treno = Treno_Passeggeri.Matricola
    where Treno_Passeggeri.Matricola = var_treno and `Vagone_Passeggeri`.Classe = var_Classe and (Posto.`Numero`, Posto.`Vagone_Passeggeri`) not in (select `Numero_Posto`, `Vagone_Passeggeri` from `Biglietto`
	 	where Biglietto.Data_Corsa = var_Data_Corsa
	 and Biglietto.Tratta = var_Tratta)
     limit 1;
	
    insert into `Biglietto` (`Numero_Posto`, `Vagone_Passeggeri`, `Data_Corsa`, `Tratta`, `Codice_Fiscale`, `Nome`, `Cognome`, `Data_di_Nascita`, `Numero_CC`)  values (@var_Posto, @var_Vagone, var_Data_Corsa, var_Tratta, var_Codice_Fiscale, var_Nome, var_Cognome, var_Data_di_nascita, var_Numero_CC);
	
    set var_biglietto_id = last_insert_id();
    select var_biglietto_id, @var_Posto, @var_Vagone;
    
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure aggiungi_azienda
-- -----------------------------------------------------

USE `Trasporto_Ferroviario_Alta_Velocita`;
DROP procedure IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`aggiungi_azienda`;

DELIMITER $$
USE `Trasporto_Ferroviario_Alta_Velocita`$$
CREATE PROCEDURE `aggiungi_azienda` (IN var_Partita_IVA varchar(11), IN var_Recapito varchar(45), IN var_Ragione_Sociale varchar(45))
BEGIN
	set transaction isolation level repeatable read;
    start transaction;
	insert into `Azienda` (`Partita_IVA`, `Recapito`, `Ragione_Sociale`)  values (var_Partita_IVA, var_Recapito, var_Ragione_Sociale);
	commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure aggiungi_corsa_treno_merci
-- -----------------------------------------------------

USE `Trasporto_Ferroviario_Alta_Velocita`;
DROP procedure IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`aggiungi_corsa_treno_merci`;

DELIMITER $$
USE `Trasporto_Ferroviario_Alta_Velocita`$$
CREATE PROCEDURE `aggiungi_corsa_treno_merci` (IN var_Data date, IN var_Tratta int, IN var_Treno_Merci varchar(4), IN var_Conducente varchar(16))
BEGIN

	declare exit handler for sqlexception
    begin
        rollback;  -- rollback any changes made in the transaction
        resignal;  -- raise again the sql exception to the caller
    end;

	set transaction isolation level repeatable read;
	start transaction;
    insert into `Corsa` (`Data`, `Tratta`)  values (var_Data, var_Tratta);
    insert into `Corsa_Treno_Merci` (`Data_Corsa`, `Tratta`, `Treno_Merci`)  values (var_Data, var_Tratta, var_Treno_Merci);
    
	if((select `Ruolo` from `Lavoratore` where `Codice_Fiscale` = var_Conducente)<>'conducente') then
		signal sqlstate '45001' set message_text = "Il lavoratore selezionato non è un conducente";
	end if;
    
    insert into `Turno` (`Data_Corsa`, `Lavoratore`, `Tratta`) values (var_Data, var_Conducente, var_Tratta);
	commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure aggiungi_corsa_treno_passeggeri
-- -----------------------------------------------------

USE `Trasporto_Ferroviario_Alta_Velocita`;
DROP procedure IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`aggiungi_corsa_treno_passeggeri`;

DELIMITER $$
USE `Trasporto_Ferroviario_Alta_Velocita`$$
CREATE PROCEDURE `aggiungi_corsa_treno_passeggeri` (IN var_Data date, IN var_Tratta int, IN var_Treno_Passeggeri varchar(4), IN var_Conducente varchar(16), IN var_Capotreno varchar(16))
BEGIN
	declare exit handler for sqlexception
    begin
        rollback;  -- rollback any changes made in the transaction
        resignal;  -- raise again the sql exception to the caller
    end;

	set transaction isolation level repeatable read;
	start transaction;
    insert into `Corsa` (`Data`, `Tratta`)  values (var_Data, var_Tratta);
    insert into `Corsa_Treno_Passeggeri` (`Data_Corsa`, `Tratta`, `Treno_Passeggeri`)  values (var_Data, var_Tratta, var_Treno_Passeggeri);
    
	if((select `Ruolo` from `Lavoratore` where `Codice_Fiscale` = var_Conducente)<>'conducente') then
		signal sqlstate '45001' set message_text = "Il lavoratore selezionato non e' un conducente";
	end if;
    
	if((select `Ruolo` from `Lavoratore` where `Codice_Fiscale` = var_Capotreno)<>'capotreno') then
		signal sqlstate '45001' set message_text = "Il lavoratore selezionato non e' un capotreno";
	end if;
    
    insert into `Turno` (`Data_Corsa`, `Lavoratore`, `Tratta`) values (var_Data, var_Conducente, var_Tratta);
    insert into `Turno` (`Data_Corsa`, `Lavoratore`, `Tratta`) values (var_Data, var_Capotreno, var_Tratta);
	commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure aggiungi_lavoratore
-- -----------------------------------------------------

USE `Trasporto_Ferroviario_Alta_Velocita`;
DROP procedure IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`aggiungi_lavoratore`;

DELIMITER $$
USE `Trasporto_Ferroviario_Alta_Velocita`$$
CREATE PROCEDURE `aggiungi_lavoratore` (IN var_Codice_Fiscale varchar(11), IN var_Nome varchar(45), IN var_Cognome varchar(45), IN var_Data_di_Nascita date, IN var_Citta_di_Nascita varchar(45), IN var_Ruolo varchar(45), IN var_Provincia_di_nascita varchar(2))
BEGIN
	set transaction isolation level repeatable read;
	start transaction;
	insert into `Lavoratore` (`Codice_Fiscale`, `Nome`, `Cognome`, `Data_di_Nascita`, `Citta_di_Nascita`, `Ruolo`, `Provincia_di_Nascita`)  values (var_Codice_Fiscale, var_Nome, var_Cognome, var_Data_di_Nascita, var_Citta_di_Nascita, var_Ruolo, var_Provincia_di_nascita);
	commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure aggiungi_report_manutenzione_locomotrice
-- -----------------------------------------------------

USE `Trasporto_Ferroviario_Alta_Velocita`;
DROP procedure IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`aggiungi_report_manutenzione_locomotrice`;

DELIMITER $$
USE `Trasporto_Ferroviario_Alta_Velocita`$$
CREATE PROCEDURE `aggiungi_report_manutenzione_locomotrice` (IN var_Locomotrice int, IN var_Testo varchar(200))
BEGIN
	set transaction isolation level repeatable read;
	start transaction;
	insert into `Report_Manutenzione_Locomotrice` (`Locomotrice`, `Testo`, `Timestamp`)  values (var_Locomotrice, var_Testo, current_timestamp());
	commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure aggiungi_report_manutenzione_vagone_merci
-- -----------------------------------------------------

USE `Trasporto_Ferroviario_Alta_Velocita`;
DROP procedure IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`aggiungi_report_manutenzione_vagone_merci`;

DELIMITER $$
USE `Trasporto_Ferroviario_Alta_Velocita`$$
CREATE PROCEDURE `aggiungi_report_manutenzione_vagone_merci` (IN var_Vagone_Merci int, IN var_Testo varchar(200))
BEGIN
	set transaction isolation level repeatable read;
	start transaction;
	insert into `Report_Manutenzione_Vagone_Merci` (`Vagone_Merci`, `Testo`, `Timestamp`)  values (var_Vagone_Merci, var_Testo, current_timestamp());
	commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure aggiungi_report_manutenzione_vagone_passeggeri
-- -----------------------------------------------------

USE `Trasporto_Ferroviario_Alta_Velocita`;
DROP procedure IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`aggiungi_report_manutenzione_vagone_passeggeri`;

DELIMITER $$
USE `Trasporto_Ferroviario_Alta_Velocita`$$
CREATE PROCEDURE `aggiungi_report_manutenzione_vagone_passeggeri` (IN var_Vagone_Passeggeri int, IN var_Testo varchar(200))
BEGIN
	set transaction isolation level repeatable read;
	start transaction;
	insert into `Report_Manutenzione_Vagone_Passeggeri` (`Vagone_Passeggeri`, `Testo`, `Timestamp`)  values (var_Vagone_Passeggeri, var_Testo, current_timestamp());
	commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure aggiungi_spedizione
-- -----------------------------------------------------

USE `Trasporto_Ferroviario_Alta_Velocita`;
DROP procedure IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`aggiungi_spedizione`;

DELIMITER $$
USE `Trasporto_Ferroviario_Alta_Velocita`$$
CREATE PROCEDURE `aggiungi_spedizione` (in var_Azienda_Mittente varchar(11), in var_Azienda_Destinataria varchar(11), in var_Merce varchar(45), in var_Massa_Complessiva int, in var_Vagone_Merci int, in var_Data_Corsa date, in var_Tratta int)
BEGIN
	declare var_treno_corsa varchar(4);
    declare var_treno_vagone varchar(4); 
    
	declare exit handler for sqlexception
    begin
        rollback;  -- rollback any changes made in the transaction
        resignal;  -- raise again the sql exception to the caller
    end;
    
	set transaction isolation level repeatable read;
	start transaction;
    
	select Treno_Merci
    from `Corsa_Treno_Merci`
    where Corsa_Treno_Merci.Data_Corsa = var_Data_Corsa & Corsa_Treno_Merci.Tratta = var_Tratta
    into var_treno_corsa;
    
    select Treno
    from `Vagone_Merci`
    where Vagone_Merci.Id = var_Vagone_Merci
    into var_treno_vagone;
    
    if(var_treno_corsa<>var_treno_vagone) then
		signal sqlstate '45001' set message_text = "Il vagone selezionato non e' parte del treno che percorre la corsa richiesta";
	end if;
    
    
    insert into `Spedizione` (`Azienda_Mittente`, `Azienda_Destinataria`, `Merce`, `Massa_Complessiva`, `Vagone_Merci`, `Data_Corsa`, `Tratta`)  values (var_Azienda_Mittente, var_Azienda_Destinataria, var_Merce, var_Massa_Complessiva, var_Vagone_Merci, var_Data_Corsa, var_Tratta);
	commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure aggiungi_treno_merci
-- -----------------------------------------------------

USE `Trasporto_Ferroviario_Alta_Velocita`;
DROP procedure IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`aggiungi_treno_merci`;

DELIMITER $$
USE `Trasporto_Ferroviario_Alta_Velocita`$$
CREATE PROCEDURE `aggiungi_treno_merci` (IN var_Matricola varchar(4), IN var_Numero_Vagoni int, IN var_Data_di_Acquisto date, IN var_Marca_Locomotrice varchar(45), IN var_Modello_Locomotrice varchar(45), IN var_Marca_Vagone varchar(45), IN var_Modello_Vagone varchar(45), IN var_Portata int)
BEGIN
    declare count int default 0;
    
	set transaction isolation level repeatable read;
	start transaction;
    insert into `Locomotrice` (`Marca`, `Modello`)  values (var_Marca_Locomotrice, var_Modello_Locomotrice);
    
	insert into `Treno_Merci` (`Matricola`, `Numero_Vagoni`, `Data_di_Acquisto`, `Locomotrice`)  values (var_Matricola, var_Numero_Vagoni, var_Data_di_Acquisto, last_insert_id());
	
	-- aggiungo vagoni
    vagoni_loop: loop
		if count >= var_Numero_Vagoni then
			leave vagoni_loop;
		end if;
        
        set count = count +1;
        
        insert into `Vagone_Merci` (`Marca`, `Modello`, `Portata`, `Treno`)  values (var_Marca_Vagone, var_Modello_Vagone, var_Portata, var_Matricola);
	end loop;
    
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure aggiungi_treno_passeggeri
-- -----------------------------------------------------

USE `Trasporto_Ferroviario_Alta_Velocita`;
DROP procedure IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`aggiungi_treno_passeggeri`;

DELIMITER $$
USE `Trasporto_Ferroviario_Alta_Velocita`$$
CREATE PROCEDURE `aggiungi_treno_passeggeri` (IN var_Matricola varchar(4), IN var_Numero_Vagoni int, IN var_Data_di_Acquisto date, IN var_Numero_Carrozze_I_Classe int, IN var_Numero_Carrozze_II_Classe int, IN var_Marca_Locomotrice varchar(45), IN var_Modello_Locomotrice varchar(45), IN var_Marca_Vagone_I_Classe varchar(45), IN var_Modello_Vagone_I_Classe varchar(45), IN var_Numero_Massimo_Passeggeri_Vagone_I_Classe int, IN var_Marca_Vagone_II_Classe varchar(45), IN var_Modello_Vagone_II_Classe varchar(45), IN var_Numero_Massimo_Passeggeri_Vagone_II_Classe int)

BEGIN
    declare count int default 0;
    declare count_posti int default 0;
    
	set transaction isolation level repeatable read;
	start transaction;
    insert into `Locomotrice` (`Marca`, `Modello`)  values (var_Marca_Locomotrice, var_Modello_Locomotrice);
    
	insert into `Treno_Passeggeri` (`Matricola`, `Numero_Vagoni`, `Data_di_Acquisto`, `Locomotrice`, `Numero_Carrozze_I_Classe`, `Numero_Carrozze_II_Classe`)  values (var_Matricola, var_Numero_Vagoni, var_Data_di_Acquisto, last_insert_id(), var_Numero_Carrozze_I_Classe, var_Numero_Carrozze_II_Classe);
	
	-- aggiungo vagoni prima classe
    prima_classe_loop: loop
		if count >= var_Numero_Carrozze_I_Classe then
			set count = 0;
			leave prima_classe_loop;
		end if;
        
        set count = count +1;
        
        insert into `Vagone_Passeggeri` (`Marca`, `Modello`, `Classe`, `Numero_Massimo_di_Passeggeri`, `Treno`)  values (var_Marca_Vagone_I_Classe, var_Modello_Vagone_I_Classe, '1', var_Numero_Massimo_Passeggeri_Vagone_I_Classe, var_Matricola);
        
		-- aggiungo posti prima classe
        posti_prima_classe_loop: loop
			if count_posti >= var_Numero_Massimo_Passeggeri_Vagone_I_Classe then
				set count_posti = 0;
				leave posti_prima_classe_loop;
			end if;
        
			set count_posti = count_posti +1;
        
			insert into Posto (Numero, Vagone_Passeggeri)  values (count_posti, last_insert_id());
			
        end loop;
	end loop;
    
	-- aggiungo vagoni seconda classe
    seconda_classe_loop: loop
		if count >= var_Numero_Carrozze_II_Classe then
			leave seconda_classe_loop;
		end if;
        
        set count = count +1;
        
        insert into `Vagone_Passeggeri` (`Marca`, `Modello`, `Classe`, `Numero_Massimo_di_Passeggeri`, `Treno`)  values (var_Marca_Vagone_II_Classe, var_Modello_Vagone_II_Classe, '2', var_Numero_Massimo_Passeggeri_Vagone_II_Classe, var_Matricola);
        
		-- aggiungo posti seconda classe
        posti_seconda_classe_loop: loop
			if count_posti >= var_Numero_Massimo_Passeggeri_Vagone_II_Classe then
				set count_posti = 0;
				leave posti_seconda_classe_loop;
			end if;
        
			set count_posti = count_posti +1;
        
			insert into Posto (Numero, Vagone_Passeggeri)  values (count_posti, last_insert_id());
			
        end loop;
	end loop;
    
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure convalida_biglietto
-- -----------------------------------------------------

USE `Trasporto_Ferroviario_Alta_Velocita`;
DROP procedure IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`convalida_biglietto`;

DELIMITER $$
USE `Trasporto_Ferroviario_Alta_Velocita`$$
CREATE PROCEDURE `convalida_biglietto` (in var_Codice_di_Prenotazione int)
BEGIN

	declare exit handler for sqlexception
    begin
        rollback;  -- rollback any changes made in the transaction
        resignal;  -- raise again the sql exception to the caller
    end;

	set transaction isolation level repeatable read;
	start transaction;
    
    if exists (select Biglietto.Codice_di_Prenotazione
				from `Biglietto`
                where Biglietto.Codice_di_Prenotazione = var_Codice_di_Prenotazione)
	then update `Biglietto`
		set  `Status` = 'convalidato'
        where Biglietto.Codice_di_prenotazione = var_Codice_di_prenotazione;
    else
		signal sqlstate '45002' set message_text = "Il codice immesso non e' stato trovato";
    end if;
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure crea_utente
-- -----------------------------------------------------

USE `Trasporto_Ferroviario_Alta_Velocita`;
DROP procedure IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`crea_utente`;

DELIMITER $$
USE `Trasporto_Ferroviario_Alta_Velocita`$$
CREATE PROCEDURE `crea_utente` (IN username VARCHAR(45), IN pass VARCHAR(45), IN ruolo varchar(45))
BEGIN
	insert into Utenti VALUES(username, MD5(pass), ruolo);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure genera_report_sui_turni_di_lavoro
-- -----------------------------------------------------

USE `Trasporto_Ferroviario_Alta_Velocita`;
DROP procedure IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`genera_report_sui_turni_di_lavoro`;

DELIMITER $$
USE `Trasporto_Ferroviario_Alta_Velocita`$$
CREATE PROCEDURE `genera_report_sui_turni_di_lavoro` (IN var_Lavoratore varchar(16), IN var_Testo_Rapporto varchar(500))
BEGIN
	declare var_entry_number int default 0;

	set transaction isolation level repeatable read;
	start transaction;
    insert into `Report_sui_turni` (`Lavoratore`, `Data`, `Testo_Rapporto`)  values (var_Lavoratore, current_date(), var_Testo_Rapporto);
commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserisci_orari_corsa_effettivi
-- -----------------------------------------------------

USE `Trasporto_Ferroviario_Alta_Velocita`;
DROP procedure IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`inserisci_orari_corsa_effettivi`;

DELIMITER $$
USE `Trasporto_Ferroviario_Alta_Velocita`$$
CREATE PROCEDURE `inserisci_orari_corsa_effettivi` (in var_Data date, in var_Tratta int, in var_Orario_Effettivo_di_Partenza datetime, in var_Orario_Effettivo_di_Arrivo datetime)
BEGIN
	set transaction isolation level repeatable read;
	start transaction;
    
    update `Corsa`
    set `Orario_Effettivo_di_Partenza` = var_Orario_Effettivo_di_Partenza and `Orario_Effettivo_di_Arrivo` = var_Orario_Effettivo_di_Arrivo
    where Corsa.`Data` = var_Data and Corsa.`Tratta` = var_Tratta;
    
    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure login
-- -----------------------------------------------------

USE `Trasporto_Ferroviario_Alta_Velocita`;
DROP procedure IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`login`;

DELIMITER $$
USE `Trasporto_Ferroviario_Alta_Velocita`$$
CREATE PROCEDURE `login` (in var_username varchar(45), in var_pass varchar(45), out var_role INT)
BEGIN
	declare var_user_role ENUM('Gestore_del_servizio', 'Lavoratore', 'Addetto_alla_manutenzione', 'Controllore', 'Acquirente');
    
	select `Ruolo` from `Utenti`
		where `Username` = var_username
        and `Password` = md5(var_pass)
        into var_user_role;
        
        -- See the corresponding enum in the client
		if var_user_role = 'Gestore_del_servizio' then
			set var_role = 1;
		elseif var_user_role = 'Lavoratore' then
			set var_role = 2;
		elseif var_user_role = 'Addetto_alla_manutenzione' then
			set var_role = 3;
		elseif var_user_role = 'Controllore' then
			set var_role = 4;
		else
			set var_role = 5;
		end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sostituisci_lavoratore
-- -----------------------------------------------------

USE `Trasporto_Ferroviario_Alta_Velocita`;
DROP procedure IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`sostituisci_lavoratore`;

DELIMITER $$
USE `Trasporto_Ferroviario_Alta_Velocita`$$
CREATE PROCEDURE `sostituisci_lavoratore` (IN var_Data_Turno date, IN var_Lavoratore_Malattia varchar(16) , IN var_Lavoratore_Sostituto varchar(16), IN var_Tratta int)
BEGIN
	declare exit handler for sqlexception
    begin
        rollback;  -- rollback any changes made in the transaction
        resignal;  -- raise again the sql exception to the caller
    end;
	
	set transaction isolation level repeatable read;
	start transaction;
    
    if (var_Data_Turno <= current_date()) then
		signal sqlstate '45001' set message_text = "Non è possibile modificare un turno passato";
	end if;
    
    if not exists (select *
					from `Turno`
                    where `Copertura` = 'coperto' and `Turno`.`Lavoratore` = var_Lavoratore_Malattia  and `Turno`.`Data_Corsa` = var_Data_Turno and `Turno`.`Tratta` = var_Tratta)
                    then
					signal sqlstate '45001' set message_text = "Non è stato possibile trovare un turno valido che corrispondesse ai criteri di ricerca";
	end if;
    
    if not exists (select  Malato.Ruolo = Sostituto.Ruolo
					from `Lavoratore` as `Malato`, `Lavoratore` as `Sostituto`
					where Malato.Codice_Fiscale =  var_Lavoratore_Malattia and Sostituto.Codice_Fiscale = var_Lavoratore_Sostituto) then
		signal sqlstate '45001' set message_text = "I lavoratori selezionati devono avere lo stesso ruolo";
	end if;
    
	update `Turno`
	set  `Copertura` = 'malattia'
	WHERE `Turno`.`Lavoratore` = var_Lavoratore_Malattia  and `Turno`.`Data_Corsa` = var_Data_Turno and `Turno`.`Tratta` = var_Tratta;
    
    INSERT INTO `Turno` (`Data_Corsa`, `Lavoratore`, `Tratta`) values (var_Data_Turno, var_Lavoratore_Sostituto, var_Tratta);
	commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure verifica_biglietto
-- -----------------------------------------------------

USE `Trasporto_Ferroviario_Alta_Velocita`;
DROP procedure IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`verifica_biglietto`;

DELIMITER $$
USE `Trasporto_Ferroviario_Alta_Velocita`$$
CREATE PROCEDURE `verifica_biglietto` (IN var_Codice_di_prenotazione int)
BEGIN
	
    set transaction isolation level read committed;
	start transaction read only;
    
	select `Codice_Fiscale`, `Nome`, `Cognome`, `Data_di_Nascita`
    from `Biglietto`
	where `Codice_di_prenotazione` = var_Codice_di_prenotazione;

    commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure visualizza_storico_treno_merci
-- -----------------------------------------------------

USE `Trasporto_Ferroviario_Alta_Velocita`;
DROP procedure IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`visualizza_storico_treno_merci`;

DELIMITER $$
USE `Trasporto_Ferroviario_Alta_Velocita`$$
CREATE PROCEDURE `visualizza_storico_treno_merci` (in var_Treno varchar(4))
BEGIN

	set transaction isolation level read committed;
	start transaction read only;
    
    -- storico manutenzione locomotrice
    
	select `Report_Manutenzione_Locomotrice`.`Timestamp`, `Report_Manutenzione_Locomotrice`.`Testo`
    from `Report_Manutenzione_Locomotrice` join `Locomotrice` on `Report_Manutenzione_Locomotrice`.`Locomotrice` = `Locomotrice`.`Id` join `Treno_Merci` on `Locomotrice`.`Id` = `Treno_Merci`.`Locomotrice`
	where `Treno_Merci`.`Matricola` = var_Treno
    order by `Report_Manutenzione_Locomotrice`.`Timestamp`;
    
    -- storico manutenzione vagoni
    
	select `Vagone_Merci`.`Id` as 'vagone', `Report_Manutenzione_Vagone_Merci`.`Timestamp`, `Report_Manutenzione_Vagone_Merci`.`Testo`
    from `Report_Manutenzione_Vagone_Merci` join `Vagone_Merci` on `Report_Manutenzione_Vagone_Merci`.`Vagone_Merci` = `Vagone_Merci`.`Id` join `Treno_Merci` on `Vagone_Merci`.`Treno` = `Treno_Merci`.`Matricola`
	where `Treno_Merci`.`Matricola` = var_Treno
    order by `Vagone_Merci`.`Id`, `Report_Manutenzione_Vagone_Merci`.`Timestamp`;

	commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure visualizza_storico_treno_passeggeri
-- -----------------------------------------------------

USE `Trasporto_Ferroviario_Alta_Velocita`;
DROP procedure IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`visualizza_storico_treno_passeggeri`;

DELIMITER $$
USE `Trasporto_Ferroviario_Alta_Velocita`$$
CREATE PROCEDURE `visualizza_storico_treno_passeggeri` (in var_Treno varchar(4))
BEGIN

	set transaction isolation level read committed;
	start transaction read only;

    -- storico manutenzione locomotrice

	select `Report_Manutenzione_Locomotrice`.`Timestamp`, `Report_Manutenzione_Locomotrice`.`Testo`
    from `Report_Manutenzione_Locomotrice` join `Locomotrice` on `Report_Manutenzione_Locomotrice`.`Locomotrice` = `Locomotrice`.`Id` join `Treno_Passeggeri` on `Locomotrice`.`Id` = `Treno_Passeggeri`.`Locomotrice`
	where `Treno_Passeggeri`.`Matricola` = var_Treno
    order by `Report_Manutenzione_Locomotrice`.`Timestamp`;
    
    -- storico manutenzione vagoni
    
	select `Vagone_Passeggeri`.`Id` as 'vagone', `Report_Manutenzione_Vagone_Passeggeri`.`Timestamp`, `Report_Manutenzione_Vagone_Passeggeri`.`Testo`
    from `Report_Manutenzione_Vagone_Passeggeri` join `Vagone_Passeggeri` on `Report_Manutenzione_Vagone_Passeggeri`.`Vagone_Passeggeri` = `Vagone_Passeggeri`.`Id` join `Treno_Passeggeri` on `Vagone_Passeggeri`.`Treno` = `Treno_Passeggeri`.`Matricola`
	where `Treno_Passeggeri`.`Matricola` = var_Treno
    order by `Vagone_Passeggeri`.`Id`, `Report_Manutenzione_Vagone_Passeggeri`.`Timestamp`;

	commit;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure aggiungi_turno_a_report_sui_turni
-- -----------------------------------------------------

USE `Trasporto_Ferroviario_Alta_Velocita`;
DROP procedure IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`aggiungi_turno_a_report_sui_turni`;

DELIMITER $$
USE `Trasporto_Ferroviario_Alta_Velocita`$$
CREATE PROCEDURE `aggiungi_turno_a_report_sui_turni` (in var_Data_Corsa date, in var_Tratta int, in var_Data_Report date)
BEGIN
	set transaction isolation level repeatable read;
	start transaction;
	insert into `Corsa_Report` (`Lavoratore`, `Data_Report`, `Data_Corsa`, `Tratta` ) values (var_Lavoratore, var_Data_Report, var_Data_Corsa, var_Tratta);
   commit;
END$$

DELIMITER ;
USE `Trasporto_Ferroviario_Alta_Velocita`;

DELIMITER $$

USE `Trasporto_Ferroviario_Alta_Velocita`$$
DROP TRIGGER IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Tratta_BEFORE_INSERT` $$
USE `Trasporto_Ferroviario_Alta_Velocita`$$
CREATE DEFINER = CURRENT_USER TRIGGER `Trasporto_Ferroviario_Alta_Velocita`.`Tratta_BEFORE_INSERT` BEFORE INSERT ON `Tratta` FOR EACH ROW
BEGIN
	-- controlla che gli orari siano validi
    if not ((NEW.Orario_Partenza between '00:00:00' and '24:00:00') or (NEW.Orario_Arrivo between '00:00:00' and '24:00:00'))
		then
		signal sqlstate '45000' set message_text = "Gli orari selezionati non sono validi";
	end if;
END$$


USE `Trasporto_Ferroviario_Alta_Velocita`$$
DROP TRIGGER IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Corsa_BEFORE_INSERT` $$
USE `Trasporto_Ferroviario_Alta_Velocita`$$
CREATE DEFINER = CURRENT_USER TRIGGER `Trasporto_Ferroviario_Alta_Velocita`.`Corsa_BEFORE_INSERT` BEFORE INSERT ON `Corsa` FOR EACH ROW
BEGIN
	-- controlla la data degli orari
    if ((not (date(NEW.Orario_Effettivo_di_Partenza) = NEW.`Data` and date(NEW.Orario_Effettivo_di_Arrivo) >= NEW.`Data`)) and (NEW.Orario_Effettivo_di_Partenza <> null or NEW.Orario_Effettivo_di_Partenza <> null))
		then
		signal sqlstate '45000' set message_text = "La data inserita negli orari non corrisponde a quella della corsa";
	end if;
END$$


USE `Trasporto_Ferroviario_Alta_Velocita`$$
DROP TRIGGER IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Report_sui_turni_BEFORE_INSERT` $$
USE `Trasporto_Ferroviario_Alta_Velocita`$$
CREATE DEFINER = CURRENT_USER TRIGGER `Trasporto_Ferroviario_Alta_Velocita`.`Report_sui_turni_BEFORE_INSERT` BEFORE INSERT ON `Report_sui_turni` FOR EACH ROW
BEGIN
	if (select week(Report_sui_turni.`Data`, 1)
		from `Report_sui_turni`
        where Report_sui_turni.Lavoratore = NEW.Lavoratore 
        and year(Report_sui_turni.`Data`) = year(NEW.`Data`)) = week(NEW.`Data`, 1)
        then
		signal sqlstate '45000' set message_text = "Non e' possibile aggiungere piu' di un report sui turni per settimana";
	end if;
END$$


USE `Trasporto_Ferroviario_Alta_Velocita`$$
DROP TRIGGER IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Corsa_Report_BEFORE_INSERT` $$
USE `Trasporto_Ferroviario_Alta_Velocita`$$
CREATE DEFINER = CURRENT_USER TRIGGER `Trasporto_Ferroviario_Alta_Velocita`.`Corsa_Report_BEFORE_INSERT` BEFORE INSERT ON `Corsa_Report` FOR EACH ROW
BEGIN
	-- controlla che il turno scelto esista
    
    if not exists (select *
					from `Turno`
                    where Turno.Lavoratore = NEW.Lavoratore and Turno.Data_Corsa = NEW.Data_Corsa and Turno.Tratta = NEW.Tratta)
		then
		signal sqlstate '45000' set message_text = "Il turno selezionato non esiste";
	end if;
END$$


USE `Trasporto_Ferroviario_Alta_Velocita`$$
DROP TRIGGER IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Ferma_BEFORE_INSERT` $$
USE `Trasporto_Ferroviario_Alta_Velocita`$$
CREATE DEFINER = CURRENT_USER TRIGGER `Trasporto_Ferroviario_Alta_Velocita`.`Ferma_BEFORE_INSERT` BEFORE INSERT ON `Ferma` FOR EACH ROW
BEGIN
	-- controlla che gli orari siano validi
    if not ((NEW.Orario_Partenza between '00:00:00' and '24:00:00') or (NEW.Orario_Arrivo between '00:00:00' and '24:00:00'))
		then
		signal sqlstate '45000' set message_text = "Gli orari selezionati non sono validi";
	end if;
END$$


USE `Trasporto_Ferroviario_Alta_Velocita`$$
DROP TRIGGER IF EXISTS `Trasporto_Ferroviario_Alta_Velocita`.`Turno_BEFORE_INSERT` $$
USE `Trasporto_Ferroviario_Alta_Velocita`$$
CREATE DEFINER = CURRENT_USER TRIGGER `Trasporto_Ferroviario_Alta_Velocita`.`Turno_BEFORE_INSERT` BEFORE INSERT ON `Turno` FOR EACH ROW
BEGIN
	declare var_Nuovo_Orario_Partenza time;
    declare var_Nuovo_Orario_Arrivo time;
    declare var_new_shift_length int default 0;
	
    select Tratta.Orario_Partenza, Tratta.Orario_Arrivo
    from `Tratta`
    where NEW.Tratta = Tratta.Codice
    into var_Nuovo_Orario_Partenza, var_Nuovo_Orario_Arrivo;

	-- due turni non si possono sovrapporre
	if exists (select *
	from `Turno` join `Tratta` on Turno.Tratta = Tratta.Codice
	where Turno.Lavoratore = NEW.Lavoratore
	and Turno.Data_Corsa = NEW.Data_Corsa
	and ((Tratta.Orario_Partenza between var_Nuovo_Orario_Partenza and var_Nuovo_Orario_Arrivo) or
		(Tratta.Orario_Arrivo between var_Nuovo_Orario_Partenza and var_Nuovo_Orario_Arrivo)))
        then
		signal sqlstate '45000' set message_text = "Non e' possibile aggiungere un turno che si sovrapponga ad un altro";
	end if;
    
	-- al lavoratore non possono essere assegnati piu' di cinque turni per settimana
	if (select count(*)
		from `Turno`
		where Turno.Lavoratore = NEW.Lavoratore 
        and week(Turno.Data_Corsa, 1) = week(NEW.Data_Corsa, 1)
        and year(Turno.Data_Corsa) = year(NEW.Data_Corsa)) >= 5
        then
		signal sqlstate '45000' set message_text = "Non e' possibile assegnare ad un lavoratore piu' di cinque turni in una settimana";
	end if;
    
	-- un lavoratore non puo' effettuare più di quattro ore di lavoro a settimana
    
    select if(timestampdiff(second, Orario_Partenza, Orario_Arrivo) >0, timestampdiff(second, Orario_Partenza, Orario_Arrivo), timestampdiff(second, Orario_Partenza, Orario_Arrivo) + 24*3600)
	from `Tratta`
	where `Tratta`.`Codice` = NEW.Tratta
    into var_new_shift_length;
    
	if(select sum(if(timestampdiff(second, Orario_Partenza, Orario_Arrivo) >0, timestampdiff(second, Orario_Partenza, Orario_Arrivo), timestampdiff(second, Orario_Partenza, Orario_Arrivo) + 24*3600))
		from `Turno` join `Tratta` on `Turno`.Tratta = `Tratta`.`Codice`
		where Turno.Lavoratore = NEW.Lavoratore 
			and Turno.Copertura = 'coperto'
			and week(Turno.Data_Corsa, 1) = week(NEW.Data_Corsa, 1)
			and year(Turno.Data_Corsa) = year(NEW.Data_Corsa)) >= 4*3600 - var_new_shift_length then
		signal sqlstate '45000' set message_text = "Un lavoratore non puo' effettuare piu' di quattro ore di lavoro a settimana";
	end if;
END$$


DELIMITER ;
SET SQL_MODE = '';
DROP USER IF EXISTS Gestore_del_servizio;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'Gestore_del_servizio' IDENTIFIED BY 'Gestore_del_servizio';

GRANT EXECUTE ON procedure `Trasporto_Ferroviario_Alta_Velocita`.`aggiungi_azienda` TO 'Gestore_del_servizio';
GRANT EXECUTE ON procedure `Trasporto_Ferroviario_Alta_Velocita`.`aggiungi_corsa_treno_merci` TO 'Gestore_del_servizio';
GRANT EXECUTE ON procedure `Trasporto_Ferroviario_Alta_Velocita`.`aggiungi_corsa_treno_passeggeri` TO 'Gestore_del_servizio';
GRANT EXECUTE ON procedure `Trasporto_Ferroviario_Alta_Velocita`.`aggiungi_lavoratore` TO 'Gestore_del_servizio';
GRANT EXECUTE ON procedure `Trasporto_Ferroviario_Alta_Velocita`.`aggiungi_spedizione` TO 'Gestore_del_servizio';
GRANT EXECUTE ON procedure `Trasporto_Ferroviario_Alta_Velocita`.`aggiungi_treno_merci` TO 'Gestore_del_servizio';
GRANT EXECUTE ON procedure `Trasporto_Ferroviario_Alta_Velocita`.`aggiungi_treno_passeggeri` TO 'Gestore_del_servizio';
GRANT EXECUTE ON procedure `Trasporto_Ferroviario_Alta_Velocita`.`crea_utente` TO 'Gestore_del_servizio';
GRANT EXECUTE ON procedure `Trasporto_Ferroviario_Alta_Velocita`.`inserisci_orari_corsa_effettivi` TO 'Gestore_del_servizio';
GRANT EXECUTE ON procedure `Trasporto_Ferroviario_Alta_Velocita`.`sostituisci_lavoratore` TO 'Gestore_del_servizio';
GRANT EXECUTE ON procedure `Trasporto_Ferroviario_Alta_Velocita`.`visualizza_storico_treno_merci` TO 'Gestore_del_servizio';
GRANT EXECUTE ON procedure `Trasporto_Ferroviario_Alta_Velocita`.`visualizza_storico_treno_passeggeri` TO 'Gestore_del_servizio';
SET SQL_MODE = '';
DROP USER IF EXISTS Lavoratore;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'Lavoratore' IDENTIFIED BY 'Lavoratore';

GRANT EXECUTE ON procedure `Trasporto_Ferroviario_Alta_Velocita`.`genera_report_sui_turni_di_lavoro` TO 'Lavoratore';
SET SQL_MODE = '';
DROP USER IF EXISTS Acquirente;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'Acquirente' IDENTIFIED BY 'Acquirente';

GRANT EXECUTE ON procedure `Trasporto_Ferroviario_Alta_Velocita`.`acquista_biglietto` TO 'Acquirente';
SET SQL_MODE = '';
DROP USER IF EXISTS Controllore;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'Controllore' IDENTIFIED BY 'Controllore';

GRANT EXECUTE ON procedure `Trasporto_Ferroviario_Alta_Velocita`.`verifica_biglietto` TO 'Controllore';
GRANT EXECUTE ON procedure `Trasporto_Ferroviario_Alta_Velocita`.`convalida_biglietto` TO 'Controllore';
SET SQL_MODE = '';
DROP USER IF EXISTS Addetto_alla_manutenzione;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'Addetto_alla_manutenzione' IDENTIFIED BY 'Addetto_alla_manutenzione';

GRANT EXECUTE ON procedure `Trasporto_Ferroviario_Alta_Velocita`.`aggiungi_report_manutenzione_locomotrice` TO 'Addetto_alla_manutenzione';
GRANT EXECUTE ON procedure `Trasporto_Ferroviario_Alta_Velocita`.`aggiungi_report_manutenzione_vagone_merci` TO 'Addetto_alla_manutenzione';
GRANT EXECUTE ON procedure `Trasporto_Ferroviario_Alta_Velocita`.`aggiungi_report_manutenzione_vagone_passeggeri` TO 'Addetto_alla_manutenzione';
SET SQL_MODE = '';
DROP USER IF EXISTS Login;
SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
CREATE USER 'Login' IDENTIFIED BY 'Login';

GRANT EXECUTE ON procedure `Trasporto_Ferroviario_Alta_Velocita`.`login` TO 'Login';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `Trasporto_Ferroviario_Alta_Velocita`.`Azienda`
-- -----------------------------------------------------
START TRANSACTION;
USE `Trasporto_Ferroviario_Alta_Velocita`;
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Azienda` (`Partita_IVA`, `Recapito`, `Ragione_Sociale`) VALUES ('a', 'a', 'a');
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Azienda` (`Partita_IVA`, `Recapito`, `Ragione_Sociale`) VALUES ('b', 'b', 'b');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Trasporto_Ferroviario_Alta_Velocita`.`Locomotrice`
-- -----------------------------------------------------
START TRANSACTION;
USE `Trasporto_Ferroviario_Alta_Velocita`;
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Locomotrice` (`Id`, `Marca`, `Modello`) VALUES (1, 'a', 'a');
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Locomotrice` (`Id`, `Marca`, `Modello`) VALUES (2, 'a', 'a');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Trasporto_Ferroviario_Alta_Velocita`.`Treno_Passeggeri`
-- -----------------------------------------------------
START TRANSACTION;
USE `Trasporto_Ferroviario_Alta_Velocita`;
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Treno_Passeggeri` (`Matricola`, `Numero_Vagoni`, `Data_di_Acquisto`, `Locomotrice`, `Numero_Carrozze_I_Classe`, `Numero_Carrozze_II_Classe`) VALUES ('2', 3, '2017-06-02', 2, 1, 2);

COMMIT;


-- -----------------------------------------------------
-- Data for table `Trasporto_Ferroviario_Alta_Velocita`.`Vagone_Passeggeri`
-- -----------------------------------------------------
START TRANSACTION;
USE `Trasporto_Ferroviario_Alta_Velocita`;
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Vagone_Passeggeri` (`Id`, `Marca`, `Modello`, `Classe`, `Numero_Massimo_di_Passeggeri`, `Treno`) VALUES (1, 'a', 'a', '1', 5, '2');
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Vagone_Passeggeri` (`Id`, `Marca`, `Modello`, `Classe`, `Numero_Massimo_di_Passeggeri`, `Treno`) VALUES (2, 'b', 'b', '2', 4, '2');
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Vagone_Passeggeri` (`Id`, `Marca`, `Modello`, `Classe`, `Numero_Massimo_di_Passeggeri`, `Treno`) VALUES (3, 'b', 'b', '2', 4, '2');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Trasporto_Ferroviario_Alta_Velocita`.`Posto`
-- -----------------------------------------------------
START TRANSACTION;
USE `Trasporto_Ferroviario_Alta_Velocita`;
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Posto` (`Numero`, `Vagone_Passeggeri`) VALUES (1, 1);
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Posto` (`Numero`, `Vagone_Passeggeri`) VALUES (2, 1);
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Posto` (`Numero`, `Vagone_Passeggeri`) VALUES (3, 1);
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Posto` (`Numero`, `Vagone_Passeggeri`) VALUES (4, 1);
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Posto` (`Numero`, `Vagone_Passeggeri`) VALUES (5, 1);
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Posto` (`Numero`, `Vagone_Passeggeri`) VALUES (1, 2);
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Posto` (`Numero`, `Vagone_Passeggeri`) VALUES (2, 2);
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Posto` (`Numero`, `Vagone_Passeggeri`) VALUES (3, 2);
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Posto` (`Numero`, `Vagone_Passeggeri`) VALUES (4, 2);
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Posto` (`Numero`, `Vagone_Passeggeri`) VALUES (1, 3);
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Posto` (`Numero`, `Vagone_Passeggeri`) VALUES (2, 3);
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Posto` (`Numero`, `Vagone_Passeggeri`) VALUES (3, 3);
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Posto` (`Numero`, `Vagone_Passeggeri`) VALUES (4, 3);

COMMIT;


-- -----------------------------------------------------
-- Data for table `Trasporto_Ferroviario_Alta_Velocita`.`Stazione`
-- -----------------------------------------------------
START TRANSACTION;
USE `Trasporto_Ferroviario_Alta_Velocita`;
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Stazione` (`Codice`, `Nome`, `Citta`, `Provincia`) VALUES (1, 'part', 'aq', 'aq');
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Stazione` (`Codice`, `Nome`, `Citta`, `Provincia`) VALUES (2, 'arr', 'aq', 'aq');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Trasporto_Ferroviario_Alta_Velocita`.`Tratta`
-- -----------------------------------------------------
START TRANSACTION;
USE `Trasporto_Ferroviario_Alta_Velocita`;
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Tratta` (`Codice`, `Capolinea_di_Partenza`, `Capolinea_di_Arrivo`, `Orario_Partenza`, `Orario_Arrivo`) VALUES (1, 1, 2, '16:00:00', '17:00:00');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Trasporto_Ferroviario_Alta_Velocita`.`Corsa`
-- -----------------------------------------------------
START TRANSACTION;
USE `Trasporto_Ferroviario_Alta_Velocita`;
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Corsa` (`Data`, `Tratta`, `Orario_Effettivo_di_Partenza`, `Orario_Effettivo_di_Arrivo`) VALUES ('2021-01-01', 1, NULL, NULL);
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Corsa` (`Data`, `Tratta`, `Orario_Effettivo_di_Partenza`, `Orario_Effettivo_di_Arrivo`) VALUES ('2021-01-02', 1, NULL, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `Trasporto_Ferroviario_Alta_Velocita`.`Corsa_Treno_Passeggeri`
-- -----------------------------------------------------
START TRANSACTION;
USE `Trasporto_Ferroviario_Alta_Velocita`;
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Corsa_Treno_Passeggeri` (`Data_Corsa`, `Tratta`, `Treno_Passeggeri`) VALUES ('2021-01-02', 1, '2');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Trasporto_Ferroviario_Alta_Velocita`.`Lavoratore`
-- -----------------------------------------------------
START TRANSACTION;
USE `Trasporto_Ferroviario_Alta_Velocita`;
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Lavoratore` (`Codice_Fiscale`, `Nome`, `Cognome`, `Data_di_Nascita`, `Citta_di_Nascita`, `Ruolo`, `Provincia_di_Nascita`) VALUES ('a', 'a', 'a', '2017-06-02', 'a', 'conducente', 'aq');
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Lavoratore` (`Codice_Fiscale`, `Nome`, `Cognome`, `Data_di_Nascita`, `Citta_di_Nascita`, `Ruolo`, `Provincia_di_Nascita`) VALUES ('b', 'b', 'b', '2017-06-02', 'a', 'capotreno', 'aq');
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Lavoratore` (`Codice_Fiscale`, `Nome`, `Cognome`, `Data_di_Nascita`, `Citta_di_Nascita`, `Ruolo`, `Provincia_di_Nascita`) VALUES ('c', 'c', 'c', '2017-06-02', 'c', 'conducente', 'aq');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Trasporto_Ferroviario_Alta_Velocita`.`Treno_Merci`
-- -----------------------------------------------------
START TRANSACTION;
USE `Trasporto_Ferroviario_Alta_Velocita`;
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Treno_Merci` (`Matricola`, `Numero_Vagoni`, `Data_di_Acquisto`, `Locomotrice`) VALUES ('1', 2, '2017-02-05', 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `Trasporto_Ferroviario_Alta_Velocita`.`Corsa_Treno_Merci`
-- -----------------------------------------------------
START TRANSACTION;
USE `Trasporto_Ferroviario_Alta_Velocita`;
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Corsa_Treno_Merci` (`Data_Corsa`, `Tratta`, `Treno_Merci`) VALUES ('2021-01-01', 1, '1');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Trasporto_Ferroviario_Alta_Velocita`.`Report_Manutenzione_Locomotrice`
-- -----------------------------------------------------
START TRANSACTION;
USE `Trasporto_Ferroviario_Alta_Velocita`;
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Report_Manutenzione_Locomotrice` (`Locomotrice`, `Testo`, `Timestamp`) VALUES (1, 'ok', '2021-04-18 16:10:59');
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Report_Manutenzione_Locomotrice` (`Locomotrice`, `Testo`, `Timestamp`) VALUES (2, 'ok', '2021-04-18 16:11:59');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Trasporto_Ferroviario_Alta_Velocita`.`Vagone_Merci`
-- -----------------------------------------------------
START TRANSACTION;
USE `Trasporto_Ferroviario_Alta_Velocita`;
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Vagone_Merci` (`Id`, `Marca`, `Modello`, `Portata`, `Treno`) VALUES (1, 'a', 'a', 20, '1');
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Vagone_Merci` (`Id`, `Marca`, `Modello`, `Portata`, `Treno`) VALUES (2, 'a', 'a', 20, '1');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Trasporto_Ferroviario_Alta_Velocita`.`Report_Manutenzione_Vagone_Merci`
-- -----------------------------------------------------
START TRANSACTION;
USE `Trasporto_Ferroviario_Alta_Velocita`;
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Report_Manutenzione_Vagone_Merci` (`Vagone_Merci`, `Testo`, `Timestamp`) VALUES (1, 'ok', '2021-04-18 16:12:59');
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Report_Manutenzione_Vagone_Merci` (`Vagone_Merci`, `Testo`, `Timestamp`) VALUES (2, 'not ok', '2021-04-18 16:13:59');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Trasporto_Ferroviario_Alta_Velocita`.`Report_Manutenzione_Vagone_Passeggeri`
-- -----------------------------------------------------
START TRANSACTION;
USE `Trasporto_Ferroviario_Alta_Velocita`;
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Report_Manutenzione_Vagone_Passeggeri` (`Vagone_Passeggeri`, `Testo`, `Timestamp`) VALUES (1, 'ok', '2021-04-18 16:14:59');
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Report_Manutenzione_Vagone_Passeggeri` (`Vagone_Passeggeri`, `Testo`, `Timestamp`) VALUES (2, 'ok', '2021-04-18 16:15:59');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Trasporto_Ferroviario_Alta_Velocita`.`Turno`
-- -----------------------------------------------------
START TRANSACTION;
USE `Trasporto_Ferroviario_Alta_Velocita`;
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Turno` (`Lavoratore`, `Data_Corsa`, `Tratta`, `Copertura`) VALUES ('a', '2021-01-01', 1, 'coperto');
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Turno` (`Lavoratore`, `Data_Corsa`, `Tratta`, `Copertura`) VALUES ('a', '2021-01-02', 1, 'coperto');
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Turno` (`Lavoratore`, `Data_Corsa`, `Tratta`, `Copertura`) VALUES ('b', '2021-01-02', 1, 'coperto');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Trasporto_Ferroviario_Alta_Velocita`.`Utenti`
-- -----------------------------------------------------
START TRANSACTION;
USE `Trasporto_Ferroviario_Alta_Velocita`;
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Utenti` (`Username`, `Password`, `Ruolo`) VALUES ('aldo', '0c88028bf3aa6a6a143ed846f2be1ea4', 'Lavoratore');
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Utenti` (`Username`, `Password`, `Ruolo`) VALUES ('giovanni', '0c88028bf3aa6a6a143ed846f2be1ea4', 'Gestore_del_servizio');
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Utenti` (`Username`, `Password`, `Ruolo`) VALUES ('giacomo', '0c88028bf3aa6a6a143ed846f2be1ea4', 'Addetto_alla_manutenzione');
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Utenti` (`Username`, `Password`, `Ruolo`) VALUES ('luigi', '0c88028bf3aa6a6a143ed846f2be1ea4', 'Controllore');
INSERT INTO `Trasporto_Ferroviario_Alta_Velocita`.`Utenti` (`Username`, `Password`, `Ruolo`) VALUES ('mario', '0c88028bf3aa6a6a143ed846f2be1ea4', 'Acquirente');

COMMIT;

