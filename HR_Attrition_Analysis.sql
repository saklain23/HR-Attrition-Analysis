--Create DATABASE
CREATE DATABASE IF NOT EXISTS HR_Analytics;

-- ============================================
-- Table 1: Employee_JobDetails
-- ============================================
DROP TABLE IF EXISTS Employee_JobDetails;

CREATE TABLE Employee_JobDetails (
    EmployeeNumber          INT PRIMARY KEY,
    Age                     INT,
    Gender                  VARCHAR(10),
    MaritalStatus           VARCHAR(20),
    Attrition               BOOLEAN,
    Department              VARCHAR(50),
    EducationField          VARCHAR(100),
    Education               INT,
    DistanceFromHome        INT,
    BusinessTravel          VARCHAR(50),
    Over18                  VARCHAR(5),
    EmployeeCount           INT,
    TotalWorkingYears       INT,             
    YearsAtCompany          INT,            
    YearsInCurrentRole      INT,
    YearsSinceLastPromotion INT,
    YearsWithCurrManager    INT,
    Tenure_Band             VARCHAR(20),
    NumCompaniesWorked      INT
);

-- ============================================
-- Table 2: Employee_Compensation
-- ============================================
DROP TABLE IF EXISTS Employee_Compensation;

CREATE TABLE Employee_Compensation (
    EmployeeNumber          INT PRIMARY KEY,
    JobRole                 VARCHAR(100),
    JobLevel                INT,
    OverTime                BOOLEAN,
    DailyRate               INT,
    HourlyRate              INT,
    MonthlyRate             NUMERIC(10,2),
    MonthlyIncome           NUMERIC(10,2),
    PercentSalaryHike       INT,
    StandardHours           INT,
    StockOptionLevel        INT,
    TrainingTimesLastYear   INT
);

-- ============================================
-- Table 3: Employee_Satisfaction
-- ============================================
DROP TABLE IF EXISTS Employee_Satisfaction;

CREATE TABLE Employee_Satisfaction (
    EmployeeNumber          INT PRIMARY KEY,
    EnvironmentSatisfaction INT,
    JobInvolvement          INT,
    JobSatisfaction         INT,
    PerformanceRating       INT,
    RelationshipSatisfaction INT,
    WorkLifeBalance         INT
);


COPY Employee_JobDetails (EmployeeNumber, Age, Gender, MaritalStatus, Attrition, Department, EducationField, Education, DistanceFromHome, BusinessTravel, Over18, EmployeeCount, TotalWorkingYears, YearsAtCompany, YearsInCurrentRole, YearsSinceLastPromotion, YearsWithCurrManager, Tenure_Band, NumCompaniesWorked)
FROM 'HR-Project\HR_Attrition_Source1.csv'
DELIMITER ','
CSV HEADER;

COPY Employee_Compensation(EmployeeNumber, JobRole, JobLevel, OverTime, DailyRate, HourlyRate, MonthlyRate, MonthlyIncome, PercentSalaryHike, StandardHours, StockOptionLevel, TrainingTimesLastYear)
FROM 'HR-Project\HR_Attrition_Source2.csv'
DELIMITER ','
CSV HEADER;

COPY Employee_Satisfaction (EmployeeNumber, EnvironmentSatisfaction, JobInvolvement, JobSatisfaction, PerformanceRating, RelationshipSatisfaction, WorkLifeBalance)
FROM 'HR-Project\HR_Attrition_Source3.csv'
DELIMITER ','
CSV HEADER;


SELECT * FROM Employee_JobDetails;
SELECT * FROM Employee_Compensation;
SELECT * FROM Employee_Satisfaction;

SELECT COUNT(*) FROM employee_jobdetails;
SELECT COUNT(*) FROM employee_compensation;
SELECT COUNT(*) FROM employee_satisfaction;

SELECT attrition, COUNT(*) AS attrition
FROM employee_jobdetails
GROUP BY attrition;


-- How many total employees are there?
SELECT COUNT(*) AS total_employees
FROM employee_jobdetails;


-- How many employees have left the company?
SELECT COUNT(*) AS left_employees
FROM employee_jobdetails
WHERE attrition = 'true';


