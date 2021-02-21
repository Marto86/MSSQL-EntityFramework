
CREATE TABLE Users(
    Id BIGINT PRIMARY KEY IDENTITY NOT NULL ,
    Username VARCHAR(30) UNIQUE  NOT NULL ,
    [Password] VARCHAR(26) NOT NULL ,
    ProfilePicture VARBINARY(MAX)
    CHECK(DATALENGTH(ProfilePicture)<= 900 * 1024 ),
    LastLoginTime DATETIME2  NOT NULL ,
    IsDeleted BIT NOT NULL


)

INSERT INTO Users(Username, [Password],  LastLoginTime, IsDeleted)
   VALUES ('Martin','123456','01.13.2020',0),
       ('Vasil','123456','01.13.2020',1),
       ('Yoan','123456','01.13.2020',0),
       ('Krasimir','123456','01.13.2020',1),
       ('Denica','123456','01.13.2020',0)

	   SELECT * FROM Users;

	   TRUNCATE TABLE Users;

	   ALTER TABLE Users 
	   DROP CONSTRAINT [PK__Users__3214EC07656BA9F9]

	   ALTER TABLE Users
	   ADD CONSTRAINT PK_Users_CompositeIdUsername
	   PRIMARY KEY(Id,Username)

       ALTER TABLE Users
	   ADD CONSTRAINT CK_UsersPasweordLenght
	   CHECK(LEN([Password])>= 5)

	   ALTER TABLE Users
	   ADD CONSTRAINT DF_LastLoginTimeDefault
	   DEFAULT GETDATE() FOR  LastLoginTime

	    ALTER TABLE Users 
	   DROP CONSTRAINT PK_Users_CompositeIdUsername

	   ALTER TABLE Users
	    ADD CONSTRAINT PK_Users_Id
		PRIMARY KEY (Id)

		 ALTER TABLE Users
		 ADD CONSTRAINT CK_UserNamelenght
		 CHECK(LEN(Username)>=3)

		 CREATE DATABASE SoftUni

		 USE SoftUni

		 CREATE TABLE Towns (
		 Id INT PRIMARY KEY IDENTITY,
		 [Name] NVARCHAR(50) NOT NULL
		 )

		 CREATE TABLE Addresses(
		 Id INT PRIMARY KEY IDENTITY,
		 AddressText NVARCHAR(100) NOT NULL,
		 TownId INT FOREIGN KEY REFERENCES Towns(Id) NOT NULL,

		 )
		 CREATE TABLE Departments(
		 Id INT PRIMARY KEY IDENTITY,
		 [Name] NVARCHAR(50) NOT NULL
		 )
		 
		 CREATE TABLE  Employees(
		 Id INT PRIMARY KEY IDENTITY,
		 FirstName NVARCHAR(20) NOT NULL,
		 MidleName NVARCHAR(20),
		 LastName NVARCHAR(20) NOT NULL,
		 JobTitle NVARCHAR(20) NOT NULL,
		 DepartmentId INT FOREIGN KEY REFERENCES Departments(Id) NOT NULL,
		 HireDate DATE NOT NULL,
		 Salary DECIMAL(7,2)NOT NULL,
		 AdressId INT FOREIGN KEY REFERENCES Addresses(Id),

		 )

		 INSERT INTO Towns([Name])
		 VALUES 
		 ('Sofia'),
		 ('Ploviv'),
		 ('Varna'),
		 ('Burgas')

		 INSERT INTO Departments([Name])
		  VALUES 
		 ('Engineering'),
		 ('Quality Assurance'),
		 ('Software Development'),
		 ('Marketing'),
		 ('Sales')

		 INSERT INTO Employees(FirstName,MidleName,LastName,JobTitle,DepartmentId,HireDate,Salary)
		 VALUES 
		 ('Ivan','Ivanov','Ivanov','.NET Developer',9,'02/01/2013',3500.00),
		 ('Petar','Petrov','Petrov','Senior Engineer',7,'03/02/2004',4000.00),
		 ('Maria','Petrova','Ivanova','Intern',8,'08/28/2016',525.25),
		 ('Georgi','Terziev','Ivanov','CEO',11,'12/09/2007',3000.00),
		 ('Peter','Pan','Pan','Intern',10,'08/28/2016',599.88)

	SELECT [Name] FROM  Towns 
	ORDER BY [Name] ASC
	SELECT [Name] FROM  Departments
	ORDER BY [Name] ASC
	SELECT FirstName,LastName,JobTitle,Salary FROM  Employees 
	ORDER BY Salary DESC

	UPDATE Employees 
	SET Salary += Salary * 0.1
	SELECT Salary FROM Employees