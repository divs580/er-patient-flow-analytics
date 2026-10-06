CREATE DATABASE IF NOT EXISTS hospital_db;
USE hospital_db;

CREATE TABLE hospital_visits (
    visit_id                VARCHAR(20) PRIMARY KEY,
    patient_id              VARCHAR(20) NOT NULL,
    arrival_datetime        TIMESTAMP NOT NULL,
    triage_level            INT CHECK (triage_level BETWEEN 1 AND 5),
    chief_complaint         VARCHAR(100),
    department              VARCHAR(100),
    attending_physician     VARCHAR(50),
    patient_age             INT CHECK (patient_age >= 0),
    patient_gender          VARCHAR(20),
    insurance_type          VARCHAR(50),
    wait_time_triage_min    DECIMAL(6, 2),
    wait_time_doctor_min    DECIMAL(6, 2),
    length_of_stay_hrs      DECIMAL(6, 2),
    disposition             VARCHAR(50),
    readmitted_30d          INT CHECK (readmitted_30d IN (0, 1)),
    satisfaction_score      DECIMAL(3, 1),
    billed_amount_usd       DECIMAL(10, 2),
    arrival_hour            INT CHECK (arrival_hour BETWEEN 0 AND 23),
    arrival_dayofweek       VARCHAR(20),
    arrival_month           INT,
    age_group               VARCHAR(20)
);
