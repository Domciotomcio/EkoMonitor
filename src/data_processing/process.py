import json
import numpy as np
import datetime as dt
import requests

def process_weather_data(data):
    """
    Function to process weather data from OpenWeatherMap API

    :param data: JSON data from OpenWeatherMap API

    :return: Dictionary containing processed weather data
        - lat: Latitude
        - lon: Longitude
        - dt: Time of data calculation, unix, UTC
        - precipitation: Precipitation volume, mm/h
        - precipitation_type: Type of precipitation in string form: "rain", "snow" or "none"
        - clouds: Cloudiness, %
        - temperature: Temperature, Celsius
        - pressure: Atmospheric pressure on the sea level, hPa
        - humidity: Humidity, %
        - visibility: Visibility, meter (max 10km)
        - wind_speed: Wind speed, m/s
        - wind_degrees: Wind direction, degrees (meteorological)
    """
    dd = json.loads(data)
    return {
        "lat": dd["coord"]["lat"],
        "lon": dd["coord"]["lon"],
        "dt": dd["dt"],
        "precipitation": dd["rain"]["1h"] if "rain" in dd else dd["snow"]["1h"] if "snow" in dd else 0,
        "precipitation_type": "rain" if "rain" in dd else "snow" if "snow" in dd else "none",
        "clouds": dd["clouds"]["all"],
        "temperature": dd["main"]["temp"],
        "pressure": dd["main"]["pressure"],
        "humidity": dd["main"]["humidity"],
        "visibility": dd["visibility"],
        "wind_speed": dd["wind"]["speed"],
        "wind_degrees": dd["wind"]["deg"],
    }

def process_mass_weather_data(data):
    """
    Function to process bulk weather data from OpenWeatherMap API

    :param data: JSON data from OpenWeatherMap API

    :return: Dictionary containing processed weather data
    """
    dd = json.loads(data)
    dd = dd["list"]
    result = {}
    result["lat"] = dd[0]["coord"]["lat"]
    result["lon"] = dd[0]["coord"]["lon"]
    result["list"] = {}
    for d in dd:
        result["list"][d["dt"]] = {
            "lat": d["coord"]["lat"],
            "lon": d["coord"]["lon"],
            "precipitation": d["rain"]["1h"] if "rain" in d else d["snow"]["1h"] if "snow" in d else 0,
            "precipitation_type": "rain" if "rain" in d else "snow" if "snow" in d else "none",
            "clouds": d["clouds"]["all"],
            "temperature": d["main"]["temp"],
            "pressure": d["main"]["pressure"],
            "humidity": d["main"]["humidity"],
            "visibility": d["visibility"],
            "wind_speed": d["wind"]["speed"],
            "wind_degrees": d["wind"]["deg"],
        }
    return result


def process_air_quality_data(data):
    """
    Function to process air quality data from OpenMeteo API

    :param data: List of three numpy arrays: hourly_pm10, hourly_pm2_5, hourly_aqi. Each numpy has a number of values equal to 24 * number of days in the range

    :return: Dictionary containing processed air quality data.
        - pm10: List of hourly pm10 values
        - pm2_5: List of hourly pm2.5 values
        - aqi: List of hourly European AQI values
        - days: Tuple of two datetime objects, start and end date
    """
    pm10 = data["pm10"]
    pm2_5 = data["pm2_5"]
    aqi = data["aqi"]
    days = data["days"]
    return {
        "pm10": pm10,
        "pm2_5": pm2_5,
        "aqi": aqi,
        "days": days,
    }


def process_pollen_data(data):
    """
    Function to process pollen data from Google Pollen API

    :param data: JSON data from Google Pollen API

    :return: Dictionary containing processed pollen data.
        - day: Date of the data in UTC UNIX timestamp
        - tree: Tree pollen index
        - grass: Grass pollen index
        - weed: Weed pollen index
        - ragweed: Ragweed pollen index
        - grasses: Grasses pollen index
        - olive: Olive pollen index
        - mugwort: Mugwort pollen index
        - alder: Alder pollen index
        - hazel: Hazel pollen index
        - ash: Ash pollen index
        - birch: Birch pollen index
        - cottonwood: Cottonwood pollen index
        - oak: Oak pollen index
        - pine: Pine pollen index

    """
    dd = json.loads(data)["dailyInfo"][0]
    result = {
        "day": dt.datetime(year=dd["date"]["year"], month=dd["date"]["month"], day=dd["date"]["day"], tzinfo=dt.timezone.utc).timestamp()
    }
    
    for pollen in dd["pollenTypeInfo"]:
        code = pollen["code"]
        index = pollen["indexInfo"]["value"] if "indexInfo" in pollen else 0
        result[code] = index
    
    for plant in dd["plantInfo"]:
        code = plant["code"]
        index = plant["indexInfo"]["value"] if "indexInfo" in plant else 0
        result[code] = index
        
    return result


