-- Зависимость активности игроков от расы персонажа:
 WITH count_registration_users AS (
      SELECT r.race_id AS race_id,
             r.race AS race,
             COUNT(DISTINCT u.id) AS count_users  --Общее количество зарегистрированных игроков
      FROM fantasy.race AS r
      LEFT JOIN fantasy.users AS u ON r.race_id = u.race_id
      LEFT JOIN fantasy.events AS e ON u.id = e.id
      GROUP BY r.race_id, r.race),
        count_users_amount AS (
      SELECT r.race,
             COUNT(DISTINCT u.id) AS total_users_amount --Количество игроков, совершивших покупку
      FROM fantasy.users AS u
      LEFT JOIN fantasy.race AS r ON r.race_id = u.race_id
      LEFT JOIN fantasy.events AS e ON u.id = e.id 
      WHERE amount > 0 
      GROUP BY r.race_id),
        count_users_pay AS (
      SELECT r.race,
             COUNT(DISTINCT u.id) AS total_users_pay  --Количество платящих игроков
      FROM fantasy.users AS u
      JOIN fantasy.race AS r ON u.race_id = r.race_id
      JOIN fantasy.events AS e ON u.id = e.id
      WHERE u.payer = 1 AND e.amount > 0 
      GROUP BY r.race),
        information AS (
      SELECT r.race,
             u.id,
             COUNT(e.transaction_id) AS count_transaction_user,
             AVG(amount) AS avg_amount_users,
             SUM(amount) AS sum_amount
      FROM fantasy.users AS u
      LEFT JOIN fantasy.race AS r ON r.race_id = u.race_id
      LEFT JOIN fantasy.events AS e ON u.id = e.id 
      WHERE amount > 0 
      GROUP BY r.race_id, u.id)
      SELECT count_registration_users.race_id,       --id расы 
             count_registration_users.race,          --раса
             count_registration_users.count_users,   --Общее количество зарегистрированных игроков
             count_users_amount.total_users_amount,  --Количество игроков, совершивших покупку
             ROUND(AVG(count_users_amount.total_users_amount/count_registration_users.count_users::NUMERIC), 2) AS part_users_pay,  --Доля игроков, совершающих покупки от общего количества игроков
             ROUND(AVG(count_users_pay.total_users_pay/count_users_amount.total_users_amount::NUMERIC), 2) AS part_users_amount ,    --Доля платящих игроков от игроков, совершивших покупку
             ROUND(AVG(information.count_transaction_user::NUMERIC), 2) AS avg_count_transaction,    --Среднее количество покупок на одного игрока
             ROUND(AVG(information.sum_amount::NUMERIC)/AVG(information.count_transaction_user), 2) AS avg_amount,        --Средняя стоимость одной покупки на игрока
             ROUND(AVG(information.sum_amount::NUMERIC), 2) AS avg_sum_amount           --Средняя суммарная стоимость всех покупок
      FROM count_registration_users
      JOIN count_users_amount ON count_registration_users.race = count_users_amount.race
      JOIN count_users_pay ON count_registration_users.race = count_users_pay.race
      JOIN information ON count_registration_users.race = information.race
      GROUP BY count_registration_users.race_id, count_registration_users.race, count_registration_users.count_users, count_users_amount.total_users_amount;
