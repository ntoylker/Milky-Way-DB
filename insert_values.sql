USE milkyway;

-- ==========================================================
-- STEP 0: FIX DATA TYPES TO MATCH PDF EXAMPLES
-- ==========================================================
-- Expanding Luminocity to hold values like 25,000 (from PDF example)
ALTER TABLE `Star` MODIFY `Luminocity` DECIMAL(15,2); 
-- Expanding OrbitalPeriod to hold values like 1752 (from PDF example)
ALTER TABLE `Planet` MODIFY `OrbitalPeriod` DECIMAL(10,2);
-- Expanding Mass to hold values like 1017.00 (from PDF example)
ALTER TABLE `Planet` MODIFY `Mass` DECIMAL(10,2);


-- ==========================================================
-- STEP 1: INSERT INDEPENDENT ENTITIES (Constellations)
-- ==========================================================
INSERT INTO `Constellation` (`Id`, `Name`, `Area`, `History`, `GeometricalDescription`, `Quadrant`) VALUES
(1, 'Ωρίωνας', 594.000, 'Ένας από τους πιο αναγνωρίσιμους, βασισμένος στον μυθικό κυνηγό.', 'Διακρίνεται από τη χαρακτηριστική ζώνη τριών αστέρων.', 'Ισημερινός'),
(2, 'Ύδρα', 1303.000, 'Ο μεγαλύτερος αστερισμός του ουρανού.', 'Πολύ μεγάλο και λεπτό σχήμα.', 'Νότιος'),
(3, 'Νότιος Σταυρός', 168.000, 'Ο μικρότερος αστερισμός, ναυτιλιακός δείκτης.', 'Έχει σχήμα σταυρού ή χαρταετού.', 'Νότιος');


-- ==========================================================
-- STEP 2: INSERT PLANETARY SYSTEMS
-- ==========================================================
-- These link to Constellations, so they come second.
INSERT INTO `Planetary System` (`Id`, `Name`, `DistanceFromEarth`, `ConstellationId`) VALUES
(1, 'Alphard System', 177.00, 2),     -- In Hydra
(2, 'Acrux System', 321.00, 3),       -- In Southern Cross
(3, 'Betelgeuse System', 642.00, 1);  -- In Orion


-- ==========================================================
-- STEP 3: INSERT PARENT "CELESTIAL OBJECTS"
-- ==========================================================
-- We must create the ID and Name here first before creating the specific Star/Planet/etc.
INSERT INTO `Celestial Object` (`Id`, `ObjectType`, `Name`) VALUES
-- Stars
(1, 'Star', 'Alphard'),
(2, 'Star', 'Acrux'),
(3, 'Star', 'Betelgeuse'),
-- Planets
(4, 'Planet', 'Pyrrhos'),
(5, 'Planet', 'Cyralon'),
(6, 'Planet', 'Varunox'),
-- Black Holes (IDs from PDF pg 46)
(20, 'Black Hole', 'Stellar BH'),
(21, 'Black Hole', 'ORI-X1'),
(22, 'Black Hole', 'HYD-BH2'),
-- Nebulas (IDs from PDF pg 46)
(30, 'Nebula', 'Emission Neb'),
(31, 'Nebula', 'Orionis Nebula-X'),
(32, 'Nebula', 'Lerna Shadow Cloud'),
-- Debris Disks (IDs from PDF pg 46)
(40, 'Debris Disk', 'Dusty Ring'),
(41, 'Debris Disk', 'Alphard Dust Belt'),
(42, 'Debris Disk', 'Acrux Outer Disk');


-- ==========================================================
-- STEP 4: INSERT CHILD TABLES (Stars, Planets, etc.)
-- ==========================================================

-- Stars (Data from PDF pg 43)
INSERT INTO `Star` (`CelestialId`, `PlanetarySystemId`, `DistanceFromEarth`, `Phase`, `SurfaceTemp`, `Age`, `Mass`, `Luminocity`) VALUES
(1, 1, 177.00, 'Main Sequence', 4230, 420.00, 3.000, 700.00),
(2, 2, 321.00, 'Subgiant', 24000, 18.00, 14.500, 25000.00),
(3, 3, 640.00, 'Red Supergiant', 3500, 10.00, 15.000, 100000.00);

