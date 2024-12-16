from fastapi import FastAPI
from process import process_hourly_request, process_historical_request


app = FastAPI()



@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/hourly/all")
def read_item(lat: float, lon: float):
    return process_hourly_request(lat, lon)

@app.get("/historical/all")
def read_item(lat: float, lon: float, start: str, end: str):
    return process_historical_request(lat, lon, start, end)


# for testing only
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8001)