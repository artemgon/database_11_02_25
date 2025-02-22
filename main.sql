create database Academy;
go

use Academy;
go

create table Curators
(
    CuratorID int identity(1,1) not null primary key,
    CuratorName nvarchar(max) not null check (LEN(TRIM(CuratorName)) > 0),
    CuratorSurname nvarchar(max) not null check (LEN(TRIM(CuratorSurname)) > 0),
)
go

create table Departments
(
    DepartmentID int identity(1,1) not null primary key,
    DepartmentBuilding int not null check (DepartmentBuilding >= 1 and DepartmentBuilding <= 5),
    DepartmentFinancing money not null check (DepartmentFinancing >= 0) default 0,
    DepartmentName nvarchar(100) not null check (LEN(TRIM(DepartmentName)) > 0) unique,
    FacultyID int not null foreign key references Faculties(FacultyID)
)
go

create table Faculties
(
    FacultyID int identity(1,1) not null primary key,
    FacultyName nvarchar(100) not null check (LEN(TRIM(FacultyName)) > 0) unique
)
go

create table Groups
(
    GroupID int identity(1,1) not null primary key,
    GroupName nvarchar(10) not null check (LEN(TRIM(GroupName)) > 0) unique,
    GroupYear int not null check (GroupYear >= 1 and GroupYear <= 5),
    DepartmentID int not null foreign key references Departments(DepartmentID)
)
go

create table GroupCurators
(
    GroupCuratorID int identity(1,1) not null primary key,
    CuratorID int not null foreign key references Curators(CuratorID),
    GroupID int not null foreign key references Groups(GroupID)
)
go

create table GroupsLectures
(
    GroupLectureID int identity(1,1) not null primary key,
    GroupID int not null foreign key references Groups(GroupID),
    LectureID int not null foreign key references Lectures(LectureID)
)
go

create table GroupStudents
(
    GroupStudentID int identity (1,1) not null primary key,
    GroupID int not null foreign key references Groups(GroupID),
    StudentID int not null foreign key references Students(StudentID)
)
go

create table Lectures
(
    LectureID int identity(1,1) not null primary key,
    LectureDate date not null check (LectureDate <= GETDATE()),
    LectureSubjectID int not null foreign key references Subjects(SubjectID),
    TeacherID int not null foreign key references Teachers(TeacherID)
)
go

create table Students
(
    StudentID int identity(1,1) not null primary key,
    StudentName nvarchar(max) not null check (LEN(TRIM(StudentName)) > 0),
    StudentRating int not null check (StudentRating >= 0 and StudentRating <= 5),
    StudentSurname nvarchar(max) not null check (LEN(TRIM(StudentSurname)) > 0)
)
go

create table Subjects
(
    SubjectID int identity(1,1) not null primary key,
    SubjectName nvarchar(100) not null check (LEN(TRIM(SubjectName)) > 0) unique
)
go

create table Teachers
(
    TeacherID int identity(1,1) not null primary key,
    IsProfessor bit not null default 0,
    TeacherName nvarchar(max) not null check (LEN(TRIM(TeacherName)) > 0),
    TeacherSalary money not null check (TeacherSalary > 0),
    TeacherSurname nvarchar(max) not null check (LEN(TRIM(TeacherSurname)) > 0)
)