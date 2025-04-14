import 'package:http/http.dart' as http;
import 'package:tareas/enlaces.dart';

class HistCambiosController {
  final String baseUrl = EnlacesUrl.histCambiosUrl;
  final String proyectoUrl = EnlacesUrl.proyectoUrl;
  final String usuarioUrl = EnlacesUrl.usuarioUrl;

  // Obtener todos los cambios históricos
  Future<List<Histcambiosmodel>> obtenerHistCambios() async {
    final response = await http.get(Uri.parse(baseUrl));
    print(
        "Respuesta API histCambios(${response.statusCode}): ${response.body}");

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<Histcambiosmodel> cambios =
          jsonData.map((json) => Histcambiosmodel.fromJson(json)).toList();

      // Obtener listas completas de proyectos y usuarios para evitar múltiples peticiones
      List<proyectoModel> proyectos = await obtenerProyectos();
      List<Usermodel> usuarios = await obtenerUsuario();

      // Crear mapas para acceder rápidamente por ID
      Map<int, String> proyectosMap = {
        for (var proyecto in proyectos) proyecto.id!: proyecto.nombreProyectos
      };
      Map<int, String> usuariosMap = {
        for (var usuario in usuarios) usuario.id!: usuario.nombreUser
      };

      // Asignar los nombres correspondientes
      for (var cambio in cambios) {
        cambio.nombreUser =
            usuariosMap[cambio.fkUser] ?? "Usuario no encontrado";
        cambio.nombreProyectos =
            proyectosMap[cambio.fkProyectos] ?? "Proyecto no encontrado";
      }

      return cambios;
    } else {
      throw Exception("Error al obtener los cambios del historial");
    }
  }

  // Obtener cambio por ID
  Future<Histcambiosmodel> obtenerHistCambioPorId(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return Histcambiosmodel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Cambio Historial no encontrado');
    }
  }

  // Crear un nuevo cambio histórico
  Future<bool> crearHistCambio(Histcambiosmodel cambio) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(cambio.toJson()),
    );
    print("Código de estado: ${response.statusCode}");
    print("Respuesta del servidor: ${response.body}");
    return response.statusCode == 200 || response.statusCode == 201;
  }

  // Actualizar un cambio histórico
  Future<bool> actualizarHistCambio(int id, Histcambiosmodel cambio) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(cambio.toJson()),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Error en la respuesta del servidor: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error al actualizar cambio: $e");
      return false;
    }
  }

  // Eliminar un cambio histórico
  Future<bool> eliminarHistCambio(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    return response.statusCode == 204;
  }

  // Obtener el nombre del usuario
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

  // Obtener el nombre del proyecto
  Future<String> obtenerNombreProyecto(int proyectoId) async {
    try {
      final response = await http.get(Uri.parse('$proyectoUrl/$proyectoId'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data["nombreProyectos"] ?? "Proyecto no encontrado";
      } else {
        return "Proyecto no encontrado";
      }
    } catch (e) {
      return "Error al obtener proyecto";
    }
  }

  //listar proyectos
  Future<List<proyectoModel>> obtenerProyectos() async {
    final response = await http.get(Uri.parse(proyectoUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => proyectoModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener la lista de proyectos');
    }
  }
}
