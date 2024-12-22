SElECT * FROM netflix

SELECT 
	COUNT(*) AS total_content
FROM netflix;

SElECT 
	DISTINCT type
FROM netflix;

--- 15 business problems

--- 1. Count the number of movies vs TV shows
SElECT 
	type, 
	COUNT(*) AS  total_content
FROM netflix
GROUP BY type

--- 2. Find the most common rating for movies and TV Shows
SELECT 
	type, 
	rating
FROM
(
SElECT 
	type,
	rating,
	COUNT(*),
	--MAX(rating)
	RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
FROM netflix
GROUP BY 1,2
) AS t1
WHERE ranking = 1
--ORDER BY 1,3 DESC

--3.List all the movies released in a specific year (e.g., 2020)

-- filter 2020
-- movies
SElECT* 
FROM netflix
WHERE 
	type = 'Movie'
	AND
	release_year = 2020

-- 4.  Find the top 5 countries with the most content on Netflix
SElECT 
	UNNEST(STRING_TO_ARRAY(country,','))AS new_country,
	COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--function
SELECT 
	UNNEST(STRING_TO_ARRAY(country,','))AS new_country
from netflix

-- 5 . identify  the longest movie
SELECT *
FROM netflix
WHERE 
	 type = 'Movie'
	 AND
	 duration = (SELECT MAX(duration) FROM netflix)

	 --6. Find the content added in the last 5 years
SELECT 
* 
FROM netflix 
WHERE 
	 TO_DATE(date_added,'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka':
SELECT * FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%'

-- 8. List all TV shows with more than 5 seasons
SELECT 
	*
FROM netflix
WHERE 
	type = 'TV Show'
	AND
	SPLIT_PART(duration,' ',1) :: numeric > 5 
	
SELECT
	SPLIT_PART('Apple Banana Cherry',' ',1)

-- 9. Count the number of content items in each genre

SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1

-- 10. Find each year and the avearge numbers of content release by India on netflix.
-- return top 5 year with highest avg content release:

--total content 333/972

SELECT 
	EXTRACT (YEAR FROM TO_DATE(date_added,'Month DD, YYYY')) as date,
	COUNT(*) as yearly_content,
	ROUND(
	COUNT(*):: numeric/(SELECT COUNT(*) FROM netflix WHERE country='India'):: numeric * 100 
	,2)as avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1

-- 11. List all movies that are documentaries
SELECT * FROM netflix
WHERE listed_in ILIKE '%documentaries%'

-- 12. Find all the content without  a director
SELECT * FROM netflix
WHERE
	director IS NULL

-- 13.Find how many movies actor 'Salman Khan' appeared in last 10 years
SELECT * FROM netflix
WHERE
	casts ILIKE '%Salman Khan%'
	AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE)-10

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in Indai.
SELECT 
	UNNEST(STRING_TO_ARRAY(casts,',')) AS actors,
	COUNT(*) as total_content
FROM netflix
WHERE country ILIKE '%india'
GROUP BY 1
ORDER BY 2 DESC

-- 15. Categories the content based on the presence of keywords 'kill' and 'voilence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. count how many items fall into each category
with new_table 
as
(
SELECT
*,
	CASE
	WHEN description ILIKE '%kill%' OR
		description ILIKE '%violence%' THEN 'Bad_Content'
		else 'Good Content'
	End category
FROM netflix
)
Select
	 category,
	 Count(*) as total_content
from new_table
Group by 1;

SELECT *FROM netflix
WHERE 
	description ILIKE '%kill%'
	OR 
	description ILIKE '%violence%'

	


