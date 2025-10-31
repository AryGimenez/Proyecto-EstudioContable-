// frontend/flutter_gestion_contable/lib/screens/deposits/deposits_screen.dart


import 'package:flutter/material.dart';
import 'package:flutter_gestion_contable/core/theme/app_colors.dart';
import 'deposits_handler.dart'; // Asegúrate de importar tu handler

/// Widget principal que construye y gestiona la interfaz de la pantalla de Depósitos.
///
/// Este [StatefulWidget] se enfoca exclusivamente en la presentación visual y la
/// interacción directa con los elementos de la interfaz de usuario (UI).
///
/// ### Rol y Arquitectura:
/// A diferencia de otros módulos (ej. Clients), esta pantalla **instancia
/// directamente** al [DepositsHandler] y utiliza [setState] para forzar
/// el redibujo de la UI ante cambios de estado (ej. selección de filas).
///
/// Esto significa que la [DepositsScreen] está fuertemente acoplada al Handler
/// y es responsable de llamar a [setState] cada vez que el estado del Handler
/// se modifica (ej. al marcar un Checkbox).
///
/// **Tareas Principales:**
/// - Renderizar la tabla de datos (`_buildDataTable`).
/// - Mostrar los totales de montos y cheques.
/// - Manejar las llamadas a los métodos de acción del Handler (Eliminar, Modificar).
class DepositsScreen extends StatefulWidget {
  const DepositsScreen({super.key}); // Constructor con key opcional

  // Método para crear el estado del widget
  @override
  _DepositsScreenState createState() => _DepositsScreenState();
}

/// Estado asociado a la [DepositsScreen]. 
///
/// Esta clase es la responsable de construir la interfaz gráfica (UI) y
/// de gestionar los cambios de estado local mediante [setState].
/// 
/// **Acoplamiento Directo (Punto a Documentar):**
/// - Instancia directamente al [DepositsHandler], lo que genera un acoplamiento
///   fuerte (ver documentación de refactorización pendiente).
/// - Debe ser notificada manualmente mediante [setState] para redibujar
///   los widgets cuando cambia una propiedad dentro del `_handler`.
/// 
/// **Contiene la definición de todos los widgets de la pantalla** (ej. la tabla,
/// la barra de filtro y los botones de acción).
class _DepositsScreenState extends State<DepositsScreen> {
  
