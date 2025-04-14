package com.example.tareasGestion.servicio;

import java.util.List;
import java.util.Optional;

import com.example.tareasGestion.modelo.asignacionesModel;

public interface asignacionesServicio {
	public void insertarAsignacion(asignacionesModel asignacion);
	public List<asignacionesModel>listarAsignaciones();
	public asignacionesModel buscarPorId(Long id);
	public void eliminarAsignacion(Long id);
}
