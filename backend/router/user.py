from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from backend import database, models, schemas
from backend.dependencies import get_db
from backend.security import get_password_hash
# from backend.auth import get_current_active_user # If you implement user authentication
from backend.schemas import user  # Importa el módulo user.py

router = APIRouter(
    prefix="/users",
    tags=["users"],
    # dependencies=[Depends(get_current_active_user)], # Protect these routes
)

@router.post("/", response_model=user.User)  # Usa user.User
def create_user(user_data: user.UserCreate, db: Session = Depends(get_db)):
    db_user = db.query(models.User).filter(models.User.username == user_data.username).first()
    if db_user:
        raise HTTPException(status_code=400, detail="Nombre de usuario ya registrado")
    db_email = db.query(models.User).filter(models.User.email == user_data.email).first()
    if db_email:
        raise HTTPException(status_code=400, detail="Correo electrónico ya registrado")
    hashed_password = get_password_hash(user_data.password)
    db_user = models.User(username=user_data.username, email=user_data.email, hashed_password=hashed_password)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

@router.get("/", response_model=List[user.User])  # Usa user.User
def read_users(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    users = db.query(models.User).offset(skip).limit(limit).all()
    return users

@router.get("/{user_id}", response_model=user.User)  # Usa user.User
def read_user(user_id: int, db: Session = Depends(get_db)):
    db_user = db.query(models.User).filter(models.User.id == user_id).first()
    if db_user is None:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")
    return db_user

@router.put("/{user_id}", response_model=user.User)  # Usa user.User
def update_user(user_id: int, user_data: user.UserUpdate, db: Session = Depends(get_db)):
    db_user = db.query(models.User).filter(models.User.id == user_id).first()
    if db_user is None:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")
    if user_data.password:
        hashed_password = get_password_hash(user_data.password)
        user_data.hashed_password = hashed_password
    for key, value in user_data.dict(exclude_unset=True).items():
        setattr(db_user, key, value)
    db.commit()
    db.refresh(db_user)
    return db_user

@router.delete("/{user_id}", response_model=user.User)  # Usa user.User
def delete_user(user_id: int, db: Session = Depends(get_db)):
    db_user = db.query(models.User).filter(models.User.id == user_id).first()
    if db_user is None:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")
    db.delete(db_user)
    db.commit()
    return db_user