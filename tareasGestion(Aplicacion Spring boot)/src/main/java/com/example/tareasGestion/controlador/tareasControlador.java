package com.example.tareasGestion.controlador;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.tareasGestion.modelo.proyectosModel;
import com.example.tareasGestion.modelo.tareasModel;
import com.example.tareasGestion.servicio.proyectosServicios;
import com.example.tareasGestion.servicio.tareasServicio;
@Controller
public class tareasControlador {
	 @Autowired
	    private tareasServicio tareasService;
	 @Autowired
	 private proyectosServicios proyectosService;
	@GetMapping("/tareasForm")
	 public String accesoFormulario(Model model) {
	     System.out.println("Accediendo al formulario de tareas");
	     List<proyectosModel> proyectos=proyectosService.listarProyectos();
	     model.addAttribute("nuevo", new tareasModel());
	     model.addAttribute("proyectos", proyectos);
	     return "formularios/tareasForm";

	 }
	@GetMapping("/tareasTable")
	public String accesoTarea(Model model) {
	    System.out.println("Accediendo a la tabla");
	    List<tareasModel> resultado = tareasService.listarTareas();
	    model.addAttribute("listaTareas", resultado); // Asegúrate de que el nombre coincida
	    return "tablas/tareasTable";
	}
	//guardar
	@PostMapping("/guardarTarea")
	public String guardarNuevaTarea(@ModelAttribute("nuevo") tareasModel nuevaTarea) {
	    // Verificar si el proyecto está siendo asignado correctamente
	    if (nuevaTarea.getFkProyectos() != null) {
	        System.out.println("Proyecto seleccionado: " + nuevaTarea.getFkProyectos().getNombreProyectos());
	    } else {
	        System.out.println("No se ha seleccionado ningún proyecto.");
	    }
	    // Guardar la tarea
	    tareasService.insertarTarea(nuevaTarea);
	    // Redirigir a la lista de tareas
	    return "redirect:/tareasTable";
	}
	//editar
	@GetMapping("/editarTareas/{id}")
	public String editarRegistro(Model model, @PathVariable(value = "id") Long id) {
	    tareasModel tareaExistente = tareasService.buscarPorId(id);
	    model.addAttribute("tareas", tareaExistente);
	    List<proyectosModel> proyectos = proyectosService.listarProyectos();
	    model.addAttribute("proyectos", proyectos);
	    return "editarForm/editarTareas";
	}

	//eliminar
	@GetMapping("/eliminarTarea/{id}")
	public String eliminarTarea(@PathVariable("id") Long id) 
	{
		tareasService.eliminarTarea(id);
	     return "redirect:/tareasTable"; 
	}
}

