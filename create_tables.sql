-- Drop tables in the correct order (Reverse Dependency)
DROP TABLE IF EXISTS Inventory, Revenue, Feedback, Booking, Customer, Facility, Employee CASCADE;

-- Creating Employee Table (First, since Facility references it)
CREATE TABLE Employee (
    Employee_Id SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Role VARCHAR(100) NOT NULL CHECK (Role IN ('Manager', 'Staff', 'Technician', 'Cleaner', 'Security')),
    Shift_Timings VARCHAR(50) NOT NULL
);

-- Creating Facility Table (After Employee, so Manager_Id can reference it)
CREATE TABLE Facility (
    Facility_Id SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Type VARCHAR(100) CHECK (Type IN ('Gym', 'Lounge', 'Restaurant', 'Shop', 'Other')),
    Location TEXT NOT NULL,
    Contact_No VARCHAR(15) NOT NULL CHECK (Contact_No ~ '^[0-9]+$'),
    Opening_Hours VARCHAR(50) NOT NULL,
    Manager_Id INT,
    CONSTRAINT fk_manager FOREIGN KEY (Manager_Id) REFERENCES Employee(Employee_Id) ON DELETE SET NULL
);

-- Creating Customer Table (No Dependencies)
CREATE TABLE Customer (
    Aadhaar_No VARCHAR(20) PRIMARY KEY,
    Customer_Name VARCHAR(255) NOT NULL,
    Age INT CHECK (Age >= 0),
    Contact_No VARCHAR(15) NOT NULL CHECK (Contact_No ~ '^[0-9]+$')
);

-- Creating Booking Table (Weak Entity with Composite Primary Key)
CREATE TABLE Booking (
    Booking_Id SERIAL PRIMARY KEY,
    Facility_Id INT NOT NULL,
    Aadhaar_No VARCHAR(20) NOT NULL,
    Employee_Id INT NOT NULL,
    Date_Time TIMESTAMP NOT NULL DEFAULT NOW(),
    Payment_Status VARCHAR(20) CHECK (Payment_Status IN ('Pending', 'Completed', 'Cancelled')),
    CONSTRAINT fk_booking_facility FOREIGN KEY (Facility_Id) REFERENCES Facility(Facility_Id) ON DELETE CASCADE,
    CONSTRAINT fk_booking_customer FOREIGN KEY (Aadhaar_No) REFERENCES Customer(Aadhaar_No) ON DELETE CASCADE,
    CONSTRAINT fk_booking_employee FOREIGN KEY (Employee_Id) REFERENCES Employee(Employee_Id) ON DELETE SET NULL
);

-- Creating Feedback Table (Weak Entity with Composite Primary Key)
CREATE TABLE Feedback (
    Feedback_Id SERIAL PRIMARY KEY,
    Facility_Id INT NOT NULL,
    Aadhaar_No VARCHAR(20) NOT NULL,
    Manager_Id INT NOT NULL,
    Date_Time TIMESTAMP NOT NULL DEFAULT NOW(),
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comments TEXT,
    CONSTRAINT fk_feedback_facility FOREIGN KEY (Facility_Id) REFERENCES Facility(Facility_Id) ON DELETE CASCADE,
    CONSTRAINT fk_feedback_customer FOREIGN KEY (Aadhaar_No) REFERENCES Customer(Aadhaar_No) ON DELETE CASCADE,
    CONSTRAINT fk_feedback_manager FOREIGN KEY (Manager_Id) REFERENCES Employee(Employee_Id) ON DELETE SET NULL
);

-- Creating Revenue Table (Composite Primary Key)
CREATE TABLE Revenue (
    Financial_Year INT CHECK (Financial_Year >= 1962),
    Facility_Id INT NOT NULL,
    Monthly_Revenue DECIMAL(10,2) CHECK (Monthly_Revenue >= 0),
    Yearly_Revenue DECIMAL(12,2) CHECK (Yearly_Revenue >= 0),
    PRIMARY KEY (Financial_Year, Facility_Id),
    CONSTRAINT fk_revenue_facility FOREIGN KEY (Facility_Id) REFERENCES Facility(Facility_Id) ON DELETE CASCADE
);

-- Creating Inventory Table (Composite Primary Key)
CREATE TABLE Inventory (
    Inventory_Id SERIAL PRIMARY KEY,
    Facility_Id INT NOT NULL,
    Item_Name VARCHAR(255) NOT NULL,
    Quantity INT CHECK (Quantity >= 0),
    Supplier VARCHAR(255),
    PRIMARY KEY (Inventory_Id, Facility_Id),
    CONSTRAINT fk_inventory_facility FOREIGN KEY (Facility_Id) REFERENCES Facility(Facility_Id) ON DELETE CASCADE
);
