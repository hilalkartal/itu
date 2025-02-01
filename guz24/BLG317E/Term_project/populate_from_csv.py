import pandas as pd
import mysql.connector
from settings import db_host, db_user, db_password, db_name

# Function to populate a table from a CSV file
def populate_table_from_csv(table_name, csv_file, column_names):
    try:
        # Connect to the database
        connection = mysql.connector.connect(
            host=db_host,
            user=db_user,
            password=db_password,
            database=db_name
        )
        cursor = connection.cursor()

        # Read the CSV file into a panda dataframe
        data = pd.read_csv(csv_file)

        # Generate SQL INSERT 
        placeholders = ", ".join(["%s"] * len(column_names))
        query = f"INSERT INTO {table_name} ({', '.join(column_names)}) VALUES ({placeholders})"

        # Insert rows from the dataframe
        for _, row in data.iterrows():
            cursor.execute(query, tuple(row[col] for col in column_names))

        # Commit the changes
        connection.commit()
        print(f"Data from {csv_file} has been inserted into {table_name}.")

    except mysql.connector.Error as err:
        print(f"Error while inserting into {table_name}: {err}")
    except Exception as e:
        print(f"Unexpected error: {e}")
    finally:
        cursor.close()
        connection.close()

#to clean tables
def clean_the_tables(table_name):
    try:
        # Connect to the database
        connection = mysql.connector.connect(
            host=db_host,
            user=db_user,
            password=db_password,
            database=db_name
        )
        eraser_cursor = connection.cursor()

        #to be able to delete without froeign key constraits
        eraser_cursor.execute("SET FOREIGN_KEY_CHECKS = 0;")
        # Generate SQL TRUNCATE 
        query = f"TRUNCATE TABLE {table_name}"
        eraser_cursor.execute(query)

        # Commit the changes
        connection.commit()
        print(f"Data from {table_name} has been erased.")
        eraser_cursor.execute("SET FOREIGN_KEY_CHECKS = 1;")
    except mysql.connector.Error as err:
        print(f"Error while deleting {table_name}: {err}")
    except Exception as e:
        print(f"Unexpected error: {e}")
    finally:
        eraser_cursor.close()
        connection.close()
     
#clean all the tables before trying to reinsert
clean_the_tables(table_name='artists')
clean_the_tables(table_name='genres')
clean_the_tables(table_name='albums')
clean_the_tables(table_name='labels')
clean_the_tables(table_name='languages')
clean_the_tables(table_name='producers')
clean_the_tables(table_name='composers')
clean_the_tables(table_name='songs')

#loading each table from csvs
populate_table_from_csv(
    table_name='artists',
    csv_file='./tables/artists.csv',
    column_names=['artist_id', 'artist_name']
)

populate_table_from_csv(
    table_name='genres',
    csv_file='./tables/genres.csv',
    column_names=['genre_id', 'genre_name', 'number_of_songs']
)

populate_table_from_csv(
    table_name='labels',
    csv_file='./tables/labels.csv',
    column_names=['label_id', 'label_name']
)

populate_table_from_csv(
    table_name='languages',
    csv_file='./tables/languages.csv',
    column_names=['language_id', 'language_name']
)

populate_table_from_csv(
    table_name='composers',
    csv_file='./tables/composers.csv',
    column_names=['composer_id', 'composer_name']
)

populate_table_from_csv(
    table_name='producers',
    csv_file='./tables/producers.csv',
    column_names=['producer_id', 'producer_name', 'number_of_songs']
)

populate_table_from_csv(
    table_name='albums',
    csv_file='./tables/albums.csv',
    column_names=['album_id', 'album', 'release_date', 'number_of_songs','label_id' ]
)

populate_table_from_csv(
    table_name='songs',
    csv_file='./tables/songs.csv',
    column_names = [
    "song_id", "song_title", "duration", "popularity", "stream", 
    "explicit_content", "artist_id", "album_id", "genre_id", 
    "label_id", "composer_id", "producer_id", "language_id"
    ]
)



