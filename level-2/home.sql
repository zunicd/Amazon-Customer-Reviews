/*  == Number of reviews ==
Most of the reviews are non-Vine reviews, 
Vine reviews are only a small fraction    
Vine: 23,682   non-Vine: 6,196,932
*/
SELECT vine, COUNT(*) as total_count
FROM h_vine_table
GROUP BY vine;

/*  == Top 20 total votes ==
There is one Vine review
*/
SELECT *
FROM h_vine_table
ORDER BY total_votes DESC
LIMIT 20;


/*  == Number of reviews with more than N total votes ==
There are 73 non-Vine and only 4 Vine reviews with more than 2000 total votes
*/
SELECT vine, COUNT(total_votes)
FROM h_vine_table
WHERE total_votes IN 
	(SELECT total_votes 
	 FROM h_vine_table 
	 WHERE total_votes > 2000)
GROUP BY vine;


/*  == Average number of total votes == 
For Vine reviews average number of total votes when they exist is 13.99 and for non-Vine 5.25
When 0 votes are included, average number drops: 8.61 for Vine and 1.99 for non-Vine reviews
*/
SELECT vine, COUNT(*) AS Count, SUM(total_votes) AS "TotalVotes",
		ROUND(AVG(total_votes),2) AS "Average"
FROM h_vine_table
WHERE total_votes > 0
GROUP BY vine;


/*  == Top 20 helpful votes ==
1 Vine review listed
*/
SELECT *
FROM h_vine_table
ORDER BY helpful_votes DESC
LIMIT 20;


/*  == Average number of helpful votes == 
For Vine reviews average number of helpful votes when they exist is 14.23 and for non-Vine 5.20
When 0 votes are included, average number drops: 7.58 for Vine and 1.70 for non-Vine reviews
*/
SELECT vine, COUNT(*) AS Count, SUM(helpful_votes) AS "HelpfulVotes",
		ROUND(AVG(helpful_votes),2) AS "Average"
FROM h_vine_table
WHERE helpful_votes > 0
GROUP BY vine;


/*  == helpful votes compared to total votes ==
It seems that Vine reviews are voted slightly more helpful than non-Vine reviews
Vine: 0.88; non-Vine: 0.86
*/
SELECT vine, ROUND(1.0*SUM(helpful_votes) / SUM(total_votes),2) AS "helpful_%"
FROM h_vine_table
WHERE total_votes > 0
GROUP BY vine;


/*  == number of 5-star reviews ==
Vine: 10,798    non-Vine: 3,881,584
*/
SELECT vine, COUNT(star_rating)
FROM h_vine_table
WHERE star_rating IN 
	(SELECT star_rating 
	 FROM h_vine_table 
	 WHERE star_rating = 5)
GROUP BY vine;


/*  == Average star rating ==
Average star rating, when total votes exist, for non-Vine reviews is 3.86 and for Vine reviews 4.16
When 0 total votes are included, average number changes to 4.18 for non-Vine and 4.21 for Vine reviews
*/
SELECT vine, ROUND(AVG(star_rating),2) AS avg_star_rating
FROM h_vine_table
WHERE total_votes > 0
GROUP BY vine;


/*  == Star rating dictribution == 
Majority of ratings are 5-star ratings (62%)
4-star ratings are 15% and others are less than 10% each
*/
SELECT star_rating, COUNT(*) AS Count, 
        ROUND(COUNT(*) * 100/(
	        SELECT COUNT(*) 
	        FROM h_vine_table),2)
  FROM h_vine_table
  GROUP BY star_rating;


/*  == Percentage of each star_rating per vine, excluding 0 helpful_votes ==
non-Vine reviews have higher percentage of 5-star and 1-star reviews
Vine reviews have higher percentage of 4-star and 3-star reviews
*/
WITH data AS 
 (SELECT star_rating, vine, COUNT(*) AS Count 
  FROM h_vine_table
  GROUP BY star_rating, vine
  )
SELECT star_rating, vine, Count, 
       ROUND(Count * 100/(SUM(Count) OVER (PARTITION BY vine)),2) AS "%"
FROM data
ORDER BY star_rating, vine;


/*  == Percentage of each star_rating per vine, jncluding 0 helpful_votes ==
For Vine reviews percentage went down slightly for each star rating
For non-Vine reviews 5-star rating went down 8 percent points and 1-star rating went up 6 percent points */			

WITH data AS 
 (SELECT star_rating, vine, COUNT(*) AS Count 
  FROM h_vine_table
  where helpful_votes > 0
  GROUP BY star_rating, vine
  )
SELECT star_rating, vine, Count, 
       ROUND(Count * 100/(SUM(Count) OVER (PARTITION BY vine)),2) AS "%"
FROM data
ORDER BY star_rating, vine;


/*  == Number of customers with Vine reviews == 
There are 3,850 distinct customers sharing 23,682 Vine reviews
Maximum is 68 reviews; 100 customers with more than 20 reviews
681 customers with more than 10 reviews
For non-Vine reviews maximum is 3515 reviews. The second one on the list 424.
*/
SELECT r.customer_id, COUNT(r.review_id) AS Count
FROM h_review_id_table r
	JOIN h_vine_table v
	ON r.review_id = v.review_id 
WHERE v.vine = 'Y'
GROUP BY customer_id
HAVING COUNT(r.review_id) > 20
ORDER BY Count DESC
;


/*  == Number of reviews per customer ==
There more Vine reviews per customer, 6.15, than non-Vine reviews, 1.79
*/ 
SELECT vine, COUNT(DISTINCT(customer_id)) AS customer_count,
			 COUNT(r.review_id) AS review_count,
			 ROUND(1.0*COUNT(*) / COUNT(DISTINCT(customer_id)),2) AS reviews_per_customer
FROM h_review_id_table r
	JOIN h_vine_table v
	ON r.review_id = v.review_id 
GROUP BY vine;

