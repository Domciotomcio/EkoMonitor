import psycopg2
from psycopg2 import errors
import hashlib
import os
# from dotenv import load_dotenv


# load_dotenv()

try:
    with open("/run/secrets/DB_NAME", "r") as f:
        DB_NAME = f.read().strip()
    with open("/run/secrets/DB_USER", "r") as f:
        DB_USER = f.read().strip()
    with open("/run/secrets/DB_PASSWORD", "r") as f:
        DB_PASSWORD = f.read().strip()
    with open("/run/secrets/DB_HOST", "r") as f:
        DB_HOST = f.read().strip()
    with open("/run/secrets/DB_PORT", "r") as f:
        DB_PORT = f.read().strip()
except FileNotFoundError:
    DB_NAME = None
    DB_USER = None
    DB_PASSWORD = None
    DB_HOST = None
    DB_PORT = None


# DB_NAME     = os.getenv('DB_NAME')
# DB_USER    = os.getenv('DB_USER')
# DB_PASSWORD = os.getenv('DB_PASSWORD')
# DB_HOST     = os.getenv('DB_HOST')
# DB_PORT     = os.getenv('DB_PORT')

# Connect to the PostgreSQL database server 
def connect():
    conn = None
    try:
        conn = psycopg2.connect(
            dbname=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD,
            host=DB_HOST,
            port=DB_PORT,
        )
        return conn
    except (Exception, psycopg2.DatabaseError) as error:
        print(error, " Error connecting to the database")

# Hash a password for storing.
def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()

# Create a new user 
def create_user(first_name, last_name, city, email, password):
    sql_query = """INSERT INTO users (first_name, last_name, city, email, password)
                   VALUES (%s, %s, %s, %s, %s) RETURNING user_id;"""
    conn = None
    user_id = None
    try:
        conn = connect()
        cur = conn.cursor()
        hashed_password = hash_password(password)
        cur.execute(sql_query, (first_name, last_name, city, email, hashed_password))
        user_id = cur.fetchone()[0]
        conn.commit()
        cur.close()
    except errors.UniqueViolation as e:
        print(f"Error: A user with email {email} already exists.")
    except (Exception, psycopg2.DatabaseError) as error:
        print(error, "Error creating user")
    finally:
        if conn is not None:
            conn.close()
    return user_id

# Authenticate a user
def authenticate_user(email, password):
    sql_query = """SELECT user_id, password FROM users WHERE email = %s;"""
    conn = None
    user_id = None
    try:
        conn = connect()
        cur = conn.cursor()
        cur.execute(sql_query, (email,))
        result = cur.fetchone()
        if result:
            stored_password = result[1]
            if stored_password == hash_password(password):
                user_id = result[0]
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error, " Error authenticating user")
    finally:
        if conn is not None:
            conn.close()
    return user_id

# Get user by user_id
def get_user(user_id):
    sql_query = """SELECT * FROM users WHERE user_id = %s;"""
    conn = None
    user = None
    try:
        conn = connect()
        cur = conn.cursor()
        cur.execute(sql_query, (user_id,))
        user = cur.fetchone()
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error, " Error getting user")
    finally:
        if conn is not None:
            conn.close()
    return user

# Update user details
def update_user(user_id, first_name, last_name, city, email, password):
    sql_query = """UPDATE users
                   SET first_name = %s,
                       last_name = %s,
                       city = %s,
                       email = %s,
                       password = %s
                   WHERE user_id = %s;"""
    conn = None
    updated_rows = 0
    try:
        conn = connect()
        cur = conn.cursor()
        hashed_password = hash_password(password)
        cur.execute(sql_query, (first_name, last_name, city, email, hashed_password, user_id))
        updated_rows = cur.rowcount
        conn.commit()
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error, " Error updating user")
    finally:
        if conn is not None:
            conn.close()
    return updated_rows

# Delete user by user_id
def delete_user(user_id):
    sql_query = """DELETE FROM users WHERE user_id = %s;"""
    conn = None
    deleted_rows = 0
    try:
        conn = connect()
        cur = conn.cursor()
        cur.execute(sql_query, (user_id,))
        deleted_rows = cur.rowcount
        conn.commit()
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error, " Error deleting user")
    finally:
        if conn is not None:
            conn.close()
    return deleted_rows
