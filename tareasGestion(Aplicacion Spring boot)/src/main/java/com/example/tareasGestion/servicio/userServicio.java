package com.example.tareasGestion.servicio;

import java.util.List;
import java.util.Optional;

import com.example.tareasGestion.modelo.tareasModel;
import com.example.tareasGestion.modelo.userModel;

public interface userServicio {
	public void insertarUser(userModel user);
	  List<userModel> buscarUsuarioPorNombre(String nombre,String email);
	  public List<userModel>listarUsers();
		public userModel buscarPorId(Long id);
		public boolean eliminarUser(Long id);
		public userModel actualizarUser(Long id, userModel userActualizado);
}
