import requests
from datetime import datetime #, timedelta
import pyodbc
import sys
import db
import os
# from dotenv import load_dotenv
import json


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


def extractPlateAppearancesAndPitches():

    # Get connection to the database
    conn = db.connect_to_db()

    # initialize cursor
    cursor = conn.cursor()

    # Load environment variables from .env file
    source_dir = os.getenv('DOWNLOAD_DIR') + "\\gameDetails"


    # Get list of all JSON files in the download directory
    json_files = [f for f in os.listdir(source_dir) if f.endswith('.json')]


    for filename in json_files:
        filepath = os.path.join(source_dir, filename)

        gameFeed = None

        with open(filepath, 'r', encoding='utf-8') as f:
            gameFeed = json.load(f)  # Load the JSON data from the file
            
        
        # assign gameId outside the plays loop
        gameId = gameFeed['gamePk']
        

        # loop through all the plays in the game
        for play in gameFeed['liveData']['plays']['allPlays']:
            pitcherId               = play['matchup']['pitcher']['id'] 
            pitchHand               = play['matchup']['pitchHand']['code']
            batterId                = play['matchup']['batter']['id']
            batSide                 = play['matchup']['batSide']['code']
            atBatIndex              = play['atBatIndex']

            #about
            halfInning              = play['about'].get('halfInning', 'NULL')
            inning                  = play['about'].get('inning', 'NULL')
            playStartTime           = play['about'].get('startTime', 'NULL')
            playEndTime             = play['about'].get('endTime', 'NULL')
            isScoringPlay           = play['about'].get('isScoringPlay', 'NULL')

            #playStartTime = datetime.strptime(playStartTime,'%Y-%m-%dT%H:%M:%S.%fZ')
            #playEndTime = datetime.strptime(playEndTime,'%Y-%m-%dT%H:%M:%S.%fZ')

            #playStartTime = datetime.strftime(playStartTime, '%Y%m%d %H:%M:%S') 
            #playEndTime =  datetime.strftime(playEndTime, '%Y%m%d %H:%M:%S')

            #result
            resultType             = play['result'].get('type', 'NULL')
            event                  = play['result'].get('event', 'NULL')
            eventType              = play['result'].get('eventType', 'NULL')
            rbi                    = play['result'].get('rbi', 'NULL')
            awayScore              = play['result'].get('awayScore', 'NULL')
            homeScore              = play['result'].get('homeScore', 'NULL')

            # build insert statement for [raw].[plateAppearances]
            SqlInsertStatementPlateAppearance = ("INSERT INTO [raw].[PlateAppearance]"
                    "(GameId, halfInning, inning, atBatIndex, pitcherId, pitchHand, batterId, batSide, startTime, endTime, isScoringPlay, resultType, event, eventType, rbi, awayScore, homeScore)"
                    f'VALUES ({gameId}, \'{halfInning}\',{inning},{atBatIndex},{pitcherId},\'{pitchHand}\',{batterId},\'{batSide}\',\'{playStartTime}\',\'{playEndTime}\',\'{isScoringPlay}\',\'{resultType}\',\'{event}\',\'{eventType}\',{rbi},{awayScore},{homeScore})')
                                    #insert a record
            
            SqlInsertStatementPlateAppearance = SqlInsertStatementPlateAppearance.replace('None', 'NULL').replace('\'NULL\'', 'NULL')
            
            cursor.execute(SqlInsertStatementPlateAppearance)
            conn.commit()

            # #loop through all the play events in each play node
            for playEvent in play['playEvents']:
            # check for event type pitch 
                if playEvent['isPitch'] == True:

                    # Store pitch values in a dictionary
                    pitchValues = {}     
                    pitchValues['gameId']             = gameId
                    pitchValues['atBatIndex']         = atBatIndex
                    pitchValues['pitcherId']          = pitcherId   
                    pitchValues['batterId']          = batterId
                    
                    pitchValues['playId']              = playEvent['playId']
                    pitchValues['pitchNumber']         = playEvent['pitchNumber']
                    # details
                    pitchValues['isInPlay']            = playEvent['details']['isInPlay']
                    pitchValues['isStrike']            = playEvent['details']['isStrike']
                    pitchValues['isBall']              = playEvent['details']['isBall']
                    pitchValues['callCode']            = playEvent['details']['call']['code']
                    pitchValues['typeCode']            = playEvent['details'].get('type', {}).get('code', None)
                    # count
                    pitchValues['countBalls']         = playEvent['count']['balls']
                    pitchValues['countStrikes']        = playEvent['count']['strikes']
                    
                    # pitchData
                    pitchData = playEvent.get('pitchData', None)
                    if pitchData is not None:                       
                        pitchValues['startSpeed']          = pitchData.get('startSpeed', 'NULL')
                        pitchValues['endSpeed']            = pitchData.get('endSpeed', 'NULL')
                        pitchValues['strikeZoneTop']       = pitchData.get('strikeZoneTop', 'NULL')
                        pitchValues['strikeZoneBottom']    = pitchData.get('strikeZoneBottom', 'NULL')
                        pitchValues['zone']                = pitchData.get('zone', 'NULL')
                        pitchValues['plateTime']           = pitchData.get('plateTime', 'NULL')
                        
                        
                        # coordinates
                        coordinates         = pitchData.get('coordinates', None)
                        if coordinates is not None:                            
                            pitchValues['aY']                  = coordinates.get('aY', 'NULL')
                            pitchValues['aZ']                  = coordinates.get('aZ', 'NULL')
                            pitchValues['pfxX']                = coordinates.get('pfxX', 'NULL')
                            pitchValues['pfxZ']                = coordinates.get('pfxZ', 'NULL')
                            pitchValues['pX']                  = coordinates.get('pX', 'NULL')
                            pitchValues['pZ']                  = coordinates.get('pZ', 'NULL')
                            pitchValues['vX0']                 = coordinates.get('vX0', 'NULL')
                            pitchValues['vY0']                 = coordinates.get('vY0', 'NULL')
                            pitchValues['vZ0']                 = coordinates.get('vZ0', 'NULL')
                            pitchValues['x']                   = coordinates.get('x', 'NULL') 
                            pitchValues['y']                   = coordinates.get('y', 'NULL') 
                            pitchValues['x0']                  = coordinates.get('x0', 'NULL')
                            pitchValues['y0']                  = coordinates.get('y0', 'NULL')
                            pitchValues['z0']                  = coordinates.get('z0', 'NULL')
                            pitchValues['aX']                  = coordinates.get('aX', 'NULL')
                        

                        # breaks                                               
                        breaks = pitchData.get('breaks', None)
                        if breaks is not None:
                            pitchValues['breakAngle']          = breaks.get('breakAngle', 'NULL')
                            pitchValues['breakLength']         = breaks.get('breakLength', 'NULL')
                            pitchValues['breakY']              = breaks.get('breakY', 'NULL')
                            pitchValues['spinRate']            = breaks.get('spinRate', 'NULL')
                            pitchValues['spinDirection']       = breaks.get('spinDirection', 'NULL')
                            
                        
                        hitData = playEvent.get('hitData', None)
                        if hitData is not None:
                            # hit data
                            pitchValues['launchSpeed']         = hitData.get('launchSpeed', 'NULL')
                            pitchValues['launchAngle']         = hitData.get('launchAngle', 'NULL')
                            pitchValues['totalDistance']       = hitData.get('totalDistance', 'NULL')
                            pitchValues['trajectory']          = hitData.get('trajectory', 'NULL')
                            pitchValues['hardness']            = hitData.get('hardness', 'NULL')
                            pitchValues['location']            = hitData.get('location', 'NULL')
                            
                            # hit coordinates 
                            hitDataCoordinates = hitData.get('coordinates', None)
                            if hitDataCoordinates is not None:
                                pitchValues['coordX']              = hitDataCoordinates.get('coordX', 'NULL')
                                pitchValues['coordY']              = hitDataCoordinates.get('coordY', 'NULL')

                    ############################################################################################################################################

                    #build sql statement
                    sqlKeys = ", ".join([f"[{key}]" for key in pitchValues.keys()])
                    sqlValues = ", ".join([f"\'{pitchValues[key]}\'" for key in pitchValues.keys()])

                    SqlInsertStatement = f"INSERT INTO [raw].[Pitch] ({sqlKeys})\nVALUES ({sqlValues})"
                    
                    SqlInsertStatement = SqlInsertStatement.replace('None', 'NULL').replace('\'NULL\'', 'NULL') 
                    
                    #insert a record
                    cursor.execute(SqlInsertStatement)

                    # #without this it doesnt commit - giving you a chance to check the execution and confirm it worked,. Your can query before commit
                    conn.commit()
                
                