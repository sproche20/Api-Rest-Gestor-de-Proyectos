import 'package:http/http.dart' as http;
import 'package:tareas/enlaces.dart';

class Asignacionescontroller {
  final String baseUrl = EnlacesUrl.asignacionesUrl;
  final String usuarioUrl = EnlacesUrl.usuarioUrl;
  final String tareaUrl = EnlacesUrl.tareaUrl;

  Future<List<Asignacionesmodel>> obtenerAsignaciones() async {
    final response = await http.get(Uri.parse(baseUrl));
    print(
        "Respuesta Api asignaciones(${response.statusCode}):${response.body}");

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<Asignacionesmodel> asignaciones =
          jsonData.map((json) => Asignacionesmodel.fromJson(json)).toList();

      // Obtener nombres de usuario y tarea
      for (var asignacion in asignaciones) {
        asignacion.nombreUser = await obtenerNombreUsuario(asignacion.fkUser);
        asignacion.nombreTarea = await obtenerNombreTarea(asignacion.fkTareas);
      }

      return asignaciones;
    } else {
      throw Exception("Error al obtener las asignaciones");
    }
  }

  //obtener asignacion por id
  Future<Asignacionesmodel> obtenerAsignacionesPorId(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return Asignacionesmodel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('asignacion no encontrada');
    }
  }

  //crear asignacion
  Future<bool> crearAsignacion(Asignacionesmodel asignaciones) async {
    final response = await http.post(Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(asignaciones.toJson()));
    print("Código de estado: ${response.statusCode}");
    print("Respuesta del servidor: ${response.body}");
    return response.statusCode == 200 || response.statusCode == 201;
  }

  //actualizar Asignaciones
  Future<bool> actualizarAsignaciones(
      int id, Asignacionesmodel asignaciones) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(asignaciones
            .toJson()), // Asegúrate de que `toJson()` esté bien implementado
      );
      if (response.statusCode == 200) {
        return true; // La actualización fue exitosa
      } else {
        print("Error en la respuesta del servidor: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error al actualizar asignación: $e");
      return false;
    }
  }

  //eliminar asignaciones
  Future<bool> eliminarAsignacion(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    return response.statusCode == 204;
  }

  //listar tareas
  Future<List<TareasModel>> obtenerTareas() async {
    try {
      final response = await http.get(Uri.parse(tareaUrl));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => TareasModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener las tareas: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  //listar usuarios
  Future<List<Usermodel>> obtenerUsuario() async {
    final response = await http.get(Uri.parse(usuarioUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Usermodel.fromJson(json)).toList();
    } else {
      throw Exception('error al obtener los usuarios');
    }
  }

  //obtener nombre de usuario
  Future<String> obtenerNombreUsuario(int userId) async {
    try {
      final response = await http.get(Uri.parse("$usuarioUrl/$userId"));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data["nombreUser"] ?? "Usuario no encontrado";
      } else {
        return "Usuario no encontrado";
      }
    } catch (e) {
      return "Error al obtener usuario";
    }
  }

  Future<String> obtenerNombreTarea(int tareaId) async {
    try {
      final response = await http.get(Uri.parse('$tareaUrl/$tareaId'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data["nombreTarea"] ?? "Tarea no encontrada";
      } else {
        return "Tarea no encontrada";
      }
    } catch (e) {
      return "Error al obtener tarea";
    }
  }
}
