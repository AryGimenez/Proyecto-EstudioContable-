# backend/servicios/servicio_contable.py

from sqlalchemy.orm import Session
from backend import models

class ServicioContable:
    def __init__(self, db: Session):
        self.db = db
        # Inicializa otros atributos necesarios

    def obtener_información_completa(self, cliente_id: int):
        # Lógica para obtener información completa del cliente
        cliente = self.db.query(models.Cliente).filter_by(id=cliente_id).first()
        if not cliente:
            return None
        
        pagos = self.db.query(models.Pago).filter_by(cliente_id=cliente_id).all()
        impuestos = self.db.query(models.Impuesto).filter_by(cliente_id=cliente_id).all()

        # Calcula el saldo total
        saldo_total = sum(pago.monto for pago in pagos) - sum(impuesto.monto for impuesto in impuestos)

        return {
            "cliente": cliente,
            "pagos": pagos,
            "impuestos": impuestos,
            "saldo_total": saldo_total
        }
