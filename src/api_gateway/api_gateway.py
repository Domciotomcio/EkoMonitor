from fastapi import FastAPI, Request, HTTPException, status
from fastapi.responses import JSONResponse
import httpx
import uvicorn
from pydantic import BaseModel
from datetime import datetime, timedelta, timezone
import jwt
from secrets import token_hex
import requests
import json
import re

app = FastAPI()

# Services and their base URLs
services = {
    "user_management": "http://user_management:8004/users",
    "user_profiling": "http://user_profiling:8005/user_answers"  
}

cachedUsers                 = dict()
SECRET_KEY                  = token_hex(32)
ALGORITHM                   = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 15


class UserAuth(BaseModel):
    email: str
    password: str

def extract_digits(input_string: str) -> int:
    digits = re.findall(r'\d', input_string)
    number = int(''.join(digits))
    return int(number)

def createBody(email: str, password: str):
    return {
        "email": email,
        "password": password
    }

def create_access_token(data: dict, expires_delta: timedelta | None = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.now(timezone.utc) + expires_delta
    else:
        expire = datetime.now(timezone.utc) + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

@app.post("/token")
async def login_for_access_token(userData: UserAuth):
    user = await authenticate(createBody(userData.email, userData.password), 
                              {"Content-Type": "application/json"})
    user = json.loads(user.json())
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": userData.email}, expires_delta=access_token_expires
    )
    cachedUsers[access_token] = {"email": userData.email, "user_id": user["user_id"],
                                  "expires": datetime.now().__add__(access_token_expires)}
    return "{\"access_token\": \"" + access_token + "\"}"


async def authenticate(body=None, headers=None):
    try:
        response = requests.post("http://user_management:8004/users/authenticate", json=body, headers=headers)
        return response
    except httpx.RequestError as exc:
        print(f"An error occurred while authorizing {exc.request.url!r}.")
        raise HTTPException(status_code=500, detail="Internal server error")


async def forward_request(service_url: str, method: str, path: str, body=None, headers=None):
    async with httpx.AsyncClient() as client:
        url = f"{service_url}{path}"
        try:
            if method == "GET":
                headers = None
            response = await client.request(method, url, json=body, headers=headers)
            return response
        except httpx.RequestError as exc:
            print(f"An error occurred while requesting {exc.request.url!r}.")
            raise HTTPException(status_code=500, detail="Internal server error")

@app.api_route("/{service}/{path:path}", methods=["GET", "POST", "PUT", "DELETE", "PATCH"])
async def gateway(service: str, path: str, request: Request):
    token = request.headers["Authorization"] 
    if service not in services:
        raise HTTPException(status_code=404, detail="Service not found")
    if path[-1].isdigit():
        if token not in cachedUsers:
            raise HTTPException(status_code=401, detail="Invalid token")
        cachedResults = cachedUsers[token]
        if int(cachedResults["user_id"]) != extract_digits(path):
            raise HTTPException(status_code=401, detail="Unauthorized access")
        if cachedResults["expires"] < datetime.now():
            raise HTTPException(status_code=401, detail="Token expired")
            
    service_url = services[service]
    body = await request.json() if request.method in ["POST", "PUT", "PATCH"] else None
    headers = dict(request.headers)
    try:
        response = await forward_request(service_url, request.method, f"/{path}", body, headers)
        return JSONResponse(status_code=response.status_code, content=response.json())
    except Exception as e:
        print(f"An error occurred: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")

if __name__ == '__main__':
    print("Starting the FastAPI application...")
    uvicorn.run(app, host="0.0.0.0", port=8003)