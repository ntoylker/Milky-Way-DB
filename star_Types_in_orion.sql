
-- Query 2: Star Types in Orion

SELECT s.`Phase`
FROM `Star` s
JOIN `Planetary System` ps ON s.`PlanetarySystemId` = ps.`Id`
JOIN `Constellation` c ON ps.`ConstellationId` = c.`Id`
WHERE s.`SurfaceTemp` >= 3000 
  AND c.`Name` = 'Ωρίωνας';