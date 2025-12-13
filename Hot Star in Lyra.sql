
-- Query 5: Hot Stars in Lyra

SELECT co.`Name` AS StarName
FROM `Star` s
JOIN `Celestial Object` co ON s.`CelestialId` = co.`Id`
JOIN `Planetary System` ps ON s.`PlanetarySystemId` = ps.`Id`
JOIN `Constellation` c ON ps.`ConstellationId` = c.`Id`
WHERE s.`SurfaceTemp` > 5000
  AND c.`Name` = 'Lyra';