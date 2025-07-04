import requests
import db


def getTeams(Season):

    # build the string to request the team data by season
    getTeams = f"https://statsapi.mlb.com/api/v1/teams?sportId=1&season={Season}"

    # get the teams details
    getTeamDetails = requests.get(getTeams)

    # format as json
    teams = getTeamDetails.json()["teams"]

    teamsList = []

    for team in teams:
        teamDetails = {}

        teamDetails['id'] = team['id'] 
        teamDetails['season'] = team['season']
        teamDetails['name'] = team['name']
        teamDetails['teamName'] = team['teamName']
        teamDetails['locationName'] = team.get('locationName', None)
        teamDetails['firstYearOfPlay'] = team['firstYearOfPlay']
        teamDetails['link'] = team['link']
        teamDetails['teamCode'] = team['teamCode']
        teamDetails['fileCode'] = team['fileCode']
        teamDetails['abbreviation'] = team['abbreviation']
        teamDetails['allStarStatus'] = team['allStarStatus']
        teamDetails['shortName'] = team['shortName']
        teamDetails['franchiseName'] = team['franchiseName']
        teamDetails['clubName'] = team['clubName']
        teamDetails['active'] = team['active']

        # Optional or potentially missing fields
        teamDetails['springLeague'] = None
        if team.get('springLeague'):
            teamDetails['springLeague'] = team['springLeague'].get('name', None)        

        # Some expansions teams don't have a venue defined
        teamDetails['venueID'] = None
        teamDetails['venueName'] = None
        if team.get('venue'):
            teamDetails['venueID'] = team['venue'].get('id', None)
            teamDetails['venueName'] = team['venue'].get('name', None)
        
        # Some teams (such as the Rays in 1997) don't have a league defined
        teamDetails['leagueName'] = None
        if team.get('league'):
            teamDetails['leagueName'] = team['league'].get('name', None)

        # Some teams (such as the Rays in 1997) don't have a division defined
        teamDetails['divisionName'] = None
        if team.get('division'):
            teamDetails['divisionName'] = team['division'].get('name', None)

        teamsList.append(teamDetails)

    # Create the raw table
    # db.create_table('raw.Team', teamsList, True)

    # Load the raw table
    db.insert_rows('raw.Team', teamsList)


if __name__ == "__main__":
    season = 2025
    while True:
        try:
            getTeams(season)
            season -= 1
        except Exception as e:
            print(f"An error occurred while processing season {season}: {e}")
            break
    
