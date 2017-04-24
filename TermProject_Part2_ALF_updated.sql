-- CS276 Term Project Part 2, Aaron Flager. Theoretical Camp Kirby Database.
-- Updated to match with Part 3

-- Set date format
ALTER SESSION SET NLS_DATE_FORMAT = 'MM/DD/YYYY';

-- Drop Preexisting Database
DROP SEQUENCE personID_seq;
DROP SEQUENCE camperID_seq;
DROP SEQUENCE staffID_seq;
DROP SEQUENCE medical_Condition_seq;
DROP SEQUENCE medical_Information_seq;
DROP SEQUENCE restricted_Activities_seq;
DROP SEQUENCE RAInfo_seq;
DROP SEQUENCE week_seq;
DROP SEQUENCE camp_Fire_Club_seq;
DROP SEQUENCE caregiver_seq;
DROP SEQUENCE accolade_seq;
DROP SEQUENCE earned_seq;
DROP SEQUENCE position_seq;
DROP SEQUENCE certification_seq;
DROP SEQUENCE work_seq;
DROP SEQUENCE assigned_seq;
DROP SEQUENCE changelog_seq;

DROP TABLE Assigned;
DROP TABLE Work;
DROP TABLE Certification;
DROP TABLE Position;
DROP TABLE Earned;
DROP TABLE Accolade;
DROP TABLE Caregiver;
DROP TABLE Camp_Fire_Club;
DROP TABLE Week;
DROP TABLE Restrict_Act_Info;
DROP TABLE Restricted_Activities;
DROP TABLE Medical_Information;
DROP TABLE Medical_Condition;
DROP TABLE Staff;
DROP TABLE Camper;
DROP TABLE Person;
DROP TABLE ChangeLog;

-- Person
CREATE TABLE Person (
	PersonID number(10) NOT NULL,
	PersonName varchar2(50),
	CONSTRAINT personID_pk PRIMARY KEY (PersonID));
	
CREATE SEQUENCE personID_seq;

INSERT INTO Person VALUES (personID_seq.NEXTVAL, 'Bigby Hand');
INSERT INTO Person VALUES (personID_seq.NEXTVAL, 'Mordenkainen Mansion');
INSERT INTO Person VALUES (personID_seq.NEXTVAL, 'Leomund Hut');
INSERT INTO Person VALUES (personID_seq.NEXTVAL, 'Melf Magic');
INSERT INTO Person VALUES (personID_seq.NEXTVAL, 'Gandalf Glamdring');
INSERT INTO Person VALUES (personID_seq.NEXTVAL, 'Evard Black');
INSERT INTO Person VALUES (personID_seq.NEXTVAL, 'Jaina Proudmoore');
INSERT INTO Person VALUES (personID_seq.NEXTVAL, 'Rosemary Thyme');
INSERT INTO Person VALUES (personID_seq.NEXTVAL, 'Santa Claus');
INSERT INTO Person VALUES (personID_seq.NEXTVAL, 'Easter Bunny');

-- Camper
CREATE TABLE Camper (
	CamperID number(10) NOT NULL,
	PersonID number(10) NOT NULL,
	CamperName varchar2(50) NOT NULL,
	CamperAge number(3) NOT NULL,
	CONSTRAINT camperID_pk PRIMARY KEY (CamperID),
	CONSTRAINT fk_personID_camper FOREIGN KEY (PersonID) REFERENCES Person(PersonID),
	CONSTRAINT camperAge_check CHECK (CamperAge BETWEEN 3 and 150));
	
CREATE SEQUENCE camperID_seq;

CREATE INDEX camperName_index ON Camper(CamperAge);

INSERT INTO Camper VALUES (camperID_seq.NEXTVAL, 6, 'Evard Black', 12);
INSERT INTO Camper VALUES (camperID_seq.NEXTVAL, 7, 'Jaina Proudmoore', 12);
INSERT INTO Camper VALUES (camperID_seq.NEXTVAL, 8, 'Rosemary Thyme', 16);
INSERT INTO Camper VALUES (camperID_seq.NEXTVAL, 9, 'Santa Claus', 8);
INSERT INTO Camper VALUES (camperID_seq.NEXTVAL, 10, 'Easter Bunny', 7);

-- Staff
CREATE TABLE Staff (
	StaffID number(10) NOT NULL,
	PersonID number(10) NOT NULL,
	StaffPhone varchar2(25) NOT NULL,
	StaffAddress varchar2(100),
	StaffEmail varchar2(60),
	CampNickname varchar2(25) DEFAULT 'Muffins',
	CONSTRAINT staffID_pk PRIMARY KEY (StaffID),
	CONSTRAINT fk_personID_staff FOREIGN KEY (PersonID) REFERENCES Person(PersonID));