  final DepositsHandler _handler = DepositsHandler(); // Instancia de DepositsHandler para manejar el estado

/// Construye el árbol de *widgets* de la pantalla de Depósitos.
///
/// Este método se llama cada vez que se requiere un redibujo (por ejemplo,
/// al llamar a [setState] o al actualizar el estado del Handler).
///
/// El diseño principal se organiza en un [Scaffold] con un [Column]
/// que apila los siguientes componentes visuales, cada uno encapsulado
/// en una función de construcción privada:
/// - Fila de filtros (`Checkbox` de Clientes y botón de búsqueda).
/// - Título de Impuestos (`_buildImpuestosPagarLine`).
/// - La tabla de datos y los totales (`_buildDataTableWithTotal`).
/// - La línea de Monto del Cheque (`_buildMontoDelChequeLine`).
/// - Las filas de botones de acción (`_buildActionButtonsRow` y `_buildActionButtonsRow2`).
///
/// @param context El contexto del *widget* en el árbol.
/// @returns Un [Scaffold] que contiene toda la estructura de la pantalla.
  @override
  Widget build(BuildContext context) {
    return Scaffold( // Estructura principal de la pantalla
      body: Padding( // Padding alrededor de todo el contenido
        padding: const EdgeInsets.all(0.0), // Espaciado alrededor del contenido
        child: Column( // Columna principal que contiene todos los elementos
          crossAxisAlignment: CrossAxisAlignment.start,// Alinea los hijos al inicio horizontalmente
          children: [ // Lista de widgets hijos
            Center( // Título centrado
              child: Text( // Título de la pantalla
                'Filtrar por', // Texto del título
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Estilo del texto
              ), // Fin del Text
            ), // Fin del Center
            Row( // Fila para los filtros y el botón de búsqueda
              children: [ // Lista de widgets en la fila
                Expanded( // Expande el widget hijo para ocupar el espacio disponible
                  child: Row( // Fila para el checkbox y el texto "Clientes"
                    children: [ // Lista de widgets en la fila
                      Checkbox( // Checkbox para seleccionar/deseleccionar "Clientes"
                        value: _handler.isClientsChecked, // Valor del checkbox basado en el estado del handler
                        onChanged: (bool? value) { // Callback cuando cambia el valor del checkbox
                          setState(() { // Llama a setState para redibujar la UI
                            _handler.toggleClientsChecked(value ?? false); // Llamamos al método del handler para cambiar el estado de "Clientes"
                          }); // Fin de setState
                        },// Fin de onChanged
                      ), // Fin del Checkbox
                      Icon(Icons.person), // Icono de persona junto al texto
                      SizedBox(width: 5), // Espacio entre el icono y el texto
                      Text('Clientes'), // Texto "Clientes"
                    ], // Fin de la lista de widgets en la fila
                  ),  // Fin del Row
                ), // Fin del Expanded
                SizedBox(width: 10),  // Espacio entre el filtro y el botón de búsqueda
                SizedBox( // Contenedor para el botón de búsqueda
                  width: 40, // Ancho fijo del botón
                  height: 80, // Alto fijo del botón
                  child: ElevatedButton( // Botón de búsqueda
                    onPressed: () {}, // Acción al presionar el botón (vacía por ahora)
                    style: ButtonStyle( // Estilo del botón
                      padding: MaterialStateProperty.all(EdgeInsets.zero), // Sin padding interno
                    ),  // Fin ButtonStyle
                    child: Icon(Icons.search, size: 24, color: Colors.white), // Icono de búsqueda dentro del botón
                  ), // Fin ElevatedButton
                ), //Fin SizedBox
              ],
            ),
            SizedBox(height: 5), // Espacio vertical entre la fila de filtros y el título de impuestos
            _buildImpuestosPagarLine(), // Línea para "Impuestos a Pagar"
            SizedBox(height: 10), // Espacio vertical entre el título de impuestos y la tabla
            _buildDataTableWithTotal(), // Función para mostrar la tabla con los totales
            SizedBox(height: 10), // Espacio vertical entre la tabla y el monto del cheque
            _buildMontoDelChequeLine(), // Línea para mostrar el monto del cheque
            SizedBox(height: 10), // Espacio vertical entre el monto del cheque y los botones de acción
            _buildActionButtonsRow(), // Fila con botones de acción: Eliminar y Modificar
            SizedBox(height: 10), // Espacio vertical entre los botones de acción y la línea horizontal
            _buildHorizontalLine(), // Línea horizontal de separación
            SizedBox(height: 10), // Espacio vertical entre la línea horizontal y los botones de acción inferiores
            _buildActionButtonsRow2(), // Fila con botones de acción: Agregar Nuevo y Cancelar
          ],
        ),
      ),
    );
  }

/// Construye el COMPONENTE VISUAL COMPLETO que muestra una tabla de datos.
///
/// Combina tres elementos clave:
/// 1. Una tabla de datos real (`_buildDataTable()`) envuelta en un
///    `SingleChildScrollView` para permitir el desplazamiento vertical.
/// 2. Un espaciador para separar la tabla del total.
/// 3. Una fila resumen (`_buildMoneyRow()`) que muestra el total de los montos
///    o el estado de resultados.
///
/// La función devuelve un Column que encapsula la tabla de datos y su total.
  Widget _buildDataTableWithTotal() {
    return Column( // Columna que contiene la tabla y el total
      children: [ // Lista de widgets en la columna
        SizedBox( // Contenedor para la tabla de datos
          width: double.infinity, // Ancho máximo disponible
          height: 200, // Alto fijo para la tabla
          child: SingleChildScrollView( // Permite el desplazamiento vertical
            scrollDirection: Axis.vertical, // Dirección del desplazamiento
            child: _buildDataTable(), // Llamada a la función que crea la tabla de datos
          ),  // Fin del SingleChildScrollView
        ), // Fin del SizedBox
        SizedBox(height: 10), // Espacio entre la tabla y el total
        _buildMoneyRow(), // Fila con los totales de montos
      ], // Fin de la lista de widgets en la columna
    ); // Fin del Column
  } 

