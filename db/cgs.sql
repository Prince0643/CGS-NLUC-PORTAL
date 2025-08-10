-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 10, 2025 at 04:53 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cgs`
--

-- --------------------------------------------------------

--
-- Table structure for table `announcements`
--

CREATE TABLE `announcements` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `announcements`
--

INSERT INTO `announcements` (`id`, `title`, `message`, `created_by`, `created_at`) VALUES
(1, 'adsafsa', 'dsadsadsa', 6, '2025-08-07 15:03:15');

-- --------------------------------------------------------

--
-- Table structure for table `chatbot_responses`
--

CREATE TABLE `chatbot_responses` (
  `id` int(11) NOT NULL,
  `keyword` varchar(100) NOT NULL,
  `response` text NOT NULL,
  `category` varchar(50) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `chatbot_responses`
--

INSERT INTO `chatbot_responses` (`id`, `keyword`, `response`, `category`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'grade', 'You can find your grade in the office.', NULL, 1, '2025-06-26 17:04:04', '2025-06-26 17:04:04'),
(3, 'thank', 'You\'re welcome!', NULL, 1, '2025-06-26 17:10:11', '2025-06-26 17:10:11'),
(4, 'subject', 'You can view your subjects in the \"Subject\" tab.', NULL, 1, '2025-06-26 17:11:01', '2025-06-26 17:11:01');

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `course_id` int(11) NOT NULL,
  `course_code` varchar(50) NOT NULL,
  `program_id` int(11) NOT NULL,
  `course_description` text NOT NULL,
  `units` int(11) NOT NULL,
  `offered` enum('offered','not offered') NOT NULL DEFAULT 'offered'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`course_id`, `course_code`, `program_id`, `course_description`, `units`, `offered`) VALUES
(1, 'PHEA 301', 1, 'Philosophical and Critical Perspectives in Educational Administration', 3, 'offered'),
(2, 'PHEA 311', 1, 'Administrative Reforms and Innovations in Education', 3, 'offered'),
(3, 'PHEA 314', 1, 'Dissertation Writing', 6, 'offered'),
(4, 'PHAG 313', 2, 'Program Planning and Project Development', 3, 'offered'),
(5, 'PHAG 309', 2, 'Advanced Seed Production and Processing', 3, 'offered'),
(6, 'PHAG 314', 2, 'Dissertation Writing', 6, 'offered'),
(7, 'PHAS 310', 3, 'Program Planning and Project Development', 3, 'offered'),
(8, 'PHAS 309', 3, 'Animal Diseases and Parasites', 3, 'offered'),
(9, 'PHAS 314', 3, 'Dissertation Writing', 6, 'offered'),
(10, 'MAEM 202', 4, 'Methods of Research', 3, 'offered'),
(11, 'MAEM 203', 4, 'Legal Bases of Education', 3, 'offered'),
(12, 'MAEM 213', 4, 'Thesis Writing 1', 3, 'offered'),
(13, 'MATL 206', 5, 'Home Economic II (Sustainable Household Consumption)', 3, 'offered'),
(14, 'MATL 204', 5, 'Administration and Supervision of TLE', 3, 'offered'),
(15, 'MATL 213', 5, 'Thesis Writing', 3, 'offered'),
(16, 'MSAG 210', 6, 'Advanced Soil Fertility and Fertility Evaluation', 3, 'offered'),
(17, 'MSAG 203', 6, 'Advanced Farming Systems', 3, 'offered'),
(18, 'MSAG 213', 6, 'Thesis Writing', 3, 'offered'),
(19, 'MSAS 209', 7, 'Advanced Farming Systems', 3, 'offered'),
(20, 'MSAS 208', 7, 'Livestock and Poultry Diseases Parasites', 3, 'offered'),
(21, 'MSAS 213', 7, 'Thesis Writing', 3, 'offered'),
(22, 'MSES 201', 8, 'Perspectives in Environmental Studies', 3, 'offered'),
(23, 'MSES 211', 8, 'Environmental Laws & Policies', 3, 'offered'),
(24, 'MSES 213', 8, 'Thesis Writing', 3, 'offered'),
(25, 'MSAF 203', 9, 'Agroforestry Theory, Practice and Adoption', 3, 'offered'),
(26, 'MSAF 206', 9, 'Silvopasture and Integrated Livestock System', 2, 'offered'),
(27, 'MSAF 213', 9, 'Thesis Writing', 3, 'offered'),
(28, 'MSAM 203', 10, 'Agribusiness Production and Operation Management', 3, 'offered'),
(29, 'MSAM 210', 10, 'Agricultural Business Risk and Investment', 3, 'offered'),
(30, 'MSAM 213', 10, 'Thesis Writing', 3, 'offered'),
(31, 'MSRD 209', 11, 'Rural Community Institution Building', 3, 'offered'),
(32, 'MSRD 208', 11, 'Rural Community Development and the Local Government', 3, 'offered'),
(33, 'MSRD 213', 11, 'Thesis Writing', 3, 'offered'),
(34, 'CCIS 204', 12, 'Information Security', 3, 'offered'),
(35, 'MCIS 217', 12, 'Corporate Information Systems Plan', 3, 'offered'),
(36, 'TWIS 220', 12, 'Thesis Writing', 3, 'offered'),
(37, 'Seri 300', 13, 'Thesis Writing', 3, 'offered'),
(38, 'MAEM 200', 4, 'Graduate Seminar', 3, 'not offered'),
(44, 'MAEM 201', 4, 'Perspectives in Education', 3, 'not offered'),
(56, 'MAEM 204', 4, 'Human Resource Management', 3, 'not offered'),
(57, 'MAEM 205', 4, 'Educational Planning', 3, 'not offered'),
(58, 'MAEM 206', 4, 'School Finance and Budgeting', 3, 'not offered'),
(59, 'MAEM 207', 4, 'Organization and Management of Educational Institutions', 3, 'not offered'),
(60, 'MAEM 208', 4, 'Communication in Educational Management', 3, 'not offered'),
(61, 'MAEM 209', 4, 'Development and Governance', 3, 'not offered'),
(62, 'MAEM 210', 4, 'Organizational Behavior', 3, 'not offered'),
(63, 'MAEM 211', 4, 'Trends in Human Public Relation Setting', 3, 'not offered'),
(64, 'MAEM 212', 4, 'Theory of Interest', 3, 'not offered'),
(101, 'MAEM 214', 4, 'Thesis Writing 2', 3, 'not offered'),
(131, 'MATL 200', 5, 'Graduate Seminar', 3, 'not offered'),
(132, 'MATL 201', 5, 'Perspectives in Education', 3, 'not offered'),
(133, 'MATL 202', 5, 'Methods of Research', 3, 'not offered'),
(134, 'MATL 203', 5, 'Livelihood Project Feasibility in TLE', 3, 'not offered'),
(135, 'MATL 205', 5, 'Home Economics I (Family Life Education Programs)', 3, 'not offered'),
(136, 'MATL 207', 5, 'Agri-fishery Arts I (Farming Systems and Production Management)', 3, 'not offered'),
(137, 'MATL 208', 5, 'Agri-fishery Arts II (Principles, Methods, and Trends in Aquaculture)', 3, 'not offered'),
(138, 'MATL 209', 5, 'ICT I (Advanced Multimedia Applications)', 3, 'not offered'),
(139, 'MATL 210', 5, 'ICT II (Advanced Web Application Development)', 3, 'not offered'),
(140, 'MATL 211', 5, 'Industrial Arts I (Industry standards and regulations)', 3, 'not offered'),
(141, 'MATL 212', 5, 'Industrial Arts II (Skills Development Education)', 3, 'not offered'),
(142, 'MATL 214', 5, 'Thesis Writing 2', 3, 'not offered'),
(146, 'MSAF 200', 9, 'Graduate Seminar', 3, 'not offered'),
(147, 'MSAF 201', 9, 'Perspectives in Agroforestry', 3, 'not offered'),
(148, 'MSAF 202', 9, 'Methods of Research', 3, 'not offered'),
(149, 'MSAF 204', 9, 'Ecological Basis of Agroforestry', 3, 'not offered'),
(150, 'MSAF 205', 9, 'Project Development and Management in Agroforestry', 3, 'not offered'),
(151, 'MSAF 207', 9, 'Agroforestry Enterprise Development', 3, 'not offered'),
(152, 'MSAF 208', 9, 'Soil Productivity in Agroforestry', 3, 'not offered'),
(153, 'MSAF 209', 9, 'Agroforestry Systems Design and Management', 3, 'not offered'),
(154, 'MSAF 210', 9, 'Social Forestry and Governance', 3, 'not offered'),
(155, 'MSAF 211', 9, 'Tree Biology and Silviculture', 3, 'not offered'),
(156, 'MSAF 212', 9, 'Agroforestry Policy and Planning', 3, 'not offered'),
(157, 'MSAF 214', 9, 'Thesis Writing 2', 3, 'not offered'),
(161, 'MSAG 200', 6, 'Graduate Seminar', 3, 'not offered'),
(162, 'MSAG 201', 6, 'Perspectives in Agronomy', 3, 'not offered'),
(163, 'MSAG 202', 6, 'Methods of Research', 3, 'not offered'),
(164, 'MSAG 204', 6, 'Advanced Field Crop Physiology and Ecology', 3, 'not offered'),
(165, 'MSAG 205', 6, 'Advanced Plant Breeding', 3, 'not offered'),
(166, 'MSAG 206', 6, 'Sustainable Agriculture', 3, 'not offered'),
(167, 'MSAG 207', 6, 'Advanced Cereal Production', 3, 'not offered'),
(168, 'MSAG 208', 6, 'Advanced Field Legumes, Root Crops and Forage Crops', 3, 'not offered'),
(169, 'MSAG 209', 6, 'Crop Pest Management', 3, 'not offered'),
(170, 'MSAG 211', 6, 'Post Harvest Field Crop Physiology and Technology', 3, 'not offered'),
(171, 'MSAG 212', 6, 'Advanced Field Crop Processing, Storage and Marketing', 3, 'not offered'),
(172, 'MSAG 214', 6, 'Thesis Writing 2', 3, 'not offered'),
(176, 'MSAM 200', 10, 'Graduate Seminar', 3, 'not offered'),
(177, 'MSAM 201', 10, 'Perspectives in Agribusiness Management', 3, 'not offered'),
(178, 'MSAM 202', 10, 'Methods of Research', 3, 'not offered'),
(179, 'MSAM 204', 10, 'Financial Management Accounting and Control', 3, 'not offered'),
(180, 'MSAM 205', 10, 'Agribusiness Cooperative & Entrepreneurship Development', 3, 'not offered'),
(181, 'MSAM 206', 10, 'Personnel Management & Industrial Relations', 3, 'not offered'),
(182, 'MSAM 207', 10, 'Advanced Marketing Management', 3, 'not offered'),
(183, 'MSAM 208', 10, 'Technology Commercialization & Technopreneurship', 3, 'not offered'),
(184, 'MSAM 209', 10, 'Innovative and Integrative Arrangements in Managing Agribusiness Enterprises', 3, 'not offered'),
(185, 'MSAM 211', 10, 'Sustainable Agri-Farming Systems', 3, 'not offered'),
(186, 'MSAM 212', 10, 'Strategic Management in Agribusiness', 3, 'not offered'),
(187, 'MSAM 214', 10, 'Thesis Writing 2', 3, 'not offered'),
(191, 'MSES 200', 8, 'Graduate Seminar', 3, 'not offered'),
(192, 'MSES 202', 8, 'Methods of Research', 3, 'not offered'),
(193, 'MSES 203', 8, 'Coastal Resources Management', 3, 'not offered'),
(194, 'MSES 204', 8, 'Forest Resources Management', 3, 'not offered'),
(195, 'MSES 205', 8, 'Sustainable Environmental and Development', 3, 'not offered'),
(196, 'MSES 206', 8, 'Culture and the Environment', 3, 'not offered'),
(197, 'MSES 207', 8, 'Settlement Systems and Land Use', 3, 'not offered'),
(198, 'MSES 208', 8, 'Environmental Impact Assessment', 3, 'not offered'),
(199, 'MSES 209', 8, 'Aquatic Ecosystem', 3, 'not offered'),
(200, 'MSES 210', 8, 'Terrestrial Ecosystem', 3, 'not offered'),
(201, 'MSES 212', 8, 'Environmental Management', 3, 'not offered'),
(202, 'MSES 214', 8, 'Thesis Writing 2', 3, 'not offered'),
(206, 'MSRD 200', 11, 'Graduate Seminar', 3, 'not offered'),
(207, 'MSRD 201', 11, 'Perspectives in Rural Community Development', 3, 'not offered'),
(208, 'MSRD 202', 11, 'Methods of Research', 3, 'not offered'),
(209, 'MSRD 203', 11, 'Rural Sociology', 3, 'not offered'),
(210, 'MSRD 204', 11, 'Socio-Cultural Innovations', 3, 'not offered'),
(211, 'MSRD 205', 11, 'Philippine Rural Community Structure and Change', 3, 'not offered'),
(212, 'MSRD 206', 11, 'Program Planning and Management of Rural Development', 3, 'not offered'),
(213, 'MSRD 207', 11, 'Evaluation of Rural Community Development', 3, 'not offered'),
(214, 'MSRD 210', 11, 'Sustainable Agriculture and Development', 3, 'not offered'),
(215, 'MSRD 211', 11, 'Community and Natural Resources Management', 3, 'not offered'),
(216, 'MSRD 212', 11, 'Community and Economic Development', 3, 'not offered'),
(217, 'MSRD 214', 11, 'Thesis Writing 2', 3, 'not offered'),
(236, 'CCIS 201', 12, 'Digital Transformation of Organizations', 3, 'not offered'),
(237, 'CCIS 202', 12, 'Agile Project Management and Risk Management', 3, 'not offered'),
(238, 'CCIS 203', 12, 'Legal Issues in Information Systems', 3, 'not offered'),
(239, 'CCIS 205', 12, 'Knowledge Management', 3, 'not offered'),
(240, 'MCIS 210', 12, 'Data Science and Analytics', 3, 'not offered'),
(241, 'MCIS 211', 12, 'Enterprise Resource Planning (ERP) – Business Processes', 3, 'not offered'),
(242, 'MCIS 212', 12, 'Enterprise Resource Planning (ERP) – Customization and configuration', 3, 'not offered'),
(243, 'MCIS 213', 12, 'Performance Management and Business Intelligence', 3, 'not offered'),
(244, 'MCIS 214', 12, 'Decision Support and Predictive Analytics', 3, 'not offered'),
(245, 'MCIS 215', 12, 'Corporate Information Systems Plan', 3, 'not offered'),
(246, 'MCIS 216', 12, 'Emerging Technologies and Issues', 3, 'not offered'),
(247, 'MCIS 218', 12, 'Information Systems Architecture', 3, 'not offered'),
(248, 'MCIS 219', 12, 'Industry Immersion', 3, 'not offered'),
(249, 'ISBA 102', 12, 'Fundamentals of Enterprise Data Management', 3, 'not offered'),
(250, 'ISPC 104', 12, 'IT Infrastructure and Network Technologies', 3, 'not offered'),
(251, 'ISBA 101', 12, 'Fundamentals of Business Analytics', 3, 'not offered'),
(252, 'ISPC 107', 12, 'IS Project Management', 3, 'not offered'),
(253, 'ISPC 112', 12, 'IS Strategy Management & Acquisition', 3, 'not offered'),
(254, 'ISPC 108', 12, 'Enterprise Systems & Architecture', 3, 'not offered'),
(255, 'ISPC 109', 12, 'Evaluation of Business Process', 3, 'not offered'),
(259, 'PHAG 300', 2, 'Graduate Seminar', 3, 'not offered'),
(260, 'PHAG 301', 2, 'Philosophical and Critical Perspectives in Agronomy', 3, 'not offered'),
(261, 'PHAG 302', 2, 'Research Designs and Methodologies', 3, 'not offered'),
(262, 'PHAG 303', 2, 'Knowledge Management in Agronomy', 3, 'not offered'),
(263, 'PHAG 304', 2, 'Applied Plant Breeding and Population Genetics', 3, 'not offered'),
(264, 'PHAG 305', 2, 'Seed Science and Technology', 3, 'not offered'),
(265, 'PHAG 306', 2, 'Physiology of Herbicides and its Interaction to Soil', 3, 'not offered'),
(266, 'PHAG 307', 2, 'Advanced Agronomic Crop Management', 3, 'not offered'),
(267, 'PHAG 308', 2, 'Advanced Crop Pest Management', 3, 'not offered'),
(268, 'PHAG 310', 2, 'Environmental Physiology', 3, 'not offered'),
(269, 'PHAG 311', 2, 'Advanced Plant Growth and Development', 3, 'not offered'),
(270, 'PHAG 312', 2, 'Sustainable Development', 3, 'not offered'),
(271, 'PHAG 315', 2, 'Dissertation Writing 2', 6, 'not offered'),
(275, 'PHAS 300', 3, 'Graduate Seminar', 3, 'not offered'),
(276, 'PHAS 301', 3, 'Philosophical and Critical Perspectives in Animal Science', 3, 'not offered'),
(277, 'PHAS 302', 3, 'Research Designs and Methodologies', 3, 'not offered'),
(278, 'PHAS 303', 3, 'Knowledge Management in Animal Science', 3, 'not offered'),
(279, 'PHAS 304', 3, 'Advanced Ruminant Production', 3, 'not offered'),
(280, 'PHAS 305', 3, 'Advanced Poultry Production', 3, 'not offered'),
(281, 'PHAS 306', 3, 'Advanced Swine Production', 3, 'not offered'),
(282, 'PHAS 307', 3, 'Advanced Forage Production and Pasture Management', 3, 'not offered'),
(283, 'PHAS 308', 3, 'Exotic and Wild Animal', 3, 'not offered'),
(284, 'PHAS 311', 3, 'Environmental Animal Health Management', 3, 'not offered'),
(285, 'PHAS 312', 3, 'Livestock Endocrinology', 3, 'not offered'),
(286, 'PHAS 313', 3, 'Advanced Farming Systems', 3, 'not offered'),
(287, 'PHAS 315', 3, 'Dissertation Writing 2', 6, 'not offered'),
(291, 'PHEA 300', 1, 'Graduate Seminar', 3, 'not offered'),
(292, 'PHEA 302', 1, 'Research Designs and Methodology', 3, 'not offered'),
(293, 'PHEA 303', 1, 'Knowledge Management in Educational Administration', 3, 'not offered'),
(294, 'PHEA 304', 1, 'Theories & Practices in Administration & Supervision', 3, 'not offered'),
(295, 'PHEA 305', 1, 'Qualitative Research Methods in Educational Administration and Organization Development', 3, 'not offered'),
(296, 'PHEA 306', 1, 'Educational Leadership', 3, 'not offered'),
(297, 'PHEA 307', 1, 'Legal Issues and Administrative Policies in Education', 3, 'not offered'),
(298, 'PHEA 308', 1, 'Systems Analysis in Education', 3, 'not offered'),
(299, 'PHEA 309', 1, 'Economics of Education: Fiscal Administration', 3, 'not offered'),
(300, 'PHEA 310', 1, 'Trends and Issues in Educational Planning', 3, 'not offered'),
(301, 'PHEA 312', 1, 'Quantitative Research Methods in Educational Administration and Organization Development', 3, 'not offered'),
(302, 'PHEA 313', 1, 'Methodology and Supervision of Higher Education', 3, 'not offered'),
(303, 'PHEA 315', 1, 'Environmental Planning and Management for Sustainable Development', 3, 'not offered'),
(304, 'PHEA 316', 1, 'Dissertation Writing 1', 6, 'not offered'),
(305, 'PHEA 317', 1, 'Dissertation Writing 2', 6, 'not offered');

-- --------------------------------------------------------

--
-- Table structure for table `course_faculty`
--

CREATE TABLE `course_faculty` (
  `course_id` int(11) NOT NULL,
  `faculty_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `course_faculty`
