1. https://drive.google.com/file/d/1JxcGOlQyra8ipEy3Xni79vl5wwSlXi5P/view?usp=sharing

--2. all namefirst and namelast from people
--along with inducted field from hof_inducted

SELECT namefirst, namelast, inducted
FROM people LEFT OUTER JOIN hof_inducted
ON people.playerid = hof_inducted.playerid;


--3. 2006 Negro League HOF Inductions

SELECT birthyear, deathyear, birthcountry, namefirst, namelast
FROM people LEFT OUTER JOIN hof_inducted
ON people.playerid = hof_inducted.playerid
WHERE yearid = 2006 AND votedby = 'Negro League';


--4. hof_inducted and salaries INNER JOIN


SELECT salaries.yearid, salaries.playerid, teamid, salary, category
FROM salaries INNER JOIN hof_inducted
ON salaries.playerid = hof_inducted.playerid;


--5. salaries and hof_inducted FULL OUTER JOIN


SELECT salaries.playerid, salaries.yearid, teamid, lgid, salary, inducted
FROM hof_inducted FULL OUTER JOIN salaries
ON hof_inducted.playerid = salaries.playerid;


--6. hof_inducted and hof_inducted UNION

SELECT * FROM hof_inducted
UNION ALL
SELECT * FROM hof_not_inducted;

SELECT playerid FROM hof_inducted
UNION
SELECT playerid FROM hof_not_inducted;

--7. SUM of salaries by name


SELECT namelast, namefirst, SUM(salary)
FROM salaries LEFT OUTER JOIN people
ON salaries.playerid = people.playerid
GROUP BY namelast, namefirst
ORDER BY namelast, namefirst;


--8. namefirst and last with all hof records

SELECT hof_inducted.playerid, yearid, namefirst, namelast 
FROM hof_inducted LEFT OUTER JOIN people
ON hof_inducted.playerid = people.playerid

UNION ALL 

SELECT hof_not_inducted.playerid, yearid, namefirst, namelast 
FROM hof_not_inducted LEFT OUTER JOIN people
ON hof_not_inducted.playerid = people.playerid;


--9. Like 8. but Filtered since 1980 and 
--sorted by year and a field "lastname, firstname"


SELECT concat(namelast,', ', namefirst) AS namefull, yearid, inducted
FROM hof_inducted LEFT OUTER JOIN people
ON hof_inducted.playerid = people.playerid
WHERE yearid >= 1980

UNION ALL 

SELECT concat(namelast,', ', namefirst) AS namefull, yearid, inducted
FROM hof_not_inducted LEFT OUTER JOIN people
ON hof_not_inducted.playerid = people.playerid
WHERE yearid >= 1980

ORDER BY yearid,  inducted DESC, namefull;

--10. Return a table containing the highest annual salary
-- for each teamid, ranked high to low along with the
-- matching playerid. 
-- BONUS! In addition to playerid, return namelast
-- and namefirst in this table (These are in the people table.).

WITH max AS
(SELECT MAX(salary) as max_salary, teamid, yearid
FROM salaries
GROUP BY teamid, yearid)
SELECT salaries.yearid, salaries.teamid, playerid, max.max_salary
FROM max LEFT OUTER JOIN salaries
ON salaries.teamid = max.teamid AND salaries.yearid = max.yearid AND salaries.salary = max.max_salary
ORDER BY max.max_salary DESC;

--10. Bonus!

WITH max AS
(SELECT MAX(salary) as max_salary, teamid, yearid
FROM salaries
GROUP BY teamid, yearid)
SELECT salaries.yearid, salaries.teamid, salaries.playerid, namelast, namefirst, max.max_salary
FROM salaries LEFT OUTER JOIN people
ON salaries.playerid = people.playerid
RIGHT OUTER JOIN max
ON salaries.teamid = max.teamid AND salaries.yearid = max.yearid AND salaries.salary = max.max_salary
ORDER BY max.max_salary DESC;

--11. Select birthyear, deathyear, namefirst, namelast
-- of all players born since birthyear of 
-- Babe Ruth (ID = ruthba01). Sort low to high.

SELECT birthyear, deathyear, namefirst, namelast
FROM people
WHERE birthyear > ANY
	(SELECT	birthyear
	FROM people
	WHERE playerid = 'ruthba01')
ORDER BY birthyear;

-- 12. Using the people table,
-- create a table containing
-- namefirst, namelast, and a
-- field called usaborn where
-- if the player's birthcountry is USA
-- then 'USA', else 'non-USA'.
-- order by 'non-USA' records first.

SELECT namefirst, namelast, 
	CASE
		WHEN birthcountry = 'USA' THEN 'USA'
		ELSE 'non-USA'
	END AS usaborn
FROM people
ORDER BY 3;

-- 13. Calculate the average height
-- for players throwing with their
-- right versus left hand.
-- Name these fields right_height
-- and left_height


SELECT
AVG(CASE WHEN throws = 'R' THEN height END) AS right_height,
AVG(CASE WHEN throws = 'L' THEN height END) AS left_height
FROM people;

-- 14. Get average of team
-- maximum salaries since 2010.
-- (Hint: WHERE goes in your CTE!)

WITH max_team_sal AS
(
	SELECT teamid, MAX(salary) as max_sal
	FROM salaries
	WHERE yearid > 2010
	GROUP BY teamid
)
SELECT AVG(max_sal) AS avg_max_sal
	FROM max_team_sal;
