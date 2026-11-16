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
## T2(version1)
Prediction (commit before running): about 55 rows, because most occupations are large, but a few small ones won't have three movies with 20 ratings.
Result: "rows_row_number": 27
Explanation: I guessed 55 and got 27, so I was very off. ROW_NUMBER gives at most 3 rows per occupation. The 20-rating rule counts per occupation, so small ones don't qualify. 11 have no rows, and executive and technician have under 3. My tie-breaker is movie_id so the result is the same every run.
## T2(version2)
Prediction (commit before running): 55 rows, the same as version 1, because I don't expect any ties at third place. A tie would make RANK return more rows.
Result: "rows_rank": 28
Explanation: I guessed the same as version 1 and got 28, so one more. I was wrong. RANK keeps tied movies. In educator, Dr. Strangelove and Rear Window tied for third, so both stayed. ROW_NUMBER only keeps one.

Top-picks for profession: I need only 3 picks becuase the page has 3 slots. I would use ROW_NUMBER. It would keep them the same. 
Rule for DENSE_RANK: 
## T3a
Prediction (commit before running): median ratings per session = about 5, because most users rate a few movies and stop. Agap over 30 minutes starts a new session.
Result: median ratings per session = 11.0
Explanation: My guess of 5 was too low. Most users have one long session, so the median is 11. The first rating of each user has a NULL gap, so it starts session 1. The running SUM of the flags numbers the sessions after that.
## T3b
Prediction (commit before running): the two columns disagree on a few rows, because only rows that share the same timestamp can be different. The default frame counts by value. 
Result: The two columns disagree on many rows, 49,787 of 100,000, because every one of those rows shares a timestamp with another rating from the same user.
Explanation: My reason was right, but it was more than a few. 75,772 rows share a timestamp with another rating from the same user, so ties are common. The default frame counts by value, so a tied row sees every row with the same timestamp.
## T4
Prediction (commit before running):  
A:plan before: SEARCH    plan after: SEARCH
B:plan before: SCAN    plan after: SEARCH
C:plan before: SCAN    plan after: SEARCH
D:plan before: SCAN    plan after: SCAN

Result:
Explanation: 
## T4d
Prediction (commit before running): plan of D_month after your indexes is SCAN, because strftime is a function on the column. Plan of this rewrite is SEARCH using idx_ratings_ts, because the column is bare.
 
Result:
Explanation: 