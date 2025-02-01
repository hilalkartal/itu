from flask import Flask, render_template, request, redirect, url_for, session
from mysql.connector.errors import IntegrityError
import mysql.connector

app = Flask(__name__)
app.secret_key = 'a_secret_key_that_is_super_hard_to_find_i_believe..//!?=)'


## first_column_name is sshown error message
def update_table_3col(connection, table_name, first_column_name,id,column1,column2):
    try:
        cursor = connection.cursor(dictionary=True)
        # Query the table to get metadata

        query = f"SELECT * FROM {table_name} LIMIT 0;"  # Query to fetch no rows but get column names
        cursor.execute(query)
        cursor.fetchone()

        # Fetch column names
        column_names = [column[0] for column in cursor.description]

        if  not id:
            print("Rendering template with error message.")
            return render_template(f'{table_name}.html', error= f"{first_column_name} is required for updating.")
       
        query = f"SELECT 1 FROM {table_name} WHERE {column_names[0]} = %s"
        cursor.execute(query, (id,))

        if not cursor.fetchone():
            return render_template(f'{table_name}.html', error=f"The provided {first_column_name} does not exist.")
                

                
        if column1 != '' and column2 != '':
            query = f"UPDATE {table_name} SET {column_names[1]} = %s, {column_names[2]} = %s WHERE {column_names[0]} = %s"
            cursor.execute(query, (column1,column2,id))
            connection.commit()

        # show the added row
            query = f"SELECT * FROM {table_name} WHERE {column_names[0]} = %s"
            cursor.execute(query,(id,))
            data = cursor.fetchall()
            connection.commit()

            return render_template(f'{table_name}.html', data = data, message=f"{table_name} update successfully!")
        
        elif column1 != '' and column2 =='':
            query = f"UPDATE {table_name} SET {column_names[1]} = %s WHERE {column_names[0]} = %s"
            cursor.execute(query, (column1,id))
            connection.commit()

            query = f"SELECT * FROM {table_name} WHERE {column_names[0]} = %s"
            cursor.execute(query,(id,))
            data = cursor.fetchall()
            connection.commit()

            return render_template(f'{table_name}.html', data = data, message=f"{table_name} update successfully!")

        elif column1 == '' and column2 !='':
            query = f"UPDATE {table_name} SET {column_names[2]} = %s WHERE {column_names[0]} = %s"
            cursor.execute(query, (column2,id))
            connection.commit()

            query = f"SELECT * FROM {table_name} WHERE {column_names[0]} = %s"
            cursor.execute(query,(id,))
            data = cursor.fetchall()
            connection.commit()

            return render_template(f'{table_name}.html', data = data, message=f"{table_name} update successfully!")
        
        # when no updates done
        else:
            query = f"SELECT * FROM {table_name} LIMIT 100"
            cursor.execute(query)
            data = cursor.fetchall()
            connection.commit()
            return render_template(f'{table_name}.html', data = data, message="Please change at least one field.")
            
    except IntegrityError as e:
        if "foreign key constraint" in str(e):
            return render_template(
                    f'{table_name}.html', 
                    error="The provided foreign key does not exist."
            )
        else:
            return render_template(
                f'{table_name}.html', 
                error="An unexpected error occurred."
            )

    finally:
        cursor.close()
        connection.close()


