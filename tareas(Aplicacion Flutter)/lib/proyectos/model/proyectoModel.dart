import 'package:intl/intl.dart';

class proyectoModel {
  int? id;
  String nombreProyectos;
  String descripcion;
  DateTime fechaInicio;
  DateTime fechafin;
  String estado;
  proyectoModel(
      {this.id,
      required this.nombreProyectos,
      required this.descripcion,
      required this.fechaInicio,
      required this.fechafin,
      required this.estado});
  // Método para convertir JSON a objeto ProyectoModel
  factory proyectoModel.fromJson(Map<String, dynamic> json) {
    return proyectoModel(
        id: json["id"],
        nombreProyectos: json["nombreProyectos"],
        descripcion: json["descripcion"],
        fechaInicio: DateTime.parse(json["fechaInicio"]),
        fechafin: DateTime.parse(json["fechaFin"]),
        estado: json["estado"]);
  }
  // Método para convertir objeto ProyectoModel a JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) // Solo incluir id si existe
        'id': id,
      'nombreProyectos': nombreProyectos,
      'descripcion': descripcion,
      'fechaInicio': DateFormat('yyyy-MM-dd')
          .format(fechaInicio), // Convierte DateTime a String
      'fechaFin': DateFormat('yyyy-MM-dd').format(fechafin),
      'estado': estado
    };
  }
}
