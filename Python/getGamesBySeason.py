import requests
import db
from datetime import datetime, timedelta
import pyodbc

# INITIALIZE SQL STUFF

def getGamesBySeason(season):

    print(f"Getting Games for {season} Season")
        
    # define the database connection parameters
    conn = db.connect_to_db()


    # initialize cursor
    cursor = conn.cursor()


    # Set min/max dates for the season
    StartDate = f"{season}-02-01"
    EndDate = f"{season}-11-30"
    
    
    # convert the start date and end date to date time value
    first_game_date = datetime.strptime(StartDate,'%Y-%m-%d')
    last_game_date = datetime.strptime(EndDate,'%Y-%m-%d')
    
    # # calculate the difference between start and end date
    delta = last_game_date - first_game_date
    
    
    # iterate through each date in the range
    for i in range(delta.days + 1):
        gameDate = (first_game_date + timedelta(days = i))
        # convert date to datestring in mm/dd/yyy format
        gameDate = gameDate.strftime("%m/%d/%Y")
        
        # build request string
        scheduleRequestString = f"http://statsapi.mlb.com/api/v1/schedule/games/?sportId=1&date={gameDate}"
        schedule = requests.get(scheduleRequestString)
        
        # convert to json
        schedule=schedule.json()

        games = []
        
        # get the total number of games played that day
        if schedule['totalGames'] > 0:
            for game in schedule['dates'][0]['games']:
                gameDetails = {}
                gameDetails['season'] = season
                gameDetails['gameId'] = (game['gamePk'])
                gameDetails['gameType'] = (game['gameType'])
                gameDetails['doubleHeader'] = (game['doubleHeader'])
                gameDetails['gamedayType'] = (game['gamedayType'])
                gameDetails['tiebreaker'] = (game['tiebreaker'])
                gameDetails['dayNight'] = (game['dayNight'])
                gameDetails['gamesInSeries'] = game.get('gamesInSeries', 'NULL')
                gameDetails['seriesGameNumber'] = game.get('seriesGameNumber', 'NULL')
                gameDetails['gameDateTime'] = (game['gameDate'])
                gameDetails['detailedState'] = (game['status']['detailedState'])
                try:
                    gameDetails['reason'] = (game['status']['status'])
                except:
                    gameDetails['reason'] = ''
                gameDetails['homeTeam'] = (game['teams']['home']['team']['id'])
                gameDetails['awayTeam'] = (game['teams']['away']['team']['id'])
                gameDetails['venue'] = (game['venue']['id'])

                games.append(gameDetails)
   
        db.insert_rows('raw.Game', games)
