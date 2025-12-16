CREATE DATABASE healthcare_system;

USE healthcare_system;

CREATE TABLE Patients (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    Gender VARCHAR(10),
    ContactInfo VARCHAR(100)
);

CREATE TABLE Doctors (
    DoctorID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    Specialty VARCHAR(100),
    ContactInfo VARCHAR(100)
);

CREATE TABLE Appointments (
    AppointmentID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    AppointmentDate DATE,
    AppointmentTime TIME,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

CREATE TABLE MedicalRecords (
    RecordID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    Date DATE,
    Diagnosis TEXT,
    Treatment TEXT,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

SELECT * FROM Patients LIMIT 10;
INSERT INTO Patients (Name, Age, Gender, ContactInfo)
VALUES ('Jane Smith', 28, 'Female', '9876543210');

INSERT INTO Doctors (Name, Specialty, ContactInfo)
VALUES ('Dr. Michael Johnson', 'Cardiology', '555-1234');

INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, AppointmentTime)
VALUES (1, 1, '2025-12-10', '10:00:00');

INSERT INTO MedicalRecords (PatientID, Date, Diagnosis, Treatment)
VALUES (1, '2025-12-09', 'Flu', 'Rest, fluids, and medication');

SELECT * FROM Patients;

SELECT * FROM Appointments
WHERE PatientID = 1;

SELECT * FROM patients
WHERE PatientID = 1;

SELECT * FROM MedicalRecords
WHERE PatientID = 1;

SELECT p.Name AS PatientName, a.AppointmentDate, a.AppointmentTime
FROM Appointments a
JOIN Patients p ON a.PatientID = p.PatientID
WHERE a.AppointmentDate = '2025-12-10';

UPDATE Patients
SET ContactInfo = '1122334455'
WHERE PatientID = 1;

UPDATE Doctors
SET Specialty = 'Neurology'
WHERE DoctorID = 1;

UPDATE Appointments
SET AppointmentTime = '14:00:00'
WHERE AppointmentID = 1;

UPDATE MedicalRecords
SET Treatment = 'Antibiotics and rest'
WHERE RecordID = 1;

DELETE FROM Appointments WHERE AppointmentID = 1;

DELETE FROM MedicalRecords WHERE RecordID = 1;

 
CREATE INDEX idx_patient_id ON Appointments (PatientID);
 
CREATE INDEX idx_doctor_id ON Appointments (DoctorID);

CREATE INDEX idx_appointment_date ON Appointments (AppointmentDate);

CREATE INDEX idx_patient_id_medicalrecords ON MedicalRecords (PatientID);

SELECT DoctorID, COUNT(PatientID) AS NumberOfAppointments
FROM Appointments
GROUP BY DoctorID;

SELECT p.Name AS PatientName, m.Date, m.Treatment
FROM MedicalRecords m
JOIN Patients p ON m.PatientID = p.PatientID
WHERE p.PatientID = 1
ORDER BY m.Date DESC
LIMIT 1;

SELECT p.Name AS PatientName, d.Name AS DoctorName, a.AppointmentDate, m.Diagnosis
FROM Appointments a
JOIN Patients p ON a.PatientID = p.PatientID
JOIN Doctors d ON a.DoctorID = d.DoctorID
JOIN MedicalRecords m ON m.PatientID = p.PatientID
WHERE a.AppointmentDate = '2025-12-7';

SELECT PatientID, COUNT(*)
FROM Patients
GROUP BY PatientID
HAVING COUNT(*) > 1;

SELECT *
FROM Patients
WHERE PatientID IS NULL;

SELECT *
FROM Doctors
WHERE DoctorID IS NULL;

SELECT AppointmentID, COUNT(*)
FROM Appointments
GROUP BY AppointmentID
HAVING COUNT(*) > 1;

 
SELECT RecordID, COUNT(*)
FROM medicalrecords
GROUP BY RecordID
HAVING COUNT(*) > 1;

SELECT doctorID, COUNT(*)
FROM doctors
GROUP BY doctorID
HAVING COUNT(*) > 1;

SELECT *
FROM medicalrecords
WHERE recordID IS NULL;

SELECT *
FROM appointments
WHERE appointmentID IS NULL;

SELECT p.Name AS PatientName, a.AppointmentDate, a.AppointmentTime
FROM Appointments a
LEFT JOIN MedicalRecords m ON a.PatientID = m.PatientID AND a.AppointmentDate = m.Date
JOIN Patients p ON a.PatientID = p.PatientID
WHERE m.RecordID IS NULL AND a.AppointmentDate < CURDATE();

SELECT p.Name AS PatientName, COUNT(a.AppointmentID) AS NumberOfAppointments
FROM Patients p
LEFT JOIN Appointments a ON p.PatientID = a.PatientID
GROUP BY p.PatientID;

SELECT d.Name AS DoctorName, COUNT(a.AppointmentID) AS NumberOfAppointments
FROM Appointments a
JOIN Doctors d ON a.DoctorID = d.DoctorID
GROUP BY d.Name
ORDER BY NumberOfAppointments DESC;

SELECT m.Diagnosis, m.Treatment, COUNT(*) AS TreatmentCount
FROM MedicalRecords m
GROUP BY m.Diagnosis, m.Treatment
ORDER BY TreatmentCount DESC;

INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, AppointmentTime)
VALUES (1, 1, '2025-12-10', '10:00:00');

SELECT DoctorID, COUNT(PatientID) AS NumberOfAppointments
FROM Appointments
GROUP BY DoctorID;
