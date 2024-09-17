USE netflix_db;

SELECT * FROM netflix;

SELECT COUNT(*) Total_Content FROM netflix;

SELECT DISTINCT(type) from netflix;


-- 1. Count the number of Movies vs TV Shows

SELECT 
	type, count(*) Total_Count
	FROM netflix
	GROUP BY type;


-- 2. Find the most common rating for movies and TV shows

SELECT 
	type, rating Most_Common_rating
	FROM (
		SELECT type,
		rating,
		count(*),
		RANK() OVER(PARTITION BY type ORDER BY count(*) DESC) RN
		FROM netflix
		GROUP BY type, rating
	) CTE
    
WHERE RN=1;



-- 3. List all movies released in a specific year (e.g., 2020)

SELECT
	type,title, release_year Release_year
	FROM NETFLIX
	WHERE 
		type="Movie" 
		AND 
		Release_year = 2020;



-- 5. Identify the longest movie
SELECT
	title Movie_Name,
	CAST(SUBSTRING(duration, 1, LOCATE(' min', duration) - 1) AS UNSIGNED) AS Duration_in_Min
	FROM netflix
	WHERE type = "Movie"
	ORDER BY Duration_in_Min DESC 
	LIMIT 1
;

-- 6. Find content added in the last 5 years
SELECT
	* FROM (

			SELECT *,
			DENSE_RANK() OVER(ORDER BY YEAR(date_added) DESC) RN
			FROM netflix) CTE

	WHERE RN < 6;


-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT 
	* FROM netflix
	WHERE director LIKE "%Rajiv Chilaka%";

-- 8. List all TV shows with more than 5 seasons
SELECT
	* FROM netflix
	WHERE type="TV Show"
    AND	
    CAST(SUBSTRING(duration,1,LOCATE(" ",duration)) AS UNSIGNED) > 5

;

-- 10.Find each year and the average numbers of content release in India on netflix. 
-- return top 5 year with highest avg content release!
SELECT 
	year(date_added) year_added,
	COUNT(*) yearly_added_count,
	ROUND(
	COUNT(*) / (SELECT COUNT(*) FROM netflix WHERE country LIKE "%India%")*100,2) AS Yearly_average
	FROM netflix
	WHERE country like "%India%"
	GROUP BY year_added
;


-- 11. List all movies that are documentaries
SELECT 
	title Documentries_Movies
	FROM netflix
	WHERE listed_in LIKE "%documentaries%"
	AND
	type = "Movie"
;


-- 12. Find all content without a director
 SELECT 
	* FROM netflix
	 WHERE director LIKE ""
;




-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
WITH CTE AS
		(
		SELECT *,
		DENSE_RANK() OVER(ORDER BY release_year DESC) RN
		FROM netflix
        )
        
SELECT * 
		FROM CTE
		WHERE RN < 11
		AND
		cast LIKE "%Salman Khan%"
;


-- 15.
-- Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.

SELECT 
	Category, COUNT(Category) Category_Count

	FROM (
		 SELECT *,
		 CASE WHEN 
         description LIKE "% kill%" OR 
         description LIKE "%viole%" THEN "Bad"
		 ELSE "Good"
		 END AS Category 
		 FROM netfliX) CTE

GROUP BY Category
;

