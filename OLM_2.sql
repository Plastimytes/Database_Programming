
CREATE DATABASE Online_Learning;
use Online_Learning;

SELECT DATABASE();

CREATE TABLE  USER(User_ID INT PRIMARY KEY, Name VARCHAR(100), Email VARCHAR(50), Password VARCHAR(20), Role VARCHAR(50));
CREATE TABLE COURSE(Course_ID VARCHAR(50) PRIMARY KEY, Course_Name VARCHAR(40), Description VARCHAR(100), User_ID INT, Price INT,Foreign Key (User_ID) REFERENCES USER(User_ID))

CREATE TABLE LESSON(Lesson_ID VARCHAR(50) PRIMARY KEY, Course_Name VARCHAR(40), Course_ID VARCHAR(50), Lesson_Name VARCHAR(40), Content_Type VARCHAR(30), Status VARCHAR(50),Foreign Key (Course_ID) REFERENCES COURSE(Course_ID))

CREATE TABLE PROGRESS(Progress_ID VARCHAR(25) PRIMARY KEY, User_ID INT, Course_ID VARCHAR(50), Complete_Percentage VARCHAR(25), Grade VARCHAR(25),Foreign Key (Course_ID) REFERENCES COURSE(Course_ID),Foreign Key (User_ID) REFERENCES USER(User_ID))

INSERT INTO USER (User_ID, Name, Email, Password, Role) VALUES
(101, 'Alice Johnson', 'alice.j@email.com', 'securepass1', 'Instructor'),
(102, 'Bob Smith', 'bob.s@email.com', 'mypassword', 'Student'),
(103, 'Charlie Brown', 'charlie.b@email.com', 'safeword321', 'Student'),
(104, 'Diana Prince', 'diana.p@email.com', 'wonderpass', 'Instructor');

INSERT INTO COURSE (Course_ID, Course_Name, Description, User_ID, Price) VALUES
('CS101', 'Intro to SQL', 'Learn the basics of database querying and management.', 101, 49),
('WEB202', 'Full Stack Dev', 'Build complete web applications using modern frameworks.', 104, 99),
('DES303', 'UX/UI Fundamentals', 'Principles of user experience and interface design.', 101, 75);

INSERT INTO LESSON (Lesson_ID, Course_Name, Course_ID, Lesson_Name, Content_Type, Status) VALUES
('L001-CS', 'Intro to SQL', 'CS101', 'What is a Database?', 'Video', 'Completed'),
('L002-CS', 'Intro to SQL', 'CS101', 'Basic SELECT Statements', 'Quiz', 'In Progress'),
('L003-CS', 'Intro to SQL', 'CS101', 'JOIN Operations', 'Video', 'Not Started'),
('L004-WEB', 'Full Stack Dev', 'WEB202', 'Node.js Backend Setup', 'Document', 'Completed'),
('L005-WEB', 'Full Stack Dev', 'WEB202', 'Frontend React Basics', 'Video', 'Completed'),
('L006-DES', 'UX/UI Fundamentals', 'DES303', 'Design Thinking Process', 'Quiz', 'Not Started');

INSERT INTO PROGRESS (Progress_ID, User_ID, Course_ID, Complete_Percentage, Grade) VALUES
('102', 102, 'CS101', '50%', 'B+'),
('103', 103, 'CS101', '100%', 'A'),
('104', 102, 'WEB202', '25%', 'N/A'),
('105', 103, 'DES303', '0%', 'N/A');

ALTER TABLE course
ADD CONSTRAINT CHK_COUR_PR CHECK (Price >=0)

ALTER TABLE USER
ALTER COLUMN Name SET DEFAULT 'Not Assigned';

ALTER TABLE COURSE
MODIFY COLUMN Description VARCHAR(100) NOT NULL;

ALTER TABLE PROGRESS
MODIFY Progress_ID INT NOT NULL AUTO_INCREMENT;

--Testing Constraints
--Course

--insert into USER (User_ID, Name, Email, Password, Role)VALUES
--(101, 'Duplicate ID test', 'mark@gmail.com','fail','Student')

--INSERT INTO COURSE (Course_ID, Course_Name, Description, User_ID, Price)VALUES
--('FAIL1', 'Negative Price Testing', 'Test check constraint',101,-5)

--INSERT INTO COURSE (Course_ID, Course_Name, Description, User_ID, Price)VALUES
--('FAIL1', 'Negative Price Test', 'Testing CHECK constraint.', 101, -5);

