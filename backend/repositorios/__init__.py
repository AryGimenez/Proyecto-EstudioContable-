# backend/repositorios/__init__.py

# Archivo encargado de importar todos los repositorios para facilitar su acceso desde otras partes de la aplicación.

from .clientes_repository import ClienteRepository
from .usuario_repository import UsuarioRepository
from .impuesto_repository import ImpuestoRepository
from .pago_repository import PagoRepository
from .deposito_repository import DepositoRepository
from .nombre_impuesto_repository import NombreImpuestoRepository
from .cheques_repository import ChequeRepository