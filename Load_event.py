# for handeling csv files
import csv
# pyodbc is used for connecting to the database
import pyodbc
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

path = 'c:\\users\\paul.davis\\source\\repos\\MLB_Database\\csv\\event.csv'
with open(path, newline='') as csvfile:
    reader = csv.reader(csvfile, delimiter=',')
    next(reader)
    for row in reader:
        # print(', '.join(row))
        #print(row[0])

        SqlInsertStatement = ("INSERT INTO [MLB].[dbo].[Event]"
            "(event, isOnBase)"
            f'VALUES (\'{row[0]}\', {row[1]})')

        cursor.execute(SqlInsertStatement)
        # #without this it doesnt commit - giving you a chance to check the execution and confirm it worked,. Your can query before commit
        conn.commit()