package com.example.tareasGestion.servicio;

import java.util.List;
import java.util.Optional;

import com.example.tareasGestion.modelo.tareasModel;

public interface tareasServicio {
	public void insertarTarea(tareasModel tarea);
	public List<tareasModel>listarTareas();
	public tareasModel  buscarPorId(Long id);
	public void eliminarTarea(Long id);
}