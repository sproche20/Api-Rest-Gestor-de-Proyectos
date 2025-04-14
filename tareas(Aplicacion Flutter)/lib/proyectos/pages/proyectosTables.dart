import 'package:intl/intl.dart';

import '../../enlaces.dart';

class Proyectostables extends StatefulWidget {
  const Proyectostables({super.key});

  @override
  State<Proyectostables> createState() => _ProyectostablesState();
}

class _ProyectostablesState extends State<Proyectostables> {
  final Proyectocontroller _proyectoController = Proyectocontroller();
  final TextEditingController _buscarController = TextEditingController();
  List<proyectoModel> _proyectos = [];
  List<proyectoModel> _proyectosFiltrados = [];
  bool _isLoading = true;
  //variable de paginacion
  int _paginaActual = 0;
  final int _proyectosPorPagina = 6; // Máximo de usuarios por página
  @override
  void initState() {
    super.initState();
    _obtenerProyectos();
    //agregar listener al campo de busqueda
    _buscarController.addListener(() {
      _filtrarProyectos(_buscarController.text);
    });
  }

  Future<void> _obtenerProyectos() async {
    try {
      List<proyectoModel> proyectos =
          await _proyectoController.obtenerProyectos();
      if (!mounted) return;
      setState(() {
        _proyectos = proyectos;
        _proyectosFiltrados = proyectos;
        _isLoading = false;
      });
    } catch (e) {
      print("Error al obtener Proyectos:$e");
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filtrarProyectos(String query) {
    if (query.isEmpty) {
      setState(() {
        _proyectosFiltrados = _proyectos;
      });
    } else {
      setState(() {
        _proyectosFiltrados = _proyectos
            .where((proyecto) => proyecto.nombreProyectos
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      });
    }
    _paginaActual = 0; // Reiniciar la paginación al filtrar
  }

  List<proyectoModel> _obtenerProyectosPaginados() {
    int inicio = _paginaActual * _proyectosPorPagina;
    if (inicio >= _proyectosFiltrados.length) {
      return [];
    }
    int fin = inicio + _proyectosPorPagina;
    return _proyectosFiltrados.sublist(inicio,
        fin > _proyectosFiltrados.length ? _proyectosFiltrados.length : fin);
  }

  void _siguientePagina() {
    if ((_paginaActual + 1) * _proyectosPorPagina <
        _proyectosFiltrados.length) {
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

  Future<void> _eliminarProyecto(BuildContext context, int proyectoId) async {
    try {
      bool eliminado = await _proyectoController.eliminarProyecto(proyectoId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(eliminado
              ? "Proyecto eliminado con exito"
              : "error al eliminar el proyecto")));
      if (eliminado) _obtenerProyectos();
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al eliminar el usuario $e")));
    }
  }

  //Metodo para mostrar el dialogo de confirmacion
  void _mostrarConfirmacionEliminar(
      BuildContext context, proyectoModel proyectos) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirmacion"),
            content:
                Text("¿Estás seguro de que quieres eliminar a este Proyecto?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancelar"),
              ),
              TextButton(
                  onPressed: () {
                    //si se acepta, eliminamos el usuario
                    if (proyectos.id != null) {
                      _eliminarProyecto(context, proyectos.id!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("ID de proyecto no valido")),
                      );
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text("Aceptar"))
            ],
          );
        });
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
                hintText: "Buscar Proyecto...",
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
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _proyectosFiltrados.isEmpty
                ? Center(child: Text("No hay Proyectos disponibles"))
                : Column(
                    children: [
                      Expanded(
                          child: ListView(
                        children: _obtenerProyectosPaginados()
                            .asMap()
                            .entries
                            .map((entry) {
                          int index = (_paginaActual * _proyectosPorPagina) +
                              entry.key +
                              1;
                          return _buildProyectoTable(entry.value, index);
                        }).toList(),
                      )),
                      _construirBotonesPaginacion(),
                    ],
                  ));
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
        if ((_paginaActual + 1) * _proyectosPorPagina <
            _proyectosFiltrados.length)
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

  TableRow _buildTableRow(String title, dynamic value) {
    // ignore: unused_local_variable
    String displayValue;
    //verificar si el valor es datetime y lo formateo
    if (value is DateTime) {
      displayValue = DateFormat('dd/MM/yyyy').format(value);
    } else {
      displayValue = value.toString();
    }
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(value),
      ),
    ]);
  }

  Widget _buildProyectoTable(proyectoModel proyecto, int index) {
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
        child: Container(
          color:
              Color.fromARGB(255, 27, 27, 41), // Color para todo el TableRow,
          child: Table(
            border: TableBorder.all(
                color: const Color.fromARGB(99, 138, 138, 138),
                borderRadius: BorderRadius.circular(12)),
            columnWidths: {0: FlexColumnWidth(1), 1: FlexColumnWidth(2)},
            children: [
              EncabezadoTabla(
                  "Nombre del Proyecto", proyecto.nombreProyectos, filaColor),
              EncabezadoTabla(
                  "Descripcion del proyecto", proyecto.descripcion, filaColor1),
              EncabezadoTabla(
                  "Fecha de Inicio",
                  DateFormat('dd/MM/yyyy').format(proyecto.fechaInicio),
                  filaColor),
              EncabezadoTabla(
                  "Fecha de Fin",
                  DateFormat('dd/MM/yyyy').format(proyecto.fechafin),
                  filaColor1),
              EncabezadoTabla("Estado", proyecto.estado, filaColor),
              if (proyecto.id != null) _buildActionRow(proyecto),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildActionRow(proyectoModel proyectos) {
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
                                    builder: (context) =>
                                        Proyectosedit(proyectos: proyectos)))
                            .then((_) {
                          _obtenerProyectos();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange),
                      child: Text('Editar',
                          style: TextStyle(color: Colors.white))),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _mostrarConfirmacionEliminar(context, proyectos);
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child:
                        Text('Eliminar', style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
          )
        ]);
  }
}
