## T1a
Prediction: this query returns 100,000 rows, because a window function keeps all rows.
Result:
Explanation:
## T1b
-- Prediction (commit before running): share_above_both is about 0.25, because about half of ratings are above a user's mean, about half are above a movie's mean, and 0.5 × 0.5 = 0.25.
Result:
Explanation:
## T1c
-- Prediction (commit before running): which two steps of the chain disappear? (Step1) The genre_means step: It was a GROUP BY that collapsed movies to one row per genre. (Step2) The JOIN back to genre_means. The genre mean is now next to every movie row with a window. The rows aren't collapsed, join is not needed.

Result:
Explanation: