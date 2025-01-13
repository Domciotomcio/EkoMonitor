from fastapi import FastAPI
from forecast import forecast, create_model, load_model, save_model, train_model, get_data, process_data, get_data_all

app = FastAPI()



@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/forecast")
def forecast_weather(code: str, timestamp: int, lat: float, lon: float):
    model, mean, std = load_model(code)
    return forecast(model, mean, std, timestamp, lat, lon)


@app.post("/new_model")
def create_new_model(code: str):
    model = create_model()
    save_model(code, model, None, None)
    return {"status": "success"}


@app.post("/train")
def train(code: str, time_from: int, time_to: int, lat: float, lon: float, proportion: float = 0.8, epochs: int = 10, batch_size: int = 32):
    model, mean, std = load_model(code)
    if model is None:
        return {"error": f"Model {code} not found"}
    data = get_data(time_from, time_to, lat, lon)
    mean, std, X_train, X_valid, y_train, y_valid = process_data(data, mean, std, proportion)
    model, history = train_model(model, X_train, X_valid, y_train, y_valid, epochs, batch_size)
    save_model(code, model, mean, std)
    return {"history": history.history}


@app.post("/train/super")
def train_on_all(code: str, proportion: float = 0.8, epochs: int = 10, batch_size: int = 32):
    model, mean, std = load_model(code)
    if model is None:
        return {"error": f"Model {code} not found"}
    data = get_data_all()
    mean, std, X_train, X_valid, y_train, y_valid = process_data(data, mean, std, proportion)
    model, history = train_model(model, X_train, X_valid, y_train, y_valid, epochs, batch_size)
    save_model(code, model, mean, std)
    return {"history": history.history}


# for testing only
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8002)