CREATE TABLE IF NOT EXISTS public.countries (
    country_id integer NOT NULL,
    country_name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT countries_pkey PRIMARY KEY (country_id)
);

CREATE TABLE IF NOT EXISTS public.leagues (
    league_id integer NOT NULL,
    country_id integer NOT NULL,
    league_name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT leagues_pkey PRIMARY KEY (league_id),
    CONSTRAINT leagues_country_id_fkey FOREIGN KEY (country_id)
        REFERENCES public.countries (country_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS public.players (
    player_id integer NOT NULL,
    player_api_id integer,
    player_name character varying(40) COLLATE pg_catalog."default",
    player_fifa_api_id integer,
    birthday character varying(30) COLLATE pg_catalog."default",
    height real,
    weight real,
    CONSTRAINT players_pkey PRIMARY KEY (player_id),
    CONSTRAINT players_player_api_id_key UNIQUE (player_api_id),
    CONSTRAINT players_player_fifa_api_id_key UNIQUE (player_fifa_api_id)
);

CREATE TABLE IF NOT EXISTS public.player_attributes (
    player_attributes_id integer NOT NULL,
    player_api_id integer,
    player_fifa_api_id integer,
    moment character varying(30) COLLATE pg_catalog."default",
    overall_rating real DEFAULT 0.0,
    stamina real DEFAULT 0.0,
    ball_control real DEFAULT 0.0,
    acceleration real DEFAULT 0.0,
    agility real DEFAULT 0.0,
    balance real DEFAULT 0.0,
    reactions real DEFAULT 0.0,
    vision real DEFAULT 0.0,
    potential real DEFAULT 0.0,
    attacking_work_rate character varying(15) COLLATE pg_catalog."default",
    defensive_work_rate character varying(15) COLLATE pg_catalog."default",
    CONSTRAINT player_attributes_pkey PRIMARY KEY (player_attributes_id),
    CONSTRAINT player_attributes_player_api_id_fkey FOREIGN KEY (player_api_id)
        REFERENCES public.players (player_api_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS public.teams (
    team_id integer NOT NULL,
    team_api_id integer NOT NULL,
    team_fifa_api_id integer,
    team_long_name character varying(40) COLLATE pg_catalog."default",
    team_short_name character varying(4) COLLATE pg_catalog."default",
    CONSTRAINT teams_pkey PRIMARY KEY (team_api_id),
    CONSTRAINT teams_team_id_key UNIQUE (team_id)
);

CREATE TABLE IF NOT EXISTS public.matches (
    match_id integer NOT NULL,
    league_id integer NOT NULL,
    season character varying(10) COLLATE pg_catalog."default",
    stage integer,
    date character varying(20) COLLATE pg_catalog."default",
    home_team_id integer,
    away_team_id integer,
    home_goals integer,
    away_goals integer,
    CONSTRAINT matches_pkey PRIMARY KEY (match_id),
    CONSTRAINT matches_away_team_id_fkey FOREIGN KEY (away_team_id)
        REFERENCES public.teams (team_api_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT matches_home_team_id_fkey FOREIGN KEY (home_team_id)
        REFERENCES public.teams (team_api_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
