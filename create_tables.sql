-- Drop tables if they exist (to avoid conflicts when re-running the script)
DROP TABLE IF EXISTS Inventory, Revenue, Feedback, Booking, Customer, Employee, Facility CASCADE;

-- Creating Facility Table
CREATE TABLE Facility (
    Facility_Id SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Type VARCHAR(100) CHECK (Type IN ('Gym', 'Lounge', 'Restaurant', 'Shop', 'Other')),  -- Domain Constraint
    Location TEXT NOT NULL,
    Contact VARCHAR(15) NOT NULL CHECK (Contact ~ '^[0-9]+$'),  -- Only numbers allowed
    Opening_Hours VARCHAR(50) NOT NULL,
    Manager_Id INT,  -- FK from Employee
    CONSTRAINT fk_manager FOREIGN KEY (Manager_Id) REFERENCES Employee(Employee_Id) ON DELETE SET NULL
);

-- Creating Employee Table
CREATE TABLE Employee (
    Employee_Id SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Role VARCHAR(100) NOT NULL CHECK (Role IN ('Manager', 'Staff', 'Technician', 'Cleaner', 'Security')),  -- Domain Constraint
    Assigned_Facility INT,  -- FK from Facility
    Shift_Timings VARCHAR(50) NOT NULL,
    CONSTRAINT fk_assigned_facility FOREIGN KEY (Assigned_Facility) REFERENCES Facility(Facility_Id) ON DELETE SET NULL
);

-- Creating Booking Table (Weak Entity)
CREATE TABLE Booking (
    Booking_Id SERIAL PRIMARY KEY,
    Facility_Id INT NOT NULL,
    Aadhaar_Number VARCHAR(20) NOT NULL,  -- FK from Customer
    Employee_Id INT NOT NULL,  -- FK from Employee
    Date_Time TIMESTAMP NOT NULL DEFAULT NOW(),
    Payment_Status VARCHAR(20) CHECK (Payment_Status IN ('Pending', 'Completed', 'Cancelled')),  -- Domain Constraint
    CONSTRAINT fk_booking_facility FOREIGN KEY (Facility_Id) REFERENCES Facility(Facility_Id) ON DELETE CASCADE,
    CONSTRAINT fk_booking_employee FOREIGN KEY (Employee_Id) REFERENCES Employee(Employee_Id) ON DELETE SET NULL
);

-- Creating Customer Table (Weak Entity)
CREATE TABLE Customer (
    Aadhaar_No VARCHAR(20) PRIMARY KEY,
    Customer_Name VARCHAR(255) NOT NULL,
    Age INT CHECK (Age >= 18),  -- Constraint: Only adults can book
    Contact_No VARCHAR(15) NOT NULL CHECK (Contact_No ~ '^[0-9]+$'),
    Booking_Id INT NOT NULL,  -- FK from Booking
    CONSTRAINT fk_customer_booking FOREIGN KEY (Booking_Id) REFERENCES Booking(Booking_Id) ON DELETE CASCADE
);

-- Creating Feedback Table
CREATE TABLE Feedback (
    Feedback_Id SERIAL PRIMARY KEY,
    Facility_Id INT NOT NULL,
    Aadhaar_Number VARCHAR(20) NOT NULL,
    Manager_Id INT NOT NULL,
    Date_Time TIMESTAMP NOT NULL DEFAULT NOW(),
    Rating INT CHECK (Rating BETWEEN 1 AND 5),  -- Constraint: Rating should be between 1-5
    Comments TEXT,
    CONSTRAINT fk_feedback_facility FOREIGN KEY (Facility_Id) REFERENCES Facility(Facility_Id) ON DELETE CASCADE,
    CONSTRAINT fk_feedback_customer FOREIGN KEY (Aadhaar_Number) REFERENCES Customer(Aadhaar_No) ON DELETE CASCADE,
    CONSTRAINT fk_feedback_manager FOREIGN KEY (Manager_Id) REFERENCES Employee(Employee_Id) ON DELETE SET NULL
);

-- Creating Revenue Table
CREATE TABLE Revenue (
    Financial_Year INT CHECK (Financial_Year BETWEEN 2000 AND 2100),  -- Constraint: Year should be realistic
    Facility_Id INT NOT NULL,
    Monthly_Revenue DECIMAL(10,2) CHECK (Monthly_Revenue >= 0),  -- Constraint: Revenue cannot be negative
    Yearly_Revenue DECIMAL(12,2) CHECK (Yearly_Revenue >= 0),
    PRIMARY KEY (Financial_Year, Facility_Id),
    CONSTRAINT fk_revenue_facility FOREIGN KEY (Facility_Id) REFERENCES Facility(Facility_Id) ON DELETE CASCADE
);

-- Creating Inventory Table
CREATE TABLE Inventory (
    Inventory_Id SERIAL PRIMARY KEY,
    Facility_Id INT NOT NULL,
    Item_Name VARCHAR(255) NOT NULL,
    Quantity INT CHECK (Quantity >= 0),  -- Constraint: Quantity cannot be negative
    Supplier VARCHAR(255),
    CONSTRAINT fk_inventory_facility FOREIGN KEY (Facility_Id) REFERENCES Facility(Facility_Id) ON DELETE CASCADE
);
