from fastapi import FastAPI, Request, HTTPException
from fastapi.responses import JSONResponse
import httpx
import uvicorn

app = FastAPI()

# Services and their base URLs
services = {
    "user_management": "http://localhost:8001/users",
    "user_profiling": "http://localhost:8002/user_answers"  
}

async def forward_request(service_url: str, method: str, path: str, body=None, headers=None):
    async with httpx.AsyncClient() as client:
        url = f"{service_url}{path}"
        try:
            if method == "GET":
                headers = None
            response = await client.request(method, url, json=body, headers=headers)
            #print("test: ", body, headers)
            #response = await client.request(method, url, json=None, headers=None)
            return response
        except httpx.RequestError as exc:
            print(f"An error occurred while requesting {exc.request.url!r}.")
            raise HTTPException(status_code=500, detail="Internal server error")

@app.api_route("/{service}/{path:path}", methods=["GET", "POST", "PUT", "DELETE", "PATCH"])
async def gateway(service: str, path: str, request: Request):
    if service not in services:
        raise HTTPException(status_code=404, detail="Service not found")
    service_url = services[service]
    body = await request.json() if request.method in ["POST", "PUT", "PATCH"] else None
    headers = dict(request.headers)
    print("test:\n", headers, "\n", request.headers, "\n", dict(request.headers))

    try:
        response = await forward_request(service_url, request.method, f"/{path}", body, headers)
        return JSONResponse(status_code=response.status_code, content=response.json())
    except Exception as e:
        print(f"An error occurred: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")

if __name__ == '__main__':
    print("Starting the FastAPI application...")
    uvicorn.run(app, host="0.0.0.0", port=8000)