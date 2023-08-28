CREATE DATABASE AcademyDb
USE AcademyDb

CREATE TABLE Groups
(
	Id int PRIMARY KEY IDENTITY,
	Name nvarchar(5) UNIQUE NOT NULL
)

CREATE TABLE Students
(
	Id int PRIMARY KEY IDENTITY,
	FirstName nvarchar(50) NOT NULL,
	LastName nvarchar(50),
	GroupId int FOREIGN KEY REFERENCES Groups(Id),
	Age tinyint CHECK(Age >= 15)
)

CREATE TABLE Subjects
(
	Id int PRIMARY KEY IDENTITY,
	Name nvarchar(50) UNIQUE NOT NULL
)

CREATE TABLE Exams
(
	Id int PRIMARY KEY IDENTITY,
	SubjectId int FOREIGN KEY REFERENCES Subjects(Id),
	StartTime smalldatetime NOT NULL,
	EndTime smalldatetime NOT NULL
)

CREATE TABLE StudentExams
(
	Id int PRIMARY KEY IDENTITY,
	StudentId int FOREIGN KEY REFERENCES Students(Id),
	ExamId int FOREIGN KEY REFERENCES Exams(Id),
	Point decimal(7,2) NOT NULL CHECK(Point >= 0 AND Point <= 100)
)

--1
SELECT s.Id, FirstName, LastName, Age, Name GroupNo
FROM Students s
JOIN Groups g ON GroupId = g.Id

--2
SELECT s.Id, FirstName, LastName, Age, COUNT(*) ExamsCount
FROM Students s
JOIN StudentExams ON s.Id = StudentId
GROUP BY s.Id, FirstName, LastName, Age

--3
SELECT s.Id, Name FROM Subjects s
LEFT JOIN Exams ON s.Id = SubjectId
WHERE SubjectId IS NULL

--4
SELECT e.Id, Name SubjectName, StartTime, EndTime, COUNT(*) StudentsCount
FROM Exams e LEFT
JOIN StudentExams ON e.Id = ExamId
JOIN Subjects s ON SubjectId = s.Id
WHERE DATEDIFF(DAY, StartTime, GETDATE()) = 1
GROUP BY e.Id, Name, StartTime, EndTime

--5
SELECT se.Id, ExamId, StudentId, (FirstName + ' ' + LastName) StudentFullName, Name GroupNo FROM StudentExams se
JOIN Students s ON se.StudentId = s.Id
JOIN Groups g ON GroupId = g.Id

--6
SELECT s.Id, FirstName, LastName, Age, AVG(Point) AverageScore
FROM Students s
JOIN StudentExams ON s.Id = StudentId
GROUP BY s.Id, FirstName, LastName, Age