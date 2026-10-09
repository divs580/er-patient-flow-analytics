# 🏥 Emergency Department Patient Flow & Operational Capacity Optimization

[![Tableau](https://img.shields.io/badge/Tableau-Public-E97627?logo=tableau)](https://public.tableau.com)
[![Python](https://img.shields.io/badge/Python-3.11-3776AB?logo=python)](Ed_patient_data_analysis.ipynb)
[![SQL](https://img.shields.io/badge/SQL-MySQL%20%2F%20PostgreSQL-4479A1?logo=mysql)](sql/ed_patient_analysis.sql)

## 📌 Executive Summary
Evaluated clinical throughput, triage prioritization, physician efficiency, and revenue realization across **10,000 emergency department patient encounters** ($44.68M billed gross revenue) to diagnose systemic wait-time bottlenecks and reduce care abandonment walkouts.

### 📄 Project Deliverables
* [📊 Interactive Tableau Dashboard (Live)]([https://public.tableau.com/app/profile/divya.kanani/viz/Ed_dashboard/Dashboard1])
* [📑 Executive Case Study Report (PDF)](./ed_analysis_report.pdf)
* [💻 Analytical SQL Scripts](./sql/ed_patient_analysis.sql)
* [📓 Python EDA & Regression Pipeline](./Ed_patient_data_analysis.ipynb)
* [📦 Packaged Tableau Workbook](./ed_dashboard.twbx)

### 🔑 Key Operational Benchmarks
| Metric | Value | Operational Context |
| :--- | :--- | :--- |
| **Total ER Visits** | 10,000 | Encounters logged across 9 core hospital specialty departments |
| **Avg Door-to-Doctor Wait** | 78.87 min | Total intake duration (triage wait + physician rooming delay) |
| **Avg Length of Stay (LOS)**| 3.26 hours | Average overall encounter duration across all clinical severities |
| **Hospital Admission Rate** | 21.17% | Proportion admitted into inpatient beds (2,117 patients) |
| **AMA Walkout Rate** | 5.41% | 541 patients who Left Against Medical Advice before care completion |
| **30-Day Readmission Rate**| 12.81% | Proportion returning for emergency care within 30 days |
| **Total Billed Gross Revenue** | $44,684,130.75 | Cumulative billed charges for clinical services |

---

## 📊 Interactive Tableau Dashboard
👉 [**Click here to view the live dashboard on Tableau Public**](https://public.tableau.com)

![Dashboard Preview](dashboard.png)

---

## 🎯 Key Analytical Findings

1. **Doctor Wait Time Dictates Patient Experience ($r = -0.73$):**
   * Regression modeling indicates patient satisfaction remains stable (~7.1/10) for short queues, but drops sharply below **3.0/10** once wait times exceed the **120-minute critical threshold**.

2. **Root Causes of Against Medical Advice (AMA) Walkouts:**
   * Care abandonment occurred in 541 visits (5.41% of total volume).
   * **16.27% of AMA walkout patients waited over 2 hours** to see a physician, demonstrating that prolonged rooming queues are the primary catalyst of financial leakage.

3. **Low-Acuity Delay Concentration:**
   * Non-urgent presentations (Triage Levels 4 & 5) comprise **45.99% of total visits** and experience the longest delays (averaging 75.2 to 98.2 minutes), tying up bed capacity needed for acute cases.

4. **Predictable Peak Inflow Surges:**
   * Arrivals surge between **14:00 and 20:00** (>600 arrivals/hour), causing severe operational strain under standard static shift models.

---

## 💡 Strategic Recommendations for Hospital Leadership

| Strategic Focus | Bottleneck Identified | Actionable Recommendation |
| :--- | :--- | :--- |
| **Throughput & Capacity** | Triage Levels 4 & 5 occupy acute care beds for 2.5–3.5 hours. | Implement an **NP/PA-led Fast-Track Minor Illness Unit** to triage non-urgent complaints away from acute emergency bays. |
| **Shift Realignment** | Volume surges heavily from 14:00 to 20:00 daily across all shifts. | Transition from fixed 8-hour shift schedules to **overlapping, staggered provider shifts (11:00–21:00 and 13:00–23:00)**. |
| **Walkout & Revenue Protection** | 541 patients left AMA, creating both clinical risk and billable loss. | Deploy an **Automated 90-Minute EHR Queue Alert** to trigger nurse-led communication and reassurance before patients walk out. |

---

## 🛠️ Advanced SQL Highlights: Physician Benchmarking
```sql
WITH PhysicianPerformance AS (
    SELECT 
        department,
        attending_physician,
        COUNT(visit_id) AS patients_treated,
        ROUND(AVG(wait_time_doctor_min), 2) AS doc_avg_wait_min,
        ROUND(AVG(satisfaction_score), 2) AS doc_avg_satisfaction
    FROM hospital_visits
    GROUP BY department, attending_physician
)
SELECT 
    department,
    attending_physician,
    patients_treated,
    doc_avg_wait_min,
    ROUND(AVG(doc_avg_wait_min) OVER (PARTITION BY department), 2) AS dept_avg_wait_min,
    ROUND(doc_avg_wait_min - AVG(doc_avg_wait_min) OVER (PARTITION BY department), 2) AS wait_variance_from_dept,
    doc_avg_satisfaction
FROM PhysicianPerformance
ORDER BY department, doc_avg_wait_min ASC;
```

---

## 📁 Repository Structure
```text
├── README.md                          <-- Project overview, findings, and strategic impact
├── ed_analysis_report.pdf             <-- Executive Case Study Report (PDF)
├── Ed_patient_data_analysis.ipynb     <-- Cleaning, EDA, feature engineering & visualizations
├── dashboard.png                      <-- Tableau executive dashboard preview
├── ed_dashboard.twbx                  <-- Packaged Tableau workbook
└── sql/
    └── ed_patient_analysis.sql        <-- Table DDL, operational KPIs, and window functions
```

