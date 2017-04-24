-- CS276 Term Project Part 2, Aaron Flager. Theoretical Camp Kirby Database.

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

-- Change Log to Data Dictionary from version 1:

-- * Changed ID data types from varchar2(10) to number(10)
-- * Removed default value 'next in sequence' from PK, going to utilize triggers
-- * Accolade description size increased from varchar2(50) to varchar2(600)

-- PART 3
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