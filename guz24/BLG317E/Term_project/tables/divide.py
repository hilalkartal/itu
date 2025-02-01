import pandas as pd
import csv

df = pd.read_csv('tables/spotify_songs_dataset.csv')


#-----------------------SONGS--------------------------------
songs = df[['song_id','song_title','duration', 'popularity', 'stream', 'explicit_content','artist','album','release_date','label','genre','composer','language','producer']]
df_album = pd.read_csv('tables/albums.csv')
df_artist = pd.read_csv('tables/artists.csv')
df_genre = pd.read_csv('tables/genres.csv')
df_label = pd.read_csv('tables/labels.csv')
#df_collaboration = pd.read_csv('tables/collaborations.csv')
df_composer = pd.read_csv('tables/composers.csv')
df_producer = pd.read_csv('tables/producers.csv')
df_language = pd.read_csv('tables/languages.csv')

songs.loc[:, 'song_id'] = songs['song_id'].str.lstrip('SP').astype(int)

songs = pd.merge(songs, df_artist[['artist_name', 'artist_id']], left_on='artist', right_on='artist_name', how='left')
songs = pd.merge(songs, df_album[['album', 'release_date','album_id']],left_on= ['album','release_date'], right_on = ['album','release_date'],how='left')
songs = pd.merge(songs, df_genre[['genre_name', 'genre_id']], left_on='genre', right_on='genre_name', how='left')
songs = pd.merge(songs, df_label[['label_name', 'label_id']], left_on='label', right_on='label_name', how='left')
##songs = pd.merge(songs, df_collaboration[['song_id', 'collaboration_id']], left_on='song_id', right_on='song_id', how='left')
songs = pd.merge(songs, df_composer[['composer_name', 'composer_id']], left_on='composer', right_on='composer_name', how='left')
songs = pd.merge(songs, df_producer[['producer_name', 'producer_id']], left_on='producer', right_on='producer_name', how='left')
songs = pd.merge(songs, df_language[['language_name', 'language_id']], left_on='language', right_on='language_name', how='left')

songs = songs.drop(columns=['artist','album','release_date','label','genre','composer','language','producer','artist_name','label_name','genre_name','composer_name','producer_name','language_name']) 
songs = songs[~songs['song_title'].str.contains('none', na=False, case=False)]

# Remove periods from 'song_title'
songs.loc[:, 'song_title'] = songs['song_title'].str.replace('.', '', regex=False)

# Drop rows with NaN in 'language_id' and convert to integer
songs = songs.dropna(subset=['song_id','song_title','duration','popularity','stream','explicit_content','artist_id','album_id','genre_id','label_id','composer_id','producer_id','language_id'])  # Remove rows where language_id is NaN
songs['language_id'] = songs['language_id'].astype(int)
songs = songs.drop_duplicates(subset=['song_id'], keep='first')
songs.to_csv('tables/songs.csv', index=False) 


"""
# ----------------------- ARTISTS --------------------------------
# Get unique artists and count their songs
artists = df['artist'].dropna().unique()  # Assuming 'artist' column contains artist names
artist_data = []

for artist_id, artist in enumerate(artists, start=1):
    artist_data.append({'artist_id': artist_id,
                        'artist_name': artist})

# Create a DataFrame for artists and save it to CSV
artist_df = pd.DataFrame(artist_data)
artist_df.to_csv('tables/artists.csv', index=False)
"""
"""
# ----------------------- ALBUMS --------------------------------
# Get unique albums and their details
albums = df[['album', 'release_date', 'label']].dropna().drop_duplicates()  # Assuming columns 'album', 'release_date', and 'label' exist

album_data = []

for album_id, row in albums.iterrows():
    album_name = row['album']
    release_date = row['release_date']
    label = row['label']
    number_of_songs = len(df[df['album'] == album_name])  # Count the number of songs in each album
    album_data.append({'album_id': album_id + 1,  # Start album_id from 1
                       'album': album_name,
                       'release_date': release_date,
                       'label': label,
                       'number_of_songs': number_of_songs})

# Create a DataFrame for albums and save it to CSV
album_df = pd.DataFrame(album_data)
df_label = pd.read_csv('tables/labels.csv')
album_df = pd.merge(album_df, df_label[['label_name', 'label_id']], left_on='label', right_on='label_name', how='left')

album_df = album_df.drop(columns=['label','label_name']) 
album_df.to_csv('tables/albums.csv', index=False)
"""


