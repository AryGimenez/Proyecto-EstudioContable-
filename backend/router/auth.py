from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from backend import database, models, schemas
from backend.schemas import auth
from backend.security import verify_password, get_password_hash
from backend.config import ACCESS_TOKEN_EXPIRE_MINUTES
from datetime import timedelta
from fastapi.security import OAuth2PasswordRequestForm
from backend.utils import generate_verification_code, send_verification_email  # Import utils
from sqlalchemy.sql import func

router = APIRouter(prefix="/auth", tags=["authentication"])

@router.post("/login")
async def login(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(database.get_db)):
    user = db.query(models.User).filter(models.User.username == form_data.username).first()
    if not user or not verify_password(form_data.password, user.hashed_password):
        raise HTTPException(status_code=400, detail="Credenciales incorrectas")
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = security.create_access_token(data={"sub": user.username}, expires_delta=access_token_expires)
    return {"access_token": access_token, "token_type": "bearer"}

@router.post("/password-reset/request")
async def request_password_reset(request_data: schemas.auth.PasswordResetRequestSchema, db: Session = Depends(database.get_db)):
    user = db.query(models.User).filter(models.User.email == request_data.email).first()
    if user:
        verification_code = generate_verification_code()
        # Store the verification code in the database (you might want a separate table for this)
        reset_request = models.PasswordResetRequest(
            email=user.email,
            token=verification_code,  # Using 'token' field for verification code for simplicity
            user_id=user.id
        )
        db.add(reset_request)
        db.commit()
        # Send the verification code to the user's email
        send_verification_email(user.email, verification_code)
        return {"message": "Se ha enviado un código de verificación a tu correo electrónico."}
    raise HTTPException(status_code=404, detail="No se encontró usuario con ese correo electrónico.")

@router.post("/password-reset/verify-code")
async def verify_code(verification_data: schemas.auth.VerifyCodeSchema, db: Session = Depends(database.get_db)):
    reset_request = db.query(models.PasswordResetRequest).filter(
        models.PasswordResetRequest.token == verification_data.verification_code,
        models.PasswordResetRequest.email == verification_data.email,
        models.PasswordResetRequest.created_at > func.now() - timedelta(minutes=15)  # Optional: Code expiration
    ).first()
    if reset_request:
        return {"message": "Código de verificación válido. Puedes restablecer tu contraseña."}
    raise HTTPException(status_code=400, detail="Código de verificación inválido o expirado.")

@router.post("/password-reset/confirm")
async def confirm_password_reset(reset_data: schemas.auth.PasswordResetConfirm, db: Session = Depends(database.get_db)):
    reset_request = db.query(models.PasswordResetRequest).filter(
        models.PasswordResetRequest.token == reset_data.verification_code,
        models.PasswordResetRequest.email == reset_data.email
    ).first()
    if reset_request:
        user = db.query(models.User).filter(models.User.email == reset_request.email).first()
        if user:
            hashed_password = get_password_hash(reset_data.new_password)
            user.hashed_password = hashed_password
            db.delete(reset_request)  # Remove the used reset request
            db.commit()
            return {"message": "Contraseña restablecida exitosamente."}
        raise HTTPException(status_code=404, detail="No se encontró usuario asociado a esta solicitud.")
    raise HTTPException(status_code=400, detail="Solicitud de restablecimiento de contraseña inválida.")