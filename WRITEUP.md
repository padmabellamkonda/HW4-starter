## T1a
Prediction: this query returns 100,000 rows, because a window function keeps all rows.
Result: 100,000 rows 
Explanation: Each window has its own PARTITION BY. user_mean groups by user_id. movie_mean groups by movie_id. Every row sits in both groups at once. A window doesn't collapse rows. So the query still returns 100,000 rows.
## T1b
Prediction (commit before running): share_above_both is about 0.25, because about half of ratings are above a user's mean, about half are above a movie's mean, and 0.5 × 0.5 = 0.25.
Result:n_above_both = 45,232 of 100,000. share_above_both = 0.452. share_above_both_20plus = 0.460
Explanation: My prediction was 0.25. The result was 0.452. I assumed the two conditions were independent, so 0.5 × 0.5 = 0.25. They are not independent. A rating above its user's mean is usually above its movie's mean too. A movie with one rating can never be above both. Its movie mean is that one rating. Dropping movies with under 20 ratings removes those ratings that can never count. So the share goes up to 0.460.
## T1c
Prediction (commit before running): which two steps of the chain disappear? (Step1) The genre_means step: It was a GROUP BY that collapsed movies to one row per genre. (Step2) The JOIN back to genre_means. The genre mean is now next to every movie row with a window. The rows aren't collapsed, join is not needed.
Result:269 rows from the chain and 269 from the rewrite. They have the same rows.
Explanation: The Week 6 chain needed genre_means. GROUP BY always returns one row per group. The rows that were grouped are gone. So the chain had to JOIN genre_means back to get the genre mean next to each movie.  The window gives me the genre mean and keeps every row. Both versions return 269 rows. With no join, there is no chance of a join changing the row count.