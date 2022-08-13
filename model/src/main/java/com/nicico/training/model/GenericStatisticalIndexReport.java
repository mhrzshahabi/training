package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_generic_statistical_index_report")
public class GenericStatisticalIndexReport {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "complex")
    private String complex;

    @Column(name = "complex_id")
    private Long complexId;

    @Column(name = "assistant")
    private String assistant;

    @Column(name = "assistant_id")
    private Long assistantId;

    @Column(name = "affairs")
    private String affairs;

    @Column(name = "affairs_id")
    private Long affairsId;

    @Column(name = "n_base_on_complex")
    private Double baseOnComplex;

    @Column(name = "n_base_on_assistant")
    private Double baseOnAssistant;

    @Column(name = "n_base_on_affairs")
    private Double baseOnAffairs;
}