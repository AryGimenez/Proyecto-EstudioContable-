# Importaciones necesarias
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse
from sqlalchemy.orm import Session
from fastapi import Depends

# Importa todas las dependencias del backend
from backend.database import Base, engine, get_db
from backend.schemas.config import AppConfig

# Importa todos los enrutadores de tu API
from backend.router import auth, clientes, impuestos, pagos, depositos, user

# Inicializa la aplicación de FastAPI
app = FastAPI()

# Crea las tablas de la base de datos si no existen
Base.metadata.create_all(bind=engine)

# Configuración de CORS
# Esto permite que tu frontend de Flutter (que se ejecuta en un origen diferente) se comunique con el backend.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Permite cualquier origen (ajústalo en producción)
    allow_credentials=True,
    allow_methods=["*"],  # Permite todos los métodos (GET, POST, etc.)
    allow_headers=["*"],  # Permite todos los encabezados
)

# Incluye todos los enrutadores de tu API
app.include_router(auth.router)
app.include_router(clientes.router)
app.include_router(impuestos.router)
app.include_router(pagos.router)
app.include_router(depositos.router)
app.include_router(user.router)

# Ruta para la página principal
# Esto sirve el archivo index.html que se crea cuando compilas la app de Flutter para la web.
# Es el punto de entrada de tu aplicación.
@app.get("/")
async def read_root():
    # Asegúrate de haber compilado tu app de Flutter para la web con `flutter build web`
    return FileResponse("frontend/flutter_gestion_contable/build/web/index.html")

# Sirve todos los archivos estáticos de la app de Flutter
# Esto le dice a FastAPI dónde encontrar los archivos de la app (CSS, JS, imágenes).
app.mount(
    "/",
    StaticFiles(directory="frontend/flutter_gestion_contable/build/web"),
    name="flutter_app"
)

# Ruta de ejemplo para la configuración de conexión
@app.post("/config/connect")
async def connect_to_app(config: AppConfig, db: Session = Depends(get_db)):
    ip_address = config.ip_address
    port = config.port
    print(f"Intentando conectar a: {ip_address}:{port}")
    return {"message": f"Configuración recibida. Intentando conectar a {ip_address}:{port}"}