def add_table_3col(connection, table_name, first_column_name,column1,column2):
    try:
        # Fetch the current maximum ID
        cursor = connection.cursor(dictionary=True)

        query = f"SELECT * FROM {table_name} LIMIT 0;"  # Query to fetch no rows but get column names
        cursor.execute(query)
        cursor.fetchone()

        # Fetch column names
        column_names = [column[0] for column in cursor.description]

        #generating primary key
        query=f"SELECT MAX({column_names[0]}) AS max_id FROM {table_name}"
        cursor.execute(query)
        max_id_result = cursor.fetchone()
        new_id = (max_id_result['max_id'] or 0) + 1  # If no records exist, start with 1


        if not column1 or not column2:
            return render_template(f'{table_name}.html', error=f"Fill all the boxes except {first_column_name}")

        # Insert the new record with the generated ID
        query = f"""
            INSERT INTO {table_name} ({column_names[0]}, {column_names[1]}, {column_names[2]}) 
            VALUES (%s, %s,%s)
        """ 
        cursor.execute(query,(new_id, column1, column2))
        connection.commit()

        #show the added row
        query = f"SELECT * FROM {table_name} WHERE {column_names[0]} = %s"
        cursor.execute(query,(new_id,))
        data = cursor.fetchall()

        # Commit the transaction
        connection.commit()

        # Render success page
        return render_template(f'{table_name}.html', data = data, message=f"{table_name} added successfully!")

    except IntegrityError as e:
        if "foreign key constraint" in str(e):
            return render_template(
                f'{table_name}.html', 
                error="The provided foreign key does not exist."
            )
        else:
            return render_template(
                f'{table_name}.html', 
                error="An unexpected error occurred."
            )
    finally:
        cursor.close()
        connection.close() 

def search_table_3col(connection,table_name,column1,column2,column3):
    cursor = connection.cursor(dictionary=True)  
    
    # to find column name
    query = f"SELECT * FROM {table_name} LIMIT 0;"  # Query to fetch no rows but get column names
    cursor.execute(query)
    cursor.fetchone()

    # Fetch column names
    column_names = [column[0] for column in cursor.description]

    query = f"SELECT * FROM {table_name} WHERE 1=1"  # Default query, will be modified if there are search filters
    # Add conditions for each column if a value is provided
    params = []
    if column1 != '':
        query += f" AND {column_names[0]} = %s"
        params.append(column1)
    if column2 != '':
        query += f" AND {column_names[1]} LIKE %s"
        params.append(f"%{column2}%")
    if column3 != '':
        query += f" AND {column_names[2]} = %s"
        params.append(column3)
            
    # If there no field is selected for searching to prevent show all value in the table
    if len(params) == 0:
        query = f"SELECT * FROM {table_name} LIMIT 100"

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
    return render_template(f'{table_name}.html', data=data, row_count=row_count)

def delete_table(connection,table_name):     
    try:
        # Attempt to delete the song record with the specified song_id
        row_id = request.form['id']
        cursor = connection.cursor(dictionary=True) 
        query = f"SELECT * FROM {table_name} LIMIT 0;"  # Query to fetch no rows but get column names
        cursor.execute(query)
        cursor.fetchone()

    # Fetch column names
        column_names = [column[0] for column in cursor.description]
        query = f"DELETE FROM {table_name} WHERE {column_names[0]} = %s"
        cursor.execute(query, (row_id,))
        connection.commit()

        # After deletion, fetch the updated table data
        query = f"SELECT * FROM {table_name} LIMIT 100;"
        cursor.execute(query)
        data = cursor.fetchall()

        # Render the page with the updated data
        return render_template(f'{table_name}.html', data=data, message=f"{table_name} deleted successfully!")
            
    except Exception as e:
        # If an error occurs, display an error message
        connection.rollback()
        return render_template(f'{table_name}.html', error=f"An error occurred: {str(e)}")
            
    finally:
        # Close the cursor and the connection
        cursor.close()
        connection.close()

def show_table(connection,table_name):
    # Default: Show the full table
    row_count = 0
    cursor = connection.cursor(dictionary=True) 
    query = f"SELECT * FROM {table_name} LIMIT 100;"
    cursor.execute(query)
    data = cursor.fetchall()

    # Close the connection
    cursor.close()
    connection.close()
    return render_template(f'{table_name}.html', data=data, row_count = row_count)


##########2COLUMN###############

