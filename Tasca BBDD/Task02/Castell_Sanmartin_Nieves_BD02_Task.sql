CREATE DATABASE Gym;

USE Gym;

CREATE TABLE Client(
    ID_CLIENT INT PRIMARY KEY, -- 1.1. Unique identifier for this table.
    FIRSTNAME VARCHAR(50) NOT NULL,
    LASTNAME VARCHAR(50) NOT NULL,
    REGISTRATION_DATE DATE NOT NULL,
    EMAIL VARCHAR(50) UNIQUE NOT NULL, -- 1.4. Email cannot be repeated.
    PHONE_NUM INT(9) NOT NULL
);

CREATE TABLE Equipment(
    ID_EQUIPMENT INT PRIMARY KEY, -- 1.1. Unique identifier for this table.
    NAME VARCHAR(50) NOT NULL,
    BRAND VARCHAR (50) NOT NULL,
    CATEGORY VARCHAR (50) NOT NULL CHECK (CATEGORY IN ('Free Weight', 'Cardio', 'Strength')), -- 1.6. Values must be restricted to those three.
    AVAILABILITY BOOLEAN DEFAULT TRUE NOT NULL, -- 1.7. Availabily by default is true.
    QUANTITY INT CONSTRAINT min_quantity CHECK (QUANTITY > 0) NOT NULL -- 1.5. Quantity cannot be 0 or negative.
);

CREATE TABLE Rent(
    ID_RENT INT PRIMARY KEY, -- 1.1. Unique identifier for this table.
    ID_CLIENT INT NOT NULL,
    ID_EQUIPMENT INT NOT NULL,
    STARTDATE DATE NOT NULL,
    ENDDATE DATE, -- 1.8. Only end date can be empty.
    FOREIGN KEY (ID_CLIENT) REFERENCES Client (ID_CLIENT), -- 1.2. References Client table.
    FOREIGN KEY (ID_EQUIPMENT) REFERENCES Equipment (ID_EQUIPMENT) -- 1.3. References Equipment table.
);

ALTER TABLE Equipment ADD COLUMN TIER VARCHAR (10) CHECK (TIER IN ('Free', 'Normal', 'Premium')); -- 2.1. Create tier field in equipment.

ALTER TABLE Equipment DROP CONSTRAINT min_quantity; -- 2.2. Quantity must be equal to or grater than 3.
-- Asked AI if I could ALTER CONSTRAINT (?) or if I had to DROP first and ADD new constraint afterwards; 
-- also whether new constraint replaces old constraint or if they coexist (the latter happens).
ALTER TABLE Equipment ADD CONSTRAINT min_quantity CHECK (QUANTITY >= 3);

ALTER TABLE Client ADD CHECK (REGISTRATION_DATE > '2026-03-13'); -- 2.3. Registration date must be later than March 13th, 2026.

ALTER TABLE Rent ADD COLUMN STARTTIME TIME NOT NULL CONSTRAINT valid_time CHECK (STARTTIME BETWEEN '6:00:00' AND '21:00:00'); -- 2.4. Rental's start time must be between 6 AM and 9 PM.

ALTER TABLE Equipment DROP CONSTRAINT min_quantity; -- 2.5. Remove constraint on quantity.

ALTER TABLE Client DROP COLUMN PHONE_NUM; -- 2.6. Delete phone number.

ALTER TABLE Equipment ADD UNIQUE (Name); -- 2.7. Two equipments cannot have the same name.

ALTER TABLE Rent DROP PRIMARY KEY; -- 2.8. Change primary key to combination of identifier fields.
ALTER TABLE Rent ADD PRIMARY KEY (ID_CLIENT, ID_EQUIPMENT);

CREATE UNIQUE INDEX active_rent ON Rent (ID_CLIENT, ENDDATE); -- 2.9. One client can only have one equipment on use at a time. Create a unique index to validate that.

ALTER TABLE Client RENAME Member; -- 2.10. Rename client to member.

DROP TABLE Rent; -- 2.11. Remove rent.

CREATE USER 'Neus' IDENTIFIED BY '12345678'; -- 2.12. Create user and give SELECT and INSERT privileges to it.
GRANT SELECT, INSERT ON Equipment TO Neus;

-- -- -- -- -- -- -- -- -- -- --


SELECT * FROM Gym.Client; -- Visualize Client table
SELECT * FROM Gym.Equipment; -- Visualize Equipment table
SELECT * FROM Gym.Rent; -- Visualize Rent table
SELECT * FROM mysql.tables_priv; -- See users' privileges