CREATE SEQUENCE staffID_seq;

INSERT INTO Staff VALUES (staffID_seq.NEXTVAL, 1, '(555) 444-3333', '20 Polyhedral St., Bellingham, WA, 57527', 'first@email.net', 'Taco');
INSERT INTO Staff VALUES (staffID_seq.NEXTVAL, 2, '(555) 333-2222', '717 Clam Dr., Bellingham, WA, 57527', 'second@email.net', 'Widget');
INSERT INTO Staff VALUES (staffID_seq.NEXTVAL, 3, '(555) 222-1111', '20 Oyster Lane, Bow, WA, 57500', 'third@email.net', 'Sphinx');
INSERT INTO Staff VALUES (staffID_seq.NEXTVAL, 4, '(555) 777-8888', '456 Seagull Blvd., Mt. Vernon, WA, 57745', 'fourth@email.net', 'Fuzzy');
INSERT INTO Staff (StaffID, PersonID, StaffPhone) VALUES (staffID_seq.NEXTVAL, 5, '(555) 111-2222');

-- Medical_Condition
CREATE TABLE Medical_Condition (
	ConditionID number(10) NOT NULL,
	ConditionName varchar2(25) NOT NULL UNIQUE,
	ConditionDesc varchar2(600) NOT NULL,
	CONSTRAINT conditionID_pk PRIMARY KEY (ConditionID),
	CONSTRAINT descLength_check CHECK (LENGTH(ConditionDesc) > 50));

CREATE SEQUENCE medical_Condition_seq START WITH 10;

INSERT INTO Medical_Condition VALUES (medical_Condition_seq.NEXTVAL, 'Allergy: Peanuts', 'This person is allergic to peanuts. This is an incredibly severe allergy and should be a high priority of concern.');
INSERT INTO Medical_Condition VALUES (medical_Condition_seq.NEXTVAL, 'Allergy: Bee Sting', 'This person is allergic to bee stings. This is an moderately severe allergy and should be considered when leaving camp property.');
INSERT INTO Medical_Condition VALUES (medical_Condition_seq.NEXTVAL, 'Heart Damage', 'This person has suffered heart damage. Their physical activity should be closely monitored. Ensure medication is taken at proper times.');
INSERT INTO Medical_Condition VALUES (medical_Condition_seq.NEXTVAL, 'ADHD', 'This person has a challenging time focusing on tasks. Have patience with them and monitor they are taking medications as needed.');
INSERT INTO Medical_Condition VALUES (medical_Condition_seq.NEXTVAL, 'Ear Infection', 'This person has an ear infection. Their water time activity should be closely monitored, or cancelled if they are uncomfortable.');

-- Medical_Information
CREATE TABLE Medical_Information (
	MedInfoID number(10) NOT NULL,
	ConditionID number(10) NOT NULL,
	PersonID number(10) NOT NULL,
	CONSTRAINT medInfoID_pk PRIMARY KEY (MedInfoID),
	CONSTRAINT fk_conditionID_MInfo FOREIGN KEY (ConditionID) REFERENCES Medical_Condition(ConditionID),
	CONSTRAINT fk_personID_MInfo FOREIGN KEY (PersonID) REFERENCES Person(PersonID));

CREATE SEQUENCE medical_Information_seq;

INSERT INTO Medical_Information VALUES (medical_Information_seq.NEXTVAL, 11, 1);
INSERT INTO Medical_Information VALUES (medical_Information_seq.NEXTVAL, 12, 1);
INSERT INTO Medical_Information VALUES (medical_Information_seq.NEXTVAL, 13, 6);
INSERT INTO Medical_Information VALUES (medical_Information_seq.NEXTVAL, 14, 9);

-- Restricted_Activities
CREATE TABLE Restricted_Activities (
	RestrictedActID number(10) NOT NULL,
	RestrictedActName varchar2(25) NOT NULL,
	RestrictedActDescc varchar2(600),
	CONSTRAINT restrictedActID_pk PRIMARY KEY (RestrictedActID));

CREATE SEQUENCE restricted_Activities_seq;

INSERT INTO Restricted_Activities VALUES (restricted_Activities_seq.NEXTVAL, 'Archery', 'Unable to participate in any archery related activities.');
INSERT INTO Restricted_Activities VALUES (restricted_Activities_seq.NEXTVAL, 'Waterfront', 'Unable to participate in any waterfront related activities.');
INSERT INTO Restricted_Activities VALUES (restricted_Activities_seq.NEXTVAL, 'Climbing', 'Unable to participate in any climbing wall related activities.');
INSERT INTO Restricted_Activities VALUES (restricted_Activities_seq.NEXTVAL, 'Camping', 'Unable to participate in the campout, refer to activity director for alternative care options.');

