import 'package:intl/intl.dart';

import '../../enlaces.dart';

class Asignacionesform extends StatefulWidget {
  const Asignacionesform({super.key});

  @override
  State<Asignacionesform> createState() => _AsignacionesformState();
}

class _AsignacionesformState extends State<Asignacionesform> {
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

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await seleccionarFecha(context);
    if (picked != null) {
      setState(() {
        fechaAsignacionSeleccionada = picked;
        fechaAsignacionController.text =
            DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> guardarAsignaciones() async {
    if (fechaAsignacionSeleccionada == null ||
        selectedUsuarioId == null ||
        selectedTareaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor complete los campos')),
      );
      return;
    }

    Asignacionesmodel nuevaAsignacion = Asignacionesmodel(
      fechaasing: fechaAsignacionSeleccionada!,
      fkUser: selectedUsuarioId!,
      fkTareas: selectedTareaId!,
    );

    try {
      bool exito =
          await asignacionescontroller.crearAsignacion(nuevaAsignacion);
      if (exito) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Asignación creada correctamente')),
        );
        fechaAsignacionController.clear();
        setState(() {
          selectedUsuarioId = null;
          selectedTareaId = null;
          fechaAsignacionSeleccionada = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al guardar la asignación")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error inesperado al guardar la asignación")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Crear Asignación'),
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
                    onPressed: () => _selectDate(context),
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
                menuMaxHeight: 300, // Limita la altura máxima del menú
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
                  onPressed: guardarAsignaciones,
                  child: const Text(
                    'Guardar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
