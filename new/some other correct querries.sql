-- Some correct queries.


-- -- 1. Ensure the Facility table has a column for fraud status.
-- ALTER TABLE Facility
-- ADD COLUMN IF NOT EXISTS "fraud status" VARCHAR(20);

-- -- 2. Create a new table to store the facility revenue status details.
-- CREATE TABLE IF NOT EXISTS Facility_Revenue_Status (
--     Facility_Id INT PRIMARY KEY,
--     Name VARCHAR(255),
--     Yearly_Revenue_2023 DECIMAL(12,2),
--     Monthly_Revenue_2022 DECIMAL(10,2),
--     Avg_Yearly_Revenue_2023 DECIMAL(12,2),
--     Revenue_Difference DECIMAL(12,2),
--     Fraud_Status VARCHAR(20)
-- );

-- -- 3. Compute averages and select facilities that satisfy:
-- --    - Monthly_Revenue (2022) > average monthly revenue for 2022
-- --    - Yearly_Revenue (2023) < average yearly revenue for 2023
-- WITH avg_year AS (
--     SELECT AVG(Yearly_Revenue) AS avg_yearly_2023
--     FROM Revenue
--     WHERE Financial_Year = 2023
-- ),
-- selected_facilities AS (
--     SELECT 
--         f.Facility_Id,
--         f.Name,
--         r2023.Yearly_Revenue,
--         r2022.Monthly_Revenue,
--         ay.avg_yearly_2023,
--         (ay.avg_yearly_2023 - r2023.Yearly_Revenue) AS revenue_diff,
--         CASE
--             WHEN (ay.avg_yearly_2023 - r2023.Yearly_Revenue) > 10 * r2022.Monthly_Revenue THEN 'excomunicado'
--             WHEN (ay.avg_yearly_2023 - r2023.Yearly_Revenue) > 7 * r2022.Monthly_Revenue THEN 'time_notice'
--             WHEN (ay.avg_yearly_2023 - r2023.Yearly_Revenue) > 5 * r2022.Monthly_Revenue THEN 'notice'
--             WHEN (ay.avg_yearly_2023 - r2023.Yearly_Revenue) > 3 * r2022.Monthly_Revenue THEN 'under suspicion'
--             ELSE 'free'
--         END AS fraud_status
--     FROM Facility f
--     JOIN Revenue r2022 
--          ON f.Facility_Id = r2022.Facility_Id AND r2022.Financial_Year = 2022
--     JOIN Revenue r2023 
--          ON f.Facility_Id = r2023.Facility_Id AND r2023.Financial_Year = 2023
--     CROSS JOIN avg_year ay
--     WHERE r2022.Monthly_Revenue > (
--             SELECT AVG(Monthly_Revenue)
--             FROM Revenue
--             WHERE Financial_Year = 2022
--           )
--       AND r2023.Yearly_Revenue < ay.avg_yearly_2023
-- )
-- -- 4. Insert the selected facilities into the helper table, ordering as required.
-- INSERT INTO Facility_Revenue_Status (
--     Facility_Id, Name, Yearly_Revenue_2023, Monthly_Revenue_2022, 
--     Avg_Yearly_Revenue_2023, Revenue_Difference, Fraud_Status
-- )
-- SELECT 
--     Facility_Id, Name, Yearly_Revenue, Monthly_Revenue, 
--     avg_yearly_2023, revenue_diff, fraud_status
-- FROM selected_facilities
-- ORDER BY Yearly_Revenue DESC, Monthly_Revenue DESC;

-- -- 5. Update the Facility table with the new fraud status if the facility's status is not 'free'.
-- WITH updated_status AS (
--     SELECT Facility_Id, Fraud_Status
--     FROM Facility_Revenue_Status
--     WHERE Fraud_Status <> 'free'
-- )
-- UPDATE Facility f
-- SET "fraud status" = u.Fraud_Status
-- FROM updated_status u
-- WHERE f.Facility_Id = u.Facility_Id;





