package com.example.tareasGestion;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;

import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import com.example.tareasGestion.modelo.userModel;
import com.example.tareasGestion.servicio.userServicio;

@SpringBootTest
class TareasGestionApplicationTests {
	@Autowired
	private userServicio userSer;
		/*@Test
		void contextLoads() {
			userModel user=new userModel();
			user.setNombreUser("maria");
			user.setEmail("maria@mail.com");
			user.setRol("empleado");
			userSer.insertarUser(user);
		}*/
		@Test
	    public void testBuscarUserPorNombreYEmail() {
			  String nombre = "";
			    String email = "juan@example.com";
			    List<userModel>users=userSer.buscarUsuarioPorNombre(nombre, email);
			    assertNotNull(users);
			    assertFalse(users.isEmpty());
			    for (userModel usuario : users) {
			        System.out.println("Usuario encontrado: " + usuario.getNombreUser() + ", " + usuario.getEmail());
			    }
	    }

}
