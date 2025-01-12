from fastapi import FastAPI
from forecast import forecast, create_model, load_model, save_model, train_model, get_data, process_data

app = FastAPI()



@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/forecast")
def read_item(code: str, timestamp: int, lat: float, lon: float):
    model, mean, std = load_model(code)
    return forecast(model, mean, std, timestamp, lat, lon)


@app.post("/new_model")
def read_item(code: str):
    model = create_model()
    save_model(code, model, None, None)
    return {"status": "success"}


@app.post("/train")
def read_item(code: str, time_from: int, time_to: int, lat: float, lon: float, proportion: float = 0.8, epochs: int = 10, batch_size: int = 32):
    model, mean, std = load_model(code)
    data = get_data(time_from, time_to, lat, lon)
    X_train, X_valid, y_train, y_valid = process_data(data, mean, std, proportion)
    model, history = train_model(model, X_train, X_valid, y_train, y_valid, epochs, batch_size)
    save_model(code, model, X_train.mean(), X_train.std())
    return {"history": str(history)}


# for testing only
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8002)