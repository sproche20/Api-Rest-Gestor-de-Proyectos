package com.example.tareasGestion.controlador;

import java.util.List;

import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.ui.Model;

import com.example.tareasGestion.modelo.userModel;
import com.example.tareasGestion.servicio.userServicio;

import ch.qos.logback.classic.Logger;

@Controller
public class userControlador {
	@Autowired
	private userServicio userSer;
	 @GetMapping("/userForm")
	 public String accesoFormulario(Model model) {
	     System.out.println("Accediendo al formulario de usuarios");
	     model.addAttribute("nuevo", new userModel());
	     return "formularios/userForm";
	 }
	 @GetMapping("/userTable")
	 public String accesoTabla(Model model) {
	     System.out.println("Accediendo a la tabla");
	     List<userModel>resultado=userSer.listarUsers();
	     model.addAttribute("listaUsuarios", resultado);
	     return "tablas/userTable";
	 }
	 //guardar
	 @PostMapping("/guardarUsuario")
	 public String guardarNuevoUsuario(@ModelAttribute("nuevo")userModel nuevoUser) 
	 {
		 userSer.insertarUser(nuevoUser);
		 return "redirect:/userTable";
	 }
	 //editar
	 @GetMapping("/editarUsuario/{id}")
	 public String editarUsuario(Model model, @PathVariable("id") Long id) {
	     // Cargar el usuario desde la base de datos y pasarlo al modelo
	     model.addAttribute("usuario", userSer.buscarPorId(id));
	     return "editarForm/editarUser"; // Carga la plantilla de edición
	 }
	 @GetMapping("/eliminarUsuario/{id}")
	 public String eliminarUsuario(@PathVariable("id") Long id) {
	     // Llamar al servicio para eliminar el usuario
	     userSer.eliminarUser(id);
	     return "redirect:/userTable";  // Redirigir a la tabla después de la eliminación
	 }
}

