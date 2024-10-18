import 'package:flutter/material.dart';
import 'package:prueba/main.dart';
import '../models/departament.dart';
import '../services/api_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Creation',
      home: CreateEmployee(),
    );
  }
}

class CreateEmployee extends StatefulWidget {
  @override
  _CreateEmployeeState createState() => _CreateEmployeeState();
}

class _CreateEmployeeState extends State<CreateEmployee> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _fechaNacimientoController =
      TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  bool _isActivo = true;
  int? _selectedDepartmentId; // Para el Dropdown de departamentos
  List<Department> _departments = []; // Lista de departamentos

  @override
  void initState() {
    super.initState();
    _loadDepartments(); // Cargar los departamentos al inicializar
  }

  Future<void> _loadDepartments() async {
    try {
      List<Department> departments =
          await ApiService().fetchDepartments(); // Llamada a la API
      setState(() {
        _departments = departments; // Asignar los departamentos obtenidos
      });
    } catch (error) {
      // Manejar el error aquí
      print('Error al cargar departamentos: $error');
    }
  }

  Future<void> _saveEmployee() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ApiService().createEmployee(
          fullname: _fullnameController.text,
          correo: _correoController.text,
          fechaNacimiento: _fechaNacimientoController.text,
          isActivo: _isActivo,
          departamentoId: _selectedDepartmentId!,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } catch (error) {
        print('Error: $error');
      }
    }
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _fechaNacimientoController.dispose();
    _correoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Employee'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Campo de nombre completo
                TextFormField(
                  controller: _fullnameController,
                  decoration: const InputDecoration(
                    hintText: 'Ingrese Nombre Completo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(12),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El nombre completo es requerido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo de fecha con calendario
                TextFormField(
                  controller: _fechaNacimientoController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    hintText: 'Ingrese Fecha de Nacimiento',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(12),
                      ),
                    ),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      _fechaNacimientoController.text = pickedDate
                          .toString()
                          .substring(0, 10); // Formato: YYYY-MM-DD
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La fecha de nacimiento es requerida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo de correo
                TextFormField(
                  controller: _correoController,
                  decoration: const InputDecoration(
                    hintText: 'Ingrese Correo Electrónico',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(12),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El correo electrónico es requerido';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(value)) {
                      return 'Ingrese un correo electrónico válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Dropdown de departamentos
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(labelText: 'Departamento'),
                  items: _departments.map((Department department) {
                    return DropdownMenuItem<int>(
                      value: department.id,
                      child: Text(department.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDepartmentId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Seleccione un departamento';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Checkbox de activo
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _isActivo,
                      onChanged: (value) {
                        setState(() {
                          _isActivo = value ?? false;
                        });
                      },
                    ),
                    const Text('Activo'),
                  ],
                ),
                const SizedBox(height: 16),

                // Botón de guardar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    onPressed: _saveEmployee,
                    child: const Text('Guardar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
