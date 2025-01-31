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
    """
    Calculate the signed logarithm of the absolute value of x
    :param x: Input value
    :return: Signed logarithm of the absolute value of x
    """
    return np.sign(x) * np.log1p(np.abs(x))


def signed_log_inverse(x):
    """
    Calculate the inverse of the signed logarithm of the absolute value of x
    :param x: Input value
    :return: Inverse of the signed logarithm of the absolute value of x
    """
    return np.sign(x) * np.expm1(np.abs(x))


def create_model():
    """
    Create a neural network model for forecasting
    The model has 6 input neurons and 12 output neurons
    It has 3 hidden layers with 128, 64 and 64 neurons respectively, all using the swish activation function
    The output layer uses the linear activation function
    The model is compiled using the mean squared error loss function and the Adam optimizer
    :return: Neural network model
    """
    model = Sequential()
    model.add(Input(shape=(6,)))
    model.add(Dense(128, activation='swish'))
    model.add(Dense(64, activation='swish'))
    model.add(Dense(64, activation='swish'))
    model.add(Dense(12))
    model.compile(loss='mean_squared_error', optimizer='adam', metrics=['mae'])
    return model


def save_model(code, model, mean, std):
    """
    Save the model, mean and standard deviation to files
    :param code: Code to use in the file names
    :param model: Model to save
    :param mean: Mean to save
    :param std: Standard deviation to save
    """
    model.save(f"forecast_model_{code}.keras")
    np.save(f"mean_{code}.npy", mean)
    np.save(f"std_{code}.npy", std)


def load_model(code):
    """
    Load the model, mean and standard deviation from files
    :param code: Code to use in the file names
    :return: Model, mean and standard deviation
    """
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
    """
    Train the model using the given data
    :param model: Model to train
    :param X_train: Training input data
    :param X_valid: Validation input data
    :param y_train: Training output data
    :param y_valid: Validation output data
    :param epochs: Number of epochs to train for
    :param batch_size: Batch size to use
    :return: Trained model and training history
    """
    history = model.fit(X_train, y_train, validation_data=(X_valid, y_valid), epochs=epochs, batch_size=batch_size)
    return model, history


def get_data(time_from, time_to, lat, lon):
    """
    Get historical weather data from the data processing service
    :param time_from: Start time in timestamp format
    :param time_to: End time in timestamp format
    :param lat: Latitude
    :param lon: Longitude
    :return: Weather data
    """
    url = f"http://data_processing:8001/historical/point?lat={lat}&lon={lon}&start={time_from}&end={time_to}"
    response = requests.get(url)
    data = response.json()
    return data


def get_data_all():
    """
    Get all historical weather data from the data processing service
    :return: Weather data
    """
    url = "http://data_processing:8001/historical/all/nopollen"
    response = requests.get(url)
    data = response.json()
    return data


def process_data(data, mean=None, std=None, proportion=0.8):
    """
    Process the data for training the model
    :param data: Weather data
    :param mean: Mean values for normalization
    :param std: Standard deviation values for normalization
    :param proportion: Proportion of data to use for training
    :return: Mean, standard deviation, training and validation input and output data"""
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
    """
    Process the data for training and testing the model
    :param data: Weather data
    :param mean: Mean values for normalization
    :param std: Standard deviation values for normalization
    :param proportions: Proportions of data to use for training, validation and testing
    :return: Mean, standard deviation, training, validation and testing input and output data
    """
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
    """
    Test the model using the given data
    :param model: Model to test
    :param X_test: Test input data
    :param y_test: Test output data
    :return: Test results
    """
    return model.evaluate(X_test, y_test)


def forecast(model, mean, std, timestamp, lat, lon):
    """
    Forecast weather data for a given time and location
    :param model: Model to use for forecasting
    :param mean: Mean values for normalization
    :param std: Standard deviation values for normalization
    :param timestamp: Time in timestamp format
    :param lat: Latitude
    :param lon: Longitude
    :return: Forecasted weather data
    """
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
