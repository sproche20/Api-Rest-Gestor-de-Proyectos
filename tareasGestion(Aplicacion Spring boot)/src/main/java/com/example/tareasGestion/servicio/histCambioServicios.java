package com.example.tareasGestion.servicio;

import java.util.List;

import com.example.tareasGestion.modelo.histcambiosModel;

public interface histCambioServicios {
public void insertarHistCambios(histcambiosModel histCamb);
public List<histcambiosModel>listarHistCambios();
public histcambiosModel buscarPorId(Long id);
public void eliminarHistCamb(Long id);
}
