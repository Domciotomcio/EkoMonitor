from fastapi import FastAPI
from aggregation import get_weather_forecast, get_air_quality, get_pollen

app = FastAPI()



@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/current/all")
def read_item(lat: float, lon: float):
    return {"weather": get_weather_forecast(lat, lon), "air_quality": get_air_quality(lat, lon), "pollen": get_pollen(lat, lon)}

@app.get("/historical/all")
def read_item(lat: float, lon: float, start: str, end: str):
    return {"weather": get_weather_forecast(lat, lon, (int(start), int(end))), "air_quality": get_air_quality(lat, lon, (int(start), int(end)))}


# for testing only
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)