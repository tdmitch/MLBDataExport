# '''
# Once a game is complete, the full dataset for the game can be accessed with this api:
#     https://statsapi.mlb.com/api/v1.1/game/631377/feed/live/

#     https://statsapi.mlb.com/api/v1.1/game/${gameid}/feed/live/

#     here is a URL for the image sources for team Hat logos https://www.mlbstatic.com/team-logos/team-cap-on-light/108.svg

#     for the current day's schedule: http://statsapi.mlb.com/api/v1/schedule/games/?sportId=1

#     for the mlb schedule on a given date http://statsapi.mlb.com/api/v1/schedule/games/?sportId=1&date=04/10/2018

#     use this to get the begining and end dates for seasons GET http://lookup-service-prod.mlb.com/json/named.org_game_type_date_info.bam?current_sw='Y'&sport_code='mlb'&game_type='L'&season='2017'
#     'R' - Regular Season
#     'S' - Spring Training
#     'E' - Exhibition
#     'A' - All Star Game
#     'D' - Division Series
#     'F' - First Round (Wild Card)
#     'L' - League Championship
#     'W' - World Series
# '''
# Dependencies
    # requests
    # pandas

# requests is used for calling APIs
import requests

# for date manipulation
from datetime import datetime #, timedelta

# pyodbc is used for connecting to the database
import pyodbc

# i think i need this one so that i can output the error messages in try catch
import sys

def getPitches(season):
# INITIALIZE SQL STUFF

    # define the database connection parameters
    conn = pyodbc.connect(
        'Driver={SQL Server};'
        'Server=DESKTOP-3J5KVRA;'
        'Database=MLB;'
        'Trusted_Connection=yes;'
        )




    # initialize cursor
    cursor = conn.cursor()

    # build select statement
    # selectGameId = f'SELECT G.[gameId] FROM [MLB].[dbo].[Game] G WHERE G.[season]<2019 AND G.[season]>=2010'
    selectGameId = f'SELECT DISTINCT G.[gameId] FROM [MLB].[dbo].[Game] G WHERE G.[season]={season} AND detailedState NOT IN (\'Postponed\', \'Cancelled\')'
    
    # use this for testing a single game load
    # selectGameId = f'SELECT DISTINCT G.[gameId] FROM [MLB].[dbo].[Game] G WHERE G.[season]={season} AND detailedState NOT IN (\'Postponed\', \'Cancelled\') AND g.[gameId] = 566085'

    # execute the sql statement
    games = cursor.execute(selectGameId)
    # get all rows from the sql return value
    games = games.fetchall()

    # itereate over the rows returned
    for game in games:  
        
        #build game feed request string - the wierd syntax on game is because game is a pyodbc.Row type, so the [0] index returns just the first column in the row (even tho there is only one column)
        gameFeedRequest = f'https://statsapi.mlb.com/api/v1.1/game/{game[0]}/feed/live/'

        # Get the records from the api
        # get the full JSON data for a complete MLB game
        gameFeed = requests.get(gameFeedRequest)

        #print(gameFeedRequest)
        
        #convert the response to json
        gameFeed = gameFeed.json()
        
        #Use gameFeed['liveData']['plays']['allPlays']['pitchIndex'] to iterate through the pitches
        print(gameFeed['gamePk'])
        # assign gameId outside the loop
        gameId                          = gameFeed['gamePk']

        # loop through all the plays in the game
        for play in gameFeed['liveData']['plays']['allPlays']:
            #print(play)
            try:
                pitcherId               = play['matchup']['pitcher']['id'] 
                pitchHand               = play['matchup']['pitchHand']['code']
                batterId                = play['matchup']['batter']['id']
                batSide                 = play['matchup']['batSide']['code']
                atBatIndex              = play['atBatIndex']

                #about
                halfInning              = play['about']['halfInning']
                inning                  = play['about']['inning']
                playStartTime           = play['about']['startTime']
                playEndTime             = play['about']['endTime']
                isScoringPlay           = play['about']['isScoringPlay']

                playStartTime = datetime.strptime(playStartTime,'%Y-%m-%dT%H:%M:%S.%fZ')
                playEndTime = datetime.strptime(playEndTime,'%Y-%m-%dT%H:%M:%S.%fZ')

                playStartTime = datetime.strftime(playStartTime, '%Y%m%d %H:%M:%S') 
                playEndTime =  datetime.strftime(playEndTime, '%Y%m%d %H:%M:%S')

                #result
                resultType             = play['result']['type']
                event                  = play['result']['event']
                eventType              = play['result']['eventType']
                rbi                    = play['result']['rbi']
                awayScore              = play['result']['awayScore']
                homeScore              = play['result']['homeScore']

                # build insert statement for [dbo].[plateAppearances]
                SqlInsertStatementPlateAppearance = ("INSERT INTO [MLB].[dbo].[PlateAppearance]"
                        "(GameId, halfInning, inning, atBatIndex, pitcherId, pitchHand, batterId, batSide, startTime, endTime, isScoringPlay, resultType, event, eventType, rbi, awayScore, homeScore)"
                        f'VALUES ({gameId}, \'{halfInning}\',{inning},{atBatIndex},{pitcherId},\'{pitchHand}\',{batterId},\'{batSide}\',\'{playStartTime}\',\'{playEndTime}\',\'{isScoringPlay}\',\'{resultType}\',\'{event}\',\'{eventType}\',{rbi},{awayScore},{homeScore})')
                                        #insert a record
                # print(SqlInsertStatementPlateAppearance)
                cursor.execute(SqlInsertStatementPlateAppearance)

                # #without this it doesnt commit - giving you a chance to check the execution and confirm it worked,. Your can query before commit
                conn.commit()

                # #loop through all the play events in each play node
                for playEvent in play['playEvents']:
                    # check for event type pitch 
                    if playEvent['isPitch'] == True:
                        playId              = playEvent['playId']
                        # gameId
                        # pitcherId
                        # batterId
                        # atBatIndex
                        pitchNumber         = playEvent['pitchNumber']
                        # details
                        isInPlay            = playEvent['details']['isInPlay']
                        isStrike            = playEvent['details']['isStrike']
                        isBall              = playEvent['details']['isBall']
                        callCode            = playEvent['details']['call']['code']
                        typeCode            = playEvent['details']['type']['code']
                        # count
                        countBalls          = playEvent['count']['balls']
                        countStrikes        = playEvent['count']['strikes']
                        # pitchData
                        startSpeed          = playEvent['pitchData']['startSpeed']
                        endSpeed            = playEvent['pitchData']['endSpeed']
                        strikeZoneTop       = playEvent['pitchData']['strikeZoneTop']
                        strikeZoneBottom    = playEvent['pitchData']['strikeZoneBottom']
                        # pitchData coordinates
                        aY                  = playEvent['pitchData']['coordinates']['aY']
                        aZ                  = playEvent['pitchData']['coordinates']['aZ']
                        pfxX                = playEvent['pitchData']['coordinates']['pfxX']
                        pfxZ                = playEvent['pitchData']['coordinates']['pfxZ']
                        pX                  = playEvent['pitchData']['coordinates']['pX']
                        pZ                  = playEvent['pitchData']['coordinates']['pZ']
                        vX0                 = playEvent['pitchData']['coordinates']['vX0']
                        vY0                 = playEvent['pitchData']['coordinates']['vY0']
                        vZ0                 = playEvent['pitchData']['coordinates']['vZ0']
                        x                   = playEvent['pitchData']['coordinates']['x'] 
                        y                   = playEvent['pitchData']['coordinates']['y']
                        x0                  = playEvent['pitchData']['coordinates']['x0']
                        y0                  = playEvent['pitchData']['coordinates']['y0']
                        z0                  = playEvent['pitchData']['coordinates']['z0']
                        aX                  = playEvent['pitchData']['coordinates']['aX']
                        # breaks                                               
                        try:
                            breakAngle          = playEvent['pitchData']['breaks']['breakAngle']
                        except:
                            breakAngle          = 0
                        try:
                            breakLength         = playEvent['pitchData']['breaks']['breakLength']
                        except:
                            breakLength         = 0
                        try:
                            breakY              = playEvent['pitchData']['breaks']['breakY']
                        except:
                            breakY              = 0
                        try:
                            spinRate            = playEvent['pitchData']['breaks']['spinRate']
                        except:
                            spinRate            = 0
                        try:
                            spinDirection       = playEvent['pitchData']['breaks']['spinDirection']
                        except:
                            spinDirection       = 0
                        try:
                            zone                = playEvent['pitchData']['zone']
                        except:
                            zone                = 0    
                        try:
                            plateTime           = playEvent['pitchData']['plateTime']
                        except:
                            plateTime           = 0
                        # hit data
                        try:
                            launchSpeed         = playEvent['hitData']['launchSpeed']
                            launchAngle         = playEvent['hitData']['launchAngle']
                            totalDistance       = playEvent['hitData']['totalDistance']
                            trajectory          = playEvent['hitData']['trajectory']
                            hardness            = playEvent['hitData']['hardness']
                            location            = playEvent['hitData']['location']
                            # hit coordinates 
                            coordX              = playEvent['hitData']['coordinates']['coordX']
                            coordY              = playEvent['hitData']['coordinates']['coordY']
                        except KeyError:
                            launchSpeed         = 0
                            launchAngle         = 0
                            totalDistance       = 0
                            trajectory          = 0
                            hardness            = 0
                            location            = 0
                            # hit coordinates 
                            coordX              = 0
                            coordY              = 0

                        #build sql statement
                        SqlInsertStatement = ("INSERT INTO [MLB].[dbo].[Pitch]"
                        "(playId, gameId, pitcherId, batterId, atBatIndex, pitchNumber, isInPlay, isStrike, isBall, callCode, typeCode, countBalls, countStrikes, startSpeed, endSpeed, strikeZoneTop, strikeZoneBottom, aY, aZ, pfxX, pfxZ, pX, pZ, vX0, vY0, vZ0, x, y, x0, y0, z0, aX, breakAngle, breakLength, breakY, spinRate, spinDirection, zone, plateTime, launchSpeed, launchAngle, totalDistance, trajectory, hardness, location, coordX, coordY)"
                        f'VALUES (\'{playId}\',{gameId},{pitcherId},{batterId},{atBatIndex},{pitchNumber},\'{isInPlay}\',\'{isStrike}\',\'{isBall}\',\'{callCode}\',\'{typeCode}\',{countBalls},{countStrikes},{startSpeed},{endSpeed},{strikeZoneTop},{strikeZoneBottom},{aY},{aZ},{pfxX},{pfxZ},{pX},{pZ},{vX0},{vY0},{vZ0},{x},{y},{x0},{y0},{z0},{aX},{breakAngle},{breakLength},{breakY},{spinRate},{spinDirection},{zone},{plateTime},{launchSpeed},{launchAngle},{totalDistance},\'{trajectory}\',\'{hardness}\',{location},{coordX},{coordY})')

                        #print(SqlInsertStatement)
                        
                        #insert a record
                        cursor.execute(SqlInsertStatement)

                        # #without this it doesnt commit - giving you a chance to check the execution and confirm it worked,. Your can query before commit
                        conn.commit()
                    
            except KeyError:
                #if there is a key error - if the key isn't present, dont push to db
                print('Error', sys.exc_info()[0])