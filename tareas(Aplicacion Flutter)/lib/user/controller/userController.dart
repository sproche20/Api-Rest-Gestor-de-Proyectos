import 'package:http/http.dart' as http;
import 'package:tareas/enlaces.dart';

class Usercontroller {
  final String baseUrl = EnlacesUrl.usuarioUrl;
  final String asignacionesUrl = EnlacesUrl.asignacionesUrl;

  //obtener todos los usuarios
  Future<List<Usermodel>> obtenerUsuario() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Usermodel.fromJson(json)).toList();
    } else {
      throw Exception('error al obtener los usuarios');
    }
  }

  //obtener usuario por id
  Future<Usermodel> obtenerUserPorId(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return Usermodel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('usuario no encontrado');
    }
  }

  //crear nuevo usuario
  Future<bool> crearUser(Usermodel usuario) async {
    final response = await http.post(Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(usuario.toJson()));
    print("Código de estado: ${response.statusCode}");
    print("Respuesta del servidor: ${response.body}");
    return response.statusCode == 201;
  }

  //actualizar User
  Future<bool> actualizarUser(int id, Usermodel user) async {
    final response = await http.put(Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()));
    return response.statusCode == 200;
  }

  Future<bool> eliminarUser(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        return true; // Usuario eliminado con éxito
      } else if (response.statusCode == 400) {
        print("Error: ${response.body}");
        throw Exception(
            "El usuario tiene asignaciones o gestiones de cambios activas.");
      } else if (response.statusCode == 404) {
        throw Exception("Usuario no encontrado.");
      } else {
        throw Exception("Error desconocido al eliminar usuario.");
      }
    } catch (e) {
      print("Error de conexión: $e");
      throw Exception("Error de conexión: $e");
    }
  }
}
