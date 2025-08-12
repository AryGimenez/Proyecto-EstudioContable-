from fastapi import FastAPI, HTTPException, APIRouter
from pydantic import BaseModel
import jwt
import datetime
from router import auth, reauth, users
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # O especifica ["http://localhost:port"] para mayor seguridad
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
app = FastAPI()

app.include_router(users.router)

SECRET_KEY = "mi_secreto"
ALGORITHM = "HS256"

class Login(BaseModel):
    usuario: str
    contrasena: str

class ResetPassword(BaseModel):
    correo: str
    codigo: str
    nueva_contrasena: str

@app.post("/login")
def login(credenciales: Login):
    # Lógica de verificación de credenciales (reemplazar con tu lógica)
    if credenciales.usuario == "usuario" and credenciales.contrasena == "contrasena":
        # Generar token JWT
        payload = {
            "sub": credenciales.usuario,
            "exp": datetime.datetime.utcnow() + datetime.timedelta(minutes=30)
        }
        token = jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)
        return {"access_token": token}
    else:
        raise HTTPException(status_code=401, detail="Credenciales incorrectas")

@app.post("/reset-password")
def reset_password(restablecer: ResetPassword):
    # Lógica de verificación de correo y código (reemplazar con tu lógica)
    if restablecer.correo == "correo@ejemplo.com" and restablecer.codigo == "1234":
        # Lógica para actualizar la contraseña en la base de datos
        return {"mensaje": "Contraseña restablecida con éxito"}
    else:
        raise HTTPException(status_code=400, detail="Correo o código incorrectos")
    