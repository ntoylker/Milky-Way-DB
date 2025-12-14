USE milkyway;

-- ==========================================================
-- STEP 1: INSERT INDEPENDENT ENTITIES (Constellations)
-- ==========================================================
INSERT INTO `Constellation` (`Id`, `Name`, `Area`, `History`, `GeometricalDescription`, `Quadrant`) VALUES
(1, 'Ωρίωνας', 594.000, 						'Ένας από τους πιο αναγνωρίσιμους, βασισμένος στον μυθικό κυνηγό.', 'Διακρίνεται από τη χαρακτηριστική ζώνη τριών αστέρων.', 'Ισημερινός'),	-- pdf
(2, 'Ύδρα', 1303.000, 							'Ο μεγαλύτερος αστερισμός του ουρανού.', 						'Πολύ μεγάλο και λεπτό σχήμα.', 							'Νότιος'),		-- pdf
(3, 'Νότιος Σταυρός', 168.000, 					'Ο μικρότερος αστερισμός, ναυτιλιακός δείκτης.', 				'Έχει σχήμα σταυρού ή χαρταετού.', 							'Νότιος'),		-- pdf
(100, 'Test Constellation for QUERY 1', 500.0, 	'Τεστ ιστορία, πάντα χαμηλά', 									'Έχει σχήμα σαν το κεφάλι του Κουδ', 					'Test Quadrant'), -- q1
(201, 'Draco', 1083.0, 'TEST', 'test',   'Test Quad'),	-- q2 Wrong Constellation
(300, 'Aquarius', 980.0, 'TEST', 'test', 'Test Quad'),	-- q3
(400, 'Cassiopeia', 598.0, 'TEST', 'test', 'Test Quad'),	-- q4
(500, 'Lyra', 286.0, 'TEST', 'test', 'Test Quad'),     -- q5 The Target
(501, 'Pegasus', 1121.0, 'TEST', 'test', 'Test Quad'); -- q5 The Wrong Constellation

-- ==========================================================
-- STEP 2: INSERT PLANETARY SYSTEMS
-- ==========================================================
INSERT INTO `Planetary System` (`Id`, `Name`, `DistanceFromEarth`, `ConstellationId`) VALUES
(1, 'Alphard System', 177.00, 2),      -- pdf In Hydra
(2, 'Acrux System', 321.00, 3),        -- pdf In Southern Cross
(3, 'Betelgeuse System', 642.00, 1),   -- pdf In Orion
(100, 'Alpha System (Winner)', 4.30,      100),   	-- q1 Close enough (< 5.0)
(101, 'Beta System (Too Far)', 6.00,      100),    	-- q1 Too far (> 5.0)
(102, 'Gamma System (Wrong Type)', 3.50,  100),		-- q1 Close, but wrong planets
(103, 'Delta System (Unhabitable)', 2.00, 100), 	-- q1 Close, but dead planets
(200, 'Orion Alpha Sys', 500.00, 1), 	-- q2 In Orion
(201, 'Orion Beta Sys', 400.00,  1),  	-- q2 In Orion
(202, 'Draco Gamma Sys', 100.00, 201), 	-- q2 In Draco
(300, 'Trappist', 39.00, 300),	-- q3
(400, 'Busy System (Large)', 25.00, 400),	-- q4 Has 4 Planets (Should Match)
(401, 'Quiet System (Small)', 12.00, 400), 	-- q4 Has 3 Planets (Should Fail)
(500, 'Vega System', 25.00, 500),      -- q5 In Lyra
(501, 'Sheliak System', 880.00, 500),  -- q5 In Lyra
(502, 'Markab System', 133.00, 501);   -- q5 In Pegasus

