import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prueba/models/departament.dart';
import '../../services/api_service.dart';

class EmployeeForm extends StatefulWidget {
  final Function(String, String, String, bool, int) onSubmit;
  final String? initialName;
  final String? initialCorreo;
  final DateTime? initialFechaNacimiento;
  final int initialIsActivo;
  final int? initialDepartmentId;

  const EmployeeForm({
    Key? key,
    required this.onSubmit,
    this.initialName,
    this.initialCorreo,
    this.initialFechaNacimiento,
    this.initialIsActivo = 1,
    this.initialDepartmentId,
  }) : super(key: key);

  @override
  _EmployeeFormState createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullnameController;
  late TextEditingController _fechaNacimientoController;
  late TextEditingController _correoController;
  bool _isActivo = true;
  int? _selectedDepartmentId;
  List<Department> _departments = [];

  @override
  void initState() {
    super.initState();
    _fullnameController = TextEditingController(text: widget.initialName ?? '');
    _fechaNacimientoController = TextEditingController(
      text: widget.initialFechaNacimiento != null
          ? DateFormat('yyyy-MM-dd').format(widget.initialFechaNacimiento!)
          : '',
    );
    _correoController = TextEditingController(text: widget.initialCorreo ?? '');
    _isActivo = widget.initialIsActivo == 1;
    _selectedDepartmentId = widget.initialDepartmentId;
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    try {
      List<Department> departments = await ApiService().fetchDepartments();
      setState(() {
        _departments = departments;
      });
    } catch (error) {
      print('Error al cargar departamentos: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
                    _fechaNacimientoController.text =
                        pickedDate.toString().substring(0, 10);
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
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Ingrese un correo electrónico válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _selectedDepartmentId,
                decoration: const InputDecoration(labelText: 'Departamento'),
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
              Row(
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSubmit(
                        _fullnameController.text,
                        _correoController.text,
                        _fechaNacimientoController.text,
                        _isActivo,
                        _selectedDepartmentId!,
                      );
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _fechaNacimientoController.dispose();
    _correoController.dispose();
    super.dispose();
  }
}
