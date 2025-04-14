package com.example.tareasGestion.DTO;

import java.time.LocalDate;

import lombok.Data;

@Data
public class tareasDTO {
	private Long id;
	private String nombreTarea;
	private String descripcion;
	private String fechaInicio;
	private String fechaFin;
	private String estado;
	private Long  fkProyectos;
	public tareasDTO(
			Long id,
			String nombreTarea,
			String descripcion,
			LocalDate fechaInicio,
			LocalDate fechaFin,
			String estado,Long fkProyectos) 
	{
		this.id=id;
		this.nombreTarea=nombreTarea;
		this.descripcion=descripcion;
		this.fechaInicio= fechaInicio.toString();
		this.fechaFin=fechaFin.toString();
		this.estado=estado;
		this.fkProyectos=fkProyectos;
	}
}
