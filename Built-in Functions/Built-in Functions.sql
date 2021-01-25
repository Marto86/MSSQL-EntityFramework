USE SoftUni

SELECT FirstName , LastName FROM Employees

 WHERE FirstName LIKE 'SA%';


 SELECT FirstName , LastName FROM Employees

 WHERE LastName LIKE '%ei%';

 SELECT FirstName FROM Employees

 WHERE DepartmentID IN (3,10) AND YEAR(HireDate) BETWEEN 1995 AND 2005 

 
 SELECT FirstName , LastName FROM Employees

 WHERE JobTitle NOT LIKE '%engineer%'

SELECT Name  FROM Towns

WHERE LEN([Name]) IN (5,6)
ORDER BY [Name] ASC

SELECT [Name] FROM Towns
WHERE LEN([Name]) IN (5, 6)
ORDER BY [Name] ASC

SELECT TownID, [Name] FROM Towns

WHERE [Name] LIKE '[MKBE]%'
ORDER BY [Name] ASC

SELECT TownID, [Name] FROM Towns

WHERE [Name] LIKE '[^RBD]%'
ORDER BY [Name] ASC

CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName,LastName FROM Employees
WHERE YEAR(dbo.Employees.HireDate) > 2000 

SELECT  dbo.Employees.FirstName ,dbo.Employees.LastName FROM dbo.Employees 
WHERE LEN(dbo.Employees.LastName) IN (5)

SELECT EmployeeID , FirstName , LastName , Salary , DENSE_RANK() OVER(PARTITION BY Salary
ORDER BY EmployeeID) AS [Rank]
FROM Employees
WHERE Salary BETWEEN 10000 AND 50000
ORDER BY Salary DESC;


SELECT * FROM (
SELECT EmployeeID , FirstName , LastName , Salary , DENSE_RANK() OVER(PARTITION BY Salary
ORDER BY EmployeeID) AS [Rank]
FROM Employees
WHERE Salary BETWEEN 10000 AND 50000
) AS Result
WHERE [Rank] = 2
ORDER BY Salary DESC;

USE Geography

SELECT CountryName,IsoCode
FROM Countries
WHERE  CountryName LIKE ('%A%A%A%')
ORDER BY IsoCode

SELECT PeakName , RiverName ,
LOWER (LEFT(PeakName,LEN(Peakname)-1) + RiverName) AS Mix
FROM Peaks , Rivers
WHERE RIGHT(PeakName,1) = LEFT(RiverName,1)
ORDER BY Mix


USE Diablo

SELECT TOP(50) [Name] ,FORMAT ([Start] ,'yyyy-MM-dd' ) AS [Start]
FROM GAMES
WHERE DATEPART(YEAR,[Start]) BETWEEN 2011 AND 2012

ORDER BY [Start],[Name]

SELECT Username , SUBSTRING(Email,CHARINDEX ('@',Email)+1,LEN(Email)) AS EmailProvider
FROM Users
ORDER BY EmailProvider, UserName



SELECT Username,
       IpAddress
           AS [IP Address]
FROM Users
WHERE IpAddress LIKE '___.1_%._%.___'
ORDER BY Username



SELECT Name,
       CASE
           WHEN DATEPART(HOUR, Start) BETWEEN 0 AND 11 THEN 'Morning'
           WHEN DATEPART(HOUR, Start) BETWEEN 12 AND 17 THEN 'Afternoon'
           ELSE 'Evening'
           END AS [Part of the Day],
       CASE
           WHEN Duration <= 3 THEN 'Extra Short'
           WHEN Duration BETWEEN 4 AND 6 THEN 'Short'
           WHEN Duration > 6 THEN 'Long'
           ELSE 'Extra Long'
           END AS [Duration]
FROM Games AS g
ORDER BY Name, Duration


  
USE Orders

SELECT ProductName,
       OrderDate,
       DATEADD(DAY, 3, OrderDate)   AS [Pay Due],
       DATEADD(MONTH, 1, OrderDate) AS [Deliver Due]
FROM Orders

