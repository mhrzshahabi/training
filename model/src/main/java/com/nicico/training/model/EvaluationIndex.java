package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_evaluation_index")
public class EvaluationIndex extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "evaluation_index_seq")
    @SequenceGenerator(name = "evaluation_index_seq", sequenceName = "seq_evaluation_index_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_name_fa", nullable = false)
    private String nameFa;

    @Column(name = "c_name_en")
    private String nameEn;

    @Column(name = "c_description")
    private String description;

    @Column(name = "c_status")
    private String evalStatus;
}
