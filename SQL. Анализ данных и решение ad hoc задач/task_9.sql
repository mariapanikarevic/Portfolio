SELECT COUNT(date) AS data_count,
       COUNT(time) AS data_time,
       COUNT(amount) AS data_amount,
       COUNT(seller_id) AS data_seller_id
FROM fantasy.events
WHERE date IS NULL
  OR time IS NULL
  OR amount IS NULL
  OR seller_id IS NULL;
