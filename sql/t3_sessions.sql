-- T3. Rating sessions. A user's ratings form one session until there is a gap
-- of more than 1800 seconds (30 minutes) since that user's previous rating.
-- Required columns, one row per session:
--   user_id, session_no, n_ratings, start_ts, duration_s
-- session_no counts 1, 2, 3, ... within each user, in time order.
-- Suggested steps (one CTE each): gap with LAG; a 0/1 new_session flag;
-- a running SUM of the flag with an explicit ROWS frame; GROUP BY.
--
-- Prediction (commit before running): median ratings per session = about 5, because most users rate a few movies and stop. Agap over 30 minutes starts a new session.
-- YOUR QUERY HERE
WITH gaps AS (
  SELECT user_id, movie_id, timestamp AS ts,
         timestamp - LAG(timestamp) OVER (
                PARTITION BY user_id
                ORDER BY timestamp, movie_id) AS gap
  FROM ratings
),
flags AS (
  SELECT *, (gap IS NULL OR gap > 1800) AS new_session
  FROM gaps
),
numbered AS (
  SELECT *, SUM(new_session) OVER (
                PARTITION BY user_id
                ORDER BY ts, movie_id
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS session_no
  FROM flags
)
SELECT user_id, session_no,
       COUNT(*) AS n_ratings,
       MIN(ts) AS start_ts,
       MAX(ts) - MIN(ts) AS duration_s
FROM numbered
GROUP BY user_id, session_no;