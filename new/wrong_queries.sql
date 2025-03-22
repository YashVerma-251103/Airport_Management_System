-- -- SELECT 
-- --     f.Name AS Facility_Name,
-- --     r.Financial_Year,
-- --     r.Yearly_Revenue,
-- --     e.Name AS Employee_Name,
-- --     s.Shift_Date,
-- --     c.Customer_Name,
-- --     b.Date_Time AS Last_Booking_Date
-- -- FROM Facility f
-- -- LEFT JOIN Revenue r ON f.Facility_Id = r.Facility_Id
-- -- LEFT JOIN Staff_Schedule s ON f.Facility_Id = s.Facility_Id
-- -- LEFT JOIN Employee e ON s.Employee_Id = e.Employee_Id
-- -- LEFT JOIN Booking b ON f.Facility_Id = b.Facility_Id
-- -- LEFT JOIN Customer c ON b.Aadhaar_No = c.Aadhaar_No
-- -- WHERE r.Financial_Year >= 2020
-- -- ORDER BY r.Financial_Year DESC, r.Yearly_Revenue DESC;

-- WITH Facility_Performance AS (
--     SELECT 
--         f.Name AS Facility_Name,
--         r.Financial_Year,
--         COUNT(b.Booking_Id) AS Total_Bookings,
--         COALESCE(AVG(fe.Rating), 0) AS Avg_Rating,
--         COALESCE(SUM(r.Yearly_Revenue), 0) AS Total_Revenue
--     FROM Facility f
--     LEFT JOIN Booking b ON f.Facility_Id = b.Facility_Id
--     LEFT JOIN Feedback fe ON f.Facility_Id = fe.Facility_Id
--     LEFT JOIN Revenue r ON f.Facility_Id = r.Facility_Id
--     WHERE r.Financial_Year >= EXTRACT(YEAR FROM CURRENT_DATE) - 5
--     GROUP BY f.Name, r.Financial_Year
-- ),

-- Top_Employees AS (
--     SELECT 
--         s.Employee_Id,
--         e.Name AS Employee_Name,
--         COUNT(s.Schedule_Id) AS Shifts_Assigned,
--         SUM(CASE 
--             WHEN s.Task_Description ILIKE '%cleaning%' THEN 1 
--             ELSE 0 
--         END) AS Cleaning_Tasks
--     FROM Staff_Schedule s
--     JOIN Employee e ON s.Employee_Id = e.Employee_Id
--     GROUP BY s.Employee_Id, e.Name
--     HAVING COUNT(s.Schedule_Id) > 10
-- ),

-- High_Value_Customers AS (
--     SELECT 
--         c.Aadhaar_No,
--         c.Customer_Name,
--         COUNT(b.Booking_Id) AS Total_Bookings,
--         SUM(CASE 
--             WHEN b.Payment_Status = 'Completed' THEN 1 
--             ELSE 0 
--         END) AS Successful_Payments
--     FROM Customer c
--     JOIN Booking b ON c.Aadhaar_No = b.Aadhaar_No
--     GROUP BY c.Aadhaar_No, c.Customer_Name
--     HAVING COUNT(b.Booking_Id) > 5
-- )

-- SELECT 
--     fp.Facility_Name,
--     fp.Financial_Year,
--     fp.Total_Bookings,
--     fp.Avg_Rating,
--     fp.Total_Revenue,
--     te.Employee_Name AS Top_Employee,
--     te.Shifts_Assigned,
--     hc.Customer_Name AS High_Value_Customer,
--     hc.Total_Bookings
-- FROM Facility_Performance fp
-- LEFT JOIN Top_Employees te ON te.Employee_Id = (
--     SELECT Employee_Id FROM Staff_Schedule 
--     WHERE Shift_Date >= (CURRENT_DATE - INTERVAL '1 year')
--     ORDER BY Shift_Date DESC LIMIT 1
-- )
-- LEFT JOIN High_Value_Customers hc ON hc.Aadhaar_No = (
--     SELECT Aadhaar_No FROM Booking 
--     WHERE Date_Time >= (CURRENT_DATE - INTERVAL '1 year')
--     ORDER BY Date_Time DESC LIMIT 1
-- )
-- ORDER BY fp.Financial_Year DESC, fp.Total_Revenue DESC;




-- -- SCHEMA WAS ALREADY PROVIDED BEFORE THIS !

-- -- --1 -- GPT

-- -- PROMPT

-- -- No changes to the original schema is allowed. Now based on the original schema perform the following task.
-- -- Find the names of facilities that generate more than the average monthly revenue in the financial year 2022 and less than the average yearly revenue in the financial year 2023 order them in decreasing order of yearly revenue if values comes same order them in same way using monthly revenue. if the result is not empty then create a separate table if it does not exist and calculate the difference in the yearly revenues from average and also create a column if it does not exist in the facility table with name "fraud status", there would 5 values for this under suspicion , on notice, excomunicado, and time_notice. these will be determined whether the difference in yearly revenues is of a factor of their monthly revenue. if the difference is more than 10 times the monthly revenue of the facility then excomunicado, more than 7 times then time_notice, more than 5 times then notice, more than 3 times then under suspicion, else free.
-- -- now also make sure that if there was a facility whose status is not free then change the status appropriately based on the current calculation of the revenues. also link the columns appropriately.
-- -- Make a single SQL command for this.



