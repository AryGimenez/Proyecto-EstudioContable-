# backend/main.py (CORREGIDO)

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import HTMLResponse # Mantén estas importaciones si las usas en otras rutas
from datetime import date

# -----------------------------------------------------------------------------------------------------
# Importaciones de routers
from backend.router import (
    clientes,
    impuestos,
    pagos,
    depositos,
    # Alias para especificar nombre de impuesto 
    nombre_impuesto as nombre_impuesto_router,
    notificaciones as notificaciones_router
)
from backend.router import users as users_router
from backend.router import auth
# -----------------------------------------------------------------------------------------------------

# Importaciones de base de datos
from backend.database import Base, engine 

# -----------------------------------------------------------------------------------------------------
# Importaciones del Scheduler
from apscheduler.schedulers.asyncio import AsyncIOScheduler
from apscheduler.triggers.interval import IntervalTrigger # O CronTrigger si prefieres horas específicas
from datetime import timedelta # Útil si usas timedelta en el trigger o cálculos de fecha
from .services.scheduler_service import verificar_vencimientos_diarios # Tu lógica de alertas

# -----------------------------------------------------------------------------------------------------

# Importar todos los modelos para que Base.metadata.create_all los vea
# Esto es una buena práctica para asegurar que SQLAlchemy registre todos los modelos
from .models import cliente, deposito, impuesto, nombre_impuesto, pago, user, notificacion # Asegúrate de tener todos tus modelos aquí

# Crea las tablas si no existen (debe estar después de las importaciones de modelos)
Base.metadata.create_all(bind=engine) # <--- Linea encargada de la creacion de la base de datos (existe otra llamada alembic, pero la encontre un poco compleja voy a estudiarla un poco mas para ver)


app = FastAPI(
    title="API de Estudio Contable",
    description="API para la gestión de clientes y usuarios.",
    version="1.0.0",
)

# Configura CORS
origins = ["*"] # Considera restringir esto en producción
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Incluye los enrutadores
app.include_router(users_router.router)
app.include_router(clientes.router)
app.include_router(impuestos.router)
app.include_router(pagos.router)
app.include_router(depositos.router)
app.include_router(auth.router)
app.include_router(nombre_impuesto_router.router)
app.include_router(notificaciones_router.router)

# --- CONFIGURACION PARA SCHEDULER DE NOTIFICACION FUNCIONE CORRECTAMENTE ---

scheduler_instance = None # Inicializa a None o declara globalmente aquí

@app.on_event("startup")
async def startup_event():
    global scheduler_instance # Accede a la instancia global
    
    # Imprime la fecha de inicio del servidor una sola vez
    print(f"Fecha de inicio del servidor: {date.today()}")

    # 1. Asegurarse de que las tablas existan (si no se han creado ya)
    # Base.metadata.create_all(bind=engine) # Ya lo tienes fuera de un evento, eso está bien.

    # 2. Inicializar y arrancar el scheduler
    if scheduler_instance is None: # Solo inicializa si no está ya (medida extra de seguridad)
        scheduler_instance = AsyncIOScheduler()
        scheduler_instance.add_job(
            verificar_vencimientos_diarios,
            trigger=IntervalTrigger(minutes=1), # o 'cron', hour=9, minute=0 para producción
            id='diario_vencimiento_job',
            replace_existing=True # Esto es útil para el --reload de Uvicorn
        )
        scheduler_instance.start()
        print("Scheduler de alertas de vencimiento iniciado.")
    else:
        print("Advertencia: Scheduler ya estaba inicializado. Saltando inicio.")


@app.on_event("shutdown")
async def shutdown_event():
    global scheduler_instance
    if scheduler_instance and scheduler_instance.running:
        scheduler_instance.shutdown(wait=False) # wait=False para un apagado rápido
        print("Scheduler de alertas de vencimiento detenido.")

# --- FIN DE CONSOLIDACIÓN ---


# Ruta de bienvenida simplificada
@app.get("/", response_class=HTMLResponse)
async def read_root():
<<<<<<< HEAD
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
    print ("Intentando conectar a: {}:{}".format(ip_address, port))
    return {"message": "Configuración recibida. Intentando conectar a {}:{}".format(ip_address, port)}
=======
    return "<h1>Bienvenido a la API de Estudio Contable</h1>"
>>>>>>> Esteban22-09
