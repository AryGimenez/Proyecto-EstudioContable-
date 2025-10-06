// frontend/flutter_gestion_contable/lib/screens/main_website/main_handler.dart

import 'package:flutter/material.dart';
import 'package:flutter_gestion_contable/core/theme/app_colors.dart';
import 'package:flutter_gestion_contable/services/api_service.dart';
import 'package:flutter_gestion_contable/screens/login/login_handler.dart';
import '../clients/clients_screen.dart';
import '../add_clients/add_clients.dart';
import '../payments/payments_screen.dart';
import '../deposits/deposits_screen.dart';
import 'notification_modal.dart';
import 'package:provider/provider.dart'; // Importa el paquete aquí
import '../clients/clients_handler.dart'; // Importa el ClientsHandler también


/// Widget principal que gestiona el estado y la navegación del sitio principal.
///
/// Este [StatefulWidget] implementa la estructura de la aplicación (barra lateral
/// y área de contenido) y maneja:
/// 1. El contenido ([_currentChild]) y título actual de la vista.
/// 2. La selección visual del menú lateral.
/// 3. La lógica de cierre de sesión (`_logout`).
/// 4. La inyección de dependencias (e.g., [ApiService]) a las sub-vistas
///    mediante [ChangeNotifierProvider] (como en el caso de 'Clientes').
class MainHandler extends StatefulWidget {
  const MainHandler({super.key}); // Constructor de la clase.
  
  
  @override
  _MainHandlerState createState() => _MainHandlerState(); // Crea el estado del widget.
}

/// Estado del widget [MainHandler].
///
/// Maneja el estado y la lógica del widget [MainHandler].
class _MainHandlerState extends State<MainHandler> {
  Widget _currentChild = const Center(child: Text('Bienvenido a la aplicación')); // Widget por defecto.
  String _currentTitle = 'Bienvenido'; // Título por defecto.
  Map<String, bool> _selectedMenuItem = { // Mapa para almacenar la selección de los botones.
    'Clientes': false, // Botón 'Clientes' no seleccionado por defecto.
    'Agregar Cliente': false, // Botón 'Agregar Cliente' no seleccionado por defecto.
    'Pagos': false, // Botón 'Pagos' no seleccionado por defecto.
    'Depósito': false, // Botón 'Depósito' no seleccionado por defecto.
    'Salir': false, // Botón 'Salir' no seleccionado por defecto.
  };

  final ApiService _apiService = ApiService();   // Instancia de la clase ApiService.

  /// Método para cambiar el contenido y el título de la pantalla.
  /// * Recibe un widget [newContent], un título [title] y un ítem de menú [menuItem].
  /// * Actualiza el estado del widget con el nuevo contenido, título y selección del ítem.
  void _changeContent(Widget newContent, String title, String menuItem) {
    setState(() {
      _currentChild = newContent;  // Actualiza el widget por defecto.
      _currentTitle = title; // Actualiza el título por defecto.
      _updateButtonSelection(menuItem); // Actualiza la selección del ítem.
    });
  }
  /// Método para actualizar la selección de los botones del menú.
  /// * Recibe un ítem de menú [selectedItem].
  /// * Actualiza el mapa [_selectedMenuItem] para marcar el ítem como seleccionado.
  void _updateButtonSelection(String selectedItem) { 
    _selectedMenuItem.updateAll((key, value) => false); // Deselecciona todos los ítems.
    _selectedMenuItem[selectedItem] = true; // Marca el ítem seleccionado.
  }
  /// Método para cerrar sesión.
  /// * Llama al método `logout` de la clase `ApiService`.
  /// * Navega a la pantalla de login y elimina el historial de navegación. 
  void _logout() async {
    await _apiService.logout(); // Llama al método logout de la clase ApiService.
    
    if (mounted) { // Verifica si el widget está montado.
      Navigator.of(context).pushAndRemoveUntil( // Navega a la pantalla de login y elimina el historial de navegación.
        MaterialPageRoute(builder: (context) => const LoginHandler()), // Ruta de la pantalla de login.
        (Route<dynamic> route) => false, // Elimina el historial de navegación.
      );
    }
  }

