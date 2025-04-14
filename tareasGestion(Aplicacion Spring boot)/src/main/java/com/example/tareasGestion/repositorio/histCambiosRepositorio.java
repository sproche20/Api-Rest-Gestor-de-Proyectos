package com.example.tareasGestion.repositorio;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.tareasGestion.modelo.histcambiosModel;

public interface histCambiosRepositorio extends JpaRepository<histcambiosModel, Long>{
	public  Optional<histcambiosModel> findById(Long id);

}
