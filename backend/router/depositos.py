from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

from ..schemas.deposito import DepositoCreate, Deposito, DepositoUpdate
from ..repositorios.deposito_repository import DepositoRepository
from ..dependencies import get_db
from ..services.websocket_manager import manager
from ..schemas.notificacion import NotificationMessage
import asyncio

router = APIRouter(
    prefix="/depositos",
    tags=["Depositos"]
)

def get_deposito_repo(db: Session = Depends(get_db)) -> DepositoRepository:
    return DepositoRepository(db)

@router.get("/", response_model=List[Deposito], summary="Obtener todos los depósitos")
def get_all_depositos(
    skip: int = 0,
    limit: int = 100,
    repo: DepositoRepository = Depends(get_deposito_repo)
):
    return repo.get_all(skip=skip, limit=limit)

@router.get("/{deposito_id}", response_model=Deposito)
def get_deposito(deposito_id: int, db: Session = Depends(get_db)):
    repo = DepositoRepository(db)
    db_deposito = repo.get_by_id(deposito_id)
    if db_deposito is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Deposito con la ID {deposito_id} otorgada no fue encontrada en la base de datos"
        )
    return db_deposito

@router.post("/", response_model=Deposito, status_code=status.HTTP_200_OK)
async def create_deposito( # Convertir a async si se necesita el broadcast
    deposito_data: DepositoCreate,
    db: Session = Depends(get_db)
):
    try:
        repo = DepositoRepository(db)
        db_deposito = repo.create(deposito_data)

        # --- Lógica de Notificación Web ---
        notification_message = {
            "type": "deposito_recibido",
            "message": f"Depósito de {db_deposito.Dep_Monto} {db_deposito.Dep_Moneda} recibido.",
            "client_id": db_deposito.Cli_ID,
            "payment_id": db_deposito.Dep_ID,
            "date": db_deposito.Dep_Fecha.isoformat() # Convertir date a string
        }
        # Enviar la notificación a todos los clientes conectados (background task)

        print("---NOTIFICACION DE DEBUG PARA TESTEAR QUE FUNCIONA ESTO----")
        print(notification_message)
        print("-----------------------------------------------------------")
       
        asyncio.create_task(manager.broadcast(notification_message)) 
        # -----------------------------------

        return db_deposito
    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e))
    
    

@router.put("/{deposito_id}", response_model=Deposito, summary="Actualizar un depósito existente")
def update_deposito(
    deposito_id: int,
    deposito_update: DepositoUpdate,
    repo: DepositoRepository = Depends(get_deposito_repo)
):
    try:
        deposito = repo.update(deposito_id, deposito_update)
        if not deposito:
            raise HTTPException(status_code=404, detail="Depósito no encontrado")
        return deposito
    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e))

@router.delete("/{deposito_id}", status_code=status.HTTP_204_NO_CONTENT, summary="Eliminar un depósito")
def delete_deposito(
    deposito_id: int,
    repo: DepositoRepository = Depends(get_deposito_repo)
):
    try:
        if not repo.delete(deposito_id):
            raise HTTPException(status_code=404, detail="Depósito no encontrado")
        return {}
    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e))