
-- Query 4: Bodies in Large Systems

-- Part A: Planets in large systems
SELECT co.`Name` AS BodyName, p.`SurfaceTemp`
FROM `Planet` p
JOIN `Celestial Object` co ON p.`CelestialId` = co.`Id`
WHERE p.`PlanetarySystemId` IN (
    SELECT `PlanetarySystemId`
    FROM `Planet`
    GROUP BY `PlanetarySystemId`
    HAVING COUNT(*) > 3
)

UNION

-- Part B: Satellites of those planets
SELECT s.`Name` AS BodyName, s.`SurfaceTemp`
FROM `Satellite` s
JOIN `Planet` p ON s.`PlanetId` = p.`CelestialId`
WHERE p.`PlanetarySystemId` IN (
    SELECT `PlanetarySystemId`
    FROM `Planet`
    GROUP BY `PlanetarySystemId`
    HAVING COUNT(*) > 3
);