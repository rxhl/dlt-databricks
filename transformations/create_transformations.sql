CREATE DATABASE IF NOT EXISTS dlt_demo_database;
USE dlt_demo_database;

-- create bronze tables
CREATE LIVE TABLE games_raw
COMMENT "Games data from a SQL source"
TBLPROPERTIES ("quality" = "bronze")
AS SELECT * FROM appschema.zzz_games;

CREATE LIVE TABLE teams_raw
COMMENT "Teams data from a SQL source"
TBLPROPERTIES ("quality" = "bronze")
AS SELECT * FROM appschema.zzz_teams;

CREATE LIVE TABLE game_opponents_raw
COMMENT "Game opponents data from a SQL source"
TBLPROPERTIES ("quality" = "bronze")
AS SELECT * FROM appschema.zzz_game_opponents;

CREATE LIVE TABLE game_scores_raw
COMMENT "Games score data from a SQL source"
TBLPROPERTIES ("quality" = "bronze")
AS SELECT * FROM appschema.zzz_game_scores;


-- create silver table
CREATE LIVE TABLE cleaned_game_details (
  CONSTRAINT valid_game_id EXPECT (game_id IS NOT NULL) ON VIOLATION DROP ROW
  )
  COMMENT "The cleaned and merged game score data" TBLPROPERTIES ("quality" = "silver") AS
  SELECT
    game_id,
    home,
    t.team_city AS visitor,
    home_score,
    visitor_score,
    -- Step 3 of 4: Display the city name for each game's winner.
    CASE
      WHEN home_score > visitor_score THEN home
      WHEN visitor_score > home_score THEN t.team_city
    END AS winner,
    game_date AS date
  FROM
    (
      -- Step 2 of 4: Replace the home team IDs with their actual city names.
      SELECT
        game_id,
        t.team_city AS home,
        home_score,
        visitor_team_id,
        visitor_score,
        game_date
      FROM
        (
          -- Step 1 of 4: Combine data from various tables (for example, game and team IDs, scores, dates).
          SELECT
            g.game_id,
            gop.home_team_id,
            gs.home_team_score AS home_score,
            gop.visitor_team_id,
            gs.visitor_team_score AS visitor_score,
            g.game_date
          FROM
            appschema.zzz_games as g,
            appschema.zzz_game_opponents as gop,
            appschema.zzz_game_scores as gs
          WHERE
            g.game_id = gop.game_id
            AND g.game_id = gs.game_id
        ) AS all_ids,
        appschema.zzz_teams as t
      WHERE
        all_ids.home_team_id = t.team_id
    ) AS visitor_ids,
    appschema.zzz_teams as t
  WHERE
    visitor_ids.visitor_team_id = t.team_id
  ORDER BY
    game_date DESC


-- create gold table
-- create gold table
CREATE LIVE TABLE final_score_data COMMENT "Aggregate game record data" TBLPROPERTIES ("quality" = "gold") AS
SELECT
  winner AS team,
  count(winner) AS wins,
  -- Each team played in 4 games.
  (4 - count(winner)) AS losses
FROM
  (
    -- Step 1 of 2: Determine the winner and loser for each game.
    SELECT
      game_id,
      winner,
      CASE
        WHEN home = winner THEN visitor
        ELSE home
      END AS loser
    FROM
      dlt_demo_database.cleaned_game_details
  )
GROUP BY
  winner
ORDER BY
  wins DESC