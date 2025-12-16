DROP DATABASE IF EXISTS milkyway;
CREATE DATABASE milkyway CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE milkyway;

-- 1. CELESTIAL OBJECT (Parent Table)
CREATE TABLE `Celestial Object` (
    `Id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `ObjectType` ENUM('Star', 'Planet', 'Black Hole', 'Nebula', 'Debris Disk') NOT NULL,
    `Name` VARCHAR(50) NOT NULL,
    PRIMARY KEY (`Id`)
);

-- 2. CONSTELLATION
CREATE TABLE `Constellation` (
    `Id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `Name` VARCHAR(50) NOT NULL,
    `Area` DECIMAL(8,3) NOT NULL,
    `History` TEXT,
    `GeometricalDescription` TEXT,
    `Quadrant` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`Id`)
);

-- 3. PLANETARY SYSTEM
CREATE TABLE `Planetary System` (
    `Id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `Name` VARCHAR(50) NOT NULL,
    `DistanceFromEarth` DECIMAL(10,2) NOT NULL,
    `ConstellationId` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`Id`),
    CONSTRAINT `fk_ps_constellation` FOREIGN KEY (`ConstellationId`) REFERENCES `Constellation`(`Id`) ON DELETE CASCADE
);

-- 4. STAR (Inherits from Celestial Object)
CREATE TABLE `Star` (
    `CelestialId` INT UNSIGNED NOT NULL,
    `PlanetarySystemId` INT UNSIGNED NOT NULL,
    `DistanceFromEarth` DECIMAL(10,2) NOT NULL,
    `Mass` DECIMAL(6,3) NOT NULL,
    `Age` DECIMAL(11,2) NOT NULL,
    `SurfaceTemp` INT NOT NULL,
    `Luminocity` DECIMAL(10,3) NOT NULL,
    `Phase` TEXT NOT NULL,
    PRIMARY KEY (`CelestialId`),
    CONSTRAINT `fk_star_celestial` FOREIGN KEY (`CelestialId`) REFERENCES `Celestial Object`(`Id`) ON DELETE CASCADE,
    CONSTRAINT `fk_star_ps` FOREIGN KEY (`PlanetarySystemId`) REFERENCES `Planetary System`(`Id`) ON DELETE CASCADE
);

-- 5. PLANET (Inherits from Celestial Object)
CREATE TABLE `Planet` (
    `CelestialId` INT UNSIGNED NOT NULL,
    `PlanetarySystemId` INT UNSIGNED NOT NULL,
    `DistanceFromEarth` DECIMAL(10,2) NOT NULL,
    `DistanceFromCenter` DECIMAL(12,2) NOT NULL,
    `Mass` DECIMAL(10,2) NOT NULL,
    `PlanetType` TEXT NOT NULL,
    `CoreTemp` INT NOT NULL,
    `SurfaceTemp` INT NOT NULL,
    `OrbitalPeriod` DECIMAL(10,5) NOT NULL,
    `Habitability` BIT NOT NULL,
    PRIMARY KEY (`CelestialId`),
    CONSTRAINT `fk_planet_celestial` FOREIGN KEY (`CelestialId`) REFERENCES `Celestial Object`(`Id`) ON DELETE CASCADE,
    CONSTRAINT `fk_planet_ps` FOREIGN KEY (`PlanetarySystemId`) REFERENCES `Planetary System`(`Id`) ON DELETE CASCADE
);

-- 6. SATELLITE (Weak Entity)
CREATE TABLE `Satellite` (
    `Name` VARCHAR(50) NOT NULL,
    `Diameter` DECIMAL(12,3) NOT NULL,
    `PlanetId` INT UNSIGNED NOT NULL,
    `Mass` DECIMAL(5,2) NOT NULL,
    `SurfaceTemp` INT NOT NULL,
    `SatelliteType` TEXT NOT NULL,
    PRIMARY KEY (`Name`, `PlanetId`),
    CONSTRAINT `fk_satellite_planet` FOREIGN KEY (`PlanetId`) REFERENCES `Planet`(`CelestialId`) ON DELETE CASCADE
);

-- 7. OBSERVATION
CREATE TABLE `Observation` (
    `Id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `CelestialId` INT UNSIGNED NOT NULL,
    `Method` VARCHAR(100) NOT NULL,
    `InstrumentType` VARCHAR(100) NOT NULL,
    `Date` DATE NOT NULL,
    `ResearcherName` VARCHAR(50) NOT NULL,
    `ObservationStatus` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`Id`),
    CONSTRAINT `fk_obs_celestial` FOREIGN KEY (`CelestialId`) REFERENCES `Celestial Object`(`Id`) ON DELETE CASCADE
);

