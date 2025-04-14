package com.example.tareasGestion.controlador;

import java.util.List;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.tareasGestion.modelo.asignacionesModel;
import com.example.tareasGestion.modelo.tareasModel;
import com.example.tareasGestion.modelo.userModel;
import com.example.tareasGestion.servicio.asignacionesServicio;
import com.example.tareasGestion.servicio.tareasServicio;
import com.example.tareasGestion.servicio.userServicio;

@Controller
public class asignacionesControlador {
	@Autowired
	private asignacionesServicio asignacionesService;
	 @Autowired
	    private tareasServicio tareasService;
	 @Autowired
		private userServicio userSer;
	 @GetMapping("/asignacionesForm")
	 public String mostrarFormulario(Model model) {
	     model.addAttribute("nuevo", new asignacionesModel());
	     model.addAttribute("listaUsuarios", userSer.listarUsers()); // Cargar usuarios
	     model.addAttribute("listaTareas", tareasService.listarTareas());   // Cargar tareas
	     return "formularios/asignacionesForm";
	 }
	@GetMapping("/asignacionesTable")
	 public String accesoTabla(Model model) {
		List<asignacionesModel>resultado=asignacionesService.listarAsignaciones();
		model.addAttribute("listaAsignaciones", resultado);
	     return "tablas/asignacionesTable";

	 }
	@PostMapping("/guardarAsignacion")
	public String guardarNuevaAsignacion(@ModelAttribute("nuevo") asignacionesModel nuevaAsignacion) {
	    if (nuevaAsignacion.getFkUser() != null && nuevaAsignacion.getFkTareas() != null) {
	        asignacionesService.insertarAsignacion(nuevaAsignacion);
	        return "redirect:/asignacionesTable"; // Redirigir a la tabla de asignaciones
	    } else {
	        return "redirect:/asignacionesForm?error=CamposObligatorios"; // Redirigir si faltan campos
	    }
	}

	//editar
	@GetMapping("/editarAsignacion/{id}")
	public String editarRegistro(Model model, @PathVariable(value="id") Long id) {
	    model.addAttribute("nuevo", asignacionesService.buscarPorId(id)); // Asegúrate de que el objeto "nuevo" tiene las relaciones fkUser y fkTareas
	    model.addAttribute("listaUsuarios", userSer.listarUsers()); // Lista de usuarios
	    model.addAttribute("listaTareas", tareasService.listarTareas()); // Lista de tareas
	    return "editarForm/editarAsignaciones"; // Vista de edición
	}


	 @GetMapping("/eliminarAsignacion/{id}")
	 public String eliminarAsignacion(@PathVariable("id") Long id) {
	     // Llamar al servicio para eliminar el usuario
		 asignacionesService.eliminarAsignacion(id);
	     return "redirect:/asignacionesTable";  // Redirigir a la tabla después de la eliminación
	 }
}
