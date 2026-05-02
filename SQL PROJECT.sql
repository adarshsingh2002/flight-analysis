use pw_code;
select * from t_t100d_market_all_carrier;


-- 1. Analyze total passenger traffic per route and over time.

select  origin_city_name , dest_city_name ,  sum(passengers) as total_passengers from t_t100d_market_all_carrier
group by 1,2
order by total_passengers desc
limit 5 ;


-- top 5 routes which are the busiest routes having huge passenger traffic
/*Miami, FL	New York, NY
New York, NY	Miami, FL
Orlando, FL	New York, NY
New York, NY	Orlando, FL
New York, NY	Chicago, IL*/

-- Least busiest routes

select ORIGIN_CITY_NAME, DEST_CITY_NAME, sum(PASSENGERS) as total_passengers
from t_t100d_market_all_carrier
where origin_city_name != dest_city_name
group by 1,2
having  total_passengers>0
order by  total_passengers;




-- 2. Determine average passengers per flight for various routes and airports.

-- for routes
select origin_city_name ,  dest_city_name , avg(passengers) as average_passengers from t_t100d_market_all_carrier
group by 1,2
order by average_passengers desc
limit 5;

-- for airport

select origin_airport_id , avg(passengers) average_passengers  from t_t100d_market_all_carrier
group by 1
order by average_passengers desc
limit 5 ;



-- 3. Assess flight frequency and identify high-traffic corridors.


select ORIGIN_CITY_NAME, DEST_CITY_NAME , count(airline_id) as total_flights from t_t100d_market_all_carrier
group by 1 ,2
order by  total_flights desc
limit 10;



-- 4. Compare passenger numbers across origin cities to identify top-performing airports.



select origin_city_name ,  sum(passengers) as Total_passengers
from t_t100d_market_all_carrier
group by 1
order by Total_passengers desc
limit 5;



-- 5. Evaluate available seat capacity to understand seat utilization. for each airline 

select * from t_t100d_market_all_carrier;
 
 with seating_capacity as(
 select airline_id ,  max(passengers) as Total_passengers from t_t100d_market_all_carrier
 group by 1
 having Total_passengers >0),
 
 seat_utilization as (
 select  fi.airline_id , fi.passengers * 100/sc.Total_passengers  as seat_utilization from t_t100d_market_all_carrier fi 
 left join seating_capacity sc
 on fi.airline_id = sc.airline_id
 order by  seat_utilization desc)
 
 select AIRLINE_ID, round(avg(seat_utilization),2) as avg_seat_utilization
from seat_utilization
group by 1
order by avg_seat_utilization desc; 



-- 6. Identify popular destination airports based on inbound passenger counts.
SELECT
DEST_AIRPORT_ID,
DEST_CITY_NAME,
SUM(PASSENGERS) AS inbound_passengers
FROM t_t100d_market_all_carrier
GROUP BY DEST_AIRPORT_ID, DEST_CITY_NAME
ORDER BY inbound_passengers DESC
LIMIT 10; 


-- 7. Examine the relationship between city population and airport passenger traffic.
WITH city_traffic AS (
    SELECT 
        ORIGIN_CITY_NAME,
        SUM(PASSENGERS) AS total_passengers,
        COUNT(*) AS total_flights,
        AVG(PASSENGERS) AS avg_passengers_per_flight
    FROM t_t100d_market_all_carrier
    GROUP BY ORIGIN_CITY_NAME
)

SELECT 
    ORIGIN_CITY_NAME,
    total_passengers,
    total_flights,
    avg_passengers_per_flight
FROM city_traffic
ORDER BY total_passengers DESC;

-- Flight Operations Analytics | SQL

-- Analyzed passenger traffic, flight frequency, and route performance using SQL.
-- Identified busiest routes, high-traffic corridors, and top destination airports.
-- Performed seat utilization analysis for airlines.
-- Generated insights for route optimization and capacity planning using SQL (CTE, Joins, Aggregations)






