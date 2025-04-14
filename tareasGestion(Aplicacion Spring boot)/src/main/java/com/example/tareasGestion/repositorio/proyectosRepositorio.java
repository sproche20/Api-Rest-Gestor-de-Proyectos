package com.example.tareasGestion.repositorio;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.tareasGestion.modelo.proyectosModel;

public interface proyectosRepositorio extends JpaRepository<proyectosModel, Long>{
	public  Optional<proyectosModel> findById(Long id);

}
