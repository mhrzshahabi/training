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
@Table(name = "tbl_parameter_value", uniqueConstraints = {@UniqueConstraint(columnNames = {"f_parameter_id", "c_title"})})
public class ParameterValue extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_parameter_value_id")
    @SequenceGenerator(name = "seq_parameter_value_id", sequenceName = "seq_parameter_value_id", allocationSize = 1)
    private Long id;

    @Column(name = "c_title", nullable = false)
    private String title;

    @Column(name = "c_code", nullable = false, unique = true)
    private String code;

    @Column(name = "c_type")
    private String type;

    @Column(name = "c_value")
    private String value;

    @Column(name = "c_description")
    private String description;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_parameter_id", insertable = false, updatable = false)
    private Parameter parameter;

    @Column(name = "f_parameter_id")
    private Long parameterId;

//    @ManyToOne(fetch = FetchType.LAZY)
//    @JoinColumn(name = "f_question_bank", insertable = false, updatable = false)
//    private QuestionBank questionTarget;
//
//    @Column(name = "f_question_bank")
//    private Long questionBankId;
}