from fastapi import FastAPI
from process import process_hourly_request, process_historical_request
import datetime as dt

app = FastAPI()



@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/hourly/all")
def read_item(lat: float, lon: float):
    return process_hourly_request(lat, lon)

@app.get("/historical/all")
def read_item(lat: float, lon: float, start: int, end: int):
    st = int(dt.datetime.fromtimestamp(start).replace(hour=0, minute=0, second=0, microsecond=0).timestamp())
    en = int(dt.datetime.fromtimestamp(end).replace(hour=23, minute=0, second=0, microsecond=0).timestamp())
    return process_historical_request(lat, lon, st, en)


# for testing only
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8001)