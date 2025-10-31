# backend/services/whatsapp_service.py

import re # Importa el módulo de expresiones regulares para la limpieza de texto

def clean_phone_number(phone_number: str) -> str: # Función para normalizar el número de teléfono
    """Elimina caracteres no numéricos y asegura el formato internacional.""" # Docstring que describe el propósito
    # 1. Elimina todo lo que no sea un digito
    cleaned_number = re.sub(r'\D', '', phone_number) # Usa regex para remover guiones, espacios, paréntesis, etc.

    # 2. Asegura que tenga el codigo de pais (Ej: '598' para Uruguay)
    #    Ajusta esta logica segun tu pais de operacion principal

    if not cleaned_number.startswith('598'): # Comprueba si el número ya tiene el prefijo de país (asumiendo '598')
        # Si tienes clientes de varios países, esta lógica debe ser más robusta,
        # quizás prefijando con el código de país si el número es local.
        pass # La lógica actual no agrega el prefijo si falta, solo verifica
    
    return cleaned_number # Retorna el número de teléfono limpio

def send_whatsapp_alert(phone_number: str, message: str) -> bool: # Función principal para simular el envío de alerta
    # --- PASO CLAVE: LIMPIAR EL NÚMERO ANTES DE USARLO ---
    # En una implementación real, la API de WhatsApp exige un número limpio.
    numero_limpio = clean_phone_number(phone_number) # Llama a la función de limpieza

    # --- SIMULACIÓN DE ENVÍO ---
    # Aquí iría el código real para interactuar con la API de WhatsApp (Twilio, 360dialog, Meta API, etc.)
    print(f"Enviando WhatsApp a {numero_limpio}") # Imprime el número limpio
    print(message) # Imprime el mensaje a enviar
    
    # En una implementación real, se devolvería True solo si la API de WhatsApp confirma el envío exitoso.
    return True # Retorna True para simular el éxito del envío