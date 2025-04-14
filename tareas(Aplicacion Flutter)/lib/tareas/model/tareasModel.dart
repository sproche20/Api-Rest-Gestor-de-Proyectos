import 'package:intl/intl.dart';

class TareasModel {
  int? id;
  String nombreTarea;
  String descripcion;
  DateTime fechaInicio;
  DateTime fechaFin;
  String estado;
  int fkProyectos;
  String? nombreProyectos;

  TareasModel(
      {this.id,
      required this.nombreTarea,
      required this.descripcion,
      required this.fechaInicio,
      required this.fechaFin,
      required this.estado,
      required this.fkProyectos,
      this.nombreProyectos});

  factory TareasModel.fromJson(Map<String, dynamic> json) {
    return TareasModel(
      id: json["id"],
      nombreTarea: json["nombreTarea"],
      descripcion: json["descripcion"],
      fechaInicio: DateTime.parse(json["fechaInicio"]),
      fechaFin: DateTime.parse(json["fechaFin"]),
      estado: json["estado"],
      fkProyectos: int.tryParse(json["fkProyectos"].toString()) ?? 0,
      nombreProyectos: json["nombreProyectos"] ?? "Proyecto desconocido",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombreTarea': nombreTarea,
      'descripcion': descripcion,
      'fechaInicio': DateFormat('yyyy-MM-dd').format(fechaInicio),
      'fechaFin': DateFormat('yyyy-MM-dd').format(fechaFin),
      'estado': estado,
      'fkProyectos': {'id': fkProyectos},
    };
  }
}
