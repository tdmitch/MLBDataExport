# for api calls
import requests

# for date manipulation
from datetime import datetime, timedelta

# pyodbc is used for connecting to the database
import pyodbc

# pandas is used for a bunch a cool stuff i think, i don't really know. here i want to use it to read the sql query results
# define the database connection parameters
# import pandas

# i think i need this one so that i can output the error messages in try catch
import sys

# INITIALIZE SQL STUFF

def wholeSeason(season):
        
    # define the database connection parameters
    conn = pyodbc.connect(
        'Driver={SQL Server};'
        'Server=DESKTOP-3J5KVRA;'
        'Database=MLB;'
        'Trusted_Connection=yes;'
        )
    # initialize cursor
    cursor = conn.cursor()


    # TODO - For 2022 Data this needs to be re-factored to a different methodology. In 2022 we need to use the schedule api
    # I lost the schedule api previously used
    # need to do something different, this is a hack at best
    # loop through the dates from 3/1 to 11/31 (hypthetically) for the given season
    StartDate = '2023-03-1'
    StartDate = f"{season}-03-01"
    # EndDate = '2023-11/31'
    EndDate = f"{season}-11-15"
    
    # example api calls
    # DailyScheduleRequestString = f"https://statsapi.mlb.com/api/v1/schedule/games/?sportId=1&date={StartDate}"
    # DailyScheduleResponse = requests.get(DailyScheduleRequestString)
    # DailyScheduleResponse = DailyScheduleResponse.json()

    # def getGames(season, gameType):
        #set initial parameters
        # season = season
    gameType = 'R'

    # convert the start date and end date to date time value
    first_game_date = datetime.strptime(StartDate,'%Y-%m-%d')
    last_game_date = datetime.strptime(EndDate,'%Y-%m-%d')
    # # calculate the difference between start and end date
    delta = last_game_date - first_game_date
    
    print(delta)

    try:
        # iterate through each date in the range
        for i in range(delta.days + 1):
            gameDate = (first_game_date + timedelta(days = i))
            # convert date to datestring in mm/dd/yyy format
            gameDate = gameDate.strftime("%m/%d/%Y")
            # build request string
            scheduleRequestString = f"http://statsapi.mlb.com/api/v1/schedule/games/?sportId=1&date={gameDate}"
            # for the mlb schedule on a given date http://statsapi.mlb.com/api/v1/schedule/games/?sportId=1&date=04/10/2018
            schedule = requests.get(scheduleRequestString)
            # convert to json
            schedule=schedule.json()
            # get the total number of games played that day
            if schedule['totalGames']>0:
                for game in schedule['dates'][0]['games']:
                    gameId        = (game['gamePk'])
                    detailedState = (game['status']['detailedState'])
                    try:
                        reason = (game['status']['status'])
                    except:
                        reason =''
                    homeTeam      = (game['teams']['home']['team']['id'])
                    awayTeam      = (game['teams']['away']['team']['id'])
                    venue         = (game['venue']['id'])

                    #build sql statement
                    SqlInsertStatement = ("INSERT INTO [MLB].[dbo].[Game]"
                    "(gameId, season, gameType, gameDate, detailedState, reason, homeTeam, awayTeam, venue)"
                    f'VALUES ({gameId}, {season}, \'{gameType}\', \'{gameDate}\', \'{detailedState}\', \'{reason}\', {homeTeam}, {awayTeam}, \'{venue}\')')

                    #print(SqlInsertStatement)

                    #insert a record
                    cursor.execute(SqlInsertStatement)

                    #without this it doesnt commit - giving you a chance to check the execution and confirm it worked,. Your can query before commit
                    conn.commit()

    except KeyError:
        #if there is a key error - if the key isn't present, dont push to db
        print('Error', sys.exc_info()[0])
    # TO DO - use this loop to call and return the api to get the schedule and then commit it to the database
