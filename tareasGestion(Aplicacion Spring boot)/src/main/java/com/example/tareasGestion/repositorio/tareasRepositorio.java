package com.example.tareasGestion.repositorio;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.tareasGestion.modelo.tareasModel;

public interface tareasRepositorio extends JpaRepository<tareasModel,Long>{
@Override
public  Optional<tareasModel> findById(Long id);
}
