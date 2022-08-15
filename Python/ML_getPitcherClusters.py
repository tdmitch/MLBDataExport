# pyodbc is used for connecting to the database
import matplotlib
import pyodbc

# pandas is used for a bunch a cool stuff i think, i don't really know. here i want to use it to read the sql query results
import pandas as pd
import numpy as np
from matplotlib.colors import ListedColormap
%matplotlib inline

# define the database connection parameters
conn = pyodbc.connect(
    'Driver={SQL Server};'
    'Server=DESKTOP-3J5KVRA;'
    'Database=MLB;'
    'Trusted_Connection=yes;'
    )
# initialize cursor
# cursor = conn.cursor()

Sql = "EXEC dbo.getPitches 2021"

# pitches = cursor.execute(Sql)

pitches = pd.read_sql_query(Sql, conn)

def initiate_centroids(k, dset):
    centroids = dset.sample(k)
    return centroids

np.random.seed(43)
k = 3
df = pitches[['typeCode', 'isInPlay', 'isStrike']]
centroids = initiate_centroids(k, df)
centroids

def rsserr(a,b):
    return np.square(np.sum((a-b)**2))

for i, centroid in enumerate(range(centroids.shape[0])):
    err = rserr(centroids.iloc[centroid, :], df.iloc[36,:])
    print('Error for centroid {0}: {1:.2f}'.format(i, err))