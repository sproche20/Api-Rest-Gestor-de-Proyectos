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

import com.example.tareasGestion.modelo.histcambiosModel;
import com.example.tareasGestion.modelo.proyectosModel;
import com.example.tareasGestion.modelo.tareasModel;
import com.example.tareasGestion.modelo.userModel;
import com.example.tareasGestion.servicio.histCambioServicios;
import com.example.tareasGestion.servicio.proyectosServicios;
import com.example.tareasGestion.servicio.userServicio;
@Controller
public class histCambiosControlador {
	@Autowired
	private histCambioServicios histCambService;
	 @Autowired
	 private proyectosServicios proyectosService;
	 @Autowired
		private userServicio userSer;
	@GetMapping("/histCambForm")
	 public String accesoFormulario(Model model) {
	     System.out.println("Accediendo al formulario");
	     model.addAttribute("nuevo",new histcambiosModel());
	     model.addAttribute("listaUsuarios", userSer.listarUsers());
	     model.addAttribute("proyectos", proyectosService.listarProyectos());
	     return "formularios/histCambForm";

	 }
	@GetMapping("/histCambTable")
	 public String accesoTabla(Model model) {
		List<histcambiosModel>resultado=histCambService.listarHistCambios();
		model.addAttribute("listaHistCambios", resultado);
	     return "tablas/histCambTable";
	 }
	//guardar
		@PostMapping("/guardarCambio")
		public  String guardarNuevoHist(@ModelAttribute("nuevo") histcambiosModel nuevoHistCamb)
		{
			histCambService.insertarHistCambios(nuevoHistCamb);
			return "redirect:/histCambTable";
		}
		//editar
		@GetMapping("/editarHistCamb/{id}")
		public String editarRegistro(Model model, @PathVariable(value = "id") Long id) {
		    // Buscar el cambio existente por su ID
		    histcambiosModel cambioExistente = histCambService.buscarPorId(id);

		    // Agregar el cambio al modelo con un nombre más coherente
		    model.addAttribute("histCambio", cambioExistente);

		    // Obtener listas de usuarios y proyectos
		    List<userModel> listaUsuarios = userSer.listarUsers();
		    List<proyectosModel> proyectos = proyectosService.listarProyectos();
		    // Pasar las listas al modelo
		    model.addAttribute("listaUsuarios", listaUsuarios);
		    model.addAttribute("proyectos", proyectos);

		    // Retornar la vista de edición
		    return "editarForm/editarHistCamb";
		}

		 @GetMapping("/eliminarHistCamb/{id}")
		 public String eliminarHisCamb(@PathVariable("id") Long id) {
		     // Llamar al servicio para eliminar el usuario
			 histCambService.eliminarHistCamb(id);
		     return "redirect:/histCambTable";  // Redirigir a la tabla después de la eliminación
		 }
}

