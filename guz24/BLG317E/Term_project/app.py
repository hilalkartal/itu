from flask import Flask, render_template, request, redirect, url_for, session
import mysql.connector
from settings import db_host, db_user, db_password, db_name
from mysql.connector.errors import IntegrityError
from operation_file import * 

app = Flask(__name__)
app.secret_key = 'a_secret_key_that_is_super_hard_to_find_i_believe..//!?=)'

# Database connection configuration
db_config = {
    'host': db_host,  
    'user': db_user,       
    'password': db_password,  
    'database': db_name
}


@app.route('/', methods=['GET', 'POST'])
def login():
    if request.method == 'POST': # if method post then this block will be executed
        username = request.form['username']
        password = request.form['password']
        
        # Connect to the database
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()

        # Query to check if the user exists in the 'admins' table
        cursor.execute("SELECT * FROM admins WHERE email = %s AND password = %s", (username, password))
        user = cursor.fetchone()  # Fetch one result

        if user:
            session['logged_in'] = True
            #return redirect(url_for('indexa')) ## which function will be called
            return render_template('index.html')
        else:
            return render_template('login.html', error="Invalid credentials")
    
    return render_template('login.html') # if method not post then it shows the logina.html

@app.route('/index.html', methods={'GET'})
def index():
    if not session.get('logged_in'):    # If user is not logged in, redirect to login page
        return redirect('/login')
    return render_template('index.html')

#--------------------ARTISTS--------------------
    
@app.route('/artists.html', methods=['GET', 'POST']) # this part in shown in browser address line
def artists():
    if not session.get('logged_in'):    # If user is not logged in, redirect to login page
        return redirect('/login')
    # Connect to the database
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor(dictionary=True)

    if request.method == 'POST':
        id = request.form.get('id')  # Required for identifying the row
        action = request.form.get('action')
        column1 = request.form.get('artist_name')  
        column2 = request.form.get('number_of_songs')
        if action == 'add':
            return add_table_3col(connection,'artists','Artist ID',column1,column2)
        elif action == 'update':
            return update_table_3col(connection,'artists','Artist ID',id,column1,column2)
        elif action == 'search':
            column1 = request.form.get('searchColumn1')  
            column2 = request.form.get('searchColumn2')
            column3 = request.form.get('searchColumn3')
            return search_table_3col(connection,'artists',column1,column2,column3)
        elif action == 'delete':
            return delete_table(connection,'artists') 

    else:
        return show_table(connection,'artists')

#--------------------ARTISTS END--------------------
    
#--------------------COMPOSERS---------------------
@app.route('/composers.html', methods=['GET', 'POST']) # this part in shown in browser address line
def composers():
    if not session.get('logged_in'):    # If user is not logged in, redirect to login page
        return redirect('/login')
    # Connect to the database
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor(dictionary=True)

    if request.method == 'POST':
        action = request.form.get('action')
        id = request.form.get('id')  # Required for identifying the row
        column1 = request.form.get('composer_name')  
        if action == 'add':
            return add_table_2col(connection,'composers','Composer ID',column1)
        elif action == 'update':
            return update_table_2col(connection,'composers','Composer ID',id,column1)
        elif action == 'search':
            column1 = request.form.get('searchColumn1')  
            column2 = request.form.get('searchColumn2')
            return search_table_2col(connection,'composers',column1,column2)
        elif action == 'delete':
            return delete_table(connection,'composers') 

    else:
        return show_table(connection,'composers')
#--------------------COMPOSERS END---------------------

#--------------------LABELS---------------------

@app.route('/labels.html', methods=['GET', 'POST']) # this part in shown in browser address line
def labels():
    if not session.get('logged_in'):    # If user is not logged in, redirect to login page
        return redirect('/login')


    # Connect to the database
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor(dictionary=True)
    
    if request.method == 'POST':
        action = request.form.get('action')
        id = request.form.get('id')
        column1 = request.form.get('label_name')  
        if action == 'add':
            return add_table_2col(connection,'labels','Label ID',column1)
        elif action == 'update':
            return update_table_2col(connection,'labels','Label ID',id,column1)
        elif action == 'search':
            column1 = request.form.get('searchColumn1')  
            column2 = request.form.get('searchColumn2')
            return search_table_2col(connection,'labels',column1,column2)
        elif action == 'delete':
            return delete_table(connection,'labels') 

    else:
        return show_table(connection,'labels')            
        
