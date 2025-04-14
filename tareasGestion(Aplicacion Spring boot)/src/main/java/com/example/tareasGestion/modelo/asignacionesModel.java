package com.example.tareasGestion.modelo;

import java.io.Serializable;
import java.time.LocalDate;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonFormat;
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
@Table(name="tb_asignaciones")
public class asignacionesModel implements Serializable{
	private static final long serialVersionUID = 1L;
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
	private long id;
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
	private LocalDate fechaasing;
	 @ManyToOne(fetch = FetchType.LAZY) // Relación de muchos-a-uno con userModel
	    @JoinColumn(name = "fkUser") // Columna de clave foránea en la tabla tb_asignaciones
	    @JsonBackReference
	 	private userModel fkUser;
	    @ManyToOne(fetch = FetchType.LAZY) // Relación de muchos-a-uno con tareasModel
	    @JoinColumn(name = "fkTareas") // Columna de clave foránea en la tabla tb_asignaciones
	    @JsonIgnore
	    private tareasModel fkTareas;
}
