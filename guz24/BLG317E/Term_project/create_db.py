import mysql.connector
from settings import db_host, db_password, db_user, db_name

try:
    #Connect to MySQL server and create the database if it doesn't exist
    database = mysql.connector.connect(
        host=db_host,
        user=db_user,
        password=db_password,
        #auth_plugin=db_password    #not sure about this line
    )
    cursor_m = database.cursor()

    # Create database if it doesn't already exist
    cursor_m.execute(f"CREATE DATABASE IF NOT EXISTS {db_name}")
    print(f"Database {db_name} created or already exists.")

    # Close initial connection (server-level)
    cursor_m.close()
    database.close()

    #database is created now
    #connect to database and create the tables from schema.sql
    
    #Connect to the new database
    new_database = mysql.connector.connect(
        user=db_user,
        password=db_password,
        host=db_host,
        database=db_name,
       # auth_plugin='mysql_native_password'
    )
    cursor_new = new_database.cursor()

    # Function to execute SQL script from a file
    def executeScriptsFromFile(filename):
        try:
            #open the file read it and load it to sql_file
            with open(filename, 'r') as fd:
                sql_file = fd.read()

            #split each query
            sqlCommands = sql_file.split(';')

            #execute the commands
            for command in sqlCommands:
                if command.strip():  # Avoid executing empty commands
                    try:
                        cursor_new.execute(command)
                    except mysql.connector.Error as err:
                        print(f"Error executing command: {err}")

        except Exception as e:
            print(f"Error reading file {filename}: {e}")

    # Execute schema.sql to make tables
    executeScriptsFromFile('./database/schema.sql')
    new_database.commit()

    print(f"Schema from {db_name} executed successfully.")

    # Clean up and close connection
    cursor_new.close()
    new_database.close()

except mysql.connector.Error as err:
    print("There was an error with the MySQL connection or execution:", err)
except Exception as err:
    print("An unexpected error occurred:", err)
