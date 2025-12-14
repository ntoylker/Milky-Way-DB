
-- Query 5: Hot Stars in Lyra

-- Constellations: One named 'Lyra' (Target) and one named 'Pegasus' (Distraction).
-- Case A (The Match): A star in Lyra with Temp 10,000 K (Should appear).
-- Case B (Too Cold): A star in Lyra with Temp 4,000 K (Should be ignored).
-- Case C (Wrong Constellation): A star in Pegasus with Temp 12,000 K (Should be ignored).

SELECT co.`Name` AS StarName
FROM `Star` s
JOIN `Celestial Object` co ON s.`CelestialId` = co.`Id`
JOIN `Planetary System` ps ON s.`PlanetarySystemId` = ps.`Id`
JOIN `Constellation` c ON ps.`ConstellationId` = c.`Id`
WHERE s.`SurfaceTemp` > 5000
  AND c.`Name` = 'Lyra';
  
-- What to expect: you should see exactly one result: Vega (The Match).
-- It ignores Sheliak (Too Cold) because 3500 is not greater than 5000.
-- It ignores Markab (Wrong Constellation) because it belongs to Pegasus, not Lyra.