import requests
from datetime import datetime #, timedelta
import db
import os
import json

def downloadGamesBySeason(season):

    # Get connection to the database
    conn = db.connect_to_db()

    # initialize cursor
    cursor = conn.cursor()

    # build select statement
    selectGameId = f'SELECT DISTINCT G.[gameId] FROM [dbo].[Game] G WHERE G.[season]={season} AND detailedState NOT IN (\'Postponed\', \'Cancelled\', \'Scheduled\')'
    
    # execute the sql statement
    games = cursor.execute(selectGameId).fetchall()


    # itereate over the rows returned
    for game in games:  
        
        #build game feed request string - the wierd syntax on game is because game is a pyodbc.Row type, so the [0] index returns just the first column in the row (even tho there is only one column)
        gameFeedRequest = f'https://statsapi.mlb.com/api/v1.1/game/{game[0]}/feed/live/'

        # Get the records from the api
        # get the full JSON data for a complete MLB game
        gameFeed = requests.get(gameFeedRequest)

        
        #convert the response to json
        gameFeed = gameFeed.json()

        game_id = gameFeed["gameData"]["game"]["id"].replace("/", "_").replace("-", "_")
       
        outputDir = os.getenv('DOWNLOAD_DIR') + "\\gameDetails\\" + game_id + ".json"

        # Save the game feed to a file
        with open(outputDir, 'w', encoding='utf-8') as f:
            f.write(str(json.dumps(gameFeed)))  
