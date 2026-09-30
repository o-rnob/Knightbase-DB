-- Derived, numeric close for dsex_index / ds30_index.
-- See README "dsex_index, ds30_index" for why this is needed.
--
-- Two row formats are present in the source tables:
--   (a) single-value rows  (open = high = low): the value is that day's CLOSE
--   (b) true OHLC rows     (open/high/low differ): `open` is the PREVIOUS day's close,
--       so this row's close is the NEXT row's `open` -- provided the next row is also (b).
-- Rows where the close cannot be derived (a (b)-row followed by an (a)-row, or the
-- last row in the table) get close_derived = NULL rather than a guess.

DROP VIEW IF EXISTS dsex_index_close;
CREATE VIEW dsex_index_close AS
WITH n AS (
  SELECT date,
         CAST(REPLACE(open, ',', '') AS REAL) AS o,
         CAST(REPLACE(high, ',', '') AS REAL) AS h,
         CAST(REPLACE(low,  ',', '') AS REAL) AS l
  FROM dsex_index
), w AS (
  SELECT date, o, h, l,
         (o = h AND h = l)                  AS single_value,
         LEAD(o)               OVER (ORDER BY date) AS next_o,
         LEAD(o = h AND h = l) OVER (ORDER BY date) AS next_single_value
  FROM n
)
SELECT date,
       CASE WHEN single_value THEN o
            WHEN next_single_value = 0 THEN next_o
       END AS close_derived,
       CASE WHEN single_value THEN 'single_value_row'
            WHEN next_single_value = 0 THEN 'next_row_open'
            ELSE 'not_derivable'
       END AS close_method
FROM w;

DROP VIEW IF EXISTS ds30_index_close;
CREATE VIEW ds30_index_close AS
WITH n AS (
  SELECT date,
         CAST(REPLACE(open, ',', '') AS REAL) AS o,
         CAST(REPLACE(high, ',', '') AS REAL) AS h,
         CAST(REPLACE(low,  ',', '') AS REAL) AS l
  FROM ds30_index
), w AS (
  SELECT date, o, h, l,
         (o = h AND h = l)                  AS single_value,
         LEAD(o)               OVER (ORDER BY date) AS next_o,
         LEAD(o = h AND h = l) OVER (ORDER BY date) AS next_single_value
  FROM n
)
SELECT date,
       CASE WHEN single_value THEN o
            WHEN next_single_value = 0 THEN next_o
       END AS close_derived,
       CASE WHEN single_value THEN 'single_value_row'
            WHEN next_single_value = 0 THEN 'next_row_open'
            ELSE 'not_derivable'
       END AS close_method
FROM w;