-- What is the overall attrition rate?
SELECT COUNT(*) AS total,
SUM(CASE WHEN attrition = true THEN 1 ELSE 0 END) AS left_count,
ROUND(100.0 * SUM(CASE WHEN attrition = true THEN 1 ELSE 0 END) / COUNT(*),2) AS attrition_rate
FROM employee_jobdetails;

-- Which department has the highest attrition?
SELECT department,
COUNT(*) AS total,
SUM(CASE WHEN attrition = true THEN 1 ELSE 0 END) AS left_count,
ROUND(100.0 * SUM(CASE WHEN attrition = true THEN 1 ELSE 0 END) / COUNT(*),2) AS attrition_rate
FROM employee_jobdetails
GROUP BY department
ORDER BY attrition_rate DESC LIMIT 1;


-- Is attrition different for male vs female?
SELECT gender, 
COUNT(*) AS total,
SUM(CASE WHEN attrition = true THEN 1 ELSE 0 END) AS left_count,
ROUND(100.0 * SUM(CASE WHEN attrition = true THEN 1 ELSE 0 END) / COUNT(*),2) AS attrition_rate
FROM employee_jobdetails
GROUP BY gender
ORDER BY attrition_rate DESC;

-- Do employees who work overtime leave more?
SELECT ec.overtime, COUNT(*) AS total,
SUM(CASE WHEN ej.attrition = true THEN 1 ELSE 0 END) AS left_count,
ROUND(100.0 * SUM(CASE WHEN ej.attrition = true THEN 1 ELSE 0 END) / COUNT(*),2) AS attrition_rate
FROM employee_jobdetails ej
JOIN employee_compensation ec ON ej.employeenumber = ec.employeenumber
GROUP BY ec.overtime
ORDER BY attrition_rate DESC;


-- Do low-salary employees leave more? 
WITH employee_salary AS (
     SELECT 
     CASE
		WHEN ec.monthlyincome < 3000 THEN 'low 3k'
		WHEN ec.monthlyincome BETWEEN 3000 AND 7000 THEN 'medium (3k_7k)'
		WHEN ec.monthlyincome BETWEEN 7001 AND 12000 THEN 'high (7K_12000k)'
		ELSE 'very high (>12k)'
		END AS salary_band,
		COUNT(*) AS total,
		SUM(CASE WHEN ej.attrition = true THEN 1 ELSE 0 END) AS left_count,
		ROUND(100.0 * SUM(CASE WHEN ej.attrition = true THEN 1 ELSE 0 END)/ COUNT(*),2) AS attrition_rate
		FROM employee_jobdetails ej
		JOIN employee_compensation ec ON ej.employeenumber = ec.employeenumber
		GROUP BY salary_band
	 )
	 SELECT *
	 FROM employee_salary
	 ORDER BY attrition_rate DESC;
	 /* ============================================
   INSIGHT:
   • Low salary (<3K) has the highest attrition (28.61%)
   • Very high salary (>12K) has the lowest attrition (5.64%)
   • Low salary employees are 5x more likely to leave
   • Action: Salary revision for low band, especially entry-level
   ============================================ */

-- Do employees with low job satisfaction leave more?
 WITH employee_jobs AS (
      SELECT 
      CASE
		 WHEN es.jobsatisfaction = 1 THEN 'Low (1)'
	     WHEN es.jobsatisfaction = 2 THEN 'Medium(2)'
		 WHEN es.jobsatisfaction = 3 THEN 'High(3)'
		 WHEN es.jobsatisfaction = 4 THEN 'Very High(4)'
		 END AS satisfaction_level,
		 COUNT(*) AS total,
		 SUM(CASE WHEN ej.attrition = true THEN 1 ELSE 0 END) AS left_count,
		 ROUND(100.0 * SUM(CASE WHEN ej.attrition = true THEN 1 ELSE 0 END)/COUNT(*),2) AS attrition_rate
		 FROM employee_jobdetails ej
		 JOIN employee_satisfaction es ON ej.employeenumber = es.employeenumber
		 GROUP BY satisfaction_level
	)
	SELECT *
	FROM employee_jobs
	ORDER BY satisfaction_level;

	/* ============================================
   INSIGHT:
   • Low job satisfaction (1) has highest attrition (22.84%)
   • Very High satisfaction (4) has lowest attrition (11.33%)
   • Low satisfaction employees are 2x more likely to leave
   • Action: Regular satisfaction surveys, address grievances, 
     improve engagement programs
   ============================================ */