-- Restricted_Activity_Information
CREATE TABLE Restrict_Act_Info (
	RestrictedInfoID number(10) NOT NULL,
	PersonID number(10) NOT NULL,
	RestrictedActID number(10) NOT NULL,
	CONSTRAINT restrictedInfoID_pk PRIMARY KEY (RestrictedInfoID),
	CONSTRAINT fk_personID_RAInfo FOREIGN KEY (PersonID) REFERENCES Person(PersonID),
	CONSTRAINT fk_RActID_RAInfo FOREIGN KEY (RestrictedActID) REFERENCES Restricted_Activities(RestrictedActID));
	
CREATE SEQUENCE RAInfo_seq;
	
INSERT INTO Restrict_Act_Info VALUES (RAInfo_seq.NEXTVAL, 6, 2);
INSERT INTO Restrict_Act_Info VALUES (RAInfo_seq.NEXTVAL, 7, 2);
INSERT INTO Restrict_Act_Info VALUES (RAInfo_seq.NEXTVAL, 9, 4);
INSERT INTO Restrict_Act_Info VALUES (RAInfo_seq.NEXTVAL, 4, 1);

-- Week
CREATE TABLE Week (
	WeekID number(10) NOT NULL,
	WeekName varchar2(50) NOT NULL,
	WeekBeginDate date NOT NULL,
	WeekEndDate date NOT NULL,
	WeekTheme varchar2(50),
	CONSTRAINT weekID_pk PRIMARY KEY (WeekID),
	CONSTRAINT weekName_unique UNIQUE (WeekName));

CREATE SEQUENCE week_seq;

INSERT INTO Week VALUES (week_seq.NEXTVAL, '2014, Week 1', '06/28/2014', '07/05/2014', 'Dinosaurs');
INSERT INTO Week VALUES (week_seq.NEXTVAL, '2014, Week 2', '07/06/2014', '07/13/2014', 'Space Pirates');
INSERT INTO Week VALUES (week_seq.NEXTVAL, '2014, Week 3', '07/14/2014', '07/21/2014', 'Water Week');
INSERT INTO Week VALUES (week_seq.NEXTVAL, '2014, Week 4', '07/22/2014', '07/29/2014', 'Wizards');
INSERT INTO Week VALUES (week_seq.NEXTVAL, '2014, Week 5', '07/30/2014', '08/06/2014', 'Fairy Tales');

-- Camp_Fire_Club
CREATE TABLE Camp_Fire_Club (
	ClubID number(10) NOT NULL,
	CamperID number(10) NOT NULL,
	ClubName varchar2(50) DEFAULT 'Samish Council' NOT NULL,
	ClubPhone varchar2(25) DEFAULT '(555) 555-5555',
	ClubEmail varchar2(50) DEFAULT 'samish.council@campfire.com',
	CONSTRAINT clubID_pk PRIMARY KEY (ClubID),
	CONSTRAINT fk_camperID_CFC FOREIGN KEY (CamperID) REFERENCES Camper(CamperID));

CREATE SEQUENCE camp_Fire_Club_seq;

INSERT INTO Camp_Fire_Club VALUES (camp_Fire_Club_seq.NEXTVAL, 1, 'Lake County Campfire', '(545) 545-5454', 'lake.council@campfire.com');
INSERT INTO Camp_Fire_Club (ClubID, CamperID) VALUES (camp_Fire_Club_seq.NEXTVAL, 2);
INSERT INTO Camp_Fire_Club (ClubID, CamperID) VALUES (camp_Fire_Club_seq.NEXTVAL, 3);
INSERT INTO Camp_Fire_Club (ClubID, CamperID) VALUES (camp_Fire_Club_seq.NEXTVAL, 4);
INSERT INTO Camp_Fire_Club (ClubID, CamperID) VALUES (camp_Fire_Club_seq.NEXTVAL, 5);

-- Caregiver
CREATE TABLE Caregiver (
	CaregiverID number(10) NOT NULL,
	CamperID number(10) NOT NULL,
	CaregiverName varchar2(50) DEFAULT 'CPS Skagit County' NOT NULL,
	CaregiverPhone varchar2(25) DEFAULT '(555) 444-4444' NOT NULL,
	CaregiverAddress varchar2(260) DEFAULT 'Skagit County Address, Bow, WA, 55555',
	CaregiverEmail varchar2(100) DEFAULT 'cps.skagit@childcare.gov',
	CONSTRAINT caregiverID_pk PRIMARY KEY (CaregiverID),
	CONSTRAINT fk_camperID_caregiver FOREIGN KEY (CamperID) REFERENCES Camper(CamperID));

