import '../enlaces.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int _selectedIndex = 0;

  // Mapeo de las categorías principales con sus iconos
  final Map<int, Map<String, dynamic>> _menuTitles = {
    0: {"title": "Inicio", "icon": Icons.home},
    1: {"title": "Usuario", "icon": Icons.person},
    2: {"title": "Usuario", "icon": Icons.person},
    3: {"title": "Proyectos", "icon": Icons.work},
    4: {"title": "Proyectos", "icon": Icons.work},
    5: {"title": "Tareas", "icon": Icons.task},
    6: {"title": "Tareas", "icon": Icons.task},
    7: {"title": "Asignaciones", "icon": Icons.assignment},
    8: {"title": "Asignaciones", "icon": Icons.assignment},
    9: {"title": "Gestión de Cambios", "icon": Icons.change_circle_outlined},
    10: {"title": "Gestión de Cambios", "icon": Icons.change_circle_outlined},
  };

  final List<Widget> _pages = [
    Inicio(),
    Userform(),
    Usertables(),
    Proyectosform(),
    Proyectostables(),
    Tareasform(),
    Tareastable(),
    Asignacionesform(),
    Asignacionestable(),
    Histcambiosform(),
    Histcambiostable(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(_menuTitles[_selectedIndex]!["icon"], color: Colors.black),
            const SizedBox(width: 8),
            Text(
              _menuTitles[_selectedIndex]!["title"],
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: const Text('Nombre de Usuario'),
              accountEmail: const Text('usuario@email.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: const Color(0xFFE91E63),
                ),
              ),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 27, 27, 41),
              ),
            ),
            _buildExpansionTile(Icons.person, 'Usuario', 1, 2),
            _buildExpansionTile(Icons.work, 'Proyectos', 3, 4),
            _buildExpansionTile(Icons.task, 'Tareas', 5, 6),
            _buildExpansionTile(Icons.assignment, 'Asignaciones', 7, 8),
            _buildExpansionTile(
                Icons.change_circle_outlined, 'Gestión de Cambios', 9, 10),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }

  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  Widget _buildExpansionTile(
      IconData icon, String title, int index1, int index2) {
    return ExpansionTile(
      leading: Icon(icon),
      title: Text(title),
      children: [
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text('Formulario'),
          onTap: () => _selectPage(index1),
        ),
        ListTile(
          leading: const Icon(Icons.table_chart),
          title: const Text('Tabla'),
          onTap: () => _selectPage(index2),
        ),
      ],
    );
  }
}
