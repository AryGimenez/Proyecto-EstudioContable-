// frontend/flutter_gestion_contable/lib/services/api_service.dart

import 'package:flutter/material.dart';

import 'base_api.dart';
import 'modules/auth_module.dart';
import 'modules/clients_module.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Punto de entrada único para todos los servicios de la API.
/// 
/// Esta clase consolida la lógica base de red con los módulos específicos
/// del negocio mediante el uso de Mixins ([with]). 
/// 
/// Al heredar de [BaseApi], obtiene acceso a la configuración de red centralizada,
/// mientras que [AuthModule] y [ClientsModule] le proporcionan las funciones
/// específicas para manejar usuarios y clientes respectivamente.
/// 
/// Beneficios de esta estructura:
/// 1. **Mantenibilidad**: Si cambia la IP, solo tocas [BaseApi].
/// 2. **Modularidad**: Cada grupo de funciones (Clientes, Ventas, Auth) vive en su propio archivo.
/// 3. **Limpieza**: Evita tener un solo archivo de 3000 líneas de código.
class ApiService extends BaseApi with AuthModule, ClientsModule {
  
  /// URL base de la API.
  @override
  final String baseUrl;

  /// Instancia estática y privada que almacena la única referencia de la clase.
  /// 
  /// Este atributo es el corazón del patrón Singleton, asegurando que 
  /// el estado de la API (como los tokens y la URL base) se mantenga 
  /// idéntico en toda la ejecución de la aplicación.
  static final ApiService _instance = ApiService._internal();

  /// Constructor de tipo 'factory' que gestiona el acceso a la instancia.
  /// 
  /// En lugar de crear un nuevo objeto cada vez que se invoca, este constructor
  /// intercepta la llamada y devuelve la instancia única [_instance].
  /// Esto permite acceder a los servicios de la API desde cualquier parte del 
  /// código usando simplemente 'ApiService()'.
  factory ApiService() {
    return _instance;
  }

  /// Constructor privado y nombrado encargado de la inicialización interna.
  /// 
  /// Al ser privado, impide la creación de instancias externas accidentales.
  /// Aquí se define la [baseUrl] fija y se dispara la lógica de [_init] para 
  /// recuperar datos persistentes (como el token) al momento de arrancar el servicio.  
  ApiService._internal() : baseUrl = 'http://127.0.0.1:8000'{
    _init();
  }



  /// Inicializa el servicio cargando el token almacenado.
  Future<void> _init() async {
    token = await getToken();
  }

  /// Cierra la sesión del usuario de forma segura.
  /// 
  /// Este método realiza una limpieza en dos niveles:
  /// 1. **Persistencia**: Elimina el JWT del almacenamiento local del dispositivo
  ///    usando [SharedPreferences] para que no se recupere al reiniciar la app.
  /// 2. **Memoria**: Limpia la variable volatil [token] en la instancia actual 
  ///    de la API para invalidar peticiones inmediatas.
  /// 
  /// Al ser un proceso que escribe en el disco del teléfono, se marca como [async].
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance(); // Obtiene el acceso al sistema de archivos local (preferencias del dispositivo)
    await prefs.remove('jwt_token'); // Elimina el token almacenado
    token = null; // Resetea la variable en memoria de la clase BaseApi a null
  }
}