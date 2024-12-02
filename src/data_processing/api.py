from fastapi import FastAPI
from process import process_hourly_request


app = FastAPI()



@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/hourly/all")
def read_item(lat: float, lon: float):
    
    return process_hourly_request(lat, lon)


# for testing only
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8001)