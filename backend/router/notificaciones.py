# backend/router/notifications.py

# Importaciones de FastAPI para manejar rutas y WebSockets
from fastapi import APIRouter, WebSocket, WebSocketDisconnect 
# Importación del gestor de conexiones WebSocket (asumiendo que tiene la lógica de conectar/desconectar/emitir)
from ..services.websocket_manager import manager 

# Define el router para Notificaciones
router = APIRouter(tags=["Notificaciones"]) # Etiqueta para la documentación automática (Swagger UI)

# ----------------------------------------------------------------------
# RUTA DE CONEXIÓN WEBSOCKET
# ----------------------------------------------------------------------

@router.websocket("/ws/notifications")
async def websocket_endpoint(websocket: WebSocket): # Define un endpoint de WebSocket
    """
    Gestiona la conexión WebSocket para recibir notificaciones en tiempo real.
    
    Esta función es el punto de entrada para que un cliente (frontend) se conecte
    al servidor para establecer una comunicación bidireccional.
    """
    
    # 1. Conexión: Aceptar la conexión y añadirla al gestor
    await manager.connect(websocket) 
    
    try:
        # 2. Bucle de Escucha: Mantener la conexión abierta
        while True:
            # Espera indefinidamente a recibir un mensaje del cliente. 
            # Esto mantiene la conexión activa. Si el cliente no envía nada, el bucle espera.
            # 'data' contendrá el mensaje de texto si el cliente envía algo.
            data = await websocket.receive_text() 
            
            # Opcional: Lógica para manejar mensajes entrantes del cliente (ej. un ping, solicitud de historial, etc.)
            # print(f"Mensaje recibido del cliente: {data}")
            
    except WebSocketDisconnect:
        # 3. Desconexión: Cuando el cliente cierra la conexión (ej. cierra la pestaña o pierde internet)
        # El gestor elimina el WebSocket de la lista de conexiones activas.
        manager.disconnect(websocket)
        # print("Cliente desconectado de notificaciones.")