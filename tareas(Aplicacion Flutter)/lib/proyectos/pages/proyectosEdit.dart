import 'package:intl/intl.dart';

import '../../enlaces.dart';

class Proyectosedit extends StatefulWidget {
  final proyectoModel proyectos;
  const Proyectosedit({super.key, required this.proyectos});

  @override
  State<Proyectosedit> createState() => _ProyectoseditState();
}

class _ProyectoseditState extends State<Proyectosedit> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController fechaInicioController = TextEditingController();
  final TextEditingController fechaFinController = TextEditingController();
  String? selectdEstado;
  DateTime? fechaInicioSeleccionada;
  DateTime? fechaFinSeleccionada;
  final Proyectocontroller proyectocontroller = Proyectocontroller();

  @override
  void initState() {
    super.initState();

    nameController.text = widget.proyectos.nombreProyectos;
    fechaInicioSeleccionada = widget.proyectos.fechaInicio;
    descripcionController.text = widget.proyectos.descripcion;
    fechaInicioController.text =
        DateFormat('yyyy-MM-dd').format(widget.proyectos.fechaInicio);
    fechaFinSeleccionada = widget.proyectos.fechafin;
    fechaFinController.text =
        DateFormat('yyyy-MM-dd').format(widget.proyectos.fechafin);
    selectdEstado = Listas.estado.contains(widget.proyectos.estado)
        ? widget.proyectos.estado
        : null;
  }

  //funcion para mostrar el selector de fecha
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

  Future<void> _actualizarProyecto() async {
    if (widget.proyectos.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: el proyecto no tiene un ID válido')),
      );
      return;
    }

    if (nameController.text.isEmpty ||
        descripcionController.text.isEmpty ||
        fechaInicioSeleccionada == null ||
        fechaFinSeleccionada == null ||
        selectdEstado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, complete todos los campos')),
      );
      return;
    }

    if (fechaInicioSeleccionada!.isAfter(fechaFinSeleccionada!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('La fecha de inicio debe ser anterior a la fecha fin')),
      );
      return;
    }

    proyectoModel nuevoProyecto = proyectoModel(
      id: widget.proyectos.id,
      nombreProyectos: nameController.text,
      descripcion: descripcionController.text,
      fechaInicio: fechaInicioSeleccionada!,
      fechafin: fechaFinSeleccionada!,
      estado: selectdEstado!,
    );

    bool exito = await proyectocontroller.actualizarProyecto(
        widget.proyectos.id!, nuevoProyecto);

    if (exito) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Proyecto actualizado correctamente')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al actualizar el proyecto")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Proyectos Editar'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre Proyecto',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.assignment),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción Proyecto',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.description),
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
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                value: selectdEstado,
                items: Listas.estado.map((String estado) {
                  return DropdownMenuItem<String>(
                    value: estado,
                    child: Text(estado),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectdEstado = value;
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
                  onPressed: _actualizarProyecto,
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
