package com.example.tareasGestion.DTO;

import java.time.LocalDate;

import lombok.Data;

@Data
public class histCambiosDTO {
	 private Long id;
	    private Long tipocambio;
	    private String fechacambio;
	    private String descripcion;
	    private Long fkProyectos;
	    private Long fkUser;
	    public histCambiosDTO(
	            Long id,
	            Long tipocambio,
	            LocalDate fechacambio,
	            String descripcion,
	            Long fkProyectos,
	            Long fkUser) {
	        this.id = id;
	        this.tipocambio = tipocambio;
	        this.fechacambio = fechacambio.toString(); // Convertir LocalDate a String
	        this.descripcion = descripcion;
	        this.fkProyectos = fkProyectos;
	        this.fkUser = fkUser;
	    }
}
