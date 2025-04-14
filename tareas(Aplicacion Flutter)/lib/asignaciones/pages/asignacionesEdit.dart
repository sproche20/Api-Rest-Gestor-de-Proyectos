import 'package:intl/intl.dart';

import '../../enlaces.dart';

class Asignacionesedit extends StatefulWidget {
  final Asignacionesmodel asignacion;
  const Asignacionesedit({super.key, required this.asignacion});

  @override
  State<Asignacionesedit> createState() => _AsignacioneseditState();
}

class _AsignacioneseditState extends State<Asignacionesedit> {
  final TextEditingController fechaAsignacionController =
      TextEditingController();
  int? selectedUsuarioId;
  int? selectedTareaId;
  DateTime? fechaAsignacionSeleccionada;
  final Asignacionescontroller asignacionescontroller =
      Asignacionescontroller();

  List<TareasModel> listaTareas = [];
  List<Usermodel> listaUsers = [];

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
    _cargarTareas();
    fechaAsignacionSeleccionada = widget.asignacion.fechaasing;
    fechaAsignacionController.text =
        DateFormat('yyyy-MM-dd').format(widget.asignacion.fechaasing);
    selectedUsuarioId = widget.asignacion.fkUser;
    selectedTareaId = widget.asignacion.fkTareas;
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? picked = await seleccionarFecha(context);
    if (picked != null) {
      setState(() {
        fechaAsignacionSeleccionada = picked;
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _cargarUsuarios() async {
    try {
      List<Usermodel> users = await asignacionescontroller.obtenerUsuario();
      setState(() {
        listaUsers = users;
      });
    } catch (e) {
      print("Error al cargar usuarios: $e");
    }
  }

  Future<void> _cargarTareas() async {
    try {
      List<TareasModel> tareas = await asignacionescontroller.obtenerTareas();
      setState(() {
        listaTareas = tareas;
      });
    } catch (e) {
      print("Error al cargar tareas: $e");
    }
  }

  Future<void> actualizarAsignacion() async {
    if (fechaAsignacionSeleccionada == null ||
        selectedUsuarioId == null ||
        selectedTareaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor complete los campos')),
      );
      return;
    }
    Asignacionesmodel nuevaAsignacion = Asignacionesmodel(
      id: widget.asignacion.id,
      fechaasing: fechaAsignacionSeleccionada!,
      fkUser: selectedUsuarioId!,
      fkTareas: selectedTareaId!,
    );
    bool exito = await asignacionescontroller.actualizarAsignaciones(
        widget.asignacion.id!, nuevaAsignacion);
    if (exito) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Asignación actualizada correctamente')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al actualizar la asignación")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Editar Asignación"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              TextField(
                controller: fechaAsignacionController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Fecha Asignación',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () =>
                        _selectDate(context, fechaAsignacionController),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Usuario',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                value: selectedUsuarioId,
                items: listaUsers.map((Usermodel user) {
                  return DropdownMenuItem<int>(
                    value: user.id,
                    child: Text(user.nombreUser),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedUsuarioId = value;
                  });
                },
                menuMaxHeight: 300,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Tarea',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                value: selectedTareaId,
                items: listaTareas.map((TareasModel tarea) {
                  return DropdownMenuItem<int>(
                    value: tarea.id,
                    child: Text(tarea.nombreTarea),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTareaId = value;
                  });
                },
                menuMaxHeight: 300,
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
                  onPressed: actualizarAsignacion,
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
