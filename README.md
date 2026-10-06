# 🏥 Emergency Department Patient Flow & Operational Capacity Optimization

[![Tableau](https://img.shields.io/badge/Tableau-Public-E97627?logo=tableau)](https://public.tableau.com)
[![Python](https://img.shields.io/badge/Python-3.11-3776AB?logo=python)](Ed_patient_data_analysis.ipynb)
[![SQL](https://img.shields.io/badge/SQL-MySQL%20%2F%20PostgreSQL-4479A1?logo=mysql)](sql/)

## 📌 Executive Summary
Evaluated clinical throughput, triage prioritization, physician efficiency, and revenue realization across **10,000 emergency department patient encounters** ($44.68M billed gross revenue) to diagnose systemic wait-time bottlenecks and reduce care abandonment walkouts.

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

1. **Doctor Wait Time Strongly Dictates Patient Experience ($r = -0.73$):**
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

├── README.md                          <-- Project overview, findings, and strategic impact
├── Ed_patient_data_analysis.ipynb     <-- Cleaning, EDA, feature engineering & visualizations
├── dashboard.png                      <-- Tableau executive dashboard preview
├── ed_patient_data.csv                <-- Sample patient visit dataset
└── sql/
    ├── 01_schema_ddl.sql              <-- Relational schema DDL with CHECK rules
    └── 02_analysis_queries.sql        <-- Operational KPIs and window function queries

4. Scroll down and click **Commit changes**.

---

### Phase 2: Upload Project 2 — Maryland Elderly Healthcare Needs

#### Step 1: Create the Repository
1. Click the **`+`** icon (top-right) $\rightarrow$ select **New repository**.
2. Under **Repository name**, enter: `maryland-elderly-healthcare-needs`.
3. Add a short description:
   > *Evaluating healthcare costs, insurance coverage gaps, and population health tiers across 53,000+ patient records using Python and K-Means clustering.*
4. Select **Public**, check **Add a README file**, select the **Python** `.gitignore`, and click **Create repository**.

---

#### Step 2: Upload Files
1. Click **Add file** $\rightarrow$ **Upload files**.
2. Drag and drop your project files:
   * Jupyter notebook (`maryland_elderly_analysis.ipynb`)
   * Policy summary report or presentation (`Maryland_Elderly_Report.pdf`)
   * Dataset or sample extract (`elderly_health_data.csv`)
   * Any exported cluster charts or visualization screenshots (`cluster_distribution.png`)
3. Commit the changes.

---

#### Step 3: Populate the Repository `README.md`
1. Open `README.md` inside `maryland-elderly-healthcare-needs`.
2. Click the pencil icon (**Edit**) and paste this markdown text:

```markdown
# 👵 Identifying Key Healthcare Assistance Needs for Older Adults in Maryland

[![Python](https://img.shields.io/badge/Python-3.11-3776AB?logo=python)](notebooks/)
[![Scikit-Learn](https://img.shields.io/badge/Scikit--Learn-Clustering-F7931E?logo=scikit-learn)](notebooks/)
[![Tableau](https://img.shields.io/badge/Tableau-Public-E97627?logo=tableau)](https://public.tableau.com)

## 📌 Executive Summary
Evaluated demographic, clinical, and financial patterns across **53,000+ patient records (73.6% aged 65+)** to identify systemic insurance coverage gaps, quantify out-of-pocket vulnerability, and segment elderly populations to guide state public health budget allocation.

### 🔑 Key Findings & Empirical Benchmarks
* **Disproportionate Coverage Gaps:** While average total healthcare expenses for older adults reached **$1.27M**, existing insurance coverage paid only **1% to 4%** of total costs, leaving massive out-of-pocket liability.
* **Extreme Vulnerability in Advanced Age:** The widest financial and coverage deficits clustered sharply among seniors aged **90 to 94**.
* **Risk Stratification via Unsupervised ML:** Applied **K-Means clustering** to segment elderly patients into **4 distinct risk tiers**, isolating high-cost, low-coverage cohorts requiring urgent state prescription subsidies and supplemental support.
* **County-Level Geographic Disparities:** Identified acute care delivery and resource disparities across **Charles, Queen Anne’s, and Howard counties**.

---

## 💡 Policy & Strategic Recommendations
1. **Targeted State Subsidies:** Prioritize state prescription drug assistance programs toward Tier 4 (high-expense, multi-comorbidity) elderly cohorts.
2. **Mobile Health Deployment:** Launch targeted mobile health clinics and community transport networks across Charles and Queen Anne's counties to reduce emergency utilization for chronic disease maintenance.
3. **Preventive Coverage Subsidies:** Expand state supplemental coverage for adults over 85 to offset catastrophic out-of-pocket expenses.

---

## 📁 Repository Structure
```text
├── README.md                          <-- Project overview, findings, and public health impact
├── maryland_elderly_analysis.ipynb    <-- Python notebook: EDA, feature scaling, K-Means clustering
├── Maryland_Elderly_Report.pdf        <-- Formal policy brief and executive deliverable
└── data/
    └── elderly_health_data.csv        <-- Maryland older adult healthcare dataset

