import pyodbc
import os

 


# Get connection to the database
def connect_to_db():

    DB_DRIVER = os.getenv('DB_DRIVER')
    DB_SERVER = os.getenv('DB_SERVER')
    DB_DATABASE = os.getenv('DB_DATABASE') 
    
    conn = pyodbc.connect(
        f"Driver={DB_DRIVER};"
        f"Server={DB_SERVER};"
        f"Database={DB_DATABASE};"
        f"Trusted_Connection=yes;"
    )

    return conn