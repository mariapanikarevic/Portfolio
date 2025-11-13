SELECT COUNT(*)
FROM fantasy.users
WHERE class_id IS NULL
      AND ch_id IS NULL
      AND pers_gender IS NULL
      AND server IS NULL
      AND race_id IS NULL
      AND payer IS NULL
      AND loc_id IS NULL;
