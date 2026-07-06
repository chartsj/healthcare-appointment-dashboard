USE patient_appointment_db;
set foreign_key_checks=0;

truncate table appointment_predictions;
truncate table appointments;
truncate table departments;
truncate table patients;

set foreign_key_checks=1;

insert into patients(gender, date_of_birth) values ('Female', '1998-05-21'),
('Male', '1985-11-03'),
('Female', '1972-02-14'),
('Male', '1990-08-09'),
('Female', '2001-12-30'),
('Male', '1965-04-18'),
('Female', '1988-07-25'),
('Male', '1995-01-11'),
('Female', '1979-09-06'),
('Male', '2003-03-22'),
('Female', '1958-10-15'),
('Male', '1969-06-02'),
('Female', '1992-11-19'),
('Male', '1981-05-28'),
('Female', '2000-02-07'),
('Male', '1975-12-12'),
('Female', '1962-08-31'),
('Male', '1999-04-04'),
('Female', '1986-01-27'),
('Male', '1970-07-13'),
('Female', '1996-09-17'),
('Male', '1955-03-05'),
('Female', '1983-06-24'),
('Male', '2002-10-09'),
('Female', '1977-11-01'),
('Male', '1991-02-20'),
('Female', '1968-05-16'),
('Male', '1989-12-03'),
('Female', '2004-07-29'),
('Male', '1974-01-08'),
('Unknown', NULL),
('Female', NULL),
('Male', NULL),
('Unknown', '1993-08-14'),
('Female', '1960-04-26'),
('Male', '1980-09-21'),
('Female', '1997-03-12'),
('Male', '1952-11-30'),
('Female', '2005-06-18'),
('Unknown', NULL),
('Female','2006-12-12'),
('Male','1972-01-02'),
('Female', '1998-05-21'),
('Male', '1985-11-03'),
('Female', '1972-02-14'),
('Male', '1990-08-09'),
('Female', '2001-12-30'),
('Male', '1965-04-18'),
('Female', '1988-07-25'),
('Male', '1995-01-11'),
('Female', '1979-09-06'),
('Male', '2003-03-22'),
('Female', '1958-10-15'),
('Male', '1969-06-02'),
('Female', '1992-11-19'),
('Male', '1981-05-28'),
('Female', '2000-02-07'),
('Male', '1975-12-12'),
('Female', '1962-08-31'),
('Male', '1999-04-04'),
('Female', '1986-01-27'),
('Male', '1970-07-13'),
('Female', '1996-09-17'),
('Male', '1955-03-05'),
('Female', '1983-06-24'),
('Male', '2002-10-09'),
('Female', '1977-11-01'),
('Male', '1991-02-20'),
('Female', '1968-05-16'),
('Male', '1989-12-03'),
('Female', '2004-07-29'),
('Male', '1974-01-08'),
('Unknown', NULL),
('Female', NULL),
('Male', NULL),
('Unknown', '1993-08-14'),
('Female', '1960-04-26'),
('Male', '1980-09-21'),
('Female', '1997-03-12'),
('Male', '1952-11-30'),
('Female', '2005-06-18'),
('Unknown', NULL),
('Female','2006-12-12'),
('Male','1972-01-2'),
('Female', '1995-08-14'),
('Male', '1986-02-03'),
('Female', '1970-11-27'),
('Male', '2003-06-19'),
('Female', '1964-09-08'),
('Male', '1992-12-22'),
('Female', '1989-04-15'),
('Male', '1957-01-30'),
('Female', '2000-10-11'),
('Male', '1978-07-06'),
('Unknown', NULL),
('Female', NULL),
('Male', '1968-03-24'),
('Female', '1982-05-09'),
('Male', '1999-09-17'),
('Female', '1975-12-04'),
('Male', '2006-02-28'),
('Unknown', '1991-06-01');


insert into departments(department_name) values
('General Medicine'),
('Cardiology'),
('Orthopaedics'),
('Dermatology'),
('Radiology'),
('Endocrinology');


INSERT INTO appointments
(
    patient_id,
    appointment_date,
    appointment_time,
    department_id,
    appointment_type,
    appointment_status,
    created_at
)
VALUES
(34, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '09:00:00', 1, 'Follow-up', 'Scheduled', NOW()),
(23, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '10:30:00', 1, 'Follow-up', 'Scheduled', NOW()),
(1,  DATE_ADD(CURDATE(), INTERVAL 2 DAY), '11:00:00', 4, 'New Consultation', 'Scheduled', NOW()),
(40, DATE_ADD(CURDATE(), INTERVAL 2 DAY), '14:00:00', 1, 'Follow-up', 'Scheduled', NOW()),
(11, DATE_ADD(CURDATE(), INTERVAL 3 DAY), '09:30:00', 2, 'Follow-up', 'Scheduled', NOW()),
(12, DATE_ADD(CURDATE(), INTERVAL 3 DAY), '15:30:00', 1, 'Follow-up', 'Scheduled', NOW()),
(9,  DATE_ADD(CURDATE(), INTERVAL 4 DAY), '08:30:00', 6, 'Screening', 'Scheduled', NOW()),
(5,  DATE_ADD(CURDATE(), INTERVAL 5 DAY), '10:00:00', 4, 'New Consultation', 'Scheduled', NOW()),
(34, DATE_ADD(CURDATE(), INTERVAL 6 DAY), '11:30:00', 1, 'Follow-up', 'Scheduled', NOW()),
(10, DATE_ADD(CURDATE(), INTERVAL 7 DAY), '16:00:00', 4, 'Follow-up', 'Scheduled', NOW()),

