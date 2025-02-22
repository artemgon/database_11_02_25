create database Academy;
go

use Academy;
go

create table Faculties
(
    FacultyID int identity(1,1) not null primary key,
    FacultyName nvarchar(100) not null check (LEN(TRIM(FacultyName)) > 0) unique
);
go

create table Departments
(
    DepartmentID int identity(1,1) not null primary key,
    DepartmentFinancing money not null check(DepartmentFinancing >= 0) default 0,
    DepartmentName nvarchar(100) not null check (LEN(TRIM(DepartmentName)) > 0) unique,
    FacultyID int not null foreign key references Faculties(FacultyID)
);
go

create table Teachers
(
    TeacherID int identity(1,1) not null primary key,
    TeacherName nvarchar(max) not null check (LEN(TRIM(TeacherName)) > 0),
    TeacherSalary money not null check(TeacherSalary > 0),
    TeacherSurname nvarchar(max) not null check (LEN(TRIM(TeacherSurname)) > 0),
    DepartmentID int not null foreign key references Departments(DepartmentID)
);
go

create table Subjects
(
    SubjectID int identity(1,1) not null primary key,
    SubjectName nvarchar(100) not null check (LEN(TRIM(SubjectName)) > 0) unique
);
go

create table Lectures
(
    LectureID int identity(1,1) not null primary key,
    LectureDayOfWeek int not null check(LectureDayOfWeek >= 1 and LectureDayOfWeek <= 7),
    LectureRoom nvarchar(max) not null check(LEN(TRIM(LectureRoom)) > 0),
    SubjectID int not null foreign key references Subjects(SubjectID),
    TeacherID int not null foreign key references Teachers(TeacherID)
);
go

create table Students
(
    StudentID int identity(1,1) not null primary key,
    StudentName nvarchar(max) not null check (LEN(TRIM(StudentName)) > 0),
    StudentSurname nvarchar(max) not null check (LEN(TRIM(StudentSurname)) > 0),
    StudentYear int not null check(StudentYear >= 1 and StudentYear <= 5)
);
go

create table Groups
(
    GroupID int identity(1,1) not null primary key,
    GroupName nvarchar(10) not null check (LEN(TRIM(GroupName)) > 0) unique,
    GroupYear int not null check(GroupYear >= 1 and GroupYear <= 5),
    DepartmentID int not null foreign key references Departments(DepartmentID),
    StudentID int not null foreign key references Students(StudentID)
);
go

create table GroupsLectures
(
    GroupLectureID int identity(1,1) not null primary key,
    GroupID int not null foreign key references Groups(GroupID),
    LectureID int not null foreign key references Lectures(LectureID)
);
go

INSERT INTO Faculties (FacultyName)
VALUES
    ('Computer Science'),
    ('Engineering'),
    ('Mathematics');

INSERT INTO Departments (DepartmentFinancing, DepartmentName, FacultyID)
VALUES
    (50000, 'Software Development', 1),
    (45000, 'Data Science', 1),
    (40000, 'Mechanical Engineering', 2),
    (30000, 'Pure Mathematics', 3);

INSERT INTO Teachers (TeacherName, TeacherSalary, TeacherSurname, DepartmentID)
VALUES
    ('Dave', 3000, 'McQueen', 1),
    ('Jack', 3500, 'Underhill', 2),
    ('Alice', 3200, 'Smith', 3),
    ('Bob', 3100, 'Johnson', 4);

INSERT INTO Subjects (SubjectName)
VALUES
    ('Database Systems'),
    ('Algorithms'),
    ('Mechanics'),
    ('Linear Algebra');

INSERT INTO Students (StudentName, StudentSurname, StudentYear)
VALUES
    ('John', 'Doe', 2),
    ('Jane', 'Smith', 3),
    ('Mike', 'Johnson', 1),
    ('Emily', 'Brown', 4);

INSERT INTO Groups (GroupName, GroupYear, DepartmentID, StudentID)
VALUES
    ('CS101', 2, 1, 1),
    ('DS201', 3, 2, 2),
    ('ME301', 1, 3, 3),
    ('MA401', 4, 4, 4);

INSERT INTO Lectures (LectureDayOfWeek, LectureRoom, SubjectID, TeacherID)
VALUES
    (1, 'D201', 1, 1),
    (2, 'D202', 2, 2),
    (3, 'D203', 3, 3),
    (4, 'D204', 4, 4);

INSERT INTO GroupsLectures (GroupID, LectureID)
VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4);

-- 1-st query--
select count(t.TeacherID) as TeachersCount
from Teachers t
inner join Departments d on t.DepartmentID = d.DepartmentID
where d.DepartmentName = 'Software Development';

-- 2-nd query--
select count(l.LectureID) as LecturesCount
from Lectures l
inner join Teachers T on l.TeacherID = T.TeacherID
where t.TeacherName = 'Dave' and t.TeacherSurname = 'McQueen';

-- 3-rd query--
select count(s.SubjectID) as SubjectsCount
from Subjects s
inner join Lectures l on s.SubjectID = l.SubjectID
where l.LectureRoom = 'D201';

-- 4-th query--
select LectureRoom, count(LectureID) as LecturesCount
from Lectures
group by LectureRoom;

-- 5-th query--
select count(distinct s.StudentID) as StudentsCount
from Lectures l
inner join Teachers t on l.TeacherID = t.TeacherID
inner join GroupsLectures gl on l.LectureID = gl.LectureID
inner join Groups g on gl.GroupID = g.GroupID
inner join Students s on g.GroupID = s.GroupID
where t.TeacherName = 'Jack' and t.TeacherSurname = 'Underhill';

-- 6-th query--
select avg(TeacherSalary) as AverageSalary
from Teachers
inner join Departments D on Teachers.DepartmentID = D.DepartmentID
inner join Faculties F on D.FacultyID = F.FacultyID
where F.FacultyName = 'Computer Science';

-- 7-th query--
select min(StudentCount) as MinStudents, max(StudentCount) as MaxStudents
from
(
    select count(s.StudentID) as StudentCount
    from Students s
    group by s.GroupID
)
as GroupStudentCounts;

-- 8-th query--
select avg(DepartmentFinancing) as AverageFinancing
from Departments;

-- 9-th query--
select t.TeacherName + ' ' + t.TeacherSurname as FullName, count(distinct l.SubjectID) as SubjectsCount
from Teachers t
inner join Lectures l on t.TeacherID = l.TeacherID
group by t.TeacherName, t.TeacherSurname;

-- 10-th query--
select LectureDayOfWeek, count(LectureID) as LecturesCount
from Lectures
group by LectureDayOfWeek
order by LectureDayOfWeek;

-- 11-th query--
select l.LectureRoom, count(distinct d.DepartmentID) as DepartmentsCount
from Lectures l
inner join Teachers t on l.TeacherID = t.TeacherID
inner join Departments d on t.DepartmentID = d.DepartmentID
group by l.LectureRoom;

-- 12-th query--
select f.FacultyName, count(distinct s.SubjectID) as SubjectsCount
from Faculties f
inner join Departments d on f.FacultyID = d.FacultyID
inner join Teachers t on d.DepartmentID = t.DepartmentID
inner join Lectures l on t.TeacherID = l.TeacherID
inner join Subjects s on l.SubjectID = s.SubjectID
group by f.FacultyName;

-- 13-th query--
select t.TeacherName + ' ' + t.TeacherSurname as TeacherFullName, l.LectureRoom, count(l.LectureID) as LecturesCount
from Lectures l
inner join Teachers t on l.TeacherID = t.TeacherID
group by t.TeacherName, t.TeacherSurname, l.LectureRoom;

drop database Academy;