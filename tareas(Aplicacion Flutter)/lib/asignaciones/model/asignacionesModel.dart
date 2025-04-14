import 'package:intl/intl.dart';

class Asignacionesmodel {
  int? id;
  DateTime fechaasing;
  int fkUser;
  int fkTareas;
  String? nombreUser;
  String? nombreTarea;
  Asignacionesmodel({
    this.id,
    required this.fechaasing,
    required this.fkUser,
    required this.fkTareas,
    this.nombreUser,
    this.nombreTarea,
  });
  //metodo para convertir JSON a objeto dart
  factory Asignacionesmodel.fromJson(Map<String, dynamic> json) {
    return Asignacionesmodel(
      id: json["id"],
      fechaasing: DateTime.parse(json["fechaasing"]),
      fkUser: int.tryParse(json["fkUser"].toString()) ?? 0,
      fkTareas: int.tryParse(json["fkTareas"].toString()) ?? 0,
      nombreUser: json["nombreUser"] ?? "Usuario desconocido",
      nombreTarea: json["nombreTarea"] ?? "Tarea desconocida",
    );
  }

  // Método para convertir objeto ProyectoModel a JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'fechaasing': DateFormat('yyyy-MM-dd').format(fechaasing),
      'fkUser': fkUser, // Se envía como objeto
      'fkTareas': fkTareas // Se envía como objeto
    };
  }
}
