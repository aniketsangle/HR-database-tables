create database hrdatabase;
use hrdatabase;



CREATE TABLE applicants (
    applicant_id   INT AUTO_INCREMENT PRIMARY KEY,
    first_name    VARCHAR(50) NOT NULL,
    last_name     VARCHAR(50) NOT NULL,
    email         VARCHAR(100) UNIQUE NOT NULL,
    phone_number  VARCHAR(15) UNIQUE NOT NULL,
    dob           DATE NOT NULL,
    gender        ENUM('Male', 'Female', 'Other') NOT NULL,
    nationality   VARCHAR(50),
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE job_positions (
    position_id   INT AUTO_INCREMENT PRIMARY KEY,
    position_name VARCHAR(100) NOT NULL,
    department    VARCHAR(100) NOT NULL,
    location      VARCHAR(100),
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE applications (
    application_id     INT AUTO_INCREMENT PRIMARY KEY,
    applicant_id       INT NOT NULL,
    position_id        INT NOT NULL,
    application_date   DATE NOT NULL,
    status            ENUM('Applied', 'Shortlisted', 'Interviewed', 'Hired', 'Rejected') NOT NULL,
    salary_expectation DECIMAL(10,2),
    created_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (applicant_id) REFERENCES applicants(applicant_id) ON DELETE CASCADE,
    FOREIGN KEY (position_id) REFERENCES job_positions(position_id) ON DELETE CASCADE
);


CREATE TABLE education (
    education_id    INT AUTO_INCREMENT PRIMARY KEY,
    applicant_id    INT NOT NULL,
    degree         VARCHAR(100) NOT NULL,
    university     VARCHAR(100) NOT NULL,
    year_of_passing YEAR NOT NULL,
    grade          VARCHAR(10),
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (applicant_id) REFERENCES applicants(applicant_id) ON DELETE CASCADE
);


CREATE TABLE experience (
    experience_id  INT AUTO_INCREMENT PRIMARY KEY,
    applicant_id   INT NOT NULL,
    company_name   VARCHAR(100) NOT NULL,
    job_title      VARCHAR(100) NOT NULL,
    start_date     DATE NOT NULL,
    end_date       DATE NULL,
    salary         DECIMAL(10,2),
    job_description TEXT,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (applicant_id) REFERENCES applicants(applicant_id) ON DELETE CASCADE
);


CREATE TABLE skills (
    skill_id        INT AUTO_INCREMENT PRIMARY KEY,
    applicant_id    INT NOT NULL,
    skill_name      VARCHAR(100) NOT NULL,
    proficiency_level ENUM('Beginner', 'Intermediate', 'Expert') NOT NULL,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (applicant_id) REFERENCES applicants(applicant_id) ON DELETE CASCADE
);


CREATE TABLE interviews (
    interview_id     INT AUTO_INCREMENT PRIMARY KEY,
    application_id   INT NOT NULL,
    interview_date   DATE NOT NULL,
    interviewer_name VARCHAR(100) NOT NULL,
    feedback         TEXT,
    status          ENUM('Pending', 'Cleared', 'Rejected') NOT NULL,
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (application_id) REFERENCES applications(application_id) ON DELETE CASCADE
);


CREATE TABLE offer_letters (
    offer_id       INT AUTO_INCREMENT PRIMARY KEY,
    application_id INT NOT NULL,
    offer_date     DATE NOT NULL,
    salary_offered DECIMAL(10,2) NOT NULL,
    joining_date   DATE NOT NULL,
    status        ENUM('Accepted', 'Declined', 'Pending') NOT NULL,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (application_id) REFERENCES applications(application_id) ON DELETE CASCADE
);



CREATE TABLE rejected_applicants (
    rejection_id     INT AUTO_INCREMENT PRIMARY KEY,
    application_id   INT NOT NULL,
    rejection_reason TEXT NOT NULL,
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (application_id) REFERENCES applications(application_id) ON DELETE CASCADE
);


-- To optimize query performance, add indexes on frequently queried columns:
CREATE INDEX idx_applicant_email ON applicants(email);
CREATE INDEX idx_application_status ON applications(status);
CREATE INDEX idx_skill_name ON skills(skill_name);

-- List All Applicants Who Applied for a Specific Job 
SELECT a.first_name, a.last_name, jp.position_name, app.status
FROM applicants a
JOIN applications app ON a.applicant_id = app.applicant_id
JOIN job_positions jp ON app.position_id = jp.position_id
WHERE jp.position_name = 'Data Analyst';


-- Count Total Applicants for Each Job Position
SELECT jp.position_name, COUNT(app.application_id) AS total_applicants
FROM applications app
JOIN job_positions jp ON app.position_id = jp.position_id
GROUP BY jp.position_name
ORDER BY total_applicants DESC;
