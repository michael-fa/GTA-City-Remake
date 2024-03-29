-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Erstellungszeit: 14. Dez 2023 um 10:27
-- Server-Version: 10.4.16-MariaDB
-- PHP-Version: 7.4.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `gtacity`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `accounts`
--

CREATE TABLE `accounts` (
  `id` int(11) NOT NULL,
  `name` varchar(24) NOT NULL,
  `password` text NOT NULL,
  `salt` text NOT NULL,
  `last_seen` int(11) NOT NULL,
  `last_ip` text NOT NULL,
  `regdate` int(11) NOT NULL,
  `rank` int(11) NOT NULL,
  `sex` int(11) NOT NULL,
  `ziviskin` int(11) NOT NULL,
  `money` int(11) NOT NULL,
  `bank` int(11) NOT NULL,
  `level` int(11) NOT NULL,
  `respekt` int(11) NOT NULL,
  `players_advertised` int(11) NOT NULL,
  `perso` int(11) NOT NULL,
  `job` int(11) NOT NULL,
  `fahrschein` int(11) NOT NULL,
  `hunger` float NOT NULL,
  `intutorial` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `accounts`
--

INSERT INTO `accounts` (`id`, `name`, `password`, `salt`, `last_seen`, `last_ip`, `regdate`, `rank`, `sex`, `ziviskin`, `money`, `bank`, `level`, `respekt`, `players_advertised`, `perso`, `job`, `fahrschein`, `hunger`, `intutorial`) VALUES
(1, 'Chester_Bennington', '4DB7324D2CC614B72F2342A6C3D63C098E5C4672ED754405BF224161501A752E', '63Rw23z', 1702545924, '127.0.0.1:57543', 1702545782, 0, 0, 2, 5000, 10000, 0, 0, 0, 0, 0, 0, 98.82, 0);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `biz`
--

CREATE TABLE `biz` (
  `id` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `owner` int(11) NOT NULL,
  `kasse` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  `custom_name` int(11) NOT NULL,
  `p_x` int(11) NOT NULL,
  `p_y` int(11) NOT NULL,
  `p_z` int(11) NOT NULL,
  `p_r` float NOT NULL,
  `int_x` int(11) NOT NULL,
  `int_y` int(11) NOT NULL,
  `int_z` int(11) NOT NULL,
  `int_r` int(11) NOT NULL,
  `interior` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `biz`
--

INSERT INTO `biz` (`id`, `type`, `owner`, `kasse`, `price`, `custom_name`, `p_x`, `p_y`, `p_z`, `p_r`, `int_x`, `int_y`, `int_z`, `int_r`, `interior`) VALUES
(1, 0, 0, 0, 650000, 0, 1833, -1842, 14, 93.5628, -26, -187, 1004, 354, 17);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `gamemode`
--

CREATE TABLE `gamemode` (
  `staatskasse` int(11) NOT NULL,
  `license_price_0` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `gamemode`
--

INSERT INTO `gamemode` (`staatskasse`, `license_price_0`) VALUES
(100, 100);

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `biz`
--
ALTER TABLE `biz`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `accounts`
--
ALTER TABLE `accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT für Tabelle `biz`
--
ALTER TABLE `biz`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