-- -- RESULT

-- WITH Avg_Revenues AS (
--     SELECT 
--         (SELECT AVG(Monthly_Revenue) FROM Revenue WHERE Financial_Year = 2022) AS Avg_Monthly_2022,
--         (SELECT AVG(Yearly_Revenue) FROM Revenue WHERE Financial_Year = 2023) AS Avg_Yearly_2023
-- ),
-- Filtered_Facilities AS (
--     SELECT 
--         r.Facility_Id, 
--         f.Name AS Facility_Name, 
--         r.Monthly_Revenue, 
--         r.Yearly_Revenue, 
--         (r.Yearly_Revenue - (SELECT Avg_Yearly_2023 FROM Avg_Revenues)) AS Revenue_Difference
--     FROM Revenue r
--     JOIN Facility f ON r.Facility_Id = f.Facility_Id
--     WHERE r.Financial_Year = 2023
--     AND r.Monthly_Revenue > (SELECT Avg_Monthly_2022 FROM Avg_Revenues)
--     AND r.Yearly_Revenue < (SELECT Avg_Yearly_2023 FROM Avg_Revenues)
--     ORDER BY r.Yearly_Revenue DESC, r.Monthly_Revenue DESC
-- )
-- -- Ensure the table exists
-- CREATE TABLE IF NOT EXISTS Facility_Revenue_Analysis (
--     Facility_Id INT PRIMARY KEY,
--     Facility_Name VARCHAR(255),
--     Monthly_Revenue DECIMAL(10,2),
--     Yearly_Revenue DECIMAL(12,2),
--     Revenue_Difference DECIMAL(12,2),
--     Fraud_Status VARCHAR(20) CHECK (Fraud_Status IN ('under suspicion', 'on notice', 'excomunicado', 'time_notice', 'free')),
--     FOREIGN KEY (Facility_Id) REFERENCES Facility(Facility_Id) ON DELETE CASCADE
-- );

-- -- Ensure the fraud status column exists in Facility table
-- DO $$ 
-- BEGIN
--     IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='facility' AND column_name='fraud_status') THEN
--         ALTER TABLE Facility ADD COLUMN fraud_status VARCHAR(20) CHECK (fraud_status IN ('under suspicion', 'on notice', 'excomunicado', 'time_notice', 'free')) DEFAULT 'free';
--     END IF;
-- END $$;

-- -- Insert or update the Facility_Revenue_Analysis table with calculated values
-- INSERT INTO Facility_Revenue_Analysis (Facility_Id, Facility_Name, Monthly_Revenue, Yearly_Revenue, Revenue_Difference, Fraud_Status)
-- SELECT 
--     Facility_Id, 
--     Facility_Name, 
--     Monthly_Revenue, 
--     Yearly_Revenue, 
--     Revenue_Difference,
--     CASE 
--         WHEN Revenue_Difference > 10 * Monthly_Revenue THEN 'excomunicado'
--         WHEN Revenue_Difference > 7 * Monthly_Revenue THEN 'time_notice'
--         WHEN Revenue_Difference > 5 * Monthly_Revenue THEN 'on notice'
--         WHEN Revenue_Difference > 3 * Monthly_Revenue THEN 'under suspicion'
--         ELSE 'free'
--     END AS Fraud_Status
-- FROM Filtered_Facilities
-- ON CONFLICT (Facility_Id) DO UPDATE 
-- SET 
--     Facility_Name = EXCLUDED.Facility_Name,
--     Monthly_Revenue = EXCLUDED.Monthly_Revenue,
--     Yearly_Revenue = EXCLUDED.Yearly_Revenue,
--     Revenue_Difference = EXCLUDED.Revenue_Difference,
--     Fraud_Status = EXCLUDED.Fraud_Status;

-- -- Update Facility table's fraud_status accordingly
-- UPDATE Facility f
-- SET fraud_status = fa.Fraud_Status
-- FROM Facility_Revenue_Analysis fa
-- WHERE f.Facility_Id = fa.Facility_Id;




-- 2 -- Gemini

-- PROMPT

-- No changes to the original schema is allowed. Now based on the original schema perform the following task.
-- Find the names of facilities that generate more than the average monthly revenue in the financial year 2022 and less than the average yearly revenue in the financial year 2023 order them in decreasing order of yearly revenue if values comes same order them in same way using monthly revenue. if the result is not empty then create a separate table if it does not exist and calculate the difference in the yearly revenues from average and also create a column if it does not exist in the facility table with name "fraud status", there would 5 values for this under suspicion , on notice, excomunicado, and time_notice. these will be determined whether the difference in yearly revenues is of a factor of their monthly revenue. if the difference is more than 10 times the monthly revenue of the facility then excomunicado, more than 7 times then time_notice, more than 5 times then notice, more than 3 times then under suspicion, else free.
-- now also make sure that if there was a facility whose status is not free then change the status appropriately based on the current calculation of the revenues. also link the columns appropriately.
-- Make a single SQL command for this.



