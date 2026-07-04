drop database if exists patient_appointment_db;
create database patient_appointment_db;

use patient_appointment_db;

create table patients(
    patient_id int auto_increment primary key,
    gender enum('Female','Male','Unknown') Not Null,
    date_of_birth date Null
);

create table departments(
    department_id int auto_increment primary key,
    department_name varchar(30) not null
);

create table appointments(
    appointment_id int auto_increment primary key,
    patient_id int not null,
    appointment_date date not null,
    appointment_time time not null,
    department_id int not null,
    appointment_type enum('New Consultation','Follow-up','Screening','Procedure') not null,
    appointment_status enum('Scheduled','Completed','Cancelled','No Show') not null,
    created_at datetime not null default current_timestamp,
    foreign key (patient_id) references patients(patient_id),
    foreign key (department_id) references departments(department_id),
    INDEX idx_appointment_status_date (appointment_status, appointment_date)

);



create table appointment_predictions(
    prediction_id int auto_increment primary key,
    appointment_id int not null,
    no_show_probability decimal(5,4) not null,
    risk_level enum('High','Medium','Low') not null,
    predicted_at datetime not null default current_timestamp,
    model_version varchar(50) not null default 'rule_v1',

    foreign key (appointment_id) references appointments(appointment_id),
    constraint unique (appointment_id, model_version) -- One appointment can only have one prediction for each model version.
    
);