CREATE DATABASE UniversityDatabase
USE UniversityDatabase

CREATE TABLE Majors(
MajorID INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(30) NOT NULL
)

CREATE TABLE Students(
StudentID INT PRIMARY KEY IDENTITY,
StudentNumber INT NOT NULL,
StudentName NVARCHAR(30) NOT NULL ,
MajorID INT FOREIGN KEY REFERENCES Majors(MajorID) NOT NULL
)
CREATE TABLE Payments(
PaymentID INT PRIMARY KEY IDENTITY ,
PaymentDate DATE NOT NULL,
PaymentAmount DECIMAL (6,2),
StudentID INT FOREIGN KEY REFERENCES Students(StudentID)
)
CREATE TABLE Subjects(
SubjectID INT PRIMARY KEY IDENTITY ,
SubjectName NVARCHAR(30) NOT NULL
)
CREATE TABLE Agenda (
StudentID INT NOT NULL FOREIGN KEY REFERENCES Students (StudentID),
SubjectID INT NOT NULL FOREIGN KEY REFERENCES Subjects (SubjectID),
PRIMARY KEY (StudentID, SubjectID)
)

