# backend/repositorios/__init__.py

# Archivo encargado de importar todos los repositorios para facilitar su acceso desde otras partes de la aplicación.

from .clientes_repository import ClienteRepository # Importacion del repositorio de Cliente
from .usuario_repository import UsuarioRepository # Importacion del repositorio de Usuario
from .impuesto_repository import ImpuestoRepository # Importacion del repositorio de Impuesto
from .pago_repository import PagoRepository # Imporaction del repositorio de Pago
from .deposito_repository import DepositoRepository # Importacion del repositorio de Deposito
from .nombre_impuesto_repository import NombreImpuestoRepository # Importacion del repositorio de NombreImpuesto
from .cheques_repository import ChequeRepository # Importacion del repositorio de Cheques