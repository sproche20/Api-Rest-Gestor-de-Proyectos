package com.example.tareasGestion.servicio.impl;

import java.util.List;
import java.util.Optional;

import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.tareasGestion.modelo.asignacionesModel;
import com.example.tareasGestion.repositorio.asignacionesRepositorio;
import com.example.tareasGestion.servicio.asignacionesServicio;

import jakarta.transaction.Transactional;
@Service
public class asignacionServicioImpl implements asignacionesServicio{
@Autowired
private asignacionesRepositorio asigRep;


	@Override
	public void insertarAsignacion(asignacionesModel asignacion) {
		try {
			asigRep.save(asignacion);
		} catch (Exception e) {
			 e.printStackTrace();
			// TODO: handle exception
		}}
	@Override
    @Transactional
    public List<asignacionesModel> listarAsignaciones() {
        List<asignacionesModel> asignaciones = asigRep.findAll();

        for (asignacionesModel asignacion : asignaciones) {
            // Inicializar las relaciones Lazy de fkUser y fkTareas
            if (asignacion.getFkUser() != null) {
                Hibernate.initialize(asignacion.getFkUser());
            }
            if (asignacion.getFkTareas() != null) {
                Hibernate.initialize(asignacion.getFkTareas());
            }}
        return asignaciones; }
	@Override
	public asignacionesModel buscarPorId(Long id) {
		// TODO Auto-generated method stub
		return asigRep.findById(id).get();
	}
	@Override
	public void eliminarAsignacion(Long id) {
		// TODO Auto-generated method stub
		try {
			asigRep.deleteById(id);  // Usar el método deleteById del repositorio para eliminar al usuario
	    } catch (Exception e) {
	        e.printStackTrace();}}}