## first_column_name is sshown error message
def update_table_2col(connection, table_name, first_column_name,id,column1):
    try:
        cursor = connection.cursor(dictionary=True)
        # Query the table to get metadata

        query = f"SELECT * FROM {table_name} LIMIT 0;"  # Query to fetch no rows but get column names
        cursor.execute(query)
        cursor.fetchone()

        # Fetch column names
        column_names = [column[0] for column in cursor.description]

        if  not id:
            print("Rendering template with error message.")
            return render_template(f'{table_name}.html', error= f"{first_column_name} is required for updating.")
       
        query = f"SELECT 1 FROM {table_name} WHERE {column_names[0]} = %s"
        cursor.execute(query, (id,))

        if not cursor.fetchone():
            return render_template(f'{table_name}.html', error=f"The provided {first_column_name} does not exist.")
            
        
        if column1 != '':
            query = f"UPDATE {table_name} SET {column_names[1]} = %s WHERE {column_names[0]} = %s"
            cursor.execute(query, (column1,id))
            connection.commit()

            query = f"SELECT * FROM {table_name} WHERE {column_names[0]} = %s"
            cursor.execute(query,(id,))
            data = cursor.fetchall()
            connection.commit()

            return render_template(f'{table_name}.html', data = data, message=f"{table_name} update successfully!")
 
        # when no updates done
        else:
            query = f"SELECT * FROM {table_name} LIMIT 100"
            cursor.execute(query)
            data = cursor.fetchall()
            connection.commit()
            return render_template(f'{table_name}.html', data = data, message="Please change at least one field.")
            
    except IntegrityError as e:
        if "foreign key constraint" in str(e):
            return render_template(
                    f'{table_name}.html', 
                    error="The provided foreign key does not exist."
            )
        else:
            return render_template(
                f'{table_name}.html', 
                error="An unexpected error occurred."
            )

    finally:
        cursor.close()
        connection.close()

def add_table_2col(connection, table_name, first_column_name,column1):
    try:
        # Fetch the current maximum ID
        cursor = connection.cursor(dictionary=True)

        query = f"SELECT * FROM {table_name} LIMIT 0;"  # Query to fetch no rows but get column names
        cursor.execute(query)
        cursor.fetchone()

        # Fetch column names
        column_names = [column[0] for column in cursor.description]

        #generating primary key
        query=f"SELECT MAX({column_names[0]}) AS max_id FROM {table_name}"
        cursor.execute(query)
        max_id_result = cursor.fetchone()
        new_id = (max_id_result['max_id'] or 0) + 1  # If no records exist, start with 1


        if not column1:
            return render_template(f'{table_name}.html', error=f"Fill all the boxes except {first_column_name}")

        # Insert the new record with the generated ID
        query = f"""
            INSERT INTO {table_name} ({column_names[0]}, {column_names[1]}) 
            VALUES (%s, %s)
        """ 
        cursor.execute(query,(new_id, column1))
        connection.commit()

        #show the added row
        query = f"SELECT * FROM {table_name} WHERE {column_names[0]} = %s"
        cursor.execute(query,(new_id,))
        data = cursor.fetchall()

        # Commit the transaction
        connection.commit()

        # Render success page
        return render_template(f'{table_name}.html', data = data, message=f"{table_name} added successfully!")

    except IntegrityError as e:
        if "foreign key constraint" in str(e):
            return render_template(
                f'{table_name}.html', 
                error="The provided foreign key does not exist."
            )
        else:
            return render_template(
                f'{table_name}.html', 
                error="An unexpected error occurred."
            )
    finally:
        cursor.close()
        connection.close() 

def search_table_2col(connection,table_name,column1,column2):
    cursor = connection.cursor(dictionary=True)  
    
    # to find column name
    query = f"SELECT * FROM {table_name} LIMIT 0;"  # Query to fetch no rows but get column names
    cursor.execute(query)
    cursor.fetchone()

    # Fetch column names
    column_names = [column[0] for column in cursor.description]

    query = f"SELECT * FROM {table_name} WHERE 1=1"  # Default query, will be modified if there are search filters
    # Add conditions for each column if a value is provided
    params = []
    if column1 != '':
        query += f" AND {column_names[0]} = %s"
        params.append(column1)
    if column2 != '':
        query += f" AND {column_names[1]} LIKE %s"
        params.append(f"%{column2}%")
            
    # If there no field is selected for searching to prevent show all value in the table
    if len(params) == 0:
        query = f"SELECT * FROM {table_name} LIMIT 100"

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
    return render_template(f'{table_name}.html', data=data, row_count=row_count)


