# backend/services/scheduler_service.py (MODIFICADO)

from datetime import date, timedelta, datetime
from ..models.impuesto import Impuesto
from ..models.cliente import Cliente
from ..models.nombre_impuesto import NombreImpuesto # Para acceder a NomIm_Txt
from ..schemas.notificacion import NotificationMessage
from ..models.notificacion import Notificacion

from .whatsapp_service import send_whatsapp_alert
from sqlalchemy.orm import joinedload # Para cargar relaciones
from ..dependencies import get_db
from sqlalchemy import text, func

def verificar_vencimientos_diarios():
    
    fecha_alerta = date.today() + timedelta(days=7)
    
    fecha_inicio_rango = datetime.combine(fecha_alerta, datetime.min.time())
    fecha_fin_rango = fecha_inicio_rango + timedelta(days=1)

    db = next(get_db())
    
    try:
        #  --- DIAGNÓSTICO CLAVE ---
        impuestos_a_alertar = (
            db.query(Impuesto)
            .options(joinedload(Impuesto.nombre_impuesto))
            .filter(func.date(Impuesto.Imp_Vencimiento) <= fecha_alerta)
            .filter(func.date(Impuesto.Imp_Vencimiento) > fecha_fin_rango)
            .all()
        )
        
        
        # -------------------------
        for impuesto in impuestos_a_alertar:
            cliente = db.query(Cliente).filter(Cliente.Cli_ID == impuesto.Cli_ID).first()

            if cliente:
                if isinstance(impuesto.Imp_Vencimiento, str):
                    fecha_vencimiento_obj = datetime.strptime(impuesto.Imp_Vencimiento, "%Y-%m-%d").date()
                else:
                    fecha_vencimiento_obj = impuesto.Imp_Vencimiento
            
           
            
            monto_total_adeudado = impuesto.Imp_Monto + impuesto.Imp_Honorario
            nombre_impuesto = impuesto.nombre_impuesto.NomIm_Txt if impuesto.nombre_impuesto else "Desconocido"
            
            mensaje = (f"""
            ¡Hola {cliente.Cli_Nom}! 🔔 Recordatorio:

            Tu impuesto *{nombre_impuesto}* vence en *7 días* el {fecha_vencimiento_obj.strftime('%d/%m/%Y')}.

            Monto total adeudado: {monto_total_adeudado: .2f} {impuesto.Imp_Moneda}.

            Saludos,
            Estudio Contable Barone
            """
            )
            
            if not cliente:
                print(f"Advertencia: Cliente con ID {impuesto.Cli_ID} no encontrado para el impuesto ID {impuesto.Imp_ID}")
                continue

            # Envía la alerta vía WhatsApp
            send_whatsapp_alert(cliente.Cli_Whatsapp, mensaje.strip())
            
            # Registra la notificación en la base de datos
            notificacion_web = NotificationMessage(
                type="vencimiento",
                message=mensaje,
                client_id=cliente.Cli_ID,
                tax_id=impuesto.Imp_ID,
                payment_id=None,
                date=datetime.now()
            )

            db_notificacion = Notificacion(
                Not_Type=notificacion_web.type,
                Not_Mensaje=notificacion_web.message,
                Cli_ID=notificacion_web.client_id,
                Imp_ID=notificacion_web.tax_id,
                Pago_ID=notificacion_web.payment_id,
                Not_FechaCreacion=notificacion_web.date
            )

            db.add(db_notificacion)
            db.commit()
            db.refresh(db_notificacion)


            print(f"NOTIFICACION CREADA: {db_notificacion.Not_ID} para cliente {db_notificacion.Cli_ID}")

    except Exception as e:
        print(f"ERROR CRÍTICO EN EL SCHEDULER: {e}")
        db.rollback() 
        
    finally:
        db.close()