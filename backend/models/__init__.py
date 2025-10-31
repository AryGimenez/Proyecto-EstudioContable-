# backend/models/__init__.py

# Archivo encargado de importar todos los modelos para facilitar su acceso desde otras partes de la aplicación.

from .user import Usuario # Importacion del modelo de Usuario
from .cliente import Cliente # Importacion del modelo de Cliente
from .impuesto import Impuesto # Importacion del modelo de Impuesto
from .pago import Pago # Importacion del modelo de Pago
from .deposito import Deposito # Importacion del modelo de Deposito
from .nombre_impuesto import NombreImpuesto # Importacion del modelo de NombreImpuesto
from .cheque import Cheque # Importacion del modelo de Cheque