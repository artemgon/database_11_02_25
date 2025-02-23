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
    DepartmentBuilding int not null check (DepartmentBuilding >= 1 and DepartmentBuilding <= 5),
    DepartmentFinancing money not null check (DepartmentFinancing >= 0) default 0,
    DepartmentName nvarchar(100) not null check (LEN(TRIM(DepartmentName)) > 0) unique,
    FacultyID int not null foreign key references Faculties(FacultyID)
);
go

create table Curators
(
    CuratorID int identity(1,1) not null primary key,
    CuratorName nvarchar(max) not null check (LEN(TRIM(CuratorName)) > 0),
    CuratorSurname nvarchar(max) not null check (LEN(TRIM(CuratorSurname)) > 0)
);
go

create table Groups
(
    GroupID int identity(1,1) not null primary key,
    GroupName nvarchar(10) not null check (LEN(TRIM(GroupName)) > 0) unique,
    GroupYear int not null check (GroupYear >= 1 and GroupYear <= 5),
    DepartmentID int not null foreign key references Departments(DepartmentID)
);
go

create table Students
(
    StudentID int identity(1,1) not null primary key,
    StudentName nvarchar(max) not null check (LEN(TRIM(StudentName)) > 0),
    StudentRating int not null check (StudentRating >= 0 and StudentRating <= 5),
    StudentSurname nvarchar(max) not null check (LEN(TRIM(StudentSurname)) > 0)
);
go

create table GroupStudents
(
    GroupStudentID int identity (1,1) not null primary key,
    GroupID int not null foreign key references Groups(GroupID),
    StudentID int not null foreign key references Students(StudentID)
);
go

create table Subjects
(
    SubjectID int identity(1,1) not null primary key,
    SubjectName nvarchar(100) not null check (LEN(TRIM(SubjectName)) > 0) unique
);
go

create table Teachers
(
    TeacherID int identity(1,1) not null primary key,
    IsProfessor bit not null default 0,
    TeacherName nvarchar(max) not null check (LEN(TRIM(TeacherName)) > 0),
    TeacherSalary money not null check (TeacherSalary > 0),
    TeacherSurname nvarchar(max) not null check (LEN(TRIM(TeacherSurname)) > 0)
);
go

create table Lectures
(
    LectureID int identity(1,1) not null primary key,
    LectureDate date not null check (LectureDate <= GETDATE()),
    LectureDayOfWeek int not null check (LectureDayOfWeek >= 1 and LectureDayOfWeek <= 7),
    LectureRoom nvarchar(max) not null check (LEN(TRIM(LectureRoom)) > 0),
    TeacherID int not null foreign key references Teachers(TeacherID),
    SubjectID int not null foreign key references Subjects(SubjectID)
);
go

create table GroupsLectures
(
    GroupLectureID int identity(1,1) not null primary key,
    GroupID int not null foreign key references Groups(GroupID),
    LectureID int not null foreign key references Lectures(LectureID)
);
go

create table GroupCurators
(
    GroupCuratorID int identity(1,1) not null primary key,
    CuratorID int not null foreign key references Curators(CuratorID),
    GroupID int not null foreign key references Groups(GroupID)
);
go

insert into Faculties (FacultyName)
values
('Computer Science'),
('Software Development'),
('Information Technology'),
('Cybersecurity'),
('Data Science');

insert into Departments (DepartmentBuilding, DepartmentFinancing, DepartmentName, FacultyID)
values
(1, 1000000, 'Computer Science', 1),
(2, 2000000, 'Software Development', 2),
(3, 3000000, 'Information Technology', 3),
(4, 4000000, 'Cybersecurity', 4),
(5, 5000000, 'Data Science', 5);

insert into Groups (GroupName, GroupYear, DepartmentID)
values
('CS-1', 1, 1),
('CS-2', 2, 1),
('SD-1', 1, 2),
('SD-2', 2, 2),
('IT-1', 1, 3),
('IT-2', 2, 3),
('CS-3', 3, 1),
('CS-4', 4, 1),
('CS-5', 5, 1);

insert into Curators (CuratorName, CuratorSurname)
values
('John', 'Doe'),
('Jane', 'Doe'),
('Jack', 'Underhill'),
('Dave', 'McQueen'),
('Alice', 'Smith');

insert into GroupCurators (CuratorID, GroupID)
values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

insert into Students (StudentName, StudentRating, StudentSurname)
values
('John', 5, 'Doe'),
('Jane', 4, 'Doe'),
('Jack', 3, 'Underhill'),
('Dave', 2, 'McQueen'),
('Alice', 1, 'Smith');

insert into GroupStudents (GroupID, StudentID)
values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