INSERT INTO USER (User_ID, Email, Password, Role) VALUES
(105, 'noname@test.com', 'autodefault', 'Student');

SELECT User_ID, Name, Email FROM USER WHERE User_ID = 105;
INSERT INTO PROGRESS (User_ID, Course_ID, Complete_Percentage, Grade) VALUES
(102, 'DES303', '10%', 'C');
SELECT Progress_ID, Complete_Percentage, Grade FROM PROGRESS WHERE Progress_ID = 106;

--Natural Join
SELECT * FROM USER NATURAL JOIN COURSE
NATURAL JOIN LESSON
NATURAL JOIN PROGRESS;

--Better version 
SELECT COURSE.*,LESSON.*,PROGRESS.* FROM COURSE, LESSON, PROGRESS WHERE COURSE.Course_ID = LESSON.Course_ID OR COURSE.Course_ID = PROGRESS.Course_ID;

--Inner Join
SELECT
 U.User_ID,
 U.Name,
 P.Course_ID,
 P.Grade
FROM
 USER U
INNER JOIN
 PROGRESS P ON U.User_ID = P.User_ID

--Left Outer Join
SELECT
 U.User_ID,
 U.Name,
 U.Role,
 P.Course_ID,
 P.Grade
FROM
 USER U
LEFT OUTER JOIN
 PROGRESS P ON U.User_ID;

--Right Outer Join
SELECT
 U.User_ID,
 U.Name,
 U.Role,
 P.Course_ID,
 P.Grade
FROM
 USER U
RIGHT OUTER JOIN
 PROGRESS P ON U.User_ID;

--Full Outer Join


SELECT
    U.User_ID,
    U.Name,
    P.Course_ID,
    P.Grade
FROM
    USER U FULL OUTER JOIN
    PROGRESS P ON U.User_ID = P.User_ID; 

SELECT
    U.Name AS Student,
    C.Course_Name,
    C.Price
FROM
    USER U,
    COURSE C
WHERE
    U.Role = 'Student' AND C.Price < 70;

--Reflection and Verification
SHOW CREATE TABLE USER;

----Entity Integrity makes each table row uniquely indentifiable by enforcing a non-null primary key while refferential integrity maintains the validity of relationship between tables by making sure foreign keys match a primary key in another table. These constraints enforce rules on data to ensure consistency and validity thus preventing insertion of inaccurate or corrupted information.The LEFT JOIN would be the one found most useful as it allows for querying all records from the primary table and including information from a related table

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

----Creating triggers for the Onilne learning System 
---A trrigger is a type of stored procedure that automatically runs when a specific event occurs in a table. It is not run manually the database runs it automatically as soon as the said event happens.

--Before trigger- type of trigger that executes it's associated SQL statement before a specific Data Manipulation Language (INSERT, UPDATE, DELETE) event

DELIMITER//

CREATE TRIGGER BEF_PROGRESS_INSERT
BEFORE INSERT ON PROGRESS
FOR EACH ROW
BEGIN
    IF NEW.Complete_percentage IS NULL OR NEW.Complete_Percentage = '' THEN
         SET NEW.Complete_Percentage = '0%';
    END IF;
END//    

DELIMITER;


--After Insert trigger is one that is executed afetr a new row has been successfully inserted
--First an audit table to log the enrollments
CREATE TABLE Enrol_log(
    Log_ID INT PRIMARY KEY AUTO_INCREMENT,
    User_ID INT NOT NULL,
    Course_ID VARCHAR(50) NOT NULL,
    Enrollment_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Action_Description VARCHAR(100)
)

DELIMITER//

---After trigger

CREATE TRIGGER After_Course_insert
AFTER INSERT ON COURSE
FOR EACH ROW
BEGIN
    INSERT INTO Enrol_log (Log_ID, User_ID, Course_ID, Enrollment_Time, Action_Description)
    VALUES (NEW.User_ID, NEW.Course_Name, 'INSERT');
END //

DELIMITER;

--Testing the before and after triggers
--Before trigger (Inserting a new progress record omitting Complete Percentage)
INSERT INTO PROGRESS (User_ID, Course_ID, Grade)--Using existing User_ID
VALUES (104, 'CS101', 'N/A');

