# Key Findings — HR Attrition Analysis

## 1. Overall Attrition
- Total Employees: 1,470
- Attrition Count: 237
- Attrition Rate: 16.12%

---

## 2. Top Attrition Drivers

| Factor | Attrition Rate |
|---|---|
| Poor Work-Life Balance (1) | 31.25% |
| Overtime | 30.5% |
| Low Salary (<3K) | 28.61% |
| New Manager (0-1 yr) | 28.32% |
| Single Employees | 25.53% |
| Frequent Travel | 24.91% |
| Low Job Satisfaction (1) | 22.84% |
| 6+ Companies Worked | 20.82% |

---

## 3. Department-wise Attrition
- Highest: Sales (20.6%)
- Lowest: R&D (13.8%)

---

## 4. Risk Scoring Model
- 20 high-risk employees identified
- Top 4 employees: Risk score 85
- 65% from Product & Engineering
- Key drivers: low job satisfaction, poor WLB, overtime, short tenure

---

## 5. Recommendations

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

## 6. SQL Techniques Used
- JOINs — Link 3 tables
- CTEs (WITH) — Readable queries
- CASE WHEN — Bands & Risk scoring
- Window Functions — SUM() OVER (PARTITION BY)
- Aggregations — COUNT, SUM, AVG, ROUND
