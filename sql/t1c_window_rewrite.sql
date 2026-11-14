-- T1c. Rewrite t1c_week6_chain.sql with a window function: no genre_means
-- step and no join back. It must return the same rows.
-- Required columns: genre_id, movie_id, movie_mean, genre_mean
--
-- Prediction (commit before running): which two steps of the chain disappear? (Step1) The genre_means step: It was a GROUP BY that collapsed movies to one row per genre. (Step2) The JOIN back to genre_means. The genre mean is now next to every movie row with a window. The rows aren't collapsed, join is not needed.
-- YOUR QUERY HERE
WITH movie_stats AS (
  SELECT movie_id, AVG(rating) AS movie_mean
  FROM ratings GROUP BY movie_id
  HAVING COUNT(*) >= 30),
movie_genre AS (
  SELECT mg.genre_id, s.movie_id, s.movie_mean,
    AVG(s.movie_mean) OVER
      (PARTITION BY mg.genre_id) AS genre_mean
  FROM movie_stats AS s
  JOIN movie_genres AS mg USING (movie_id))
SELECT genre_id, movie_id, movie_mean, genre_mean
FROM movie_genre
WHERE movie_mean >= genre_mean + 0.5;