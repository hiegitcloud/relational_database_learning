#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals)+SUM(opponent_goals)
               FROM games
               ;")"


echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals)
               FROM games
               ;")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL " SELECT ROUND(AVG(winner_goals), 2)
                FROM games
                ;")"

echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL " SELECT AVG(opponent_goals)+AVG(winner_goals)
                FROM games
                ;")"

echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL " SELECT MAX(winner_goals)
                FROM games
                ;")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL " SELECT COUNT(game_id)
                FROM games
                WHERE winner_goals > 2
                ;")"

echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "SELECT t.name
               FROM (SELECT winner_id
                     FROM games
                     WHERE year=2018 AND round='Final'
                     ) AS w
                JOIN teams t ON w.winner_id=t.team_id
                ;")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL " WITH win AS (
                  SELECT winner_id id, year
                  FROM games
                  WHERE year=2014 AND round='Eighth-Final'
                  ),
                
                opp AS (
                  SELECT opponent_id id, year
                  FROM games
                  WHERE year=2014 AND round='Eighth-Final'
                  )
            
                SELECT t.name
                FROM teams t
                LEFT JOIN win ON t.team_id=win.id
                LEFT JOIN opp ON t.team_id=opp.id
                WHERE win.year IS NOT NULL OR opp.year IS NOT NULL
                ORDER BY t.name ASC
                ;")"

echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL " SELECT DISTINCT t.name 
                FROM teams t
                JOIN games g ON t.team_id=g.winner_id
                ORDER BY t.name ASC
                ;")"

echo -e "\nYear and team name of all the champions:"
echo "$($PSQL " SELECT w.year, t.name
                FROM (SELECT year, winner_id
                      FROM games
                      WHERE round='Final'
                      ) AS w
                JOIN teams t ON w.winner_id=t.team_id
                ;")"

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT name 
               FROM teams 
               WHERE name LIKE 'Co%'
               ;")"