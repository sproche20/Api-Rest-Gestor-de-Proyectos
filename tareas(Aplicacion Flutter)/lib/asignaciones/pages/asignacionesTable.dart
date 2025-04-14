import 'package:intl/intl.dart';

import '../../enlaces.dart';

class Asignacionestable extends StatefulWidget {
  const Asignacionestable({super.key});

  @override
  State<Asignacionestable> createState() => _AsignacionestableState();
}

class _AsignacionestableState extends State<Asignacionestable> {
  final Asignacionescontroller _asignacionescontroller =
      Asignacionescontroller();
  final TextEditingController _buscarController = TextEditingController();
  List<Asignacionesmodel> _asignaciones = [];
  List<Asignacionesmodel> _asignacionesFiltradas = [];
  bool _isLoading = true;
  //variable de paginacion
  int _paginaActual = 0;
  final int _asignacionesPorPaginas = 6;

  @override
  void initState() {
    super.initState();
    _obtenerAsignaciones();
    //agregar listener al campo de busqueda
    _buscarController.addListener(() {
      _filtrarAsignaciones(_buscarController.text);
    });
  }

  Future<void> _obtenerAsignaciones() async {
    try {
      List<Asignacionesmodel> asignaciones =
          await _asignacionescontroller.obtenerAsignaciones();
      if (!mounted) return; // ✅ Verificación antes de procesar los datos
      // Obtener nombres de usuarios y tareas en paralelo
      await Future.wait(asignaciones.map((asignacion) async {
        final nombres = await Future.wait([
          _asignacionescontroller.obtenerNombreUsuario(asignacion.fkUser),
          _asignacionescontroller.obtenerNombreTarea(asignacion.fkTareas),
        ]);
        asignacion.nombreUser = nombres[0];
        asignacion.nombreTarea = nombres[1];
      }));
      if (!mounted) return; // ✅ Verificación antes de actualizar el estado
      setState(() {
        _asignaciones = asignaciones;
        _asignacionesFiltradas = List.from(
            _asignaciones); // Asegurando que las asignaciones filtradas contengan las asignaciones iniciales
        _isLoading = false;
      });
    } catch (e) {
      print("Error al obtener las asignaciones: $e");
      if (!mounted) return; // ✅ Evita setState si el widget ya no está
      setState(() => _isLoading = false);
    }
  }

  void _filtrarAsignaciones(String query) {
    setState(() {
      if (query.isEmpty) {
        _asignacionesFiltradas = List.from(_asignaciones);
      } else {
        _asignacionesFiltradas = _asignaciones.where((asignacion) {
          return asignacion.nombreUser != null &&
              asignacion.nombreTarea != null &&
              (asignacion.nombreUser!
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  asignacion.nombreTarea!
                      .toLowerCase()
                      .contains(query.toLowerCase()));
        }).toList();
      }
      _paginaActual = 0; // Reinicia la paginación al buscar
    });
  }

  List<Asignacionesmodel> _obtenerAsignacionesPaginadas() {
    int inicio = _paginaActual * _asignacionesPorPaginas;
    if (inicio >= _asignacionesFiltradas.length) {
      return [];
    }
    int fin = inicio + _asignacionesPorPaginas;
    return _asignacionesFiltradas.sublist(
        inicio,
        fin > _asignacionesFiltradas.length
            ? _asignacionesFiltradas.length
            : fin);
  }

  void _siguientePagina() {
    if ((_paginaActual + 1) * _asignacionesPorPaginas <
        _asignacionesFiltradas.length) {
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

  Future<void> _eliminarAsignacion(int asignacionId) async {
    bool? confirmacion = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Eliminar Asignación"),
        content: Text("¿Estás seguro de que deseas eliminar esta asignación?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmacion == true) {
      try {
        // Eliminar la asignación en la base de datos
        await _asignacionescontroller.eliminarAsignacion(asignacionId);

        // Actualizar la lista de asignaciones en el estado
        setState(() {
          // Eliminar de la lista original
          _asignaciones
              .removeWhere((asignacion) => asignacion.id == asignacionId);

          // Eliminar de la lista filtrada
          _asignacionesFiltradas
              .removeWhere((asignacion) => asignacion.id == asignacionId);
        });

        // Si quieres recargar la lista completa en caso de que haya cambios en la base de datos:
        // _obtenerAsignaciones();
      } catch (e) {
        print("Error al eliminar la asignación: $e");
      }
    }
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
                hintText: "Buscar por tareas o usuarios...",
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
            : _asignaciones.isEmpty
                ? Center(child: Text("No hay asignaciones disponibles"))
                : Column(
                    children: [
                      Expanded(
                          child: ListView(
                        children: _obtenerAsignacionesPaginadas()
                            .asMap()
                            .entries
                            .map((entry) {
                          int index =
                              (_paginaActual * _asignacionesPorPaginas) +
                                  entry.key +
                                  1;
                          return _buildAsignacionTable(entry.value, index);
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
        if ((_paginaActual + 1) * _asignacionesPorPaginas <
            _asignacionesFiltradas.length)
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

  Widget _buildAsignacionTable(Asignacionesmodel asignacion, int index) {
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
            EncabezadoTabla(
                "Fecha",
                DateFormat('dd/MM/yyyy').format(asignacion.fechaasing),
                filaColor),
            EncabezadoTabla(
                "Usuario", asignacion.nombreUser ?? "N/A", filaColor1),
            EncabezadoTabla(
                "Tarea", asignacion.nombreTarea ?? "N/A", filaColor),
            if (asignacion.id != null) _buildActionRow(asignacion)
          ],
        ),
      ),
    );
  }

  TableRow _buildActionRow(Asignacionesmodel asignacion) {
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
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    //navegar a la pantalla de edicion enviando la asignacion seleccionada
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Asignacionesedit(asignacion: asignacion)),
                    ).then((_) {
                      //recargar la lista de asignaciones despues de editar
                      _obtenerAsignaciones();
                    });
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: Text('Editar', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _eliminarAsignacion(asignacion.id!),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child:
                      Text('Eliminar', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ]);
  }
}
