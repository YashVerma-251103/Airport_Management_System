-- 1. Employee Table Inserts
INSERT INTO Employee (Name, Role, Shift_Timings) VALUES
('Alice Johnson', 'Manager', '09:00-17:00'),
('Bob Smith', 'Staff', '10:00-18:00'),
('Carol White', 'Technician', '08:00-16:00'),
('David Brown', 'Cleaner', '07:00-15:00'),
('Eva Green', 'Security', '12:00-20:00'),
('Frank Black', 'Authority', '11:00-19:00');

-- 2. Facility Table Inserts
-- Assuming Employee IDs are auto-assigned sequentially, so Alice (id=1) and Frank (id=6) are used as managers.
INSERT INTO Facility (Name, Type, Location, Contact_No, Opening_Hours, Manager_Id) VALUES
('Downtown Gym', 'Gym', '123 Main St', '1234567890', '06:00-22:00', 1),
('Airport Lounge', 'Lounge', 'Airport Terminal 1', '0987654321', '05:00-23:00', 1),
('Skyline Restaurant', 'Restaurant', '456 Elm St', '1122334455', '10:00-22:00', 2),
('City Shop', 'Shop', '789 Oak St', '2233445566', '09:00-21:00', NULL),
('Central Park Facility', 'Other', 'Central Park, NYC', '3344556677', 'Open 24 Hours', 6);

-- 3. Customer Table Inserts
INSERT INTO Customer (Aadhaar_No, Customer_Name, Age, Contact_No) VALUES
('111122223333', 'John Doe', 30, '5551112222'),
('444455556666', 'Jane Roe', 25, '5553334444'),
('777788889999', 'Sam Smith', 40, '5555556666');

-- 4. Booking Table Inserts
-- Note: Composite primary key is (Booking_Id, Facility_Id, Aadhaar_No). We allow Booking_Id to auto-increment.
INSERT INTO Booking (Facility_Id, Aadhaar_No, Employee_Id, Date_Time, Payment_Status) VALUES
(1, '111122223333', 2, '2025-03-15 10:30:00', 'Completed'),
(2, '444455556666', 2, '2025-03-16 14:00:00', 'Pending'),
(3, '777788889999', 3, '2025-03-17 18:45:00', 'Cancelled'),
(1, '444455556666', 4, '2025-03-18 09:15:00', 'Completed'),
(5, '111122223333', 1, '2025-03-19 12:00:00', 'Pending');

-- 5. Feedback Table Inserts
-- Composite primary key: (Feedback_Id, Facility_Id, Aadhaar_No, Manager_Id)
INSERT INTO Feedback (Facility_Id, Aadhaar_No, Manager_Id, Date_Time, Rating, Comments) VALUES
(1, '111122223333', 1, '2025-03-16 11:00:00', 5, 'Excellent service and facilities.'),
(2, '444455556666', 1, '2025-03-17 15:30:00', 4, 'Comfortable lounge with timely assistance.'),
(3, '777788889999', 2, '2025-03-18 20:45:00', 3, 'Food quality was average, could be improved.'),
(5, '111122223333', 6, '2025-03-19 13:00:00', 4, 'Great ambiance but slightly crowded.');

-- 6. Revenue Table Inserts
INSERT INTO Revenue (Financial_Year, Facility_Id, Monthly_Revenue, Yearly_Revenue) VALUES
(2023, 1, 10000.00, 120000.00),
(2023, 2, 15000.00, 180000.00),
(2023, 3, 8000.00, 96000.00),
(2022, 1, 9000.00, 108000.00),
(2022, 5, 20000.00, 240000.00);

-- 7. Inventory Table Inserts
INSERT INTO Inventory (Facility_Id, Item_Name, Quantity, Supplier) VALUES
(1, 'Treadmills', 5, 'FitnessSuppliers Inc.'),
(1, 'Dumbbells', 50, 'GymEquip Co.'),
(2, 'Sofas', 10, 'Comfort Furnishings'),
(3, 'Tableware', 100, 'Culinary Supplies Ltd.'),
(4, 'Merchandise', 200, 'Retail Wholesale'),
(5, 'First Aid Kits', 20, 'Medical Essentials');

-- 8. Flight Table Inserts
INSERT INTO Flight (Flight_Number, Airline, Departure_Time, Arrival_Time, Status, Gate, Terminal) VALUES
('AA101', 'AirAlpha', '2025-03-20 06:00:00', '2025-03-20 08:30:00', 'On Time', 'A1', 'T1'),
('BB202', 'BetaAir', '2025-03-20 09:00:00', '2025-03-20 11:45:00', 'Delayed', 'B2', 'T2'),
('CC303', 'GammaFly', '2025-03-20 12:15:00', '2025-03-20 14:45:00', 'Cancelled', 'C3', 'T3'),
('DD404', 'DeltaWings', '2025-03-20 15:00:00', '2025-03-20 17:30:00', 'Departed', 'D4', 'T4'),
('EE505', 'EpsilonAir', '2025-03-20 18:00:00', '2025-03-20 20:30:00', 'Arrived', 'E5', 'T5');

-- 9. Staff_Schedule Table Inserts
INSERT INTO Staff_Schedule (Employee_Id, Shift_Date, Shift_Start, Shift_End, Task_Description, Created_At) VALUES
(2, '2025-03-20', '10:00:00', '18:00:00', 'Manage front-desk operations', '2025-03-15 09:00:00'),
(3, '2025-03-20', '08:00:00', '16:00:00', 'Oversee technical maintenance', '2025-03-15 09:15:00'),
(4, '2025-03-20', '07:00:00', '15:00:00', 'General cleaning duties', '2025-03-15 09:30:00'),
(5, '2025-03-20', '12:00:00', '20:00:00', 'Security monitoring', '2025-03-15 09:45:00'),
(1, '2025-03-20', '09:00:00', '17:00:00', 'Facility management oversight', '2025-03-15 10:00:00');

-- 10. Communication Table Inserts
INSERT INTO Communication (Sender_Id, Receiver_Id, Message_Type, Message, Sent_At) VALUES
(1, 2, 'Alert', 'Please review the facility maintenance report.', '2025-03-16 08:00:00'),
(2, 3, 'Notice', 'Scheduled system update tonight at 22:00.', '2025-03-16 12:00:00'),
(3, 4, 'Message', 'Requesting extra cleaning supplies in the storage.', '2025-03-16 14:30:00'),
(5, 1, 'Alert', 'Security breach attempt detected in the lounge.', '2025-03-16 16:45:00');

-- 11. Incident Table Inserts
INSERT INTO Incident (Reported_By, Facility_Id, Description, Status, Reported_At, Resolved_At) VALUES
(2, 1, 'Equipment malfunction in the gym area.', 'Reported', '2025-03-16 09:30:00', NULL),
(3, 2, 'Air conditioning failure in the lounge.', 'In Progress', '2025-03-16 11:00:00', NULL),
(4, 3, 'Spillage in the restaurant kitchen causing a slip hazard.', 'Resolved', '2025-03-16 12:15:00', '2025-03-16 13:00:00'),
(5, NULL, 'Suspicious activity reported near the facility entrance.', 'Reported', '2025-03-16 15:20:00', NULL);
