package com.example.tareasGestion.restController;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.tareasGestion.DTO.AsignacionDTO;
import com.example.tareasGestion.modelo.asignacionesModel;
import com.example.tareasGestion.modelo.tareasModel;
import com.example.tareasGestion.modelo.userModel;
import com.example.tareasGestion.servicio.asignacionesServicio;
import com.example.tareasGestion.servicio.tareasServicio;
import com.example.tareasGestion.servicio.userServicio;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/asignaciones")
public class asignacionesRestController {
	@Autowired
	private asignacionesServicio asignacionesService;
	 @Autowired
	    private tareasServicio tareasService;
	 @Autowired
		private userServicio userSer;
	 // Obtener todas las asignaciones
	 @GetMapping
	 public List<AsignacionDTO> obtenerAsignaciones() {
		    List<asignacionesModel> asignaciones = asignacionesService.listarAsignaciones();
		    
		    return asignaciones.stream().map(a -> new AsignacionDTO(
		            a.getId(),
		            a.getFechaasing(),
		            (a.getFkUser() != null) ? a.getFkUser().getId() : 0, // Si es null, devolver 0
		            (a.getFkTareas() != null) ? a.getFkTareas().getId() : 0  // Si es null, devolver 0
		        )).collect(Collectors.toList());
		}
	    // Obtener una asignación por ID
	 @GetMapping("/{id}")
	 public ResponseEntity<asignacionesModel>ObtenerAsigPorId(@PathVariable("id")Long id)
	 {
		 asignacionesModel asignacion=asignacionesService.buscarPorId(id);
		 return (asignacion!=null)?ResponseEntity.ok(asignacion):ResponseEntity.notFound().build();
	 }
	 //crear nueva asignacion
	 @PostMapping
	 public ResponseEntity<?>guardarAsignacion(@RequestBody Map<String,Object>datos)
	 {
		 try {
			 //extraer datos del json
			asignacionesModel nuevaAsignacion=new asignacionesModel();
            Long userId = Long.valueOf(datos.get("fkUser").toString());
            Long tareaId = Long.valueOf(datos.get("fkTareas").toString());
            LocalDate fecha = LocalDate.parse(datos.get("fechaasing").toString());
            //Buscar los objetos relacionados
            userModel usuario=userSer.buscarPorId(userId);
            tareasModel tarea=tareasService.buscarPorId(tareaId);
            if (usuario==null||tarea==null) {
				return ResponseEntity.badRequest().body("usuario y tarea no encontrados");
			}
            //asignar valores 
            nuevaAsignacion.setFechaasing(fecha);
            nuevaAsignacion.setFkUser(usuario);
            nuevaAsignacion.setFkTareas(tarea);
            //guardar en la db
            asignacionesService.insertarAsignacion(nuevaAsignacion);
            return ResponseEntity.ok(nuevaAsignacion);

		} catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al guardar la asignación: " + e.getMessage());
		}
	 }
	 //actualizar
	 @PutMapping("/{id}")
	 public ResponseEntity<?>actualizarAsignacion(@PathVariable("id")Long id,@RequestBody Map<String,Object>datos)
	{
		try {
			asignacionesModel asignacionExistente=asignacionesService.buscarPorId(id);
			if (asignacionExistente==null) {
				return ResponseEntity.notFound().build();
			}
			//extraer los datos del json
			Long userId=Long.valueOf(datos.get("fkUser").toString());
			Long tareaId=Long.valueOf(datos.get("fkTareas").toString());
			LocalDate fecha=LocalDate.parse(datos.get("fechaasing").toString());
			//buscar los objetos relacionados
			userModel usuario=userSer.buscarPorId(userId);
			tareasModel tarea=tareasService.buscarPorId(tareaId);
			
			if (usuario==null|| tarea==null) {
				return ResponseEntity.badRequest().body("Usuario o tarea no encontrado");
			}
			//actualizar los valores
			asignacionExistente.setFechaasing(fecha);
			asignacionExistente.setFkUser(usuario);
			asignacionExistente.setFkTareas(tarea);
			//guardar cambios
			asignacionesService.insertarAsignacion(asignacionExistente);
			return ResponseEntity.ok(asignacionExistente);
					
		} catch (Exception e) {
	        return ResponseEntity.badRequest().body("Error al actualizar la asignación: " + e.getMessage());
		}
	}
	 //eliminar
	 @DeleteMapping("/{id}")
	 public ResponseEntity<Void>eliminarAsignacion(@PathVariable("id") Long  id)
	 {
		 asignacionesModel asignacion=asignacionesService.buscarPorId(id);
		 if(asignacion==null)
		 {
			 return ResponseEntity.notFound().build();
		 }
		 asignacionesService.eliminarAsignacion(id);
		 return ResponseEntity.noContent().build();
	 }
	 // Obtener la lista de usuarios (para que Flutter pueda poblar un dropdown)
	 @GetMapping("/usuarios")
		public List<userModel>obtenerUser()
		{
			return userSer.listarUsers();
		}
		 // Obtener la lista de tareas (para que Flutter pueda poblar un dropdown)
	    @GetMapping("/tareas")
	    public List<tareasModel> obtenerTareas() {
	        return tareasService.listarTareas();
	    }


}