-- ==========================================================
-- STEP 3: INSERT PARENT "CELESTIAL OBJECTS"
-- ==========================================================
INSERT INTO `Celestial Object` (`Id`, `ObjectType`, `Name`) VALUES
-- Stars
(1, 'Star', 'Alphard'),
(2, 'Star', 'Acrux'),
(3, 'Star', 'Betelgeuse'),
(200, 'Star', 'Orion Hot Star'),	-- q2
(201, 'Star', 'Orion Cold Star'),	-- q2
(202, 'Star', 'Draco Hot Star'),	-- q2
(500, 'Star', 'Vega (The Match)'),				-- q5
(501, 'Star', 'Sheliak (Too Cold)'),			-- q5
(502, 'Star', 'Markab (Wrong Constellation)'),	-- q5
-- Planets
(4, 'Planet', 'Pyrrhos'),
(5, 'Planet', 'Cyralon'),
(6, 'Planet', 'Varunox'),
(100, 'Planet', 'Planet Winner'), 	-- q1
(101, 'Planet', 'Planet Far'), 		-- q1
(102, 'Planet', 'Planet Gas'), 		-- q1
(103, 'Planet', 'Planet Dead'), 	-- q1
(301, 'Planet', 'Trappist-Belt Dweller'), -- q3 The Match
(302, 'Planet', 'Trappist-Inner'),        -- q3 Too Close
(303, 'Planet', 'Trappist-Outer'),        -- q3 Too Far
(401, 'Planet', 'Busy-1'),	-- q4 4 Planets for the Busy System
(402, 'Planet', 'Busy-2'),	-- q4 4 Planets for the Busy System
(403, 'Planet', 'Busy-3'),	-- q4 4 Planets for the Busy System
(404, 'Planet', 'Busy-4'),	-- q4 4 Planets for the Busy System
(405, 'Planet', 'Quiet-1'),	-- q4 3 Planets for the Quiet System
(406, 'Planet', 'Quiet-2'),	-- q4 3 Planets for the Quiet System
(407, 'Planet', 'Quiet-3'),	-- q4 3 Planets for the Quiet System
-- Black Holes
(20, 'Black Hole', 'Stellar BH'),
(21, 'Black Hole', 'ORI-X1'),
(22, 'Black Hole', 'HYD-BH2'),
-- Nebulas
(30, 'Nebula', 'Emission Neb'),
(31, 'Nebula', 'Orionis Nebula-X'),
(32, 'Nebula', 'Lerna Shadow Cloud'),
-- Debris Disks
(40, 'Debris Disk', 'Dusty Ring'),
(41, 'Debris Disk', 'Alphard Dust Belt'),
(42, 'Debris Disk', 'Acrux Outer Disk'),
(304, 'Debris Disk', 'Trappist Belt');	-- q3

-- ==========================================================
-- STEP 4: INSERT CHILD TABLES (Stars, Planets, etc.)
-- ==========================================================
--
-- Stars
INSERT INTO `Star` (`CelestialId`, `PlanetarySystemId`, `DistanceFromEarth`, `Phase`, `SurfaceTemp`, `Age`, `Mass`, `Luminocity`) VALUES
(1, 1, 177.00, 'Main Sequence', 4230, 420.00, 3.000, 700.000),
(2, 2, 321.00, 'Subgiant', 24000, 18.00, 14.500, 25000.000),
(3, 3, 640.00, 'Red Supergiant', 3500, 10.00, 15.000, 100000.000),
(200, 200, 500.00, 'Red Supergiant',3500, 	15.0, 10.0, 10000.00), 	-- q2 Case A: The Match (In Orion, > 3000K) -> Result: 'Red Supergiant'
(201, 201, 400.00, 'Red Dwarf', 	2500,	0.5, 460.0, 0.05), 		-- q2 Case B: Too Cold (In Orion, < 3000K) -> Result: Ignored
(202, 202, 100.00, 'Main Sequence', 9000,	2.0, 500.0, 20.00), 	-- q2 Case C: Wrong Constellation (In Draco, > 3000K) -> Result: Ignored
(500, 500, 25.00, 'Main Sequence',    9600,  2.1, 455.0, 40.0), 		-- q5 Case A: The Match (In Lyra, Temp 9600 > 5000)
(501, 501, 880.00, 'Eclipsing Binary', 3500, 5.0, 100.0, 2000.0), 	-- q5 Case B: Too Cold (In Lyra, Temp 3500 < 5000)
(502, 502, 133.00, 'Main Sequence', 10000,   3.0, 300.0, 95.0); 		-- q5 Case C: Wrong Constellation (In Pegasus, Temp 10000 > 5000)

