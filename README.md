# Big Data - Amazon Customer Reviews

## Objective

Many of Amazon's shoppers depend on product reviews to make a purchase. Amazon makes these datasets publicly available. However, they are quite large and can exceed the capacity of local machines to handle. One dataset alone contains several million rows and this can be quite taxing on the average local computer. In this analysis I use Google Colab notebooks to perform the ETL process completely in the cloud. This way I was able to run PySpark ETL commands and load two chosen large  datasets of Amazon reviews (Kitchen purchase reviews and Home purchase reviews) into an AWS RDS PostgreSQL instance. SQL was then used to perform a statistical analysis of selected data. The task is to investigate whether Vine reviews are free of bias and if they are truly trustworthy.

## Dependencies

- Google Colab notebooks
- Java 11 (JDK 11)
- Apache Spark 3.0.0
- Hadoop 3.2
- PostgreSQL12
- AWS RDS to host database

## Data analysis

SQL queries were used for analysis and comparison of Vine and non-Vine reviews  for both datasets. The sql queries files contain comments on results all the way. The results for both files were almost identical, except for the file size. The following discoveries were found:

- Most of the reviews were non-Vine reviews, and only a small fraction were Vine reviews. For example, let's check the Kitchen dataset: 

  > Vine: 24,433  non-Vine: 4,855,528

- The reviews with the most total votes and most helpful votes are mostly non-Vine reviews. Only few Vine reviews have more than 2000 total votes.

- For Vine reviews average number of total votes is more than double of votes for non-Vine reviews.

- It is very similar for helpful votes. 

- If we exclude reviews without votes, the average number of votes drops to approximately a half.

- It seems that Vine reviews are voted slightly more helpful than non-Vine reviews. An they are almost the same for both datasets. Again the example for Kitchen dataset:

  > Vine: 0.86; non-Vine: 0.84

- Average star rating, when all votes are included is almost identical, for both non-Vine and Vine reviews. But if 0 total votes are excluded, average star rating for Vine reviews stays almost the same and becomes slightly higher than for non-Vine reviews (4.18 vs. 3.85)

- Star rating distribution is almost the same for both datasets. Majority of ratings are 5-star ratings (~64%), 4-star ratings are  ~15% and others are less than 10% each.

- non-Vine reviews have higher percentage of 5-star and 1-star reviews and Vine reviews have higher percentage of 4-star and 3-star reviews. Including reviews with 0 helpful votes will decrease 5-star rating percentage for non-Vine reviews and increase percentage for 1-star rating

- There are more Vine reviews per customer in both datasets. The Kitchen dataset example:

  > Vine: 5.87, non-Vine: 1.72

It does not look like that there is a big difference between non-Vine and Vine reviewers. One of the differences is that Vine reviewers will less likely rate products with 5-star and 1-star than non-Vine reviewers. They still rate plenty of products with 5-star but not as much as non-Vine reviewers. So, Vine reviewers will more likely (~94%) give the positive rating (5, 4, 3 stars) than non-Vine reviewers (~86%). I am not sure if only this fact could prove that they are bias. We should probably look for more information and do additional analysis. The last insight from above, stating that in average Vine reviewers have more reviews, is pretty obvious, they receive free products in exchange for reviews.

















