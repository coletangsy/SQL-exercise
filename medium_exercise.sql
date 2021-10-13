-- Twenty-five SQL practice exercises | by Michael Boles | Towards Data Science
-- https://towardsdatascience.com/twenty-five-sql-practice-exercises-5fc791e24082


-- Process to deal with sql
-- use sub-table to re-arrange the data, and then return the desired output


-- 1. Cancellation rates
-- From the following table of user IDs, actions, and dates, write a query to return the publication and cancellation rate for each user.

-- Turn the action into int. with CASE WHEN
T1 AS (
SELECT user_id,
SUM(CASE WHEN action = “start” THEN 1 ELSE 0) AS “start”, 
SUM(CASE WHEN action = “cancel” THEN 1 ELSE 0) AS “cancel”, 
SUM(CASE WHEN action = “publish” THEN 1 ELSE 0) AS “publish”,
FROM users
GROUP BY user_id
ORDER BY user_id)

SELECT user_id, 1.0 * publish / start AS “publish_rate”, 1.0*cancel / start AS “cancel_rate”
FROM T1;


-- 2. Changes in net worth
-- From the following table of transactions between two users, write a query to return the change in net worth for each user, ordered by decreasing net change.

-- calculate the debits and credits data seperately first
Debits AS(
SELECT sender, SUM(amount) AS debited
FROM transactions
GROUP BY sender),

Credits AS()
SELECT receiver, SUM(amount) AS credited
FROM transactions
GROUP BY receiver)

-- combine the table and calculate 
SELECT COALESCE(sender, receiver) AS user,
COALESCE(credited,0) – COALESCE(debited,0) AS net_change
FROM Debits d FULL JOIN Credits c ON d.sender = c.receiver
ORDER BY user DESC;

 
-- 3. Most frequent items
-- From the following table containing a list of dates and items ordered, write a query to return the most frequent item ordered on each date. Return multiple items in the case of a tie.

-- Add item count column, grouping by date and item columns
T1 AS (
SELECT date, item, count(*) AS item_count
FROM items
GROUP BY date, item
ORDER BY date)

-- Add rank column, in desc order partition by date with RANK() OVER (PARTITION BY ORDER BY)
T2 AS (
SELECT *, RANK() OVER (PARTITION BY date ORDER BY item_count DESC) AS date_rank
FROM T1)

-- Select / filter out the date_rank = 1
SELECT date, item
FROM T2
WHERE date_rank = 1;


-- 4. Time difference between latest actions
-- From the following table of user actions, write a query to return for each user the time elapsed between the last action and the second-to-last action, in ascending order by user ID.

-- Use the row_number() to identify the date
T1 AS (
SELECT *, row_number() OVER (PARTITION BY user_id ORDER BY action_date DESC) AS date_rank 
FROM users),

-- filter out the data with sub-table
Latest AS (
SELECT * FROM T1 WHERE date_rank = 1),

Next_Latest AS (
SELECT * FROM T1 WHERE date_rank = 2)

-- Left join the Next_Latest to Latest since not everyone have Next_Latest, Left join to join only those who have Next_Latest, subtracting Latest from Next_Latest to get the time elapsed
SELECT Latest.user_id, Latest.action_date – Next_Latest.action_date AS days_elapsed
FROM Latest LEFT JOIN Next_Latest ON Latest.user_id = Next_Latest.user_id
ORDER BY Latest.user_id;

 
-- 5. Super users
-- A company defines its super users as those who have made at least two transactions. From the following table, write a query to return, for each user, the date when they become a super user, ordered by oldest super users first. Users who are not super users should also be present in the table.

-- Find out whether the customer have made at least two transactions
WITH T1 AS (
SELECT *, row_number() OVER (PARTITION BY user_id ORDER BY transaction_date ASC) AS transaction_number
FROM users),

-- Filter the superuser out
WITH T2 AS(
SELECT user_id, transaction_date
FROM T1
WHERE transaction_number = 2),

-- Get the full list of user
WITH T3 AS(
SELECT DISTINCT user_id
FROM users),

-- Left join superusers T2 to the full list T3 and order by date
SELECT T3.user_id, transaction_date AS superuser_date  
FROM T3 LEFT JOIN T2 ON T3.user_id = T2.user_id
ORDER BY transaction_date;

 
-- 6. Content recommendation (hard)
-- Using the following two tables, write a query to return page recommendations to a social media user based on the pages that their friends have liked, but that they have not yet marked as liked. Order the result by ascending user ID