-- Do employees with poor work-life balance leave more? 
SELECT
      CASE
	  WHEN es.worklifebalance = 1 THEN 'Low(1)'
	  WHEN es.worklifebalance = 2 THEN 'Medium(2)'
	  WHEN es.worklifebalance = 3 THEN 'high(3)'
	  WHEN es.worklifebalance = 4 THEN 'Very High(4)'
	  END AS worklifebalance_level,
	  COUNT(*) AS total,
	  SUM(CASE WHEN ej.attrition = true THEN 1 ELSE 0 END) AS left_count,
	  ROUND(100.0 * SUM(CASE WHEN ej.attrition = true THEN 1 ELSE 0 END)/ COUNT(*),2) AS attrition_rate
	  FROM employee_satisfaction es
	  JOIN employee_jobdetails ej ON es.employeenumber = ej.employeenumber
	  GROUP BY worklifebalance_level
	  ORDER BY worklifebalance_level;
	  
-- Who are the top 10 highest paid employees? — Top	  
SELECT ec.employeenumber,
       ec.jobrole,
	   ec.monthlyincome,
       ej.department,
	   ej.yearsatcompany,
	   ej.educationfield
	   FROM employee_compensation ec
	   JOIN employee_jobdetails ej ON ec.employeenumber = ej.employeenumber
	   ORDER BY monthlyincome DESC LIMIT 10;

-- What is the average age of employees who left vs stayed?
SELECT attrition,
COUNT(*) AS total,
ROUND(AVG(age),2) AS avg_age
FROM employee_jobdetails
GROUP BY attrition;

-- What is the average tenure of employees who left?
SELECT 
ROUND(AVG(yearsatcompany),2) AS avg_tenure
FROM employee_jobdetails
WHERE attrition = true;

-- Which job role has the highest attrition? 
SELECT ec.jobrole,
COUNT(*) AS total,
SUM(CASE WHEN ej.attrition = true THEN 1 ELSE 0 END) AS left_count,
ROUND(100.0 * SUM(CASE WHEN ej.attrition = true THEN 1 ELSE 0 END)/ COUNT(*),2) AS attrition_rate
FROM employee_compensation ec 
JOIN employee_jobdetails ej ON ec.employeenumber = ej.employeenumber
GROUP BY ec.jobrole
ORDER BY attrition_rate DESC;


-- Which education field has the highest attrition?
SELECT educationfield,
COUNT(*) AS total,
SUM(CASE WHEN attrition = true THEN 1 ELSE 0 END) AS left_count,
ROUND(100.0 * SUM(CASE WHEN attrition = true THEN 1 ELSE 0 END)/ COUNT(*),2) AS attrition_rate
FROM employee_jobdetails
GROUP BY educationfield
ORDER BY attrition_rate DESC;


-- Which employees are most likely to leave based on satisfaction, work-life balance, and tenure?

SELECT ej.employeenumber,
       ej.department,
	   ec.jobrole,
	   es.jobsatisfaction,
	   es.worklifebalance,
	   ej.yearsatcompany,
	   ej.yearssincelastpromotion,
	   ec.overtime,
	   (
	   CASE WHEN es.jobsatisfaction <=2 THEN 30 ELSE 0 END +
	   CASE WHEN es.worklifebalance <= 2 THEN 25 ELSE 0 END +
	   CASE WHEN ej.yearsatcompany <= 2 THEN 20 ELSE 0 END +
	   CASE WHEN ej.yearssincelastpromotion >=3 THEN 15 ELSE 0 END+
	   CASE WHEN ec.overtime = true THEN 10 ELSE 0 END
	   )AS risk_score
       FROM employee_jobdetails ej
	   JOIN employee_compensation ec ON ej.employeenumber = ec.employeenumber
	   JOIN employee_satisfaction es ON ec.employeenumber = es.employeenumber
	   WHERE ej.attrition = false
	   ORDER BY risk_score DESC LIMIT 20;
	   
