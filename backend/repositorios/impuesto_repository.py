# backend/repositorios/impuesto_repository.py

from sqlalchemy.orm import Session, joinedload
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from typing import List, Optional
from decimal import Decimal

from ..models.impuesto import Impuesto
from ..models.cliente import Cliente
from ..schemas.impuesto import ImpuestoCreate, ImpuestoUpdate
from ..models.nombre_impuesto import NombreImpuesto

class ImpuestoRepository:
    """
    Clase de repositorio que maneja las operaciones CRUD para el modelo Impuesto.
    Implementa la lógica de cálculo de honorarios (20%) y la actualización automática 
    del saldo (Cli_Saldo) del cliente, ya que un impuesto representa una DEUDA.
    """
    HONORARIO_RATE = Decimal("0.20")

    def __init__(self, db: Session):
        """Inicializa el repositorio con la sesión de base de datos."""
        self.db = db

    def _calculate_total_adeudado(self, monto: Decimal) -> Decimal:
        """
        Calcula el total adeudado (Monto + Honorario).
        
        CORRECCIÓN: Corregir el nombre de la variable de 'mondo' a 'monto'.
        """
        honorario = monto * self.HONORARIO_RATE
        return monto + honorario

    def _adjust_client_balance(self, cli_id: int, total_amount_difference: Decimal):
        """
        Método privado para ajustar el saldo del cliente.
        
        Args:
            cli_id (int): ID del cliente.
            total_amount_difference (Decimal): Cantidad a SUMAR al Cli_Saldo. 
                                               Positivo = Saldo aumenta (menos deuda). 
                                               Negativo = Saldo disminuye (más deuda).
                                               
        Raises:
            ValueError: Si el cliente con el ID proporcionado no existe.
        """
        if total_amount_difference == Decimal(0): # Aseguramos comparación con Decimal
            return
        
        # CORRECCIÓN: Usar la sintaxis moderna para consistencia y seguridad, aunque .query funciona.
        cliente = self.db.execute(
            select(Cliente) 
            .filter(Cliente.Cli_ID == cli_id)
        ).scalars().first()

        if not cliente:
            raise ValueError(f"Cliente con ID {cli_id} no encontrado para ajustar saldo")
        
        # Se suma la diferencia (que puede ser positiva o negativa)
        cliente.Cli_Saldo += total_amount_difference
        self.db.add(cliente)
        # El commit se realiza en la función principal (create, update, delete)


# ----------------------------------------------------------------------
# MÉTODOS DE LECTURA (GET)
# ----------------------------------------------------------------------

    def get_by_id(self, impuesto_id: int) -> Optional[Impuesto]:
        """
        Obtiene un impuesto por su ID, cargando eager loading el NombreImpuesto.
        """
        return (
            self.db.query(Impuesto)
            .options(joinedload(Impuesto.nombre_impuesto))
            .filter(Impuesto.Imp_ID == impuesto_id)
            .first()
        )

    def get_all(self, skip: int = 0, limit: int = 100) -> List[Impuesto]:
        """
        Obtiene todos los impuestos, con paginación y cargando eager loading el NombreImpuesto.
        """
        return (
            self.db.query(Impuesto)
            .options(joinedload(Impuesto.nombre_impuesto))
            .offset(skip)
            .limit(limit)
            .all()
        )

# ----------------------------------------------------------------------
# MÉTODO DE CREACIÓN (CREATE)
# ----------------------------------------------------------------------

    def create(self, impuesto_data:ImpuestoCreate) -> Impuesto:
        """
        Crea un nuevo impuesto, calcula honorarios y RESTA el total adeudado al saldo del cliente.

        Flujo Transaccional:
        1. Valida el Cliente y NombreImpuesto.
        2. Calcula Imp_Honorario y Total Adeudado.
        3. Resta el Total Adeudado al Cli_Saldo (aumenta la deuda).
        4. Inserta el registro de impuesto.

        Raises:
            ValueError: Si el Cliente o NombreImpuesto no existe.
        """
        # Validar Cliente
        cliente = self.db.execute(
            select(Cliente).filter(Cliente.Cli_ID == impuesto_data.Cli_ID)
        ).scalars().first()
        
        if not cliente:
            raise ValueError(f"Cliente con ID {impuesto_data.Cli_ID} no encontrado.")
            
        # Validar NombreImpuesto (se asume que si el NomIm_ID no es None, debe existir)
        if impuesto_data.NomIm_ID is not None:
             if not self.db.query(NombreImpuesto).filter(NombreImpuesto.NomIm_ID == impuesto_data.NomIm_ID).first():
                 raise ValueError(f"Nombre de Impuesto con ID {impuesto_data.NomIm_ID} no encontrado.")
        
        # 1. Cálculos
        monto_decimal = Decimal(str(impuesto_data.Imp_Monto))
        imp_honorario = monto_decimal * self.HONORARIO_RATE
        total_adeudado = monto_decimal + imp_honorario

        # 2. Creación del objeto Impuesto
        db_impuesto = Impuesto(**impuesto_data.dict(exclude={'Imp_Monto'}),
                               Imp_Monto=monto_decimal,
                               Imp_Honorario=imp_honorario)
        self.db.add(db_impuesto)

        try:
            # 3. Ajuste de saldo: RESTA el total adeudado (diferencia negativa)
            self._adjust_client_balance(cliente.Cli_ID, -total_adeudado)

            self.db.commit()
            self.db.refresh(db_impuesto)
            self.db.refresh(cliente) # Opcional, pero bueno para depuración
        except ValueError as e:
            self.db.rollback()
            raise e
        except IntegrityError as e:
            self.db.rollback()
            raise IntegrityError(f"Error al crear el impuesto (Integrity Error). Detalles: {e}", params=None, orig=None)

        # Retorna el Impuesto cargado con la relacion
        return self.get_by_id(db_impuesto.Imp_ID)

