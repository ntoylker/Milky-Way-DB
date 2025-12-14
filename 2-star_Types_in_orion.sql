
-- Query 2: Star Types in Orion

-- Case A (The Match): A star in Orion with Temp > 3000 (Should appear).
-- Case B (Too Cold): A star in Orion with Temp < 3000 (Should be ignored).
-- Case C (Wrong Constellation): A star in Draco with Temp > 3000 (Should be ignored).

SELECT s.`Phase`
FROM `Star` s
JOIN `Planetary System` ps ON s.`PlanetarySystemId` = ps.`Id`
JOIN `Constellation` c ON ps.`ConstellationId` = c.`Id`
WHERE s.`SurfaceTemp` >= 3000 
  AND c.`Name` = 'Ωρίωνας';

-- What to expect: you should see exactly one result: Red Supergiant.
-- It ignores the Red Dwarf because it is too cold (2500K).
-- It ignores the Main Sequence star because it is in Draco, not Orion.