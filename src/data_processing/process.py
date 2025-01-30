import datetime as dt
import pymongo.mongo_client
import requests
import os
import pymongo
from copy import deepcopy
# from dotenv import load_dotenv

# load_dotenv()

# db_password = os.getenv("DB_PASSWORD")
try:
    with open("/run/secrets/MONGO_PASSWORD", "r") as file:
        db_password = file.read().strip()
except FileNotFoundError:
    db_password = None
uri = f"mongodb+srv://EkoMonitorAdmit:{db_password}@ekomonitor.kcnzk.mongodb.net/?retryWrites=true&w=majority&appName=EkoMonitor"
delta = 0.1


def process_weather_data(data):
    """
    Function to process weather data from OpenMeteo API

    :param data: List of nine numpy arrays and two tuples:
        - temperature_2m: List of hourly temperature values
        - relative_humidity_2m: List of hourly relative humidity values
        - precipitation_probability: List of hourly precipitation probability values
        - precipitation: List of hourly precipitation values
        - surface_pressure: List of hourly surface pressure values
        - cloud_cover: List of hourly cloud cover values
        - visibility: List of hourly visibility values
        - wind_speed_10m: List of hourly wind speed values
        - wind_direction_10m: List of hourly wind direction values
        - location: Tuple of two floats, latitude and longitude
        - days: Tuple of two ints, start and end date as UNIX timestamps
        For each day in the range of days the array will contain 24 values, one for each hour from 00:00 to 23:00, after which the next day starts

    :return: Dictionary containing processed weather data.
        - lat: Latitude
        - lon: Longitude
        - dt: Date and time of data as list of datetime
        - precipitation: list of Precipitation volume, mm/h
        - precipitation_probability: list of Probability of precipitation with more than 0.1 mm of the preceding hour, %
        - cloud_cover: list of Total cloud cover as an area fraction, %
        - temperature: list of Temperature, Celsius
        - pressure: list of Surface pressure, hPa
        - humidity: list of Relative humidity, %
        - visibility: list of Visibility, meter
        - wind_speed: list of Wind speed, m/s
        - wind_degrees: list of Wind direction, degrees
    """

    temperature_2m = data["temperature_2m"]
    relative_humidity_2m = data["relative_humidity_2m"]
    precipitation_probability = data["precipitation_probability"]
    precipitation = data["precipitation"]
    surface_pressure = data["surface_pressure"]
    cloud_cover = data["cloud_cover"]
    visibility = data["visibility"]
    wind_speed_10m = data["wind_speed_10m"]
    wind_direction_10m = data["wind_direction_10m"]
    lat = data["location"][0]
    lon = data["location"][1]
    dt_start = dt.datetime.fromtimestamp(data["days"][0], tz=dt.timezone.utc)
    dt_start = dt_start.replace(hour=0, minute=0, second=0, microsecond=0)
    dt_list = [dt_start + dt.timedelta(hours=i) for i in range(len(temperature_2m))]
    return {
        "lat": lat,
        "lon": lon,
        "dt": dt_list,
        "precipitation": precipitation,
        "precipitation_probability": precipitation_probability,
        "clouds": cloud_cover,
        "temperature": temperature_2m,
        "pressure": surface_pressure,
        "humidity": relative_humidity_2m,
        "visibility": visibility,
        "wind_speed": wind_speed_10m,
        "wind_degrees": wind_direction_10m,
    }

