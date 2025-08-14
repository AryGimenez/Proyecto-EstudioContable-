import random
import string
from fastapi_mail import FastMail, MessageSchema, ConnectionConfig
from backend.config import MAIL_USERNAME, MAIL_PASSWORD, MAIL_SERVER, MAIL_PORT, MAIL_FROM

def generate_verification_code(length=6):
    characters = string.ascii_letters + string.digits
    return ''.join(random.choice(characters) for _ in range(length))

async def send_verification_email(email: str, verification_code: str):
    conf = ConnectionConfig(
        MAIL_USERNAME=MAIL_USERNAME,
        MAIL_PASSWORD=MAIL_PASSWORD,
        MAIL_SERVER=MAIL_SERVER,
        MAIL_PORT=MAIL_PORT,
        MAIL_FROM=MAIL_FROM,
        MAIL_TLS=True,
        MAIL_SSL=False,
        USE_CREDENTIALS=True,
        VALIDATE_CERTS=True
    )

    message = MessageSchema(
        subject="Tu Código de Verificación para Restablecer Contraseña",
        recipients=[email],
        body=f"""
            <p>Hola,</p>
            <p>Tu código de verificación para restablecer tu contraseña es: <strong>{verification_code}</strong></p>
            <p>Este código expirará en 15 minutos.</p>
            <p>Si no solicitaste este restablecimiento, puedes ignorar este correo.</p>
        """,
        subtype="html"
    )

    fm = FastMail(conf)
    await fm.send_message(message)