insert into Subjects (SubjectName)
values
('Math'),
('Physics'),
('Chemistry'),
('Biology'),
('History');

insert into Teachers (IsProfessor, TeacherName, TeacherSalary, TeacherSurname)
values
(1, 'John', 1000, 'Doe'),
(0, 'Jane', 2000, 'Doe'),
(1, 'Jack', 3000, 'Underhill'),
(0, 'Dave', 4000, 'McQueen'),
(1, 'Alice', 5000, 'Smith');

insert into Lectures (LectureDate, LectureDayOfWeek, LectureRoom, TeacherID, SubjectID)
values
('2021-01-01', 1, 'A101', 1, 1),
('2021-01-02', 2, 'B102', 2, 2),
('2021-01-03', 3, 'C103', 3, 3),
('2021-01-04', 4, 'D104', 4, 4),
('2021-01-05', 5, 'E105', 5, 5);

-- 1-st query--
select count(TeacherID) as TeachersCount
from Teachers
inner join Departments on Teachers.TeacherID = Departments.DepartmentID
where DepartmentName = 'Software Development';

-- 2-nd query--
select count(LectureID) as LecturesCount
from Lectures
inner join Teachers T on Lectures.TeacherID = T.TeacherID
where TeacherName = 'Dave' and TeacherSurname = 'McQueen';

-- 3-rd query--
select count(L.SubjectID) as SubjectsCount
from Subjects S
inner join Lectures L on S.SubjectID = L.SubjectID
where L.LectureRoom = 'D201';

-- 4-th query--
select LectureRoom, count(LectureID) as LecturesCount
from Lectures
group by LectureRoom

-- 5-th query--
select count(distinct s.StudentID) as StudentsCount
from Lectures l
inner join Teachers t on l.TeacherID = t.TeacherID
inner join GroupsLectures gl on l.LectureID = gl.LectureID
inner join Groups g on gl.GroupID = g.GroupID
inner join GroupStudents gs on g.GroupID = gs.GroupID
inner join Students s on gs.StudentID = s.StudentID
where t.TeacherName = 'Jack' and t.TeacherSurname = 'Underhill';

-- 6-th query--
select avg(TeacherSalary) as AverageSalary
from Teachers
inner join Lectures L on Teachers.TeacherID = L.TeacherID
inner join GroupsLectures GL on L.LectureID = GL.LectureID
join Groups G on GL.GroupID = G.GroupID
inner join Departments D on D.DepartmentID = G.DepartmentID
where DepartmentName = 'Computer Science';

-- 7-th query--
select min(StudentCount) as MinStudents, max(StudentCount) as MaxStudents
from (
    select count(distinct gs.StudentID) as StudentCount
    from Groups g
    inner join GroupStudents gs on g.GroupID = gs.GroupID
    group by g.GroupID
) as GroupStudentCounts;

-- 8-th query--
select avg(DepartmentFinancing) as AverageFinancing
from Departments

-- 9-th query--
select t.TeacherName + ' ' + t.TeacherSurname as FullName, count(distinct l.SubjectID) as SubjectsCount
from Teachers t
inner join Lectures l on t.TeacherID = l.TeacherID
group by t.TeacherName, t.TeacherSurname;

-- 10-th query--
select count(LectureID) as LecturesCount
from Lectures
group by LectureDayOfWeek
order by LectureDayOfWeek;

-- 11-th query--
select LectureRoom, count(distinct d.DepartmentID) as DepartmentsCount
from Lectures l
inner join GroupsLectures gl on l.LectureID = gl.LectureID
inner join Groups g on gl.GroupID = g.GroupID
inner join Departments d on g.DepartmentID = d.DepartmentID
group by LectureRoom;

-- 12-th query--
select FacultyName, count(S.SubjectID) as SubjectsCount
from Faculties F
inner join Departments D on F.FacultyID = D.FacultyID
inner join Groups G on D.DepartmentID = G.DepartmentID
inner join GroupsLectures GL on G.GroupID = GL.GroupID
inner join Lectures L on GL.LectureID = L.LectureID
inner join Subjects S on L.SubjectID = S.SubjectID
group by FacultyName;

-- 13-th query--
select 'Quantity of lectures: ' + cast(count(L.LectureID) as nvarchar) as LecturesCount,
       'Teacher: ' + T.TeacherName + ' ' + T.TeacherSurname as TeacherFullName,
       'Classroom: ' + L.LectureRoom as Classroom
from Lectures L
inner join Teachers T on L.TeacherID = T.TeacherID
group by L.LectureRoom, T.TeacherName, T.TeacherSurname;

drop database Academy;