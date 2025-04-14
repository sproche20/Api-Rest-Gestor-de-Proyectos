import 'package:flutter/material.dart';

TableRow EncabezadoTabla(String title, String value, Color filaColor) {
  return TableRow(
    decoration: BoxDecoration(
      color: filaColor, // Aquí aplicamos el color alternado a la fila
    ),
    children: [
      Container(
        color: Color.fromARGB(255, 27, 27, 41),
        padding: EdgeInsets.all(8.0),
        child: Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      Container(
        color: filaColor, // El valor de la celda tomará el color de la fila
        padding: EdgeInsets.all(8.0),
        child: Text(value,
            style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
      ),
    ],
  );
}