-- RESULT

-- 1. Find Facilities with Revenue Conditions

WITH FacilityRevenue AS (
    SELECT
        f.Facility_Id,
        f.Name AS Facility_Name,
        r2022.Monthly_Revenue AS Monthly_Revenue_2022,
        r2022.Yearly_Revenue AS Yearly_Revenue_2022,
        r2023.Yearly_Revenue AS Yearly_Revenue_2023
    FROM
        Facility f
    JOIN
        Revenue r2022 ON f.Facility_Id = r2022.Facility_Id AND r2022.Financial_Year = 2022
    JOIN
        Revenue r2023 ON f.Facility_Id = r2023.Facility_Id AND r2023.Financial_Year = 2023
),
AverageRevenue AS (
    SELECT
        AVG(Monthly_Revenue_2022) AS Avg_Monthly_2022,
        AVG(Yearly_Revenue_2023) AS Avg_Yearly_2023
    FROM
        FacilityRevenue
),
FilteredFacilities AS (
    SELECT
        fr.Facility_Id,
        fr.Facility_Name,
        fr.Monthly_Revenue_2022,
        fr.Yearly_Revenue_2022,
        fr.Yearly_Revenue_2023
    FROM
        FacilityRevenue fr, AverageRevenue ar
    WHERE
        fr.Monthly_Revenue_2022 > ar.Avg_Monthly_2022 AND fr.Yearly_Revenue_2023 < ar.Avg_Yearly_2023
    ORDER BY
        fr.Yearly_Revenue_2023 DESC, fr.Monthly_Revenue_2022 DESC
)

-- 2. Create and Populate Result Table (if needed)

SELECT * INTO temp_Revenue_Difference FROM (
    SELECT
        ff.Facility_Id,
        ff.Facility_Name,
        ff.Monthly_Revenue_2022,
        ff.Yearly_Revenue_2022,
        ff.Yearly_Revenue_2023,
        (ff.Yearly_Revenue_2023 - (SELECT AVG(Yearly_Revenue_2023) FROM FacilityRevenue)) AS Yearly_Revenue_Difference
    FROM
        FilteredFacilities ff
) as subQuery;

-- 3. Add Fraud Status Column (if needed) and Update Facility Table

ALTER TABLE Facility
ADD COLUMN IF NOT EXISTS Fraud_Status VARCHAR(20) CHECK (Fraud_Status IN ('Free', 'Under suspicion', 'Notice', 'Time_notice', 'Excomunicado'));

--4. Update Fraud Status Based on Revenue Difference

UPDATE Facility
SET Fraud_Status = 
    CASE
        WHEN temp_Revenue_Difference.Yearly_Revenue_Difference > 10 * temp_Revenue_Difference.Monthly_Revenue_2022 THEN 'Excomunicado'
        WHEN temp_Revenue_Difference.Yearly_Revenue_Difference > 7 * temp_Revenue_Difference.Monthly_Revenue_2022 THEN 'Time_notice'
        WHEN temp_Revenue_Difference.Yearly_Revenue_Difference > 5 * temp_Revenue_Difference.Monthly_Revenue_2022 THEN 'Notice'
        WHEN temp_Revenue_Difference.Yearly_Revenue_Difference > 3 * temp_Revenue_Difference.Monthly_Revenue_2022 THEN 'Under suspicion'
        ELSE 'Free'
    END
FROM temp_Revenue_Difference
WHERE Facility.Facility_Id = temp_Revenue_Difference.Facility_Id;

-- 5. Update Fraud status for any facility that may have been previously flagged.
UPDATE Facility
SET Fraud_Status = 
    CASE
        WHEN temp_Revenue_Difference.Yearly_Revenue_Difference > 10 * temp_Revenue_Difference.Monthly_Revenue_2022 THEN 'Excomunicado'
        WHEN temp_Revenue_Difference.Yearly_Revenue_Difference > 7 * temp_Revenue_Difference.Monthly_Revenue_2022 THEN 'Time_notice'
        WHEN temp_Revenue_Difference.Yearly_Revenue_Difference > 5 * temp_Revenue_Difference.Monthly_Revenue_2022 THEN 'Notice'
        WHEN temp_Revenue_Difference.Yearly_Revenue_Difference > 3 * temp_Revenue_Difference.Monthly_Revenue_2022 THEN 'Under suspicion'
        ELSE 'Free'
    END
FROM (SELECT Facility_Id, Yearly_Revenue_Difference, Monthly_Revenue_2022 FROM temp_Revenue_Difference) as temp_Revenue_Difference
WHERE Facility.Facility_Id = temp_Revenue_Difference.Facility_Id;

--6. Display the result.

SELECT * from temp_Revenue_Difference;