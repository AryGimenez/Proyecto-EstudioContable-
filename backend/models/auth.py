# models/auth.py
from sqlalchemy import Column, Integer, String, ForeignKey, DateTime, func
from sqlalchemy.orm import relationship
from backend.database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, index=True)
    email = Column(String, unique=True, index=True)
    hashed_password = Column(String)
    created_at = Column(DateTime, server_default=func.now())

    # Relationship with PasswordResetRequest
    password_reset_requests = relationship("PasswordResetRequest", back_populates="user")

class PasswordResetRequest(Base):
    __tablename__ = "password_reset_requests"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, ForeignKey("users.email"))
    token = Column(String)
    created_at = Column(DateTime, server_default=func.now())

    user = relationship("User", back_populates="password_reset_requests")