  /// Construye una fila (Widget) dedicada a mostrar el resumen financiero.
  ///
  /// Esta función se utiliza típicamente debajo de una tabla de datos
  /// para presentar métricas clave como el 'Total a Pagar', 'Total de Ingresos',
  /// o el 'Beneficio Neto'. Devuelve un Row o un contenedor similar
  /// que organiza los montos de dinero de forma clara y destacada.
  Widget _buildMoneyRow() {
    return Row( // Fila para mostrar los totales de montos
      mainAxisAlignment: MainAxisAlignment.spaceAround, // Espacio alrededor de los elementos
      children: [ // Lista de widgets en la fila
        Row( // Fila para el primer monto
          children: [ // Lista de widgets en la fila
            Icon(Icons.attach_money, color: AppColors.primary), // Icono de dinero
            Text('3000', // Texto del monto
                style: TextStyle( // Estilo del texto
                  fontSize: 18, //  Tamaño de fuente
                  fontWeight: FontWeight.bold // Negrita
                  ) // Fin del TextStyle
                ), // Fin del Text
          ], // Fin de la lista de widgets en la fila
        ), // Fin del Row
        Row( // Fila para el segundo monto
          children: [ // Lista de widgets en la fila
            Icon(Icons.attach_money, color: AppColors.primary), // Icono de dinero
            Text('3000', // Texto del monto
                style: TextStyle( // Estilo del texto
                  fontSize: 18, // Tamaño de fuente
                  fontWeight: FontWeight.bold // Negrita
                ) // Fin del TextStyle
              ), // Fin del Text
          ], // Fin de la lista de widgets en la fila
        ), // Fin del Row
      ], // Fin de la lista de widgets en la fila
    ); // Fin del Row
  }

  /// Construye y devuelve un widget que sirve como encabezado o línea de separación
  /// para la sección de "Impuestos a Pagar" dentro de una vista.
  ///
  /// El widget utiliza un color de fondo definido (AppColors.primary) y un
  /// texto centrado de color blanco para asegurar que esta información fiscal
  /// crítica se destaque visualmente del resto de la tabla o el reporte.
  Widget _buildImpuestosPagarLine() {
    return Container( // Contenedor para el título de impuestos
      width: double.infinity, // Ancho máximo disponible
      padding: EdgeInsets.all(5), // Padding interno
      color: AppColors.primary, // Color de fondo
      child: Text( // Texto del título
        'Impuestos a Pagar', // Texto a mostrar
        style: TextStyle( //  Estilo del texto
            fontSize: 14, //  Tamaño de fuente
            fontWeight: FontWeight.bold, // Negrita
            color: Colors.white // Color blanco
          ),// Fin del TextStyle
        textAlign: TextAlign.center, // Alineación centrada
      ), // Fin del Text
    ); // Fin del Container
  } // Fin de la función _buildImpuestosPagarLine

