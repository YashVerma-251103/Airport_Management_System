-- Create database if not exists
-- CREATE DATABASE test_ams;
-- \c test_ams;  -- Connect to the ams database

-- Drop existing tables
DROP TABLE IF EXISTS Inventory, Revenue, Feedback, Booking, Customer, Employee, Facility CASCADE;

-- Facility Table
CREATE TABLE Facility (
    Facility_Id SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Type VARCHAR(100) CHECK (Type IN ('Gym','Lounge','Restaurant','Shop','Other')),
    Location TEXT NOT NULL,
    Contact_No VARCHAR(15) NOT NULL CHECK (Contact_No ~ '^[0-9]+$'),
    Opening_Hours VARCHAR(50) NOT NULL,
    Manager_Id INT,
    FOREIGN KEY (Manager_Id) REFERENCES Employee(Employee_Id) ON DELETE SET NULL
);

-- Employee Table
CREATE TABLE Employee (
    Employee_Id SERIAL PRIMARY KEY,
    Assigned_Facility INT,
    Name VARCHAR(255) NOT NULL,
    Role VARCHAR(100) CHECK (Role IN ('Manager','Staff','Technician','Cleaner','Security')),
    Shift_Timings VARCHAR(50) NOT NULL,
    FOREIGN KEY (Assigned_Facility) REFERENCES Facility(Facility_Id) ON DELETE SET NULL
);

-- Customer Table
CREATE TABLE Customer (
    Aadhaar_No VARCHAR(20) PRIMARY KEY,
    Customer_Name VARCHAR(255) NOT NULL,
    Age INT CHECK (Age >= 0),
    Contact_No VARCHAR(15) NOT NULL CHECK (Contact_No ~ '^[0-9]+$')
);

-- Booking Table (Weak Entity)
CREATE TABLE Booking (
    Booking_Id SERIAL,
    Facility_Id INT,
    Aadhaar_No VARCHAR(20),
    PRIMARY KEY (Booking_Id, Facility_Id, Aadhaar_No),
    Employee_Id INT,
    Date_Time TIMESTAMP DEFAULT NOW(),
    Payment_Status VARCHAR(20) CHECK (Payment_Status IN ('Pending','Completed','Cancelled')),
    FOREIGN KEY (Facility_Id) REFERENCES Facility(Facility_Id) ON DELETE CASCADE,
    FOREIGN KEY (Aadhaar_No) REFERENCES Customer(Aadhaar_No) ON DELETE CASCADE,
    FOREIGN KEY (Employee_Id) REFERENCES Employee(Employee_Id) ON DELETE SET NULL
);

-- Feedback Table (Weak Entity)
CREATE TABLE Feedback (
    Feedback_Id SERIAL,
    Facility_Id INT,
    Aadhaar_No VARCHAR(20),
    PRIMARY KEY (Feedback_Id, Facility_Id, Aadhaar_No),
    Manager_Id INT,
    Date_Time TIMESTAMP DEFAULT NOW(),
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comments TEXT,
    FOREIGN KEY (Facility_Id) REFERENCES Facility(Facility_Id) ON DELETE CASCADE,
    FOREIGN KEY (Aadhaar_No) REFERENCES Customer(Aadhaar_No) ON DELETE CASCADE,
    FOREIGN KEY (Manager_Id) REFERENCES Employee(Employee_Id) ON DELETE SET NULL
);

-- Revenue Table (Weak Entity)
CREATE TABLE Revenue (
    Financial_Year INT CHECK (Financial_Year >= 1962),
    Facility_Id INT,
    PRIMARY KEY (Financial_Year, Facility_Id),
    Monthly_Revenue DECIMAL(10,2) CHECK (Monthly_Revenue >= 0),
    Yearly_Revenue DECIMAL(12,2) CHECK (Yearly_Revenue >= 0),
    FOREIGN KEY (Facility_Id) REFERENCES Facility(Facility_Id) ON DELETE CASCADE
);

-- Inventory Table (Weak Entity)
CREATE TABLE Inventory (
    Inventory_Id SERIAL,
    Facility_Id INT,
    PRIMARY KEY (Inventory_Id, Facility_Id),
    Item_Name VARCHAR(255) NOT NULL,
    Quantity INT CHECK (Quantity >= 0),
    Supplier VARCHAR(255),
    FOREIGN KEY (Facility_Id) REFERENCES Facility(Facility_Id) ON DELETE CASCADE
);
