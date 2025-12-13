
-- Query 1: Habitability Search

SELECT DISTINCT ps.`Name` AS SystemName
FROM `Planet` p
JOIN `Planetary System` ps ON p.`PlanetarySystemId` = ps.`Id`
WHERE p.`PlanetType` LIKE '%Super Earth%' 
  AND p.`Habitability` = 1 
  AND ps.`DistanceFromEarth` < 5.0;