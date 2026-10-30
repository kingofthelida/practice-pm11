
-- 1. Вывести всех пациентов
SELECT * FROM patients;

-- 2. Вывести всех врачей с их специальностями
SELECT doctors.full_name, specialties.name AS specialty
FROM doctors
JOIN specialties ON doctors.specialty_id = specialties.specialty_id;

-- 3. Вывести расписание приёмов с пациентами, врачами и кабинетами
SELECT
    appointments.appointment_datetime,
    patients.full_name AS patient,
    doctors.full_name AS doctor,
    rooms.room_number,
    appointments.status
FROM appointments
JOIN patients ON appointments.patient_id = patients.patient_id
JOIN doctors ON appointments.doctor_id = doctors.doctor_id
JOIN rooms ON appointments.room_id = rooms.room_id;

-- 4. Посчитать количество пациентов каждого пола
SELECT gender, COUNT(*) AS total
FROM patients
GROUP BY gender;

-- 5. Посчитать количество приёмов каждого врача
SELECT doctors.full_name, COUNT(appointments.appointment_id) AS total
FROM doctors
LEFT JOIN appointments ON doctors.doctor_id = appointments.doctor_id
GROUP BY doctors.doctor_id;

-- 6. Посчитать количество приёмов по статусам
SELECT status, COUNT(*) AS total
FROM appointments
GROUP BY status;

-- 7. Найти пациентов, у которых есть завершённые приёмы
SELECT full_name
FROM patients
WHERE EXISTS (
    SELECT 1
    FROM appointments
    WHERE appointments.patient_id = patients.patient_id
    AND appointments.status = 'Завершён'
);

-- 8. Вывести все приёмы врача с ID = 1
SELECT *
FROM appointments
WHERE doctor_id = 1;

-- 9. Вывести диагнозы по каждому приёму
SELECT
    appointments.appointment_id,
    patients.full_name AS patient,
    diagnoses.name AS diagnosis
FROM appointments
JOIN patients ON appointments.patient_id = patients.patient_id
JOIN appointment_diagnoses
    ON appointments.appointment_id = appointment_diagnoses.appointment_id
JOIN diagnoses
    ON appointment_diagnoses.diagnosis_id = diagnoses.diagnosis_id;

-- 10. Вывести назначения лекарств пациентам
SELECT
    patients.full_name,
    prescriptions.medication_name,
    prescriptions.dosage,
    prescriptions.instructions
FROM prescriptions
JOIN appointments ON prescriptions.appointment_id = appointments.appointment_id
JOIN patients ON appointments.patient_id = patients.patient_id;

-- 11. Найти пациентов, у которых больше одного приёма
SELECT patients.full_name, COUNT(appointments.appointment_id) AS total
FROM patients
JOIN appointments ON patients.patient_id = appointments.patient_id
GROUP BY patients.patient_id
HAVING COUNT(appointments.appointment_id) > 1;

-- 12. Найти врачей, у которых приёмов больше среднего количества
SELECT doctors.full_name, COUNT(appointments.appointment_id) AS total
FROM doctors
LEFT JOIN appointments ON doctors.doctor_id = appointments.doctor_id
GROUP BY doctors.doctor_id
HAVING COUNT(appointments.appointment_id) > (
    SELECT AVG(total)
    FROM (
        SELECT COUNT(*) AS total
        FROM appointments
        GROUP BY doctor_id
    )
);

-- 13. Найти самый часто встречающийся диагноз
SELECT diagnoses.name, COUNT(*) AS total
FROM diagnoses
JOIN appointment_diagnoses
    ON diagnoses.diagnosis_id = appointment_diagnoses.diagnosis_id
GROUP BY diagnoses.diagnosis_id
ORDER BY total DESC
LIMIT 1;

-- 14. Найти приёмы за октябрь 2026 года
SELECT *
FROM appointments
WHERE appointment_datetime >= '2026-10-01'
AND appointment_datetime < '2026-11-01';

-- 15. Найти кабинеты, в которых было больше одного приёма
SELECT rooms.room_number, COUNT(appointments.appointment_id) AS total
FROM rooms
JOIN appointments ON rooms.room_id = appointments.room_id
GROUP BY rooms.room_id
HAVING COUNT(appointments.appointment_id) > 1;
