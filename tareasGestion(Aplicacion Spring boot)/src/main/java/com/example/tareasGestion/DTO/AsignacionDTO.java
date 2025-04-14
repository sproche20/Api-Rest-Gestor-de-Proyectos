package com.example.tareasGestion.DTO;

import java.time.LocalDate;

import com.example.tareasGestion.modelo.asignacionesModel;
import com.example.tareasGestion.modelo.tareasModel;
import com.example.tareasGestion.modelo.userModel;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.Entity;
import lombok.Data;
@Data
public class AsignacionDTO {
    private Long id;
    private String fechaasing;
    private Long fkUser;
    private Long fkTareas;
    

    public AsignacionDTO(
    		Long id,
    		LocalDate fechaasing,
    		Long fkUser,
    		Long fkTareas) {
        this.id = id;
        this.fechaasing = fechaasing.toString(); // Convertir LocalDate a String
        this.fkUser = fkUser;
        this.fkTareas = fkTareas;
    }
}
