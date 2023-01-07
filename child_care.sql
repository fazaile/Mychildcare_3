-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 07, 2023 at 04:05 AM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.1.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `child_care`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_table`
--

CREATE TABLE `activity_table` (
  `activity_id` int(11) NOT NULL,
  `classroom_id` int(11) NOT NULL,
  `activity_image` text NOT NULL,
  `activity_description` text NOT NULL,
  `activity_date` date NOT NULL,
  `activity_start` datetime NOT NULL,
  `activity_end` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `admin_table`
--

CREATE TABLE `admin_table` (
  `admin_id` int(11) NOT NULL,
  `admin_name` varchar(50) NOT NULL,
  `admin_email` varchar(50) NOT NULL,
  `admin_password` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_table`
--

INSERT INTO `admin_table` (`admin_id`, `admin_name`, `admin_email`, `admin_password`) VALUES
(1, 'admin', 'admin@admin.com', 'admin123');

-- --------------------------------------------------------

--
-- Table structure for table `children_table`
--

CREATE TABLE `children_table` (
  `children_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `classroom_id` int(11) NOT NULL,
  `name` text NOT NULL,
  `age` int(11) NOT NULL,
  `image` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `children_table`
--

INSERT INTO `children_table` (`children_id`, `user_id`, `classroom_id`, `name`, `age`, `image`) VALUES
(2, 1, 0, 'Zubaidah', 0, 'https://i.imgur.com/dXXbPky.jpg'),
(12, 0, 0, 'Kasim', 5, 'https://i.imgur.com/3L7Wbn0.jpg'),
(17, 0, 0, 'Ahmad Maslan', 4, 'https://i.imgur.com/roL3ydH.jpg'),
(19, 0, 0, 'aa', 2, 'https://i.imgur.com/dQxuVWz.jpg'),
(20, 0, 0, 'aab', 2, 'https://i.imgur.com/NRLkW7P.jpg'),
(21, 0, 0, 'aabcd', 2, 'https://i.imgur.com/dDKvrZh.jpg'),
(22, 0, 0, 'aabcde', 2, 'https://i.imgur.com/kCzCIXO.jpg'),
(23, 0, 0, 'aabcde', 2, 'https://i.imgur.com/USofWhi.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `classroom_table`
--

CREATE TABLE `classroom_table` (
  `classroom_id` int(11) NOT NULL,
  `classroom_name` varchar(11) NOT NULL,
  `classroom_capacity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `classroom_table`
--

INSERT INTO `classroom_table` (`classroom_id`, `classroom_name`, `classroom_capacity`) VALUES
(1, 'Caterpillar', 20),
(2, 'Butterfly', 20),
(3, 'Tiger', 20);

-- --------------------------------------------------------

--
-- Table structure for table `menu_table`
--

CREATE TABLE `menu_table` (
  `menu_id` int(11) NOT NULL,
  `classroom_id` int(11) NOT NULL,
  `menu_name` varchar(50) NOT NULL,
  `menu_date` date NOT NULL,
  `menu_start_time` time NOT NULL,
  `menu_end_time` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `skill_table`
--

CREATE TABLE `skill_table` (
  `skil_id` int(11) NOT NULL,
  `communication` int(11) NOT NULL,
  `reading` int(11) NOT NULL,
  `counting` int(11) NOT NULL,
  `art` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `teacher_table`
--

CREATE TABLE `teacher_table` (
  `teacher_id` int(11) NOT NULL,
  `teacher_name` varchar(50) NOT NULL,
  `teacher_email` varchar(50) NOT NULL,
  `teacher_password` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teacher_table`
--

INSERT INTO `teacher_table` (`teacher_id`, `teacher_name`, `teacher_email`, `teacher_password`) VALUES
(1, 'teacher', 'teacher@teacher.com', 'teacher1234'),
(2, 'teacher1', 'teacher1@teacher.com', 'teacher1234\r\n');

-- --------------------------------------------------------

--
-- Table structure for table `users_table`
--

CREATE TABLE `users_table` (
  `user_id` int(11) NOT NULL,
  `user_name` varchar(100) NOT NULL,
  `user_email` varchar(100) NOT NULL,
  `user_password` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_table`
--

INSERT INTO `users_table` (`user_id`, `user_name`, `user_email`, `user_password`) VALUES
(1, 'test', 'test@test.com', '16d7a4fca7442dda3ad93c9a726597e4'),
(2, 'test', 'test1@test.com', '16d7a4fca7442dda3ad93c9a726597e4');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity_table`
--
ALTER TABLE `activity_table`
  ADD PRIMARY KEY (`activity_id`);

--
-- Indexes for table `admin_table`
--
ALTER TABLE `admin_table`
  ADD PRIMARY KEY (`admin_id`);

--
-- Indexes for table `children_table`
--
ALTER TABLE `children_table`
  ADD PRIMARY KEY (`children_id`);

--
-- Indexes for table `classroom_table`
--
ALTER TABLE `classroom_table`
  ADD PRIMARY KEY (`classroom_id`);

--
-- Indexes for table `menu_table`
--
ALTER TABLE `menu_table`
  ADD PRIMARY KEY (`menu_id`);

--
-- Indexes for table `skill_table`
--
ALTER TABLE `skill_table`
  ADD PRIMARY KEY (`skil_id`);

--
-- Indexes for table `teacher_table`
--
ALTER TABLE `teacher_table`
  ADD PRIMARY KEY (`teacher_id`);

--
-- Indexes for table `users_table`
--
ALTER TABLE `users_table`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_table`
--
ALTER TABLE `activity_table`
  MODIFY `activity_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `admin_table`
--
ALTER TABLE `admin_table`
  MODIFY `admin_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `children_table`
--
ALTER TABLE `children_table`
  MODIFY `children_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `classroom_table`
--
ALTER TABLE `classroom_table`
  MODIFY `classroom_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `menu_table`
--
ALTER TABLE `menu_table`
  MODIFY `menu_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `skill_table`
--
ALTER TABLE `skill_table`
  MODIFY `skil_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `teacher_table`
--
ALTER TABLE `teacher_table`
  MODIFY `teacher_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `users_table`
--
ALTER TABLE `users_table`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
