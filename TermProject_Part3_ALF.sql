-- CS276 Term Project Part 3, Aaron Flager. Theoretical Camp Kirby Database.

-- Package One, Contains: INSERT, UPDATE, DELETE with Exception handling
-------------------------------------------------------------------------
-- dataChange_pkg Specification
CREATE OR REPLACE PACKAGE dataChange_pkg
	IS
	-- INSERT for Week table
	PROCEDURE week_insert
		(p_weekName IN week.weekName%TYPE,
		 p_weekBeginDate IN week.weekBeginDate%TYPE,
		 p_weekEndDate IN week.weekEndDate%TYPE,
		 p_weekTheme IN week.weekTheme%TYPE);
		 
	-- UPDATE for Week table, Theme column, based on PK
	PROCEDURE weekTheme_update
		(p_weekID IN week.weekID%TYPE,
		 p_weekTheme IN week.weekTheme%TYPE);
		 
	-- DELETE Week based on PK
	PROCEDURE week_delete
		(p_weekID IN week.weekID%TYPE);
		
END dataChange_pkg;

-- dataChange_pkg Body
CREATE OR REPLACE PACKAGE BODY dataChange_pkg
	IS
	-- INSERT for Week table
	PROCEDURE week_insert
		(p_weekName IN week.weekName%TYPE,
		 p_weekBeginDate IN week.weekBeginDate%TYPE,
		 p_weekEndDate IN week.weekEndDate%TYPE,
		 p_weekTheme IN week.weekTheme%TYPE)
		IS
	BEGIN
		INSERT INTO Week
		VALUES (week_seq.NEXTVAL, 
				p_weekName, p_weekBeginDate, 
				p_weekEndDate, p_weekTheme);
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			raise_application_error (-20001, 'no data found');
		WHEN OTHERS THEN
			raise_application_error (-20000, 'problem encountered');
	END week_insert;
	
	-- UPDATE for Week table Theme column, based on PK
	PROCEDURE weekTheme_update
		(p_weekID IN week.weekID%TYPE,
		 p_weekTheme IN week.weekTheme%TYPE)
		 IS
	BEGIN
		UPDATE week SET weekTheme = p_weekTheme WHERE weekID = p_weekID;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			raise_application_error (-20001, 'no data found');
		WHEN OTHERS THEN
			raise_application_error (-20000, 'problem encountered');
	END weekTheme_update;
	
	-- DELETE Week based on PK
	PROCEDURE week_delete
		(p_weekID IN week.weekID%TYPE)
		IS
	BEGIN
		DELETE FROM assigned WHERE weekID = p_weekID;
		DELETE FROM work WHERE weekID = p_weekID;
		DELETE FROM week WHERE weekID = p_weekID;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			raise_application_error (-20001, 'no data found');
		WHEN OTHERS THEN
			raise_application_error (-20000, 'problem encountered');
	END week_delete;
	
END dataChange_pkg;


-- Package Two, Contains: 3 Functions
--------------------------------------
-- dataFind_pkg Specification
CREATE OR REPLACE PACKAGE dataFind_pkg
	IS
	-- Find caregiver's name for camperID
	FUNCTION caregiver_find
		(f_camperID IN camper.camperID%TYPE)
		RETURN VARCHAR2;
		
	-- Count number of staff in specific position
	FUNCTION position_count
		(f_position IN position.positionID%TYPE)
		RETURN NUMBER;
		
	-- How many accolades earned by camper of specific category
	FUNCTION accByCateg_forCamper
		(f_camperID IN camper.camperID%TYPE,
		 f_accoladeCategory IN accolade.accoladeCategory%TYPE)
		 RETURN NUMBER;
		 
END dataFind_pkg;

-- dataFind_pkg Body
CREATE OR REPLACE PACKAGE BODY dataFind_pkg
	IS
	-- Find caregiver's name for camperID
	FUNCTION caregiver_find
		(f_camperID IN camper.camperID%TYPE)
		RETURN VARCHAR2
	IS
		lv_caregiverName caregiver.caregiverName%TYPE;
	BEGIN
		SELECT caregiverName INTO lv_caregiverName
		FROM caregiver
		WHERE camperID = f_camperID;
		RETURN lv_caregiverName;
	END caregiver_find;
	
	-- Count number of staff in specific position
	FUNCTION position_count
		(f_position IN position.positionID%TYPE)
		RETURN NUMBER
	IS
		lv_count NUMBER;
	BEGIN
		SELECT COUNT(p.positionID) INTO lv_count
		FROM staff s
		INNER JOIN certification c
		  ON s.staffID = c.staffID
		INNER JOIN position p
		  ON p.positionID = c.positionID
		WHERE f_position = p.positionID;
		RETURN lv_count;
	END position_count;
	
	-- How many accolades earned by camper of specific category
	FUNCTION accByCateg_forCamper
		(f_camperID IN camper.camperID%TYPE,
		 f_accoladeCategory IN accolade.accoladeCategory%TYPE)
		 RETURN NUMBER
	IS
		lv_countAccolade NUMBER;
	BEGIN
		SELECT COUNT(e.accoladeID) INTO lv_countAccolade
		FROM earned e
		INNER JOIN camper c
		  ON e.camperID = c.camperID
		INNER JOIN accolade a
		  ON e.accoladeID = a.accoladeID
		WHERE f_camperID = e.camperID
		AND f_accoladeCategory = a.accoladeCategory;
		RETURN lv_countAccolade;
	END accByCateg_forCamper;
	
END dataFind_pkg;


-- Three Triggers, one for each of INSERT, UPDATE, DELETE
----------------------------------------------------------
/* 	
	More information about previous and current data could be tracked if necessary.
	Currently, I only update the theme and the effectiveness of the ChangeLog table
	can be evaluated off of only recording the old and new values for weekTheme. In
	a more extensive changelog, all the changed values for the table could be recorded.
*/
-- INSERT trigger
CREATE OR REPLACE TRIGGER insert_trigger
  AFTER INSERT ON week
  FOR EACH ROW
 BEGIN
   INSERT INTO changelog
    VALUES(changelog_seq.NEXTVAL, USER, SYSDATE, :OLD.weekTheme, :NEW.weekTheme, 'I');
 END;
 
 -- UPDATE trigger
 CREATE OR REPLACE TRIGGER update_trigger
  AFTER UPDATE ON week
  FOR EACH ROW
 BEGIN
   INSERT INTO changelog
    VALUES(changelog_seq.NEXTVAL, USER, SYSDATE, :OLD.weekTheme, :NEW.weekTheme, 'U');
 END;
 
 -- DELETE trigger
 CREATE OR REPLACE TRIGGER delete_trigger
  AFTER DELETE ON week
  FOR EACH ROW
 BEGIN
   INSERT INTO changelog
    VALUES(changelog_seq.NEXTVAL, USER, SYSDATE, :OLD.weekTheme, :NEW.weekTheme, 'D');
 END;
 

---------------------------------------------------------------------------------
/* PREVIOUSLY SEPARATE FILE, BUT LIMITED TO 3 FILE SUBMISSIONS ON OBJECTIVE 3 */
---------------------------------------------------------------------------------

-- CS276 Term Project Part 3, Aaron Flager. Theoretical Camp Kirby Database.
-- TESTING AND CHANGE NOTES

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

