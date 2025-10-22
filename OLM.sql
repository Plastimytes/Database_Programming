create DATABASE Online_Learning;
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