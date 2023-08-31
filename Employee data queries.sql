SELECT * from employee_data
SELECT * from employee_engagement_survey_data

-- Average Active Employee Rating
select 
	AVG(Current_Employee_Rating) as Average_Active_Employee_Rating
from employee_data

-- Average Engagement Score
select 
	AVG(Engagement_Score) as Average_Engagement_Score
from employee_engagement_survey_data

-- Average Satisaction Score
select 
	AVG(Satisfaction_Score) as Average_Satisaction_Score
from employee_engagement_survey_data

-- Average Work-Life Balance Score

select 
	AVG(Satisfaction_Score) as Average_work_life_balance_Score
from employee_engagement_survey_data

-- Total Employee by Department

SELECT 
	DepartmentType,
	count(DepartmentType) as Total_Employee
FROM employee_data
group by DepartmentType
order by count(DepartmentType) desc

-- Age distribution by department (AVG, MIN and MAX)

SELECT
	DepartmentType,
	avg(DATEDIFF(YY,DOB,GETDATE())) as age,
	min(DATEDIFF(YY,DOB,GETDATE())) as Min_Age,
	max(DATEDIFF(YY,DOB,GETDATE())) as Max_Age
from employee_data
group by DepartmentType

-- Years with company by Age

SELECT
	DISTINCT DATEDIFF(YY,DOB,GETDATE()) as age,
	AVG(DATEDIFF(YY,StartDate,GETDATE())) as Years_at_Company
from employee_data
group by DATEDIFF(YY,DOB,GETDATE())
ORDER BY DATEDIFF(YY,DOB,GETDATE()) asc

-- Calculate the Engagement Score % by Department type

SELECT 
	distinct a.DepartmentType,
	sum(b.Engagement_Score) as Total_Engagement,
	--(count(a.DepartmentType)/sum(b.Engagement_Score)) * 100 AS Percentage
	CAST(SUM(b.Engagement_Score) * 100.0 / (SELECT SUM(Engagement_Score) from employee_engagement_survey_data) AS DECIMAL(10,2)) AS percentage
FROM employee_data as a
full outer join employee_engagement_survey_data as b
on a.EmpID = b. Employee_ID
GROUP BY a.DepartmentType

-- Calculate the Satisfaction Score % by Department type

SELECT 
	distinct a.DepartmentType,
	sum(b.Satisfaction_Score) as Total_Satisfaction,
	--(count(a.DepartmentType)/sum(b.Engagement_Score)) * 100 AS Percentage
	CAST(SUM(b.Satisfaction_Score) * 100.0 / (SELECT SUM(Satisfaction_Score) from employee_engagement_survey_data) AS DECIMAL(10,2)) AS percentage
FROM employee_data as a
full outer join employee_engagement_survey_data as b
on a.EmpID = b. Employee_ID
GROUP BY a.DepartmentType

-- Calculate the Work-Life Balance Score % by Department type

SELECT 
	distinct a.DepartmentType,
	sum(b.Work_Life_Balance_Score) as Total_Work_Life_Balance_Score,
	--(count(a.DepartmentType)/sum(b.Engagement_Score)) * 100 AS Percentage
	CAST(SUM(b.Work_Life_Balance_Score) * 100.0 / (SELECT SUM(Work_Life_Balance_Score) from employee_engagement_survey_data) AS DECIMAL(10,2)) AS percentage
FROM employee_data as a
full outer join employee_engagement_survey_data as b
on a.EmpID = b. Employee_ID
GROUP BY a.DepartmentType

-- Current Active Male/Female Ratio

select
	distinct GenderCode, 
	count(GenderCode),
	CAST(count(GenderCode) * 100.0 / (SELECT count(GenderCode) from employee_data where EmployeeStatus = 'Active') AS DECIMAL(10,1)) AS percentage
from employee_data
where EmployeeStatus = 'Active'
group by GenderCode