-- DO $$
-- DECLARE
--     v_count INTEGER;
-- BEGIN
--     -- 1. Ensure the Facility table has a column for fraud status.
--     EXECUTE 'ALTER TABLE Facility ADD COLUMN IF NOT EXISTS "fraud status" VARCHAR(20)';

--     -- 2. Create the helper table if it does not exist.
--     EXECUTE '
--       CREATE TABLE IF NOT EXISTS Facility_Revenue_Status (
--           Facility_Id INT PRIMARY KEY,
--           Name VARCHAR(255),
--           Yearly_Revenue_2023 DECIMAL(12,2),
--           Monthly_Revenue_2022 DECIMAL(10,2),
--           Avg_Yearly_Revenue_2023 DECIMAL(12,2),
--           Revenue_Difference DECIMAL(12,2),
--           Fraud_Status VARCHAR(20)
--       )';

--     -- 3. Compute averages and select facilities satisfying the conditions.
--     WITH avg_year AS (
--          SELECT AVG(Yearly_Revenue) AS avg_yearly_2023
--          FROM Revenue
--          WHERE Financial_Year = 2023
--     ),
--     avg_month AS (
--          SELECT AVG(Monthly_Revenue) AS avg_monthly_2022
--          FROM Revenue
--          WHERE Financial_Year = 2022
--     ),
--     selected_facilities AS (
--          SELECT 
--              f.Facility_Id,
--              f.Name,
--              r2023.Yearly_Revenue AS yearly_revenue,
--              r2022.Monthly_Revenue AS monthly_revenue,
--              ay.avg_yearly_2023,
--              (ay.avg_yearly_2023 - r2023.Yearly_Revenue) AS revenue_diff,
--              CASE
--                  WHEN (ay.avg_yearly_2023 - r2023.Yearly_Revenue) > 10 * r2022.Monthly_Revenue THEN 'excomunicado'
--                  WHEN (ay.avg_yearly_2023 - r2023.Yearly_Revenue) > 7 * r2022.Monthly_Revenue THEN 'time_notice'
--                  WHEN (ay.avg_yearly_2023 - r2023.Yearly_Revenue) > 5 * r2022.Monthly_Revenue THEN 'notice'
--                  WHEN (ay.avg_yearly_2023 - r2023.Yearly_Revenue) > 3 * r2022.Monthly_Revenue THEN 'under suspicion'
--                  ELSE 'free'
--              END AS fraud_status
--          FROM Facility f
--          JOIN Revenue r2022 
--               ON f.Facility_Id = r2022.Facility_Id AND r2022.Financial_Year = 2022
--          JOIN Revenue r2023 
--               ON f.Facility_Id = r2023.Facility_Id AND r2023.Financial_Year = 2023
--          CROSS JOIN avg_year ay
--          CROSS JOIN avg_month am
--          WHERE r2022.Monthly_Revenue > am.avg_monthly_2022
--            AND r2023.Yearly_Revenue < ay.avg_yearly_2023
--     )
--     SELECT COUNT(*) INTO v_count FROM selected_facilities;

--     -- 4. If the result is not empty, insert into the helper table and update Facility.
--     IF v_count > 0 THEN
--         INSERT INTO Facility_Revenue_Status (
--             Facility_Id, Name, Yearly_Revenue_2023, Monthly_Revenue_2022, 
--             Avg_Yearly_Revenue_2023, Revenue_Difference, Fraud_Status
--         )
--         SELECT 
--             Facility_Id, Name, yearly_revenue, monthly_revenue, 
--             avg_yearly_2023, revenue_diff, fraud_status
--         FROM selected_facilities
--         ORDER BY yearly_revenue DESC, monthly_revenue DESC;

--         UPDATE Facility f
--         SET "fraud status" = sf.fraud_status
--         FROM selected_facilities sf
--         WHERE f.Facility_Id = sf.Facility_Id
--           AND sf.fraud_status <> 'free';
--     END IF;
-- END
-- $$;




