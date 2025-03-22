-- -- 2 -- Gemini

-- -- PROMPT

-- -- No changes to the original schema is allowed. Now based on the original schema perform the following task.
-- -- Find the names of facilities that generate more than the average monthly revenue in the financial year 2022 and less than the average yearly revenue in the financial year 2023 order them in decreasing order of yearly revenue if values comes same order them in same way using monthly revenue. if the result is not empty then create a separate table if it does not exist and calculate the difference in the yearly revenues from average and also create a column if it does not exist in the facility table with name "fraud status", there would 5 values for this under suspicion , on notice, excomunicado, and time_notice. these will be determined whether the difference in yearly revenues is of a factor of their monthly revenue. if the difference is more than 10 times the monthly revenue of the facility then excomunicado, more than 7 times then time_notice, more than 5 times then notice, more than 3 times then under suspicion, else free.
-- -- now also make sure that if there was a facility whose status is not free then change the status appropriately based on the current calculation of the revenues. also link the columns appropriately.
-- -- Make a single SQL command for this.



-- -- RESULT

-- -- 1. Find Facilities with Revenue Conditions

-- WITH FacilityRevenue AS (
--     SELECT
--         f.Facility_Id,
--         f.Name AS Facility_Name,
--         r2022.Monthly_Revenue AS Monthly_Revenue_2022,
--         r2022.Yearly_Revenue AS Yearly_Revenue_2022,
--         r2023.Yearly_Revenue AS Yearly_Revenue_2023
--     FROM
--         Facility f
--     JOIN
--         Revenue r2022 ON f.Facility_Id = r2022.Facility_Id AND r2022.Financial_Year = 2022
--     JOIN
--         Revenue r2023 ON f.Facility_Id = r2023.Facility_Id AND r2023.Financial_Year = 2023
-- ),
-- AverageRevenue AS (
--     SELECT
--         AVG(Monthly_Revenue_2022) AS Avg_Monthly_2022,
--         AVG(Yearly_Revenue_2023) AS Avg_Yearly_2023
--     FROM
--         FacilityRevenue
-- ),
-- FilteredFacilities AS (
--     SELECT
--         fr.Facility_Id,
--         fr.Facility_Name,
--         fr.Monthly_Revenue_2022,
--         fr.Yearly_Revenue_2022,
--         fr.Yearly_Revenue_2023
--     FROM
--         FacilityRevenue fr, AverageRevenue ar
--     WHERE
--         fr.Monthly_Revenue_2022 > ar.Avg_Monthly_2022 AND fr.Yearly_Revenue_2023 < ar.Avg_Yearly_2023
--     ORDER BY
--         fr.Yearly_Revenue_2023 DESC, fr.Monthly_Revenue_2022 DESC
-- )

-- -- 2. Create and Populate Result Table (if needed)

-- SELECT * INTO temp_Revenue_Difference FROM (
--     SELECT
--         ff.Facility_Id,
--         ff.Facility_Name,
--         ff.Monthly_Revenue_2022,
--         ff.Yearly_Revenue_2022,
--         ff.Yearly_Revenue_2023,
--         (ff.Yearly_Revenue_2023 - (SELECT AVG(Yearly_Revenue_2023) FROM FacilityRevenue)) AS Yearly_Revenue_Difference
--     FROM
--         FilteredFacilities ff
-- ) as subQuery;

-- -- 3. Add Fraud Status Column (if needed) and Update Facility Table

-- ALTER TABLE Facility
-- ADD COLUMN IF NOT EXISTS Fraud_Status VARCHAR(20) CHECK (Fraud_Status IN ('Free', 'Under suspicion', 'Notice', 'Time_notice', 'Excomunicado'));

-- --4. Update Fraud Status Based on Revenue Difference

-- UPDATE Facility
-- SET Fraud_Status = 
--     CASE
--         WHEN temp_Revenue_Difference.Yearly_Revenue_Difference > 10 * temp_Revenue_Difference.Monthly_Revenue_2022 THEN 'Excomunicado'
--         WHEN temp_Revenue_Difference.Yearly_Revenue_Difference > 7 * temp_Revenue_Difference.Monthly_Revenue_2022 THEN 'Time_notice'
--         WHEN temp_Revenue_Difference.Yearly_Revenue_Difference > 5 * temp_Revenue_Difference.Monthly_Revenue_2022 THEN 'Notice'
--         WHEN temp_Revenue_Difference.Yearly_Revenue_Difference > 3 * temp_Revenue_Difference.Monthly_Revenue_2022 THEN 'Under suspicion'
--         ELSE 'Free'
--     END
-- FROM temp_Revenue_Difference
-- WHERE Facility.Facility_Id = temp_Revenue_Difference.Facility_Id;

-- -- 5. Update Fraud status for any facility that may have been previously flagged.
-- UPDATE Facility
-- SET Fraud_Status = 
--     CASE
--         WHEN temp_Revenue_Difference.Yearly_Revenue_Difference > 10 * temp_Revenue_Difference.Monthly_Revenue_2022 THEN 'Excomunicado'
--         WHEN temp_Revenue_Difference.Yearly_Revenue_Difference > 7 * temp_Revenue_Difference.Monthly_Revenue_2022 THEN 'Time_notice'
--         WHEN temp_Revenue_Difference.Yearly_Revenue_Difference > 5 * temp_Revenue_Difference.Monthly_Revenue_2022 THEN 'Notice'
--         WHEN temp_Revenue_Difference.Yearly_Revenue_Difference > 3 * temp_Revenue_Difference.Monthly_Revenue_2022 THEN 'Under suspicion'
--         ELSE 'Free'
--     END
-- FROM (SELECT Facility_Id, Yearly_Revenue_Difference, Monthly_Revenue_2022 FROM temp_Revenue_Difference) as temp_Revenue_Difference
-- WHERE Facility.Facility_Id = temp_Revenue_Difference.Facility_Id;

-- --6. Display the result.

-- SELECT * from temp_Revenue_Difference;