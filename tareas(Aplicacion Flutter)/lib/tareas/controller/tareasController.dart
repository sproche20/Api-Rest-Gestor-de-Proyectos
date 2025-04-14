import 'package:http/http.dart' as http;
import 'package:tareas/enlaces.dart';

class Tareascontroller {
  final String baseUrl = EnlacesUrl.tareaUrl;
  final String proyectosUrl = EnlacesUrl.proyectoUrl;
  //obtener todas las listas
  Future<List<TareasModel>> obtenerTareas() async {
    final response = await http.get(Uri.parse(baseUrl));
    print("Respuesta api tareas (${response.statusCode}):${response.body}");

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<TareasModel> tareas =
          jsonData.map((json) => TareasModel.fromJson(json)).toList();
      //obtener nombres de los proyectos
      for (var tarea in tareas) {
        tarea.nombreProyectos = await obtenerNombreProyectos(tarea.fkProyectos);
      }
      return tareas;
    } else {
      throw Exception("Error al obtener las tareas");
    }
  }

  //obtener tarea por id
  Future<TareasModel> obtenerTareaPorId(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return TareasModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('tarea no encontrada');
    }
  }

  //crear tarea
  Future<bool> crearTarea(TareasModel tarea) async {
    final response = await http.post(Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(tarea.toJson()));
    print("Código de estado: ${response.statusCode}");
    print("Respuesta del servidor: ${response.body}");
    return response.statusCode == 200 || response.statusCode == 201;
  }

  //actualizarTarea
  Future<bool> actualizarTarea(int id, TareasModel tarea) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(tarea
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

  //eliminar Tarea
  Future<bool> eliminarTarea(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        print("Error ${response.body}");
        throw Exception(
            "La tarea tiene asignaciones activas. Primero elimine esa entidad.");
      } else if (response.statusCode == 404) {
        throw Exception("Tarea no encontrada");
      } else {
        throw Exception("Error desconocido al eliminar la tarea");
      }
    } catch (e) {
      print("Error de conexion: $e");
      throw Exception("Error de conexión: $e");
    }
  }

  //listar proyectos
  Future<List<proyectoModel>> obtenerProyectos() async {
    final response = await http.get(Uri.parse(proyectosUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => proyectoModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener la lista de proyectos');
    }
  }

  //obtenerNombreProyecto
  Future<String> obtenerNombreProyectos(int proyectoId) async {
    try {
      final response = await http.get(Uri.parse("$proyectosUrl/$proyectoId"));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data["nombreProyectos"] ?? "proyecto no encontrado";
      } else {
        return "proyecto no encontrado";
      }
    } catch (e) {
      return "Error al obtener proyectos";
    }
  }
}