-- Patient 34: high no-show history
(34, DATE_SUB(CURDATE(), INTERVAL 90 DAY), '09:00:00', 1, 'Follow-up', 'No Show', DATE_SUB(CURDATE(), INTERVAL 120 DAY)),
(34, DATE_SUB(CURDATE(), INTERVAL 70 DAY), '10:30:00', 1, 'Follow-up', 'No Show', DATE_SUB(CURDATE(), INTERVAL 100 DAY)),
(34, DATE_SUB(CURDATE(), INTERVAL 45 DAY), '15:30:00', 1, 'Follow-up', 'No Show', DATE_SUB(CURDATE(), INTERVAL 75 DAY)),
(34, DATE_SUB(CURDATE(), INTERVAL 20 DAY), '11:00:00', 1, 'Follow-up', 'Cancelled', DATE_SUB(CURDATE(), INTERVAL 50 DAY)),
(34, DATE_SUB(CURDATE(), INTERVAL 30 DAY), '09:00:00', 1, 'Follow-up', 'No Show', DATE_SUB(CURDATE(), INTERVAL 120 DAY)),
(34, DATE_SUB(CURDATE(), INTERVAL 60 DAY), '10:00:00', 1, 'Follow-up', 'No Show', DATE_SUB(CURDATE(), INTERVAL 120 DAY)),

-- Patient 40: high no-show history
(40, DATE_SUB(CURDATE(), INTERVAL 100 DAY), '10:00:00', 1, 'Follow-up', 'No Show', DATE_SUB(CURDATE(), INTERVAL 130 DAY)),
(40, DATE_SUB(CURDATE(), INTERVAL 60 DAY), '14:00:00', 1, 'Follow-up', 'No Show', DATE_SUB(CURDATE(), INTERVAL 90 DAY)),
(40, DATE_SUB(CURDATE(), INTERVAL 30 DAY), '09:30:00', 1, 'Follow-up', 'Cancelled', DATE_SUB(CURDATE(), INTERVAL 60 DAY)),

-- Patient 11: medium risk
(11, DATE_SUB(CURDATE(), INTERVAL 80 DAY), '09:00:00', 2, 'Follow-up', 'No Show', DATE_SUB(CURDATE(), INTERVAL 110 DAY)),
(11, DATE_SUB(CURDATE(), INTERVAL 50 DAY), '10:00:00', 2, 'Follow-up', 'Cancelled', DATE_SUB(CURDATE(), INTERVAL 80 DAY)),
(11, DATE_SUB(CURDATE(), INTERVAL 25 DAY), '11:30:00', 2, 'Follow-up', 'Completed', DATE_SUB(CURDATE(), INTERVAL 55 DAY)),

-- Patient 5: medium risk
(5, DATE_SUB(CURDATE(), INTERVAL 85 DAY), '10:30:00', 4, 'New Consultation', 'No Show', DATE_SUB(CURDATE(), INTERVAL 115 DAY)),
(5, DATE_SUB(CURDATE(), INTERVAL 40 DAY), '15:00:00', 4, 'Follow-up', 'Cancelled', DATE_SUB(CURDATE(), INTERVAL 70 DAY)),

-- Patient 1: mostly okay
(1, DATE_SUB(CURDATE(), INTERVAL 75 DAY), '11:00:00', 4, 'New Consultation', 'Completed', DATE_SUB(CURDATE(), INTERVAL 105 DAY)),
(1, DATE_SUB(CURDATE(), INTERVAL 35 DAY), '14:00:00', 4, 'Follow-up', 'Cancelled', DATE_SUB(CURDATE(), INTERVAL 65 DAY)),
(1, DATE_SUB(CURDATE(), INTERVAL 15 DAY), '09:30:00', 4, 'Follow-up', 'Completed', DATE_SUB(CURDATE(), INTERVAL 45 DAY)),

-- Patient 23: low risk
(23, DATE_SUB(CURDATE(), INTERVAL 95 DAY), '09:00:00', 1, 'Follow-up', 'Completed', DATE_SUB(CURDATE(), INTERVAL 125 DAY)),
(23, DATE_SUB(CURDATE(), INTERVAL 55 DAY), '10:30:00', 1, 'Follow-up', 'Completed', DATE_SUB(CURDATE(), INTERVAL 85 DAY)),
(23, DATE_SUB(CURDATE(), INTERVAL 18 DAY), '15:30:00', 1, 'Follow-up', 'Completed', DATE_SUB(CURDATE(), INTERVAL 48 DAY)),

-- Patient 12: low risk
(12, DATE_SUB(CURDATE(), INTERVAL 65 DAY), '08:30:00', 1, 'Follow-up', 'Completed', DATE_SUB(CURDATE(), INTERVAL 95 DAY)),
(12, DATE_SUB(CURDATE(), INTERVAL 28 DAY), '15:30:00', 1, 'Follow-up', 'Completed', DATE_SUB(CURDATE(), INTERVAL 58 DAY)),

-- Patient 9: low risk
(9, DATE_SUB(CURDATE(), INTERVAL 72 DAY), '09:00:00', 6, 'Screening', 'Completed', DATE_SUB(CURDATE(), INTERVAL 102 DAY)),
(9, DATE_SUB(CURDATE(), INTERVAL 22 DAY), '08:30:00', 6, 'Screening', 'Completed', DATE_SUB(CURDATE(), INTERVAL 52 DAY)),

-- Patient 10: low risk
(10, DATE_SUB(CURDATE(), INTERVAL 68 DAY), '14:00:00', 4, 'Follow-up', 'Completed', DATE_SUB(CURDATE(), INTERVAL 98 DAY)),
(10, DATE_SUB(CURDATE(), INTERVAL 32 DAY), '16:00:00', 4, 'Follow-up', 'Completed', DATE_SUB(CURDATE(), INTERVAL 62 DAY));
