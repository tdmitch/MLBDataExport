# for api calls
import requests

# for date manipulation
from datetime import datetime, timedelta

# pyodbc is used for connecting to the database
import pyodbc

# pandas is used for a bunch a cool stuff i think, i don't really know. here i want to use it to read the sql query results
# define the database connection parameters
import pandas

# i think i need this one so that i can output the error messages in try catch
import sys

# INITIALIZE SQL STUFF

# define the database connection parameters
conn = pyodbc.connect(
    'Driver={SQL Server};'
    'Server=1S343Z2;'
    'Database=MLB;'
    'Trusted_Connection=yes;'
    )
# initialize cursor
cursor = conn.cursor()

def getTeams(Season):

    # build the string to request the team data by season
    getTeams = f"http://lookup-service-prod.mlb.com/json/named.team_all_season.bam?sport_code='mlb'&all_star_sw='N'&season='{Season}'"

    # get the teams details
    getTeamDetails = requests.get(getTeams)

    # format as json
    getTeamDetails = getTeamDetails.json()

    teams = getTeamDetails['team_all_season']['queryResults']['row']

    for team in teams:
        try: 
            teamId = team['team_id']
            name = team['name']
            fullName = team['name_display_full']
            abbrevName = team['mlb_org_abbrev']
            leagueId = team['league_id']
            league= team['league_abbrev']
            divisionId = team['division_id']
            division = team['division']
            venueName = team['venue_name']
            venueId = team['venue_id']
            city = team['city']
            state = team['state']
                        
            # #build sql statement
            SqlInsertStatement = ("INSERT INTO [MLB].[dbo].[Team]"
            "(teamId, name, fullName, abbrevName, leagueId, league, divisionId, division, venueName, venueId, city, state)"
            f"VALUES ({teamId}, \'{name}\', \'{fullName}\', \'{abbrevName}\', {leagueId}, \'{league}\', {divisionId}, \'{division}\', \'{venueName}\', {venueId}, \'{city}\',\'{state}\')")

            print(SqlInsertStatement)
            
            # #insert a record
            cursor.execute(SqlInsertStatement)

            # #without this it doesnt commit - giving you a chance to check the execution and confirm it worked,. Your can query before commit
            conn.commit()

        except KeyError:
            #if there is a key error - if the key isn't present, dont push to db
            print('Error', sys.exc_info()[0])

