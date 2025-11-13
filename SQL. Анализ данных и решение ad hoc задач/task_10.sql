-- Доля платящих пользователей по всем данным:
   SELECT COUNT(id) AS count_id,
       SUM(payer) AS payer_id,
       AVG(payer) AS avg_payer
   FROM fantasy.users;
-- Доля платящих пользователей в разрезе расы персонажа:
   SELECT DISTINCT u.race_id,
        r.race,
        SUM(u.payer) AS count_payer,
        ROUND(AVG(u.payer), 3) AS payer_share
   FROM fantasy.users AS u
   LEFT JOIN fantasy.race AS r ON u.race_id = r.race_id
   GROUP BY u.race_id, r.race
   ORDER BY count_payer DESC;
