from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Optional
from user_profiling import create_user_answer, read_user_answer, update_user_answer, delete_user_answer

app = FastAPI()

# Definition of Pydantic models for input data
class UserAnswerCreate(BaseModel):
    user_id: int
    outdoor_activities: str
    health_concerns: str
    daily_commute: str
    gardening: str
    weather_interest: str

class UserAnswerUpdate(BaseModel):
    user_id: Optional[int] = None
    outdoor_activities: Optional[str] = None
    health_concerns: Optional[str] = None
    daily_commute: Optional[str] = None
    gardening: Optional[str] = None
    weather_interest: Optional[str] = None

# Endpoint for creating a new user answer
@app.post("/user_answers/", response_model=int)
def api_create_user_answer(user_answer: UserAnswerCreate):
    answer_id = create_user_answer(
        user_answer.user_id,
        user_answer.outdoor_activities,
        user_answer.health_concerns,
        user_answer.daily_commute,
        user_answer.gardening,
        user_answer.weather_interest
    )
    if answer_id is None:
        raise HTTPException(status_code=400, detail="User answer creation failed")
    return answer_id

# Endpoint for reading user answer
@app.get("/user_answers/{answer_id}")
def api_read_user_answer(answer_id: int):
    user_answer = read_user_answer(answer_id)
    if user_answer is None:
        raise HTTPException(status_code=404, detail="User answer not found")
    return user_answer

# Endpoint for updating user answer
@app.put("/user_answers/{answer_id}", response_model=int)
def api_update_user_answer(answer_id: int, user_answer: UserAnswerUpdate):
    existing_user_answer = read_user_answer(answer_id)
    if existing_user_answer is None:
        raise HTTPException(status_code=404, detail="User answer not found")
    
    updated_user_answer = {
        "user_id": user_answer.user_id if user_answer.user_id is not None else existing_user_answer[1],
        "outdoor_activities": user_answer.outdoor_activities if user_answer.outdoor_activities is not None else existing_user_answer[2],
        "health_concerns": user_answer.health_concerns if user_answer.health_concerns is not None else existing_user_answer[3],
        "daily_commute": user_answer.daily_commute if user_answer.daily_commute is not None else existing_user_answer[4],
        "gardening": user_answer.gardening if user_answer.gardening is not None else existing_user_answer[5],
        "weather_interest": user_answer.weather_interest if user_answer.weather_interest is not None else existing_user_answer[6],
    }
    
    updated_rows = update_user_answer(
        answer_id,
        updated_user_answer["user_id"],
        updated_user_answer["outdoor_activities"],
        updated_user_answer["health_concerns"],
        updated_user_answer["daily_commute"],
        updated_user_answer["gardening"],
        updated_user_answer["weather_interest"]
    )
    if updated_rows == 0:
        raise HTTPException(status_code=400, detail="User answer update failed")
    return updated_rows

# Endpoint for deleting user answer
@app.delete("/user_answers/{answer_id}", response_model=int)
def api_delete_user_answer(answer_id: int):
    deleted_rows = delete_user_answer(answer_id)
    if deleted_rows == 0:
        raise HTTPException(status_code=404, detail="User answer not found")
    return deleted_rows

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8005)