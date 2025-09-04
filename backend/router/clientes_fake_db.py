# routers/clientes_fake_db.py

from fastapi import APIRouter, HTTPException, Depends
from typing import List

# Importamos los esquemas que definiste en el archivo schemas/cliente.py
from backend.schemas import cliente 

router = APIRouter(
    prefix="/clientes",
    tags=["clientes"]
)

# 💾 Base de datos falsa: Una lista de Python para simular los registros de clientes.
# La inicializamos con 3 clientes falsos para que puedas hacer pruebas de inmediato.
fake_db = [
    {
        "id": 1,
        "nombre_completo": "Ana Torres",
        "email": "ana.torres@example.com",
        "contacto": "555-1234",
        "whatsapp": "555-1234",
        "saldo": 1500.50,
        "direccion": "Calle Falsa 123",
    },
    {
        "id": 2,
        "nombre_completo": "Carlos Ruiz",
        "email": "carlos.ruiz@example.com",
        "contacto": "555-5678",
        "whatsapp": "555-5678",
        "saldo": -50.75,
        "direccion": "Avenida Siempre Viva 456",
    },
    {
        "id": 3,
        "nombre_completo": "Elena Gómez",
        "email": "elena.gomez@example.com",
        "contacto": "555-9012",
        "whatsapp": "555-9012",
        "saldo": 0.0,
        "direccion": "Plaza Central 789",
    },
]

# 💡 POST: Crea un nuevo cliente
@router.post("/", response_model=cliente.Cliente, status_code=201)
def create_cliente(cliente_data: cliente.ClienteCreate):
    # Generamos un ID simple para el nuevo cliente.
    # En una DB real, esto se haría automáticamente.
    new_id = len(fake_db) + 1
    new_client = cliente_data.dict()
    new_client["id"] = new_id
    
    # Agregamos el nuevo cliente a nuestra base de datos falsa.
    fake_db.append(new_client)
    
    return new_client

# 💡 GET: Obtiene todos los clientes
@router.get("/", response_model=List[cliente.Cliente])
def read_all_clientes():
    return fake_db

# 💡 GET: Obtiene un cliente por su ID
@router.get("/{cliente_id}", response_model=cliente.Cliente)
def read_cliente_by_id(cliente_id: int):
    # Buscamos el cliente en nuestra lista falsa.
    for client in fake_db:
        if client["id"] == cliente_id:
            return client
    # Si no lo encontramos, levantamos un error 404.
    raise HTTPException(status_code=404, detail="Cliente no encontrado")

# 💡 PUT: Actualiza un cliente existente por su ID
@router.put("/{cliente_id}", response_model=cliente.Cliente)
def update_cliente(cliente_id: int, cliente_data: cliente.ClienteUpdate):
    for index, client in enumerate(fake_db):
        if client["id"] == cliente_id:
            # Actualizamos los campos que se proporcionaron en la petición.
            for key, value in cliente_data.dict(exclude_unset=True).items():
                fake_db[index][key] = value
            return fake_db[index]
    # Si el cliente no existe, devolvemos un error.
    raise HTTPException(status_code=404, detail="Cliente no encontrado")

# 💡 DELETE: Elimina un cliente por su ID
@router.delete("/{cliente_id}", response_model=cliente.Cliente)
def delete_cliente(cliente_id: int):
    for index, client in enumerate(fake_db):
        if client["id"] == cliente_id:
            # Elimina el cliente de la lista y lo retorna.
            deleted_client = fake_db.pop(index)
            return deleted_client
    # Si el cliente no existe, devolvemos un error.
    raise HTTPException(status_code=404, detail="Cliente no encontrado")