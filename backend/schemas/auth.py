from pydantic import BaseModel, EmailStr, validator

class UserLogin(BaseModel):
    username: str
    password: str

class PasswordResetRequestSchema(BaseModel):
    email: EmailStr

class VerifyCodeSchema(BaseModel):
    email: EmailStr
    verification_code: str

class PasswordResetConfirm(BaseModel):
    email: EmailStr
    verification_code: str
    new_password: str
    confirm_new_password: str

    @validator('confirm_new_password')
    def passwords_match(cls, value, values):
        if 'new_password' in values and value != values['new_password']:
            raise ValueError('Las nuevas contraseñas no coinciden.')
        return value