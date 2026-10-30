
PRAGMA foreign_keys = ON;

CREATE TABLE specialties (
    specialty_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE patients (
    patient_id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL,
    birth_date TEXT NOT NULL,
    gender TEXT NOT NULL CHECK (gender IN ('М', 'Ж')),
    phone TEXT UNIQUE,
    address TEXT
);

CREATE TABLE doctors (
    doctor_id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL,
    specialty_id INTEGER NOT NULL,
    phone TEXT UNIQUE,
    FOREIGN KEY (specialty_id)
        REFERENCES specialties(specialty_id)
);

CREATE TABLE rooms (
    room_id INTEGER PRIMARY KEY,
    room_number TEXT NOT NULL UNIQUE,
    floor INTEGER NOT NULL CHECK (floor > 0)
);

CREATE TABLE appointments (
    appointment_id INTEGER PRIMARY KEY,
    patient_id INTEGER NOT NULL,
    doctor_id INTEGER NOT NULL,
    room_id INTEGER NOT NULL,
    appointment_datetime TEXT NOT NULL,
    status TEXT NOT NULL CHECK (
        status IN ('Запланирован', 'Завершён', 'Отменён')
    ),
    notes TEXT,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

CREATE TABLE diagnoses (
    diagnosis_id INTEGER PRIMARY KEY,
    icd_code TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    description TEXT
);

CREATE TABLE appointment_diagnoses (
    appointment_id INTEGER NOT NULL,
    diagnosis_id INTEGER NOT NULL,
    PRIMARY KEY (appointment_id, diagnosis_id),
    FOREIGN KEY (appointment_id)
        REFERENCES appointments(appointment_id),
    FOREIGN KEY (diagnosis_id)
        REFERENCES diagnoses(diagnosis_id)
);

CREATE TABLE prescriptions (
    prescription_id INTEGER PRIMARY KEY,
    appointment_id INTEGER NOT NULL,
    medication_name TEXT NOT NULL,
    dosage TEXT,
    instructions TEXT,
    FOREIGN KEY (appointment_id)
        REFERENCES appointments(appointment_id)
);
