--1. Can you find out the total milk production for 2023? 
--Your manager wants this information for the yearly report.
--What is the total milk production for 2023?

SELECT
SUM(Value)
FROM
milk_production
WHERE Year = 2023;

--Result = 91,812,000,000

--2. Which states had cheese production greater than 100 million in April 2023?
--The Cheese Department wants to focus their marketing efforts there.
--How many states are there?

SELECT
distinct State_ANSI
FROM
cheese_production
WHERE Year = 2023 AND Period = 'APR' AND Value > 100000000;

--Result = 14 states, however one result lacks a State_ANSI - therefore, I'm putting 13.

--3. Your manager wants to know how coffee production has changed over the years.
--What is the total value of coffee produciton for 2011?

SELECT
Year,
SUM(Value)
FROM
coffee_production
GROUP BY Year;

--Result = 7,600,000. This is also presents coffee production over the years instead of just giving us 2011.

--4. There's a meeting with the Honey Council next week. 
--Find the average honey productin for 2022 so you're prepared.

SELECT
AVG(Value)
FROM
honey_production
WHERE Year = 2022;

--Result = 3,133,275.

--5. The State Relations team wants a list of all states names with their corresponding ANSI codes.
--Can you generate that list?
--What is the State_ANSI code for Florida?

SELECT
*
FROM
state_lookup;

--Results = Whole list appears. A quick scan shows the State_ANSI code for Florida is 12.
--Can be narrowed down with a where statement.

--6. For a cross-commodity report, can you list all states with their cheese production values,
--even if they didn't produce any cheese in April of 2023?
--What is the total for NEW JERSEY?

SELECT
sl.State,
SUM(cp.Value)
FROM
state_lookup sl LEFT JOIN cheese_production cp
ON sl.State_ANSI = cp.State_ANSI
GROUP BY sl.State

--All states are now listed even if they didn't produce cheese in April of 2023. I would get more clarity if this was what they
--really intended, or if they wanted this information to pertain to April 2023 only. We grouped results by state, and summed
--the cheese production value. When looking through the list, you we can see that New Jersey produced 2,069,941,000 cheese.

--7. Can you find the total yogurt production for states in the year 2022 which also have cheese production
--data from 2023? This will help the Dairy Division in their planning.

SELECT 
SUM(yp.Value) AS Total_Yogurt_Production
FROM 
yogurt_production yp
WHERE yp.Year = 2022
AND yp.State_ANSI IN (
    SELECT DISTINCT cp.State_ANSI
    FROM cheese_production cp
    WHERE cp.Year = 2023
);

--Results = 1,171,095,000. Here we have SUM the yogurt production value that is found in year 2022, and where the State.ANSI
--Matches the State_ANSI from cheese production where the year is 2023.

--8. List all states from state_lookup that are missing from milk_production in 2023.
--How many states are there?

SELECT
COUNT(*) as States_Missing_From_Milk_Production_In_2023
FROM state_lookup sl LEFT JOIN milk_production mp
ON sl.State_ANSI = mp.State_ANSI 
AND mp.Year = 2023 
WHERE mp.Value IS NULL;

--Results = 26. We have used a LEFT JOIN to return all results from state_lookup, as well as all results from milk_production
--incuding those that are not matching. And then we specifed that these results must be from the year 2023 only. And then we
--specified further to see nulls only. Then we used the count function to count how many states are listed.

--9. List all states with their cheese production values, includign states that didn't produce any cheese in April 2023.
--Did Delaware produce any chees in April 2023?

SELECT
*
FROM state_lookup sl LEFT JOIN cheese_production cp
ON sl.State_ANSI = cp.State_ANSI
AND cp.Year = 2023 AND cp.Period = 'APR'
WHERE sl.State = 'DELAWARE'

--Results = No. We returned all results for state_lookup for the year 2023 and the period APR where the state was DELAWARE
--And the return value was Null.

--10. Find the average coffee production for all years where the honey production exceeded 1 million.

SELECT
AVG(Value)
FROM
coffee_production
WHERE Year IN (SELECT Year 
	FROM honey_production
	WHERE Value > 1000000);
	
--Results = 6,426,666.666666667. This query returns the avg value of coffee production where the year matches the years of honey
--production where the Value > 1 million.
