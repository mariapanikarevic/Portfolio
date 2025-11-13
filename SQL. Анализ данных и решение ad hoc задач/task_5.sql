SELECT DISTINCT server,
       COUNT(server)
FROM fantasy.users
GROUP BY server;
