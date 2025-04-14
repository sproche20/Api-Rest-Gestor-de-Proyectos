package com.example.tareasGestion.restController;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.tareasGestion.modelo.userModel;
import com.example.tareasGestion.repositorio.histCambiosRepositorio;
import com.example.tareasGestion.repositorio.userRepositorio;
import com.example.tareasGestion.servicio.userServicio;

@RestController
@RequestMapping("api/users")
public class userRestController {
	@Autowired
	private userRepositorio userRep;
	@Autowired
	private userServicio userSer;
	  // Obtener todos los usuarios (Lista en formato JSON)
	@GetMapping
	public List<userModel>obtenerUser()
	{
		return userSer.listarUsers();
	}
    // Obtener un usuario por ID
	@GetMapping("/{id}")
	public ResponseEntity<userModel> obtenerUsuarioPorId(@PathVariable("id")Long id)
	{
		userModel usuario=userSer.buscarPorId(id);
		return (usuario!=null)?ResponseEntity.ok(usuario):ResponseEntity.notFound().build();
	}
	// Crear un nuevo usuario
	@PostMapping
	public ResponseEntity<userModel>crearUser(@RequestBody userModel nuevoUser)
	{
		userSer.insertarUser(nuevoUser);
		return ResponseEntity.status(HttpStatus.CREATED).body(nuevoUser);
	}
	//ActualizarUser
	@PutMapping("/{id}")
	public ResponseEntity<userModel>actualizarUser(@PathVariable("id")Long id,@RequestBody userModel userActualizado)
	{
		userModel usuarioActualizado=userSer.actualizarUser(id, userActualizado);
		if (usuarioActualizado==null) {
			return ResponseEntity.notFound().build();
		}
		return ResponseEntity.ok(userActualizado);
	}
	  // Eliminar un usuario
	@DeleteMapping("/{id}")
	public ResponseEntity<?> eliminarUsuario(@PathVariable("id") Long id) {
	    Optional<userModel> usuarioOpt = userRep.findById(id);
	    if (usuarioOpt.isEmpty()) {
	        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Usuario no encontrado.");
	    }
	    
	    userModel usuario = usuarioOpt.get();
	    // Verifica si hay asignaciones activas
	    if (!usuario.getListaAsignaciones().isEmpty()||!usuario.getListarHistCambios().isEmpty()) {
	        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("El usuario tiene asignaciones o gestiones de cambios activas.");
	    }

	    try {
	        userRep.delete(usuario);
	        return ResponseEntity.status(HttpStatus.OK).body("Usuario eliminado con éxito.");
	    } catch (Exception e) {
	        e.printStackTrace();
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error al eliminar el usuario.");
	    }
	}

	}