--Verifying
SELECT Progress_ID, User_ID, Course_ID, Complete_Percentage, Grade
FROM PROGRESS
WHERE User_ID = 104 AND Course_ID = 'CS101';
select * from progress;
--After trigger 
INSERT INTO COURSE(Course_ID, Course_Name, Description, User_ID, Price)
VALUES ('AI401','Introduction to Computing', 'Fudamentals of Computing', 104, 129);

--Verifying the after trigger
SELECT Log_ID, User_ID, Course_ID, Enrollment_Time, Action_Description
FROM Enrol_log
WHERE Course_ID = 'AI401';

--Needs fixing 
SELECT User_ID FROM USER;



--------------------------------------------------------------------------------------------------------------

---Before Update trigger (To make sure the percentage is consistent)
--This trigger is used to make sure the progress does not decrease
DELIMITER//

CREATE TRIGGER BEF_PROGRESS_UPDATE
BEFORE UPDATE ON PROGRESS
FOR EACH ROW
BEGIN

    SET @old_percent = CAST(REPLACE(OLD.Complete_Percentage, '%', '') AS UNSIGNED);
    SET @new_percent = CAST(REPLACE(NEW.Complete_Percentage, '%', '') AS UNSIGNED);

    IF @new_percent < @old_percent THEN
        
        SET MESSAGE_TEXT = 'Course completion percentage cannot be reduced. Progress must move forward.';
    END IF;
    
    IF @new_percent > 100 THEN
        SET NEW.Complete_Percentage = '100%';
    END IF;
END //

DELIMITER ;

--After update trigger
--Logs any changes to the course table 
DELIMITER//

CREATE TRIGGER AFT_COURSE_UPDATE
AFTER UPDATE ON COURSE
FOR EACH ROW 
BEGIN
    DECLARE v_action_desc VARCHAR(100);

    SET v_action_desc = '';
    IF NEW.Price <> OLD.Price THEN
        SET v_action_desc = CONCAT(v_action_desc, 'Price changed from $', OLD.Price, ' to $', NEW.Price, '. ');
    END IF;

    -- Check for Description update
    IF NEW.Description <> OLD.Description THEN
        SET v_action_desc = CONCAT(v_action_desc, 'Description was modified.');
    END IF;

    -- Log the change if either the price or description was modified
    IF v_action_desc <> '' THEN
        -- Log the update using the course owner's User_ID
        INSERT INTO Enrol_log (User_ID, Course_ID, Action_Description)
        VALUES (NEW.User_ID, NEW.Course_ID, TRIM(v_action_desc));
    END IF;
END //

DELIMITER;


--------------------------------------------------------------------------------------------------------------------------------------------

--Before delete trigger
--Log table tostore deleted information
CREATE TABLE Course_Delete_Log (
    Log_ID INT AUTO_INCREMENT PRIMARY KEY,
    Course_ID VARCHAR(50),
    Course_Name VARCHAR(100),
    Deleted_By VARCHAR(100),
    Deletion_Time DATETIME
);

-- Prevent deleting a course if lessons still exist for it
DELIMITER //
CREATE TRIGGER before_course_delete
BEFORE DELETE ON COURSE
FOR EACH ROW
BEGIN
    DECLARE lesson_count INT;
    
    -- Check if the course has associated lessons
    SELECT COUNT(*) INTO lesson_count
    FROM LESSON
    WHERE Course_ID = OLD.Course_ID;
    
    -- If lessons exist, block deletion
    IF lesson_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete course with existing lessons.';
    END IF;
END;
//
DELIMITER ;

--After Delete trigger
DELIMITER //
CREATE TRIGGER after_course_delete
AFTER DELETE ON COURSE
FOR EACH ROW
BEGIN
    INSERT INTO Course_Delete_Log (Course_ID, Course_Name, Deleted_By, Deletion_Time)
    VALUES (OLD.Course_ID, OLD.Course_Name, USER(), NOW());
END;
//
DELIMITER;

--Testing the triggers
---It won't delete course with exiting lessons

INSERT INTO LESSON (Lesson_ID, Course_Name, Course_ID, Lesson_Name, Content_Type, Status)
VALUES ('L001', 'Intro to SQL', 'CS101', 'SQL Basics', 'Video','Active');

DELETE FROM COURSE WHERE Course_ID ='CS101';




--Other trigger types
--After Insert/Update-Makes data bend to a specific formatt before inserting and saving
--Before Insert/Update-Auto clcaulating derived data?
--More research to be made