  /// Método para construir el widget.
  /// * Muestra la barra de aplicación y el área de contenido.
  @override
  Widget build(BuildContext context) {
    return Scaffold( // Devuelve un widget Scaffold.
      body: Column( // Columna para organizar los widgets.
        children: [ // Widgets hijos de la columna.
          Container( // Container para la barra de aplicación.
            height: 60, // Altura de la barra de aplicación.
            color: AppColors.primary, // Color de la barra de aplicación.
            padding: const EdgeInsets.symmetric(horizontal: 20), // Padding horizontal.
            child: Row( // Fila para organizar los widgets.
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espacio entre los widgets.
              children: [ // Widgets hijos de la fila.
                Text( // Texto para mostrar el título.
                  _currentTitle, // Título actual.
                  style: const TextStyle( // Estilo del texto.
                      color: Colors.white, // Color blanco.
                      fontSize: 20, // Tamaño de fuente.
                      fontWeight: FontWeight.bold), // Peso de la fuente.
                ),
                Row( // Fila para organizar los widgets.
                  children: [ // Widgets hijos de la fila.
                    ElevatedButton.icon( // Botón de notificaciones.
                      onPressed: () { // Llama al método para mostrar el modal de notificaciones.
                        showDialog( // Muestra el modal de notificaciones.
                          context: context, // Contexto de la pantalla.
                          builder: (context) => NotificationModal(), // Modal de notificaciones.
                        );
                      },
                      style: ElevatedButton.styleFrom( // Estilo del botón.
                        backgroundColor: const Color(0xFF792D1F), // Color de fondo.
                        padding: EdgeInsets.zero, // Padding cero.
                        minimumSize: const Size(120, 40), // Tamaño mínimo.
                        shape: RoundedRectangleBorder( // Forma redondeada.
                          borderRadius: BorderRadius.circular(8), // Radio de borde.
                        ),
                      ),
                      icon: const Icon(Icons.notifications, color: Colors.white), // Icono de notificaciones.
                      label: const SizedBox.shrink(), // Sin espacio adicional.
                    ),
                    const SizedBox(width: 10), // Espacio entre el botón de notificaciones y el botón de menú.
                    IconButton( // Botón de menú.
                      icon: const Icon(Icons.menu, color: Colors.white), // Icono de menú.
                      onPressed: () {}, // Llama al método para mostrar el modal de menú.
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded( // Área de contenido.
            child: Row( // Fila para organizar los widgets.
              children: [ // Widgets hijos de la fila.
                Container( // Container para el menú lateral.
                  width: 250, // Ancho del menú lateral.
                  color: AppColors.primary, // Color de fondo del menú lateral.
                  child: Column( // Columna para organizar los widgets.
                    children: [ // Widgets hijos de la columna.
                      const SizedBox(height: 20), // Espacio entre el avatar y los ítems del menú.
                      const CircleAvatar( // Avatar del usuario.
                        radius: 40, // Radio del avatar.
                        backgroundColor: Colors.white, // Color de fondo del avatar.
                        child: Icon(Icons.person, size: 40, color: Colors.brown), // Icono de persona.
                      ),
                      const SizedBox(height: 10), // Espacio entre el avatar y el nombre del usuario.
                      const Text('Lorena Giménez', // Nombre del usuario.
                          style: TextStyle(color: Colors.white, fontSize: 18)), // Estilo del texto.
                      const SizedBox(height: 20), // Espacio entre el nombre del usuario y los ítems del menú.
                      _buildMenuButton('Clientes', Icons.people, onPressed: () { // Botón para acceder a la lista de clientes.
                        _changeContent( // Cambia el contenido de la pantalla.
                          ChangeNotifierProvider( // Provider para ClientsHandler.
                            create: (context) => ClientsHandler(_apiService), // Crea una instancia de ClientsHandler.
                            child: const ClientsScreen(), // Pantalla para mostrar la lista de clientes.
                          ),
                          'Clientes', // Título para la lista de clientes.
                          'Clientes', // Subtítulo para la lista de clientes.
                        );
                      }),
                      _buildMenuButton( // Botón para agregar un cliente.
                        'Agregar Cliente', // Título para agregar un cliente.
                        Icons.person_add, // Icono para agregar un cliente.
                        onPressed: () { // Llama al método para agregar un cliente.
                          _changeContent( // Cambia el contenido de la pantalla.
                            AgregarClientesContent(), // Pantalla para agregar un cliente.
                            'Agregar Cliente', // Título para agregar un cliente.
                            'Agregar Cliente', // Subtítulo para agregar un cliente.
                          );
                        }),
                      _buildMenuButton( // Botón para acceder a la lista de pagos.
                        'Pagos', // Título para la lista de pagos.
                        Icons.payment, // Icono para la lista de pagos.
                        onPressed: () {
                          _changeContent( // Cambia el contenido de la pantalla.
                            ChangeNotifierProvider( // Provider para PaymentsHandler.
                              create: (context) => PaymentsHandler(_apiService), // Crea una instancia de PaymentsHandler.
                              child: const PaymentsScreen(), // Pantalla para mostrar la lista de pagos.
                            ),
                            'Pagos', // Título para la lista de pagos.
                            'Pagos', // Subtítulo para la lista de pagos.
                          );
                        }),
                      _buildMenuButton( // Botón para acceder al depósito.
                        'Depósito', // Título para el depósito.
                        Icons.account_balance, // Icono para el depósito.
                        onPressed: () {
                          _changeContent( // Cambia el contenido de la pantalla.
                            DepositsScreen(), // Pantalla para mostrar el depósito.
                            'Depósito', // Título para el depósito.
                            'Depósito', // Subtítulo para el depósito.
                          );
                        }),
                      const Spacer(),
                      _buildMenuButton( // Botón para cerrar sesión.
                        'Salir', // Título para cerrar sesión.
                        Icons.exit_to_app,  // Icono para cerrar sesión.
                        isExit: true, // Indica que es un botón de cerrar sesión.
                        onPressed: _logout // Llama al método para cerrar sesión.
                      ),
                    ],
                  ),
                ),
                Expanded( // Expanded para ocupar el espacio restante.
                  child: Container( // Container para el contenido principal.
                    padding: const EdgeInsets.all(16), // Espacio alrededor del contenido.
                    child: _currentChild, // Contenido actual.
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Widget para construir los botones de navegación del menú de la barra lateral.
  ///
  /// Este método aplica estilos condicionales basados en el estado de la aplicación:
  /// 1. El color de fondo es blanco si el botón está **seleccionado** (`_selectedMenuItem[title] == true`).
  /// 2. El botón "Salir" (`isExit: true`) usa un color de fondo especial (`0xFF792D1F`) y color de texto/ícono blanco.
  /// 3. Los botones no seleccionados usan `Colors.amber[200]` como color de fondo.
  ///
  /// @param title El texto que se mostrará como etiqueta del botón.
  /// @param icon El ícono que se mostrará junto a la etiqueta.
  /// @param isExit Flag booleano para aplicar estilos de botón de salida/cierre de sesión (rojo oscuro y blanco).
  /// @param onPressed La función de callback que se ejecuta al presionar el botón (generalmente, [_changeContent] o [_logout]).
  /// @returns Un [Padding] que contiene un [ElevatedButton.icon] con el estilo y la acción definidos.
  Widget _buildMenuButton(String title, IconData icon,
      {bool isExit = false, required VoidCallback onPressed}) {
    return Padding( // Padding para agregar espacio alrededor del botón.
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10), // Espacio vertical y horizontal.
      child: SizedBox( // SizedBox para limitar el ancho del botón.
        width: double.infinity, // Ancho máximo para el botón.
        child: ElevatedButton.icon( // Botón con ícono y texto.
          style: ElevatedButton.styleFrom(// Estilo del botón.
            backgroundColor: _selectedMenuItem[title] == true // Si el botón está seleccionado, usa blanco.
                ? Colors.white // Color de fondo blanco.
                : (isExit   
                    ? const Color(0xFF792D1F) // Si es salir, usa color rojo oscuro.
                    : Colors.amber[200]), // Si no está seleccionado y no es salir, usa amarillo.
            foregroundColor: Colors.black, // Color de texto/ícono negro.
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12), // Espacio interno del botón.
            shape: // Forma del botón.
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Bordes redondeados.
          ),
          onPressed: onPressed,// Llama al callback recibido del handler.
          icon: Icon(icon, color: isExit ? Colors.white : AppColors.primary), // Color del ícono basado en si es salir o no.
          label: Text(title, // Texto del botón.
              style: TextStyle(color: isExit ? Colors.white : AppColors.primary)), // Color del texto basado en si es salir o no.
        ),
      ),
    );
  }
}