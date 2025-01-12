# pip install requests requests-cache retry-requests openmeteo-requests

import requests
import os
import openmeteo_requests
import datetime as dt
import json

openweather_key = os.getenv("OPENWEATHER_API_KEY")
google_maps_key = os.getenv("GOOGLE_MAPS_API_KEY")



# Get weather data from OpenWeatherMap API
def get_weather(lat, lon):
    """
    Get current weather data from OpenWeatherMap API
    :param lat: Latitude
    :param lon: Longitude
    :return: Weather data in JSON format
    """
    url = f"https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={openweather_key}&units=metric"
    response = requests.get(url)
    data = response.json()
    return json.dumps(data)


# Get historical weather data from OpenWeatherMap API
def get_historical_weather(lat, lon, start, end):
    """
    Get historical weather data from OpenWeatherMap API
    :param lat: Latitude
    :param lon: Longitude
    :param start: Start date in UNIX timestamp UTC timezone
    :param end: End date in UNIX timestamp UTC timezone
    :return: Weather data in JSON format
    """
    url = f"https://history.openweathermap.org/data/2.5/history/city?lat={lat}&lon={lon}&type=hour&start={start}&end={end}&appid={openweather_key}&units=metric"
    response = requests.get(url)
    data = response.json()
    return json.dumps(data)

# Get air quality data from OpenMeteo API
def get_air_quality(lat, lon, days=None):
    """
    Get air quality data (pm10, pm2.5 and European AQI) from OpenMeteo API
    :param lat: Latitude
    :param lon: Longitude
    :param days: Tuple of two datetime objects, start and end date, both inclusive, only year, month and day are considered
    :return: List of three numpy arrays and a tuple of two datetime objects: hourly_pm10, hourly_pm2_5, hourly_aqi, days
             each array contains hourly values for the respective pollutant or AQI
             for each day in the range of days the array will contain 24 values, one for each hour from 00:00 to 23:00, after which the next day starts
             the tuple contains the start and end date
    """
    if days is None:
        days = (dt.datetime.now(), dt.datetime.now())
    openmeteo = openmeteo_requests.Client()

    url = "https://air-quality-api.open-meteo.com/v1/air-quality"
    params = {
        "latitude": lat,
        "longitude": lon,
        "hourly": ["pm10", "pm2_5", "european_aqi"],
        "start_date": days[0].strftime("%Y-%m-%d"),
        "end_date": days[1].strftime("%Y-%m-%d")
    }
    responses = openmeteo.weather_api(url, params=params)
    hourly = responses[0].Hourly()
    hourly_pm10 = hourly.Variables(0).ValuesAsNumpy().tolist()
    hourly_pm2_5 = hourly.Variables(1).ValuesAsNumpy().tolist()
    hourly_aqi = hourly.Variables(2).ValuesAsNumpy().tolist()
    return {"pm10": hourly_pm10, "pm2_5": hourly_pm2_5, "aqi": hourly_aqi, "days": days}

# Get pollen data from Google Pollen API
def get_pollen(lat, lon):
    """
    Get pollen data from Google Pollen API in the form of JSON
    :param lat: Latitude
    :param lon: Longitude
    :return: Pollen data in JSON format
    """
    url = f"https://pollen.googleapis.com/v1/forecast:lookup?key={google_maps_key}&location.longitude={lon}&location.latitude={lat}&days=1&plantsDescription=true"
    response = requests.get(url)
    data = response.json()
    return json.dumps(data)

# for testing only
if __name__ == "__main__":
    # print(get_weather(51, 17))
    # print(get_air_quality(51, 17, (dt.datetime(2024, 11, 17), dt.datetime(2024, 11, 19))))
    print(get_pollen(41, 17))
