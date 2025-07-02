# for api calls
import requests
import db

# for date manipulation
from datetime import datetime, timedelta

# pyodbc is used for connecting to the database
import pyodbc

# i think i need this one so that i can output the error messages in try catch
import sys

# INITIALIZE SQL STUFF

def getGamesBySeason(season):

    print(f"Getting Games for {season} Season")
        
    # define the database connection parameters
    conn = db.connect_to_db()


    # initialize cursor
    cursor = conn.cursor()


    # Set min/max dates for the season
    StartDate = f"{season}-03-01"
    EndDate = f"{season}-11-15"
    
    
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
        
        # get the total number of games played that day
        if schedule['totalGames']>0:
            for game in schedule['dates'][0]['games']:
                gameId        = (game['gamePk'])
                gameType     = (game['gameType'])
                doubleHeader = (game['doubleHeader'])
                gamedayType = (game['gamedayType'])
                tiebreaker = (game['tiebreaker'])
                dayNight = (game['dayNight'])
                gamesInSeries = game.get('gamesInSeries', 'NULL')
                seriesGameNumber = game.get('seriesGameNumber', 'NULL')
                gameDateTime = (game['gameDate'])
                detailedState = (game['status']['detailedState'])
                try:
                    reason = (game['status']['status'])
                except:
                    reason =''
                homeTeam      = (game['teams']['home']['team']['id'])
                awayTeam      = (game['teams']['away']['team']['id'])
                venue         = (game['venue']['id'])

                #build sql statement
                SqlInsertStatement = ("INSERT INTO [dbo].[Game]"
                "(gameId, season, gameType, gameDate, detailedState, reason, homeTeam, awayTeam, venue, doubleHeader, gamedayType, tiebreaker, dayNight, gamesInSeries, seriesGameNumber, gameDateTime)"
                f'VALUES ({gameId}, {season}, \'{gameType}\', \'{gameDate}\', \'{detailedState}\', \'{reason}\', {homeTeam}, {awayTeam}, \'{venue}\', \'{doubleHeader}\', \'{gamedayType}\', \'{tiebreaker}\', \'{dayNight}\', {gamesInSeries}, {seriesGameNumber}, \'{gameDateTime}\')')

                #print(SqlInsertStatement)

                #insert a record
                cursor.execute(SqlInsertStatement)

                #without this it doesnt commit - giving you a chance to check the execution and confirm it worked,. Your can query before commit
                conn.commit()

    # except KeyError:
    #     #if there is a key error - if the key isn't present, dont push to db
    #     print('Error', sys.exc_info()[0])
    # # TO DO - use this loop to call and return the api to get the schedule and then commit it to the database
