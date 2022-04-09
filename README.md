# MLB_Database
Py proj to build a killer mlb db

Building out the project fresh is not automated. I am picking this back up for the 2022 season

Questions
    1. How do you account for what happens on the field? Do you?
    2. 


Build Automation
  1. DDL - Database Schema Build 
    a. For each object in SQL/DDL check to see if it exits and if not, create
    b. Should I be scripting out the DB to deploy to git to make sure I dont forget to save any db object script      changes that I make? Thats probably better than what im doing

  2. 






Once a game is complete, the full dataset for the game can be accessed with this api:
    https://statsapi.mlb.com/api/v1.1/game/631377/feed/live/

    https://statsapi.mlb.com/api/v1.1/game/${gameid}/feed/live/
    