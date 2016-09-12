/* Общее время включенных гарнитур по дням в часах    */

SELECT CAST(Started AS DATE), SUM(DATEDIFF(SECOND, Started, Finished))/60/60
FROM Sessions
GROUP BY CAST(Started AS DATE)
ORDER BY CAST(Started AS DATE) DESC