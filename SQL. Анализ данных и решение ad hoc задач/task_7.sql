SELECT *,
       COUNT(*) OVER() AS row_count
FROM fantasy.events
LIMIT 5;
