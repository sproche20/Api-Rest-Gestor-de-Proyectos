package com.example.tareasGestion.repositorio;


import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.tareasGestion.modelo.userModel;
@Repository
public interface userRepositorio extends JpaRepository<userModel, Long>{
	@Query("SELECT u FROM userModel u WHERE u.nombreUser = :nombre AND u.email = :email")
	List<userModel> buscarUserPorNombre(@Param("nombre") String nombre, @Param("email") String email);
	@Override
	public  Optional<userModel> findById(Long id);
}