-- Inner join friends and page likes tables on user_id
T1 AS (
SELECT l.user_id, l.page_likes, f.friend
FROM likes l JOIN friends F ON l.user_id = F.user_id),

-- Left join likes on this, requiring user = friend and user.likes = friend.likes
T2 AS(
SELECT T1.user_id, T1.page_likes, T1.friend, l.page_likes AS friend_likes
FROM T1 LEFT JOIN likes l ON T1.user_id = l.user_id AND T1.page_likes = l.page_likes)

-- If a friend pair doesn’t share a common page like, friend likes column will be null – pull out these entries
SELECT DISTINCT friend AS user_id, page_likes AS recommended_page 
FROM T2
WHERE friend_likes IS NULL
ORDER BY user_id ASC;

 
-- 7. Mobile and web visitors
-- With the following two tables, return the fraction of users who only visited mobile, only visited web, and visited both.

-- Full-join the web and mobile, then we have the count of each types and total respectively
T1 AS (
SELECT DISTINCT m.user_id AS mobile_user, w.user_id AS web_user
FROM mobile m FULL JOIN web w ON m.user_id = w.user_id),

T2 AS (
SELECT SUM(CASE WHEN mobile_user IS NOT NULL AND web_user IS NULL THEN 1 ELSE 0 END) AS n_mobile,
	SUM(CASE WHEN mobile_user IS NULL AND web_user IS NOT NULL THEN 1 ELSE 0 END) AS n.web,
	SUM(CASE WHEN mobile_user IS NOT NULL AND web_user IS NOT NULL THEN 1 ELSE 0 END) AS n.both
	COUNT(*) AS n.total
FROM T1),

-- Calculate the fraction with the no. in each / total
SELECT 1.0*n_mobile/n_total AS mobile_fraction, 
1.0*n_web/n_total AS web_fraction, 
1.0*n_both/n_total AS both_fraction
FROM T2;

 
-- 8. Upgrade rate by product action (hard)
-- Given the following two tables, return the fraction of users, rounded to two decimal places, who accessed feature two (type: F2 in events table) and upgraded to premium within the first 30 days of signing up.

-- Get feature 2 users and their date
T1 AS(
SELECT user_id, type, access_date AS f2_date
FROM events
WHERE type = “F2”),

-- Get Premium users and their date
T2 AS(
SELECT user_id, type, access_date AS premium_date
FROM events
WHERE type = “P”),

-- Applied T1 as filter and filter f2 user data, then join T2 (P) to check upgrade_time
T3 AS (
SELECT DATE(T2.premium_date) – DATE(u.join_date) AS upgrade_time
FROM users U JOIN T1 ON U.user_id = T1.user_id 
	LEFT JOIN T2 ON u.user_id = T2.user_id),

SELECT ROUND(1.0*SUM(CASE WHEN upgrade_time < 30 THEN 1 ELSE 0 END)/COUNT(*),2) AS upgrade_rate
FROM T3;

 
-- 9. Most friended
-- Given the following table, return a list of users and their corresponding friend count. Order the result by descending friend count, and in the case of a tie, by ascending user ID. Assume that only unique friendships are displayed

-- Get all the combination
T1 AS(
SELECT user1 AS user_id FROM friends 
UNION ALL 
SELECT user2 AS user_id FROM friends),

-- Group by user_id and count the friends
SELECT user_id, count(*) AS friend_count
FROM T1
GROUP BY user_id
ORDER BY friend_count DESC, user_id ASC

 
-- 10. Project aggregation (hard)
-- The projects table contains three columns: task_id, start_date, and end_date. The difference between end_date and start_date is 1 day for each row in the table. If task end dates are consecutive they are part of the same project. Projects do not overlap.
-- Write a query to return the start and end dates of each project, and the number of days it took to complete. Order by ascending project duration, and descending start date in the case of a tie.

-- Get start dates not present in end date columns
T1 AS(
SELECT start_date
FROM projects
WHERE start_date NOT IN (SELECT end_date FROM projects) ),

-- Get end dates do not present in start_date columns
T2 AS(
SELECT end_date
FROM projects
WHERE end_date NOT IN (SELECT start_date FROM projects) ),

-- Filter to plausible start-end pairs, doint the matching works
T3 AS(
SELECT start_date, MIN(end_date) AS end_date
FROM T1, T2
WHERE start_date < end_date
GROUP BY start_date)

SELECT *, DATE(end_date) – DATE(start_date) AS project_duration
FROM T3
ORDER BY project_duration ASC, start_date ASC

 
-- 11. Birthday attendance
-- Given the following two tables, write a query to return the fraction of students, rounded to two decimal places, who attended school
-- (attendance = 1) on their birthday.

