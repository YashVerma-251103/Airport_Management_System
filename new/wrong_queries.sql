



-- SCHEMA WAS ALREADY PROVIDED BEFORE THIS !

-- --1 -- GPT

-- PROMPT

-- No changes to the original schema is allowed. Now based on the original schema perform the following task.
-- Find the names of facilities that generate more than the average monthly revenue in the financial year 2022 and less than the average yearly revenue in the financial year 2023 order them in decreasing order of yearly revenue if values comes same order them in same way using monthly revenue. if the result is not empty then create a separate table if it does not exist and calculate the difference in the yearly revenues from average and also create a column if it does not exist in the facility table with name "fraud status", there would 5 values for this under suspicion , on notice, excomunicado, and time_notice. these will be determined whether the difference in yearly revenues is of a factor of their monthly revenue. if the difference is more than 10 times the monthly revenue of the facility then excomunicado, more than 7 times then time_notice, more than 5 times then notice, more than 3 times then under suspicion, else free.
-- now also make sure that if there was a facility whose status is not free then change the status appropriately based on the current calculation of the revenues. also link the columns appropriately.
-- Make a single SQL command for this.



-- RESULT

WITH Avg_Revenues AS (
    SELECT 
        (SELECT AVG(Monthly_Revenue) FROM Revenue WHERE Financial_Year = 2022) AS Avg_Monthly_2022,
        (SELECT AVG(Yearly_Revenue) FROM Revenue WHERE Financial_Year = 2023) AS Avg_Yearly_2023
),
Filtered_Facilities AS (
    SELECT 
        r.Facility_Id, 
        f.Name AS Facility_Name, 
        r.Monthly_Revenue, 
        r.Yearly_Revenue, 
        (r.Yearly_Revenue - (SELECT Avg_Yearly_2023 FROM Avg_Revenues)) AS Revenue_Difference
    FROM Revenue r
    JOIN Facility f ON r.Facility_Id = f.Facility_Id
    WHERE r.Financial_Year = 2023
    AND r.Monthly_Revenue > (SELECT Avg_Monthly_2022 FROM Avg_Revenues)
    AND r.Yearly_Revenue < (SELECT Avg_Yearly_2023 FROM Avg_Revenues)
    ORDER BY r.Yearly_Revenue DESC, r.Monthly_Revenue DESC
)
-- Ensure the table exists
CREATE TABLE IF NOT EXISTS Facility_Revenue_Analysis (
    Facility_Id INT PRIMARY KEY,
    Facility_Name VARCHAR(255),
    Monthly_Revenue DECIMAL(10,2),
    Yearly_Revenue DECIMAL(12,2),
    Revenue_Difference DECIMAL(12,2),
    Fraud_Status VARCHAR(20) CHECK (Fraud_Status IN ('under suspicion', 'on notice', 'excomunicado', 'time_notice', 'free')),
    FOREIGN KEY (Facility_Id) REFERENCES Facility(Facility_Id) ON DELETE CASCADE
);

-- Ensure the fraud status column exists in Facility table
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='facility' AND column_name='fraud_status') THEN
        ALTER TABLE Facility ADD COLUMN fraud_status VARCHAR(20) CHECK (fraud_status IN ('under suspicion', 'on notice', 'excomunicado', 'time_notice', 'free')) DEFAULT 'free';
    END IF;
END $$;

-- Insert or update the Facility_Revenue_Analysis table with calculated values
INSERT INTO Facility_Revenue_Analysis (Facility_Id, Facility_Name, Monthly_Revenue, Yearly_Revenue, Revenue_Difference, Fraud_Status)
SELECT 
    Facility_Id, 
    Facility_Name, 
    Monthly_Revenue, 
    Yearly_Revenue, 
    Revenue_Difference,
    CASE 
        WHEN Revenue_Difference > 10 * Monthly_Revenue THEN 'excomunicado'
        WHEN Revenue_Difference > 7 * Monthly_Revenue THEN 'time_notice'
        WHEN Revenue_Difference > 5 * Monthly_Revenue THEN 'on notice'
        WHEN Revenue_Difference > 3 * Monthly_Revenue THEN 'under suspicion'
        ELSE 'free'
    END AS Fraud_Status
FROM Filtered_Facilities
ON CONFLICT (Facility_Id) DO UPDATE 
SET 
    Facility_Name = EXCLUDED.Facility_Name,
    Monthly_Revenue = EXCLUDED.Monthly_Revenue,
    Yearly_Revenue = EXCLUDED.Yearly_Revenue,
    Revenue_Difference = EXCLUDED.Revenue_Difference,
    Fraud_Status = EXCLUDED.Fraud_Status;

-- Update Facility table's fraud_status accordingly
UPDATE Facility f
SET fraud_status = fa.Fraud_Status
FROM Facility_Revenue_Analysis fa
WHERE f.Facility_Id = fa.Facility_Id;




