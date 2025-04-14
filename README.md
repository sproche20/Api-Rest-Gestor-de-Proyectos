
# 📁 Sistema de Gestión de Proyectos

Aplicación web para la gestión y seguimiento de proyectos, desarrollada con Flutter para el frontend y Spring Boot para el backend. Permite registrar proyectos, tareas, usuarios asignados, historial de cambios y visualizar el progreso general.

## 🚀 Funcionalidades principales

- Crear, editar y eliminar proyectos.
- Asignar tareas a usuarios.
- Control de estados de tareas (pendiente, en progreso, completada).
- Registro de historial de cambios por proyecto.
- Visualización organizada del avance de los proyectos.

## 🛠️ Tecnologías utilizadas

### Frontend (Flutter)
- Flutter con arquitectura MVC
- Consumo de APIs REST
- Paginación de tablas
- Formularios y validaciones
- Manejo de estados básicos

### Backend (Spring Boot)
- Spring Boot 3
- Spring Data JPA + Hibernate
- PostgreSQL
- Lombok
- Controladores REST
- Arquitectura en capas (modelo, servicio, repositorio, DTOs)

## 📂 Estructura del proyecto

```
📁 backend/
 ├── config/
 ├── controlador/
 ├── dto/
 ├── modelo/
 ├── repositorio/
 ├── restcontroller/
 ├── servicio/
 └── servicio/impl/

📁 frontend/
 ├── proyectos/
 │   ├── controller/
 │   ├── models/
 │   └── pages/
 ├── tareas/
 ├── user/
 ├── histCambios/
 ├── asignaciones/
 └── widgets/
```

## ⚙️ Cómo ejecutar el proyecto

### Backend
1. Clona el repositorio.
2. Configura la base de datos PostgreSQL.
3. Ejecuta el proyecto desde tu IDE (IntelliJ, Spring Tools, etc.).
4. Asegúrate que la API corra en `http://localhost:8080`.

### Frontend
1. Abre la carpeta del frontend con VS Code o Android Studio.
2. Ejecuta los comandos:  
   ```
   flutter pub get
   flutter run
   ```
3. Asegúrate de tener un emulador o dispositivo conectado.



## 👨‍💻 Autor

- Nombre: Paúl Roche
- GitHub: [@sproche20](https://github.com/sproche20)

---

> Este proyecto fue desarrollado como parte de la práctica de gestión de proyectos y desarrollo de aplicaciones modernas con Flutter y Spring Boot.
