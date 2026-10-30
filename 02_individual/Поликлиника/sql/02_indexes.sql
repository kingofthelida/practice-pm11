CREATE INDEX idx_appointments_patient_datetime
ON appointments(patient_id, appointment_datetime);

CREATE INDEX idx_appointments_doctor_datetime
ON appointments(doctor_id, appointment_datetime);