-- Planets
INSERT INTO `Planet` (`CelestialId`, `PlanetarySystemId`, `DistanceFromEarth`, `PlanetType`, `DistanceFromCenter`, `Habitability`, `SurfaceTemp`, `CoreTemp`, `OrbitalPeriod`, `Mass`) VALUES
(4, 2, 180620.00, 'Gas Giant', 54236.75, 0, 2200, 45000, 1752.00, 1017.00),
(5, 1, 14500.00, 'Rocky', 8589579.82, 0, 850, 7900, 64.00, 5.80),
(6, 3, 9556.00, 'Ice Giant', 9898579.56, 0, 380, 14500, 840.00, 133.50),
(100, 100, 4.30, 'Super Earth', 10000, 1, 280, 5000, 365, 1.5), -- q1 Case A: The Match (Should show up)
(101, 101, 6.00, 'Super Earth', 10000, 1, 280, 5000, 365, 1.5), -- q1 Case B: Too Far (Should NOT show up)
(102, 102, 3.50, 'Gas Giant', 20000, 1, 150, 4000, 4000, 300), 	-- q1 Case C: Wrong Type (Should NOT show up)
(103, 103, 2.00, 'Super Earth', 5000, 0, 800, 6000, 100, 1.8), 	-- q1 Case D: Not Habitable (Should NOT show up)
(301, 300, 39.00,   'Rocky',  15.00,   0,  200, 4000, 100,   1.0),	-- q3 Case A: The Match (Distance 15.0 is BETWEEN 10.0 and 20.0)
(302, 300, 39.00,   'Rocky',   5.00,   1,  300, 5000,  50,   0.8),	-- q3 Case B: Too Close (Distance 5.0 is NOT between 10.0 and 20.0)
(303, 300, 39.00, 'Ice Giant',25.00,   0,   50, 4000, 500,   5.0),	-- q3 Case C: Too Far (Distance 25.0 is NOT between 10.0 and 20.0)
(401, 400, 25.00, 'Gas Giant', 5.0, 0, 150, 5000, 400, 300.0),	-- q4 System 400 (Busy): 4 Planets
(402, 400, 25.00, 'Rocky',     2.0, 1, 280, 4000, 100, 1.0),	-- q4 System 400 (Busy): 4 Planets
(403, 400, 25.00, 'Ice Giant', 10.0, 0, 80,  3000, 1000, 15.0),	-- q4 System 400 (Busy): 4 Planets
(404, 400, 25.00, 'Rocky',     1.5, 0, 400, 4500, 80, 0.5),		-- q4 System 400 (Busy): 4 Planets
(405, 401, 12.00, 'Gas Giant', 4.0, 0, 140, 5000, 300, 250.0),	-- q4 System 401 (Quiet): 3 Planets
(406, 401, 12.00, 'Rocky',     1.2, 1, 300, 4100, 90, 1.2),		-- q4 System 401 (Quiet): 3 Planets
(407, 401, 12.00, 'Rocky',     0.8, 0, 500, 4600, 50, 0.4);		-- q4 System 401 (Quiet): 3 Planets

-- Black Holes
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
(42, 'Rocky', 3, 12.700, 29.300, 0.000150, 'Carbonaceous Rock'),
(304, 'Rocky Ring', 300, 10.000, 20.000, 0.005, 'Silicates');	-- q3


-- ==========================================================
-- STEP 5: INSERT DEPENDENT WEAK ENTITIES (Satellites)
-- ==========================================================
INSERT INTO `Satellite` (`Name`, `PlanetId`, `SatelliteType`, `Mass`, `SurfaceTemp`, `Diameter`) VALUES
('Thalmar', 4, 'Quasi', 0.01, 180, 3200.000),
('Kelython', 5, 'Natural', 0.03, 150, 5400.000),
('Dravix', 6, 'Natural', 0.19, 95, 11800.000),
('Busy-Moon', 401, 'Natural', 0.05, 100, 3000.000),		-- q4 Add a satellite to one of the "Busy" planets  (Busy-1,  ID 401)
('Quiet-Moon', 405, 'Natural', 0.04, 110, 2500.000);	-- q4 Add a satellite to one of the "Quiet" planets (Quiet-1, ID 405)

-- ==========================================================
-- STEP 6: INSERT OBSERVATIONS
-- ==========================================================
INSERT INTO `Observation` (`Id`, `CelestialId`, `Method`, `ResearcherName`, `Date`, `ObservationStatus`, `InstrumentType`) VALUES
(1, 2, 'Spectroscopy', 'Dr. Elena Korvin', '2034-05-01', 'Completed', 'Infrared-Telescope'),
(2, 6, 'Radar Imaging', 'Prof. Luis Ortega', '2035-01-01', 'In Progress', 'Deep-Space-Radar-Array'),
(3, 21, 'Transit Photometry', 'Dr. Mei-Ling Tan', '2033-11-01', 'Failed', 'Optical-Space-Telescope');

-- 