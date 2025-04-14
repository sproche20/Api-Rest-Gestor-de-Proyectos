package com.example.tareasGestion.modelo;

import java.io.Serializable;
import java.time.LocalDate;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name="tb_histcambios")
public class histcambiosModel implements Serializable{
	private static final long serialVersionUID = 1L;
	 @Id
	    @GeneratedValue(strategy = GenerationType.IDENTITY)
	 private Long id;
	 private Long tipocambio;
	 private LocalDate fechacambio;
	 private String descripcion;
	 @ManyToOne(fetch = FetchType.LAZY)
	 @JoinColumn(name = "fkProyectos")
	 @JsonIgnore // Evita ciclos innecesarios con proyectos
	 private proyectosModel fkProyectos;
	 @ManyToOne(fetch = FetchType.LAZY)
	 @JoinColumn(name = "fkUser") 
	 @JsonBackReference
	 private userModel fkUser;
}
