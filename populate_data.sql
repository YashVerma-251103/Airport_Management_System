-- Disable Foreign Key Checks Temporarily (for bulk insert efficiency)
SET session_replication_role = 'replica';

-- Insert Employees (Including Managers)
INSERT INTO Employee (Employee_Id, Name, Role, Assigned_Facility, Shift_Timings) VALUES
(1, 'Alice Johnson', 'Manager', 1, '9 AM - 5 PM'),
(2, 'Bob Smith', 'Staff', 2, '8 AM - 4 PM'),
(3, 'Charlie Brown', 'Technician', 3, '10 AM - 6 PM'),
(4, 'David Wilson', 'Cleaner', 4, '6 AM - 2 PM'),
(5, 'Emily Davis', 'Security', 1, '7 AM - 3 PM'),
(6, 'Frank White', 'Staff', 2, '12 PM - 8 PM'),
(7, 'Grace Lee', 'Technician', 3, '2 PM - 10 PM'),
(8, 'Henry Adams', 'Manager', 4, '11 AM - 7 PM');

-- Insert Facilities (Assigning Managers)
INSERT INTO Facility (Facility_Id, Name, Type, Location, Contact_No, Opening_Hours, Manager_Id) VALUES
(1, 'Sky Gym', 'Gym', 'Terminal A - 2nd Floor', '1234567890', '6 AM - 10 PM', 1),
(2, 'Elite Lounge', 'Lounge', 'Terminal B - 1st Floor', '9876543210', '24 Hours', 2),
(3, 'Express Diner', 'Restaurant', 'Terminal C - Ground Floor', '1122334455', '7 AM - 11 PM', 3),
(4, 'FlyMart', 'Shop', 'Terminal D - Duty-Free', '5566778899', '6 AM - 12 AM', 4);

-- Insert Customers
INSERT INTO Customer (Aadhaar_No, Customer_Name, Age, Contact_No, Booking_Id) VALUES
('123456789012', 'Michael Scott', 35, '9998887776', 1),
('987654321098', 'Pam Beesly', 28, '8887776665', 2),
('564738291012', 'Jim Halpert', 32, '7776665554', 3),
('102938475601', 'Dwight Schrute', 36, '6665554443', 4),
('019283746509', 'Angela Martin', 30, '5554443332', 5);

-- Insert Bookings (Using Composite Primary Key)
INSERT INTO Booking (Booking_Id, Facility_Id, Aadhaar_No, Employee_Id, Date_Time, Payment_Status) VALUES
(1, 1, '123456789012', 1, '2025-02-15 10:00:00', 'Completed'),
(2, 2, '987654321098', 2, '2025-02-15 11:30:00', 'Pending'),
(3, 3, '564738291012', 3, '2025-02-15 13:00:00', 'Completed'),
(4, 4, '102938475601', 4, '2025-02-15 15:00:00', 'Cancelled'),
(5, 1, '019283746509', 5, '2025-02-15 17:00:00', 'Completed');

-- Insert Feedback (Using Composite Primary Key)
INSERT INTO Feedback (Feedback_Id, Facility_Id, Aadhaar_No, Manager_Id, Date_Time, Rating, Comments) VALUES
(1, 1, '123456789012', 1, '2025-02-15 12:00:00', 5, 'Great gym, well-maintained equipment.'),
(2, 2, '987654321098', 2, '2025-02-15 14:00:00', 4, 'Very comfortable lounge.'),
(3, 3, '564738291012', 3, '2025-02-15 16:00:00', 3, 'Food was okay, but service was slow.'),
(4, 4, '102938475601', 4, '2025-02-15 18:00:00', 2, 'Store was messy, not well organized.'),
(5, 1, '019283746509', 1, '2025-02-15 20:00:00', 5, 'Excellent personal training!');

-- Insert Revenue Data (Composite Primary Key)
INSERT INTO Revenue (Financial_Year, Facility_Id, Monthly_Revenue, Yearly_Revenue) VALUES
(2024, 1, 50000.00, 600000.00),
(2024, 2, 75000.00, 900000.00),
(2024, 3, 60000.00, 720000.00),
(2024, 4, 45000.00, 540000.00),
(2023, 1, 48000.00, 576000.00),
(2023, 2, 70000.00, 840000.00);

-- Insert Inventory Data (Using Composite Primary Key)
INSERT INTO Inventory (Inventory_Id, Facility_Id, Item_Name, Quantity, Supplier) VALUES
(1, 1, 'Treadmill', 5, 'Fitness Co.'),
(2, 1, 'Dumbbells Set', 10, 'Iron Strength'),
(3, 2, 'Lounge Chairs', 20, 'Airport Furnishers'),
(4, 2, 'Cushions', 15, 'Luxury Comforts'),
(5, 3, 'Coffee Machines', 3, 'BrewTech'),
(6, 3, 'Cooking Utensils', 10, 'Kitchen Experts'),
(7, 4, 'Duty-Free Perfumes', 50, 'Global Scents'),
(8, 4, 'Luxury Watches', 25, 'Swiss Timepieces');

-- Re-enable Foreign Key Checks
SET session_replication_role = 'origin';

-- Verify Data (Run this to check if data is inserted properly)
SELECT * FROM Employee;
SELECT * FROM Facility;
SELECT * FROM Customer;
SELECT * FROM Booking;
SELECT * FROM Feedback;
SELECT * FROM Revenue;
SELECT * FROM Inventory;
