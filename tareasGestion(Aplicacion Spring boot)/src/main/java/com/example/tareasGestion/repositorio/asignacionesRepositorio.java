package com.example.tareasGestion.repositorio;


import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.tareasGestion.modelo.asignacionesModel;
public interface asignacionesRepositorio extends JpaRepository<asignacionesModel, Long>{
	@Override
	public  Optional<asignacionesModel> findById(Long id);
	List<asignacionesModel> findByFkUser_Id(Long userId);

}
