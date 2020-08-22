/*  == Number of reviews ==
Most of the reviews are non-Vine reviews, 
Vine reviews are only a small fraction    
Vine: 24,433   non-Vine: 4,855,528
*/
SELECT vine, COUNT(*) as total_count
FROM k_vine_table
GROUP BY vine;

/*  == Top 20 total votes ==
*/
SELECT *
FROM k_vine_table
ORDER BY total_votes DESC
LIMIT 20;


/*  == Number of reviews with more than N total votes ==
There are 87 non-Vine and only 3 Vine reviews with more than 2000 total votes
*/
SELECT vine, COUNT(total_votes)
FROM k_vine_table
WHERE total_votes IN 
	(SELECT total_votes 
	 FROM k_vine_table 
	 WHERE total_votes > 2000)
GROUP BY vine;


/*  == Average number of total votes == 
For Vine reviews average number of total votes when they exist is 11.00 and for non-Vine 6.57
When 0 votes are included, average number drops: 6.92 for Vine and 2.66 for non-Vine reviews
*/
SELECT vine, COUNT(*) AS Count, SUM(total_votes) AS "TotalVotes",
		ROUND(AVG(total_votes),2) AS "Average"
FROM k_vine_table
WHERE total_votes > 0
GROUP BY vine;


/*  == Top 20 helpful votes ==
*/
SELECT *
FROM k_vine_table
ORDER BY helpful_votes DESC
LIMIT 20;


/*  == Average number of helpful votes == 
For Vine reviews average number of helpful votes when they exist is 11.24 and for non-Vine 6.40
When 0 votes are included, average number drops: 5.96 for Vine and 2.23 for non-Vine reviews
*/
SELECT vine, COUNT(*) AS Count, SUM(helpful_votes) AS "HelpfulVotes",
		ROUND(AVG(helpful_votes),2) AS "Average"
FROM k_vine_table
WHERE helpful_votes > 0
GROUP BY vine;


/*  == helpful votes compared to total votes ==
It seems that Vine reviews are voted slightly more helpful than non-Vine reviews
Vine: 0.86; non-Vine: 0.84
*/
SELECT vine, ROUND(1.0*SUM(helpful_votes) / SUM(total_votes),2) AS "helpful_%"
FROM k_vine_table
WHERE total_votes > 0
GROUP BY vine;


/*  == number of 5-star reviews ==
Vine: 11,752    non-Vine: 3,116,464
*/
SELECT vine, COUNT(star_rating)
FROM k_vine_table
WHERE star_rating IN 
	(SELECT star_rating 
	 FROM k_vine_table 
	 WHERE star_rating = 5)
GROUP BY vine;


/*  == Average star rating ==
Average star rating, when total votes exist, for non-Vine reviews is 3.85 and for Vine reviews 4.18
When 0 total votes are included, average number changes to 4.21 for non-Vine and 4.25 for Vine reviews
*/
SELECT vine, ROUND(AVG(star_rating),2) AS avg_star_rating
FROM k_vine_table
WHERE total_votes > 0
GROUP BY vine;


/*  == Star rating dictribution == 
Majority of ratings are 5-star ratings (64%)
4-star ratings are 15% and others are less than 10% each
*/
SELECT star_rating, COUNT(*) AS Count, 
        ROUND(COUNT(*) * 100/(
	        SELECT COUNT(*) 
	        FROM k_vine_table),2)
  FROM k_vine_table
  GROUP BY star_rating;


/*  == Percentage of each star_rating per vine, excluding 0 helpful_votes ==
non-Vine reviews have higher percentage of 5-star and 1-star reviews
Vine reviews have higher percentage of 4-star and 3-star reviews
*/
WITH data AS 
 (SELECT star_rating, vine, COUNT(*) AS Count 
  FROM k_vine_table
  GROUP BY star_rating, vine
  )
SELECT star_rating, vine, Count, 
       ROUND(Count * 100/(SUM(Count) OVER (PARTITION BY vine)),2) AS "%"
FROM data
ORDER BY star_rating, vine;


/*  == Percentage of each star_rating per vine, including 0 helpful_votes ==
For Vine reviews percentage went down slightly for each star rating
For non-Vine reviews 5-star rating went down 10 percent points and 1-star rating went up 7 percent points */			

WITH data AS 
 (SELECT star_rating, vine, COUNT(*) AS Count 
  FROM k_vine_table
  where helpful_votes > 0
  GROUP BY star_rating, vine
  )
SELECT star_rating, vine, Count, 
       ROUND(Count * 100/(SUM(Count) OVER (PARTITION BY vine)),2) AS "%"
FROM data
ORDER BY star_rating, vine;


/*  == Number of customers with Vine reviews == 
There are 4,160 distinct customers sharing 24,433 Vine reviews
Maximum is 40 reviews; 102 customers with more than 20 reviews
675 customers with more than 10 reviews
For non-Vine reviews maximum is 429 reviews
*/
SELECT r.customer_id, COUNT(r.review_id) AS Count
FROM k_review_id_table r
	JOIN k_vine_table v
	ON r.review_id = v.review_id 
WHERE v.vine = 'Y'
GROUP BY customer_id
HAVING COUNT(r.review_id) > 20
ORDER BY Count DESC
;


/*  == Number of reviews per customer ==
There more Vine reviews per customer, 5.87, than non-Vine reviews, 1.72
*/ 
SELECT vine, COUNT(DISTINCT(customer_id)) AS customer_count,
			 COUNT(r.review_id) AS review_count,
			 ROUND(1.0*COUNT(*) / COUNT(DISTINCT(customer_id)),2) AS reviews_per_customer
FROM k_review_id_table r
	JOIN k_vine_table v
	ON r.review_id = v.review_id 
GROUP BY vine;

