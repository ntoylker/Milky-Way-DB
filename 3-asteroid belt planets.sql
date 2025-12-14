
-- Query 3: Planets in the Asteroid Belt

-- The System: Must be named 'Trappist'.
-- The Disk: Let's say it exists from 10.0 to 20.0 AU (Astronomical Units).
-- Case A (The Match): A planet at 15.0 AU (Inside the belt).
-- Case B (Too Close): A planet at 5.0 AU (Safe inside the ring).
-- Case C (Too Far): A planet at 25.0 AU (Safe outside the ring).

SELECT co.`Name` AS PlanetName
FROM `Planet` p
JOIN `Celestial Object` co ON p.`CelestialId` = co.`Id`
JOIN `Planetary System` ps ON p.`PlanetarySystemId` = ps.`Id`
JOIN `Debris Disk` dd ON dd.`PlanetarySystemId` = ps.`Id`
WHERE ps.`Name` = 'Trappist'
  AND p.`DistanceFromCenter` BETWEEN dd.`InnerRadius` AND dd.`OuterRadius`;
  
-- What to expect: you should see exactly one result: Trappist-Belt Dweller.
-- It ignores Trappist-Inner because 5.0 is less than the Inner Radius (10.0).
-- It ignores Trappist-Outer because 25.0 is greater than the Outer Radius (20.0).