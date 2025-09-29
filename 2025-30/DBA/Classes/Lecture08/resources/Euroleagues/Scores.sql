SELECT
	stage AS "Stage", CAST(date AS Date) AS "Date", t1.team_short_name || ' vs ' || t2.team_short_name AS "Teams", home_goals || ' - ' || away_goals AS "Score"
FROM
	matches m
JOIN
	teams t1
ON
	t1.team_api_id = m.home_team_id
JOIN
	teams t2
ON
	t2.team_api_id = m.away_team_id
WHERE
	m.league_id = 1 AND
	m.season LIKE '2014/2015' AND
	m.stage = 7