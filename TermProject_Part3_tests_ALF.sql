-- CS276 Term Project Part 3, Aaron Flager. Theoretical Camp Kirby Database.

-- Change Log to Objective 1 from first version:
-- * Changed ID data types from varchar2(10) to number(10)
-- * Removed default value 'next in sequence' from PK, going to utilize triggers
-- * Accolade description size increased from varchar2(50) to varchar2(600)
-- * "RESTRICTED_ACTIVITY_INFORMATION" Table changed to "RESTRICT_ACT_INFO"
-- * Added "ChangeLog" Table for testing Triggers. Objective 1 data changed accordingly.

-- PART 2
----------
-- Validation to show there is data entered into the database
SELECT * FROM Person;
SELECT * FROM Camper;
SELECT * FROM Staff;
SELECT * FROM Medical_Condition;
SELECT * FROM Medical_Information;
SELECT * FROM Restricted_Activities;
SELECT * FROM Restrict_Act_Info;
SELECT * FROM Week;
SELECT * FROM Camp_Fire_Club;
SELECT * FROM Caregiver;
SELECT * FROM Accolade;
SELECT * FROM Earned;
SELECT * FROM Position;
SELECT * FROM Certification;
SELECT * FROM Work;
SELECT * FROM Assigned;
SELECT * FROM ChangeLog; -- Added for Part 3


-- PART 3
----------
-- dataChange_pkg tests
------------------------

-- Tests INSERT. Assuming it's the first time it's run, weekID = 6
SELECT * FROM week;

BEGIN
  dataChange_pkg.week_insert('Week 3, 2015', '7/7/2015', '7/14/2015', 'Musical Week');
END;

-- Tests DELETE of newly entered test week, if it has weekID = 6
BEGIN
  dataChange_pkg.week_delete(6);
END;

-- Tests UPDATE for weekTheme. Theme should change from 'Dinosaurs' to 'Pirates'
SELECT * FROM week WHERE weekID = 1;

BEGIN
  dataChange_pkg.weekTheme_update(1, 'Pirates');
END;

-- Test DELETE to prove child table data deleted
-- View table data
SELECT * FROM week, assigned, work 
	WHERE week.weekID = 2 
	AND week.weekID = assigned.weekID 
	AND week.weekID = work.weekID;

-- Delete weekID 2
BEGIN
  dataChange_pkg.week_delete(2);
END;


-- dataFind_pkg tests
----------------------

-- Tests caregiver_find. Expect "Testing this: CPS Skagit County"
BEGIN
  DBMS_OUTPUT.PUT_LINE('Testing this: ' || dataFind_pkg.caregiver_find(1));
END;

-- Seeing what staff are in what positions
SELECT s.staffID, s.campNickName, p.positionID 
FROM staff s
INNER JOIN certification c
  ON s.staffID = c.staffID
INNER JOIN position p
  ON p.positionID = c.positionID;
  
-- Tests position_count. Expect "Count of position 1: 2"
BEGIN
  DBMS_OUTPUT.PUT_LINE('Count of position 1: ' || dataFind_pkg.position_count(1));
END;

-- Seeing what campers have earned which accolades
SELECT c.camperID, c.camperName, a.accoladeName, a.accoladecategory 
FROM camper c
INNER JOIN earned e
  ON c.camperID = e.camperID
INNER JOIN accolade a
  ON a.accoladeID = e.accoladeID;
 
-- Tests accbycateg_forCamper. Expect "Camper 4 earned # of Archery accolades: 1" 
BEGIN
  DBMS_OUTPUT.PUT_LINE('Camper 4 earned # of Archery accolades: ' 
	|| dataFind_pkg.accbycateg_forCamper(4, 'Archery'));
END;

-- Trigger tests, check "changelog" table data
-- Can utilize dataChange_pkg test anonymous blocks
-- Information will vary depending on inserted/updated/deleted data
SELECT * FROM changelog;