/* ============================================
   INSIGHT:
   • 20 high-risk employees identified
   • 65% from Product & Engineering
   • Key drivers: low job satisfaction (<=2), 
     poor work-life balance (<=2), overtime, 
     short tenure (<=2 years)
   • Top 4 employees: risk score 85 — immediate HR action
   ============================================ */	   

	   
 -- What is the average salary by department?
WITH average_salary AS (
    SELECT 
        ej.Department,
        COUNT(*) AS total,
        ROUND(AVG(ec.MonthlyIncome), 2) AS avg_salary
    FROM employee_jobdetails ej
    JOIN employee_compensation ec ON ej.EmployeeNumber = ec.EmployeeNumber
    GROUP BY ej.Department
)
SELECT * 
FROM average_salary
ORDER BY avg_salary DESC;

/* ============================================
   INSIGHT:
   • Business Development has highest avg salary ($6,959.17)
   • Product & Engineering has lowest avg salary ($6,281.25)
   • Salary gap between highest and lowest: ~$678
   • Action: Review salary band for Product & Engineering
   ============================================ */
 
 -- What is the promotion gap by department?
 WITH promotion_gap AS (
      SELECT department,
	  COUNT(*) AS total,
	  ROUND(AVG(yearssincelastpromotion),2) AS avg_gap,
	  MAX(yearssincelastpromotion) AS max_promotion_gap
	  FROM employee_jobdetails
	  GROUP BY department
	  )
SELECT * FROM promotion_gap
ORDER BY avg_gap DESC, max_promotion_gap DESC;

/* ============================================
   INSIGHT:
   • Business Development has highest avg promotion gap (2.35 years)
   • Both Business Development & Product & Engineering have 
     employees stuck for 15 years without promotion
   • People Operations has lowest gap (1.78 years)
   • Action: Immediate promotion review for 15-year stuck employees
     in BD and Product & Engineering
   ============================================ */


-- What is the gender distribution by department?
WITH gender_ratio AS (
    SELECT 
        department,
        gender,
        COUNT(*) AS total,
        ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY department), 2) AS percentage
    FROM employee_jobdetails
    GROUP BY department, gender
)
SELECT * 
FROM gender_ratio
ORDER BY department, gender;

/* ============================================
   INSIGHT:
   • All departments have more male than female employees
   • People Operations has the highest gender gap (68.25% male)
   • Business Development has the most balanced ratio (57.62% male)
   • Action: Diversity hiring initiative for People Operations
   ============================================ */
	 

 -- Does marital status affect attrition?
 WITH married_status AS (
      SELECT maritalstatus,
	  COUNT(*) AS total,
	  SUM(CASE WHEN attrition = true THEN 1 ELSE 0 END) AS left_count,
	  ROUND(100.0 * SUM(CASE WHEN attrition = true THEN 1 ELSE 0 END)/ COUNT(*),2) AS attrition_rate
  FROM employee_jobdetails
  GROUP BY maritalstatus	
 )
 SELECT *
 FROM married_status
 ORDER BY attrition_rate DESC;

/* ============================================
   INSIGHT:
   • Single employees have the highest attrition (25.53%)
   • Married employees: 12.48% attrition
   • Divorced employees: 10.09% attrition (lowest)
   • Single employees are 2x more likely to leave than married
   • Action: Engagement & career growth program for single employees
   ============================================ */
   
-- Business travel vs attrition?
WITH traveling_business AS (
        SELECT businesstravel,
		COUNT(*) AS total,
		SUM(CASE WHEN attrition = true THEN 1 ELSE 0 END) AS left_count,
		ROUND(100.0 * SUM(CASE WHEN attrition = true THEN 1 ELSE 0 END) / COUNT(*),2) AS attrition_rate
  FROM employee_jobdetails
  GROUP BY businesstravel
)
SELECT *
FROM traveling_business
ORDER BY attrition_rate DESC;

