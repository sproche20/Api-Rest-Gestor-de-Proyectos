import '../../enlaces.dart';

class Usertables extends StatefulWidget {
  const Usertables({super.key});

  @override
  State<Usertables> createState() => _UsertablesState();
}

class _UsertablesState extends State<Usertables> {
  final Usercontroller _userController = Usercontroller();
  final TextEditingController _buscarController = TextEditingController();
  List<Usermodel> _usuarios = [];
  List<Usermodel> _usuariosFiltrados = [];
  bool _isLoading = true;
  //variable de paginacion
  int _paginaActual = 0;
  final int _usuariosPorPagina = 6; // Máximo de usuarios por página

  @override
  void initState() {
    super.initState();
    _obtenerUsers();
    //agregar listener al campo de busqueda
    _buscarController.addListener(() {
      _filtrarUsuarios(_buscarController.text);
    });
  }

  Future<void> _obtenerUsers() async {
    try {
      List<Usermodel> users = await _userController.obtenerUsuario();
      if (!mounted)
        return; // Evitar llamar setState si el widget ya no está montado
      setState(() {
        _usuarios = users;
        _usuariosFiltrados = users;
        _isLoading = false;
      });
    } catch (e) {
      print("Error al obtener usuarios:$e");
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filtrarUsuarios(String query) {
    if (query.isEmpty) {
      setState(() {
        _usuariosFiltrados = _usuarios;
      });
    } else {
      setState(() {
        _usuariosFiltrados = _usuarios
            .where((user) =>
                user.nombreUser.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
    _paginaActual = 0; // Reiniciar la paginación al filtrar
  }

  List<Usermodel> _obtenerUsuariosPaginados() {
    int inicio = _paginaActual * _usuariosPorPagina;
    if (inicio >= _usuariosFiltrados.length) {
      return [];
    }
    int fin = inicio + _usuariosPorPagina;
    return _usuariosFiltrados.sublist(inicio,
        fin > _usuariosFiltrados.length ? _usuariosFiltrados.length : fin);
  }

  void _siguientePagina() {
    if ((_paginaActual + 1) * _usuariosPorPagina < _usuariosFiltrados.length) {
      setState(() {
        _paginaActual++;
      });
    }
  }

  void _paginaAnterior() {
    if (_paginaActual > 0) {
      setState(() {
        _paginaActual--;
      });
    }
  }

  Future<void> _eliminarUsuario(BuildContext context, int userId) async {
    try {
      bool eliminado = await _userController.eliminarUser(userId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(eliminado
                ? "Usuario eliminado con éxito"
                : "Error al eliminar el usuario")),
      );
      if (eliminado) _obtenerUsers();
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al eliminar el usuario: $e")),
      );
    }
  }

  // Método para mostrar el diálogo de confirmación
  void _mostrarConfirmacionEliminar(BuildContext context, Usermodel user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmación"),
          content:
              Text("¿Estás seguro de que quieres eliminar a este usuario?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo sin hacer nada
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                // Si se acepta, eliminamos el usuario
                if (user.id != null) {
                  _eliminarUsuario(context, user.id!);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("ID de usuario no válido")),
                  );
                }
                Navigator.of(context)
                    .pop(); // Cerrar el diálogo después de eliminar
              },
              child: Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Fondo del campo de búsqueda
            borderRadius: BorderRadius.circular(30), // Bordes redondeados
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _buscarController,
            decoration: InputDecoration(
              hintText: "Buscar usuario...",
              hintStyle: TextStyle(color: Colors.grey[600]),
              prefixIcon:
                  Icon(Icons.search, color: Colors.blue), // Icono de búsqueda
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 15),
            ),
            style: TextStyle(color: Colors.black),
            cursorColor: Colors.blue,
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _usuariosFiltrados.isEmpty
              ? Center(child: Text("No hay usuarios disponibles"))
              : Column(
                  children: [
                    Expanded(
                      // Aquí sí es correcto
                      child: ListView(
                        children: _obtenerUsuariosPaginados()
                            .asMap()
                            .entries
                            .map((entry) {
                          int index = (_paginaActual * _usuariosPorPagina) +
                              entry.key +
                              1;
                          return _buildUserTable(entry.value, index);
                        }).toList(),
                      ),
                    ),
                    _construirBotonesPaginacion(),
                  ],
                ),
    );
  }

  Widget _construirBotonesPaginacion() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_paginaActual > 0)
          GestureDetector(
            onTap: _paginaAnterior,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Blanco crema
                borderRadius: BorderRadius.circular(30), // Bordes redondeados
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              child: Text(
                "Anterior",
                style: TextStyle(
                  color: Colors.black, // Color del texto
                  fontSize: 16,
                ),
              ),
            ),
          ),
        SizedBox(width: 10),
        if ((_paginaActual + 1) * _usuariosPorPagina <
            _usuariosFiltrados.length)
          GestureDetector(
            onTap: _siguientePagina,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Blanco crema
                borderRadius: BorderRadius.circular(30), // Bordes redondeados
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              child: Text(
                "Siguiente",
                style: TextStyle(
                  color: Colors.black, // Color del texto
                  fontSize: 16,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUserTable(Usermodel user, int index) {
    // Alternar el color de la fila entre blanco y gris
    Color filaColor =
        const Color.fromARGB(255, 215, 226, 233); // Color para filas pares

    Color filaColor1 =
        const Color.fromARGB(255, 244, 244, 244); // Color para filas impares

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Table(
          border: TableBorder.all(
              color: const Color.fromARGB(99, 138, 138, 138),
              borderRadius: BorderRadius.circular(12)),
          columnWidths: {0: FlexColumnWidth(1), 1: FlexColumnWidth(2)},
          children: [
            EncabezadoTabla("Nombre de usuario", user.nombreUser, filaColor),
            EncabezadoTabla("Correo electronico", user.email, filaColor1),
            EncabezadoTabla("Rol", user.rol, filaColor),
            if (user.id != null) _buildActionRow(user),
          ],
        ),
      ),
    );
  }

  TableRow _buildActionRow(Usermodel user) {
    return TableRow(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 27, 27, 41), // Color para todo el TableRow
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              "Acciones",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Container(
            color: Color.fromARGB(255, 255, 255, 255),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Useredit(users: user),
                        ),
                      ).then((_) => _obtenerUsers());
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange),
                    child:
                        Text('Editar', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Mostrar la ventana de confirmación antes de eliminar
                      _mostrarConfirmacionEliminar(context, user);
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child:
                        Text('Eliminar', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ]);
  }
}
