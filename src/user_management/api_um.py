from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Optional
from user_management import create_user, authenticate_user, get_user, update_user, delete_user

app = FastAPI()

# Definition of Pydantic models for input data
class UserCreate(BaseModel):
    first_name: str
    last_name: str
    city: str
    email: str
    password: str

class UserUpdate(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    city: Optional[str] = None
    email: Optional[str] = None
    password: Optional[str] = None

class UserAuth(BaseModel):
    email: str
    password: str

# Endpoint for creating a new user
@app.post("/users/", response_model=int)
def api_create_user(user: UserCreate):
    user_id = create_user(user.first_name, user.last_name, user.city, user.email, user.password)
    if user_id is None:
        raise HTTPException(status_code=400, detail="User creation failed")
    return user_id

# Endpoint for authenticating a user
@app.post("/users/authenticate", response_model=int)
def api_authenticate_user(user: UserAuth):
    user_id = authenticate_user(user.email, user.password)
    if user_id is None:
        raise HTTPException(status_code=401, detail="Authentication failed")
    return user_id

# Endpoint for getting user data
@app.get("/users/{user_id}")
def api_get_user(user_id: int):
    user = get_user(user_id)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return user

# Endpoint for updating user data
@app.put("/users/{user_id}", response_model=int)
def api_update_user(user_id: int, user: UserUpdate):
    existing_user = get_user(user_id)
    if existing_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    
    updated_user = {
        "first_name": user.first_name if user.first_name is not None else existing_user[1],
        "last_name": user.last_name if user.last_name is not None else existing_user[2],
        "city": user.city if user.city is not None else existing_user[3],
        "email": user.email if user.email is not None else existing_user[4],
        "password": user.password if user.password is not None else existing_user[5],
    }
    
    updated_rows = update_user(user_id, updated_user["first_name"], updated_user["last_name"], updated_user["city"], updated_user["email"], updated_user["password"])
    if updated_rows == 0:
        raise HTTPException(status_code=400, detail="User update failed")
    return updated_rows

# Endpoint for deleting a user
@app.delete("/users/{user_id}", response_model=int)
def api_delete_user(user_id: int):
    deleted_rows = delete_user(user_id)
    if deleted_rows == 0:
        raise HTTPException(status_code=404, detail="User not found")
    return deleted_rows

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8001)