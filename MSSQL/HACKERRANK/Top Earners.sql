DECLARE @MAXTOTALSALARY INT=(SELECT MAX(MONTHS*SALARY)
FROM EMPLOYEE)
DECLARE @COUNTEMPLOYEESWITHMAXSALARY INT=(SELECT COUNT(*) FROM EMPLOYEE WHERE @MAXTOTALSALARY=(MONTHS*SALARY))
DECLARE @OUTPUT NVARCHAR(50)= CONCAT(@MAXTOTALSALARY,' ',@COUNTEMPLOYEESWITHMAXSALARY)
SELECT @OUTPUT