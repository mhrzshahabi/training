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
@Table(name = "tbl_parameter_value")
public class ParameterValue extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_parameter_value_id")
    @SequenceGenerator(name = "seq_parameter_value_id", sequenceName = "seq_parameter_value_id", allocationSize = 1)
    private Long id;

    @Column(name = "c_title", nullable = false)
    private String value;

    @Column(name = "c_description")
    private String description;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_parameter_type_id", insertable = false, updatable = false)
    private ParameterType parameterType;

    @Column(name = "f_parameter_type_id")
    private Long parameterTypeId;

}
