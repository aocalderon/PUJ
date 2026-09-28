-- Messi's stats.

SELECT 
	* 
FROM 
	public.players
JOIN
	public.player_attributes
USING
	(player_api_id)
WHERE
	player_name LIKE '%Messi%'
ORDER BY
	moment DESC;
	

-- Teams that have both a 0–0 draw and at least one 5+ goal victory.

WITH A AS (
  SELECT home_team_id AS team_api_id
  FROM public.matches
  WHERE home_goals = 0 AND away_goals = 0
  UNION
  SELECT away_team_id
  FROM public.matches
  WHERE home_goals = 0 AND away_goals = 0
),
B AS (
  SELECT home_team_id AS team_api_id
  FROM public.matches
  WHERE (home_goals - away_goals) >= 5
  UNION
  SELECT away_team_id
  FROM public.matches
  WHERE (away_goals - home_goals) >= 5
)
SELECT t.team_long_name
FROM (
	SELECT team_api_id
	FROM A
	INTERSECT
	SELECT team_api_id 
	FROM B) AS foo
JOIN 
	public.teams t
USING (team_api_id);


-- Teams that have won by 4+ at least once but have never lost by 4+.

WITH big_wins AS (
  SELECT home_team_id AS team_api_id FROM public.matches WHERE (home_goals - away_goals) >= 4
  UNION
  SELECT away_team_id FROM public.matches WHERE (away_goals - home_goals) >= 4
),
big_losses AS (
  SELECT home_team_id AS team_api_id FROM public.matches WHERE (away_goals - home_goals) >= 4
  UNION
  SELECT away_team_id FROM public.matches WHERE (home_goals - away_goals) >= 4
)
SELECT 
	t.team_long_name AS team_name
FROM (
	SELECT team_api_id FROM big_losses
	EXCEPT
	SELECT team_api_id FROM big_wins) AS foo
JOIN public.teams t USING (team_api_id);


-- League–seasons with the highest draw rate.

WITH marks AS (
  SELECT league_id, season,
         CASE WHEN home_goals = away_goals THEN 1 ELSE 0 END AS is_draw
  FROM public.matches
)
SELECT l.league_name, m.season,
       COUNT(*) AS matches,
       SUM(m.is_draw) AS draws,
       ROUND(100.0 * SUM(m.is_draw)::numeric / COUNT(*), 2) AS draw_rate
FROM marks m
JOIN public.leagues l ON l.league_id = m.league_id
GROUP BY l.league_name, m.season
ORDER BY draw_rate DESC
LIMIT 15;


-- Teams with the highest variance of goals per game (min 50 games).

WITH all_goals AS (
  SELECT home_team_id AS team_api_id, home_goals AS goals FROM public.matches
  UNION ALL
  SELECT away_team_id AS team_api_id, away_goals AS goals FROM public.matches
)
SELECT t.team_long_name AS team_name,
       COUNT(*) AS games,
       ROUND(AVG(goals)::numeric, 3)     AS mean_goals,
       ROUND(VAR_SAMP(goals)::numeric,3) AS var_goals
FROM all_goals a
JOIN public.teams t ON t.team_api_id = a.team_api_id
GROUP BY t.team_long_name
HAVING COUNT(*) >= 50
ORDER BY var_goals DESC
LIMIT 15;

-- Above potential

WITH A AS (
  SELECT pa.player_api_id, p.player_name, AVG(pa.potential) AS player_potential
  FROM public.player_attributes pa
  NATURAL JOIN public.players p
  WHERE pa.potential IS NOT NULL
  GROUP BY pa.player_api_id, p.player_name
),
B AS (
  SELECT AVG(player_potential) AS general_potential
  FROM A
)
SELECT p.player_name, a.player_potential, b.general_potential
FROM public.players p
NATURAL JOIN A a, B b
WHERE a.player_potential > b.general_potential AND
	p.height <= 170

-- Messi or Cristiano?

WITH candidates AS (
  SELECT p.player_api_id, p.player_name AS who
  FROM public.players p
  WHERE p.player_name LIKE '%Messi%' OR p.player_name LIKE '%Cristiano R%'
),
stats AS (
  SELECT c.who,
         AVG(pa.overall_rating) AS avg_overall,
         MAX(pa.overall_rating) AS max_overall
  FROM candidates c
  JOIN public.player_attributes pa
  ON pa.player_api_id = c.player_api_id
  GROUP BY c.who
)
SELECT * 
FROM stats
ORDER BY avg_overall DESC, max_overall DESC;
