import 'package:intl/intl.dart';

import '../../enlaces.dart';

class Histcambiostable extends StatefulWidget {
  const Histcambiostable({super.key});

  @override
  State<Histcambiostable> createState() => _HistcambiostableState();
}

class _HistcambiostableState extends State<Histcambiostable> {
  final HistCambiosController _cambiosController = HistCambiosController();
  final TextEditingController _buscarController = TextEditingController();
  List<Histcambiosmodel> _histCambios = [];
  List<Histcambiosmodel> _histCambiosFiltrada = [];
  bool _isLoading = true;
  //variable de paginacion
  int _paginaActual = 0;
  final int _histCambiosPorPaginas = 6;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _obtenerHistCambios();

    //agregar listener al campo de busqueda
    _buscarController.addListener(() {
      _filtrarHistCambios(_buscarController.text);
    });
  }

  Future<void> _obtenerHistCambios() async {
    try {
      List<Histcambiosmodel> histCambios =
          await _cambiosController.obtenerHistCambios();
      if (!mounted) return; // ✅ Verificación antes de procesar los datos

      // Obtener nombres del proyecto, usuario y tipo de cambio en paralelo
      await Future.wait(histCambios.map((cambio) async {
        final nombres = await Future.wait([
          _cambiosController.obtenerNombreProyecto(cambio.fkProyectos),
          _cambiosController.obtenerNombreUsuario(cambio.fkUser),
        ]);

        cambio.nombreProyectos = nombres[0];
        cambio.nombreUser = nombres[1];
        // Asignar la descripción del tipo de cambio
        cambio.nombreTipoCambio =
            _obtenerDescripcionTipoCambio(cambio.tipocambio);
      }));
      if (!mounted) return; // ✅ Verificación antes de actualizar el estado
      setState(() {
        _histCambios = histCambios;
        _histCambiosFiltrada = List.from(_histCambios);
        _isLoading = false;
      });
    } catch (e) {
      print("Error al obtener los historiales de cambio: $e");
      if (!mounted) return; // ✅ Evita setState si el widget ya no está
      setState(() => _isLoading = false);
    }
  }

  void _filtrarHistCambios(String query) {
    setState(() {
      if (query.isEmpty) {
        // Cuando la búsqueda está vacía, mostrar todos los elementos
        _histCambiosFiltrada = List.from(_histCambios);
      } else {
        // Filtrar los cambios basados en los nombres de usuario o proyecto
        _histCambiosFiltrada = _histCambios.where((cambios) {
          return (cambios.nombreUser != null &&
              cambios.nombreProyectos != null &&
              (cambios.nombreUser!
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  cambios.nombreProyectos!
                      .toLowerCase()
                      .contains(query.toLowerCase())));
        }).toList();
      }
      // Resetear la paginación al filtrar
      _paginaActual = 0;
    });
  }

  List<Histcambiosmodel> _obtenerHistCambiosPaginadas() {
    int inicio = _paginaActual * _histCambiosPorPaginas;
    if (inicio >= _histCambiosFiltrada.length) {
      return [];
    }
    int fin = inicio + _histCambiosPorPaginas;
    return _histCambiosFiltrada.sublist(inicio,
        fin > _histCambiosFiltrada.length ? _histCambiosFiltrada.length : fin);
  }

  void _siguientePagina() {
    if ((_paginaActual + 1) * _histCambiosPorPaginas <
        _histCambiosFiltrada.length) {
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

  String _obtenerDescripcionTipoCambio(int id) {
    final tipo = Listas.tiposCambios.firstWhere(
      (tipo) => tipo['id'] == id,
      orElse: () => {'descripcion': 'Desconocido'},
    );
    return tipo['descripcion'];
  }

  Future<void> _eliminarHistCambio(int histCambioId) async {
    bool? confirmacion = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Eliminar HistCambio"),
              content: Text("¿Estás seguro de que deseas eliminar este dato?"),
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
            ));
    if (confirmacion == true) {
      try {
        // Llamar al controlador para eliminar el cambio
        await _cambiosController.eliminarHistCambio(histCambioId);

        // Actualizar las listas
        setState(() {
          _histCambios.removeWhere((cambio) => cambio.id == histCambioId);
          _histCambiosFiltrada = List.from(_histCambios);

          // Ajustar la paginación si es necesario
          if ((_paginaActual + 1) * _histCambiosPorPaginas >
              _histCambiosFiltrada.length) {
            _paginaActual = (_paginaActual > 0) ? _paginaActual - 1 : 0;
          }
        });
      } catch (e) {
        print("Error al eliminar el historial de cambio: $e");
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
                hintText: "Buscar por Proyectos o usuarios...",
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
            : _histCambios.isEmpty
                ? Center(
                    child: Text("No hay HistCambios disponibles"),
                  )
                : Column(
                    children: [
                      Expanded(
                          child: ListView(
                              children: _obtenerHistCambiosPaginadas()
                                  .asMap()
                                  .entries
                                  .map((entry) {
                        int index = (_paginaActual * _histCambiosPorPaginas) +
                            entry.key +
                            1;
                        return _buildHistCambiosTable(entry.value, index);
                      }).toList())),
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
        if ((_paginaActual + 1) * _histCambiosPorPaginas <
            _histCambiosFiltrada.length)
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

  Widget _buildHistCambiosTable(Histcambiosmodel histCambio, int index) {
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
            EncabezadoTabla("Proyecto Asociado",
                histCambio.nombreProyectos ?? "N/A", filaColor),
            EncabezadoTabla(
                "Usuario", histCambio.nombreUser ?? "Desconocido", filaColor1),
            EncabezadoTabla("Tipo de Cambio",
                histCambio.nombreTipoCambio ?? "Desconocido", filaColor),
            EncabezadoTabla("Descripción del Cambio Realizado",
                histCambio.descripcion, filaColor1),
            EncabezadoTabla(
                "Fecha",
                DateFormat('yyyy-MM-dd').format(histCambio.fechacambio),
                filaColor),
            _buildActionRow(histCambio),
          ],
        ),
      ),
    );
  }

  TableRow _buildActionRow(Histcambiosmodel histCambio) {
    return TableRow(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 27, 27, 41), // Color para todo el TableRow
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            "Acciones",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Container(
          color: Color.fromARGB(
              255, 255, 255, 255), // Fondo para la parte de botones
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.start, // Alineación de los botones
            children: [
              ElevatedButton(
                onPressed: () {
                  // Navegar a la pantalla de edición
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Histcambioedit(histCambio: histCambio),
                    ),
                  ).then((_) {
                    // Recargar la lista de asignaciones después de editar
                    _obtenerHistCambios();
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: Text('Editar', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _eliminarHistCambio(histCambio.id!),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text('Eliminar', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
