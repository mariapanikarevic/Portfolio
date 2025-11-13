SELECT c.table_schema,
       c.table_name,
       c.column_name,
       c.data_type,
       k.constraint_name
FROM information_schema.columns AS c 
LEFT JOIN information_schema.key_column_usage AS k 
    USING(table_name, column_name, table_schema)
WHERE c.table_schema = 'fantasy' AND c.table_name = 'events'
ORDER BY c.table_name;
