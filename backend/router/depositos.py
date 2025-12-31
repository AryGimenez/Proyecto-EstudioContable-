# backend/router/depositos.py

# Importaciones de FastAPI y SQLAlchemy
from fastapi import APIRouter, Depends, HTTPException, status # Importaciones necesarias para funciones de FastAPI
from sqlalchemy.orm import Session # Importación para manejar sesiones de base de datos
from typing import List # Para tipos de listas


# Importaciones de tu proyecto
from ..schemas.deposito import DepositoCreate, Deposito, DepositoUpdate # Asegura la importaciones de los esquemas de depósito
from ..repositorios.deposito_repository import DepositoRepository # Importa el repositorio de depósitos
from ..dependencies import get_db # Dependencia para obtener la sesión de la base de datos
from ..services.websocket_manager import manager # Importa el gestor de WebSockets, para notificaciones en tiempo real
from ..schemas.notificacion import NotificationMessage # Esquema para mensajes de notificación
import asyncio # Para tareas asíncronas en segundo plano


# Define el router para depósitos
router = APIRouter(
    prefix="/depositos", # Prefijo para todas las rutas de depósitos, "/" es la url que se usa como camino acceder a estas rutas
    tags=["Depositos"]
)

# Dependencia para obtener el repositorio de depósitos (inyección de dependencias)
def get_deposito_repo(db: Session = Depends(get_db)) -> DepositoRepository: # Inyecta la sesión de DB y retorna el repositorio
    return DepositoRepository(db) # Crea una instancia del repositorio de depósitos


# Rutas CRUD para depósitos (POST, GET, PUT, DELETE)

# Obtener todos los depósitos
@router.get("/", response_model=List[Deposito], summary="Obtener todos los depósitos") # Responde con una lista de depósitos
def get_all_depositos(
    skip: int = 0, # Parámetro para paginación (número de registros a omitir)
    limit: int = 100, # Parámetro para paginación (límite de registros a retornar)
    repo: DepositoRepository = Depends(get_deposito_repo) # Inyecta el repositorio de depósitos (dependencia
):
    return repo.get_all(skip=skip, limit=limit) # Retorna todos los depósitos con paginación


# Obtener un depósito por ID
@router.get("/{deposito_id}", response_model=Deposito) # Responde con el esquema de depósito
def get_deposito(deposito_id: int, db: Session = Depends(get_db)): # ID del depósito y sesión de DB inyectada (dependencia)
    repo = DepositoRepository(db) # Crea una instancia del repositorio de depósitos
    db_deposito = repo.get_by_id(deposito_id) # Busca el depósito por ID
    if db_deposito is None: # Si no se encuentra, lanza un error 404
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Deposito con la ID {deposito_id} otorgada no fue encontrada en la base de datos"
        )
    return db_deposito # Retorna el depósito encontrado si está en la base de datos

# Crear un nuevo depósito
@router.post("/", response_model=Deposito, status_code=status.HTTP_201_CREATED) # Responde con el esquema de depósito y código 201
async def create_deposito(
    deposito_data: DepositoCreate, # Datos del nuevo depósito (monto, fecha, cliente, etc.)
    db: Session = Depends(get_db) # Sesión de base de datos inyectada (dependencia
):
    try:
        repo = DepositoRepository(db) # Obtiene el repositorio de depósitos
        db_deposito = repo.create(deposito_data) # Intenta crear el depósito en la base de datos

        # --- Lógica de Notificación Web ---
        notification_message = {
            "type": "deposito_recibido", # Tipo de notificación
            "message": f"Depósito de {db_deposito.Dep_Monto} {db_deposito.Dep_Moneda} recibido.", # Mensaje de la notificación
            "client_id": db_deposito.Cli_ID, # ID del cliente asociado al depósito
            "payment_id": db_deposito.Dep_ID, # ID del depósito creado
            "date": db_deposito.Dep_Fecha.isoformat() # Fecha del depósito en formato ISO
        }

        # --- Enviar Notificación a terminal para testeo se eliminara a futuro ---

        print("---NOTIFICACION DE DEBUG PARA TESTEAR QUE FUNCIONA ESTO----")
        print(notification_message)
        print("-----------------------------------------------------------")
       

       # Enviar la notificación a todos los clientes conectados (background task)
        asyncio.create_task(manager.broadcast(notification_message)) 
        # -----------------------------------

        return db_deposito # Retorna el depósito creado
    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e)) # Error al crear el depósito


# Actualizar un depósito existente
@router.put("/{deposito_id}", response_model=Deposito, summary="Actualizar un depósito existente") # Actualiza un depósito por ID
def update_deposito(
    deposito_id: int, # ID del depósito a actualizar
    deposito_update: DepositoUpdate, # Datos actualizados del depósito
    repo: DepositoRepository = Depends(get_deposito_repo) # Repositorio de depósitos inyectado
):
    try: # Intentar actualizar el depósito
        deposito = repo.update(deposito_id, deposito_update) # Actualiza el depósito en la base de datos
        if not deposito: # Si no se encuentra el depósito
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Depósito no encontrado") # Error 404
        return deposito # Retorna el depósito actualizado
    except ValueError as e: # Captura de errores al actualizar el depósito
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e)) # Error al actualizar el depósito


# Eliminar un depósito por ID
@router.delete("/{deposito_id}", status_code=status.HTTP_204_NO_CONTENT, summary="Eliminar un depósito") # Eliminar un depósito por ID
def delete_deposito(
    deposito_id: int, # ID del depósito a eliminar
    repo: DepositoRepository = Depends(get_deposito_repo) # Repositorio de depósitos inyectado
):
    try:
        if not repo.delete(deposito_id):
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Depósito no encontrado") # Error 404
        return {} # Retorna un diccionario vacío
    except ValueError as e: # Captura de errores al eliminar el depósito
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e)) # Error al eliminar el depósito