from fastapi import APIRouter, HTTPException
from pydantic import BaseModel


router = APIRouter()

class User(BaseModel):
    id: int
    fullname: str
    email: str
    phone: str
    is_active: bool = True

@router.get("/Users")
async def User(Users: int):