  /// Construye una línea (Widget) dedicada a mostrar el campo o el valor
  /// del "Monto del Cheque" dentro de un formulario o un resumen de transacción.
  ///
  /// Esta función es fundamental en la contabilidad para destacar cuánto dinero
  /// representa un cheque. Generalmente devuelve un Row que contiene una etiqueta
  /// de texto ('Monto del Cheque') y el valor numérico correspondiente.
  Widget _buildMontoDelChequeLine() {
    return Stack( // Stack para superponer el monto sobre el contenedor
      children: [// Lista de widgets en el stack
        Container( // Contenedor para el título de monto del cheque
          width: double.infinity, // Ancho máximo disponible
          padding: EdgeInsets.all(5), // Padding interno
          color: AppColors.primary, // Color de fondo
          child: Text( // Texto del título
            'Monto del Cheque', // Texto a mostrar
            style: TextStyle( // Estilo del texto
                fontSize: 14, // Tamaño de fuente 
                fontWeight: FontWeight.bold, // Negrita
                color: Colors.white // Color blanco
              ), // Fin del TextStyle
            textAlign: TextAlign.center, // Alineación centrada
          ), // Fin del Text
        ), // Fin del Container
        Positioned( // Posiciona el contenedor del monto en la esquina superior derecha
          right: 350, // Posición desde la derecha
          child: Container( // Contenedor para el monto del cheque
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4), // Padding interno
              decoration: BoxDecoration( // Decoración del contenedor
                color: Colors.white, // Color de fondo blanco
                borderRadius: BorderRadius.circular(10), // Bordes redondeados
                boxShadow: [ // Sombra para dar profundidad
                  BoxShadow( // Sombra del contenedor
                    color: Colors.grey.withOpacity(0.3), // Color de la sombra con opacidad
                    spreadRadius: 1, // Radio de propagación
                    blurRadius: 3, // Radio de desenfoque
                    offset: Offset(0, 1), // Desplazamiento de la sombra
                  ), // Fin del BoxShadow
                ], // Fin de la lista de sombras
              ), // Fin del BoxDecoration
              child: Row( // Fila para el icono y el monto
                children: [ //  Lista de widgets en la fila
                  Icon(Icons.attach_money, color: AppColors.primary), // Icono de dinero
                  Text( // Texto del monto
                    '30,000', // Monto a mostrar
                    style: TextStyle( // Estilo del texto
                      fontSize: 18, // Tamaño de fuente
                      fontWeight: FontWeight.bold, // Negrita
                      color: AppColors.primary, // Color del texto
                    ), // Fin del TextStyle
                  ), // Fin del Text
                ], // Fin de la lista de widgets en la fila
              )), // Fin del Container
        ), // Fin del Positioned
      ], // Fin de la lista de widgets en el stack
    ); // Fin del Stack
  } //  Fin de la función _buildMontoDelChequeLine

  // Función que construye la tabla de datos
  Widget _buildDataTable() {
    return SizedBox(
      width: double.infinity,
      child: DataTable(
        columnSpacing: 20.0,
        dataRowHeight: 24.0,
        headingRowHeight: 24.0,
        headingRowColor: MaterialStateProperty.all(AppColors.primary),
        columns: [
          // Columna para la casilla de verificación de seleccionar/deseleccionar todas las filas
          DataColumn(
            label: Row(
              children: [
                Checkbox(
                  value: _handler.selectedRows.every((selected) => selected),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value ?? false) {
                        _handler.selectAllRows(); // Selecciona todas las filas si se marca la casilla
                      } else {
                        _handler.deselectAllRows(); // Deselecciona todas las filas si se desmarca la casilla
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          DataColumn(label: Text('Impuesto')),
          DataColumn(label: Text('Monto')),
          DataColumn(label: Text('Honorario')),
          DataColumn(label: Text('Vencimiento')),
        ],
        rows: List.generate(10, (index) {
          return DataRow(
            cells: [
              DataCell(
                // Casilla de verificación para cada fila
                Checkbox(
                  value: _handler.selectedRows[index],
                  onChanged: (bool? value) {
                    setState(() {
                      _handler.toggleRowSelection(index, value); // Llamamos al método para alternar la selección de la fila
                    });
                  },
                ),
              ),
              DataCell(Text('Impuesto ${index + 1}')),
              DataCell(Text('\$500')),
              DataCell(Text('\$300')),
              DataCell(Text('01/01/2025')),
            ],
          );
        }),
      ),
    );
  }

  /// Construye una fila (Widget Row) que contiene un conjunto de botones de acción.
  ///
  /// Esta función es utilizada para agrupar las acciones principales que el usuario
  /// puede ejecutar en una pantalla específica (por ejemplo, 'Guardar', 'Cancelar',
  /// 'Editar', 'Eliminar'). Asegura que los botones estén alineados y espaciados
  /// correctamente.
  Widget _buildActionButtonsRow() {
    return Row( // Fila para los botones de acción
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espacio entre los botones
      children: [// Lista de widgets en la fila
        SizedBox( // Contenedor para el botón de eliminar
          width: 100, // Ancho del botón
          height: 35, // Alto del botón
          child: ElevatedButton( // Botón de eliminar
            onPressed: () {// Acción al presionar el botón
              _handler.eliminarSeleccionados(); // Llamamos al método para eliminar los elementos seleccionados
            }, // Fin de onPressed
            style: ElevatedButton.styleFrom( // Estilo del botón
              backgroundColor: AppColors.primary, // Color de fondo
              padding: EdgeInsets.zero, // Sin padding interno
            ), // Fin de style
            child: Text( // Texto del botón
              'Eliminar', // Texto a mostrar
              style: TextStyle(fontSize: 12),// Estilo del texto
            ), // Fin del Text
          ),// Fin del ElevatedButton
        ),// Fin del SizedBox
        SizedBox(// Contenedor para el botón de modificar
          width: 100,// Ancho del botón
          height: 35, // Alto del botón
          child: ElevatedButton( // Botón de modificar
            onPressed: () { // Acción al presionar el botón
              _handler.modificarSeleccionados(); // Llamamos al método para modificar los elementos seleccionados
            }, // Fin de onPressed
            style: ElevatedButton.styleFrom( // Estilo del botón
              backgroundColor: AppColors.primary, // Color de fondo
              padding: EdgeInsets.zero, // Sin padding interno
            ), // Fin de style
            child: Text( // Texto del botón
              'Modificar', // Texto a mostrar
              style: TextStyle(fontSize: 12), //  Estilo del texto
            ), // Fin del Text
          ), // Fin del ElevatedButton
        ), // Fin del SizedBox
      ],// Fin de la lista de widgets en la fila
    ); // Fin del Row
  } // Fin de la función _buildActionButtonsRow

  /// Construye un widget de línea horizontal simple, que actúa como un divisor visual.
  ///
  /// Esta función se utiliza para separar secciones de contenido, elementos de lista
  /// o datos en un reporte (como en Contaduría Barone).
  /// Típicamente, devuelve un Divider o un Container con una altura mínima y un colo
  Widget _buildHorizontalLine() {
    return Divider(
      color: AppColors.primary,
      height: 2,
    );
  }

  /// Construye una segunda fila de botones de acción para la pantalla.
  ///
  /// Esta función se utiliza cuando la vista requiere más de una fila
  /// de botones debido a la cantidad o la categorización de las acciones (ej.
  /// una fila para acciones primarias y una segunda fila para acciones secundarias,
  /// como 'Exportar', 'Imprimir' o 'Configuración').
  Widget _buildActionButtonsRow2() {
    return Row( // Fila para los botones de acción
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espacio entre los botones
      children: [ // Lista de widgets en la fila
        SizedBox( // Contenedor para el botón de agregar nuevo
          width: 100, // Ancho del botón
          height: 35, // Alto del botón
          child: ElevatedButton( // Botón de agregar nuevo
            onPressed: () { // Acción al presionar el botón
              _handler.agregarNuevo(); // Llamamos al método para agregar un nuevo depósito
            }, // Fin de onPressed
            style: ElevatedButton.styleFrom( // Estilo del botón
              backgroundColor: AppColors.primary, // Color de fondo
              padding: EdgeInsets.zero, // Sin padding interno
            ), // Fin de style
            child: Text( // Texto del botón
              'Agregar Nuevo', // Texto a mostrar
              style: TextStyle(fontSize: 12), // Estilo del texto
            ), // Fin del Text
          ), // Fin del ElevatedButton
        ), // Fin del SizedBox
        SizedBox( // Contenedor para el botón de cancelar
          width: 100, // Ancho del botón
          height: 35, // Alto del botón
          child: ElevatedButton(  //  
            onPressed: () { // Acción al presionar el botón
              _handler.cancelarAccion(); // Llamamos al método para cancelar la acción
            }, // Fin de onPressed
            style: ElevatedButton.styleFrom( // Estilo del botón
              backgroundColor: AppColors.primary,// Color de fondo
              padding: EdgeInsets.zero, // Sin padding interno
            ), // Fin de style
            child: Text( // Texto del botón
              'Cancelar', // Texto a mostrar
              style: TextStyle(fontSize: 12), // Estilo del texto
            ), // Fin del Text
          ), // Fin del ElevatedButton
        ), // Fin del SizedBox
      ], // Fin de la lista de widgets en la fila
    ); // Fin del Row
  } // Fin de la función _buildActionButtonsRow2


} 
