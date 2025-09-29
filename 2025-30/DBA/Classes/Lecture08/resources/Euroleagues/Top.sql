SELECT
  p.player_name AS "Player", 
  AVG(pa.overall_rating) AS "Score"
FROM
  players p
JOIN
  player_attributes pa
ON
  p.player_api_id = pa.player_api_id
WHERE
	EXTRACT(year FROM CAST(pa.moment AS Date)) = 2011
GROUP BY
  p.player_name
ORDER BY
  2 DESC
LIMIT 
  10