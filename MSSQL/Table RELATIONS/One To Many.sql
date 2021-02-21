CREATE DATABASE TableOnetoMany
USE TableOnetoMany

CREATE TABLE Manufacturers(
ManufacturerID  INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(30) NOT NULL,
EstablishedOn DATETIME NOT NULL
)
CREATE TABLE Models(
ModelID INT PRIMARY KEY IDENTITY(101,1),
[Name] NVARCHAR(30) NOT NULL,
ManufacturerID INT FOREIGN KEY  REFERENCES  Manufacturers(ManufacturerID)
)
INSERT INTO Manufacturers([Name], EstablishedOn)
	VALUES	
		('BMW', '1916-07-03'),
		('Tesla', '2003-01-01'),
		('Lada', '1966-01-05');
INSERT INTO Models([Name], ManufacturerID)
	VALUES
		('X1', 1),
		('i6', 1),
		('Model S',2 ),
		('Model X', 2),
		('Model 3', 2),
		('Nova', 3);