def process_air_quality_data(data):
    """
    Function to process air quality data from OpenMeteo API

    :param data: List of three numpy arrays and two tuples:
        - hourly_pm10: List of hourly pm10 values
        - hourly_pm2_5: List of hourly pm2.5 values
        - hourly_aqi: List of hourly European AQI values
        - location: Tuple of two floats, latitude and longitude
        - days: Tuple of two ints, start and end date as UNIX timestamps

    :return: Dictionary containing processed air quality data.
        - lat: Latitude
        - lon: Longitude
        - dt: Date and time of data as datetime
        - pm10: List of hourly pm10 values
        - pm2_5: List of hourly pm2.5 values
        - aqi: List of hourly European AQI values
    """
    pm10 = data["pm10"]
    pm2_5 = data["pm2_5"]
    aqi = data["aqi"]
    lat = data["location"][0]
    lon = data["location"][1]
    dt_start = dt.datetime.fromtimestamp(data["days"][0], tz=dt.timezone.utc)
    dt_start = dt_start.replace(hour=0, minute=0, second=0, microsecond=0)
    dt_list = [dt_start + dt.timedelta(hours=i) for i in range(len(pm10))]
    return {
        "lat": lat,
        "lon": lon,
        "dt": dt_list,
        "pm10": pm10,
        "pm2_5": pm2_5,
        "aqi": aqi,
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
    dd = data["dailyInfo"][0]
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
    return {
        "timestamp": int(dt.datetime.now().replace(microsecond=0, minute=0, second=0).timestamp()),
        "location": {
            "latitude": weather_data["lat"],
            "longitude": weather_data["lon"],
        },
        "weather_conditions": {
            "precipitation": {
                "value": weather_data["precipitation"][h],
                "unit": "mm/h"
            },
            "precipitation_probability": {
                "value": weather_data["precipitation_probability"][h],
                "unit": "%"
            },
            "cloudiness": {
                "value": weather_data["clouds"][h],
                "unit": "%"
            },
            "temperature": {
                "value": round(weather_data["temperature"][h]*100)/100,
                "unit": "°C"
            },
            "pressure": {
                "value": round(weather_data["pressure"][h]*100)/100,
                "unit": "hPa"
            },
            "humidity": {
                "value": weather_data["humidity"][h],
                "unit": "%"
            },
            "visibility": {
                "value": weather_data["visibility"][h],
                "unit": "m"
            },
            "wind_speed": {
                "value": round(weather_data["wind_speed"][h]*100)/100,
                "unit": "m/s"
            },
            "wind_direction": {
                "value": round(weather_data["wind_degrees"][h]*100)/100,
                "unit": "°"
            },
            "pm10": {
                "value": round(air_quality_data["pm10"][h]*100)/100,
                "unit": "µg/m³"
            },
            "pm2_5": {
                "value": round(air_quality_data["pm2_5"][h]*100)/100,
                "unit": "µg/m³"
            },
            "aqi": {
                "value": round(air_quality_data["aqi"][h]*100)/100,
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
    }


def process_hourly_request(lat, lon):
    """
    Function to process hourly data from API

    :param lat: Latitude
    :param lon: Longitude

    :return: results of process_hourly with data from aggregation API
    """
    client = pymongo.mongo_client.MongoClient(uri)
    db = client["EkoMonitor"]
    collection = db["processed_data_with_pollen"]
    existing_result = collection.find_one({
        "location.latitude": {"$gt": lat-delta, "$lt": lat+delta},
        "location.longitude": {"$gt": lon-delta, "$lt": lon+delta},
        "timestamp": int(dt.datetime.now().replace(microsecond=0, minute=0, second=0).timestamp())
    })
    if existing_result:
        existing_result.pop("_id")
        return existing_result

    url=f"http://data_aggregation:8000/current/all?lat={lat}&lon={lon}"
    response = requests.get(url)
    resp = response.json()
    result = process_hourly(resp["weather"], resp["air_quality"], resp["pollen"])
    collection.insert_one(result)

    collection2 = db["processed_data_no_pollen"]
    if collection2.count_documents({
        "location.latitude": {"$gt": lat-delta, "$lt": lat+delta},
        "location.longitude": {"$gt": lon-delta, "$lt": lon+delta},
        "timestamp": result["timestamp"]
    }) == 0:
        r2 = deepcopy(result)
        r2["weather_conditions"].pop("pollen")
        collection2.insert_one(r2)
    result.pop("_id")
    return result


def process_historical_data(weather, air_quality):
    """
    Function to process historical data from OpenWeatherMap API and OpenMeteo API

    :param weather: JSON data from OpenWeatherMap API
    :param air_quality: List of three numpy arrays: hourly_pm10, hourly_pm2_5, hourly_aqi. Each numpy has a number of values equal to 24 * number of days in the range

    :return: Dictionary containing processed historical data
    """
    weather_data = process_weather_data(weather)
    air_quality_data = process_air_quality_data(air_quality)

    result = {}
    result["location"] = {
        "latitude": weather_data["lat"],
        "longitude": weather_data["lon"],
    }
    result["weather_data"] = {}
    i = 0
    for time in weather_data["dt"]:
        result["weather_data"][int(time.timestamp())] = {
            "precipitation": {
                "value": weather_data["precipitation"][i],
                "unit": "mm/h"
            },
            "precipitation_probability": {
                "value": weather_data["precipitation_probability"][i],
                "unit": "%"
            },
            "cloudiness": {
                "value": weather_data["clouds"][i],
                "unit": "%"
            },
            "temperature": {
                "value": round(weather_data["temperature"][i]*100)/100,
                "unit": "°C"
            },
            "pressure": {
                "value": round(weather_data["pressure"][i]*100)/100,
                "unit": "hPa"
            },
            "humidity": {
                "value": weather_data["humidity"][i],
                "unit": "%"
            },
            "visibility": {
                "value": weather_data["visibility"][i],
                "unit": "m"
            },
            "wind_speed": {
                "value": round(weather_data["wind_speed"][i]*100)/100,
                "unit": "m/s"
            },
            "wind_direction": {
                "value": round(weather_data["wind_degrees"][i]*100)/100,
                "unit": "°"
            },
            "pm10": {
                "value": round(air_quality_data["pm10"][i]*100)/100,
                "unit": "µg/m³"
            },
            "pm2_5": {
                "value": round(air_quality_data["pm2_5"][i]*100)/100,
                "unit": "µg/m³"
            },
            "aqi": {
                "value": round(air_quality_data["aqi"][i]*100)/100,
                "unit": ""
            },
        }
        i += 1
    return result


def process_historical_request(lat, lon, start, end):
    """
    Function to process historical data from API

    :param lat: Latitude
    :param lon: Longitude
    :param start: Start date in UNIX timestamp UTC timezone
    :param end: End date in UNIX timestamp UTC timezone

    :return: results of process_hourly with data from aggregation API
    """

    client = pymongo.mongo_client.MongoClient(uri)
    db = client["EkoMonitor"]
    collection = db["processed_data_no_pollen"]
    st = int(dt.datetime.fromtimestamp(start).replace(microsecond=0, minute=0, second=0, hour=0).timestamp())
    en = int(dt.datetime.fromtimestamp(end).replace(microsecond=0, minute=0, second=0, hour=23).timestamp())
    missing = []
    existing_result = collection.find({
        "location.latitude": {"$gt": lat-delta, "$lt": lat+delta},
        "location.longitude": {"$gt": lon-delta, "$lt": lon+delta},
        "timestamp": {"$gt": st-1, "$lt": en+1}
    })
    existing_list = existing_result.to_list()
    existing_set = {x["timestamp"] for x in existing_list}
    for i in range(st, en+1, 3600):
        if i not in existing_set:
            missing.append(i)
    if missing == []:
        result = {
            "location": {
                "latitude": lat,
                "longitude": lon,
            },
            "weather_data": {}
        }
        for f in existing_list:
            f.pop("_id")
            result["weather_data"][f["timestamp"]] = f["weather_conditions"]
        return result

    url=f"http://data_aggregation:8000/historical/all?lat={lat}&lon={lon}&start={start}&end={end}"
    response = requests.get(url)
    resp = response.json()
    result = process_historical_data(resp["weather"], resp["air_quality"])
    missing_result = [{
        "timestamp": m,
        "location": {
            "latitude": lat,
            "longitude": lon,
        },
        "weather_conditions": result["weather_data"][m]
        } for m in result["weather_data"] if m in missing]
    if missing_result != []:
        collection.insert_many(missing_result)

    return result


def get_whole_database_nopollen():
    """
    Function to get the whole database of processed data without pollen

    :return: List of all entries in the database
    """
    client = pymongo.mongo_client.MongoClient(uri)
    db = client["EkoMonitor"]
    collection = db["processed_data_no_pollen"]
    result = collection.find({}).to_list()
    for r in result:
        r.pop("_id")
    return result


def get_whole_database_withpollen():
    """
    Function to get the whole database of processed data with pollen

    :return: List of all entries in the database
    """
    client = pymongo.mongo_client.MongoClient(uri)
    db = client["EkoMonitor"]
    collection = db["processed_data_with_pollen"]
    result = collection.find({}).to_list()
    for r in result:
        r.pop("_id")
    return result

# for testing only
if __name__ == "__main__":
    print(process_hourly_request(51, 17))
    print(process_historical_request(51, 17, 1736366964, 1736626164))