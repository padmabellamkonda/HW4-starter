-- T4d. The app team's D_month query (in run.py) filters with strftime and
-- stays a SCAN whatever you index. Rewrite it as a range on the raw column,
-- with two placeholders: the first and last second of the month, as
--   timestamp >= ? AND timestamp < ?
-- run.py fills in the month boundaries and checks the counts match.
-- Required: one column, the count.
--
-- Prediction (commit before running): plan of D_month after your indexes is SCAN, because strftime is a function on the column. Plan of this rewrite is SEARCH using idx_ratings_ts, because the column is bare.


-- YOUR QUERY HERE
