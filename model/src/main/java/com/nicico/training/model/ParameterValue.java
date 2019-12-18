package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;

@Getter
@Setter
@Accessors(chain = true)
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(of = "id")
@Entity
@Table(name = "tbl_parameter_value")
public class ParameterValue extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_parameter_value_id")
    @SequenceGenerator(name = "seq_parameter_value_id", sequenceName = "seq_parameter_value_id", allocationSize = 1)
    private Long id;

    @Column(name = "c_title", nullable = false)
    private String title;

    @Column(name = "c_code")
    private String code;

    @Column(name = "c_description")
    private String description;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_parameter_id", insertable = false, updatable = false)
    private Parameter parameter;

    @Column(name = "f_parameter_id")
    private Long parameterId;
}