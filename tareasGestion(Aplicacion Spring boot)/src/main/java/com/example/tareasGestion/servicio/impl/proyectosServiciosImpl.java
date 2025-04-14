package com.example.tareasGestion.servicio.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.tareasGestion.modelo.proyectosModel;
import com.example.tareasGestion.repositorio.proyectosRepositorio;
import com.example.tareasGestion.servicio.proyectosServicios;
@Service
public class proyectosServiciosImpl implements proyectosServicios{
@Autowired
private proyectosRepositorio proyectosRep;
	@Override
	public void insertarProyectos(proyectosModel proyectos) {
		try {
			proyectosRep.save(proyectos);
		} catch (Exception e) {
			e.printStackTrace();
			// TODO: handle exception
		}}
	@Override
	public List<proyectosModel> listarProyectos() {
		// TODO Auto-generated method stub
		return proyectosRep.findAll();
	}

	@Override
	public proyectosModel buscarPorId(Long id) {
		// TODO Auto-generated method stub
		return proyectosRep.findById(id).get();

	}
	@Override
	public void eliminarProyecto(Long id) {
		// TODO Auto-generated method stub
		try {
			proyectosRep.deleteById(id);  // Usar el método deleteById del repositorio para eliminar al usuario
	    } catch (Exception e) {
	        e.printStackTrace();
	    }}}
