import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
import os
os.environ["KERAS_BACKEND"] = "tensorflow"
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Input
import requests
import datetime as dt

# Input:
#  Latitude, Longitude, Year, Month, Day, Hour (time from timestamp)
# Output:
#  Precipitation, Precipitation_percentage, Cloudiness, Temperature, Pressure, Humidity, Visibility,
#  Wind Speed, Wind Degrees, pm10, pm2_5, aqi

def signed_log_transform(x):
    return np.sign(x) * np.log1p(np.abs(x))


def signed_log_inverse(x):
    return np.sign(x) * np.expm1(np.abs(x))


def create_model():
    model = Sequential()
    model.add(Input(shape=(6,)))
    model.add(Dense(128, activation='swish'))
    model.add(Dense(64, activation='swish'))
    model.add(Dense(64, activation='swish'))
    model.add(Dense(12))
    model.compile(loss='mean_squared_error', optimizer='adam', metrics=['mae'])
    return model


def save_model(code, model, mean, std):
    model.save(f"forecast_model_{code}.keras")
    np.save(f"mean_{code}.npy", mean)
    np.save(f"std_{code}.npy", std)


def load_model(code):
    model = create_model()
    mean = None
    std = None
    try:
        model.load_weights(f"forecast_model_{code}.keras")
        mean = np.load(f"mean_{code}.npy", allow_pickle=True)
        std = np.load(f"std_{code}.npy", allow_pickle=True)
    except Exception as e:
        print(f"Error loading model: {e}")
        return None, None, None
    return model, mean, std


def train_model(model, X_train, X_valid, y_train, y_valid, epochs=10, batch_size=32):
    history = model.fit(X_train, y_train, validation_data=(X_valid, y_valid), epochs=epochs, batch_size=batch_size)
    return model, history


def get_data(time_from, time_to, lat, lon):
    url = f"http://127.0.0.1:8001/historical/point?lat={lat}&lon={lon}&start={time_from}&end={time_to}"
    response = requests.get(url)
    data = response.json()
    return data


def get_data_all():
    url = "http://127.0.0.1:8001/historical/all/nopollen"
    response = requests.get(url)
    data = response.json()
    return data


def process_data(data, mean=None, std=None, proportion=0.8):
    dlist = []
    if isinstance(data, dict):
        for i in data["weather_data"]:
            date = dt.datetime.fromtimestamp(int(i))
            dlist.append({
                "Precipitation": data["weather_data"][i]["precipitation"]["value"],
                "Precipitation Probability": data["weather_data"][i]["precipitation_probability"]["value"],
                "Cloudiness": data["weather_data"][i]["cloudiness"]["value"],
                "Temperature": data["weather_data"][i]["temperature"]["value"],
                "Pressure": data["weather_data"][i]["pressure"]["value"],
                "Humidity": data["weather_data"][i]["humidity"]["value"],
                "Visibility": data["weather_data"][i]["visibility"]["value"],
                "Wind Speed": data["weather_data"][i]["wind_speed"]["value"],
                "Wind Degrees": data["weather_data"][i]["wind_direction"]["value"],
                "pm10": data["weather_data"][i]["pm10"]["value"],
                "pm2_5": data["weather_data"][i]["pm2_5"]["value"],
                "aqi": data["weather_data"][i]["aqi"]["value"],
                "latitude": data["location"]["latitude"],
                "longitude": data["location"]["longitude"],
                "year": date.year,
                "month": date.month,
                "day": date.day,
                "hour": date.hour
                })
    else:
        for i in data:
            date = dt.datetime.fromtimestamp(i["timestamp"])
            dlist.append({
                "Precipitation": i["weather_conditions"]["precipitation"]["value"],
                "Precipitation Probability": i["weather_conditions"]["precipitation_probability"]["value"],
                "Cloudiness": i["weather_conditions"]["cloudiness"]["value"],
                "Temperature": i["weather_conditions"]["temperature"]["value"],
                "Pressure": i["weather_conditions"]["pressure"]["value"],
                "Humidity": i["weather_conditions"]["humidity"]["value"],
                "Visibility": i["weather_conditions"]["visibility"]["value"],
                "Wind Speed": i["weather_conditions"]["wind_speed"]["value"],
                "Wind Degrees": i["weather_conditions"]["wind_direction"]["value"],
                "pm10": i["weather_conditions"]["pm10"]["value"],
                "pm2_5": i["weather_conditions"]["pm2_5"]["value"],
                "aqi": i["weather_conditions"]["aqi"]["value"],
                "latitude": i["location"]["latitude"],
                "longitude": i["location"]["longitude"],
                "year": date.year,
                "month": date.month,
                "day": date.day,
                "hour": date.hour
                })
    df = pd.DataFrame(dlist)
    df = df.interpolate()
    df = signed_log_transform(df)
    a = np.asarray(None)
    if np.array_equal(mean, a) or np.array_equal(std, a):
        mean = df.mean()
        std = df.std()
    df = (df - mean) / std

    X = df[["latitude", "longitude", "year", "month", "day", "hour"]]
    y = df[["Precipitation", "Precipitation Probability", "Cloudiness", "Temperature", "Pressure", "Humidity", "Visibility",
            "Wind Speed", "Wind Degrees", "pm10", "pm2_5", "aqi"]]
    X_train, X_valid, y_train, y_valid = train_test_split(X, y, test_size=1-proportion)
    return mean, std, X_train, X_valid, y_train, y_valid


