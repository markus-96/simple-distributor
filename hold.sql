-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Erstellungszeit: 13. Mrz 2021 um 16:05
-- Server-Version: 8.0.23-0ubuntu0.20.04.1
-- PHP-Version: 7.4.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `vmail`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `hold`
--

CREATE TABLE `hold` (
  `id` int UNSIGNED NOT NULL,
  `destination_username` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `destination_domain` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `hold` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `hold`
--
ALTER TABLE `hold`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `source_username` (`destination_username`,`destination_domain`),
  ADD KEY `destination_domain` (`destination_domain`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `hold`
--
ALTER TABLE `hold`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `hold`
--
ALTER TABLE `hold`
  ADD CONSTRAINT `hold_ibfk_1` FOREIGN KEY (`destination_domain`) REFERENCES `domains` (`domain`) ON DELETE RESTRICT ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
