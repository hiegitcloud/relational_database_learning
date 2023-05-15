#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $winner != 'winner' ]]
  then
    WINNER=$($PSQL "SELECT name FROM teams WHERE name='$winner';")
    if [[ -z $WINNER ]]
    then
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$winner');")
    fi
  fi

  if [[ $opponent != 'opponent' ]]
  then
    OPPONENT=$($PSQL "SELECT name FROM teams WHERE name='$opponent';")
    if [[ -z $OPPONENT ]]
    then
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$opponent');")
    fi
  fi   

  if [[ $year != 'year' && $round != 'round' && $winner != 'winner' && $opponent != 'opponent' && $winner_goals != 'winner_goals' && $opponent_goals != 'opponent_goals' ]]
  then 
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$winner';")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent';")
    INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', $WINNER_ID, $OPPONENT_ID, $winner_goals, $opponent_goals);")
  fi
done


        
  