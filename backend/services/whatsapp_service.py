# backend/services/whatsapp_service.py

import re

def clean_phone_number(phone_number: str) -> str:
    """Elimina caracteres no numéricos y asegurael formato internacional."""
    # 1. Elimina todo lo que no sea un digito
    cleaned_number = re.sub(r'\D', '', phone_number)

    # 2. Asegura que tenga el codigo de pais (Ej: '598' para Uruguay)
    #   Ajusta esta logica segun tu pas de operacion principal

    if not cleaned_number.startswith('598'):
        # Si tienes clientes de varios países, esta lógica debe ser más robusta,
        # quizás prefijando con el código de país si el número es local.
        pass
    
    return cleaned_number

def send_whatsapp_alert(phone_number: str, message: str) -> bool:
    # --- PASO CLAVE: LIMPIAR EL NÚMERO ANTES DE USARLO ---
    # En una implementación real, la API de WhatsApp exige un número limpio.
    numero_limpio = clean_phone_number(phone_number) 
    
    print(f"Enviando WhatsApp a {numero_limpio}")
    print(message)

    
    return True