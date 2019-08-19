package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;


import javax.persistence.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"},callSuper = false)
@Entity
@Table(name = "tbl_term", schema = "training")
public class Term extends Auditable{
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "Term_seq")
    @SequenceGenerator(name = "Term_seq", sequenceName = "seq_Term_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_code")
    private String code;

    @Column(name = "c_title_fa")
    private String titleFa;

    @Column(name="c_startdate")
    private String startDate;

     @Column(name="c_enddate")
    private String endDate;


    @Column(name = "c_description")
    private String description;

}