CREATE SEQUENCE caregiver_seq;

INSERT INTO Caregiver (CaregiverID, CamperID) VALUES (caregiver_seq.NEXTVAL, 1);
INSERT INTO Caregiver VALUES (caregiver_seq.NEXTVAL, 2, 'Mary Poppins', '(555) 999-9999', '123 Lollipop Loop, Bow, WA, 58989', 'umbrella@email.net');
INSERT INTO Caregiver VALUES (caregiver_seq.NEXTVAL, 3, 'Mary Poppins', '(555) 988-9888', '123 Lollipop Loop, Bow, WA, 58989', 'umbrella@email.net');
INSERT INTO Caregiver VALUES (caregiver_seq.NEXTVAL, 4, 'Oompa Loompa', '(555) 123-5432', '444 Wonka Blvd., Mt. Vernon, WA, 58900', 'candy@email.net');
INSERT INTO Caregiver VALUES (caregiver_seq.NEXTVAL, 5, 'Captain Kangaroo', '(555) 432-1234', '17 Hopsalong Rd., Bellingham, WA, 58212', 'howdy@email.net');

-- Accolade
CREATE TABLE Accolade (
	AccoladeID number(10) NOT NULL,
	AccoladeName varchar2(50) NOT NULL,
	AccoladeCategory varchar2(50),
	AccoladeDesc varchar2(600),
	CONSTRAINT accoladeID_pk PRIMARY KEY (AccoladeID));

CREATE SEQUENCE accolade_seq;

INSERT INTO Accolade VALUES (accolade_seq.NEXTVAL, 'Archery Rank: 1', 'Archery', 'Person has shot 25 points from 5 yards.');
INSERT INTO Accolade VALUES (accolade_seq.NEXTVAL, 'Sharpshooter', 'Archery', 'Person has shot all bullseyes from 10 yards or more.');
INSERT INTO Accolade VALUES (accolade_seq.NEXTVAL, 'Canoe Rank: 3', 'Waterfront', 'Person has traveled on an overnight canoe trip.');
INSERT INTO Accolade VALUES (accolade_seq.NEXTVAL, 'Plant Identification Bead', 'Outdoor Living Skills', 'Person has identified 10 or more plants accurately.');
INSERT INTO Accolade VALUES (accolade_seq.NEXTVAL, 'Friendship Song Bead', 'Leadership', 'Person has made up a complimentary song for 3 other campers.');

-- Earned
CREATE TABLE Earned (
	EarnedID number(10) NOT NULL,
	AccoladeID number(10) NOT NULL,
	CamperID number(10) NOT NULL,
	CONSTRAINT earnedID_pk PRIMARY KEY (EarnedID),
	CONSTRAINT fk_accoladeID_earned FOREIGN KEY (AccoladeID) REFERENCES Accolade(AccoladeID),
	CONSTRAINT fk_camperID_earned FOREIGN KEY (CamperID) REFERENCES Camper(CamperID));

CREATE SEQUENCE earned_seq;

INSERT INTO Earned VALUES (earned_seq.NEXTVAL, 1, 5);
INSERT INTO Earned VALUES (earned_seq.NEXTVAL, 1, 4);
INSERT INTO Earned VALUES (earned_seq.NEXTVAL, 2, 5);
INSERT INTO Earned VALUES (earned_seq.NEXTVAL, 3, 2);
INSERT INTO Earned VALUES (earned_seq.NEXTVAL, 5, 1);

-- Position
CREATE TABLE Position (
	PositionID number(10) NOT NULL,
	PositionName varchar(25) NOT NULL,
	PositionDesc varchar2(600) NOT NULL,
	CONSTRAINT positionID_pk PRIMARY KEY (PositionID),
	CONSTRAINT posDescLength_check CHECK (LENGTH(PositionDesc) > 50));
	
CREATE SEQUENCE position_seq;

