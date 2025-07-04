import getGamesBySeason as g
import extractPlateAppearancesAndPitches as p
import downloadGameDetail as d
import db
import util
import os
import logging

"""
    This script is used to download and import MLB game data for a specified season.
"""

season = 2017


# Set up logging
log_file = os.path.join(os.getenv('DOWNLOAD_DIR', '.'), 'mlb_data_export.log')
logging.basicConfig(
    filename=log_file,
    level=logging.INFO,
    format='%(asctime)s %(levelname)s: %(message)s'
)
logging.info("Started MLB data export for season %d", season)



# Truncate the raw tables to ensure a clean slate for the new data
db.execute_non_query("TRUNCATE TABLE raw.PlateAppearance")
db.execute_non_query("TRUNCATE TABLE raw.Pitch")
print(f"Truncated raw.PlateAppearance and raw.Pitch tables")
logging.info("Truncated raw.PlateAppearance and raw.Pitch tables")

# Download games for the specified season
d.downloadGamesBySeason(season)
print(f"Downloaded games for the {season} season")
logging.info("Downloaded games for the %d season", season)

# Extract plate appearances and pitches from the downloaded game data files
p.extractPlateAppearancesAndPitches()    
print(f"Extracted plate appearances and pitches for the {season} season")
logging.info("Extracted plate appearances and pitches for the %d season", season)

# Load the plate appearances and pitches into the target tables
db.execute_non_query("EXEC dbo.usp_Load_PlateAppearance")
db.execute_non_query("EXEC dbo.usp_Load_Pitch")
print(f"Loaded plate appearances and pitches into target tables for the {season} season")
logging.info("Loaded plate appearances and pitches into target tables for the %d season", season)

# Move downloaded files to the archive directory
util.move_files(source_dir=os.getenv('DOWNLOAD_DIR') + "\\gameDetails", 
                destination_dir=os.getenv('DOWNLOAD_DIR') + "\\gameDetails\\archive", 
                extension=".json")
print(f"Moved downloaded files to the archive directory")
logging.info("Moved downloaded files to the archive directory")



