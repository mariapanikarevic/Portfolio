-- Статистические показатели по полю amount:
   SELECT COUNT(amount) AS count_amount,
          SUM(amount) AS sum_amount,
          MIN(amount) AS min_amount,
          MAX(amount) AS max_amount,
          AVG(amount) AS avg_amount,
          PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY amount) AS perc_amount,
          STDDEV(amount) AS stand_dev
   FROM fantasy.events
   WHERE amount > 0 ;

-- Аномальные нулевые покупки:
   WITH count_player AS
     (SELECT
      (SELECT COUNT(amount) AS amount_null
       FROM fantasy.events 
       WHERE amount = '0' ) ,
       COUNT(amount) AS total_count
      FROM fantasy.events) 
   SELECT amount_null,
           total_count,
           ROUND((amount_null/total_count::NUMERIC), 4) AS part
   FROM count_player;

-- Сравнительный анализ активности платящих и неплатящих игроков:
   WITH classification_player AS (
      SELECT u.id AS count_id,
          u.payer AS payer,
          COUNT(e.transaction_id) AS count_transaction,
          SUM(e.amount) AS sum_amount
      FROM fantasy.users AS u 
      JOIN fantasy.events AS e ON u.id = e.id
      WHERE e.amount > 0
      GROUP BY u.id, u.payer)
   SELECT payer,
        COUNT(count_id) AS count_users,
        AVG(count_transaction) AS avg_transaction,
        AVG(sum_amount) AS avg_sum
   FROM classification_player
   GROUP BY payer; 

-- Популярные эпические предметы:
   WITH top_item_code AS (
      SELECT item_code,
             COUNT(transaction_id) AS count_transaction,
             COUNT(DISTINCT id) AS count_id
      FROM fantasy.events
      WHERE amount > 0 
      GROUP BY item_code)
   SELECT i.item_code,
          i.game_items,
          tic.count_transaction,
          tic.count_transaction::NUMERIC / (SELECT COUNT(transaction_id) FROM fantasy.events WHERE amount > 0) AS part_transaction,
          tic.count_id::NUMERIC / (SELECT COUNT(DISTINCT id) FROM fantasy.events WHERE amount > 0) AS part_users
   FROM top_item_code AS tic
   RIGHT JOIN fantasy.items AS i ON tic.item_code = i.item_code 
   ORDER BY count_transaction DESC NULLS last;
