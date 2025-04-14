package com.example.tareasGestion.modelo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonManagedReference;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name="tb_user")
public class userModel implements Serializable{
	private static final long serialVersionUID = 1L; 
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	private String nombreUser;
	private String email;
	private String rol;
	@OneToMany(mappedBy = "fkUser"/*,cascade = CascadeType.REFRESH,fetch = FetchType.LAZY*/)
	@JsonManagedReference
	private List<asignacionesModel>listaAsignaciones=new ArrayList<>();
	@OneToMany(mappedBy = "fkUser")
	@JsonIgnore // Evita ciclos de serialización innecesarios
	private List<histcambiosModel>listarHistCambios=new ArrayList<>();
}