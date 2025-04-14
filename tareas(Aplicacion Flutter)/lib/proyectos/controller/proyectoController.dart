import 'package:http/http.dart' as http;
import 'package:tareas/enlaces.dart';

class Proyectocontroller {
  final String baseUrl = EnlacesUrl.proyectoUrl;
  //obtener todas las listas
  Future<List<proyectoModel>> obtenerProyectos() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => proyectoModel.fromJson(json)).toList();
      } else {
        throw Exception('Error${response.statusCode}:${response.body}');
      }
    } catch (e) {
      throw Exception('Error al conectar cona la API: $e');
    }
  }

  //obtener user por id
  Future<proyectoModel> obtenerProyectoPorId(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return proyectoModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('proyecto no encontrado');
    }
  }

  //crear Proyecto
  Future<bool> crearProyecto(proyectoModel proyecto) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(proyecto.toJson()),
      );
      print("Código de estado: ${response.statusCode}");
      print("Respuesta del servidor: ${response.body}");
      if (response.statusCode == 201) {
        return true;
      } else {
        print("Error: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error en la petición: $e");
      return false;
    }
  }

  //actualizarProyecto
  Future<bool> actualizarProyecto(int id, proyectoModel proyecto) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(proyecto
            .toJson()), // Asegúrate de que `toJson()` esté bien implementado
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Error en la respuesta del servidor: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error al actualizar asignación: $e");
      return false;
    }
  }

  //eliminarProyecto
  Future<bool> eliminarProyecto(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        print("Error ${response.body}");
        throw Exception(
            "El proyecto tiene tareas o historial de cambios activos. Primero elimine esas entidades.");
      } else if (response.statusCode == 404) {
        throw Exception("Proyecto no encontrado");
      } else {
        throw Exception("Error desconocido al eliminar proyecto");
      }
    } catch (e) {
      print("Error de conexion: $e");
      throw Exception("Error de conexión: $e");
    }
  }
}
