DROP DATABASE IF EXISTS milkyway;
CREATE DATABASE milkyway;
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
    `Luminocity` DECIMAL(6,5) NOT NULL,
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
    `Mass` DECIMAL(5,2) NOT NULL,
    `PlanetType` TEXT NOT NULL,
    `CoreTemp` INT NOT NULL,
    `SurfaceTemp` INT NOT NULL,
    `OrbitalPeriod` DECIMAL(8,5) NOT NULL,
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