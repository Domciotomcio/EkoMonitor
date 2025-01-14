import psycopg2
import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.preprocessing import LabelEncoder
import os

# Database connection parameters
# DB_NAME     = os.getenv("DB_NAME")
# DB_USER    = os.getenv("DB_USER")
# DB_PASSWORD = os.getenv("DB_PASSWORD")
# DB_HOST     = os.getenv("DB_HOST")
# DB_PORT    = os.getenv("DB_PORT")

DB_NAME     = 'ekomonitor'
DB_USER   = 'admin'
DB_PASSWORD = 'MBCZ1380'
DB_HOST     = '40.68.222.189'
DB_PORT     = '5432'

def connect():
    """ Connect to the PostgreSQL database server """
    conn = None
    try:
        conn = psycopg2.connect(
            dbname=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD,
            host=DB_HOST,
        )
        return conn
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)

# Fetch data from the user_answers table
def fetch_data():
    sql_query = """SELECT outdoor_activities, health_concerns, daily_commute, gardening, weather_interest, profile FROM user_answers;"""
    conn = None
    data = None
    try:
        conn = connect()
        cur = conn.cursor()
        cur.execute(sql_query)
        data = cur.fetchall()
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()
    return data

# Setup the model
def setup_model():
    data = fetch_data()
    if not data:
        return None, None, None

    df = pd.DataFrame(data, columns=["outdoor_activities", "health_concerns", "daily_commute", "gardening", "weather_interest", "profile"])

    # Encode categorical variables
    label_encoders = {}
    for column in df.columns[:-1]:
        le = LabelEncoder()
        df[column] = le.fit_transform(df[column])
        label_encoders[column] = le

    # Encode target variable
    profile_encoder = LabelEncoder()
    df["profile"] = profile_encoder.fit_transform(df["profile"])

    # Split the data
    X = df.drop("profile", axis=1)
    y = df["profile"]
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    # Train the model
    model = LogisticRegression()
    model.fit(X_train.values, y_train.values)

    return model, label_encoders, profile_encoder

# Predict user profile
def predict_profile(model, label_encoders, profile_encoder, answers):
    encoded_answers = []
    for question, answer in answers.items():
        encoded_answer = label_encoders[question].transform([answer])[0]
        encoded_answers.append(encoded_answer)
    encoded_answers = np.array(encoded_answers).reshape(1, -1)
    profile_index = model.predict(encoded_answers)[0]
    profile = profile_encoder.inverse_transform([profile_index])[0]
    return profile


# Create a new user answer
def create_user_answer(user_id, outdoor_activities, health_concerns, daily_commute, gardening, weather_interest):
    model, label_encoders, profile_encoder = setup_model()
    if not model:
        print("Model training failed. No data available.")
        return None

    answers = {
        "outdoor_activities": outdoor_activities,
        "health_concerns": health_concerns,
        "daily_commute": daily_commute,
        "gardening": gardening,
        "weather_interest": weather_interest
    }
    profile = predict_profile(model, label_encoders, profile_encoder, answers)

    sql_query = """INSERT INTO user_answers (answer_id, user_id, outdoor_activities, health_concerns, daily_commute, gardening, weather_interest, profile)
                   VALUES (%s, %s, %s, %s, %s, %s, %s, %s) RETURNING answer_id;"""
    conn = None
    answer_id = None
    try:
        conn = connect()
        cur = conn.cursor()
        cur.execute(sql_query, (user_id, user_id, outdoor_activities, health_concerns, daily_commute, gardening, weather_interest, profile))
        answer_id = cur.fetchone()[0]
        conn.commit()
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()
    return answer_id

# Read user answer by answer_id
def read_user_answer(answer_id):
    sql_query = """SELECT * FROM user_answers WHERE user_id = %s;"""
    conn = None
    user_answer = None
    try:
        conn = connect()
        cur = conn.cursor()
        cur.execute(sql_query, (answer_id,))
        user_answer = cur.fetchone()
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()
    return user_answer

# Update user answer by answer_id
def update_user_answer(answer_id, user_id, outdoor_activities, health_concerns, daily_commute, gardening, weather_interest):
    model, label_encoders, profile_encoder = setup_model()
    if not model:
        print("Model training failed. No data available.")
        return 0

    answers = {
        "outdoor_activities": outdoor_activities,
        "health_concerns": health_concerns,
        "daily_commute": daily_commute,
        "gardening": gardening,
        "weather_interest": weather_interest
    }
    profile = predict_profile(model, label_encoders, profile_encoder, answers)

    sql_query = """UPDATE user_answers
                   SET user_id = %s,
                       outdoor_activities = %s,
                       health_concerns = %s,
                       daily_commute = %s,
                       gardening = %s,
                       weather_interest = %s,
                       profile = %s
                   WHERE answer_id = %s;"""
    conn = None
    updated_rows = 0
    try:
        conn = connect()
        cur = conn.cursor()
        cur.execute(sql_query, (user_id, outdoor_activities, health_concerns, daily_commute, gardening, weather_interest, profile, answer_id))
        updated_rows = cur.rowcount
        conn.commit()
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()
    return updated_rows

# Delete user answer by answer_id
def delete_user_answer(answer_id):
    sql_query = """DELETE FROM user_answers WHERE answer_id = %s;"""
    conn = None
    deleted_rows = 0
    try:
        conn = connect()
        cur = conn.cursor()
        cur.execute(sql_query, (answer_id,))
        deleted_rows = cur.rowcount
        conn.commit()
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()
    return deleted_rows
