CREATE TABLE AppleStore_description_combined AS

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4

**Exploring the data*

-- Check the number of unique apps in AppleStore

SELECT COUNT(DISTINCT id) as UniqueAppID
FROM AppleStore

SELECT COUNT(DISTINCT id) as UniqueAppID
From AppleStore_description_combined

-- Check for missing valuesAppleStore

SELECT count(*) as MissingValue
FROM AppleStore
WHERE track_name is NULL OR user_rating is NULL

SELECT count(*) as MissingValue
FROM AppleStore_description_combined
WHERE app_desc IS NULL

-- Apps per genre

SELECT prime_genre,COUNT(*) as NumApps
FROM AppleStore
GROUP BY prime_genre
Order By NumApps DESC

-- get overview of app rating

SELECT min(user_rating) as MinRating,
       max(user_rating) AS MaxRating,
       AVG(user_rating) as AVGRating
FROM AppleStore

-- Determine whether paid apps have a higher rating than free

Select case 
            WHEN price > 1 THEN 'paid' 
            ELSE "free"
            END AS App_type,
            avg(user_rating) AS Avg_Rating
FROM AppleStore
ORDER BY App_type DESC

-- Check Ratings for apps with supported languages

SELECT CASE
            WHEN lang_num < 10 THEN '<10 languages'
            when lang_num BETWEEN 10 and 30 THEN '10-30 languages'
            else '>30 languages'
            END as language_data,
            avg(user_rating) AS avg_rating
from AppleStore
Group by language_data
ORDER by avg_rating DESC


-- check low rating app genres

 SELECT prime_genre,
        avg(user_rating) AS Avg_Rating
 FROM AppleStore
 GROUP BY prime_genre
 ORDER BY Avg_Rating ASC
 LIMIT 10
 
 SELECT CASE
            WHEn (b.app_desc) > 500 THEN 'short'
            WHEn (b.app_desc) BETWEEN 500 and 1000 THEN 'medium'
            ELSE 'long'
            end as Description_legnth,
            avg(user_rating) as Avg_Rating
 
 FROM 
      AppleStore as A
 JOIN
      AppleStore_description_combined as B
 on
      a.id = b.id
 group BY Description_legnth
 ORDER by Avg_Rating DESC
