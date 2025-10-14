# backend/schemas/cheques.py

from pydantic import BaseModel, Field, condecimal # Importaciones Pydantic y condecimal para precisión
from datetime import date # Importación para manejo de fechas
from typing import Optional, List # Importaciones para campos opcionales y listas

# --- Esquemas Anidados para Relaciones ---

class NombreImpuestoBase(BaseModel): # Clase para estructurar la respuesta del nombre de impuesto asociado
    """Esquema base para el nombre de impuesto relacionado""" # Documentación principal de la clase
    NomIm_ID: int = Field(..., description="ID del nombre de impuesto.") # ID única del tipo de impuesto
    NomIm_Txt: str = Field(..., description="Nombre descriptivo del impuesto.") # Texto descriptivo del impuesto
    
    class Config: # Clase para la configuración del esquema
        orm_mode = True # Permite mapear campos desde el modelo ORM

# --- Esquemas de Cheque ---

class ChequeBase(BaseModel): # Clase BaseModel para las clases Create y Update (campos base)
    """Campos comunes para la creación y actualización""" # Documentación principal de la clase
    Cli_ID: int = Field(..., description="ID del cliente asociado.") # Clave foránea al cliente
    NomIm_ID: Optional[int] = Field(None, description="ID del nombre del impuesto (ej: 1 para IVA).") # Clave foránea al impuesto, opcional
    Cheq_Numero: str = Field(..., max_length=50, description="Número de referencia del cheque.") # Número único de identificación del cheque
    Cheq_Monto: condecimal(max_digits=10, decimal_places=2) = Field(..., description="Monto del cheque.") # Monto monetario, con precisión decimal obligatoria
    Cheq_FechaEmision: date = Field(..., description="Fecha de emisión del cheque.") # Fecha en que se creó el cheque
    Cheq_FechaVencimiento: date = Field(..., description="Fecha de vencimiento del cheque.") # Fecha límite para el depósito o cobro
    Cheq_Estado: Optional[str] = Field("Pendiente", max_length=50, description="Estado actual del cheque.") # Estado del cheque (por defecto "Pendiente")
    
    class Config: # Clase para la configuración del esquema
        orm_mode = True # Permite leer desde el modelo ORM

class ChequeCreate(ChequeBase): # Clase para la creación de un nuevo cheque (POST)
    """Esquema usado para crear un nuevo cheque (POST)""" # Documentación principal de la clase
    pass # Hereda todos los campos de ChequeBase como obligatorios para la creación

class ChequeUpdate(BaseModel): # Clase para la actualización parcial de un cheque (PUT/PATCH)
    """Esquema usado para actualizar un cheque (PUT) - Campos opcionales""" # Documentación principal de la clase
    Cli_ID: Optional[int] = Field(None, description="ID del cliente asociado (Opcional).") # Opcional para actualizar la clave foránea del cliente
    NomIm_ID: Optional[int] = Field(None, description="ID del nombre del impuesto (Opcional).") # Opcional para actualizar la clave foránea del impuesto
    Cheq_Numero: Optional[str] = Field(None, max_length=50, description="Número de referencia del cheque (Opcional).") # Opcional para actualizar el número
    Cheq_Monto: Optional[condecimal(max_digits=10, decimal_places=2)] = Field(None, description="Monto del cheque (Opcional).") # Opcional para actualizar el monto
    Cheq_FechaEmision: Optional[date] = Field(None, description="Fecha de emisión (Opcional).") # Opcional para actualizar la fecha de emisión
    Cheq_FechaVencimiento: Optional[date] = Field(None, description="Fecha de vencimiento (Opcional).") # Opcional para actualizar la fecha de vencimiento
    Cheq_Estado: Optional[str] = Field(None, max_length=50, description="Estado actual del cheque (Opcional).") # Opcional para actualizar el estado

    class Config: # Clase para la configuración del esquema
        orm_mode = True # Permite leer desde el modelo ORM

class Cheque(ChequeBase): # Clase encargada de lo que retorna al cliente (respuesta)
    """Esquema de respuesta (incluye ID y campo computado)""" # Documentación principal de la clase
    Cheq_ID: int = Field(..., description="ID único del cheque.") # Retorna el ID único del registro del cheque
    
    # Campo computado del modelo (Propiedad @property)
    Cheq_NomImpuesto: Optional[str] = Field(None, description="Nombre del impuesto asociado, obtenido de un campo computado en el modelo ORM.") # Nombre del impuesto, calculado o mapeado
    
    # Opcional: Incluir la relación completa
    nombre_impuesto: Optional[NombreImpuestoBase] = Field(None, description="Objeto de relación que incluye el ID y nombre del impuesto.") # Objeto anidado del Nombre de Impuesto