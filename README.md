# Netflix Movies and TV Shows Data Analysis using SQL

![](https://github.com/UmeshSubhedar/Netflix_SQL_Project/blob/main/Netflix_logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
create database netflix_db;

use netflix_db;

CREATE TABLE netflix(
	show_id VARCHAR(10),
	type VARCHAR(10),
	title VARCHAR(150),
	director VARCHAR(210) DEFAULT NULL,
	cast VARCHAR(1000) DEFAULT NULL,
	country	VARCHAR(150) DEFAULT NULL,
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(10),
	duration VARCHAR(15),	
	listed_in VARCHAR(100),
	description VARCHAR(260)
    )
;

show variables like 'secure_file_priv';
set sql_mode='';

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/netflix_titles.csv"
INTO TABLE netflix
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES;

set global local_infile=1;
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT 
	type, count(*) Total_Count
	FROM netflix
	GROUP BY type;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
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
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT
	type,title, release_year Release_year
	FROM NETFLIX
	WHERE 
		type="Movie" 
		AND 
		Release_year = 2020;
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Identify the Longest Movie

```sql
SELECT
	title Movie_Name,
	CAST(SUBSTRING(duration, 1, LOCATE(' min', duration) - 1) AS UNSIGNED) AS Duration_in_Min
	FROM netflix
	WHERE type = "Movie"
	ORDER BY Duration_in_Min DESC 
	LIMIT 1
;
```

**Objective:** Find the movie with the longest duration.

### 5. Find Content Added in the Last 5 Years

```sql
SELECT
	* FROM (
		SELECT *,
		DENSE_RANK() OVER(ORDER BY YEAR(date_added) DESC) RN
		FROM netflix) CTE
	WHERE RN < 6;
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 6. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT 
	* FROM netflix
	WHERE director LIKE "%Rajiv Chilaka%";

```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 7. List All TV Shows with More Than 5 Seasons

```sql
SELECT
	* FROM netflix
	WHERE type="TV Show"
	AND	
   	CAST(SUBSTRING(duration,1,LOCATE(" ",duration)) AS UNSIGNED) > 5
```

**Objective:** Identify TV shows with more than 5 seasons.

### 8.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
SELECT 
	year(date_added) year_added,
	COUNT(*) yearly_added_count,
	ROUND(
	COUNT(*) / (SELECT COUNT(*) FROM netflix WHERE country LIKE "%India%")*100,2) AS Yearly_average
	FROM netflix
	WHERE country like "%India%"
	GROUP BY year_added
;
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 9. List All Movies that are Documentaries

```sql
SELECT 
	title Documentries_Movies
	FROM netflix
	WHERE listed_in LIKE "%documentaries%"
	AND
	type = "Movie"
;
```

**Objective:** Retrieve all movies classified as documentaries.

### 10. Find All Content Without a Director

```sql
SELECT 
	* FROM netflix
	 WHERE director LIKE ""
;
```

**Objective:** List content that does not have a director.

### 11. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
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
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.


### 12. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.



## Author - Umesh Subhedar
This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback feel free to get in touch!

Thank you for your support, and I look forward to connecting with you!
