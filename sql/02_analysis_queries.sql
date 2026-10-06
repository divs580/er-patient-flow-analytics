-- 2. EXECUTIVE OPERATIONAL AND FINANCIAL KPIS
SELECT 
    COUNT(visit_id) AS total_visits,
    COUNT(DISTINCT patient_id) AS unique_patients,
    ROUND(AVG(wait_time_triage_min), 2) AS avg_triage_wait_min,
    ROUND(AVG(wait_time_doctor_min), 2) AS avg_doctor_wait_min,
    ROUND(AVG(wait_time_triage_min + wait_time_doctor_min), 2) AS avg_door_to_doc_min,
    ROUND(AVG(length_of_stay_hrs), 2) AS avg_los_hours,
    ROUND(SUM(billed_amount_usd), 2) AS total_revenue_usd,
    ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction_score,
    ROUND(100.0 * COUNT(CASE WHEN disposition = 'Admitted' THEN 1 END) / COUNT(*), 2) AS admission_rate_pct,
    ROUND(100.0 * COUNT(CASE WHEN disposition = 'AMA' THEN 1 END) / COUNT(*), 2) AS ama_walkout_rate_pct,
    ROUND(100.0 * SUM(readmitted_30d) / COUNT(*), 2) AS readmission_rate_pct
FROM hospital_visits;

-- 3. CLINICAL TRIAGE THROUGHPUT AND PATIENT FLOW VALIDATION
SELECT 
    triage_level,
    COUNT(*) AS total_patients,
    ROUND(AVG(wait_time_triage_min), 2) AS avg_triage_wait_min,
    ROUND(AVG(wait_time_doctor_min), 2) AS avg_doctor_wait_min,
    ROUND(AVG(wait_time_triage_min + wait_time_doctor_min), 2) AS avg_door_to_doc_min,
    ROUND(AVG(length_of_stay_hrs), 2) AS avg_los_hrs,
    ROUND(100.0 * COUNT(CASE WHEN disposition = 'Admitted' THEN 1 END) / COUNT(*), 2) AS admission_rate_pct,
    ROUND(AVG(billed_amount_usd), 2) AS avg_billed_amount,
    ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction
FROM hospital_visits
GROUP BY triage_level
ORDER BY triage_level ASC;

-- 4. ROOT-CAUSE WALKOUT ANALYSIS: AGAINST MEDICAL ADVICE (AMA)
SELECT 
    disposition,
    COUNT(visit_id) AS total_patients,
    ROUND(AVG(wait_time_triage_min), 2) AS avg_triage_wait_min,
    ROUND(AVG(wait_time_doctor_min), 2) AS avg_doctor_wait_min,
    ROUND(AVG(wait_time_triage_min + wait_time_doctor_min), 2) AS avg_door_to_doc_min,
    ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction_score,
    ROUND(100.0 * COUNT(CASE WHEN wait_time_doctor_min > 120 THEN 1 END) / COUNT(*), 2) AS pct_waited_over_2hrs
FROM hospital_visits
GROUP BY disposition
ORDER BY avg_doctor_wait_min DESC;

-- 5. CLINICAL RISK: 30-DAY READMISSION SEGMENTATION
SELECT 
    chief_complaint,
    age_group,
    COUNT(visit_id) AS total_cases,
    SUM(readmitted_30d) AS readmission_count,
    ROUND(100.0 * SUM(readmitted_30d) / COUNT(visit_id), 2) AS readmission_rate_pct,
    ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction,
    ROUND(AVG(billed_amount_usd), 2) AS avg_cost_per_case
FROM hospital_visits
GROUP BY chief_complaint, age_group
HAVING COUNT(visit_id) >= 3
ORDER BY readmission_rate_pct DESC, total_cases DESC;

-- 6. PHYSICIAN PERFORMANCE BENCHMARK 
WITH PhysicianPerformance AS (
    SELECT 
        department,
        attending_physician,
        COUNT(visit_id) AS patients_treated,
        ROUND(AVG(wait_time_doctor_min), 2) AS doc_avg_wait_min,
        ROUND(AVG(length_of_stay_hrs), 2) AS doc_avg_los_hrs,
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

-- 7. REVENUE AND FINANCIAL REALIZATION: TOP CASES PER SPECIALTY
WITH RankedFinancialCases AS (
    SELECT 
        visit_id,
        department,
        chief_complaint,
        insurance_type,
        billed_amount_usd,
        length_of_stay_hrs,
        DENSE_RANK() OVER (PARTITION BY department ORDER BY billed_amount_usd DESC) AS revenue_rank
    FROM hospital_visits
)
SELECT * FROM RankedFinancialCases 
WHERE revenue_rank <= 3;
