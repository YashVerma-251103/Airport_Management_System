-- Disable Foreign Key Checks Temporarily (for bulk insert efficiency)
SET session_replication_role = 'replica';

-- Insert Employees (Including Managers)
INSERT INTO Employee (Name, Role, Shift_Timings) VALUES
('Alice Johnson', 'Manager', '9 AM - 5 PM'),
('Bob Smith', 'Staff', '8 AM - 4 PM'),
('Charlie Brown', 'Technician', '10 AM - 6 PM'),
('David Wilson', 'Cleaner', '6 AM - 2 PM'),
('Emily Davis', 'Security', '7 AM - 3 PM');

-- Insert Facilities (Assigning Managers)
INSERT INTO Facility (Name, Type, Location, Contact, Opening_Hours, Manager_Id) VALUES
('Sky Gym', 'Gym', 'Terminal A - 2nd Floor', '1234567890', '6 AM - 10 PM', 1),
('Elite Lounge', 'Lounge', 'Terminal B - 1st Floor', '9876543210', '24 Hours', 2),
('Express Diner', 'Restaurant', 'Terminal C - Ground Floor', '1122334455', '7 AM - 11 PM', 3),
('FlyMart', 'Shop', 'Terminal D - Duty-Free', '5566778899', '6 AM - 12 AM', 4);

-- Update Employees with Assigned Facility
UPDATE Employee 
SET Assigned_Facility = 1 WHERE Name = 'Alice Johnson';
UPDATE Employee 
SET Assigned_Facility = 2 WHERE Name = 'Bob Smith';
UPDATE Employee 
SET Assigned_Facility = 3 WHERE Name = 'Charlie Brown';

-- Insert Customers
INSERT INTO Customer (Aadhaar_No, Customer_Name, Age, Contact_No, Booking_Id) VALUES
('123456789012', 'Michael Scott', 35, '9998887776', 1),
('987654321098', 'Pam Beesly', 28, '8887776665', 2),
('564738291012', 'Jim Halpert', 32, '7776665554', 3),
('102938475601', 'Dwight Schrute', 36, '6665554443', 4);

-- Insert Bookings
INSERT INTO Booking (Facility_Id, Aadhaar_Number, Employee_Id, Date_Time, Payment_Status) VALUES
(1, '123456789012', 1, '2025-02-15 10:00:00', 'Completed'),
(2, '987654321098', 2, '2025-02-15 11:30:00', 'Pending'),
(3, '564738291012', 3, '2025-02-15 13:00:00', 'Completed'),
(4, '102938475601', 4, '2025-02-15 15:00:00', 'Cancelled');

-- Insert Feedback
INSERT INTO Feedback (Facility_Id, Aadhaar_Number, Manager_Id, Date_Time, Rating, Comments) VALUES
(1, '123456789012', 1, '2025-02-15 12:00:00', 5, 'Great gym, well-maintained equipment.'),
(2, '987654321098', 2, '2025-02-15 14:00:00', 4, 'Very comfortable lounge.'),
(3, '564738291012', 3, '2025-02-15 16:00:00', 3, 'Food was okay, but service was slow.'),
(4, '102938475601', 4, '2025-02-15 18:00:00', 2, 'Store was messy, not well organized.');

-- Insert Revenue
INSERT INTO Revenue (Financial_Year, Facility_Id, Monthly_Revenue, Yearly_Revenue) VALUES
(2024, 1, 50000.00, 600000.00),
(2024, 2, 75000.00, 900000.00),
(2024, 3, 60000.00, 720000.00),
(2024, 4, 45000.00, 540000.00);

-- Insert Inventory Items
INSERT INTO Inventory (Facility_Id, Item_Name, Quantity, Supplier) VALUES
(1, 'Treadmill', 5, 'Fitness Co.'),
(2, 'Lounge Chairs', 20, 'Airport Furnishers'),
(3, 'Coffee Machines', 3, 'BrewTech'),
(4, 'Duty-Free Perfumes', 50, 'Global Scents');

-- Re-enable Foreign Key Checks
SET session_replication_role = 'origin';

-- Verify Data
SELECT * FROM Employee;
SELECT * FROM Facility;
SELECT * FROM Customer;
SELECT * FROM Booking;
SELECT * FROM Feedback;
SELECT * FROM Revenue;
SELECT * FROM Inventory;
