SELECT *,
       COUNT(*) OVER () AS row_count
FROM fantasy.users
LIMIT 5;