SELECT ROUND(1.0*SUM(attendance) / COUNT(*), 2) AS birthday_attendance
FROM attendance a JOIN students s ON a.student_id = s.student_id AND 
	EXTRACT(MONTH FROM school_date) = EXTRACT(MONTH FROM date_of_birth) AND
	EXTRACT(DAY FROM school_date) = EXTRACT(DAY FROM date_of_birth)

 
-- 12. Hacker scores
-- Given the following two tables, write a query to return the hacker ID, name, and total score (the sum of maximum scores for each challenge completed) ordered by descending score, and by ascending hacker ID in the case of score tie. Do not display entries for hackers with a score of zero.

-- select highest score for each hacker in each challenge completed
T1 AS(
SELECT hacker_id, challenge_id, MAX(score) AS max_score
FROM submissions
GROUP BY hacker_id, challenge_id)

-- join the score and information together and calculate the maximum score of each hacker
SELECT T1.hacker_id, h.name, SUM(T1.max_score) AS total_score
FROM T1 JOIN hackers h ON T1.hacker_id = h.hacker_id
GROUP BY T1.hacker_id
HAVING total_score > 0
ORDER BY total_score DESC, T1.hacker_id ASC

 
-- 13. Rank without RANK (hard)
-- Write a query to rank scores in the following table without using a window function. If there is a tie between two scores, both should have the same rank. After a tie, the following rank should be the next consecutive integer value.

SELECT s1.score, COUNT(DISTINCT s2.score) AS score_rank -- COUNT(DISTINCT) Count how many score is larger then itself with JOIN ON <=
FROM scores s1 JOIN scores s2 ON s1.score <= s2.score
GROUP BY s1.id, s1.score
ORDER BY s1.id DESC

-- remark : self-join on inequality produces a table with one score and all scores as large as this joined to it, grouping by first id and score, and counting up all unique values of joined scores yields the equivalent of DENSE_RANK() 

 
-- 14. Cumulative salary sum
-- The following table holds monthly salary information for several employees. Write a query to get, for each month, the cumulative sum of an employee’s salary over a period of 3 months, excluding the most recent month. The result should be ordered by ascending employee ID and month.

-- rank the month (lastest = 1) for each employee
T1 AS (
SELECT *, RANK() OVER (PARTITION BY id ORDER BY pay_month DESC) AS month_rank 
FROM employee),

-- use sum() as winder function and sum up the rank 2, 3, 4 salary 
SELECT id, pay_month, salary, SUM(salary) OVER (PARTITION BY id ORDER BY month_rank DESC) AS cumulative_sum
FROM T1
WHERE month rank !=1 AND month_rank <=4
ORDER BY id, pay_month

 
-- 15. Team standings
-- Write a query to return the scores of each team in the teams table after all matches displayed in the matches table. Points are awarded as follows: zero points for a loss, one point for a tie, and three points for a win. The result should include team name and points, and be ordered by decreasing points. In case of a tie, order by alphabetized team name.

-- Turn the score into guest_points and host_points
T1 AS (
SELECT *, 
CASE WHEN host_goals > guest_goals THEN 3 WHEN host_goals = guest_goals THEN 1 ELSE 0 END AS host_points,
	CASE WHEN host_goals < host_goals THEN 3 WHEN host_goals = guest_goals THEN 1 ELSE 0 END AS guest_points,
FROM matches)

-- Group up the total points (with team details and the point they earned from that match)
SELECT t.team_name, a.host_points + b.guest_points AS total_points
FROM teams t JOIN T1 a ON t.team_id = a.host_team
	JOIN T1 b ON t.team_id = b.guest_team
ORDER BY total_points DESC, team_name ASC

 
-- 16. Customers who didn’t buy a product
-- From the following table, write a query to display the ID and name of customers who bought products A and B, but didn’t buy product C, ordered by ascending customer ID.

SELECT DISTINCT c.id, c.name
FROM orders o JOIN customers c ON o.customer_id = c. id
WHERE customer_ID IN (SELECT customer_id FROM orders WHERE product_name = “A”) 
	AND customer_ID IN (SELECT customer_id FROM orders WHERE product_name = “B”)
	AND customer_ID NOT IN (SELECT customer_id FROM orders WHERE product_name = “C”)
ORDER BY c.id

 
-- 17. Median latitude (hard)
-- Write a query to return the median latitude of weather stations from each state in the following table, rounding to the nearest tenth of a degree. Note that there is no MEDIAN() function in SQL!

