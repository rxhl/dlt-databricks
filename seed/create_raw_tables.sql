-- Make sure you are using the right schema (database) name
SHOW DATABASES;
USE appschema;



-- Drop tables if created already
DROP TABLE IF EXISTS zzz_game_opponents;
DROP TABLE IF EXISTS zzz_game_scores;
DROP TABLE IF EXISTS zzz_games;
DROP TABLE IF EXISTS zzz_teams;



-- Create and populate game_opponents table
CREATE TABLE zzz_game_opponents (
game_id INT,
home_team_id INT,
visitor_team_id INT
) USING DELTA;

INSERT INTO zzz_game_opponents VALUES (1, 1, 2);
INSERT INTO zzz_game_opponents VALUES (2, 1, 3);
INSERT INTO zzz_game_opponents VALUES (3, 2, 1);
INSERT INTO zzz_game_opponents VALUES (4, 2, 3);
INSERT INTO zzz_game_opponents VALUES (5, 3, 1);
INSERT INTO zzz_game_opponents VALUES (6, 3, 2);



-- Create and populate game_scores table
CREATE TABLE zzz_game_scores (
game_id INT,
home_team_score INT,
visitor_team_score INT
) USING DELTA;

INSERT INTO zzz_game_scores VALUES (1, 4, 2);
INSERT INTO zzz_game_scores VALUES (2, 0, 1);
INSERT INTO zzz_game_scores VALUES (3, 1, 2);
INSERT INTO zzz_game_scores VALUES (4, 3, 2);
INSERT INTO zzz_game_scores VALUES (5, 3, 0);
INSERT INTO zzz_game_scores VALUES (6, 3, 1);



-- Create and populate games table
CREATE TABLE zzz_games (
game_id INT,
game_date DATE
) USING DELTA;

INSERT INTO zzz_games VALUES (1, '2020-12-12');
INSERT INTO zzz_games VALUES (2, '2021-01-09');
INSERT INTO zzz_games VALUES (3, '2020-12-19');
INSERT INTO zzz_games VALUES (4, '2021-01-16');
INSERT INTO zzz_games VALUES (5, '2021-01-23');
INSERT INTO zzz_games VALUES (6, '2021-02-06');



-- Create and populate teams table
CREATE TABLE zzz_teams (
team_id INT,
team_city VARCHAR(15)
) USING DELTA;

INSERT INTO zzz_teams VALUES (1, "San Francisco");
INSERT INTO zzz_teams VALUES (2, "Seattle");
INSERT INTO zzz_teams VALUES (3, "Amsterdam");