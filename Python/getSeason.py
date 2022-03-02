import getGameIdsBySeason, getPitchesBySeason, getPlayersBySeason, getTeamsBySeason

Season = 2021

getGameIdsBySeason.getGames(Season,'S')

    # 'R' - Regular Season
    # 'S' - Spring Training
    # 'E' - Exhibition
    # 'A' - All Star Game
    # 'D' - Division Series
    # 'F' - First Round (Wild Card)
    # 'L' - League Championship
    # 'W' - World Series

getPitchesBySeason.getPitches(Season)

getPlayersBySeason.getPlayers(Season)

getTeamsBySeason.getTeams(Season)

# execute Load_fact.Season SP
# execute Load_fact.

# run comparison