-- Re-arrange the table
T1 AS (
SELECT *, row_number() OVER (PARTITION BY state ORDER BY latitude ASC) AS row_number_state, -- arrange in order and give row no.
	COUNT(*) OVER (PARTITION BY state) AS row_count  -- count the total rows
FROM stations)

-- Applied >=total/2 & <= total/2+1 = median
SELECT state, AVG(latitude) AS median_latitude -- AVG() since it may return 2 
FROM T1
WHERE row_number_state >= 1.0*row_count/2 AND row_number_state <= 1.0*row_count/2+1 
GROUP BY state
 

-- 18. Maximally-separated cities
-- From the same table in question 17, write a query to return the furthest-separated pair of cities for each state, and the corresponding distance (in degrees, rounded to 2 decimal places) between those two cities.

-- self-join on matching states and city < city (avoids identical and double-counted city pairs), pulling state, city pair, and latitude/longitude coordinates for each city - get into pairs
T1 AS(
SELECT s1.state, s1.city AS city1, s2.city AS city2, s1.latitude AS city1_lat, s1.longitude AS city1_long, s2.latitude AS city2_lat, s2.longitude AS city2_long
FROM stations s1 JOIN stations s2 ON s1.state = s2.state AND s1.city < s2.city),

-- Add a column displaying rounded Euclidean distance
T2 AS (
SELECT *, ROUND( ((city1_lat – city2_lat)^2 + (city1_long – city2_long)^2)^0.5),2) AS dist
FROM T1),

-- Rank city pair by descending distance
T3 AS(
SELECT *, RANK() OVER (PARTITION BY state ORDER BY dist DESC) AS dist_rank
FROM t2)

SELECT state, city1, city2, dist
FROM T3
WHERE dist_rank = 1
 

-- 19. Cycle time
-- Write a query to return the average cycle time across each month. Cycle time is the time elapsed between one user joining and their invitees joining. Users who joined without an invitation have a zero in the “invited by” column.


-- self-join on invited by = user ID, extract join month from inviter join date with CAST(EXTRACT() AS int), and calculate cycle time as difference between join dates of inviter and invitee
T1 AS(
SELECT CAST(EXTRACT(MONTH FROM u2.join_date) AS int) AS month, u1.join_date – u2.join_date AS cycle_time
FROM users u1 JOIN users u2 ON u1.invited_by = u2.user_id
ORDER BY month )

-- pull out the average data of each month
SELECT month, AVG(cycle_time) AS cycle_time_month_avg
FROM T1
GROUP BY month
ORDER BY month
 

-- 20. Three in a row
-- The attendance table logs the number of people counted in a crowd each day an event is held. Write a query to return a table showing the date and visitor count of high-attendance periods, defined as three consecutive entries (not necessarily consecutive dates) with more than 100 visitors.

-- Data organizing 
T1 AS(
SELECT *, row_number() OVER (ORDER BY event_date) AS day_num 
FROM attendance),

-- Data filtering visitor > 100
T2 AS(
SELECT *
FROM T1
WHERE visitors > 100),

-- Self-join twice on offset = 1 day and offset = 2 days
T3 AS(
SELECT a.day_num AS day1, b.day_num AS day2, c.day_num AS day3
FROM T2 a JOIN T2 b ON a.day_num = b.day_num – 1 
	JOIN T2 c ON a.day_num = c.day_num – 2)

-- Pull the data out 
SELECT event_date, visitors
FROM T1
WHERE day_num IN (SELECT day1 FROM T3) 
OR day_num IN (SELECT day2 FROM T3) 
OR day_num IN (SELECT day3 FROM T3)

 
-- 21. Commonly purchased together
-- Using the following two tables, write a query to return the names and purchase frequency of the top three pairs of products most often bought together. The names of both products should appear in one column.

-- crate product pairs
T1 AS (
SELECT o1.product_id AS prod_1, o2.product_id AS prod_2
FROM orders o1 JOIN orders o2 ON o1.order_id = o2.order_id
	AND o1.product_id < o2.product_id), # get pair

-- Join products table to get product names, and concatenate to get product pairs in columns
T2 AS (
SELECT CONCAT(p1.name, “ ”, p2.name) AS product_pair
FROM T1 JOIN products p1 ON t1.prod1 = p1.id 
	JOIN products p2 ON t1.prod2 = p2.id)

-- Show the result
SELECT *, COUNT(*) AS purchase_freq
FROM T2
GROUP BY product_pair
ORDER BY purchase_freq
LIMIT 3
 
