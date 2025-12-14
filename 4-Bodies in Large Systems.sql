
-- Query 4: Bodies in Large Systems

-- System "Busy" (The Match): Has 4 Planets (Threshold is > 3). One of these planets will have a satellite. All these bodies (4 planets + 1 satellite) should appear in the result.
-- System "Quiet" (The Fail): Has 3 Planets. This is not greater than 3. None of its bodies should appear.

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

-- What to expect: you should see exactly 5 results (bodies):
-- Busy-1 (Planet)
-- Busy-2 (Planet)
-- Busy-3 (Planet)
-- Busy-4 (Planet)
-- Busy-Moon (Satellite)
-- You should NOT see any "Quiet" planets or the "Quiet-Moon", because their system only has 3 planets (which is not greater than 3).