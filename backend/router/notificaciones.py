# backend/router/notifications.py

from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from ..services.websocket_manager import manager

router = APIRouter(tags=["Notificaciones"])

@router.websocket("/ws/notifications")
async def websocket_endpoint(websocket: WebSocket):
    await manager.connect(websocket)
    try:
        while True:
            # Mantener la conexión abierta (escuchando mensajes, aunque no se usen)
            data = await websocket.receive_text() 
            # Opcional: puedes manejar mensajes entrantes desde el frontend aquí
    except WebSocketDisconnect:
        manager.disconnect(websocket)