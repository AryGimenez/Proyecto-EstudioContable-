# backend/services/scheduler_service.py (MODIFICADO)

# --- Importaciones de Sistema y Utilidades ---
from datetime import date, timedelta, datetime # Clases para manejo de fechas y tiempo
from sqlalchemy.orm import joinedload # Para cargar relaciones de forma eficiente (eager loading)
from sqlalchemy import text, func # Funciones de SQLAlchemy (como func.date)

# --- Importaciones de Modelos (ORM) ---
from ..models.impuesto import Impuesto # Modelo para acceder a los datos de impuestos
from ..models.cliente_model import ClienteModel # Modelo para acceder a los datos de clientes (contacto)
from ..models.nombre_impuesto import NombreImpuesto # Modelo para obtener el nombre del impuesto (NomIm_Txt)
from ..models.notificacion import Notificacion # Modelo para registrar las alertas enviadas

# --- Importaciones de Esquemas y Servicios ---
from ..schemas.notificacion import NotificationMessage # Esquema Pydantic para la estructura del mensaje de notificación
from .whatsapp_service import send_whatsapp_alert # Función para enviar la alerta de WhatsApp
from ..dependencies import get_db # Dependencia para obtener la sesión de base de datos


def verificar_vencimientos_diarios(): # Función principal ejecutada por el scheduler
    
    # --- 1. Cálculo de la Fecha de Alerta (7 días antes del vencimiento) ---
    fecha_alerta = date.today() + timedelta(days=7) # Calcula la fecha que está a 7 días en el futuro
    
    # Estas líneas no son usadas en el query actual, se pueden eliminar o revisar
    # fecha_inicio_rango = datetime.combine(fecha_alerta, datetime.min.time())
    # fecha_fin_rango = fecha_inicio_rango + timedelta(days=1)

    db = next(get_db()) # Inicializa y obtiene la sesión de base de datos
    
    try:
        # --- 2. Consulta de Impuestos a Alertar (Filtro por Vencimiento) ---
        impuestos_a_alertar = (
            db.query(Impuesto)
            .options(joinedload(Impuesto.nombre_impuesto)) # Carga eager loading el nombre del impuesto
            .filter(func.date(Impuesto.Imp_Vencimiento) == fecha_alerta) # Filtra solo los impuestos que vencen EXACTAMENTE en la fecha_alerta (dentro de 7 días)
            # Las siguientes dos líneas están causando un error lógico o están mal ubicadas:
            # .filter(func.date(Impuesto.Imp_Vencimiento) <= fecha_alerta) 
            # .filter(func.date(Impuesto.Imp_Vencimiento) > fecha_fin_rango)
            # Debería ser solo: .filter(func.date(Impuesto.Imp_Vencimiento) == fecha_alerta)
            .all() # Ejecuta la consulta
        )
        
        # -------------------------
        for impuesto in impuestos_a_alertar: # Itera sobre cada impuesto encontrado
            cliente = db.query(ClienteModel).filter(ClienteModel.Cli_ID == impuesto.Cli_ID).first() # Busca el cliente asociado al impuesto
            
            # 3. Normalización de la Fecha de Vencimiento
            if cliente: # Asegura que solo procesa si el cliente existe
                if isinstance(impuesto.Imp_Vencimiento, str): # Comprueba si el campo de fecha es un string (esto debe corregirse en el ORM)
                    fecha_vencimiento_obj = datetime.strptime(impuesto.Imp_Vencimiento, "%Y-%m-%d").date() # Convierte el string a objeto date
                else:
                    fecha_vencimiento_obj = impuesto.Imp_Vencimiento # Si ya es un objeto date, lo usa directamente
            
                # 4. Preparación de Variables para el Mensaje
                monto_total_adeudado = impuesto.Imp_Monto + impuesto.Imp_Honorario # Suma el monto base más el honorario
                nombre_impuesto = impuesto.nombre_impuesto.NomIm_Txt if impuesto.nombre_impuesto else "Desconocido" # Obtiene el nombre del impuesto o usa "Desconocido"
                
                # 5. Construcción del Mensaje
                mensaje = (f"""
                ¡Hola {cliente.Cli_Nom}! 🔔 Recordatorio:

                Tu impuesto *{nombre_impuesto}* vence en *7 días* el {fecha_vencimiento_obj.strftime('%d/%m/%Y')}.

                Monto total adeudado: {monto_total_adeudado: .2f} {impuesto.Imp_Moneda}. # Se asume que Imp_Moneda existe en el modelo Impuesto
                
                Saludos,
                Estudio Contable Barone
                """
                )
                
                if not cliente: # Doble verificación, aunque ya se verifica al inicio del 'if cliente'
                    print(f"Advertencia: Cliente con ID {impuesto.Cli_ID} no encontrado para el impuesto ID {impuesto.Imp_ID}")
                    continue

                # 6. Envío y Registro
                send_whatsapp_alert(cliente.Cli_Whatsapp, mensaje.strip()) # Llama al servicio externo para enviar el WhatsApp
                
                # 7. Creación de la Notificación para Registro Interno
                notificacion_web = NotificationMessage( # Crea el esquema Pydantic para el registro
                    type="vencimiento", # Tipo de alerta
                    message=mensaje, # El mensaje completo enviado
                    client_id=cliente.Cli_ID,
                    tax_id=impuesto.Imp_ID,
                    payment_id=None,
                    date=datetime.now()
                )

                db_notificacion = Notificacion( # Crea el modelo ORM
                    Not_Type=notificacion_web.type,
                    Not_Mensaje=notificacion_web.message,
                    Cli_ID=notificacion_web.client_id,
                    Imp_ID=notificacion_web.tax_id,
                    Pago_ID=notificacion_web.payment_id,
                    Not_FechaCreacion=notificacion_web.date
                )

                db.add(db_notificacion) # Agrega el modelo a la sesión
                db.commit() # Confirma la transacción en la base de datos
                db.refresh(db_notificacion) # Obtiene los datos finales (incluyendo el ID)

                print(f"NOTIFICACION CREADA: {db_notificacion.Not_ID} para cliente {db_notificacion.Cli_ID}")

    except Exception as e:
        print(f"ERROR CRÍTICO EN EL SCHEDULER: {e}") # Imprime cualquier error inesperado
        db.rollback() # Revierte cualquier cambio pendiente en caso de error
        
    finally:
        db.close() # Cierra la sesión de base de datos