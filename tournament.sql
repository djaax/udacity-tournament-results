-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.


DROP DATABASE IF EXISTS tournament;

CREATE DATABASE tournament;
\c tournament;

DROP TABLE IF EXISTS players CASCADE;
DROP TABLE IF EXISTS matches CASCADE;
DROP VIEW IF EXISTS standings CASCADE;

CREATE TABLE players (
	id SERIAL PRIMARY KEY,
	fullname varchar(255)
);

CREATE TABLE matches (
	winner integer REFERENCES players (id),
	loser integer REFERENCES players (id),
	PRIMARY KEY (winner, loser) 
);

CREATE VIEW standings AS
	SELECT players.id as player_id, players.fullname as player_name,
	(SELECT count(*) FROM matches WHERE matches.winner = players.id) as wins,
	(SELECT count(*) FROM matches WHERE players.id in (winner, loser)) as matches
	FROM players
	GROUP BY players.id
	ORDER BY wins DESC;

