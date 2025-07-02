import getGamesBySeason as g
import extractPlateAppearancesAndPitches as p
import downloadGameDetail as d


for year in range(2021, 2018, -1):
   # Download games for the specified season
   print(f"Downloading games from {year} season")
   d.downloadGamesBySeason(year)
print("Completed downloading games for all seasons")

print(f"Extracting plate appearances and pitches")
p.extractPlateAppearancesAndPitches()    
print("Completed extracting plate appearances and pitches for all seasons")