--

INSERT INTO `course_faculty` (`course_id`, `faculty_id`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 3),
(7, 4),
(8, 6),
(9, 3),
(10, 7),
(11, 8),
(12, 3),
(13, 9),
(14, 1),
(14, 9),
(15, 3),
(16, 10),
(17, 5),
(18, 3),
(19, 6),
(20, 6),
(21, 3),
(22, 11),
(23, 12),
(24, 3),
(25, 13),
(26, 14),
(27, 3),
(28, 15),
(29, 16),
(30, 3),
(31, 17),
(32, 17),
(33, 3),
(34, 18),
(35, 19),
(36, 3),
(37, 3);

-- --------------------------------------------------------

--
-- Table structure for table `enrollments`
--

CREATE TABLE `enrollments` (
  `enrollment_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `term` varchar(10) NOT NULL,
  `academic_year` varchar(10) NOT NULL,
  `student_category` varchar(4) NOT NULL,
  `status` enum('pending','enrolled','rejected') DEFAULT 'pending',
  `id_number` varchar(50) DEFAULT NULL,
  `date_applied` timestamp NOT NULL DEFAULT current_timestamp(),
  `full_name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `program` varchar(100) DEFAULT NULL,
  `student_name` varchar(255) DEFAULT NULL,
  `student_email` varchar(255) DEFAULT NULL,
  `student_id_number` varchar(50) DEFAULT NULL,
  `program_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `enrollments`
--

INSERT INTO `enrollments` (`enrollment_id`, `student_id`, `course_id`, `term`, `academic_year`, `student_category`, `status`, `id_number`, `date_applied`, `full_name`, `email`, `address`, `program`, `student_name`, `student_email`, `student_id_number`, `program_id`) VALUES
(334, 15, 31, '1st Sem', '2025-2026', 'Old', 'pending', NULL, '2025-07-04 12:06:45', NULL, NULL, 'Pagdalagan, San Fernando City, La Union', NULL, 'Mark Morillo Quinitip', 'mark@gmail.com', '211-1003-6', 11),
(335, 15, 32, '1st Sem', '2025-2026', 'Old', 'pending', NULL, '2025-07-04 12:06:45', NULL, NULL, 'Pagdalagan, San Fernando City, La Union', NULL, 'Mark Morillo Quinitip', 'mark@gmail.com', '211-1003-6', 11),
(336, 15, 33, '1st Sem', '2025-2026', 'Old', 'pending', NULL, '2025-07-04 12:06:45', NULL, NULL, 'Pagdalagan, San Fernando City, La Union', NULL, 'Mark Morillo Quinitip', 'mark@gmail.com', '211-1003-6', 11),
(337, 14, 13, '1st Sem', '2025-2026', 'New', 'enrolled', NULL, '2025-07-04 13:34:47', NULL, NULL, 'Sevilla, San Fernando City, La Union', NULL, 'Bianca Mairah', 'bianca@gmail.com', '211-1003-5', 5),
(338, 14, 14, '1st Sem', '2025-2026', 'New', 'enrolled', NULL, '2025-07-04 13:34:47', NULL, NULL, 'Sevilla, San Fernando City, La Union', NULL, 'Bianca Mairah', 'bianca@gmail.com', '211-1003-5', 5),
(339, 14, 15, '1st Sem', '2025-2026', 'New', 'enrolled', NULL, '2025-07-04 13:34:47', NULL, NULL, 'Sevilla, San Fernando City, La Union', NULL, 'Bianca Mairah', 'bianca@gmail.com', '211-1003-5', 5);

-- --------------------------------------------------------

--
-- Table structure for table `enrollment_fees`
--

CREATE TABLE `enrollment_fees` (
  `id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `total_units` int(11) NOT NULL,
  `tuition_fee` decimal(10,2) NOT NULL,
  `misc_fee` decimal(10,2) NOT NULL,
  `total_fee` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `enrollment_fees`
--

INSERT INTO `enrollment_fees` (`id`, `student_id`, `total_units`, `tuition_fee`, `misc_fee`, `total_fee`, `created_at`) VALUES
(3, 15, 9, 3600.00, 3175.00, 6775.00, '2025-07-04 12:06:45'),
(4, 14, 9, 3600.00, 3375.00, 6975.00, '2025-07-04 13:34:47');

-- --------------------------------------------------------

--
-- Table structure for table `faculty`
--

CREATE TABLE `faculty` (
  `faculty_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `faculty`
--

INSERT INTO `faculty` (`faculty_id`, `name`, `user_id`) VALUES
(1, 'GSNisperos', NULL),
(2, 'JRETabafunda', NULL),
(3, 'TBA', NULL),
(4, 'PPFontanilla', NULL),
(5, 'AVSagun', 17),
(6, 'FMCamalig', NULL),
(7, 'MBMendoza', NULL),
(8, 'DPLicay', NULL),
(9, 'NBTugelida', 18),
(10, 'VMLibunao', NULL),
(11, 'JJCAndrada', NULL),
(12, 'DAVilar', NULL),
(13, 'LDGavina', NULL),
(14, 'JCortado', NULL),
(15, 'AGLaquidan', 16),
(16, 'JNQuinquito', NULL),
(17, 'GTBondot', NULL),
(18, 'DANeri', NULL),
(19, 'ECEbuenga', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `grades`
--

CREATE TABLE `grades` (
  `grade_id` int(11) NOT NULL,
  `enrollment_id` int(11) NOT NULL,
  `grade` varchar(10) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `grades`
--

INSERT INTO `grades` (`grade_id`, `enrollment_id`, `grade`, `created_at`, `updated_at`) VALUES
(1, 337, '89', '2025-08-08 06:04:35', '2025-08-08 06:04:35'),
(2, 338, '92', '2025-08-08 06:05:42', '2025-08-08 06:05:42');

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

CREATE TABLE `logs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(255) NOT NULL,
  `details` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `logs`
--

INSERT INTO `logs` (`id`, `user_id`, `action`, `details`, `created_at`) VALUES
(1, NULL, 'Backup', 'Database backup downloaded', '2025-08-10 14:31:08');

-- --------------------------------------------------------

--
-- Table structure for table `programs`
--

CREATE TABLE `programs` (
  `program_id` int(11) NOT NULL,
  `program_name` varchar(255) NOT NULL,
  `program_level` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `programs`
--

INSERT INTO `programs` (`program_id`, `program_name`, `program_level`) VALUES
(1, 'Doctor of Philosophy in Educational Administration', NULL),
(2, 'Doctor of Philosophy in Agronomy', NULL),
(3, 'Doctor of Philosophy in Animal Science', NULL),
(4, 'Master of Arts in Educational Management', NULL),
(5, 'Master of Science in Education (TLE)', NULL),
(6, 'Master of Science in Agronomy', NULL),
(7, 'Master of Science in Animal Science', NULL),
(8, 'Master of Science in Environmental Studies', NULL),
(9, 'Master of Science in Agroforestry', NULL),
(10, 'Master of Science in Agribusiness Management', NULL),
(11, 'Master of Science in Rural Community Development', NULL),
(12, 'Master of Science in Information Systems', NULL),
(13, 'Master of Science in Sericulture', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `schedules`
--

CREATE TABLE `schedules` (
  `schedule_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `day_time` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `schedules`
--

INSERT INTO `schedules` (`schedule_id`, `course_id`, `day_time`) VALUES
(1, 1, '8-12S'),
(2, 1, '5:30-8:30W'),
(3, 1, '5:30-7:30F'),
(4, 2, '1-5S'),
(5, 2, '5:30-8:30T'),
(6, 2, '5:30-7:30Th'),
(7, 3, 'TBA'),
(8, 4, '8-12S'),
(9, 4, '5:30-8:30W'),
(10, 4, '5:30-7:30F'),
(11, 5, '1-5S'),
(12, 5, '5:30-8:30T'),
(13, 5, '5:30-7:30Th'),
(14, 6, 'TBA'),
(15, 7, '8-12S'),
(16, 7, '5:30-8:30W'),
(17, 7, '5:30-7:30F'),
(18, 8, '1-5S'),
(19, 8, '5:30-8:30T'),
(20, 8, '5:30-7:30Th'),
(21, 9, 'TBA'),
(22, 10, '8-12S'),
(23, 10, '5:30-8:30W'),
(24, 10, '5:30-7:30F'),
(25, 11, '1-5S'),
(26, 11, '5:30-8:30T'),
(27, 11, '5:30-7:30Th'),
(28, 12, 'TBA'),
(29, 13, '8-12S'),
(30, 13, '5:30-8:30W'),
(31, 13, '5:30-7:30F'),
(32, 14, '1-5S'),
(33, 14, '5:30-8:30T'),
(34, 14, '5:30-7:30Th'),
(35, 15, 'TBA'),
(36, 16, '8-12S'),
(37, 16, '5:30-8:30W'),
(38, 16, '5:30-7:30F'),
(39, 17, '1-5S'),
(40, 17, '5:30-8:30T'),
(41, 17, '5:30-7:30Th'),
(42, 18, 'TBA'),
(43, 19, '1-6S'),
(44, 19, '5:30-8:30T'),
(45, 20, '8-12S'),
(46, 20, '5:30-8:30W'),
(47, 20, '5:30-7:30F'),
(48, 21, 'TBA'),
(49, 22, '8-12S'),
(50, 22, '5:30-8:30W'),
(51, 22, '5:30-7:30F'),
(52, 23, '1-5S'),
(53, 23, '5:30-8:30T'),
(54, 23, '5:30-7:30Th'),
(55, 24, 'TBA'),
(56, 25, '8-12S'),
(57, 25, '5:30-8:30W'),
(58, 25, '5:30-7:30F'),
(59, 26, '1-5S'),
(60, 26, '5:30-8:30T'),
(61, 26, '5:30-7:30Th'),
(62, 27, 'TBA'),
(63, 28, '8-12S'),
(64, 28, '5:30-8:30W'),
(65, 28, '5:30-7:30F'),
(66, 29, '1-5S'),
(67, 29, '5:30-8:30T'),
(68, 29, '5:30-7:30Th'),
(69, 30, 'TBA'),
(70, 31, '8-12S'),
(71, 31, '5:30-8:30W'),
(72, 31, '5:30-7:30F'),
(73, 32, '1-5S'),
(74, 32, '5:30-8:30T'),
(75, 32, '5:30-7:30Th'),
(76, 33, 'TBA'),
(77, 34, '1-5S'),
(78, 34, '5:30-8:30T'),
(79, 34, '5:30-7:30Th'),
(80, 35, '8-12S'),
(81, 35, '5:30-8:30W'),
(82, 35, '5:30-7:30F'),
(83, 36, 'TBA'),
(84, 37, 'TBA');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `user_level` enum('admin','student','teacher') NOT NULL DEFAULT 'student',
  `program_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `full_name`, `created_at`, `user_level`, `program_id`) VALUES
(4, 'tolentino@gmail.com', '$2b$10$C8T1WMh7VEYNcmz2UEn1yOJQhwfy7vnHXlLCdWBHO10iVLIm8AY4y', '', '2025-06-24 13:29:30', 'student', NULL),
(6, 'admin2@cgs.edu', '$2b$10$RhVLs/JwrUyGaC/7ZvftD.hggvXtffTUsu4pQrbk8qfnGxhpO3hgy', '', '2025-06-25 16:26:09', 'admin', NULL),
(7, 'msis.student@cgs.edu', 'password123', '', '2025-06-28 07:04:15', 'student', NULL),
(11, 'tolen@gmail.com', '$2b$10$4kXdclLy1gYvdnslIhhDgelL2lUxdZc8HLU6ObqBlip0IaTvno.Jy', '', '2025-06-30 07:51:34', 'student', NULL),
(12, 'tolentinochristian89@gmail.com', '$2b$10$mNfLLKuEPmBqx7cIr62PoOOGnQuEICPqS0Gsunlq6jqO/rzO6WStO', '', '2025-06-30 10:03:56', 'student', NULL),
(13, 'prence@gmail.com', '$2b$10$FNO0JFizImtzMS8jL2VuCexsgbRM1/JFpUiuexhXw.gjA2YvEurOG', '', '2025-06-30 14:57:16', 'student', NULL),
(14, 'bianca@gmail.com', '$2b$10$gMdc7QlJw8mGsxXwKIrSR.ZtbXQjU2qwzH6hxGOIQljWQfkvRDr/u', 'Bianca Mairah', '2025-06-30 15:30:10', 'student', NULL),
(15, 'mark@gmail.com', '$2b$10$12haxuMG42A0O8JBMnhSBeoHVyy3cyGhNzVM4oyRD/lqj706QERG6', 'Mark Morillo Quinitip', '2025-07-04 12:05:54', 'student', NULL),
(16, 'aglaquidan@gmail.com', '$2b$10$M85TFcZONVbqzUYBTX5lI.cUiut7xKjSZqnf2ccruM.rHxQ4iXNRm', 'AGLaquidan', '2025-08-07 15:06:08', 'teacher', NULL),
(17, 'avsagun@gmail.com', '$2b$10$CuDg/lSKzW0WVWVdoPVE.Oe0BC0h5J8cz3jrtot98FGa5DxfBMYEa', 'AVSagun', '2025-08-08 05:32:57', 'teacher', NULL),
(18, 'nbtugelida@gmail.com', '$2b$10$DDob9R2x8ChvbMZt4MY7yethQmwvegTWmXXDvFZqdfl8FPmsmu8fK', 'NBTugelida', '2025-08-08 05:55:28', 'teacher', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `announcements`
--
ALTER TABLE `announcements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `chatbot_responses`
--
ALTER TABLE `chatbot_responses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`course_id`),
  ADD UNIQUE KEY `course_code` (`course_code`),
  ADD KEY `program_id` (`program_id`);

--
-- Indexes for table `course_faculty`
--
ALTER TABLE `course_faculty`
  ADD PRIMARY KEY (`course_id`,`faculty_id`),
  ADD KEY `faculty_id` (`faculty_id`);

--
-- Indexes for table `enrollments`
--
ALTER TABLE `enrollments`
  ADD PRIMARY KEY (`enrollment_id`),
  ADD KEY `course_id` (`course_id`),
  ADD KEY `fk_enrollments_student` (`student_id`);

--
-- Indexes for table `enrollment_fees`
--
ALTER TABLE `enrollment_fees`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `faculty`
--
ALTER TABLE `faculty`
  ADD PRIMARY KEY (`faculty_id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `fk_faculty_user` (`user_id`);

--
-- Indexes for table `grades`
--
ALTER TABLE `grades`
  ADD PRIMARY KEY (`grade_id`),
  ADD KEY `enrollment_id` (`enrollment_id`);

--
-- Indexes for table `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `programs`
--
ALTER TABLE `programs`
  ADD PRIMARY KEY (`program_id`),
  ADD UNIQUE KEY `program_name` (`program_name`);

--
-- Indexes for table `schedules`
--
ALTER TABLE `schedules`
  ADD PRIMARY KEY (`schedule_id`),
  ADD KEY `course_id` (`course_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_user_level` (`user_level`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `announcements`
--
ALTER TABLE `announcements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `chatbot_responses`
--
ALTER TABLE `chatbot_responses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `course_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=306;

--
-- AUTO_INCREMENT for table `enrollments`
--
ALTER TABLE `enrollments`
  MODIFY `enrollment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=340;

--
-- AUTO_INCREMENT for table `enrollment_fees`
--
ALTER TABLE `enrollment_fees`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `faculty`
--
ALTER TABLE `faculty`
  MODIFY `faculty_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `grades`
--
ALTER TABLE `grades`
  MODIFY `grade_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `logs`
--
ALTER TABLE `logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `programs`
--
ALTER TABLE `programs`
  MODIFY `program_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `schedules`
--
ALTER TABLE `schedules`
  MODIFY `schedule_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=85;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `announcements`
--
ALTER TABLE `announcements`
  ADD CONSTRAINT `announcements_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `courses`
--
ALTER TABLE `courses`
  ADD CONSTRAINT `courses_ibfk_1` FOREIGN KEY (`program_id`) REFERENCES `programs` (`program_id`);

--
-- Constraints for table `course_faculty`
--
ALTER TABLE `course_faculty`
  ADD CONSTRAINT `course_faculty_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`),
  ADD CONSTRAINT `course_faculty_ibfk_2` FOREIGN KEY (`faculty_id`) REFERENCES `faculty` (`faculty_id`);

--
-- Constraints for table `enrollments`
--
ALTER TABLE `enrollments`
  ADD CONSTRAINT `enrollments_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_enrollments_student` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `enrollment_fees`
--
ALTER TABLE `enrollment_fees`
  ADD CONSTRAINT `enrollment_fees_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `faculty`
--
ALTER TABLE `faculty`
  ADD CONSTRAINT `fk_faculty_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `grades`
--
ALTER TABLE `grades`
  ADD CONSTRAINT `grades_ibfk_1` FOREIGN KEY (`enrollment_id`) REFERENCES `enrollments` (`enrollment_id`) ON DELETE CASCADE;

--
-- Constraints for table `logs`
--
ALTER TABLE `logs`
  ADD CONSTRAINT `logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `schedules`
--
ALTER TABLE `schedules`
  ADD CONSTRAINT `schedules_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
