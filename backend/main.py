from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from backend.router import auth, clientes, impuestos, pagos, depositos, user
from fastapi.middleware.cors import CORSMiddleware
from backend.database import Base, engine
from fastapi import FastAPI, Depends
from backend.schemas.config import AppConfig
from sqlalchemy.orm import Session
from backend.database import get_db

Base.metadata.create_all(bind=engine)

app = FastAPI()

app.mount("/static", StaticFiles(directory="frontend/flutter_gestion_contable/lib/"), name="static") # Ejemplo para un build de React

@app.get("/")
async def read_root():
    return Fileresponse("frontend/flutter_gestion_contable/lib/main.react") # Ajusta la ruta a tu index.html

# Configuración de CORS (asegúrate de permitir el método POST para esta ruta)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router)

# app.include_router(users.router)

@app.post("/config/connect")
async def connect_to_app(config: AppConfig, db: Session = Depends(get_db)):
    ip_address = config.ip_address
    port = config.port
    print(f"Intentando conectar a: {ip_address}:{port}")

    # Aquí iría la lógica para intentar conectarse a la aplicación
    # en la dirección IP y el puerto proporcionados.
    # Esto podría involucrar:
    # - Intentar una conexión de red (socket)
    # - Hacer una petición HTTP a otra API
    # - Conectarse a una base de datos en esa ubicación

    # Por ahora, solo devolvemos un mensaje indicando que se recibió la configuración
    return {"message": f"Configuración recibida. Intentando conectar a {ip_address}:{port}"}
Base.metadata.create_all(bind=engine)

app = FastAPI()

# Configuración de CORS para permitir peticiones desde tu frontend Flutter (en desarrollo)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # En producción, limita esto a los dominios de tu app
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router)
# app.include_router(users.router) # Si tienes rutas de usuarios