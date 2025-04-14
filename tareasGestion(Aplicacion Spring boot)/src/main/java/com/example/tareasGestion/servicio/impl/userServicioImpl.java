package com.example.tareasGestion.servicio.impl;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.tareasGestion.modelo.userModel;
import com.example.tareasGestion.repositorio.userRepositorio;
import com.example.tareasGestion.servicio.userServicio;
@Service
public class userServicioImpl implements userServicio{
@Autowired
private userRepositorio userRep;
	@Override
	public void insertarUser(userModel user) {
	try {
		userRep.saveAndFlush(user);
	} catch (Exception e) {
		 e.printStackTrace();
	}
		
	}
	@Override
	public List<userModel> buscarUsuarioPorNombre(String nombre, String email) {
		// TODO Auto-generated method stub
		return userRep.buscarUserPorNombre(nombre, email);
	}
	@Override
	public List<userModel> listarUsers() {
		// TODO Auto-generated method stub
		return userRep.findAll();
	}
	@Override
	public userModel buscarPorId(Long id) {
		// TODO Auto-generated method stub
		return userRep.findById(id).get();
	}
	@Override
	public boolean eliminarUser(Long id) {
		Optional<userModel> usuarioOptional = userRep.findById(id);
		if (usuarioOptional.isPresent()) {
			userModel usuario=usuarioOptional.get();
			//verificamos si el usuario tiene asignaciones activas
			if (!usuario.getListaAsignaciones().isEmpty()) {
				return false;
			}
			try {
				userRep.deleteById(id);
			} catch (Exception e) {
				e.printStackTrace();
				return false;
				// TODO: handle exception
			}
		}
		return false;

	}
	@Override
	public userModel actualizarUser(Long id, userModel userActualizado) {
		 // Buscar el usuario por ID
		Optional<userModel>usuarioExistente=userRep.findById(id);
		if(usuarioExistente.isPresent()) 
		{
			userModel usuario=usuarioExistente.get();
            // Actualizar los campos del usuario con los nuevos datos
			usuario.setNombreUser(userActualizado.getNombreUser());
			usuario.setEmail(userActualizado.getEmail());
			usuario.setRol(userActualizado.getRol());
			// Guardar el usuario actualizado en la base de datos
			return userRep.save(usuario);	
		}
		return null;
	}
}
