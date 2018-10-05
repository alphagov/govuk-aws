SELECT
  (current_date - interval '1' day) date,
  count(*) count,
  status,
  host,
  url
FROM bouncer
WHERE year = year(current_date - interval '1' day)
  AND month = month(current_date - interval '1' day)
  AND date = day(current_date - interval '1' day)
GROUP BY status, host, url
HAVING count(*) >= 10
ORDER BY 2 DESC
