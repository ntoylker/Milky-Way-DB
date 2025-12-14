-- ==========================================================
-- USER CREATION AND PRIVILEGES
-- Roles defined in Deliverable 1:
-- 1. Administrator (Διαχειριστής)
-- 2. Researcher (Ερευνητής)
-- 3. Verified User (Ερασιτέχνης Verified User)
-- 4. Hobbyist (Χομπίστας)
-- ==========================================================

-- 1. Create the Users (with placeholder passwords)
CREATE USER IF NOT EXISTS 'admin_user'@'localhost' IDENTIFIED BY 'adminPass123!';
CREATE USER IF NOT EXISTS 'researcher_user'@'localhost' IDENTIFIED BY 'researchPass123!';
CREATE USER IF NOT EXISTS 'verified_user'@'localhost' IDENTIFIED BY 'verifiedPass123!';
CREATE USER IF NOT EXISTS 'hobbyist_user'@'localhost' IDENTIFIED BY 'hobbyPass123!';

-- ==========================================================
-- GRANT PRIVILEGES
-- ==========================================================

-- ----------------------------------------------------------
-- 1. ADMINISTRATOR
-- Requirement: Full control over data and roles
-- ----------------------------------------------------------
GRANT ALL PRIVILEGES ON milkyway.* TO 'admin_user'@'localhost' WITH GRANT OPTION;


-- ----------------------------------------------------------
-- 2. RESEARCHER
-- Requirement: Read all data, Insert new data, Update/Delete their own data
-- Note: SQL cannot restrict "Update own data only" natively without complex row-level security
-- Standard practice is to grant INSERT, UPDATE, DELETE permissions on the data tables
-- ----------------------------------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON milkyway.* TO 'researcher_user'@'localhost';


-- ----------------------------------------------------------
-- 3. VERIFIED USER
-- Requirement: Read official data, Submit proposals to "Pending Observations"
-- CRITICAL NOTE: Your current schema lacks the "Pending Observations" table mentioned in Deliverable 1
-- Therefore, we grant SELECT on all tables
-- ----------------------------------------------------------
GRANT SELECT ON milkyway.* TO 'verified_user'@'localhost';
GRANT INSERT ON milkyway.`Observation` TO 'verified_user'@'localhost'; 


-- ----------------------------------------------------------
-- 4. HOBBYIST
-- Requirement: Read-only access, complex queries
-- ----------------------------------------------------------
GRANT SELECT ON milkyway.* TO 'hobbyist_user'@'localhost';


-- ==========================================================
-- APPLY CHANGES
-- ==========================================================
FLUSH PRIVILEGES;