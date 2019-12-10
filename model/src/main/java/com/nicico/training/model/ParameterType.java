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
@Table(name = "tbl_parameter_type")
public class ParameterType extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_parameter_type_id")
    @SequenceGenerator(name = "seq_parameter_type_id", sequenceName = "seq_parameter_type_id", allocationSize = 1)
    private Long id;

    @Column(name = "c_title", nullable = false)
    private String title;

    @Column(name = "c_description")
    private String description;
}
