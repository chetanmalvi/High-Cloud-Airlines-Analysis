Use Airlines;
show tables;
Select * from maindata;
 
 select * from maindata limit 5;
 select count(*) from maindata;
 select count(*) from `flight types`;
 Describe maindata;

ALTER TABLE maindata 
RENAME COLUMN `# Available Seats` TO Available_Seats;
ALTER TABLE maindata 
RENAME COLUMN `From - To City` TO From_To_City;
ALTER TABLE maindata 
RENAME COLUMN `Carrier Name` TO Carrier_Name;
ALTER TABLE maindata 
RENAME COLUMN `# Transported Passengers` TO transported_passengers;
ALTER TABLE maindata 
RENAME COLUMN `%Distance Group ID` TO Distance_Group_ID;
ALTER TABLE maindata 
RENAME COLUMN `%Airline ID` TO Airline_ID;
ALTER TABLE `distance groups`
RENAME COLUMN `ï»¿%Distance Group ID` TO Distance_Group_ID;
ALTER TABLE `distance groups`
RENAME COLUMN `Distance Interval` TO Distance_Interval;
select * from `distance groups`;

SELECT 
    STR_TO_DATE(CONCAT(Year, '-',`Month (#)`, '-', Day), '%Y-%m-%d') AS flight_date
FROM maindata;

UPDATE maindata
SET flight_date = STR_TO_DATE(CONCAT(Year, '-', `Month (#)`, '-', Day), '%Y-%m-%d');

/* Q 1 "1.calcuate the following fields from the Year	Month (#)	Day  fields ( First Create a Date Field from Year , Month , Day fields)"
   A.Year
   B.Monthno
   C.Monthfullname
   D.Quarter(Q1,Q2,Q3,Q4)
   E. YearMonth ( YYYY-MMM)
   F. Weekdayno
   G.Weekdayname
   H.FinancialMOnth
   I. Financial Quarter */

SELECT 
    YEAR(flight_date) AS Year,
    MONTH(flight_date) AS Monthno,
    DATE_FORMAT(flight_date, '%M') AS Monthfullname,
    QUARTER(flight_date) AS Quarter,
    DATE_FORMAT(flight_date, '%Y-%b') AS YearMonth,
    WEEKDAY(flight_date) AS Weekdayno,  -- (0=Monday, 6=Sunday)
    DATE_FORMAT(flight_date, '%W') AS Weekdayname,
    CASE 
        WHEN MONTH(flight_date) BETWEEN 4 AND 12 THEN MONTH(flight_date) - 3
        ELSE MONTH(flight_date) + 9 
    END AS FinancialMonth,
    CASE 
        WHEN MONTH(flight_date) BETWEEN 4 AND 6 THEN 'Q1'
        WHEN MONTH(flight_date) BETWEEN 7 AND 9 THEN 'Q2'
        WHEN MONTH(flight_date) BETWEEN 10 AND 12 THEN 'Q3'
        ELSE 'Q4'
    END AS FinancialQuarter
FROM Maindata;

-- Q 2. Find the load Factor percentage on a yearly , Quarterly , Monthly basis ( Transported passengers / Available seats)

 SELECT 
    YEAR(flight_date) AS Year, 
    QUARTER(flight_date) AS Quarter, 
    MONTH(flight_date) AS Monthno, 
    SUM(transported_passengers) AS Total_Transported_Passengers, 
    SUM(Available_Seats) AS Total_Available_Seats,  
    (SUM(transported_passengers) / SUM(Available_Seats) * 100) AS load_Factor  
FROM maindata   
GROUP BY YEAR(flight_date), QUARTER(flight_date), MONTH(flight_date)  
ORDER BY Year, Quarter, Monthno  
LIMIT 1000; 
   
--- Q 3. Find the load Factor percentage on a Carrier Name basis ( Transported passengers / Available seats)

SELECT 
    Carrier_Name,SUM(transported_passengers),SUM(available_seats),
    SUM(transported_passengers) / SUM(available_seats) * 100 
    AS load_Factor
FROM maindata
GROUP BY Carrier_Name
ORDER BY load_Factor DESC; 

-- Q 4. Identify Top 10 Carrier Names based passengers preference 
SELECT 
    Carrier_Name,
    SUM(transported_passengers) AS Total_Passengers
FROM maindata
GROUP BY Carrier_Name
ORDER BY Total_Passengers DESC
LIMIT 10; 

-- Q 5. Display top Routes ( from-to City) based on Number of Flights 
SELECT 
    From_To_City, 
    count(From_To_City) 
     AS number_of_Flights
FROM maindata
GROUP BY From_To_City
ORDER BY count(From_To_City)  DESC
LIMIT 10; 

-- Q6: Identify Load Factor on Weekends vs. Weekdays
SELECT 
    CASE 
        WHEN DAYOFWEEK(flight_date) IN (1, 7) THEN 'Weekend' 
        ELSE 'Weekday' 
    END AS Week_Type, 
    SUM(transported_passengers) AS Total_Transported_Passengers, 
    SUM(Available_Seats) AS Total_Available_Seats,  
    (SUM(transported_passengers) / SUM(Available_Seats) * 100) AS Load_Factor_Percentage  
FROM maindata  
GROUP BY Week_Type; 

-- Q 7. Identify number of flights based on Distance group
SELECT 
    Distance_Group_ID , 
    COUNT(*) AS Total_Flights
FROM Maindata
GROUP BY Distance_Group_ID
ORDER BY Distance_Group_ID; 




