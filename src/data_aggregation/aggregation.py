# pip install requests requests-cache retry-requests openmeteo-requests

import requests
import os
import openmeteo_requests
import datetime as dt

openweather_key = os.getenv("OPENWEATHER_API_KEY")


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
    return data

# Get air quality data from OpenMeteo API
def get_air_quality(lat, lon, days=(dt.datetime.now(), dt.datetime.now())):
    """
    Get air quality data (pm10, pm2.5 and European AQI) from OpenMeteo API
    :param lat: Latitude
    :param lon: Longitude
    :param days: Tuple of two datetime objects, start and end date, both inclusive, only year, month and day are considered
    :return: List of three numpy arrays: hourly_pm10, hourly_pm2_5, hourly_aqi
             each array contains hourly values for the respective pollutant or AQI
             for each day in the range of days the array will contain 24 values, one for each hour from 00:00 to 23:00, after which the next day starts
    """
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
    hourly_pm10 = hourly.Variables(0).ValuesAsNumpy()
    hourly_pm2_5 = hourly.Variables(1).ValuesAsNumpy()
    hourly_aqi = hourly.Variables(2).ValuesAsNumpy()
    return [hourly_pm10, hourly_pm2_5, hourly_aqi]

# Get pollen data from Google Pollen API    [NOT IMPLEMENTED YET]
def get_pollen(lat, lon):
    pass

# for testing only
if __name__ == "__main__":
    print(get_weather(50, 50))
    print(get_air_quality(50, 50, (dt.datetime(2024, 11, 17), dt.datetime(2024, 11, 19))))
