import 'package:prueba/models/departament.dart';

class Employee {
  final int id;
  final String fullname;
  final String correo;
  final DateTime fechaNacimiento;
  final int isActivo;
  final int departamentoId; // ID del departamento
  final Department departamento; // Información completa del departamento

  Employee({
    required this.id,
    required this.fullname,
    required this.correo,
    required this.fechaNacimiento,
    required this.isActivo,
    required this.departamentoId,
    required this.departamento,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      fullname: json['fullname'],
      correo: json['correo'],
      fechaNacimiento: DateTime.parse(json['fecha_nacimiento']),
      isActivo: json['isActivo'],
      departamentoId: json['departamento_id'],
      departamento: Department.fromJson(json['departamento']),
    );
  }
}
