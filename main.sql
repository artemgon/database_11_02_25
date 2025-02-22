CREATE DATABASE Hospital;
GO

USE Hospital;
GO

CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    DepartmentBuilding INT NOT NULL CHECK(DepartmentBuilding > 0 AND DepartmentBuilding < 6),
    DepartmentName NVARCHAR(100) NOT NULL CHECK(LEN(TRIM(DepartmentName)) > 0) UNIQUE
);
GO

CREATE TABLE Doctor (
    DoctorID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    DoctorName NVARCHAR(MAX) NOT NULL CHECK (LEN(TRIM(DoctorName)) > 0),
    DoctorPremium MONEY NOT NULL CHECK (DoctorPremium > 0) DEFAULT 0,
    DoctorSalary MONEY NOT NULL CHECK (DoctorSalary > 0),
    DoctorSurname NVARCHAR(MAX) NOT NULL CHECK (LEN(TRIM(DoctorSurname)) > 0)
);
GO

CREATE TABLE Examinations (
    ExaminationID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    ExaminationName NVARCHAR(100) NOT NULL CHECK (LEN(TRIM(ExaminationName)) > 0) UNIQUE
);
GO

CREATE TABLE Wards (
    WardID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    WardName NVARCHAR(20) NOT NULL CHECK (LEN(TRIM(WardName)) > 0) UNIQUE,
    WardPlaces INT NOT NULL CHECK (WardPlaces >= 1),
    DepartmentID INT NOT NULL FOREIGN KEY REFERENCES Departments(DepartmentID)
);
GO

CREATE TABLE DoctorExaminations (
    DoctorExaminationID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    DoctorExaminationEndTime TIME NOT NULL,
    DoctorExaminationStartTime TIME NOT NULL CHECK (DoctorExaminationStartTime > '08:00:00' AND DoctorExaminationStartTime < '18:00:00'),
    DoctorID INT NOT NULL FOREIGN KEY REFERENCES Doctor(DoctorID),
    ExaminationID INT NOT NULL FOREIGN KEY REFERENCES Examinations(ExaminationID),
    WardID INT NOT NULL FOREIGN KEY REFERENCES Wards(WardID)
);
GO

CREATE TRIGGER ValidateExaminationTime
ON DoctorExaminations
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE DoctorExaminationEndTime <= DoctorExaminationStartTime
    )
    BEGIN
        RAISERROR('DoctorExaminationEndTime must be greater than DoctorExaminationStartTime.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

INSERT INTO Departments (DepartmentBuilding, DepartmentName)
VALUES
(1, 'Cardiology'),
(2, 'Neurology'),
(3, 'Oncology'),
(4, 'Pediatrics'),
(5, 'Surgery'),
(6, 'Neurology'),
(7, 'Oncology'),
(8, 'Pediatrics');


INSERT INTO Doctor (DoctorName, DoctorPremium, DoctorSalary, DoctorSurname)
VALUES
('John', 1000, 5000, 'Doe'),
('Jane', 2000, 6000, 'Doe'),
('Jack', 3000, 7000, 'Doe'),
('Jill', 4000, 8000, 'Doe'),
('Jim', 5000, 9000, 'Doe');

INSERT INTO Examinations (ExaminationName)
VALUES
('Blood Test'),
('MRI'),
('X-Ray'),
('Ultrasound'),
('CT');

INSERT INTO Wards (WardName, WardPlaces, DepartmentID)
VALUES
('Ward1', 10, 1),
('Ward2', 20, 2),
('Ward3', 30, 3),
('Ward4', 40, 4),
('Ward5', 50, 5);

INSERT INTO DoctorExaminations (DoctorExaminationEndTime, DoctorExaminationStartTime, DoctorID, ExaminationID, WardID)
VALUES
('09:00:00', '08:30:00', 1, 1, 1),  -- Valid: Start time is 08:30:00
('10:00:00', '09:00:00', 2, 2, 2),  -- Valid: Start time is 09:00:00
('11:00:00', '10:00:00', 3, 3, 3),  -- Valid: Start time is 10:00:00
('12:00:00', '11:00:00', 4, 4, 4),  -- Valid: Start time is 11:00:00
('13:00:00', '12:00:00', 5, 5, 5);  -- Valid: Start time is 12:00:00

-- 1-st query --
SELECT COUNT(WardName) AS SpaciousWards
FROM Wards
WHERE WardPlaces > 10;

-- 2-nd query --
SELECT DepartmentBuilding, WardPlaces
FROM Wards
INNER JOIN Departments
ON Wards.DepartmentID = Departments.DepartmentID
WHERE WardPlaces > 10;

-- 3-rd query --
SELECT DepartmentName, WardPlaces
FROM Wards
INNER JOIN Departments
ON Wards.DepartmentID = Departments.DepartmentID
WHERE WardPlaces > 10;

-- 4-th query --
SELECT DepartmentName, SUM(DoctorPremium) AS TotalPremium
FROM Doctor
INNER JOIN Departments
ON Doctor.DoctorID = Departments.DepartmentID
GROUP BY DepartmentName;

-- 5-th --
SELECT d.DepartmentName
FROM Departments d
INNER JOIN Wards w ON d.DepartmentID = w.DepartmentID
INNER JOIN DoctorExaminations de ON w.WardID = de.WardID
GROUP BY d.DepartmentName
HAVING COUNT(DISTINCT de.DoctorID) >= 5;

-- 6-th query --
SELECT COUNT(DoctorName) AS DoctorsCount, SUM(DoctorSalary) + SUM(DoctorPremium) AS TotalCost
FROM Doctor;

-- 7-th query --
SELECT AVG(DoctorSalary + DoctorPremium) AS AverageCost
FROM Doctor;

-- 8-th query --
SELECT WardName, MIN(WardPlaces) AS MinPlaces
FROM Wards
GROUP BY WardName;

-- 9-th query --
SELECT DepartmentBuilding, SUM(WardPlaces) AS TotalPlaces
FROM Departments
INNER JOIN Wards W ON Departments.DepartmentID = W.DepartmentID
WHERE (DepartmentBuilding = 1 OR DepartmentBuilding = 6 OR DepartmentBuilding = 7 OR DepartmentBuilding = 8)
  AND WardPlaces > 10
GROUP BY DepartmentBuilding
HAVING SUM(WardPlaces) > 100;

DROP DATABASE Hospital;