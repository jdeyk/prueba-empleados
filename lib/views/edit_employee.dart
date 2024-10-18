import 'package:flutter/material.dart';
import 'package:prueba/main.dart';
import 'package:prueba/services/api_service.dart';
import 'forms/form_employee.dart';
import 'package:prueba/models/employee.dart';

class EditEmployee extends StatelessWidget {
  final Employee employee;

  const EditEmployee({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Empleado'),
      ),
      body: EmployeeForm(
        initialName: employee.fullname,
        initialCorreo: employee.correo,
        initialFechaNacimiento: employee.fechaNacimiento,
        initialIsActivo: employee.isActivo,
        initialDepartmentId: employee.departamentoId,
        onSubmit: (fullname, correo, fechaNacimiento, isActivo,
            departamentoId) async {
          try {
            final apiService = ApiService();
            String formattedDate = fechaNacimiento;
            int activeStatus = isActivo ? 1 : 0;

            await apiService.updateEmployee(
              employee.id.toString(),
              fullname,
              correo,
              formattedDate,
              activeStatus,
              departamentoId,
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Empleado actualizado con éxito')),
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      HomePage()), // Asegúrate de importar tu HomePage
            );
          } catch (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Error al actualizar el empleado: $error')),
            );
          }
        },
      ),
    );
  }
}
