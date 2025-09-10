from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
# Mantén estas importaciones si las usas en otras rutas
from fastapi.responses import HTMLResponse, RedirectResponse 
from backend.router import clientes, users, impuestos, pagos, depositos
from backend.database import Base, engine

# Crea las tablas si no existen
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="API de Estudio Contable",
    description="API para la gestión de clientes y usuarios.",
    version="1.0.0",
)

# Configura CORS
origins = ["*"]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Incluye los enrutadores
app.include_router(users.router)
app.include_router(clientes.router)
app.include_router(impuestos.router)
# app.include_router(pagos.router)
# app.include_router(depositos.router)

# Ruta de bienvenida simplificada
@app.get("/", response_class=HTMLResponse)
async def read_root():
    return "<h1>Bienvenido a la API de Estudio Contable</h1>"