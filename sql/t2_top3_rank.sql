-- T2 (version 2, RANK). The same question, with RANK() ordered by mean_rating
-- only, keeping rows with pos <= 3.
-- Required columns: occupation, pos, movie_id, title, n, mean_rating
--
-- Prediction (commit before running): 55 rows, the same as version 1, because I don't expect any ties at third place. A tie would make RANK return more rows.
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
  SELECT *, RANK() OVER (
           PARTITION BY occupation
           ORDER BY mean_rating DESC) AS pos
  FROM stats
)
SELECT occupation, pos, movie_id, title, n, mean_rating
FROM ranked WHERE pos <= 3;