# HR Attrition Analysis

SQL-based analysis of 1,470 employees to identify key drivers of 
attrition and predict high-risk employees using PostgreSQL.

---

## Project Overview

Employee attrition is a major challenge for HR teams. This project 
analyzes HR data across 3 normalized tables to answer critical 
business questions:

- Why are employees leaving?
- Which departments, roles, and demographics are most affected?
- Who is most likely to leave next?

**Dataset:** 1,470 employees | 35 columns | 3 tables

---

## Tools Used

| Tool | Purpose |
|---|---|
| PostgreSQL | Database & Analysis |
| SQL | JOINs, CTEs, Window Functions, CASE WHEN |
| CSV | Data Import |

---

## Database Schema

### Table 1: Employee_JobDetails
Personal & job information — Age, Gender, Department, JobRole, 
Attrition, Tenure, etc.

### Table 2: Employee_Compensation
Salary & compensation — MonthlyIncome, DailyRate, OverTime, 
StockOptionLevel, etc.

### Table 3: Employee_Satisfaction
Satisfaction scores — JobSatisfaction, WorkLifeBalance, 
EnvironmentSatisfaction, etc.

**Common Key:** `EmployeeNumber` (links all 3 tables)

---

## Key Findings

### 1. Overall Attrition
- Total Employees: 1,470
- Attrition Count: 237
- Attrition Rate: 16.12%

### 2. Department-wise
- Highest: Sales (20.6%)
- Lowest: R&D (13.8%)

### 3. Overtime Impact
- Overtime employees: 30.5% attrition
- Non-overtime: 10.4% attrition

### 4. Salary Impact
- Low salary (<3K): 28.61% attrition
- Very high (>12K): 5.64% attrition
- Low salary employees are 5x more likely to leave

### 5. Job Satisfaction
- Low satisfaction (1): 22.84% attrition
- Very High satisfaction (4): 11.33% attrition

### 6. Work-Life Balance
- Poor WLB (1): 31.25% attrition
- Very High WLB (4): 14.22% attrition

### 7. Marital Status
- Single: 25.53% attrition
- Married: 12.48%
- Divorced: 10.09%

### 8. Business Travel
- Frequent Travel: 24.91% attrition
- No Travel: 8.00%

### 9. Manager Change
- 0-1 years with manager: 28.32% attrition
- 4+ years: 11.16%

### 10. Job Hopping
- 6+ companies worked: 20.82% attrition
- 3-5 companies: 13.57%

### 11. Promotion Gap
- Business Development avg gap: 2.35 years
- Employees stuck for 15 years without promotion

### 12. Gender Distribution
- All departments male-dominated
- People Operations: 68.25% male

---

## Risk Scoring Model

A weighted risk model identified 20 high-risk employees based on:

| Factor | Weight |
|---|---|
| Job Satisfaction <= 2 | +30 |
| Work-Life Balance <= 2 | +25 |
| Years at Company <= 2 | +20 |
| Promotion Gap >= 3 years | +15 |
| Overtime = TRUE | +10 |

**Max Score:** 100

**Top 4 employees:** Risk score 85 — Immediate HR intervention

---

## Business Recommendations

| # | Recommendation | Impact |
|---|---|---|
| 1 | Salary revision for low band (<3K) | Reduce 28.61% attrition |
| 2 | Overtime cap / hire more staff | Reduce 30.5% attrition |
| 3 | Manager transition program | Reduce 28.32% attrition |
| 4 | Engagement program for single employees | Reduce 25.53% attrition |
| 5 | Travel incentives / remote options | Reduce 24.91% attrition |
| 6 | Promotion review for stuck employees | Address 15-year gap |
| 7 | Diversity hiring for People Operations | Improve gender ratio |

---

## Repository Structure

```
HR-Attrition-Analysis/
│
├── README.md
├── sql/
│   └── HR_Attrition_Analysis.sql
├── data/
│   ├── HR_Attrition_Source1.csv
│   ├── HR_Attrition_Source2.csv
│   └── HR_Attrition_Source3.csv
└── insights/
    └── key_findings.md
```

---

## How to Run

1. Create database: `CREATE DATABASE HR_Analytics;`

2. Run the SQL file: `sql/HR_Attrition_Analysis.sql`

3. Import CSV files using the `COPY` command

4. Run analysis queries

---

## SQL Techniques Used

- JOINs — Link 3 tables
- CTEs (WITH) — Readable queries
- CASE WHEN — Bands & Risk scoring
- Window Functions — SUM() OVER (PARTITION BY)
- Aggregations — COUNT, SUM, AVG, ROUND
- Subqueries — Complex analysis

---

## Author

**Saklain Alam**

- GitHub: [github.com/saklain23](https://github.com/saklain23)
- LinkedIn: [linkedin.com/in/saklain-alam-0342ab408](https://www.linkedin.com/in/saklain-alam-0342ab408)

---

## License

This project is open-source and available under the MIT License.