/* ============================================
   INSIGHT:
   • Frequent travelers have the highest attrition (24.91%)
   • Occasional travelers: 14.96%
   • No travel: 8.00% (lowest)
   • Frequent travelers are 3x more likely to leave than non-travelers
   • Action: Reduce travel burden, provide travel incentives, 
     or offer remote/hybrid options
   ============================================ */

-- Does stock option level affect attrition?
 WITH stock_level AS (
        SELECT ec.stockoptionlevel,
		COUNT(*) AS total,
		SUM(CASE WHEN ej.attrition = true THEN 1 ELSE 0 END) AS left_count,
		ROUND(100.0 * SUM(CASE WHEN ej.attrition = true THEN 1 ELSE 0 END) / COUNT(*),2) AS attrition_rate
		FROM employee_compensation ec
		JOIN employee_jobdetails ej ON ec.employeenumber = ej.employeenumber
		GROUP BY ec.stockoptionlevel
  )
  SELECT *
  FROM stock_level
  ORDER BY attrition_rate DESC;

-- Do high performers get higher salary hikes?
   WITH performers_salary AS(
          SELECT es.performancerating,
				 ROUND(AVG(ec.percentsalaryhike),2) AS avg_salary_hike
				 FROM employee_compensation ec
				 JOIN employee_satisfaction es ON ec.employeenumber = es.employeenumber
				 GROUP BY es.performancerating	         
   )
   SELECT *
   FROM performers_salary
   ORDER BY avg_salary_hike DESC;
/* ============================================
   INSIGHT:
   • Rating 4 (Outstanding) gets 21.85% hike
   • Rating 3 (Excellent) gets 14.00% hike
   • High performers DO get higher salary hikes (7.85% more)
   • Action: Performance-based hike structure is working — 
     continue rewarding top performers
   ============================================ */

-- Do employees who worked at more companies leave more?
   WITH employee_leaving AS (
           SELECT
		       CASE
		       WHEN numcompaniesworked <= 2 THEN '0-2 companies'
			   WHEN numcompaniesworked BETWEEN 3 AND 5 THEN '3-5 companies'
			   ELSE '6+ companies'
			   END AS companies_band,
			   COUNT(*) AS total,
	 SUM(CASE WHEN attrition = true THEN 1 ELSE 0 END) AS left_count,
     ROUND(100.0 * SUM(CASE WHEN attrition = true THEN 1 ELSE 0 END) / COUNT(*),2) AS attrition_rate
			   FROM employee_jobdetails
			   GROUP BY companies_band
   ) 
   SELECT *
   FROM  employee_leaving
   ORDER BY attrition_rate DESC;
 /* ============================================
   INSIGHT:
   • Employees who worked at 6+ companies have highest attrition (20.82%)
   • 0-2 companies: 15.86% attrition
   • 3-5 companies: 13.57% attrition (lowest)
   • Job-hoppers (6+ companies) are more likely to leave
   • Action: Focus on career growth & stability for experienced hires
   ============================================ */  
   
-- Does a recent manager change affect attrition?
  WITH manager_tenure AS (
        SELECT
		      CASE 
			      WHEN  yearswithcurrmanager <= 1 THEN '0-1 years'
				  WHEN  yearswithcurrmanager BETWEEN 2 AND 3 THEN '2-3 years'
				  ELSE '4+ years'
				  END AS manager_band,
				  COUNT(*) AS total,
				  SUM(CASE WHEN attrition = true THEN 1 ELSE 0 END) AS left_count,
				  ROUND(100.0 * SUM(CASE WHEN attrition = true THEN 1 ELSE 0 END) / COUNT(*),2) AS attrition_rate
				  FROM employee_jobdetails
				  GROUP BY manager_band	
  )
  SELECT *
  FROM manager_tenure
  ORDER BY attrition_rate DESC;

  /* ============================================
   INSIGHT:
   • Employees with 0-1 years with current manager have highest attrition (28.32%)
   • 2-3 years: 14.20% attrition
   • 4+ years: 11.16% attrition (lowest)
   • Recent manager change = 2.5x more likely to leave
   • Action: Manager transition program, mentorship for new managers
   ============================================ */
  
SELECT * FROM Employee_JobDetails;
SELECT * FROM Employee_Compensation;
SELECT * FROM Employee_Satisfaction;
