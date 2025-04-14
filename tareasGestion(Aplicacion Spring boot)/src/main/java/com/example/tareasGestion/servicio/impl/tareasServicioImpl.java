package com.example.tareasGestion.servicio.impl;


import java.util.List;
import java.util.Optional;

import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.tareasGestion.modelo.tareasModel;
import com.example.tareasGestion.repositorio.tareasRepositorio;
import com.example.tareasGestion.servicio.tareasServicio;

import jakarta.transaction.Transactional;
@Service
public class tareasServicioImpl  implements tareasServicio{
@Autowired
private tareasRepositorio tareaRep;
	@Override
	public void insertarTarea(tareasModel tarea) {
		try {
			tareaRep.save(tarea);
		} catch (Exception e) {
			e.printStackTrace();
			// TODO: handle exception
		}}
	@Transactional
	public List<tareasModel> listarTareas() {
	    List<tareasModel> tareas = tareaRep.findAll();
	    for (tareasModel tarea : tareas) {
	        if (((tareasModel) tarea).getFkProyectos() != null) {
	            Hibernate.initialize(tarea.getFkProyectos());
	        }
	    }
	    return tareas;
	}
	@Override
	public tareasModel buscarPorId(Long id) {
		// TODO Auto-generated method stub
		return tareaRep.findById(id).get();
	}
	@Override
	public void eliminarTarea(Long id) {
		try {
			tareaRep.deleteById(id);  // Usar el método deleteById del repositorio para eliminar al usuario
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
		// TODO Auto-generated method stub
	}
}
