import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from tenserflow.keras.models import Sequential
from tenserflow.keras.layers import Dense
import requests
import datetime as dt
import json

# Input:
#  Latitude, Longitude, Year, Month, Day, Hour (time from timestamp)
# Output:
#  Precipitation, Cloudiness, Temperature, Pressure, Humidity, Visibility,
#  Wind Speed, Wind Degrees, pm10, pm2_5, aqi

def create_model():
    model = Sequential()
    model.add(Dense(128, activation='swish'), input_dim=6)
    model.add(Dense(64, activation='swish'))
    model.add(Dense(64, activation='swish'))
    model.add(Dense(11))
    model.compile(loss='mean_squared_error', optimizer='adam', metrics=['mae'])
    return model


def save_model(code, model, mean, std):
    model.save(f"forecast_model_{code}.h5")
    np.save(f"mean_{code}.npy", mean)
    np.save(f"std_{code}.npy", std)


def load_model(code):
    model = create_model()
    mean = None
    std = None
    try:
        model.load_weights(f"forecast_model_{code}.h5")
        mean = np.load(f"mean_{code}.npy")
        std = np.load(f"std_{code}.npy")
    except:
        pass
    return model, mean, std


def train_model(model, X_train, X_valid, y_train, y_valid, epochs=10, batch_size=32):
    history = model.fit(X_train, y_train, validation_data=(X_valid, y_valid), epochs=epochs, batch_size=batch_size)
    return model, history


def get_data(time_from, time_to, lat, lon):
    url = f"http://127.0.0.1:8000/historical/all?lat={lat}&lon={lon}&start={time_from}&end={time_to}"
    response = requests.get(url)
    data = response.json()
    return data


def process_data(data, mean=None, std=None, proportion=0.8):
    df = pd.DataFrame(columns=["Precipitation", "Cloudiness", "Temperature", "Pressure",
                                "Humidity", "Visibility", "Wind Speed", "Wind Degrees",
                                "pm10", "pm2_5", "aqi", "latitude", "longitude", "year",
                                "month", "day", "hour"])
    weather_data = json.loads(data)
    for timestamp, values in weather_data["weather_data"]:
        date = dt.datetime.fromtimestamp(timestamp)
        df = df.append({"Precipitation": values["precipitation"], "Cloudiness": values["cloudiness"],
                        "Temperature": values["temperature"], "Pressure": values["pressure"],
                        "Humidity": values["humidity"], "Visibility": values["visibility"],
                        "Wind Speed": values["wind_speed"], "Wind Degrees": values["wind_degrees"],
                        "pm10": values["pm10"], "pm2_5": values["pm2_5"], "aqi": values["aqi"],
                        "latitude": weather_data["location"]["latitude"], "longitude": weather_data["location"]["longitude"],
                        "year": date.year, "month": date.month, "day": date.day, "hour": date.hour}, ignore_index=True)
    
    df = np.log1p(df)
    if mean is None or std is None:
        mean = df.mean()
        std = df.std()
    df = (df - mean) / std

    X = df[["latitude", "longitude", "year", "month", "day", "hour"]]
    y = df[["Precipitation", "Cloudiness", "Temperature", "Pressure", "Humidity", "Visibility",
            "Wind Speed", "Wind Degrees", "pm10", "pm2_5", "aqi"]]
    X_train, X_valid, y_train, y_valid = train_test_split(X, y, test_size=1-proportion)
    return mean, std, X_train, X_valid, y_train, y_valid


def process_data_test(data, mean=None, std=None, proportions=(0.8, 0.5)):
    df = pd.DataFrame(columns=["Precipitation", "Cloudiness", "Temperature", "Pressure",
                                "Humidity", "Visibility", "Wind Speed", "Wind Degrees",
                                "pm10", "pm2_5", "aqi", "latitude", "longitude", "year",
                                "month", "day", "hour"])
    weather_data = json.loads(data)
    for timestamp, values in weather_data["weather_data"]:
        date = dt.datetime.fromtimestamp(timestamp)
        df = df.append({"Precipitation": values["precipitation"], "Cloudiness": values["cloudiness"],
                        "Temperature": values["temperature"], "Pressure": values["pressure"],
                        "Humidity": values["humidity"], "Visibility": values["visibility"],
                        "Wind Speed": values["wind_speed"], "Wind Degrees": values["wind_degrees"],
                        "pm10": values["pm10"], "pm2_5": values["pm2_5"], "aqi": values["aqi"],
                        "latitude": weather_data["location"]["latitude"], "longitude": weather_data["location"]["longitude"],
                        "year": date.year, "month": date.month, "day": date.day, "hour": date.hour}, ignore_index=True)
    
    df = np.log1p(df)
    if mean is None or std is None:
        mean = df.mean()
        std = df.std()
    df = (df - mean) / std

    X = df[["latitude", "longitude", "year", "month", "day", "hour"]]
    y = df[["Precipitation", "Cloudiness", "Temperature", "Pressure", "Humidity", "Visibility",
            "Wind Speed", "Wind Degrees", "pm10", "pm2_5", "aqi"]]
    X_train, X_temp, y_train, y_temp = train_test_split(X, y, test_size=1-proportions[0])
    X_valid, X_test, y_valid, y_test = train_test_split(X_temp, y_temp, test_size=1-proportions[1])
    return mean, std, X_train, X_valid, X_test, y_train, y_valid, y_test


def test_model(model, X_test, y_test):
    return model.evaluate(X_test, y_test)


def forecast(model, mean, std, timestamp, lat, lon):
    df = pd.DataFrame(columns=["latitude", "longitude", "year", "month", "day", "hour"])
    date = dt.datetime.fromtimestamp(timestamp)
    df = df.append({"latitude": lat, "longitude": lon, "year": date.year, "month": date.month,
                    "day": date.day, "hour": date.hour}, ignore_index=True)
    df = np.log1p(df)
    df = (df - mean) / std
    result = model.predict(df)
    result = result * std + mean
    result = np.expm1(result)
    return json.dumps(result)
