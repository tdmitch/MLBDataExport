# for api calls
import requests

# for date manipulation
from datetime import datetime, timedelta

# pyodbc is used for connecting to the database
import pyodbc

# pandas is used for a bunch a cool stuff i think, i don't really know. here i want to use it to read the sql query results
import pandas

# i think i need this one so that i can output the error messages in try catch
import sys

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

def getPlayers(season):

    #build SQL statement to call SP
    getPlayerIdBySeason = f"EXEC [dbo].[getPlayerIdBySeason] {season}"

    playerIds = cursor.execute(getPlayerIdBySeason)
    # get all rows from the sql return value
    playerIds = playerIds.fetchall()

    for playerId in playerIds:
        playerId = playerId[0]
        # test player id 519058
        # print(playerId)
        # build the string to request the player data by player id
        getPlayerDetailsRequestString = f"http://lookup-service-prod.mlb.com/json/named.player_info.bam?sport_code='mlb'&player_id='{playerId}'"

        # get the player details
        getPlayerDetails = requests.get(getPlayerDetailsRequestString)

        # format as json
        getPlayerDetails = getPlayerDetails.json()

        try: 
            player = getPlayerDetails['player_info']['queryResults']['row']
            #print(player)
            firstName= player['name_first']
            firstName = firstName.replace("'","''")
            lastName= player['name_last']
            lastName = lastName.replace("'","''")
            jerseyNumber = player['jersey_number']
            weight = player['weight']
            heightFeet = player['height_feet']
            heightInches = player['height_inches']
            teamId = player['team_id']
            throws = player['throws']
            bats = player['bats']
            primaryPosition = player['primary_position']
            
            # #build sql statement
            SqlInsertStatement = ("INSERT INTO [MLB].[dbo].[Player]"
            "(playerId, firstName, lastName, jerseyNumber, weight, heightFeet, heightInches, teamId, throws, bats, primaryPosition)"
            f'VALUES ({playerId}, \'{firstName}\', \'{lastName}\',\'{jerseyNumber}\',{weight},{heightFeet},{heightInches},{teamId},\'{throws}\',\'{bats}\',\'{primaryPosition}\')')

            #print(SqlInsertStatement)
            
            # #insert a record
            cursor.execute(SqlInsertStatement)

            # #without this it doesnt commit - giving you a chance to check the execution and confirm it worked,. Your can query before commit
            conn.commit()

        except KeyError:
            #if there is a key error - if the key isn't present, dont push to db
            print('Error', sys.exc_info()[0])

