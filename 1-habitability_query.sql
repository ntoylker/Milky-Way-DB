
-- Query 1: Habitability Search

-- Case A (The Winner): A system < 5.0 ly with a Habitable Super Earth. (Should appear in results).
-- Case B (Too Far): A system > 5.0 ly with a Habitable Super Earth. (Should be ignored).
-- Case C (Wrong Type): A system < 5.0 ly but the planet is a Gas Giant. (Should be ignored).
-- Case D (Not Habitable): A system < 5.0 ly with a Super Earth, but Habitability = 0. (Should be ignored).

SELECT DISTINCT ps.`Name` AS HabbitableSystemName
FROM `Planet` p
JOIN `Planetary System` ps ON p.`PlanetarySystemId` = ps.`Id`
WHERE p.`PlanetType` LIKE '%Super Earth%' 
  AND p.`Habitability` = 1 
  AND ps.`DistanceFromEarth` < 5.0;
  
-- What to expect: you should see exactly one result: Alpha System (Winner)