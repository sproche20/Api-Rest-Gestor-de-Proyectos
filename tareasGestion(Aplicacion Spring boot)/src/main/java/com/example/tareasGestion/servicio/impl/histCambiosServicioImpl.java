package com.example.tareasGestion.servicio.impl;

import java.util.List;

import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.tareasGestion.modelo.histcambiosModel;
import com.example.tareasGestion.repositorio.histCambiosRepositorio;
import com.example.tareasGestion.servicio.histCambioServicios;

import jakarta.transaction.Transactional;
@Service
public class histCambiosServicioImpl implements histCambioServicios{
@Autowired
private histCambiosRepositorio histCambRep;
	@Override
	public void insertarHistCambios(histcambiosModel histCamb) {
		try {
			histCambRep.save(histCamb);
		} catch (Exception e) {
			 e.printStackTrace();
			// TODO: handle exception
		}}
	@Override
    @Transactional
	public List<histcambiosModel> listarHistCambios() {
		List<histcambiosModel>histCamb=histCambRep.findAll();
		for(histcambiosModel historialCambio:histCamb) 
		{
			if(historialCambio.getFkUser()!=null) 
			{
				Hibernate.initialize(historialCambio.getFkUser());
			}
			if(historialCambio.getFkProyectos()!=null) 
			{
				Hibernate.initialize(historialCambio.getFkProyectos());
			}
		}
		// TODO Auto-generated method stub
		return histCamb;
	}
	@Override
	public histcambiosModel buscarPorId(Long id) {
		// TODO Auto-generated method stub
		return histCambRep.findById(id).get();}
	@Override
	public void eliminarHistCamb(Long id) {
		// TODO Auto-generated method stub
		try {
			histCambRep.deleteById(id);  // Usar el método deleteById del repositorio para eliminar al usuario
	    } catch (Exception e) {
	        e.printStackTrace();   }}}
