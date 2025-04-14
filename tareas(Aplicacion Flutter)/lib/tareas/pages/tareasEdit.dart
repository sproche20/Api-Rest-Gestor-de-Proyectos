import 'package:intl/intl.dart';

import '../../enlaces.dart';

class Tareasedit extends StatefulWidget {
  final TareasModel tarea;
  const Tareasedit({super.key, required this.tarea});

  @override
  State<Tareasedit> createState() => _TareaseditState();
}

class _TareaseditState extends State<Tareasedit> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController fechaInicioController = TextEditingController();
  final TextEditingController fechaFinController = TextEditingController();
  final Tareascontroller tareascontroller = Tareascontroller();
  String? selectedEstado;
  int? selectedProyectoId;
  DateTime? fechaInicioSeleccionada;
  DateTime? fechaFinSeleccionada;

  List<proyectoModel> listaProyectos = [];

  @override
  void initState() {
    super.initState();
    _cargarProyectos();
    Listas.estado = Listas.estado.toSet().toList();
    nameController.text = widget.tarea.nombreTarea;
    descripcionController.text = widget.tarea.descripcion;
    fechaInicioSeleccionada = widget.tarea.fechaInicio;
    fechaInicioController.text =
        DateFormat('yyyy-MM-dd').format(widget.tarea.fechaInicio);
    fechaFinSeleccionada = widget.tarea.fechaFin;
    fechaFinController.text =
        DateFormat('yyyy-MM-dd').format(widget.tarea.fechaFin);
    selectedEstado = Listas.estado.contains(widget.tarea.estado)
        ? widget.tarea.estado
        : null;
    selectedProyectoId = widget.tarea.fkProyectos;
  }

  Future<void> _selectDate(BuildContext context,
      TextEditingController controller, bool isStarDate) async {
    DateTime? picked = await seleccionarFecha(context);
    if (picked != null) {
      setState(() {
        final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        controller.text = formattedDate;
        if (isStarDate) {
          fechaInicioSeleccionada = picked;
        } else {
          fechaFinSeleccionada = picked;
        }
      });
    }
  }

  Future<void> _cargarProyectos() async {
    try {
      List<proyectoModel> proyectos = await tareascontroller.obtenerProyectos();
      setState(() {
        listaProyectos = proyectos;
      });
    } catch (e) {
      print("Error al cargar proyectos: $e");
    }
  }

  Future<void> actualizarTarea() async {
    if (widget.tarea.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: La tarea no tiene un ID válido')));
      return;
    }
    if (!Listas.estado.contains(selectedEstado)) {
      selectedEstado = null;
    }

    if (nameController.text.isEmpty ||
        descripcionController.text.isEmpty ||
        fechaInicioSeleccionada == null ||
        fechaFinSeleccionada == null ||
        selectedEstado == null ||
        selectedProyectoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor complete los campos')));
      return;
    }
    if (fechaInicioSeleccionada!.isAfter(fechaFinSeleccionada!)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('La fecha de inicio debe ser anterior a la fecha fin')));
      return;
    }

    TareasModel nuevaTarea = TareasModel(
      id: widget.tarea.id,
      nombreTarea: nameController.text,
      descripcion: descripcionController.text,
      fechaInicio: fechaInicioSeleccionada!,
      fechaFin: fechaFinSeleccionada!,
      estado: selectedEstado!.toLowerCase(),
      fkProyectos: selectedProyectoId!,
    );
    bool exito =
        await tareascontroller.actualizarTarea(widget.tarea.id!, nuevaTarea);
    if (exito) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tarea actualizada correctamente')));
      Navigator.pop(context); // Volver a la pantalla anterior
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al actualizar la Tarea")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Editar Tarea"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre Tarea',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.assignment),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 5, // Permite hasta 5 líneas de texto
                minLines: 3, // Mínimo 3 líneas de texto visibles
              ),
              const SizedBox(height: 12),
              TextField(
                controller: fechaInicioController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Fecha Inicio',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () =>
                        _selectDate(context, fechaInicioController, true),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: fechaFinController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Fecha Fin',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () =>
                        _selectDate(context, fechaFinController, false),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Estado',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                value: Listas.estado.contains(selectedEstado)
                    ? selectedEstado
                    : null,
                items: Listas.estado.map((String estado) {
                  return DropdownMenuItem<String>(
                      value: estado, child: Text(estado));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedEstado = value;
                  });
                },
                menuMaxHeight: 300, // Limita la altura máxima del menú
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Proyecto',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                value: selectedProyectoId,
                items: listaProyectos.map((proyectoModel proyecto) {
                  return DropdownMenuItem<int>(
                    value: proyecto.id,
                    child: Text(proyecto.nombreProyectos),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedProyectoId = value;
                  });
                },
                menuMaxHeight: 300, // Limita la altura máxima del menú
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: actualizarTarea,
                  child: const Text(
                    'Actualizar',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
