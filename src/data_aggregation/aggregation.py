import requests
import os
import openmeteo_requests
import datetime as dt

google_maps_key = os.getenv("GOOGLE_MAPS_API_KEY")

def get_weather_forecast(lat, lon, days=None):
    """
    Get weather forecast data from OpenMeteo API
    :param lon: Longitude
    :param days: Tuple of two datetime objects, start and end date, both inclusive, only year, month and day are considered
    :return: List of nine numpy arrays, a tuple of two floats and a tuple of two datetime objects: !!!!!!!!!!!, days
             each array contains hourly values for the respective weather data
             for each day in the range of days the array will contain 24 values, one for each hour from 00:00 to 23:00, after which the next day starts
             the first tuple contains the latitude and longitude
             the second tuple contains the start and end date
    """
    if days is None:
        days = (dt.datetime.now().timestamp(), dt.datetime.now().timestamp())
    openmeteo = openmeteo_requests.Client()

    url = "https://api.open-meteo.com/v1/forecast"
    params = {
        "latitude": lat,
        "longitude": lon,
        "hourly": ["temperature_2m", "relative_humidity_2m", "precipitation_probability",
                   "precipitation", "surface_pressure", "cloud_cover", "visibility",
                   "wind_speed_10m", "wind_direction_10m"],
        "start_date": dt.datetime.fromtimestamp(days[0]).strftime("%Y-%m-%d"),
        "end_date": dt.datetime.fromtimestamp(days[1]).strftime("%Y-%m-%d")
    }
    responses = openmeteo.weather_api(url, params=params)
    hourly = responses[0].Hourly()
    hourly_temperature_2m = hourly.Variables(0).ValuesAsNumpy().tolist()
    hourly_relative_humidity_2m = hourly.Variables(1).ValuesAsNumpy().tolist()
    hourly_precipitation_probability = hourly.Variables(2).ValuesAsNumpy().tolist()
    hourly_precipitation = hourly.Variables(3).ValuesAsNumpy().tolist()
    hourly_surface_pressure = hourly.Variables(4).ValuesAsNumpy().tolist()
    hourly_cloud_cover = hourly.Variables(5).ValuesAsNumpy().tolist()
    hourly_visibility = hourly.Variables(6).ValuesAsNumpy().tolist()
    hourly_wind_speed_10m = hourly.Variables(7).ValuesAsNumpy().tolist()
    hourly_wind_direction_10m = hourly.Variables(8).ValuesAsNumpy().tolist()
    return {"temperature_2m": hourly_temperature_2m, "relative_humidity_2m": hourly_relative_humidity_2m,
            "precipitation_probability": hourly_precipitation_probability, "precipitation": hourly_precipitation,
            "surface_pressure": hourly_surface_pressure, "cloud_cover": hourly_cloud_cover, "visibility": hourly_visibility,
            "wind_speed_10m": hourly_wind_speed_10m, "wind_direction_10m": hourly_wind_direction_10m, "location": (lat, lon), "days": days}

# Get air quality data from OpenMeteo API
def get_air_quality(lat, lon, days=None):
    """
    Get air quality data (pm10, pm2.5 and European AQI) from OpenMeteo API
    :param lat: Latitude
    :param lon: Longitude
    :param days: Tuple of two datetime objects, start and end date, both inclusive, only year, month and day are considered
    :return: List of three numpy arrays, a tuple of floats and a tuple of two datetime objects: hourly_pm10, hourly_pm2_5, hourly_aqi, days
             each array contains hourly values for the respective pollutant or AQI
             for each day in the range of days the array will contain 24 values, one for each hour from 00:00 to 23:00, after which the next day starts
             the first tuple contains the latitude and longitude
             the second tuple contains the start and end date
    """
    if days is None:
        days = (dt.datetime.now().timestamp(), dt.datetime.now().timestamp())
    openmeteo = openmeteo_requests.Client()

    url = "https://air-quality-api.open-meteo.com/v1/air-quality"
    params = {
        "latitude": lat,
        "longitude": lon,
        "hourly": ["pm10", "pm2_5", "european_aqi"],
        "start_date": dt.datetime.fromtimestamp(days[0]).strftime("%Y-%m-%d"),
        "end_date": dt.datetime.fromtimestamp(days[1]).strftime("%Y-%m-%d")
    }
    responses = openmeteo.weather_api(url, params=params)
    hourly = responses[0].Hourly()
    hourly_pm10 = hourly.Variables(0).ValuesAsNumpy().tolist()
    hourly_pm2_5 = hourly.Variables(1).ValuesAsNumpy().tolist()
    hourly_aqi = hourly.Variables(2).ValuesAsNumpy().tolist()
    return {"pm10": hourly_pm10, "pm2_5": hourly_pm2_5, "aqi": hourly_aqi, "location": (lat, lon), "days": days}

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
    return data

# for testing only
if __name__ == "__main__":
    print(get_weather_forecast(51, 17, (1736366964, 1736626164)))
    print(get_air_quality(51, 17, (1736366964, 1736626164)))