#----------------------------LABELS END----------------------
@app.route('/contact')
def contact():
    return render_template('contact.html')

@app.route('/logout')
def logout():
    # Perform logout logic, e.g., clear the session
    session.clear()
    return redirect(url_for('login_page'))  # Use the view function name 'login', not 'login.html'

@app.route('/login')
def login_page():
    return render_template('login.html')  # Ensure you have a login.html template

#--------------------ALBUMS---------------------
@app.route('/album_basic.html', methods=['GET', 'POST'])
def handle_action_albums():
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor(dictionary=True)
    
    if request.method == 'POST':
        action = request.form.get('action')
        toggle = request.form.get('toggle')  # Toggle flag

        if action == 'add':
            try:
                # Fetch the current maximum ID
                cursor.execute("SELECT MAX(album_id) AS max_id FROM albums")
                max_id_result = cursor.fetchone()
                new_id = (max_id_result['max_id'] or 0) + 1  # If no records exist, start with 1

                # Fetch form data
                column_album = request.form.get('column1', '')
                column_rd = request.form.get('column2', '')
                column_nos = request.form.get('column3', '')
                column_label = request.form.get('column4', '')

                if not column_album or not column_rd or not column_nos or not column_label:
                    return render_template('album_basic.html', error="Fill all the boxes except Album ID")
                
                cursor.execute("SELECT 1 FROM labels WHERE label_id = %s", (column_label,))
                if not cursor.fetchone():
                    return render_template('album_basic.html', error="The provided Label ID does not exist.")

                # Insert the new record with the generated ID
                cursor.execute("""
                    INSERT INTO albums (album_id, album, release_date, number_of_songs, label_id) 
                    VALUES (%s, %s, %s, %s, %s)
                """, (new_id, column_album, column_rd, column_nos, column_label))
                
                #show the added row
                cursor.execute("SELECT * FROM albums WHERE album_id = %s LIMIT 100",(new_id,))
                data = cursor.fetchall()

                # Commit the transaction
                connection.commit()

                # Render success page
                return render_template('album_basic.html', data = data, message="Album added successfully!")

            except IntegrityError as e:
                if "foreign key constraint" in str(e):
                    return render_template(
                        'album_basic.html', 
                        error="The provided Label ID does not exist."
                    )
                else:
                    return render_template(
                        'album_basic.html', 
                        error="An unexpected error occurred."
                    )
            finally:
                cursor.close()
                connection.close()
        
        elif action == 'update':
            try:
                id = request.form.get('id')  # Required for identifying the row
                column1 = request.form.get('column1')  # Album
                column2 = request.form.get('column2')  # Release Date
                column3 = request.form.get('column3')  # Number of Songs
                column4 = request.form.get('column4')  # Label ID
        
                updates = []
                params = []
                
                if not id:
                    return render_template('album_basic.html', error="Album ID is required for updating.")
                
                cursor.execute("SELECT 1 FROM albums WHERE album_id = %s", (id,))
                if not cursor.fetchone():
                    return render_template('album_basic.html', error="The provided Album ID does not exist.")
                
                if column1:
                    updates.append("album = %s")
                    params.append(column1)
                
                if column2:
                    updates.append("release_date = %s")
                    params.append(column2)
                
                if column3:
                    updates.append("number_of_songs = %s")
                    params.append(column3)
                
                if column4:
                    updates.append("label_id = %s")
                    params.append(column4)
                
                if updates:
                    params.append(id)
                    query = f"UPDATE albums SET {', '.join(updates)} WHERE album_id = %s"
                    cursor.execute(query, params)
                    connection.commit()

                # show the added row
                    cursor.execute("SELECT * FROM albums WHERE album_id = %s",(id,))
                    data = cursor.fetchall()

                # Commit the transaction
                    connection.commit()

                # Render success page
                    return render_template('album_basic.html', data = data, message="Album update successfully!")

                # when no updates done
                else:
                    cursor.execute("SELECT * FROM albums LIMIT 100")
                    data = cursor.fetchall()
                    connection.commit()
                    return render_template('album_basic.html', data = data, message="Please change at least one field.")
            
            except IntegrityError as e:
                if "foreign key constraint" in str(e):
                    return render_template(
                        'album_basic.html', 
                        error="The provided Label ID does not exist."
                    )
                else:
                    return render_template(
                        'album_basic.html', 
                        error="An unexpected error occurred."
                    )
            finally:
                cursor.close()
                connection.close()
            
        elif action == 'delete':
           # Handle delete
            row_id = request.form['id']
            
            try:
                # Attempt to delete the song record with the specified song_id
                cursor.execute("DELETE FROM albums WHERE album_id = %s", (row_id,))
                connection.commit()

                # After deletion, fetch the updated table data
                query = "SELECT * FROM albums LIMIT 100;"
                cursor.execute(query)
                data = cursor.fetchall()

                # Render the page with the updated data
                return render_template('album_basic.html', data=data, message="Album deleted successfully!")
            
            except Exception as e:
                # If an error occurs, display an error message
                connection.rollback()
                return render_template('album_basic.html', error=f"An error occurred: {str(e)}")
            
            finally:
                # Close the cursor and the connection
                cursor.close()
                connection.close()
        
        elif action == 'search':
            # Handle search
            column1 = request.form.get('searchColumn1', '')
            column2 = request.form.get('searchColumn2', '')
            column3 = request.form.get('searchColumn3', '')
            column4 = request.form.get('searchColumn4', '')
            column5 = request.form.get('searchColumn5', '')
            
            query = "SELECT * FROM albums WHERE 1=1"  # Default query, will be modified if there are search filters

            # Add conditions for each column if a value is provided
            params = []

            if column1 != '':
                query += " AND album_id = %s"
                params.append(column1)
            if column2 != '':
                query += " AND album LIKE %s"
                params.append(f"%{column2}%")
            if column3 != '':
                query += " AND release_date = %s"
                params.append(column3)
            if column4 != '':
                query += " AND number_of_songs = %s"
                params.append(column4)
            if column5 != '':
                query += " AND label_id = %s"
                params.append(column5)
            
            # If there no field is selected for searching to prevent show all value in the table
            if len(params) == 0:
                query = "SELECT * FROM albums LIMIT 100"

            # Execute the query with the parameters
            cursor.execute(query, tuple(params))

            # Fetch the results
            data = cursor.fetchall()
            # if all fields are empty
            if len(params) == 0:
                row_count = 0
            else:
                row_count = len(data)  # Count the number of rows returned
            connection.close()

            # Render the page with the filtered data
            return render_template('album_basic.html', data=data, row_count=row_count)
    
        elif action == 'show':
            if toggle == 'labels':  # Show label names
                # Get the rows currently displayed in the table
                displayed_rows = request.form.getlist('displayed_rows')  # Pass current rows from the form

                if not displayed_rows:
                    # If no rows are passed, return an error or the default albums table
                    query = "SELECT * FROM albums LIMIT 100;"
                    cursor.execute(query)
                    data = cursor.fetchall()
                    cursor.close()
                    connection.close()
                    return render_template('album_basic.html', data=data, error="No rows to update!")

                # Convert displayed_rows into a tuple for the SQL query
                row_ids = tuple(displayed_rows)
                if len(row_ids) == 1:
                    # Special case for single ID (tuple syntax issue)
                    row_ids = f"({row_ids[0]})"

                # Query to fetch corresponding label names for the displayed rows
                query = f"""
                    SELECT a.album_id, a.album, a.release_date, a.number_of_songs, l.label_id, l.label_name
                    FROM albums a
                    LEFT JOIN labels l ON a.label_id = l.label_id
                    WHERE a.album_id IN {row_ids}
                """
                cursor.execute(query)
                data = cursor.fetchall()
                # Close the connection
                connection.close() 
                return render_template('album_basic.html', data=data, show_labels=True)
            
            else:   # Show label IDs
                # Get the rows currently displayed in the table
                displayed_rows = request.form.getlist('displayed_rows')  # Pass current rows from the form

                if not displayed_rows:
                    # If no rows are passed, return an error or the default albums table
                    query = "SELECT * FROM albums LIMIT 100;"
                    cursor.execute(query)
                    data = cursor.fetchall()
                    cursor.close()
                    connection.close()
                    return render_template('album_basic.html', data=data, error="No rows to update!")

                # Convert displayed_rows into a tuple for the SQL query
                row_ids = tuple(displayed_rows)
                if len(row_ids) == 1:
                    # Special case for single ID (tuple syntax issue)
                    row_ids = f"({row_ids[0]})"

                
                query = f"SELECT * FROM albums WHERE album_id IN {row_ids} LIMIT 100;"
                cursor.execute(query)
                data = cursor.fetchall()
                connection.close()
                return render_template('album_basic.html', data=data, show_labels=False)


    else:    
    
        # Default: Show the full table
        row_count = 0
        query = "SELECT * FROM albums LIMIT 100;"
        cursor.execute(query)
        data = cursor.fetchall()

        # Close the connection
        cursor.close()
        connection.close()
        return render_template('album_basic.html', data=data, row_count=row_count, show_labels=False)

