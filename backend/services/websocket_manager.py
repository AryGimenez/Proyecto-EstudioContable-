# backend/services/websocket_manager.py

from fastapi import WebSocket # Importa la clase WebSocket de FastAPI para manejar conexiones
from typing import List, Dict # Tipos de Python para anotar listas y diccionarios

class ConnectionManager: # Clase principal para gestionar el ciclo de vida de las conexiones WebSocket
    
    def __init__(self): # Método constructor que se ejecuta al crear la instancia
        # Almacena las conexiones activas, si las necesitas para usuarios específicos
        # En este caso, solo necesitamos una lista simple para notificaciones globales
        self.active_connections: List[WebSocket] = [] # Lista que contiene todos los objetos WebSocket activos

    async def connect(self, websocket: WebSocket): # Método asíncrono para manejar una nueva conexión
        await websocket.accept() # Acepta la conexión WebSocket entrante
        self.active_connections.append(websocket) # Agrega el objeto WebSocket a la lista de conexiones activas

    def disconnect(self, websocket: WebSocket): # Método síncrono para manejar la desconexión
        self.active_connections.remove(websocket) # Remueve el objeto WebSocket de la lista de conexiones activas

    async def broadcast(self, message: Dict): # Método asíncrono para enviar un mensaje a todos los clientes
        """Envía un mensaje JSON a todos los clientes conectados.""" # Docstring que explica la función
        for connection in self.active_connections: # Itera sobre cada conexión activa en la lista
            # Usamos json para enviar datos estructurados
            await connection.send_json(message) # Envía el diccionario 'message' serializado como JSON al cliente

manager = ConnectionManager() # Crea una única instancia global del ConnectionManager para usar en el router/servicios