-- Planets (Data from PDF pg 43-44)
INSERT INTO `Planet` (`CelestialId`, `PlanetarySystemId`, `DistanceFromEarth`, `PlanetType`, `DistanceFromCenter`, `Habitability`, `SurfaceTemp`, `CoreTemp`, `OrbitalPeriod`, `Mass`) VALUES
(4, 2, 180620.00, 'Gas Giant', 54236.75, 0, 2200, 45000, 1752.00, 1017.00),
(5, 1, 14500.00, 'Rocky', 8589579.82, 0, 850, 7900, 64.00, 5.80),
(6, 3, 9556.00, 'Ice Giant', 9898579.56, 0, 380, 14500, 840.00, 133.50);

-- Black Holes (Data from PDF pg 46)
INSERT INTO `Black Hole` (`CelestialId`, `BlackHoleType`, `ConstellationId`, `DistanceFromEarth`, `Mass`, `Spin`, `EventHorizonRadius`) VALUES
(20, 'Stellar', 1, 1340.50, 12.500, 0.6700, 37000.00),
(21, 'Intermediate', 2, 8700.20, 520.000, 0.8100, 1540000.00),
(22, 'Supermassive', 3, 2000.00, 999.999, 0.9900, 99999999.99); -- (Note: PDF Mass 5.8M exceeds DECIMAL(6,3), inserted max allowed)

-- Nebulas (Data from PDF pg 46)
INSERT INTO `Nebula` (`CelestialId`, `NebulaType`, `ConstellationId`, `DistanceFromEarth`, `PhysicalSize`, `PrimaryComposition`) VALUES
(30, 'Emission', 1, 1344.20, 24.00, 'H2, He, OIII'),
(31, 'Dark', 2, 3900.50, 12.70, 'Carbon Dust, H2'),
(32, 'Reflection', 3, 620.30, 8.10, 'Silicates, Molecular Gas');

-- Debris Disks (Data from PDF pg 46)
INSERT INTO `Debris Disk` (`CelestialId`, `DebrisDiskType`, `PlanetarySystemId`, `InnerRadius`, `OuterRadius`, `Mass`, `MainComposition`) VALUES
(40, 'Dusty Ring', 1, 18.200, 42.500, 0.000021, 'Silicates, Ice Grains'),
(41, 'Icy Debris', 2, 34.100, 88.000, 0.000305, 'Water Ice, CO Ice'),
(42, 'Rocky', 3, 12.700, 29.300, 0.000150, 'Carbonaceous Rock');


-- ==========================================================
-- STEP 5: INSERT DEPENDENT WEAK ENTITIES (Satellites)
-- ==========================================================
INSERT INTO `Satellite` (`Name`, `PlanetId`, `SatelliteType`, `Mass`, `SurfaceTemp`, `Diameter`) VALUES
('Thalmar', 4, 'Quasi', 0.01, 180, 3200.000),
('Kelython', 5, 'Natural', 0.03, 150, 5400.000),
('Dravix', 6, 'Natural', 0.19, 95, 11800.000);


-- ==========================================================
-- STEP 6: INSERT OBSERVATIONS
-- ==========================================================
INSERT INTO `Observation` (`Id`, `CelestialId`, `Method`, `ResearcherName`, `Date`, `ObservationStatus`, `InstrumentType`) VALUES
(1, 2, 'Spectroscopy', 'Dr. Elena Korvin', '2034-05-01', 'Completed', 'Infrared-Telescope'),
(2, 6, 'Radar Imaging', 'Prof. Luis Ortega', '2035-01-01', 'In Progress', 'Deep-Space-Radar-Array'),
(3, 21, 'Transit Photometry', 'Dr. Mei-Ling Tan', '2033-11-01', 'Failed', 'Optical-Space-Telescope');