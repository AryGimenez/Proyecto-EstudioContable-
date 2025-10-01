# backend/services/websocket_manager.py

from fastapi import WebSocket
from typing import List, Dict

class ConnectionManager:
    def __init__(self):
        # Almacena las conexiones activas, si las necesitas para usuarios específicos
        # En este caso, solo necesitamos una lista simple para notificaciones globales
        self.active_connections: List[WebSocket] = []

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)

    def disconnect(self, websocket: WebSocket):
        self.active_connections.remove(websocket)

    async def broadcast(self, message: Dict):
        """Envía un mensaje JSON a todos los clientes conectados."""
        for connection in self.active_connections:
            # Usamos json para enviar datos estructurados
            await connection.send_json(message)

manager = ConnectionManager()