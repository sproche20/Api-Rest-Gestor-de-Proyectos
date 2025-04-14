package com.example.tareasGestion.controlador;

import java.time.LocalDate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.tareasGestion.modelo.proyectosModel;
import com.example.tareasGestion.modelo.tareasModel;
import com.example.tareasGestion.modelo.userModel;
import com.example.tareasGestion.servicio.tareasServicio;
import com.example.tareasGestion.servicio.userServicio;

@Controller
public class indexControlador {
	 
	@GetMapping("/principal")//url
public String accesoIndex() 
{
	return "/index";//ruta fisica
	}
	 
	 @GetMapping("/tabla") // Ruta para tabla.html
	    public String accesoTabla() {
	        return "tabla"; // Nombre del archivo sin la extensión .html
	    } 
	}


