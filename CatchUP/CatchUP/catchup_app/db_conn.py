import psycopg2

def dbconnect():
    try:
        # Connect to the database
        conn = psycopg2.connect(
            host="192.168.88.10",
            database="postgres",
            user="postgres",
            password="admin"
        )

        # Create a cursor
        cursor = conn.cursor()

        # Close the cursor and connection
        cursor.close()
        conn.close()

    except (Exception, psycopg2.Error) as error:
        print("Error connecting to the database:", error)
