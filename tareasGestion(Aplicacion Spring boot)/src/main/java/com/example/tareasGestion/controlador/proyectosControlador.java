package com.example.tareasGestion.controlador;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.tareasGestion.modelo.proyectosModel;
import com.example.tareasGestion.modelo.tareasModel;
import com.example.tareasGestion.modelo.userModel;
import com.example.tareasGestion.servicio.proyectosServicios;

@Controller
public class proyectosControlador {
	@Autowired
	private proyectosServicios proyectosService;
	@GetMapping("/proyectosForm")
	 public String accesoFormulario(Model model) {
	     System.out.println("Accediendo al formulario");
	     model.addAttribute("nuevo", new proyectosModel());
	     return "formularios/proyectosForm";

	 }
	@GetMapping("/proyectosTable")
	 public String accesoTabla(Model model) {
	     System.out.println("Accediendo a la tabla");
	     List<proyectosModel>resultado=proyectosService.listarProyectos();
	     model.addAttribute("listaProyectos", resultado);
	     return "tablas/proyectosTable";

	 }
	//guardar
		@PostMapping("/guardarProyecto")
		public  String guardarNuevoProyecto(@ModelAttribute("nuevo") proyectosModel nuevoProyecto)
		{
			proyectosService.insertarProyectos(nuevoProyecto);
			return "redirect:/proyectosTable";
		}
		//editar
		@GetMapping("/editarProyecto/{id}")
		public String editarRegistro(Model model,@PathVariable(value="id")Long id) 
		{
			model.addAttribute("nuevo",proyectosService.buscarPorId(id));
			return "editarForm/editarProyectos";
		}
		//eliminar
		 @GetMapping("/eliminarProyecto/{id}")
		 public String eliminarProyecto(@PathVariable("id") Long id) {
		     // Llamar al servicio para eliminar el usuario
			 proyectosService.eliminarProyecto(id);
		     return "redirect:/proyectosTable";  // Redirigir a la tabla después de la eliminación
		 }	
}