# ----------------------------------------------------------------------
# MÉTODO DE ACTUALIZACIÓN (UPDATE)
# ----------------------------------------------------------------------

    def update(self, impuesto_id: int, impuesto_update: ImpuestoUpdate) -> Optional[Impuesto]:
        """
        Actualiza un impuesto, recalcula el total adeudado y aplica la diferencia al saldo del cliente.
        
        Flujo Transaccional:
        1. Recalcula el viejo Total Adeudado.
        2. Aplica los cambios al objeto DB.
        3. Recalcula el nuevo Total Adeudado.
        4. Si el cliente no cambia, ajusta la diferencia: `(TotalViejo - TotalNuevo)` se suma al saldo.
        5. Si el cliente cambia, revierte la deuda vieja (`+TotalViejo`) y aplica la nueva deuda (`-TotalNuevo`).
        """
        db_impuesto = self.get_by_id(impuesto_id)
        if not db_impuesto:
            return None
        
        update_data = impuesto_update.dict(exclude_unset=True)

        # Guardar valores antiguos para el ajuste diferencial
        old_monto_decimal = Decimal(str(db_impuesto.Imp_Monto))
        old_cli_id = db_impuesto.Cli_ID
        old_total_adeudado = self._calculate_total_adeudado(old_monto_decimal)

        # 2. Aplicar los datos de actualizacion al objeto DB_IMPUESTO
        for key, value in update_data.items():
            # Si el valor es Imp_Monto, convertir a Decimal
            if key == 'Imp_Monto' and value is not None:
                setattr(db_impuesto, key, Decimal(str(value)))
            else:
                setattr(db_impuesto, key, value)

        # 3. Recalcular el total adeudado con los nuevos datos
        # CORRECCIÓN: Usar el valor que ya está en db_impuesto (que ya es Decimal) o el del update.
        # Ya que se asignó en el paso 2, usamos el de db_impuesto.
        new_monto_decimal = db_impuesto.Imp_Monto
        
        # Recalcular Honorario y Total Adeudado
        new_imp_honorario = new_monto_decimal * self.HONORARIO_RATE
        db_impuesto.Imp_Honorario = new_imp_honorario
        new_total_adeudado = self._calculate_total_adeudado(new_monto_decimal)

        new_cli_id = db_impuesto.Cli_ID

        try:
            # 4. Lógica de Ajuste del Saldo

            if old_cli_id == new_cli_id:
                # 4a. MISMO Cliente: Ajuste diferencial
                # Diferencia: (Viejo Total - Nuevo Total). 
                # Si Viejo > Nuevo, la diferencia es positiva -> SUMA al saldo (menos deuda).
                balance_difference = old_total_adeudado - new_total_adeudado
                self._adjust_client_balance(old_cli_id, balance_difference)

            else:
                # 4b. CAMBIO DE CLIENTE: Revertir del viejo y aplicar al nuevo

                # Revertir la deuda del cliente anterior (sumar el Total Adeudado viejo)
                self._adjust_client_balance(old_cli_id, old_total_adeudado)

                # Aplicar la nueva deuda al nuevo cliente (restar el Total Adeudado nuevo)
                self._adjust_client_balance(new_cli_id, -new_total_adeudado)

            # 5. Commit y retorno
            self.db.add(db_impuesto)
            self.db.commit()
            return self.get_by_id(db_impuesto.Imp_ID)
            
        except ValueError as e:
            self.db.rollback()
            raise e


# ----------------------------------------------------------------------
# MÉTODO DE ELIMINACIÓN (DELETE)
# ----------------------------------------------------------------------

    def delete(self, impuesto_id: int) -> Optional[Impuesto]:
        """
        Elimina un impuesto y revierte la deuda al saldo del cliente.
        
        Flujo: El Total Adeudado se SUMA al saldo del cliente para anular la deuda creada.
        
        Raises:
            ValueError: Si el cliente asociado no existe para revertir el saldo.
        """
        db_impuesto = self.get_by_id(impuesto_id)
        if not db_impuesto:
            return None
        
        monto_decimal = Decimal(str(db_impuesto.Imp_Monto))
        total_adeudado = self._calculate_total_adeudado(monto_decimal)

        try:
            # Ajuste de Saldo (Suma el total adeudado, revierte la deuda)
            self._adjust_client_balance(db_impuesto.Cli_ID, total_adeudado)
            
            # Eliminación
            impuesto_eliminado = db_impuesto
            self.db.delete(db_impuesto)
            self.db.commit()
            return impuesto_eliminado
        except ValueError as e:
            self.db.rollback()
            raise e