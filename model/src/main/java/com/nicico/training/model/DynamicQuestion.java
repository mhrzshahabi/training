package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;

@Getter
@Setter
@Accessors(chain = true)
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(of = "id", callSuper = false)
@Entity
@Table(name = "tbl_dynamic_question")
public class DynamicQuestion extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_dynamic_question_id")
    @SequenceGenerator(name = "seq_dynamic_question_id", sequenceName = "seq_dynamic_question_id", allocationSize = 1)
    private Long id;

    @Column(name = "f_weight", nullable = false)
    private Integer weight;

    @Column(name = "n_order", nullable = false)
    private Integer order;

    @Column(name = "c_question", nullable = false, unique = true)
    private String question;
}

