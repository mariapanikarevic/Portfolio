SELECT c.table_schema,
       c.table_name,
       c.column_name,
       c.data_type,
       u.constraint_name
FROM information_schema.columns  AS c
LEFT JOIN information_schema.key_column_usage AS u ON c.table_name = u.table_name
          AND c.table_schema = u.table_schema 
          AND c.column_name = u.column_name
WHERE c.table_schema = 'fantasy' AND c.table_name = 'users'
ORDER BY table_name;
