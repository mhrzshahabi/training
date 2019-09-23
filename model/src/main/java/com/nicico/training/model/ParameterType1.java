/*
ghazanfari_f, 9/16/2019, 8:22 AM
*/
package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import javax.validation.constraints.NotBlank;
import java.util.Set;

/*@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = "id")
@Entity
@Table(name = "tbl_parameter_type")*/
public class ParameterType1 {

    /*@Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_parameter_id")
    @SequenceGenerator(name = "seq_parameter_id", sequenceName = "seq_parameter_id", allocationSize = 1)
    private Long id;

    @Column(name = "c_title_fa", nullable = false, unique = true)
    @NotBlank
    private String titleFa;

    @OneToMany(mappedBy = "parameterType")
    private Set<Parameter> parameters;

    @Column(name = "c_description")
    private String description;*/
}
