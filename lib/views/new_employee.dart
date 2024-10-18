import 'package:flutter/material.dart';
import 'forms/form_employee.dart'; // Importa el formulario reutilizable
import '../services/api_service.dart';

class NewEmployee extends StatelessWidget {
  const NewEmployee({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alta Empleado'),
      ),
      body: EmployeeForm(
        onSubmit: (name, correo, fechaNacimiento, isActivo, departamentoId) {
          _saveEmployee(
            name,
            correo,
            fechaNacimiento,
            isActivo,
            departamentoId,
            context,
          );
        },
      ),
    );
  }

  Future<void> _saveEmployee(
      String fullname,
      String correo,
      String fechaNacimiento,
      bool isActivo,
      int departamentoId,
      BuildContext context) async {
    try {
      await ApiService().createEmployee(
        fullname: fullname,
        correo: correo,
        fechaNacimiento: fechaNacimiento,
        isActivo: isActivo,
        departamentoId: departamentoId,
      );
      Navigator.pop(
          context); // Regresa a la pantalla anterior después de guardar
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el empleado')),
      );
    }
  }
}