def process_hourly(weather, air_quality, pollen):
    """
    Function to process hourly data

    :param weather: JSON data from OpenWeatherMap API
    :param air_quality: List of three numpy arrays: hourly_pm10, hourly_pm2_5, hourly_aqi. Each numpy has a number of values equal to 24 * number of days in the range
    :param pollen: JSON data from Google Pollen API

    :return: Dictionary containing processed hourly data
    """
    weather_data = process_weather_data(weather)
    air_quality_data = process_air_quality_data(air_quality)
    pollen_data = process_pollen_data(pollen)
    h = dt.datetime.now().hour
    return json.dumps(str({
        "timestamp": dt.datetime.now().timestamp(),
        "location": {
            "latitude": weather_data["lat"],
            "longitude": weather_data["lon"],
        },
        "weather_conditions": {
            "precipitation": {
                "value": weather_data["precipitation"],
                "type": weather_data["precipitation_type"],
                "unit": "mm/h"
            },
            "cloudiness": {
                "value": weather_data["clouds"],
                "unit": "%"
            },
            "temperature": {
                "value": weather_data["temperature"],
                "unit": "°C"
            },
            "pressure": {
                "value": weather_data["pressure"],
                "unit": "hPa"
            },
            "humidity": {
                "value": weather_data["humidity"],
                "unit": "%"
            },
            "visibility": {
                "value": weather_data["visibility"],
                "unit": "m"
            },
            "wind_speed": {
                "value": weather_data["wind_speed"],
                "unit": "m/s"
            },
            "wind_direction": {
                "value": weather_data["wind_degrees"],
                "unit": "°"
            },
            "pm10": {
                "value": air_quality_data["pm10"][h],
                "unit": "µg/m³"
            },
            "pm2_5": {
                "value": air_quality_data["pm2_5"][h],
                "unit": "µg/m³"
            },
            "aqi": {
                "value": air_quality_data["aqi"][h],
                "unit": ""
            },
            "pollen": {
                "day": pollen_data["day"],
                "tree": {
                    "value": pollen_data["TREE"],
                    "unit": ""
                },
                "grass": {
                    "value": pollen_data["GRASS"],
                    "unit": ""
                },
                "weed": {
                    "value": pollen_data["WEED"],
                    "unit": ""
                },
                "ragweed": {
                    "value": pollen_data["RAGWEED"],
                    "unit": ""
                },
                "grasses": {
                    "value": pollen_data["GRAMINALES"],
                    "unit": ""
                },
                "olive": {
                    "value": pollen_data["OLIVE"],
                    "unit": ""
                },
                "mugwort": {
                    "value": pollen_data["MUGWORT"],
                    "unit": ""
                },
                "alder": {
                    "value": pollen_data["ALDER"],
                    "unit": ""
                },
                "hazel": {
                    "value": pollen_data["HAZEL"],
                    "unit": ""
                },
                "ash": {
                    "value": pollen_data["ASH"],
                    "unit": ""
                },
                "birch": {
                    "value": pollen_data["BIRCH"],
                    "unit": ""
                },
                "cottonwood": {
                    "value": pollen_data["COTTONWOOD"],
                    "unit": ""
                },
                "oak": {
                    "value": pollen_data["OAK"],
                    "unit": ""
                },
                "pine": {
                    "value": pollen_data["PINE"],
                    "unit": ""
                },
            }

        }
    }))


def process_hourly_request(lat, lon):
    """
    Function to process hourly data from API

    :param lat: Latitude
    :param lon: Longitude

    :return: results of process_hourly with data from aggregation API
    """
    url=f"http://127.0.0.1:8000/current/all?lat={lat}&lon={lon}"
    response = requests.get(url)
    resp = response.json()
    return process_hourly(resp["weather"], resp["air_quality"], resp["pollen"])


def process_historical_data(weather, air_quality):
    """
    Function to process historical data from OpenWeatherMap API and OpenMeteo API

    :param weather: JSON data from OpenWeatherMap API
    :param air_quality: List of three numpy arrays: hourly_pm10, hourly_pm2_5, hourly_aqi. Each numpy has a number of values equal to 24 * number of days in the range

    :return: Dictionary containing processed historical data
    """
    weather_data = process_mass_weather_data(weather)
    air_quality_data = process_air_quality_data(air_quality)

    result = {}
    result["location"] = {
        "latitude": weather_data["lat"],
        "longitude": weather_data["lon"],
    }
    result["weather_data"] = {}
    i = 0
    for timestamp, data in weather_data["list"].items():
        result["weather_data"][timestamp] = {
            "precipitation": {
                "value": data["precipitation"],
                "type": data["precipitation_type"],
                "unit": "mm/h"
            },
            "cloudiness": {
                "value": data["clouds"],
                "unit": "%"
            },
            "temperature": {
                "value": data["temperature"],
                "unit": "°C"
            },
            "pressure": {
                "value": data["pressure"],
                "unit": "hPa"
            },
            "humidity": {
                "value": data["humidity"],
                "unit": "%"
            },
            "visibility": {
                "value": data["visibility"],
                "unit": "m"
            },
            "wind_speed": {
                "value": data["wind_speed"],
                "unit": "m/s"
            },
            "wind_direction": {
                "value": data["wind_degrees"],
                "unit": "°"
            },
            "pm10": {
                "value": air_quality_data["pm10"][i],
                "unit": "µg/m³"
            },
            "pm2_5": {
                "value": air_quality_data["pm2_5"][i],
                "unit": "µg/m³"
            },
            "aqi": {
                "value": air_quality_data["aqi"][i],
                "unit": ""
            },
        }
        i += 1
    return json.dumps(str(result))


def process_historical_request(lat, lon, start, end):
    """
    Function to process historical data from API

    :param lat: Latitude
    :param lon: Longitude
    :param start: Start date in UNIX timestamp UTC timezone
    :param end: End date in UNIX timestamp UTC timezone

    :return: results of process_hourly with data from aggregation API
    """
    url=f"http://127.0.0.1:8000/historical/all?lat={lat}&lon={lon}&start={start}&end={end}"
    response = requests.get(url)
    resp = response.json()
    return process_historical_data(resp["weather"], resp["air_quality"])


# for testing only
if __name__ == "__main__":

    print(process_hourly_request(51, 17))