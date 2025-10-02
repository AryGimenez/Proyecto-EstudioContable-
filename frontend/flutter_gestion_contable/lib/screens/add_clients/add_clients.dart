// lib/screens/clients/add_clientes.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_gestion_contable/core/theme/app_colors.dart';

class AgregarClientesContent extends StatefulWidget {
  const AgregarClientesContent({super.key});

  @override
  _AgregarClientesContentState createState() => _AgregarClientesContentState();
}

class _AgregarClientesContentState extends State<AgregarClientesContent> {
  // Controladores de texto para los campos del cliente.
  final TextEditingController nombreCompletoController = TextEditingController();
  final TextEditingController fechaNacimientoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController datosContactoController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();

  // URL del endpoint de tu backend para clientes (mantengo tu URL actual)
  final String clientsApiUrl = 'http://127.0.0.1:8000/clientes';
  // URL del endpoint de tu backend para impuestos
  final String taxesApiUrl = 'http://127.0.0.1:8000/impuestos';

  // Controladores de texto para los campos de impuestos.
  final TextEditingController taxNombreController = TextEditingController();
  final TextEditingController taxFrecuenciaController = TextEditingController();
  final TextEditingController taxDiasController = TextEditingController();
  final TextEditingController taxVencimientoController = TextEditingController();
  final TextEditingController taxMontoController = TextEditingController();
  final TextEditingController taxHonorarioController = TextEditingController();

  // Lista para almacenar los impuestos obtenidos del backend.
  List<Map<String, dynamic>> _taxesData = [];
  int? _selectedTaxId; // Almacena el ID del impuesto seleccionado del backend
  int? _selectedTaxRowIndex; // Para el estado visual de la fila seleccionada en la tabla

  // Variables para saber si estamos modificando un impuesto existente o agregando uno nuevo
  bool _isEditingTax = false;

  @override
  void initState() {
    super.initState();
    _fetchTaxes(); // Carga los impuestos al iniciar el widget
  }

  @override
  void dispose() {
    nombreCompletoController.dispose();
    fechaNacimientoController.dispose();
    emailController.dispose();
    whatsappController.dispose();
    datosContactoController.dispose();
    direccionController.dispose();
    taxNombreController.dispose();
    taxFrecuenciaController.dispose();
    taxDiasController.dispose();
    taxVencimientoController.dispose();
    taxMontoController.dispose();
    taxHonorarioController.dispose();
    super.dispose();
  }

  // --- Lógica de conexión con el backend para impuestos ---

