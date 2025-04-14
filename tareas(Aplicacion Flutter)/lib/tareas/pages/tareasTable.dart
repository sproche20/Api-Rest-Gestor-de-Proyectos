import 'package:intl/intl.dart';
import '../../enlaces.dart';

class Tareastable extends StatefulWidget {
  const Tareastable({super.key});

  @override
  State<Tareastable> createState() => _TareastableState();
}

class _TareastableState extends State<Tareastable> {
  final Tareascontroller _tareascontroller = Tareascontroller();
  final TextEditingController _buscarController = TextEditingController();
  List<TareasModel> _tareas = [];
  List<TareasModel> _tareasFiltradas = [];
  bool _isLoading = true;
  //variable de paginacion
  int _paginaActual = 0;
  final int _tareasPorPaginas = 6;
  @override
  void initState() {
    super.initState();
    _obtenerTareas();
    //agregar listener al campo de busqueda
    _buscarController.addListener(() {
      _filtrarTareas(_buscarController.text);
    });
  }

  Future<void> _obtenerTareas() async {
    try {
      List<TareasModel> tareas = await _tareascontroller.obtenerTareas();
      if (!mounted) return; // ✅ Verificación antes de procesar los datos

      // Obtener nombre de los proyectos
      await Future.wait(tareas.map((tarea) async {
        final nombres = await Future.wait(
            [_tareascontroller.obtenerNombreProyectos(tarea.fkProyectos)]);
        tarea.nombreProyectos = nombres[0];
      }));

      if (!mounted) return; // ✅ Verificación antes de actualizar el estado
      setState(() {
        _tareas = tareas;
        _tareasFiltradas = tareas;
        _isLoading = false;
      });
    } catch (e) {
      print("Error al obtener las tareas: $e");
      if (!mounted) return; // ✅ Evita setState si el widget ya no está
      setState(() => _isLoading = false);
    }
  }

  void _filtrarTareas(String query) {
    setState(() {
      if (query.isEmpty) {
        _tareasFiltradas = List.from(_tareas);
      } else {
        _tareasFiltradas = _tareas
            .where((tarea) =>
                tarea.nombreTarea.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      _paginaActual = 0; // Reinicia la paginación al buscar
    });
  }

  List<TareasModel> _obtenerTareasPaginadas() {
    int inicio = _paginaActual * _tareasPorPaginas;
    if (inicio >= _tareasFiltradas.length) {
      return [];
    }
    int fin = inicio + _tareasPorPaginas;
    return _tareasFiltradas.sublist(
        inicio, fin > _tareasFiltradas.length ? _tareasFiltradas.length : fin);
  }

  void _siguientePagina() {
    if ((_paginaActual + 1) * _tareasPorPaginas < _tareasFiltradas.length) {
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

  Future<void> _eliminarTarea(BuildContext context, int tareaId) async {
    try {
      bool eliminado = await _tareascontroller.eliminarTarea(tareaId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(eliminado
              ? "Tarea eliminada con exito"
              : "error al eliminar la tarea")));
      if (eliminado) _obtenerTareas();
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al eliminar el usuario $e")));
    }
  }

  //Metodo para mostrar el dialogo de confirmacion
  void _mostrarConfirmacionEliminar(BuildContext context, TareasModel tareas) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirmacion"),
            content:
                Text("¿Estás seguro de que quieres eliminar a esta tarea?"),
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
                    if (tareas.id != null) {
                      _eliminarTarea(context, tareas.id!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("ID de tarea no valida")),
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
                hintText: "Buscar tareas...",
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
            : _tareasFiltradas.isEmpty
                ? Center(child: Text("No hay tareas disponibles"))
                : Column(
                    children: [
                      Expanded(
                          child: ListView(
                        children: _obtenerTareasPaginadas()
                            .asMap()
                            .entries
                            .map((entry) {
                          int index = (_paginaActual * _tareasPorPaginas) +
                              entry.key +
                              1;
                          return _buildTareaTable(entry.value, index);
                        }).toList(),
                      )),
                      _construirBotonesPaginacion()
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
        if ((_paginaActual + 1) * _tareasPorPaginas < _tareasFiltradas.length)
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

  Widget _buildTareaTable(TareasModel tarea, int index) {
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
            EncabezadoTabla("Tarea", tarea.nombreTarea, filaColor),
            EncabezadoTabla("Descripcion de la Tarea a desarrollar",
                tarea.descripcion, filaColor1),
            EncabezadoTabla("Fecha Inicio",
                DateFormat('dd/MM/yyyy').format(tarea.fechaInicio), filaColor),
            EncabezadoTabla("Fecha de Finalizacion",
                DateFormat('dd/MM/yyyy').format(tarea.fechaFin), filaColor1),
            EncabezadoTabla("Estado", tarea.estado, filaColor),
            EncabezadoTabla("Proyecto Asociado", tarea.nombreProyectos ?? "N/A",
                filaColor1),
            if (tarea.id != null) _buildActionRow(tarea)
          ],
        ),
      ),
    );
  }

  TableRow _buildActionRow(TareasModel tareas) {
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
            color: const Color.fromARGB(255, 215, 226, 233),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      //navegar a la pantalla de edicion enviando la tarea seleccionada
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Tareasedit(tarea: tareas))).then((_) {
                        _obtenerTareas();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange),
                    child:
                        Text('Editar', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      _mostrarConfirmacionEliminar(context, tareas);
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
