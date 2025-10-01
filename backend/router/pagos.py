from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
import asyncio
from ..services.websocket_manager import manager

# Importa los esquemas y repositorios
from ..dependencies import get_db
from ..schemas.pago import Pago, PagoCreate, PagoUpdate # Asegúrate de importar ClienteUpdate
from ..repositorios.pago_repository import PagoRepository
from ..services.websocket_manager import manager
from ..schemas.notificacion import NotificationMessage


router = APIRouter(
    prefix= "/pagos",
    tags=["Pagos"]
)


# --- ¡NUEVA FUNCIÓN DE DEPENDENCIA PARA EL REPOSITORIO! ---
# def get_pagos_repo(db: Session = Depends(get_db)) -> PagoRepository:
#     return PagoRepository(db)
# --------------------------------------------------------

@router.post("/", response_model=Pago, status_code=status.HTTP_201_CREATED, summary="Crear un nuevo pago")
async def create_pago( # Convertir a async si se necesita el broadcast
    pago_data: PagoCreate,
    db: Session = Depends(get_db),
):
    try:
        repo = PagoRepository(db)
        db_pago = repo.create(pago_data)

        # --- Lógica de Notificación Web ---
        notification_message = {
            "type": "pago_recibido",
            "message": f"Pago de {db_pago.Pago_Monto} {db_pago.Pago_Moneda} recibido.",
            "client_id": db_pago.Cli_ID,
            "payment_id": db_pago.Pago_ID,
            "date": db_pago.Pago_Fecha.isoformat() # Convertir date a string
        }
        # Enviar la notificación a todos los clientes conectados (background task)
        print("---NOTIFICACION DE DEBUG PARA TESTEAR QUE FUNCIONA ESTO----")
        print(notification_message)
        print("-----------------------------------------------------------")

        asyncio.create_task(manager.broadcast(notification_message))
        # -----------------------------------

        return db_pago
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error al crear el pago: {str(e)}"
        )
    
@router.get("/", response_model=List[Pago])
def get_all_pago(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    repo = PagoRepository(db)
    pagos = repo.get_all(skip=skip, limit=limit)
    return pagos

@router.get("/{pago_id}", response_model=Pago)
def get_pago(pago_id: int, db: Session = Depends(get_db)):
    repo = PagoRepository(db)
    db_pago = repo.get_by_id(pago_id)
    if db_pago is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Pago con la ID {pago_id} otorgada no fue encontrada en la base de datos"
        )
    return db_pago

@router.put("/{pago_id}", response_model=Pago)
def update_pagos(pago_id: int, pago_data: PagoUpdate, db: Session = Depends(get_db)):
    repo = PagoRepository(db)
    db_pago = repo.update(pago_id, pago_data)
    if db_pago is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Pago no encontrado"
        )
    return db_pago

@router.delete("/{pago_id}", status_code=status.HTTP_200_OK)
def delete_pago(pago_id: int, db: Session = Depends(get_db)):
    repo = PagoRepository(db)
    deleted_pago = repo.delete(pago_id)
    if deleted_pago is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Pago no encontrado"
        )
    return {"message": f"Pago con ID {pago_id} del eliminado correctamente"}