-- 8. BLACK HOLE (Inherits from Celestial Object)
CREATE TABLE `Black Hole` (
    `CelestialId` INT UNSIGNED NOT NULL,
    `BlackHoleType` VARCHAR(100) NOT NULL,
    `ConstellationId` INT UNSIGNED NOT NULL,
    `DistanceFromEarth` DECIMAL(10,2) NOT NULL,
    `Mass` DECIMAL(6,3) NOT NULL,
    `Spin` DECIMAL(5,4) NOT NULL,
    `EventHorizonRadius` DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (`CelestialId`),
    CONSTRAINT `fk_bh_celestial` FOREIGN KEY (`CelestialId`) REFERENCES `Celestial Object`(`Id`) ON DELETE CASCADE,
    CONSTRAINT `fk_bh_constellation` FOREIGN KEY (`ConstellationId`) REFERENCES `Constellation`(`Id`) ON DELETE CASCADE
);

-- 9. NEBULA (Inherits from Celestial Object)
CREATE TABLE `Nebula` (
    `CelestialId` INT UNSIGNED NOT NULL,
    `NebulaType` VARCHAR(100) NOT NULL,
    `ConstellationId` INT UNSIGNED NOT NULL,
    `DistanceFromEarth` DECIMAL(10,2) NOT NULL,
    `PhysicalSize` DECIMAL(6,2) NOT NULL,
    `PrimaryComposition` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`CelestialId`),
    CONSTRAINT `fk_nebula_celestial` FOREIGN KEY (`CelestialId`) REFERENCES `Celestial Object`(`Id`) ON DELETE CASCADE,
    CONSTRAINT `fk_nebula_constellation` FOREIGN KEY (`ConstellationId`) REFERENCES `Constellation`(`Id`) ON DELETE CASCADE
);

-- 10. DEBRIS DISK (Inherits from Celestial Object)
CREATE TABLE `Debris Disk` (
    `CelestialId` INT UNSIGNED NOT NULL,
    `DebrisDiskType` VARCHAR(100) NOT NULL,
    `PlanetarySystemId` INT UNSIGNED NOT NULL,
    `InnerRadius` DECIMAL(12,3) NOT NULL,
    `OuterRadius` DECIMAL(12,3) NOT NULL,
    `Mass` DECIMAL(10,6) NOT NULL,
    `MainComposition` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`CelestialId`),
    CONSTRAINT `fk_dd_celestial` FOREIGN KEY (`CelestialId`) REFERENCES `Celestial Object`(`Id`) ON DELETE CASCADE,
    CONSTRAINT `fk_dd_ps` FOREIGN KEY (`PlanetarySystemId`) REFERENCES `Planetary System`(`Id`) ON DELETE CASCADE
);