  // Obtener todos los impuestos del backend
  Future<void> _fetchTaxes() async {
    try {
      final response = await http.get(Uri.parse(taxesApiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _taxesData = data.map((tax) => {
            'id': tax['Imp_ID'],
            'nombre': tax['Imp_Nom'],
            'frecuencia': tax['Imp_Frecuencia'],
            'dias': tax['Imp_Dias'].toString(),
            'vencimiento': tax['Imp_Vencimiento'],
            'monto': tax['Imp_Monto'].toString(),
            'honorario': tax['Imp_Honorario'].toString(),
          }).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al cargar los impuestos.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de conexión al obtener impuestos: $e')));
    }
  }

  // Agregar un nuevo impuesto al backend
  Future<void> _addTax() async {
    if (taxNombreController.text.isEmpty ||
        taxFrecuenciaController.text.isEmpty ||
        taxDiasController.text.isEmpty ||
        taxVencimientoController.text.isEmpty ||
        taxMontoController.text.isEmpty ||
        taxHonorarioController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, complete todos los campos del impuesto.')));
      return;
    }

    try {
      final taxData = {
        'Imp_Nom': taxNombreController.text,
        'Imp_Frecuencia': taxFrecuenciaController.text,
        'Imp_Dias': int.parse(taxDiasController.text),
        'Imp_Vencimiento': taxVencimientoController.text,
        'Imp_Monto': double.parse(taxMontoController.text),
        'Imp_Honorario': double.parse(taxHonorarioController.text),
      };

      final response = await http.post(
        Uri.parse(taxesApiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(taxData),
      );

      if (response.statusCode == 201) {
        _clearTaxFields();
        _fetchTaxes();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Impuesto agregado correctamente.')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al agregar el impuesto: ${response.statusCode} - ${response.body}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de conexión o inesperado al agregar impuesto: $e')));
    }
  }

  // Actualizar un impuesto existente en el backend
  Future<void> _updateTax() async {
    if (_selectedTaxId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: No se ha seleccionado ningún impuesto para modificar.')));
      return;
    }
    if (taxNombreController.text.isEmpty ||
        taxFrecuenciaController.text.isEmpty ||
        taxDiasController.text.isEmpty ||
        taxVencimientoController.text.isEmpty ||
        taxMontoController.text.isEmpty ||
        taxHonorarioController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, complete todos los campos del impuesto para modificar.')));
      return;
    }

    try {
      final taxData = {
        'Imp_Nom': taxNombreController.text,
        'Imp_Frecuencia': taxFrecuenciaController.text,
        'Imp_DiasVencimiento': int.parse(taxDiasController.text),
        'Imp_Vencimiento': taxVencimientoController.text,
        'Imp_Monto': double.parse(taxMontoController.text),
        'Imp_Honorario': double.parse(taxHonorarioController.text),
      };

      final response = await http.put(
        Uri.parse('$taxesApiUrl/$_selectedTaxId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(taxData),
      );

      if (response.statusCode == 200) {
        _clearTaxFields();
        _fetchTaxes();
        setState(() {
          _isEditingTax = false;
          _selectedTaxId = null;
          _selectedTaxRowIndex = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Impuesto actualizado correctamente.')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al actualizar el impuesto: ${response.statusCode} - ${response.body}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de conexión o inesperado al actualizar impuesto: $e')));
    }
  }

  // Eliminar un impuesto del backend
  Future<void> _deleteTax() async {
    if (_selectedTaxId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, seleccione un impuesto para eliminar.')));
      return;
    }

    try {
      final response = await http.delete(Uri.parse('$taxesApiUrl/$_selectedTaxId'));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Impuesto eliminado de la base de datos.')));
        _fetchTaxes();
        setState(() {
          _selectedTaxId = null;
          _selectedTaxRowIndex = null;
          _isEditingTax = false;
          _clearTaxFields();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al eliminar el impuesto: ${response.statusCode} - ${response.body}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de conexión al eliminar impuesto: $e')));
    }
  }
  
  // --- Lógica para Clientes (sin cambios) ---
  void _addClient() async { /* ... */
    if (nombreCompletoController.text.isEmpty ||
        direccionController.text.isEmpty ||
        emailController.text.isEmpty ||
        whatsappController.text.isEmpty ||
        datosContactoController.text.isEmpty ||
        fechaNacimientoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, complete todos los campos del cliente.')));
      return;
    }

    try {
      final clientData = {
        'Cli_Nom': nombreCompletoController.text,
        'Cli_Dir': direccionController.text,
        'Cli_Email': emailController.text,
        'Cli_Whatsapp': whatsappController.text,
        'Cli_Contacto': datosContactoController.text,
        'Cli_FechNac': fechaNacimientoController.text,
        'Cli_Saldo': 0.0,
      };

      print('Intentando POST de cliente a: $clientsApiUrl con datos: $clientData');
      final response = await http.post(
        Uri.parse(clientsApiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(clientData),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        _clearClientFields();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cliente agregado correctamente.')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al agregar el cliente: ${response.statusCode} - ${response.body}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de conexión o inesperado al agregar cliente: $e')));
    }
  }

  void _clearClientFields() {
    nombreCompletoController.clear();
    fechaNacimientoController.clear();
    emailController.clear();
    whatsappController.clear();
    datosContactoController.clear();
    direccionController.clear();
  }

  // --- Lógica para Impuestos (anteriormente local, ahora para cargar/limpiar campos) ---

  // Método para cargar los datos de un impuesto seleccionado en los TextFields.
  void _loadTaxForEdit() {
    if (_selectedTaxRowIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, seleccione un impuesto para modificar.')));
      return;
    }
    final taxToEdit = _taxesData[_selectedTaxRowIndex!];
    setState(() {
      taxNombreController.text = taxToEdit['nombre'];
      taxFrecuenciaController.text = taxToEdit['frecuencia'];
      taxDiasController.text = taxToEdit['dias'];
      taxVencimientoController.text = taxToEdit['vencimiento'];
      taxMontoController.text = taxToEdit['monto'];
      taxHonorarioController.text = taxToEdit['honorario'];
      _isEditingTax = true; // Entrar en modo edición
    });
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos de impuesto cargados para edición.')));
  }

  // Método auxiliar para limpiar los campos del impuesto.
  void _clearTaxFields() {
    taxNombreController.clear();
    taxFrecuenciaController.clear();
    taxDiasController.clear();
    taxVencimientoController.clear();
    taxMontoController.clear();
    taxHonorarioController.clear();
    setState(() {
      _isEditingTax = false; // Salir del modo edición al limpiar
      _selectedTaxId = null;
      _selectedTaxRowIndex = null;
    });
  }

  // --- Lógica Global de Botones ---

  // Decide si agregar un cliente o un impuesto.
  void _handleAgregarButton() {
    if (_isEditingTax) {
      _updateTax(); // Si estamos editando un impuesto, lo actualizamos.
    } else if (_areTaxFieldsFilled()) {
      _addTax(); // Si hay campos de impuesto llenos y no estamos editando, agregamos un nuevo impuesto.
    } else if (_areClientFieldsFilled()) {
      _addClient(); // Si no hay campos de impuesto pero sí de cliente, agregamos un cliente.
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, complete los campos de cliente o de impuesto para agregar/modificar.')));
    }
  }

  // Decide qué limpiar (clientes, impuestos o ambos).
  void _handleCancelarButton() {
    // Limpiar campos de cliente si están llenos
    if (_areClientFieldsFilled()) {
      _clearClientFields();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Campos de cliente limpiados.')));
    }
    // Limpiar campos y estado de impuesto si están llenos o hay algo seleccionado
    if (_areTaxFieldsFilled() || _selectedTaxId != null || _selectedTaxRowIndex != null || _isEditingTax) {
      _clearTaxFields(); // Esto también resetea _isEditingTax, _selectedTaxId, _selectedTaxRowIndex
      _fetchTaxes(); // Volver a cargar los impuestos para asegurar que la tabla esté fresca
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Campos e tabla de impuestos limpiados.')));
    }
    // Si no había nada que limpiar, avisar
    if (!_areClientFieldsFilled() && !_areTaxFieldsFilled() && _selectedTaxId == null && !_isEditingTax) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No hay campos para limpiar.')));
    }
    debugPrint('Botón Cancelar presionado.');
  }

  bool _areClientFieldsFilled() {
    return nombreCompletoController.text.isNotEmpty ||
           fechaNacimientoController.text.isNotEmpty ||
           emailController.text.isNotEmpty ||
           whatsappController.text.isNotEmpty ||
           datosContactoController.text.isNotEmpty ||
           direccionController.text.isNotEmpty;
  }

  bool _areTaxFieldsFilled() {
    return taxNombreController.text.isNotEmpty ||
           taxFrecuenciaController.text.isNotEmpty ||
           taxDiasController.text.isNotEmpty ||
           taxVencimientoController.text.isNotEmpty ||
           taxMontoController.text.isNotEmpty ||
           taxHonorarioController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth - 32.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sección de Datos de Clientes
          const Center(
            child: Text(
              "Datos de clientes",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          _buildInputRow([
            _buildTextField("Nombre Completo", nombreCompletoController),
            _buildTextField("Fecha de Nacimiento", fechaNacimientoController, onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
                locale: const Locale('es', 'ES'),
              );
              if (pickedDate != null) {
                fechaNacimientoController.text = "${pickedDate.toLocal()}".split(' ')[0];
              }
            }, readOnly: true),
            _buildTextField("Email", emailController, keyboardType: TextInputType.emailAddress),
          ]),
          const SizedBox(height: 8),
          _buildInputRow([
            _buildTextField("Whatsapp", whatsappController, keyboardType: TextInputType.phone),
            _buildTextField("Datos de Contacto", datosContactoController),
            _buildTextField("Dirección", direccionController),
          ]),
          const SizedBox(height: 20),

          // Sección de Impuestos
          Container(
            color: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            width: containerWidth,
            child: const Center(
              child: Text(
                "Impuestos",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _buildInputRow([
            _buildTextField("Nombre", taxNombreController),
            _buildTextField("Frecuencia", taxFrecuenciaController),
            _buildTextField("Días", taxDiasController, keyboardType: TextInputType.number),
            _buildTextField("Vencimiento", taxVencimientoController, onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
                locale: const Locale('es', 'ES'),
              );
              if (pickedDate != null) {
                taxVencimientoController.text = "${pickedDate.toLocal()}".split(' ')[0];
              }
            }, readOnly: true),
            _buildTextField("Monto", taxMontoController, keyboardType: TextInputType.number),
            _buildTextField("Honorario", taxHonorarioController, keyboardType: TextInputType.number),
          ]),
          const SizedBox(height: 20),

          // Tabla de Impuestos
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.resolveWith<Color?>((states) => AppColors.primary),
                  columns: const [
                    DataColumn(label: Text('Nombre', style: TextStyle(color: Colors.white))),
                    DataColumn(label: Text('Frecuencia', style: TextStyle(color: Colors.white))),
                    DataColumn(label: Text('Días', style: TextStyle(color: Colors.white))),
                    DataColumn(label: Text('Vencimiento', style: TextStyle(color: Colors.white))),
                    DataColumn(label: Text('Monto', style: TextStyle(color: Colors.white))),
                    DataColumn(label: Text('Honorario', style: TextStyle(color: Colors.white))),
                  ],
                  rows: _taxesData.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> tax = entry.value;
                    bool isSelected = _selectedTaxRowIndex == index;

                    return DataRow(
                      selected: isSelected,
                      onSelectChanged: (bool? selected) {
                        setState(() {
                          if (selected != null && selected) {
                            // Si se selecciona una fila, limpia los campos de arriba primero
                            // y luego carga los datos si es para edición.
                            _clearTaxFields(); // Limpia campos y resetea _isEditingTax
                            _selectedTaxRowIndex = index;
                            _selectedTaxId = tax['id']; 
                          } else {
                            _clearTaxFields(); // Desselecciona y limpia todo
                          }
                        });
                      },
                      cells: [
                        DataCell(Text(tax['nombre'] ?? '')),
                        DataCell(Text(tax['frecuencia'] ?? '')),
                        DataCell(Text(tax['dias']?.toString() ?? '')),
                        DataCell(Text(tax['vencimiento'] ?? '')),
                        DataCell(Text(tax['monto']?.toString() ?? '')),
                        DataCell(Text(tax['honorario']?.toString() ?? '')),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Botones Inferiores (Eliminar, Modificar, Cancelar, Agregar/Guardar Cambios)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSmallButton("Eliminar", AppColors.primary, onPressed: _deleteTax),
                  const SizedBox(height: 8),
                  _buildSmallButton("Cancelar", AppColors.primary, onPressed: _handleCancelarButton),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildSmallButton("Modificar", AppColors.primary, onPressed: _selectedTaxId != null ? _loadTaxForEdit : null), // Habilitado solo si hay un impuesto seleccionado
                  const SizedBox(height: 8),
                  _buildSmallButton(
                    _isEditingTax ? "Guardar Cambios" : "Agregar",
                    AppColors.primary,
                    onPressed: _handleAgregarButton,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // --- Widgets auxiliares (igual que antes) ---

  Widget _buildInputRow(List<Widget> children) {
    return Row(
      children: children.map((widget) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: widget,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType, bool readOnly = false, VoidCallback? onTap}) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        ),
      ),
    );
  }

  Widget _buildSmallButton(String text, Color color, {VoidCallback? onPressed}) {
    return SizedBox(
      width: 120,
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}