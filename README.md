# Database_Programming
For the assignments on the online learning platform

##Source Code

create DATABASE Online_Learning;
use Online_Learning;

SELECT DATABASE();

CREATE TABLE  USER(User_ID INT PRIMARY KEY, Name VARCHAR(100), Email VARCHAR(50), Password VARCHAR(20), Role VARCHAR(50));
CREATE TABLE COURSE(Course_ID VARCHAR(50) PRIMARY KEY, Course_Name VARCHAR(40), Description VARCHAR(100), User_ID INT, Price INT,Foreign Key (User_ID) REFERENCES USER(User_ID))

CREATE TABLE LESSON(Lesson_ID VARCHAR(50) PRIMARY KEY, Course_Name VARCHAR(40), Course_ID VARCHAR(50), Lesson_Name VARCHAR(40), Content_Type VARCHAR(30), Status VARCHAR(50),Foreign Key (Course_ID) REFERENCES COURSE(Course_ID))

CREATE TABLE PROGRESS(Progress_ID VARCHAR(25) PRIMARY KEY, User_ID INT, Course_ID VARCHAR(50), Complete_Percentage VARCHAR(25), Grade VARCHAR(25),Foreign Key (Course_ID) REFERENCES COURSE(Course_ID),Foreign Key (User_ID) REFERENCES USER(User_ID))