"""
# ----------------------- COLLABORATION --------------------------------
collaborations = df[['collaboration','song_id','artist']].dropna().drop_duplicates()
collaboration_data = []
for collaboration_id, row in enumerate(collaborations.itertuples(index=False), start=1):
    collaboration_data.append({
        'collaboration_id': collaboration_id,
        'collaboration_name': row.collaboration,  # Access row.collaboration
        'song_id': row.song_id,                   # Access row.song_id
        'artist': row.artist                      # Access row.artist
    })
    
collaboration_df = pd.DataFrame(collaboration_data)
df_artist = pd.read_csv('tables/artists.csv')
collaboration_df = pd.merge(collaboration_df, df_artist[['artist_id','name']], left_on='artist', right_on='name', how='left')
collaboration_df['song_id'] = collaboration_df['song_id'].str.lstrip('SP').astype(int)
collaboration_df = collaboration_df.drop(columns=['name','artist'])
collaboration_df.to_csv('tables/collaborations.csv', index=False)
"""


"""
# ----------------------- COMPOSER --------------------------------
composers = df['composer'].dropna().unique()

composer_data = [] #creating empty list

for composer_id, composer in enumerate(composers, start = 1):
    composer_data.append({'composer_id': composer_id,
                         'composer_name': composer})
   
composer_df = pd.DataFrame(composer_data)
composer_df.to_csv('tables/composer.csv', index=False)
"""

"""
#-----------------------LANGUAGE--------------------------------
languages = df['language'].dropna().unique()

language_data = []

for language_id, language in enumerate(languages, start=1):
    language_data.append({'language_id' : language_id,
                        'language_name' : language})
  
language_df = pd.DataFrame(language_data)
language_df.to_csv('tables/languages.csv', index=False)
"""

"""
#-----------------------PRODUCER--------------------------------
#find unique strings in column 'producer'
producers = df['producer'].dropna().unique()    #dropna() removes any NaN, unique() returns an array of unique artists

producer_data = []     #empty list

for producer_id, producer in enumerate(producers, start=1):
    number_of_songs = len(df[df['producer'] == producer])
    producer_data.append({'producer_id' : producer_id,
                        'producer_name' : producer,
                        'number_of_songs' : number_of_songs})

producer_df = pd.DataFrame(producer_data)
producer_df.to_csv('tables/producers.csv', index=False)
"""

"""
#-----------------------GENRE--------------------------------
#find unique strings in column 'genre'
genres = df['genre'].dropna().unique()    #dropna() removes any NaN, unique() returns an array of unique genre

genre_data = []     #empty list

for genre_id, genre in enumerate(genres, start=1):
    number_of_songs = len(df[df['genre'] == genre])  # Count the number of songs for each genre
    genre_data.append({'genre_id' : genre_id,
                        'genre_name' : genre,
                        'number_of_songs': number_of_songs})

genre_df = pd.DataFrame(genre_data)
genre_df.to_csv('tables/genres.csv', index=False)
"""

"""
# ----------------------- LABELS --------------------------------
# Get unique LABELS and count their songs
labels = df['label'].dropna().unique()  # Assuming 'label' column contains artist names
label_data = []

for label_id, label in enumerate(labels, start=1):
    label_data.append({'label_id': label_id,
                        'label_name': label})

# Create a DataFrame for artists and save it to CSV
label_df = pd.DataFrame(label_data)
label_df.to_csv('tables/labels.csv', index=False)
"""