#----------------------------ALBUMS END----------------------


#--------------------SONGS---------------------
@app.route('/song_basic.html', methods=['GET', 'POST'])
def handle_action_songs():
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor(dictionary=True)
    
    if request.method == 'POST':
        action = request.form.get('action')
        toggle = request.form.get('toggle')  # Toggle flag
        if action == 'add':
            try:
                # Fetch the current maximum ID for songs
                cursor.execute("SELECT MAX(song_id) AS max_id FROM songs")
                max_id_result = cursor.fetchone()
                new_id = (max_id_result['max_id'] or 0) + 1  # If no records exist, start with 1

                # Fetch form data
                column_title = request.form.get('song_title', '')
                column_duration = request.form.get('duration', '')
                column_popularity = request.form.get('popularity', '')
                column_stream = request.form.get('stream', '')
                column_explicit = request.form.get('explicit_content', '')
                column_artist = request.form.get('artist_id', '')
                column_album = request.form.get('album_id', '')
                column_genre = request.form.get('genre_id', '')
                column_label = request.form.get('label_id', '')
                column_language = request.form.get('language_id', '')
                column_composer = request.form.get('composer_id', '')
                column_producer = request.form.get('producer_id', '')

                # Make sure all input places are filled
                if not column_title or not column_duration or not column_popularity or not column_stream or not column_explicit or not column_album or not column_artist or not column_genre or not column_label or not column_language or not column_composer or not column_producer:
                    return render_template('song_basic.html', error="Fill all the places except Song ID to add a record")

                # Check if foreign key values exist
                cursor.execute("SELECT 1 FROM artists WHERE artist_id = %s", (column_artist,))
                if not cursor.fetchone():
                    return render_template('song_basic.html', error="The provided Artist ID does not exist.")
                
                cursor.execute("SELECT 1 FROM albums WHERE album_id = %s", (column_album,))
                if not cursor.fetchone():
                    return render_template('song_basic.html', error="The provided Album ID does not exist.")
                
                cursor.execute("SELECT 1 FROM genres WHERE genre_id = %s", (column_genre,))
                if not cursor.fetchone():
                    return render_template('song_basic.html', error="The provided Genre ID does not exist.")
                
                cursor.execute("SELECT 1 FROM labels WHERE label_id = %s", (column_label,))
                if not cursor.fetchone():
                    return render_template('song_basic.html', error="The provided Label ID does not exist.")
                
                cursor.execute("SELECT 1 FROM languages WHERE language_id = %s", (column_language,))
                if not cursor.fetchone():
                    return render_template('song_basic.html', error="The provided Language ID does not exist.")
                
                cursor.execute("SELECT 1 FROM producers WHERE producer_id = %s", (column_producer,))
                if not cursor.fetchone():
                    return render_template('song_basic.html', error="The provided Producer ID does not exist.")
                
                cursor.execute("SELECT 1 FROM composers WHERE composer_id = %s", (column_composer,))
                if not cursor.fetchone():
                    return render_template('song_basic.html', error="The provided Composer ID does not exist.")

                # Insert the new song record with the generated ID
                cursor.execute("""
                    INSERT INTO songs (song_id, song_title, duration, popularity, stream, explicit_content, 
                                    artist_id, album_id, genre_id, label_id, language_id, composer_id, producer_id) 
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                """, (new_id, column_title, column_duration, column_popularity, column_stream, column_explicit,
                    column_artist, column_album, column_genre, column_label, column_language, column_composer, column_producer))
                
                # Update number_of_songs in the associated tables
                cursor.execute("""
                    UPDATE albums 
                    SET number_of_songs = number_of_songs + 1 
                    WHERE album_id = %s
                """, (column_album,))

                cursor.execute("""
                    UPDATE genres 
                    SET number_of_songs = number_of_songs + 1 
                    WHERE genre_id = %s
                """, (column_genre,))

                cursor.execute("""
                    UPDATE producers 
                    SET number_of_songs = number_of_songs + 1 
                    WHERE producer_id = %s
                """, (column_producer,))
                # Show the added row
                cursor.execute("SELECT * FROM songs WHERE song_id = %s LIMIT 100", (new_id,))
                data = cursor.fetchall()

                # Commit the transaction
                connection.commit()

                # Render success page with the added data
                return render_template('song_basic.html', data=data, message="Song added successfully!")

            except IntegrityError as e:
                if "foreign key constraint" in str(e):
                    return render_template(
                        'song_basic.html', 
                        error="One of the provided foreign keys does not exist or caused a constraint violation."
                    )
                else:
                    return render_template(
                        'song_basic.html', 
                        error="An unexpected error occurred."
                    )
            except Exception as e:
                # Catch all other exceptions
                connection.rollback()
                return render_template('song_basic.html', error=f"An error occurred: {str(e)}")
            finally:
                cursor.close()
                connection.close()

        elif action == 'update':
            try:
                # Fetch form data

                id = request.form.get('id')  # Required for identifying the row
                column1 = request.form.get('song_title')  
                column2 = request.form.get('duration')  
                column3 = request.form.get('popularity')  
                column4 = request.form.get('stream')
                column5 = request.form.get('explicit_content')  
                column6 = request.form.get('artist_id')  
                column7 = request.form.get('album_id')  
                column8 = request.form.get('genre_id')
                column9 = request.form.get('label_id')  
                column10 = request.form.get('language_id')  
                column11 = request.form.get('composer_id')
                column12 = request.form.get('producer_id')          
                
                updates = []
                params = []
                if not id :
                    return render_template('song_basic.html', error="Song ID is required for updating.")
                
                cursor.execute("SELECT 1 FROM songs WHERE song_id = %s", (id,))
                if not cursor.fetchone():
                    return render_template('song_basic.html', error="The provided Song ID does not exist.")
                
                if column1:
                    updates.append("song_title = %s")
                    params.append(column1)
                
                if column2:
                    updates.append("duration = %s")
                    params.append(column2)
                
                if column3:
                    updates.append("popularity = %s")
                    params.append(column3)
                
                if column4:
                    updates.append("stream = %s")
                    params.append(column4)
                
                if column5:
                    updates.append("explicit_content = %s")
                    params.append(column5)
                
                if column6:
                    updates.append("artist_id = %s")
                    params.append(column6)
                
                if column7:
                    updates.append("album_id = %s")
                    params.append(column7)
                
                if column8:
                    updates.append("genre_id = %s")
                    params.append(column8)
                
                if column9:
                    updates.append("label_id = %s")
                    params.append(column9)
                
                if column10:
                    updates.append("language_id= %s")
                    params.append(column10)
                
                if column11:
                    updates.append("composer_id = %s")
                    params.append(column11)
                
                if column12:
                    updates.append("producer_id = %s")
                    params.append(column12)
                
                if updates:
                    params.append(id)
                    query = f"UPDATE songs SET {', '.join(updates)} WHERE song_id = %s"
                    cursor.execute(query, params)
                    connection.commit()

                #show the updated row
                    cursor.execute("SELECT * FROM songs WHERE song_id = %s",(id,))
                    data = cursor.fetchall()

                # Commit the transaction
                    connection.commit()

                # Render success page
                    return render_template('song_basic.html', data = data, message="Song update successfully!")
                
                # when no updates done
                else:
                    cursor.execute("SELECT * FROM songs LIMIT 100")
                    data = cursor.fetchall()
                    connection.commit()
                    return render_template('song_basic.html', data = data, message="Please change at least one field.")
            
            except IntegrityError as e:
                if "foreign key constraint" in str(e):
                    return render_template(
                        'song_basic.html', 
                        error="One of the provided foreign keys does not exist or caused a constraint violation."
                    )
                else:
                    return render_template(
                        'song_basic.html', 
                        error ="An unexpected error occurred."
                    )
            finally:
                cursor.close()
                connection.close()
                      
        elif action == 'delete':
            # Handle delete
            row_id = request.form['id']

            try:
                # Fetch the song details to get related foreign keys
                cursor.execute("SELECT album_id, genre_id, producer_id FROM songs WHERE song_id = %s", (row_id,))
                song_details = cursor.fetchone()

                if not song_details:
                    return render_template('song_basic.html', error="The specified Song ID does not exist.")

                # Extract the foreign key values
                column_album = song_details['album_id']
                column_genre = song_details['genre_id']
                column_producer = song_details['producer_id']

                # Delete the song record
                cursor.execute("DELETE FROM songs WHERE song_id = %s", (row_id,))

                # Update the related tables
                cursor.execute("""
                    UPDATE albums 
                    SET number_of_songs = number_of_songs - 1 
                    WHERE album_id = %s
                """, (column_album,))

                cursor.execute("""
                    UPDATE genres 
                    SET number_of_songs = number_of_songs - 1 
                    WHERE genre_id = %s
                """, (column_genre,))

                cursor.execute("""
                    UPDATE producers 
                    SET number_of_songs = number_of_songs - 1 
                    WHERE producer_id = %s
                """, (column_producer,))

                # Commit the transaction
                connection.commit()

                # Fetch the updated table data
                query = "SELECT * FROM songs LIMIT 100;"
                cursor.execute(query)
                data = cursor.fetchall()

                # Render the page with the updated data
                return render_template('song_basic.html', data=data, message="Song deleted successfully!")

            except Exception as e:
                # If an error occurs, display an error message
                connection.rollback()
                return render_template('song_basic.html', error=f"An error occurred: {str(e)}")

            finally:
                # Close the cursor and the connection
                cursor.close()
                connection.close()

        elif action == 'search':
            # Handle search
            column1 = request.form.get('searchColumn1', '')
            column2 = request.form.get('searchColumn2', '')
            column3 = request.form.get('searchColumn3', '')
            column4 = request.form.get('searchColumn4', '')
            column5 = request.form.get('searchColumn5', '')
            column6 = request.form.get('searchColumn6', '')
            column7 = request.form.get('searchColumn7', '')
            column8 = request.form.get('searchColumn8', '')
            column9 = request.form.get('searchColumn9', '')
            column10 = request.form.get('searchColumn10', '')
            column11 = request.form.get('searchColumn11', '')
            column12 = request.form.get('searchColumn12', '')
            column13 = request.form.get('searchColumn13', '')

            query = "SELECT * FROM songs WHERE 1=1"  # Default query, will be modified if there are search filters

            # Add conditions for each column if a value is provided
            params = []

            if column1 != '':
                query += " AND song_id = %s"
                params.append(column1)
            if column2 != '':
                query += " AND song_title LIKE %s"
                params.append(f"%{column2}%")
            if column3 != '':
                query += " AND duration = %s"
                params.append(column3)
            if column4 != '':
                query += " AND popularity = %s"
                params.append(column4)
            if column5 != '':
                query += " AND stream = %s"
                params.append(column5)
            if column6 != '':
                query += " AND explicit_content = %s"
                params.append(column6)
            if column7 != '':
                query += " AND artist_id = %s"
                params.append(column7)
            if column8 != '':
                query += " AND album_id = %s"
                params.append(column8)
            if column9 != '':
                query += " AND genre_id = %s"
                params.append(column9)
            if column10 != '':
                query += " AND label_id = %s"
                params.append(column10)
            if column11 != '':
                query += " AND language_id = %s"
                params.append(column11)
            if column12 != '':
                query += " AND composer_id = %s"
                params.append(column12)
            if column13 != '':
                query += " AND producer_id = %s"
                params.append(column13)
            
            # If all places are empty then return first 100 rows
            if len(params) == 0:
                query = "SELECT * FROM songs LIMIT 100"

            # Execute the query with the parameters
            cursor.execute(query, tuple(params))

            # Fetch the results
            data = cursor.fetchall()
            
            if len(params) == 0:
                row_count = 0
            else:
                row_count = len(data)

            connection.close()

            # Render the page with the filtered data
            return render_template('song_basic.html', data=data, row_count = row_count)
        
        elif action == 'show_selected':
            # Handle show selected
            select_artist = request.form.get('select_artist', '')
            select_album = request.form.get('select_album', '')
            select_genre = request.form.get('select_genre', '')
            select_label = request.form.get('select_label', '')
            select_language = request.form.get('select_language', '')
            select_composer = request.form.get('select_composer', '')
            select_producer = request.form.get('select_producer', '')
            remaining_column = [" ,s.artist_id"," ,s.album_id", " ,s.genre_id", " ,s.label_id", " ,s.language_id", " ,s.composer_id", " ,s.producer_id"]

            query = """
                SELECT s.song_id, s.song_title, s.duration, s.popularity, s.stream, s.explicit_content
            """  # Start with the base query for the songs table

            # List to hold the joins for each selected column
            joins = []
            names = []
            show_artists = False
            show_albums = False
            show_genres = False
            show_labels = False
            show_languages = False
            show_composers = False
            show_producers = False
            displayed_rows = request.form.getlist("displayed_rows")
            row_ids = tuple(displayed_rows)
            if len(row_ids) == 1:
                # Special case for single ID (tuple syntax issue)
                row_ids = f"({row_ids[0]})"
            
            if select_artist:
                names.append(" ,a.artist_name")
                remaining_column.remove(" ,s.artist_id")
                join_part = " LEFT JOIN artists a ON s.artist_id = a.artist_id"
                joins.append(join_part)
                show_artists = True
            if select_album:
                names.append(" ,al.album")
                remaining_column.remove(" ,s.album_id")
                join_part = " LEFT JOIN albums al ON s.album_id = al.album_id"
                joins.append(join_part)
                show_albums = True
            if select_genre:
                names.append(" ,g.genre_name")
                remaining_column.remove(" ,s.genre_id")
                join_part = " LEFT JOIN genres g ON s.genre_id = g.genre_id"
                joins.append(join_part)
                show_genres = True
            if select_label:
                names.append(" ,l.label_name")
                remaining_column.remove(" ,s.label_id")
                join_part = " LEFT JOIN labels l ON s.label_id = l.label_id"
                joins.append(join_part)
                show_labels = True
            if select_language:
                names.append(" ,lang.language_name")
                remaining_column.remove(" ,s.language_id")
                join_part = " LEFT JOIN languages lang ON s.language_id = lang.language_id"
                joins.append(join_part)
                show_languages = True
            if select_composer:
                names.append(" ,c.composer_name")
                remaining_column.remove(" ,s.composer_id")
                join_part = " LEFT JOIN composers c ON s.composer_id = c.composer_id"
                joins.append(join_part)
                show_composers = True
            if select_producer:
                names.append(" ,p.producer_name")
                remaining_column.remove(" ,s.producer_id")
                join_part = " LEFT JOIN producers p ON s.producer_id = p.producer_id"
                joins.append(join_part)
                show_producers = True

            query += "".join(remaining_column)
            query += "".join(names)
            query += " FROM songs s "
            query += "".join(joins)
            query += f" WHERE s.song_id IN {row_ids}"
            # If no checkboxes are selected, we can either show the default or add logic here
            

            
            # Execute the query without any additional filtering
            cursor.execute(query)

            # Fetch the results
            data = cursor.fetchall()

            # Render the page with the selected data
            return render_template('song_basic.html', data=data,show_artists=show_artists,show_albums=show_albums,show_genres = show_genres,show_labels=show_labels,show_languages=show_languages,show_composers=show_composers,show_producers=show_producers)

    else:    
    
        # Default: Show the full table
        row_count = 0
        query = "SELECT * FROM songs LIMIT 100;"
        cursor.execute(query)
        data = cursor.fetchall()

        # Close the connection
        cursor.close()
        connection.close()
        return render_template('song_basic.html', data=data, row_count = row_count)

