-- T1b. How many ratings are above BOTH the user's mean and the movie's mean?
-- Required columns (one row):
--   n_ratings, n_above_both, share_above_both, share_above_both_20plus
-- share_above_both_20plus: the same share, counting only ratings of movies
-- that have at least 20 ratings.
-- Build on T1a in a CTE; filter or count outside it.
--
-- Prediction (commit before running): share_above_both is about 0.25, because about half of ratings are above a user's mean, about half are above a movie's mean, and 0.5 × 0.5 = 0.25.

-- YOUR QUERY HERE
WITH ctx AS (
  SELECT user_id, movie_id, rating,
         AVG(rating)  OVER (PARTITION BY user_id)  AS user_mean,
         AVG(rating)  OVER (PARTITION BY movie_id) AS movie_mean,
         COUNT(*)     OVER (PARTITION BY movie_id) AS n_movie
  FROM ratings)
SELECT
  (SELECT COUNT(*) FROM ctx) AS n_ratings,
  (SELECT COUNT(*) FROM ctx
   WHERE rating > user_mean AND rating > movie_mean) AS n_above_both,
  (SELECT COUNT(*) FROM ctx
   WHERE rating > user_mean AND rating > movie_mean) * 1.0
    / (SELECT COUNT(*) FROM ctx) AS share_above_both,
  (SELECT COUNT(*) FROM ctx
   WHERE n_movie >= 20 AND rating > user_mean AND rating > movie_mean) * 1.0
    / (SELECT COUNT(*) FROM ctx WHERE n_movie >= 20) AS share_above_both_20plus;