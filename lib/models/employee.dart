class Employee {
  final int id;
  final String fullname;
  final DateTime fechaNacimiento; // Cambiado a DateTime
  final String correo;
  final int isActivo;
  final int departamentoId;

  Employee({
    required this.id,
    required this.fullname,
    required this.fechaNacimiento,
    required this.correo,
    required this.isActivo,
    required this.departamentoId,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      fullname: json['fullname'],
      fechaNacimiento:
          DateTime.parse(json['fecha_nacimiento']),
      correo: json['correo'],
      isActivo: json['isActivo'],
      departamentoId: json['departamento_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'fecha_nacimiento': fechaNacimiento.toIso8601String(),
      'correo': correo,
      'isActivo': isActivo,
      'departamento_id': departamentoId,
    };
  }
}
