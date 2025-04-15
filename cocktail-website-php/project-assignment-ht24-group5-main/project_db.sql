-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Lis 06, 2024 at 10:23 AM
-- Wersja serwera: 10.4.32-MariaDB
-- Wersja PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `project_db`
--

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `comments`
--

CREATE TABLE `comments` (
  `idComment` int(20) NOT NULL,
  `idDrink` int(20) NOT NULL,
  `idUser` int(20) NOT NULL,
  `Content` varchar(1000) NOT NULL,
  `Date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `drinks`
--

CREATE TABLE `drinks` (
  `idDrink` int(20) NOT NULL,
  `strDrink` varchar(50) NOT NULL,
  `strInstructions` varchar(1000) NOT NULL,
  `strDrinkThumb` varchar(200) NOT NULL,
  `strCategory` varchar(50) NOT NULL,
  `Posted` datetime(6) NOT NULL,
  `idUser` int(7) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `drinks`
--

INSERT INTO `drinks` (`idDrink`, `strDrink`, `strInstructions`, `strDrinkThumb`, `strCategory`, `Posted`, `idUser`) VALUES
(1000000, 'Beer_Example', 'Take the ingredients and do this to get beer.', 'cocktailPictures/beer_example.png', 'Soft Drink', '2024-10-20 17:00:58.000000', 2),
(1000001, 'Shrek cocktail', 'Boil the water. Add matcha powder and stir until the matcha melts.', 'cocktailPictures/How-to-Make-Matcha-013s_1.png', 'Cocktail', '2024-11-03 17:40:40.380607', 8),
(1000002, 'Lemonades with various flavors', 'NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN', 'cocktailPictures/Cocktails-right-ff2a4b8-e1651960915224.jpg', 'Soft Drink', '2024-11-03 17:56:09.392374', 8),
(1000003, 'Mojito', 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', 'cocktailPictures/cocktails-ueberblick-mojito.jpg', 'Punch / Party Drink', '2024-11-03 18:02:00.862591', 8),
(1000004, 'Color changing cocktail', 'kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk', 'cocktailPictures/Magical-Color-Changing-Cocktails-The-Flavor-Bender-Featured-Image-SQ-5.jpg', 'Cocktail', '2024-11-03 18:03:19.952827', 8),
(1000005, 'Berry cocktails', 'zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz', 'cocktailPictures/Berry-Vodka-Cocktails-FI-1200.jpg', 'Cocktail', '2024-11-03 18:04:50.706202', 8);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `favoritedcocktails`
--

CREATE TABLE `favoritedcocktails` (
  `idDrink` int(20) NOT NULL,
  `idUser` int(20) NOT NULL,
  `Date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `favoritedcocktails`
--

INSERT INTO `favoritedcocktails` (`idDrink`, `idUser`, `Date`) VALUES
(11007, 2, '2024-10-20 17:10:06.000000'),
(1000000, 2, '2024-10-20 17:10:06.000000'),
(1000001, 8, '2024-11-03 18:11:29.000000'),
(1000004, 8, '2024-11-03 18:11:40.000000');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `favoritedingredients`
--

CREATE TABLE `favoritedingredients` (
  `idUser` int(7) NOT NULL,
  `idIngredient` int(7) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `favoritedingredients`
--

INSERT INTO `favoritedingredients` (`idUser`, `idIngredient`) VALUES
(8, 337),
(8, 486),
(8, 497),
(8, 513);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ingredients`
--

CREATE TABLE `ingredients` (
  `idIngredient` int(7) NOT NULL,
  `strIngredient` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ingredients`
--

INSERT INTO `ingredients` (`idIngredient`, `strIngredient`) VALUES
(1, 'Vodka'),
(2, 'Gin'),
(3, 'Rum'),
(4, 'Tequila'),
(5, 'Scotch'),
(6, 'Absolut Kurant'),
(7, 'Absolut Peppar'),
(8, 'Absolut Vodka'),
(9, 'Advocaat'),
(10, 'Aejo Rum'),
(11, 'Aftershock'),
(12, 'Agave Syrup'),
(13, 'Ale'),
(14, 'Allspice'),
(16, 'Almond Flavoring'),
(17, 'Almond'),
(18, 'Amaretto'),
(19, 'Angelica Root'),
(20, 'Angostura Bitters'),
(21, 'Anis'),
(22, 'Anise'),
(23, 'Anisette'),
(24, 'Aperol'),
(25, 'Apfelkorn'),
(26, 'Apple Brandy'),
(27, 'Apple Cider'),
(28, 'Apple Juice'),
(29, 'Apple Schnapps'),
(30, 'Apple'),
(31, 'Applejack'),
(32, 'Apricot Brandy'),
(33, 'Apricot Nectar'),
(34, 'Apricot'),
(35, 'Aquavit'),
(36, 'Asafoetida'),
(37, 'Añejo Rum'),
(39, 'Bacardi Limon'),
(40, 'Bacardi'),
(43, 'Baileys Irish Cream'),
(44, 'Banana Liqueur'),
(45, 'Banana Rum'),
(46, 'Banana Syrup'),
(47, 'Banana'),
(48, 'Barenjager'),
(49, 'Basil'),
(51, 'Beef Stock'),
(52, 'Beer'),
(53, 'Benedictine'),
(54, 'Berries'),
(55, 'Bitter lemon'),
(56, 'Bitters'),
(57, 'Black Pepper'),
(58, 'Black Rum'),
(59, 'Black Sambuca'),
(60, 'Blackberries'),
(61, 'Blackberry Brandy'),
(62, 'Blackberry Schnapps'),
(63, 'Blackcurrant Cordial'),
(64, 'Blackcurrant Schnapps'),
(65, 'Blackcurrant Squash'),
(66, 'Blended Whiskey'),
(67, 'Blue Curacao'),
(68, 'Blue Maui'),
(69, 'Blueberries'),
(70, 'Blueberry Schnapps'),
(71, 'Bourbon'),
(74, 'Brandy'),
(77, 'Brown Sugar'),
(79, 'Butter'),
(80, 'Butterscotch Schnapps'),
(81, 'Cachaca'),
(82, 'Calvados'),
(83, 'Campari'),
(84, 'Canadian Whisky'),
(85, 'Candy'),
(86, 'Cantaloupe'),
(87, 'Caramel Coloring'),
(88, 'Carbonated Soft Drink'),
(89, 'Carbonated Water'),
(90, 'Cardamom'),
(93, 'Cayenne Pepper'),
(94, 'Celery Salt'),
(95, 'Celery'),
(96, 'Chambord Raspberry Liqueur'),
(97, 'Champagne'),
(99, 'Cherries'),
(100, 'Cherry Brandy'),
(101, 'Cherry Cola'),
(102, 'Cherry Grenadine'),
(103, 'Cherry Heering'),
(104, 'Cherry Juice'),
(105, 'Cherry Liqueur'),
(106, 'Cherry'),
(112, 'Chocolate Ice-cream'),
(113, 'Chocolate Liqueur'),
(114, 'Chocolate Milk'),
(115, 'Chocolate Syrup'),
(116, 'Chocolate'),
(120, 'Cider'),
(121, 'Cinnamon Schnapps'),
(122, 'Cinnamon'),
(123, 'Citrus Vodka'),
(124, 'Clamato Juice'),
(126, 'Cloves'),
(127, 'Club Soda'),
(128, 'Coca-Cola'),
(130, 'Cocktail Onion'),
(131, 'Cocoa Powder'),
(132, 'Coconut Cream'),
(133, 'Coconut Liqueur'),
(134, 'Coconut Milk'),
(135, 'Coconut Rum'),
(136, 'Coconut Syrup'),
(137, 'Coffee Brandy'),
(138, 'Coffee Liqueur'),
(139, 'Coffee'),
(141, 'Cognac'),
(142, 'Cointreau'),
(143, 'Cola'),
(144, 'Cold Water'),
(145, 'Condensed Milk'),
(147, 'Coriander'),
(149, 'Corn Syrup'),
(151, 'Cornstarch'),
(152, 'Corona'),
(154, 'Cranberries'),
(155, 'Cranberry Juice'),
(156, 'Cranberry Liqueur'),
(157, 'Cranberry Vodka'),
(158, 'Cream of Coconut'),
(159, 'Cream Sherry'),
(160, 'Cream Soda'),
(161, 'Cream'),
(162, 'Creme De Almond'),
(163, 'Creme De Banane'),
(164, 'Creme De Cacao'),
(165, 'Creme De Cassis'),
(166, 'Creme De Noyaux'),
(167, 'Creme Fraiche'),
(168, 'Crown Royal'),
(169, 'Crystal Light'),
(171, 'Cucumber'),
(172, 'Cumin Powder'),
(173, 'Cumin Seed'),
(174, 'Curacao'),
(175, 'Cynar'),
(176, 'Daiquiri Mix'),
(177, 'Dark Chocolate'),
(178, 'Dark Creme De Cacao'),
(179, 'Dark Rum'),
(180, 'Dark Soy Sauce'),
(181, 'Demerara Sugar'),
(186, 'Dr. Pepper'),
(187, 'Drambuie'),
(188, 'Dried Oregano'),
(189, 'Dry Vermouth'),
(190, 'Dubonnet Blanc'),
(191, 'Dubonnet Rouge'),
(192, 'Egg White'),
(193, 'Egg Yolk'),
(194, 'Egg'),
(195, 'Eggnog'),
(199, 'Erin Cream'),
(200, 'Espresso'),
(201, 'Everclear'),
(203, 'Fanta'),
(205, 'Fennel Seeds'),
(207, 'Firewater'),
(208, 'Flaked Almonds'),
(210, 'Food Coloring'),
(211, 'Forbidden Fruit'),
(212, 'Frangelico'),
(215, 'Fresca'),
(216, 'Fresh Basil'),
(217, 'Fresh Lemon Juice'),
(220, 'Fruit Juice'),
(221, 'Fruit Punch'),
(222, 'Fruit'),
(223, 'Galliano'),
(224, 'Garlic Sauce'),
(226, 'Gatorade'),
(228, 'Ginger Ale'),
(229, 'Ginger Beer'),
(230, 'Ginger'),
(231, 'Glycerine'),
(232, 'Godiva Liqueur'),
(233, 'Gold rum'),
(234, 'Gold Tequila'),
(235, 'Goldschlager'),
(237, 'Grain Alcohol'),
(238, 'Grand Marnier'),
(239, 'Granulated Sugar'),
(240, 'Grape juice'),
(241, 'Grape soda'),
(242, 'Grapefruit Juice'),
(243, 'Grapes'),
(245, 'Green Chartreuse'),
(246, 'Green Creme de Menthe'),
(247, 'Green Ginger Wine'),
(248, 'Green Olives'),
(250, 'Grenadine'),
(252, 'Ground Ginger'),
(253, 'Guava juice'),
(254, 'Guinness stout'),
(255, 'Guinness'),
(256, 'Half-and-half'),
(257, 'Hawaiian punch'),
(258, 'Hazelnut liqueur'),
(259, 'Heavy cream'),
(260, 'Honey'),
(261, 'Hooch'),
(264, 'Hot Chocolate'),
(265, 'Hot Damn'),
(266, 'Hot Sauce'),
(268, 'Hpnotiq'),
(269, 'Ice-Cream'),
(270, 'Ice'),
(271, 'Iced tea'),
(272, 'Irish cream'),
(273, 'Irish Whiskey'),
(275, 'Jack Daniels'),
(276, 'Jello'),
(277, 'Jelly'),
(278, 'Jagermeister'),
(279, 'Jim Beam'),
(280, 'Johnnie Walker'),
(282, 'Kahlua'),
(283, 'Key Largo Schnapps'),
(284, 'Kirschwasser'),
(285, 'Kiwi liqueur'),
(286, 'Kiwi'),
(287, 'Kool-Aid'),
(288, 'Kummel'),
(289, 'Lager'),
(293, 'Lemon Juice'),
(294, 'Lemon Peel'),
(295, 'Lemon soda'),
(296, 'Lemon vodka'),
(297, 'Lemon-lime soda'),
(298, 'lemon-lime'),
(299, 'lemon'),
(300, 'Lemonade'),
(303, 'Licorice Root'),
(304, 'Light Cream'),
(305, 'Light Rum'),
(306, 'Lillet'),
(307, 'Lime juice cordial'),
(308, 'Lime Juice'),
(309, 'Lime liqueur'),
(310, 'Lime Peel'),
(311, 'Lime vodka'),
(312, 'Lime'),
(313, 'Limeade'),
(314, 'Madeira'),
(315, 'Malibu Rum'),
(317, 'Mandarin'),
(318, 'Mandarine napoleon'),
(319, 'Mango'),
(320, 'Maple syrup'),
(321, 'Maraschino cherry juice'),
(322, 'Maraschino Cherry'),
(323, 'Maraschino Liqueur'),
(324, 'Margarita mix'),
(325, 'Marjoram leaves'),
(326, 'Marshmallows'),
(327, 'Maui'),
(328, 'Melon Liqueur'),
(329, 'Melon Vodka'),
(330, 'Mezcal'),
(331, 'Midori Melon Liqueur'),
(332, 'Midori'),
(333, 'Milk'),
(336, 'Mint syrup'),
(337, 'Mint'),
(338, 'Mountain Dew'),
(344, 'Nutmeg'),
(346, 'Olive Oil'),
(347, 'Olive'),
(348, 'Onion'),
(350, 'Orange Bitters'),
(351, 'Orange Curacao'),
(352, 'Orange Juice'),
(353, 'Orange liqueur'),
(354, 'Orange Peel'),
(355, 'Orange rum'),
(356, 'Orange Soda'),
(357, 'Orange spiral'),
(358, 'Orange vodka'),
(359, 'Orange'),
(361, 'Oreo cookie'),
(362, 'Orgeat Syrup'),
(363, 'Ouzo'),
(364, 'Oyster Sauce'),
(365, 'Papaya juice'),
(366, 'Papaya'),
(367, 'Parfait amour'),
(372, 'Passion fruit juice'),
(373, 'Passion fruit syrup'),
(374, 'Passoa'),
(375, 'Peach brandy'),
(376, 'Peach juice'),
(377, 'Peach liqueur'),
(378, 'Peach Nectar'),
(379, 'Peach Schnapps'),
(380, 'Peach Vodka'),
(381, 'Peach'),
(382, 'Peachtree schnapps'),
(383, 'Peanut Oil'),
(386, 'Pepper'),
(387, 'Peppermint extract'),
(388, 'Peppermint Schnapps'),
(389, 'Pepsi Cola'),
(390, 'Pernod'),
(391, 'Peychaud bitters'),
(392, 'Pina colada mix'),
(393, 'Pineapple Juice'),
(394, 'Pineapple rum'),
(395, 'Pineapple vodka'),
(396, 'Pineapple-orange-banana juice'),
(397, 'Pineapple'),
(398, 'Pink lemonade'),
(399, 'Pisang Ambon'),
(400, 'Pisco'),
(402, 'Plain Chocolate'),
(403, 'Plain Flour'),
(405, 'Plums'),
(406, 'Port'),
(409, 'Powdered Sugar'),
(411, 'Purple passion'),
(412, 'Raisins'),
(413, 'Raspberry cordial'),
(414, 'Raspberry Jam'),
(415, 'Raspberry Juice'),
(416, 'Raspberry Liqueur'),
(417, 'Raspberry schnapps'),
(418, 'Raspberry syrup'),
(419, 'Raspberry Vodka'),
(421, 'Red Chile Flakes'),
(422, 'Red Chili Flakes'),
(423, 'Red Hot Chili Flakes'),
(425, 'Red Wine'),
(426, 'Rhubarb'),
(427, 'Ricard'),
(429, 'Rock Salt'),
(430, 'Root beer schnapps'),
(431, 'Root beer'),
(432, 'Roses sweetened lime juice'),
(433, 'Rosewater'),
(435, 'Rumple Minze'),
(436, 'Rye Whiskey'),
(437, 'Sake'),
(439, 'Salt'),
(440, 'Sambuca'),
(441, 'Sarsaparilla'),
(442, 'Schnapps'),
(443, 'Schweppes Lemon'),
(444, 'Schweppes Russchian'),
(448, 'Sherbet'),
(449, 'Sherry'),
(452, 'Sirup of roses'),
(453, 'Sloe Gin'),
(455, 'Soda Water'),
(456, 'Sour Apple Pucker'),
(457, 'Sour Mix'),
(458, 'Southern Comfort'),
(459, 'Soy Milk'),
(460, 'Soy Sauce'),
(461, 'Soya Milk'),
(462, 'Soya Sauce'),
(464, 'Spiced Rum'),
(466, 'Sprite'),
(467, 'Squeezed Orange'),
(468, 'Squirt'),
(470, 'Strawberries'),
(471, 'Strawberry juice'),
(472, 'Strawberry liqueur'),
(473, 'Strawberry Schnapps'),
(474, 'Strawberry syrup'),
(475, 'Sugar Syrup'),
(476, 'Sugar'),
(477, 'Sunny delight'),
(478, 'Surge'),
(479, 'Swedish punsch'),
(480, 'Sweet and Sour'),
(481, 'Sweet Cream'),
(482, 'Sweet Vermouth'),
(483, 'Tabasco Sauce'),
(484, 'Tang'),
(485, 'Tawny port'),
(486, 'Tea'),
(487, 'Tennessee whiskey'),
(488, 'Tequila rose'),
(490, 'Tia Maria'),
(492, 'Tomato Juice'),
(494, 'Tomato'),
(497, 'Tonic Water'),
(498, 'Triple Sec'),
(499, 'Tropicana'),
(500, 'Tuaca'),
(502, 'Vanilla extract'),
(503, 'Vanilla Ice-Cream'),
(504, 'Vanilla liqueur'),
(505, 'Vanilla schnapps'),
(506, 'Vanilla syrup'),
(507, 'Vanilla vodka'),
(508, 'Vanilla'),
(510, 'Vermouth'),
(511, 'Vinegar'),
(513, 'Water'),
(514, 'Watermelon schnapps'),
(515, 'Whipped Cream'),
(516, 'Whipping Cream'),
(519, 'White chocolate liqueur'),
(520, 'White Creme de Menthe'),
(521, 'White grape juice'),
(522, 'White port'),
(523, 'White Rum'),
(524, 'White Vinegar'),
(525, 'White Wine'),
(526, 'Wild Turkey'),
(527, 'Wildberry schnapps'),
(528, 'Wine'),
(529, 'Worcestershire Sauce'),
(530, 'Wormwood'),
(531, 'Yeast'),
(532, 'Yellow Chartreuse'),
(533, 'Yoghurt'),
(534, 'Yukon Jack'),
(535, 'Zima'),
(537, 'Caramel Sauce'),
(538, 'Chocolate Sauce'),
(539, 'Lillet Blanc'),
(540, 'Peach Bitters'),
(541, 'Mini-snickers bars'),
(542, 'Prosecco'),
(543, 'Salted Chocolate'),
(544, 'Martini Rosso'),
(545, 'Martini Bianco'),
(546, 'Martini Extra Dry'),
(547, 'Fresh Lime Juice'),
(548, 'Fresh Mint'),
(549, 'Rosemary'),
(550, 'Habanero Peppers'),
(551, 'Ilegal Joven mezcal'),
(552, 'Elderflower cordial'),
(553, 'Rosso Vermouth'),
(554, 'Creme de Violette'),
(555, 'Cocchi Americano'),
(556, 'White Vermouth'),
(557, 'Dry Curacao'),
(558, 'Nocino'),
(559, 'Averna'),
(560, 'Ramazzotti'),
(561, 'Fernet-Branca'),
(562, 'Allspice Dram'),
(563, 'Falernum'),
(564, 'Singani'),
(565, 'Arrack'),
(566, 'Blackstrap rum'),
(567, 'Ginger Syrup'),
(568, 'Honey syrup'),
(569, 'Blended Scotch'),
(570, 'Islay single malt Scotch'),
(571, '151 proof rum'),
(572, '7-up'),
(573, 'Absinthe'),
(574, 'Absolut citron'),
(575, 'Creme de Mure'),
(576, 'Olive Brine'),
(577, 'Pineapple Syrup'),
(578, 'St. Germain'),
(579, 'Lavender'),
(600, 'Whiskey'),
(601, 'Whisky'),
(602, 'Pomegranate juice'),
(603, 'Watermelon'),
(604, 'Chareau'),
(605, 'Cinnamon Whisky'),
(606, 'Red Bull'),
(607, 'Diet Coke'),
(608, 'Rosemary Syrup'),
(609, 'Figs'),
(610, 'Thyme'),
(611, 'Orange Slice'),
(612, 'Blood Orange'),
(613, 'Amaro Montenegro'),
(614, 'Ruby Port'),
(615, 'Rose'),
(616, 'Tajin');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `ratings`
--

CREATE TABLE `ratings` (
  `idUser` int(20) NOT NULL,
  `idDrink` int(20) NOT NULL,
  `Rating` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `recipes`
--

CREATE TABLE `recipes` (
  `idDrink` int(20) NOT NULL,
  `idIngredient` int(3) NOT NULL,
  `strMeasure` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `recipes`
--

INSERT INTO `recipes` (`idDrink`, `idIngredient`, `strMeasure`) VALUES
(1000000, 1, '10 oz'),
(1000000, 2, '1/4 liter'),
(1000001, 486, '1 teaspoon of matcha'),
(1000001, 513, '1 mug'),
(1000002, 30, '1'),
(1000002, 144, '3 l'),
(1000002, 299, '1'),
(1000002, 337, '3 leaves'),
(1000002, 359, '1'),
(1000003, 2, '100ml'),
(1000003, 299, '1'),
(1000003, 337, '1 leaf'),
(1000003, 497, '100ml'),
(1000004, 69, '1/4 glass'),
(1000004, 286, '1'),
(1000004, 337, '1 leaf'),
(1000004, 513, '200ml'),
(1000005, 1, '1 teaspoon'),
(1000005, 69, '1/4 glass'),
(1000005, 418, '50 ml'),
(1000005, 470, '2'),
(1000005, 513, '200ml');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `users`
--

CREATE TABLE `users` (
  `idUser` int(20) NOT NULL,
  `Username` varchar(50) NOT NULL,
  `Password` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`idUser`, `Username`, `Password`) VALUES
(2, 'a', '80084bf2fba02475726feb2cab2d8215eab14bc6bdd8bfb2c8151257032ecd8b'),
(7, 'Test', 'ab3fe4003f14e3ef573417f95e47d4985c482eadd139c08b3758eeae7cc60b9d'),
(8, 'Yunior', '1bf0b26eb2090599dd68cbb42c86a674cb07ab7adc103ad3ccdf521bb79056b9');

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`idComment`),
  ADD KEY `idUser` (`idUser`);

--
-- Indeksy dla tabeli `drinks`
--
ALTER TABLE `drinks`
  ADD PRIMARY KEY (`idDrink`);

--
-- Indeksy dla tabeli `favoritedcocktails`
--
ALTER TABLE `favoritedcocktails`
  ADD PRIMARY KEY (`idDrink`,`idUser`),
  ADD KEY `idUser` (`idUser`);

--
-- Indeksy dla tabeli `favoritedingredients`
--
ALTER TABLE `favoritedingredients`
  ADD PRIMARY KEY (`idUser`,`idIngredient`) USING BTREE,
  ADD KEY `idIngredient` (`idIngredient`);

--
-- Indeksy dla tabeli `ingredients`
--
ALTER TABLE `ingredients`
  ADD PRIMARY KEY (`idIngredient`);

--
-- Indeksy dla tabeli `ratings`
--
ALTER TABLE `ratings`
  ADD PRIMARY KEY (`idUser`,`idDrink`),
  ADD KEY `idUser` (`idUser`);

--
-- Indeksy dla tabeli `recipes`
--
ALTER TABLE `recipes`
  ADD PRIMARY KEY (`idDrink`,`idIngredient`) USING BTREE,
  ADD KEY `idIngredient` (`idIngredient`);

--
-- Indeksy dla tabeli `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`idUser`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `idComment` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `drinks`
--
ALTER TABLE `drinks`
  MODIFY `idDrink` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1000006;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `idUser` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`idUser`) REFERENCES `users` (`idUser`);

--
-- Constraints for table `favoritedcocktails`
--
ALTER TABLE `favoritedcocktails`
  ADD CONSTRAINT `favoritedcocktails_ibfk_2` FOREIGN KEY (`idUser`) REFERENCES `users` (`idUser`);

--
-- Constraints for table `favoritedingredients`
--
ALTER TABLE `favoritedingredients`
  ADD CONSTRAINT `favoritedingredients_ibfk_1` FOREIGN KEY (`idUser`) REFERENCES `users` (`idUser`),
  ADD CONSTRAINT `favoritedingredients_ibfk_2` FOREIGN KEY (`idIngredient`) REFERENCES `ingredients` (`idIngredient`);

--
-- Constraints for table `ratings`
--
ALTER TABLE `ratings`
  ADD CONSTRAINT `ratings_ibfk_2` FOREIGN KEY (`idUser`) REFERENCES `users` (`idUser`);

--
-- Constraints for table `recipes`
--
ALTER TABLE `recipes`
  ADD CONSTRAINT `recipes_ibfk_1` FOREIGN KEY (`idDrink`) REFERENCES `drinks` (`idDrink`),
  ADD CONSTRAINT `recipes_ibfk_2` FOREIGN KEY (`idIngredient`) REFERENCES `ingredients` (`idIngredient`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
