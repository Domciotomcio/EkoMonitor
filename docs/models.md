# Models

## raw_weather_data
How raw data about weather is stored.
Every information about weather will be accumulated separately, because:
 - they are from different endpoints
 - they might need to be refreshed at different times

Below basic unified json structure for raw weather data:
```json
{
  "id": "string",
  "timestamp": "number",
  "location": {
    "latitude": "number",
    "longitude": "number"
  },
  "weather_conditions": [
    ...
  ]
}
```
Info from  sensors will be stored in the `...` part.
Example data with temperature
```json
{
  "id": "1612345678",
  "timestamp": 1612345678,
  "location": {
    "latitude": 12.345678,
    "longitude": 23.456789
  },
  "weather_conditions": [
    {
      "type": "temperature",
      "value": 25.0,
      "unit": "C"
    }
  ]
}
```
Example data with elements from air quality sensor
```json
{
  "id": "1612345678",
  "timestamp": 1612345678,
  "location": {
    "latitude": 12.345678,
    "longitude": 23.456789
  },
  "weather_conditions": [
    {
      "type": "pm10",
      "value": 50.0,
      "unit": "ug/m3"
    },
    {
      "type": "pm25",
      "value": 25.0,
      "unit": "ug/m3"
    }
  ]
}
```

## data_processing_model
How data is processed and stored in the database in data processing module.

```json
{
  "id": "string",
  "start_timestamp": "number",
  "end_timestamp": "number",
  "time_delta": "number",
  "location": {
    "latitude": "number",
    "longitude": "number"
  },
  "weather_conditions": [
    "precipitation": {
      "value": "number",
      "unit": "string"
    },
    "cloud_coverage": {
      "value": "number",
      "unit": "string"
    },
    "temperature": {
      "value": "number",
      "unit": "string"
    },
    "pressure": {
      "value": "number",
      "unit": "string"
    },
    "humidity": {
      "value": "number",
      "unit": "string"
    },
    "visibility": {
      "value": "number",
      "unit": "string"
    },
    "wind_speed": {
      "value": "number",
      "wind_direction": "string",
      "unit": "string"
    },
    "pollen": {
      "value": "number",
      "unit": "string"
    },
    "particulate_matter": {
      "pm10": {
        "value": "number",
        "unit": "string"
      },
      "pm25": {
        "value": "number",
        "unit": "string"
      }
    }


  ]
}
```

## Mobile and Web app
Data that is needed to be send to mobile app.

**Latest data**
```json
{
  "id": "string",
  "timestamp": "number",  // latest timestamp of the data
  "location": {
    "latitude": "number",
    "longitude": "number",
    "city": "string",
    "region": "string",
    "country": "string"
  },
  "weather_conditions": [
    ...
  ]
}
```
**Data from specified date range**
```json
{
  "id": "string",
  "start_timestamp": "number",
  "end_timestamp": "number",
  "location": {
    "latitude": "number",
    "longitude": "number",
    "city": "string",
    "region": "string",
    "country": "string"
  },
  "weather_conditions": [
    ...
  ]
}
```


