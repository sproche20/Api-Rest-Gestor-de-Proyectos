import 'package:intl/intl.dart';

import '../../enlaces.dart';

class Histcambioedit extends StatefulWidget {
  final Histcambiosmodel histCambio;
  const Histcambioedit({super.key, required this.histCambio});

  @override
  State<Histcambioedit> createState() => _HistcambioeditState();
}

class _HistcambioeditState extends State<Histcambioedit> {
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController fechaCambioController = TextEditingController();
  final HistCambiosController histCambiosController = HistCambiosController();

  int? selectedTipoCambio;
  int? selectedProyectoId;
  int? selectedUserId;
  DateTime? fechaCambioSeleccionada;

  List<Usermodel> listaUsers = [];
  List<proyectoModel> listaProyectos = [];

  @override
  void initState() {
    super.initState();
    _cargarProyectos();
    _cargarUsuarios();

    descripcionController.text = widget.histCambio.descripcion;
    fechaCambioSeleccionada = widget.histCambio.fechacambio;
    fechaCambioController.text =
        DateFormat('yyyy-MM-dd').format(widget.histCambio.fechacambio);
    selectedProyectoId = widget.histCambio.fkProyectos;
    selectedUserId = widget.histCambio.fkUser;
    selectedTipoCambio = widget.histCambio.tipocambio;
  }

  Future<void> _cargarProyectos() async {
    try {
      List<proyectoModel> proyectos =
          await histCambiosController.obtenerProyectos();
      setState(() {
        listaProyectos = proyectos;
      });
    } catch (e) {
      print("Error al cargar proyectos: $e");
    }
  }

  Future<void> _cargarUsuarios() async {
    try {
      List<Usermodel> users = await histCambiosController.obtenerUsuario();
      setState(() {
        listaUsers = users;
      });
    } catch (e) {
      print("Error al cargar usuarios: $e");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await seleccionarFecha(context);
    if (picked != null) {
      setState(() {
        fechaCambioSeleccionada = picked;
        fechaCambioController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> actualizarHistCambio() async {
    if (selectedTipoCambio == null ||
        descripcionController.text.isEmpty ||
        fechaCambioSeleccionada == null ||
        selectedProyectoId == null ||
        selectedUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos')),
      );
      return;
    }

    Histcambiosmodel nuevoHistCambio = Histcambiosmodel(
      id: widget.histCambio.id,
      descripcion: descripcionController.text,
      fechacambio: fechaCambioSeleccionada!,
      tipocambio: selectedTipoCambio!,
      fkProyectos: selectedProyectoId!,
      fkUser: selectedUserId!,
    );

    try {
      bool exito = await histCambiosController.actualizarHistCambio(
          nuevoHistCambio.id!, nuevoHistCambio);
      if (exito) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Historial de cambio actualizado correctamente')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error al actualizar el historial de cambio')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Error inesperado al actualizar el historial de cambio')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Editar Cambio'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Tipo de Cambio',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                value: selectedTipoCambio,
                items: Listas.tiposCambios.map((tipo) {
                  return DropdownMenuItem<int>(
                    value: tipo['id'],
                    child: Text(tipo['descripcion']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTipoCambio = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: fechaCambioController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Fecha de Cambio',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  suffixIcon: IconButton(
                    onPressed: () => _selectDate(context),
                    icon: const Icon(Icons.calendar_today),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción del Cambio',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 5, // Permite hasta 5 líneas de texto
                minLines: 3, // Mínimo 3 líneas de texto visibles
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
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Usuario',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                value: selectedUserId,
                items: listaUsers.map((Usermodel user) {
                  return DropdownMenuItem<int>(
                    value: user.id,
                    child: Text(user.nombreUser),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedUserId = value;
                  });
                },
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
                  onPressed: actualizarHistCambio,
                  child: const Text('Actualizar',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
