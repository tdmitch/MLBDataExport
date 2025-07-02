import Python.getGamesBySeason as getGamesBySeason, Python.extractPlateAppearancesAndPitches as extractPlateAppearancesAndPitches,getPlayersBySeason, getTeamsBySeason

Season = 2023

# getGameIdsBySeason.getGames(Season,'S')
getGamesBySeason.wholeSeason(Season)

    # 'R' - Regular Seasonwho
    # 'S' - Spring Training
    # 'E' - Exhibition
    # 'A' - All Star Game
    # 'D' - Division Series
    # 'F' - First Round (Wild Card)
    # 'L' - League Championship
    # 'W' - World Series


extractPlateAppearancesAndPitches.getPitches(Season)

getPlayersBySeason.getPlayers(Season)

getTeamsBySeason.getTeams(Season)

# execute Load_fact.Season SP
# execute Load_fact.

# run comparison