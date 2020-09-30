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
@Table(name = "tbl_term")
public class Term extends Auditable {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "term_seq")
    @SequenceGenerator(name = "term_seq", sequenceName = "seq_term_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_code", unique = true, nullable = false)
    private String code;

    @Column(name = "c_title_fa",nullable = false)
    private String titleFa;

    @Column(name = "c_startdate",nullable = false)
    private String startDate;

    @Column(name = "c_enddate",nullable = false)
    private String endDate;


    @Column(name = "c_description")
    private String description;

}
