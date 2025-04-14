package com.example.tareasGestion.restController;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;
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

import com.example.tareasGestion.DTO.histCambiosDTO;
import com.example.tareasGestion.modelo.histcambiosModel;
import com.example.tareasGestion.modelo.proyectosModel;
import com.example.tareasGestion.modelo.userModel;
import com.example.tareasGestion.servicio.histCambioServicios;
import com.example.tareasGestion.servicio.proyectosServicios;
import com.example.tareasGestion.servicio.userServicio;
@RestController
@RequestMapping("/api/histCambios")
public class histcambiosRestController {
	@Autowired
	private histCambioServicios histCambService;
	 @Autowired
	 private proyectosServicios proyectosService;
	 @Autowired
		private userServicio userSer;
	 //listarHistCambios
	 @GetMapping
	 public List<histCambiosDTO> obtenerHistCambios() {
	     List<histcambiosModel> histCambios = histCambService.listarHistCambios();
	     
	     return histCambios.stream()
	         .map(a -> new histCambiosDTO(
	             a.getId(),
	             a.getTipocambio(),
	             a.getFechacambio(),
	             a.getDescripcion(),
	             (a.getFkProyectos() != null) ? a.getFkProyectos().getId() : 0,  // Corregido
	             (a.getFkUser() != null) ? a.getFkUser().getId() : 0  // Corregido
	         ))
	         .collect(Collectors.toList());
	 }

	 
	 //obtenerHistCambios por id
	 @GetMapping("/{id}")
	 public ResponseEntity<histcambiosModel>obtenerhistCambiosPorId(@PathVariable("id")Long id)
	 {
		 histcambiosModel histCambios=histCambService.buscarPorId(id);
		 return (histCambios!=null)?ResponseEntity.ok(histCambios):ResponseEntity.notFound().build();
	 }
	 //crear nuevo Historial de cambios
	 @PostMapping
	 public ResponseEntity<?> crearhistCambio(@RequestBody Map<String, Object> datos) {
	     try {
	         // Extraer datos del JSON
	         histcambiosModel nuevoHistCambios = new histcambiosModel();
	         Long proyectoId = Long.valueOf(datos.get("fkProyectos").toString());
	         Long userId = Long.valueOf(datos.get("fkUser").toString());
	         LocalDate fecha = LocalDate.parse(datos.get("fechacambio").toString());
	         Long tipoCambio = Long.valueOf(datos.get("tipocambio").toString());  // Extraer tipo de cambio
	         String descripcion = datos.get("descripcion").toString();  // Extraer descripción

	         // Buscar los objetos relacionados
	         proyectosModel proyectos = proyectosService.buscarPorId(proyectoId);
	         userModel usuario = userSer.buscarPorId(userId);
	         if (proyectos == null || usuario == null) {
	             return ResponseEntity.badRequest().body("Proyectos y usuarios no encontrados");
	         }

	         // Asignar valores al objeto histcambios
	         nuevoHistCambios.setFechacambio(fecha);
	         nuevoHistCambios.setFkProyectos(proyectos);
	         nuevoHistCambios.setFkUser(usuario);
	         nuevoHistCambios.setTipocambio(tipoCambio);  // Asignar tipo de cambio
	         nuevoHistCambios.setDescripcion(descripcion);  // Asignar descripción

	         // Guardar en la base de datos
	         histCambService.insertarHistCambios(nuevoHistCambios);
	         return ResponseEntity.ok(nuevoHistCambios);
	     } catch (Exception e) {
	         return ResponseEntity.badRequest().body("Error al guardar el histCambio: " + e.getMessage());
	     }
	 }

	 //actualizarHistCambio
	 @PutMapping("/{id}")
	 public ResponseEntity<?>actualizarHistCambios(@PathVariable("id")Long id,@RequestBody Map<String, Object>datos)
	 {
		try {
			histcambiosModel histCambiosExistente=histCambService.buscarPorId(id);
			if (histCambiosExistente==null) {
				return ResponseEntity.notFound().build();
			}
			// Extraer datos del JSON
	         histcambiosModel nuevoHistCambios = new histcambiosModel();
	         Long proyectoId = Long.valueOf(datos.get("fkProyectos").toString());
	         Long userId = Long.valueOf(datos.get("fkUser").toString());
	         LocalDate fecha = LocalDate.parse(datos.get("fechacambio").toString());
	         Long tipoCambio = Long.valueOf(datos.get("tipocambio").toString());  // Extraer tipo de cambio
	         String descripcion = datos.get("descripcion").toString();  // Extraer descripción
	         // Buscar los objetos relacionados
	         proyectosModel proyectos = proyectosService.buscarPorId(proyectoId);
	         userModel usuario = userSer.buscarPorId(userId);
	         if (proyectos == null || usuario == null) {
	             return ResponseEntity.badRequest().body("Proyectos y usuarios no encontrados");
	         }
	         //actualizar los valores
	         histCambiosExistente.setFechacambio(fecha);
	         histCambiosExistente.setFkProyectos(proyectos);
	         histCambiosExistente.setFkUser(usuario);
	         histCambiosExistente.setTipocambio(tipoCambio);  // Asignar tipo de cambio
	         histCambiosExistente.setDescripcion(descripcion);  // Asignar descripción
	         //guardar cambios
	         histCambService.insertarHistCambios(histCambiosExistente);
	         return ResponseEntity.ok(histCambiosExistente);

		} catch (Exception e) {
	        return ResponseEntity.badRequest().body("Error al actualizar el histCambios: " + e.getMessage());

		}
	 }
	 //eliminar histCambios
	 @DeleteMapping("/{id}")
	 public ResponseEntity<Void>eliminarHistCambios(@PathVariable("id")Long id)
	 {
		 histcambiosModel histCambios=histCambService.buscarPorId(id);
		 if (histCambios==null) {
			return ResponseEntity.notFound().build();
		}
		 histCambService.eliminarHistCamb(id);
		 return ResponseEntity.noContent().build();
	 }
	 // Obtener la lista de usuarios (para que Flutter pueda poblar un dropdown)
	 @GetMapping("/usuarios")
		public List<userModel>obtenerUser()
		{
			return userSer.listarUsers();
		}
		//obtener lista de proyectos:

		@GetMapping("/proyectos")
		public List<proyectosModel>obtenerProyectos() {
			return proyectosService.listarProyectos();
		}
}
