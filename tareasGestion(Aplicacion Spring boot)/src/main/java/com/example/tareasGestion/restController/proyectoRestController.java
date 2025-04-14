package com.example.tareasGestion.restController;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.tareasGestion.modelo.proyectosModel;
import com.example.tareasGestion.repositorio.proyectosRepositorio;
import com.example.tareasGestion.servicio.proyectosServicios;
@RestController
@RequestMapping("api/proyectos")
public class proyectoRestController {
	@Autowired
	private proyectosRepositorio proyectosRep;
	@Autowired
	private proyectosServicios proyectosService;
	//listarProyectos
	@GetMapping
	public List<proyectosModel>obtenerProyectos()
	{
		return proyectosService.listarProyectos();
	}
	//obtener proyecto por id
	@GetMapping("/{id}")
	public ResponseEntity<proyectosModel>obtenerProyectoPorId(@PathVariable("id")Long id)
	{
		proyectosModel proyecto=proyectosService.buscarPorId(id);
		return(proyecto!=null)?ResponseEntity.ok(proyecto):ResponseEntity.notFound().build();
	}
	//crear nuevoProyecto
	@PostMapping
	public ResponseEntity<proyectosModel>crearProyecto(@RequestBody proyectosModel nuevoProyecto)
	{
		proyectosService.insertarProyectos(nuevoProyecto);
		return ResponseEntity.status(HttpStatus.CREATED).body(nuevoProyecto);
	}
	//actualizar proyecto
	@PutMapping("/{id}")
	public ResponseEntity<proyectosModel>actualizarProyecto(@PathVariable("id")Long id,@RequestBody proyectosModel proyectoActualizado)
	{
		proyectosModel proyectoExistente=proyectosService.buscarPorId(id);
		if (proyectoExistente==null) {
			return ResponseEntity.notFound().build();
		}
		proyectoActualizado.setId(id);
		proyectosService.insertarProyectos(proyectoActualizado);
		return ResponseEntity.ok(proyectoActualizado);
	}
	//eliminar proyecto
	@DeleteMapping("/{id}")
	public ResponseEntity<?>eliminarProyecto(@PathVariable("id")Long id)
	{
		Optional<proyectosModel>proyectoOpt=proyectosRep.findById(id);
		if (proyectoOpt.isEmpty()) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Proyecto no encontrado");
		}
		proyectosModel proyecto=proyectoOpt.get();
		//verificar si esta activo
		if (!proyecto.getListaTareas().isEmpty()||!proyecto.getListarHistCambios().isEmpty()) {
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("El proyecto tiene tareas o historial de cambios activos. Primero elimine esas entidades.");
		}
		try {
			proyectosRep.delete(proyecto);
			return ResponseEntity.status(HttpStatus.OK).body("Proyecto Eliminado con exito");
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error al eliminar el proyecto");
			
		}
	}
}