#----------------------------SONGS END----------------------

#----------------------------GENRE----------------------
@app.route('/genres.html', methods=['GET', 'POST']) # this part in shown in browser address line
def genres():
    if not session.get('logged_in'):    # If user is not logged in, redirect to login page
        return redirect('/login')
    # Connect to the database
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor(dictionary=True)

    if request.method == 'POST':
        id = request.form.get('id')  # Required for identifying the row
        action = request.form.get('action')
        column1 = request.form.get('genre_name')  
        column2 = request.form.get('number_of_songs')
        if action == 'add':
            return add_table_3col(connection,'genres','Genre ID',column1,column2)
        elif action == 'update':
            return update_table_3col(connection,'genres','Genre ID',id,column1,column2)
        elif action == 'search':
            column1 = request.form.get('searchColumn1')  
            column2 = request.form.get('searchColumn2')
            column3 = request.form.get('searchColumn3')
            return search_table_3col(connection,'genres',column1,column2,column3)
        elif action == 'delete':
            return delete_table(connection,'genres') 

    else:
        return show_table(connection,'genres')

#----------------------------GENRE END----------------------

#----------------------------PRODUCERS----------------------
@app.route('/producers.html', methods=['GET', 'POST']) # this part in shown in browser address line
def producers():
    if not session.get('logged_in'):    # If user is not logged in, redirect to login page
        return redirect('/login')
    # Connect to the database
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor(dictionary=True)

    if request.method == 'POST':
        id = request.form.get('id')  # Required for identifying the row
        action = request.form.get('action')
        column1 = request.form.get('producers_name')  
        column2 = request.form.get('number_of_songs')
        if action == 'add':
            return add_table_3col(connection,'producers','Producer ID',column1,column2)
        elif action == 'update':
            return update_table_3col(connection,'producers','Producer ID',id,column1,column2)
        elif action == 'search':
            column1 = request.form.get('searchColumn1')  
            column2 = request.form.get('searchColumn2')
            column3 = request.form.get('searchColumn3')
            return search_table_3col(connection,'producers',column1,column2,column3)
        elif action == 'delete':
            return delete_table(connection,'producers') 

    else:
        return show_table(connection,'producers')

#----------------------------PRODUCERS END----------------------

#----------------------------LANGUAGES----------------------
@app.route('/languages.html', methods=['GET', 'POST']) # this part in shown in browser address line
def languages():
    if not session.get('logged_in'):    # If user is not logged in, redirect to login page
        return redirect('/login')


    # Connect to the database
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor(dictionary=True)
    
    if request.method == 'POST':
        action = request.form.get('action')
        id = request.form.get('id')
        column1 = request.form.get('language_name')  
        if action == 'add':
            return add_table_2col(connection,'languages','Language ID',column1)
        elif action == 'update':
            return update_table_2col(connection,'languages','Language ID',id,column1)
        elif action == 'search':
            column1 = request.form.get('searchColumn1')  
            column2 = request.form.get('searchColumn2')
            return search_table_2col(connection,'languages',column1,column2)
        elif action == 'delete':
            return delete_table(connection,'languages') 

    else:
        return show_table(connection,'languages')    

#----------------------------LANGUAGES END----------------------

if __name__ == '__main__':
    app.run(debug=True)