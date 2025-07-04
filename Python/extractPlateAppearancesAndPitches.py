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

    
    # Load environment variables from .env file
    source_dir = os.getenv('DOWNLOAD_DIR') + "\\gameDetails"


    # Get list of all JSON files in the download directory
    json_files = [f for f in os.listdir(source_dir) if f.endswith('.json')]


    for filename in json_files:
        filepath = os.path.join(source_dir, filename)

        plateAppearances = []
        pitches = []

        gameFeed = None

        with open(filepath, 'r', encoding='utf-8') as f:
            gameFeed = json.load(f)  # Load the JSON data from the file
            
        
        # assign gameId outside the plays loop
        gameId = gameFeed['gamePk']
        

        # loop through all the plays in the game
        for play in gameFeed['liveData']['plays']['allPlays']:
            playValues = {}
            playValues['gameId']                    = gameId
            playValues['pitcherId']               = play['matchup']['pitcher']['id'] 
            playValues['pitchHand']               = play['matchup']['pitchHand']['code']
            playValues['batterId']                = play['matchup']['batter']['id']
            playValues['batSide']                 = play['matchup']['batSide']['code']
            playValues['atBatIndex']              = play['atBatIndex']

            #about
            playValues['halfInning']              = play['about'].get('halfInning', 'NULL')
            playValues['inning']                  = play['about'].get('inning', 'NULL')
            playValues['startTime']              = play['about'].get('startTime', 'NULL')
            playValues['endTime']             = play['about'].get('endTime', 'NULL')
            playValues['isScoringPlay']           = play['about'].get('isScoringPlay', 'NULL')

            #result
            playValues['resultType']             = play['result'].get('type', 'NULL')
            playValues['event']                  = play['result'].get('event', 'NULL')
            playValues['eventType']              = play['result'].get('eventType', 'NULL')
            playValues['rbi']                    = play['result'].get('rbi', 'NULL')
            playValues['awayScore']              = play['result'].get('awayScore', 'NULL')
            playValues['homeScore']              = play['result'].get('homeScore', 'NULL')

            # Add this plate appearance to the list
            plateAppearances.append(playValues)


            # #loop through all the play events in each play node
            for playEvent in play['playEvents']:
            # check for event type pitch 
                if playEvent['isPitch'] == True:

                    # Store pitch values in a dictionary
                    pitchValues = {}     
                    pitchValues['gameId']             = gameId
                    pitchValues['atBatIndex']         = playValues['atBatIndex']
                    pitchValues['pitcherId']          = playValues['pitcherId']
                    pitchValues['batterId']           = playValues['batterId']

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

                    pitches.append(pitchValues)


        # Insert plate appearances
        db.insert_rows('raw.PlateAppearance', plateAppearances)       

        # Insert pitches
        db.insert_rows('raw.Pitch', pitches)
                