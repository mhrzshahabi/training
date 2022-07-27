package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.*;
import java.io.Serializable;

//@Getter
//@Setter
//@NoArgsConstructor
//@AllArgsConstructor
//@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
public class GenericStatisticalIndexReport {

    @Id
    private Long id;

    private String complex;

    private String assistant;

    private String affairs;

    private Long baseOnComplex;

    private Long baseOnAssistant;

    private Long baseOnAffairs;
}