def process_data_test(data, mean=None, std=None, proportions=(0.8, 0.5)):
    dlist = []
    if isinstance(data, dict):
        for i in data["weather_data"]:
            date = dt.datetime.fromtimestamp(int(i))
            dlist.append({
                "Precipitation": data["weather_data"][i]["precipitation"]["value"],
                "Precipitation Probability": data["weather_data"][i]["precipitation_probability"]["value"],
                "Cloudiness": data["weather_data"][i]["cloudiness"]["value"],
                "Temperature": data["weather_data"][i]["temperature"]["value"],
                "Pressure": data["weather_data"][i]["pressure"]["value"],
                "Humidity": data["weather_data"][i]["humidity"]["value"],
                "Visibility": data["weather_data"][i]["visibility"]["value"],
                "Wind Speed": data["weather_data"][i]["wind_speed"]["value"],
                "Wind Degrees": data["weather_data"][i]["wind_direction"]["value"],
                "pm10": data["weather_data"][i]["pm10"]["value"],
                "pm2_5": data["weather_data"][i]["pm2_5"]["value"],
                "aqi": data["weather_data"][i]["aqi"]["value"],
                "year": date.year,
                "month": date.month,
                "day": date.day,
                "hour": date.hour
                })
    else:
        for i in data:
            date = dt.datetime.fromtimestamp(i["timestamp"])
            dlist.append({
                "Precipitation": i["weather_conditions"]["precipitation"]["value"],
                "Precipitation Probability": i["weather_conditions"]["precipitation_probability"]["value"],
                "Cloudiness": i["weather_conditions"]["cloudiness"]["value"],
                "Temperature": i["weather_conditions"]["temperature"]["value"],
                "Pressure": i["weather_conditions"]["pressure"]["value"],
                "Humidity": i["weather_conditions"]["humidity"]["value"],
                "Visibility": i["weather_conditions"]["visibility"]["value"],
                "Wind Speed": i["weather_conditions"]["wind_speed"]["value"],
                "Wind Degrees": i["weather_conditions"]["wind_direction"]["value"],
                "pm10": i["weather_conditions"]["pm10"]["value"],
                "pm2_5": i["weather_conditions"]["pm2_5"]["value"],
                "aqi": i["weather_conditions"]["aqi"]["value"],
                "latitude": i["location"]["latitude"],
                "longitude": i["location"]["longitude"],
                "year": date.year,
                "month": date.month,
                "day": date.day,
                "hour": date.hour
                })
    df = pd.DataFrame(dlist)
    df = df.interpolate()
    df = signed_log_transform(df)
    a = np.asarray(None)
    if np.array_equal(mean, a) or np.array_equal(std, a):
        mean = df.mean()
        std = df.std()
    df = (df - mean) / std

    X = df[["latitude", "longitude", "year", "month", "day", "hour"]]
    y = df[["Precipitation", "Precipitation Probability", "Cloudiness", "Temperature", "Pressure", "Humidity", "Visibility",
            "Wind Speed", "Wind Degrees", "pm10", "pm2_5", "aqi"]]
    X_train, X_temp, y_train, y_temp = train_test_split(X, y, test_size=1-proportions[0])
    X_valid, X_test, y_valid, y_test = train_test_split(X_temp, y_temp, test_size=1-proportions[1])
    return mean, std, X_train, X_valid, X_test, y_train, y_valid, y_test


def test_model(model, X_test, y_test):
    return model.evaluate(X_test, y_test)


def forecast(model, mean, std, timestamp, lat, lon):
    date = dt.datetime.fromtimestamp(timestamp)
    df = pd.DataFrame([{"latitude": lat, "longitude": lon, "year": date.year, "month": date.month,
                    "day": date.day, "hour": date.hour}])
    df = signed_log_transform(df)
    df = (df - mean[-6:]) / std[-6:]
    df = df[["latitude", "longitude", "year", "month", "day", "hour"]]
    result = model.predict(df)
    std_pom = std[:-6]
    mean_pom = mean[:-6]
    result = result[0]
    result = result * std_pom + mean_pom
    result = pd.DataFrame(result).T
    result.columns = ["Precipitation", "Precipitation Probability", "Cloudiness", "Temperature",
                      "Pressure", "Humidity", "Visibility", "Wind Speed", "Wind Degrees", "pm10", "pm2_5", "aqi"]
    result = signed_log_inverse(result)
    return result

if __name__ == "__main__":
    # model = create_model()
    model, mean, std = load_model("test")
    # data = get_data_all()
    # mean, std, X_train, X_valid, X_test, y_train, y_valid, y_test = process_data_test(data)
    # model, history = train_model(model, X_train, X_valid, y_train, y_valid, epochs=1000)
    # save_model("test", model, mean, std)
    # print(model.metrics_names)
    # print(model.summary())
    # print(test_model(model, X_test, y_test))
    print(forecast(model, mean, std, 1736826000, 51.5074, 17.1278).T)
