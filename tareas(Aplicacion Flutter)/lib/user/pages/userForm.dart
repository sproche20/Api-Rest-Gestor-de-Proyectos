import 'package:tareas/enlaces.dart';

class Userform extends StatefulWidget {
  const Userform({super.key});

  @override
  State<Userform> createState() => _UserformState();
}

class _UserformState extends State<Userform> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? selectedRole;
  final Usercontroller usercontroller =
      Usercontroller(); //instancia del controlador
  //Metodo para nombres completos
  // Método para enviar datos a la API
  Future<void> guardarUsuario() async {
    String nombreCompleto =
        nameController.text.trim(); // Elimina espacios extra

    // Verificar que el nombre tenga al menos dos palabras
    List<String> partesNombre = nombreCompleto.split(RegExp(r'\s+'));
    if (partesNombre.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor ingrese nombre y apellido completos')),
      );
      return; // Sale de la función sin guardar
    }

    if (nombreCompleto.isEmpty ||
        emailController.text.isEmpty ||
        selectedRole == null) {
      // Mostrar mensaje si faltan campos
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor complete los campos')),
      );
      return;
    }

    Usermodel nuevoUsuario = Usermodel(
      nombreUser: nombreCompleto,
      email: emailController.text,
      rol: selectedRole!.toLowerCase(),
    );

    bool exito = await usercontroller.crearUser(nuevoUsuario);
    if (exito) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario guardado con éxito')),
      );
      // Limpiar campos
      nameController.clear();
      emailController.clear();
      setState(() {
        selectedRole = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al guardar usuario")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Campo de nombre
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre Usuario',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),

              // Campo de correo
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),

              // Dropdown de roles
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Rol',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                value: selectedRole,
                items: Listas.roles.map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Botón de Guardar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63), // Color amaranto
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: guardarUsuario,
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
