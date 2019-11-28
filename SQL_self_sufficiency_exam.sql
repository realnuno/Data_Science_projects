1. Write a query that allows you to inspect the schema of the naep table.

SELECT column_name, data_type 
FROM information_schema.columns
WHERE table_name = 'naep';



2. Write a query that returns the first 50 records of the naep table.

SELECT *
FROM naep
LIMIT 50;

3.  Write a query that returns summary statistics for avg_math_4_score by state. Make sure to sort the results alphabetically by state name.

SELECT state, COUNT(avg_math_4_score) AS count, AVG(avg_math_4_score) AS average, MIN(avg_math_4_score) AS min, MAX(avg_math_4_score) AS max
FROM naep
GROUP BY state
ORDER BY state;


4. Write a query that alters the previous query so that it returns only the summary statistics for avg_math_4_score by state with differences in max and min values that are greater than 30.

SELECT state, COUNT(avg_math_4_score) AS count, AVG(avg_math_4_score) AS average, MIN(avg_math_4_score) AS min, MAX(avg_math_4_score) AS max
FROM naep
GROUP BY state
HAVING (MAX(avg_math_4_score) - MIN(avg_math_4_score)) > 30
ORDER BY state;


5. 

SELECT state AS bottom_10_states, avg_math_4_score
FROM naep
WHERE year = 2000
ORDER BY avg_math_4_score
LIMIT 10;

6.

SELECT ROUND(AVG(avg_math_4_score), 2) AS avg_of_avg
FROM naep
WHERE year = 2000;


7.
SELECT state AS below_average_states_y2000, avg_math_4_score, year
FROM naep
WHERE avg_math_4_score <
	(SELECT AVG(avg_math_4_score)
	 FROM naep
	 WHERE year = 2000)
GROUP BY state, avg_math_4_score, year
ORDER BY state;


8.
SELECT state AS scores_missing_y2000
FROM naep
WHERE year = 2000 AND avg_math_4_score IS NULL
GROUP BY state
ORDER BY state;


9.
SELECT naep.state, ROUND(avg_math_4_score, 2) AS rounded_score, total_expenditure
FROM naep LEFT OUTER JOIN finance
ON naep.id = finance.id
WHERE naep.year = 2000 AND ROUND(avg_math_4_score, 2) IS NOT NULL
ORDER BY total_expenditure DESC;
