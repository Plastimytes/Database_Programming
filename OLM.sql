--KENKYERENGYE SELLAH S25B13/040
--KENKYERENGYE SELLAH S25B1/040

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

--Left Outer
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