-- ==========================================================
-- 11. TABLE FOR VERIFIED USER SUBMISSIONS (Requirement 2)
-- ΧΡΕΙΑΖΕΤΑΙ ΑΥΤΌΣ Ο ΠΊΝΑΚΑΣ ΓΙΑ ΝΑ ΜΠΟΡΈΣΕΙ ΝΑ ΥΠΑΡΞΕΙ Ο USER "VERIFIED USER" ΠΟΥ ΠΕΡΙΓΡΑΦΗΚΕ
-- ΣΤΟ ΠΡΩΤΟ ΠΑΡΑΔΟΤΕΟ ΣΤΗΝ ΥΠΟΕΝΟΤΗΤΑ 2.
-- ΑΥΤΌΣ Ο ΠΙΝΑΚΑΣ ΥΛΟΠΟΙΕΙ ΤΙΣ "ΑΙΤΗΣΕΙΣ" ΠΟΥ ΚΑΝΕΙ Ο VERIFIED USER ΓΙΑ ΝΑ ΚΑΤΑΧΩΡΗΣΕΙ ΔΕΔΟΜΕΝΑ ΣΤΗ ΒΑΣΗ
-- ΔΕΝ ΥΠΑΡΧΕΙ ΣΤΑ ΣΧΗΜΑΤΑ, ΔΕΝ ΥΠΑΡΧΕΙ ΠΟΥΘΕΝΑ ΠΕΡΑ ΑΠΌ ΕΔΩ.
-- ΚΑΘΑΡΑ ΒΟΗΘΗΤΙΚΌ TABLE
-- ==========================================================
CREATE TABLE `Pending_Observation` (
    `Id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `SubmitterName` VARCHAR(50) NOT NULL,
    `TargetObject` VARCHAR(50) NOT NULL,
    `ObservationData` TEXT NOT NULL,
    `SubmissionDate` DATE NOT NULL,
    `Status` ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
    PRIMARY KEY (`Id`)
);


-- ==========================================================
-- 12. VIEWS (Based on Deliverable 1, Section 4.4)
-- ==========================================================

-- 1. View for Natural Satellites, their Mother Planet and the System [cite: 388]
-- Shows satellite details linked to the planet name (from Celestial Object) and System name.
CREATE OR REPLACE VIEW `View_Satellite_Full_Details` AS
SELECT 
    s.`Name` AS SatelliteName,
    s.`Diameter`,
    s.`SatelliteType`,
    co.`Name` AS PlanetName,
    ps.`Name` AS SystemName
FROM `Satellite` s
JOIN `Planet` p ON s.`PlanetId` = p.`CelestialId`
JOIN `Celestial Object` co ON p.`CelestialId` = co.`Id`
JOIN `Planetary System` ps ON p.`PlanetarySystemId` = ps.`Id`;

-- 2. View for Planetary Systems that have Red Dwarfs [cite: 404]
-- Lists systems containing stars with phase 'Red Dwarf', showing Mass and Luminosity.
CREATE OR REPLACE VIEW `View_Red_Dwarf_Systems` AS
SELECT 
    ps.`Name` AS SystemName,
    co.`Name` AS StarName,
    s.`Mass`,
    s.`Luminocity`,
    s.`Phase`
FROM `Star` s
JOIN `Planetary System` ps ON s.`PlanetarySystemId` = ps.`Id`
JOIN `Celestial Object` co ON s.`CelestialId` = co.`Id`
WHERE s.`Phase` = 'Red Dwarf';

-- 3. View for Planet types with high surface temperature (> 400K) [cite: 408]
-- Filters planets hot enough to likely be uninhabitable or close to the star.
CREATE OR REPLACE VIEW `View_Hot_Planets` AS
SELECT 
    co.`Name` AS PlanetName,
    p.`PlanetType`,
    p.`SurfaceTemp`,
    ps.`Name` AS SystemName
FROM `Planet` p
JOIN `Celestial Object` co ON p.`CelestialId` = co.`Id`
JOIN `Planetary System` ps ON p.`PlanetarySystemId` = ps.`Id`
WHERE p.`SurfaceTemp` > 400;

-- 4. View for Planets and the name of their Planetary System [cite: 412]
-- A general directory connecting Planets to their Systems.
CREATE OR REPLACE VIEW `View_Planet_Directory` AS
SELECT 
    co.`Name` AS PlanetName,
    ps.`Name` AS SystemName,
    p.`Habitability`,
    p.`DistanceFromEarth`
FROM `Planet` p
JOIN `Planetary System` ps ON p.`PlanetarySystemId` = ps.`Id`
JOIN `Celestial Object` co ON p.`CelestialId` = co.`Id`;