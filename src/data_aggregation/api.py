from fastapi import FastAPI
from aggregation import get_weather, get_air_quality, get_pollen


app = FastAPI()



@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/current/all")
def read_item(lat: float, lon: float):
    return {"weather": get_weather(lat, lon), "air_quality": get_air_quality(lat, lon), "pollen": get_pollen(lat, lon)}


# for testing only
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)