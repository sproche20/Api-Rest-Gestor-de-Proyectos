import 'package:intl/intl.dart';

class Histcambiosmodel {
  int? id;
  int tipocambio;
  DateTime fechacambio;
  String descripcion;
  int fkProyectos;
  int fkUser;
  String? nombreUser;
  String? nombreProyectos;
  String?
      nombreTipoCambio; // Nuevo campo para almacenar la descripción del tipo de cambio
  Histcambiosmodel({
    this.id,
    required this.tipocambio,
    required this.fechacambio,
    required this.descripcion,
    required this.fkProyectos,
    required this.fkUser,
    this.nombreUser,
    this.nombreProyectos,
    this.nombreTipoCambio,
  });
  //metodo para convertir JSON  a objetos dart
  factory Histcambiosmodel.fromJson(Map<String, dynamic> json) {
    return Histcambiosmodel(
        id: json["id"],
        fechacambio: DateTime.parse(json["fechacambio"]),
        tipocambio: json["tipocambio"],
        descripcion: json["descripcion"],
        fkProyectos: int.tryParse(json["fkProyectos"].toString()) ?? 0,
        fkUser: int.tryParse(json["fkUser"].toString()) ?? 0,
        nombreUser: json["nombreUser"] ?? "Usuario Desconocido",
        nombreProyectos: json["nombreProyectos"] ?? "Proyecto Desconocido");
  }
  //metodo para convertir objeto modelo a Json
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'fechacambio': DateFormat('yyyy-MM-dd').format(fechacambio),
      'descripcion': descripcion,
      'tipocambio': tipocambio,
      'fkProyectos': fkProyectos,
      'fkUser': fkUser, // Se envía como objeto
    };
  }
}
