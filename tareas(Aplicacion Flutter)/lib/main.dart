import 'enlaces.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: const Menu(),
      //initialRoute: 'userTable',
      routes: {
        'inicio': (context) => Inicio(),
        'userForm': (context) => Userform(),
        'userTable': (context) => Usertables(),
        'ProyectoForm': (context) => Proyectosform(),
        'proyectoTable': (context) => Proyectostables(),
        'tareasForm': (context) => Tareasform(),
        'tareaTable': (context) => Tareastable(),
        'asignacionesForm': (context) => Asignacionesform(),
        'asignacioneTable': (context) => Asignacionestable(),
        'histCambios': (context) => Histcambiosform(),
        'histCambiosTable': (context) => Histcambiostable(),
      },
    );
  }
}