INSERT INTO Position VALUES (position_seq.NEXTVAL, 'Camp Counselor', 'In charge of caring for the day to day needs of their assigned campers. Includes overnight care and specific child care needs.');
INSERT INTO Position VALUES (position_seq.NEXTVAL, 'CIT Counselor', 'Offers training and oversight to the campers in the "Counselor in Training" program. Includes educational guidance and hands on experiences for campers.');
INSERT INTO Position VALUES (position_seq.NEXTVAL, 'Arts and Crafts', 'In charge of offering fun and approachable arts and crafts activities during programming time. Also available for other programming staff duties when required.');
INSERT INTO Position VALUES (position_seq.NEXTVAL, 'Archery Instructor', 'In charge of offering safe and fun archery instruction during programming time. Also available for other programming staff duties when required.');
INSERT INTO Position VALUES (position_seq.NEXTVAL, 'Program Director', 'Organizes the schedules and activities of all program staff. Responsible for camp wide theme integration and weekly all camp games.');

-- Certification
CREATE TABLE Certification (
	CertID number(10) NOT NULL,
	StaffID number(10) NOT NULL,
	PositionID number(10) NOT NULL,
	CertName varchar2(25) NOT NULL,
	CertDesc varchar2(260),
	CertInquiryPhone varchar2(25),
	CONSTRAINT certID_pk PRIMARY KEY (CertID),
	CONSTRAINT fk_staffID_cert FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
	CONSTRAINT fk_positionID_cert FOREIGN KEY (PositionID) REFERENCES Position(PositionID));

CREATE SEQUENCE certification_seq;

INSERT INTO Certification VALUES (certification_seq.NEXTVAL, 1, 4, 'AAA Instructor', 'American Archery Association Instructor Certification.', '(555) 677-7776');
INSERT INTO Certification VALUES (certification_seq.NEXTVAL, 3, 1, 'Red Cross First Aid + CPR', 'Red Cross Trained First Aid and CPR', '(555) 987-7890');
INSERT INTO Certification VALUES (certification_seq.NEXTVAL, 4, 1, 'UW First Aid + CPR', 'University of Washington Trained First Aid and CPR', '(555) 111-1211');
INSERT INTO Certification VALUES (certification_seq.NEXTVAL, 5, 5, 'Leadership Instructor', 'Campfire Verified Leadership Instructor Certification', '(555) 333-3232');

-- Work
CREATE TABLE Work (
	WorkID number(10) NOT NULL,
	PositionID number(10) NOT NULL,
	StaffID number(10) NOT NULL,
	WeekID number(10) NOT NULL,
	CONSTRAINT workID_pk PRIMARY KEY (WorkID),
	CONSTRAINT fk_positionID_work FOREIGN KEY (PositionID) REFERENCES Position(PositionID),
	CONSTRAINT fk_staffID_work FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
	CONSTRAINT fk_weekID_work FOREIGN KEY (WeekID) REFERENCES Week(WeekID));

CREATE SEQUENCE work_seq;

INSERT INTO Work VALUES (work_seq.NEXTVAL, 1, 4, 1);
INSERT INTO Work VALUES (work_seq.NEXTVAL, 3, 1, 2);
INSERT INTO Work VALUES (work_seq.NEXTVAL, 4, 1, 3);
INSERT INTO Work VALUES (work_seq.NEXTVAL, 5, 5, 4);

-- Assigned
CREATE TABLE Assigned (
	AssignedID number(10) NOT NULL,
	StaffID number(10) NOT NULL,
	CamperID number(10) NOT NULL,
	WeekID number(10) NOT NULL,
	CONSTRAINT assignedID_pk PRIMARY KEY (AssignedID),
	CONSTRAINT fk_staffID_assigned FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
	CONSTRAINT fk_camperID_assigned FOREIGN KEY (CamperID) REFERENCES Camper(CamperID),
	CONSTRAINT fk_weekID_assigned FOREIGN KEY (WeekID) REFERENCES Week(WeekID));
	
CREATE SEQUENCE assigned_seq;

INSERT INTO Assigned VALUES (assigned_seq.NEXTVAL, 4, 1, 1);
INSERT INTO Assigned VALUES (assigned_seq.NEXTVAL, 4, 3, 2);
INSERT INTO Assigned VALUES (assigned_seq.NEXTVAL, 5, 4, 2);
INSERT INTO Assigned VALUES (assigned_seq.NEXTVAL, 3, 3, 3);
INSERT INTO Assigned VALUES (assigned_seq.NEXTVAL, 4, 1, 5);

-- ChangeLog
CREATE TABLE ChangeLog (
	changeLogID number(10) NOT NULL,
	CLUser varchar2(25) NOT NULL,
	CLSystemDate date NOT NULL,
	OldValue varchar2(600),
	NewValue varchar2(600),
	TypeOfChange char(1) NOT NULL,
	CONSTRAINT changeLogID_pk PRIMARY KEY (changeLogID));
	
CREATE SEQUENCE changelog_seq;