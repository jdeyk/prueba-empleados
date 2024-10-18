import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba/models/departament.dart';
import '../models/employee.dart';

class ApiService {
  final String baseUrl = 'http://192.168.1.4:8000/api/v1';

  Future<Employee> fetchEmployee(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/empleados/$id'));

    if (response.statusCode == 200) {
      return Employee.fromJson(json.decode(response.body));
    } else {
      try {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        final String errorMessage =
            errorResponse['message'] ?? 'Error desconocido';
        throw Exception('Error al cargar el empleado: $errorMessage');
      } catch (e) {
        throw Exception('Error al cargar el empleado: ${response.body}');
      }
    }
  }

  Future<List<Department>> fetchDepartments() async {
    final response = await http.get(Uri.parse('$baseUrl/departamentos'));
    print('result departamentos');
    print(response.body);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((department) => Department.fromJson(department))
          .toList();
    } else {
      throw Exception('Error al cargar departamentos');
    }
  }

  Future<void> createEmployee({
    required String fullname,
    required String correo,
    required String fechaNacimiento,
    required bool isActivo,
    required int departamentoId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/empleados'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'fullname': fullname,
        'correo': correo,
        'fecha_nacimiento': fechaNacimiento,
        'isActivo': isActivo ? 1 : 0,
        'departamento_id': departamentoId,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al guardar el empleado: ${response.body}');
    }
  }

  Future<void> updateEmployee(String id, String fullname, String correo,
      String fechaNacimiento, int isActivo, int departamentoId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/empleados/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'fullname': fullname,
        'correo': correo,
        'fecha_nacimiento': fechaNacimiento,
        'isActivo': isActivo,
        'departamento_id': departamentoId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el empleado');
    }
  }

  Future<void> deleteEmployee(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/empleados/$id'));

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el empleado');
    }
  }
}
