package com.example.tareasGestion.restController;

import java.util.List;
import java.util.Optional;import java.util.stream.Collector;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.tareasGestion.DTO.tareasDTO;
import com.example.tareasGestion.modelo.proyectosModel;
import com.example.tareasGestion.modelo.tareasModel;
import com.example.tareasGestion.repositorio.tareasRepositorio;
import com.example.tareasGestion.servicio.proyectosServicios;
import com.example.tareasGestion.servicio.tareasServicio;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;

@RestController
@RequestMapping("api/tareas")
public class tareasRestController {
	@Autowired
	private tareasRepositorio tareaRep;
	@Autowired
    private tareasServicio tareasService;
	@Autowired
	private proyectosServicios proyectosService;
	//obtener todas las tareas
	@GetMapping
	public List<tareasDTO>obtenerTareas()
	{
		List<tareasModel> tareas=tareasService.listarTareas();
		return tareas.stream().map(a-> new tareasDTO(
				a.getId(),
				a.getNombreTarea(),
				a.getDescripcion(),
				a.getFechaInicio(),
				a.getFechaFin(),
				a.getEstado(),
				(a.getFkProyectos()!=null)? a.getFkProyectos().getId():0
				)).collect(Collectors.toList());
	}
	
	//obtener tarea por id
	@GetMapping("/{id}")
	public ResponseEntity<tareasModel> obtenerTarezasPorId(@PathVariable("id")Long id)
	{
		tareasModel tareas=tareasService.buscarPorId(id);
		return (tareas!=null)?ResponseEntity.ok(tareas):ResponseEntity.notFound().build();
	}
	//crear nueva tarea
	@PostMapping
	public ResponseEntity<?>crearTarea(@RequestBody tareasModel nuevatarea)
	{
		if (nuevatarea.getFkProyectos()==null||nuevatarea.getFkProyectos().getId()<=0) {
			return ResponseEntity.badRequest().body("Error: el campo FkProyecto es obligatorio y debe ser mayor que 0.");
		}
		  // Verificar si el usuario y la tarea existen en la base de datos
		boolean proyectoExistente=proyectosService.buscarPorId(nuevatarea.getFkProyectos().getId())!=null;
		if(!proyectoExistente) 
		{
			return ResponseEntity.badRequest().body("error el proyecto especificado no existe");
		}
		try 
		{
			tareasService.insertarTarea(nuevatarea);
			return ResponseEntity.status(HttpStatus.CREATED).body(nuevatarea);
		}catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error al guardar la tarea: " + e.getMessage());
		}
	}
	//actualizar
	@PutMapping("/{id}")
	public ResponseEntity<tareasModel>actualizarTarea(@PathVariable("id")Long id,@RequestBody tareasModel tareaActualizada)
	{
		tareasModel tareaExistente=tareasService.buscarPorId(id);
		if (tareaExistente==null) {
			return ResponseEntity.notFound().build();
		}
		tareaActualizada.setId(id);
		tareasService.insertarTarea(tareaActualizada);
		return ResponseEntity.ok(tareaActualizada);
	}
	 //eliminar
	@DeleteMapping("/{id}")
	public ResponseEntity<?>eliminarTarea(@PathVariable("id")Long id)
	{
		Optional<tareasModel>tareaOpt=tareaRep.findById(id);
		if (tareaOpt.isEmpty()) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body("tarea no encontrada");
		}
		tareasModel tareas=tareaOpt.get();
		//verificar si esta activo
		if (!tareas.getListaAsignaciones().isEmpty()) {
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("La tarea tiene asignaciones activas. Primero elimine esa entidad.");
		}
		try {
			tareaRep.delete(tareas);
			return ResponseEntity.status(HttpStatus.OK).body("tarea  eliminada con exito");
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error al eliminar la tarea ");
			}
			
		
	}
	//obtener lista de proyectos:
	@GetMapping("/proyectos")
	public List<proyectosModel>obtenerProyectos() {
		return proyectosService.listarProyectos();
	}
}