-- 22. Average treatment effect (hard)
-- From the following table summarizing the results of a study, calculate the average treatment effect as well as upper and lower bounds of the 95% confidence interval. Round these numbers to 3 decimal places.

-- count the average outcaome, std and group size for control and treatement group
control AS(
SELECT 1.0*SUM(outcome)/COUNT(*) AS avg_outcome,
	STDDEV(outcome) AS std_dev, -- return the standard deviations
	COUNT(*) AS group_size
FROM study
WHERE assignment = 0),

treatment AS(
SELECT 1.0*SUM(outcome)/COUNT(*) AS avg_outcome,
	STDDEV(outcome) AS std_dev,
	COUNT(*) AS group_size
FROM study
WHERE assignment = 1),

-- get average treatment effect size
effect_size AS (
SELECT t.avg_outcome - c.avg_outcome AS effect_size
FROM control c, treatment t ),

-- construct 95% confidence interval using z* = 1.96 and magnitude of individual standard errors [ std dev / sqrt(sample size) ]
conf_interval AS (
SELECT 1.96 * (t.std_dev^2 / t.group_size 
             + c.std_dev^2 / c.group_size)^0.5 AS conf_int
FROM treatment t, control c )

SELECT round(es.effect_size, 3) AS point_estimate, 
        round(es.effect_size - ci.conf_int, 3) AS lower_bound, 
        round(es.effect_size + ci.conf_int, 3) AS upper_bound
FROM effect_size es, conf_interval ci


-- 23. Rolling sum salary
-- The following table shows the monthly salary for an employee for the first nine months in a given year. From this, write a query to return a table that displays, for each month in the first half of the year, the rolling sum of the employee’s salary for that month and the following two months, ordered chronologically.

-- self-join to match month n with months n, n+1, and n+2, then sum salary across those months, filter to first half of year, and sort
SELECT s1.month, sum(s2.salary) AS salary_3mos
FROM salaries s1 JOIN salaries s2 ON s1.month <= s2.month
	AND s1.month > s2.month - 3
GROUP BY month
HAVING s1.month <7
ORDER BY month ASC


-- 24. Taxi cancellation rate
-- From the given trips and users tables for a taxi service, write a query to return the cancellation rate in the first two days in October, rounded to two decimal places, for trips not involving banned riders or drivers.

-- filter trips table to exclude banned riders and drivers, then calculate cancellation rate as 1 - fraction of trips completed, rounding as requested and filtering to first two days of the month
SELECT request_date, ROUND(SUM(CASE WHEN status != “completed” THEN 1 ELSE 0)/COUNT(status),2) AS “cancel_rate”
FROM trips
WHERE request_date BETWEEN “2020-10-01” AND “2020-10-02” 
	AND rider_id NOT IN (
	SELECT user_id FROM users WHERE banned = “yes”)
	AND drivier_id NOT IN (
	SELECT user_id FROM users WHERE banned = “yes”)
GROUP BY request_date


-- 25. Retention curve (hard)
-- From the following user activity table, write a query to return the fraction of users who are retained (show some activity) a given number of days after joining. By convention, users are considered active on their join day (day 0).

-- get join dates for each user
join_dates AS (
SELECT user_id, action_date AS join_date
FROM users
WHERE action = "Join"),

-- create vector containing all dates in date range
date_vector AS (
SELECT CAST(generate_series(MIN(action_date), MAX(action_date), "1 day"::interval) AS date) AS dates
FROM users),

-- cross join to get all possible user-date combinations
all_user_dates AS (
SELECT DISTINCT user_id, d.dates
FROM users CROSS JOIN date_vector d),

-- left join users table onto all user-date combinations on matching user ID and date (null on days where user didn't engage), join onto this each user's signup date, exclude user-date combinations falling before user signup
T1 AS (
SELECT a.dates - c.join_date AS day_no, b.user_id
FROM all_users_dates a LEFT JOIN users b ON a.user_id = b.user_id
	AND a.dates = b.action_date JOIN join_dates c ON a.user_id = c.user_id 
WHERE a.dates - c.join_date >= 0 )

-- grouping by days since signup, count (non-null) user IDs as active users, total users, and the quotient as retention rate
SELECT day_no, COUNT(*) AS n_total, 
       COUNT(DISTINCT user_id) AS n_active, 
       ROUND(1.0*COUNT(DISTINCT user_id)/COUNT(*), 2) AS retention
FROM T1
GROUP BY day_no