-- T2 (version 1, ROW_NUMBER). The three highest-rated movies for each
-- occupation, among movies rated at least 20 times by users with that occupation.
-- Required columns: occupation, pos, movie_id, title, n, mean_rating
-- Order the window so that the result is the same on every run (state your
-- tie-breaker in WRITEUP.md).
--
-- Prediction (commit before running): about 55 rows, because most occupations are large, but a few small ones won't have three movies with 20 ratings.

-- YOUR QUERY HERE
WITH stats AS (
  SELECT u.occupation, r.movie_id, m.title,
         COUNT(*) AS n, AVG(r.rating) AS mean_rating
  FROM ratings AS r
  JOIN users AS u USING (user_id)
  JOIN movies AS m USING (movie_id)
  GROUP BY u.occupation, r.movie_id, m.title
  HAVING COUNT(*) >= 20
),
ranked AS (
  SELECT *, ROW_NUMBER() OVER (
           PARTITION BY occupation
           ORDER BY mean_rating DESC, movie_id) AS pos
  FROM stats
)
SELECT occupation, pos, movie_id, title, n, mean_rating
FROM ranked WHERE pos <= 3;