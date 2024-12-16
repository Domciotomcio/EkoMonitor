from fastapi import FastAPI
from aggregation import get_weather, get_air_quality, get_pollen, get_historical_weather
from datetime import datetime as dt


app = FastAPI()



@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/current/all")
def read_item(lat: float, lon: float):
    return {"weather": get_weather(lat, lon), "air_quality": get_air_quality(lat, lon), "pollen": get_pollen(lat, lon)}

@app.get("/historical/all")
def read_item(lat: float, lon: float, start: str, end: str):
    return {"weather": get_historical_weather(lat, lon, start, end), "air_quality": get_air_quality(lat, lon, (dt.fromtimestamp(int(lat)), dt.fromtimestamp(int(lon))))}


# for testing only
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)