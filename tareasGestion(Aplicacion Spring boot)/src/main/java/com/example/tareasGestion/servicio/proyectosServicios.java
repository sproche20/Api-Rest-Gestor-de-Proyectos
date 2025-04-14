package com.example.tareasGestion.servicio;

import java.util.List;

import com.example.tareasGestion.modelo.proyectosModel;

public interface proyectosServicios {
	public void insertarProyectos(proyectosModel proyectos);
	public List<proyectosModel>listarProyectos();
	public proyectosModel buscarPorId(Long id);
	public void eliminarProyecto(Long id);

}
