
-- Query 3: Planets in the Asteroid Belt

SELECT co.`Name` AS PlanetName
FROM `Planet` p
JOIN `Celestial Object` co ON p.`CelestialId` = co.`Id`
JOIN `Planetary System` ps ON p.`PlanetarySystemId` = ps.`Id`
JOIN `Debris Disk` dd ON dd.`PlanetarySystemId` = ps.`Id`
WHERE ps.`Name` = 'Trappist'
  AND p.`DistanceFromCenter` BETWEEN dd.`InnerRadius` AND dd.`OuterRadius`;