/*
ghazanfari_f, 9/16/2019, 8:22 AM
*/
package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import javax.validation.constraints.NotBlank;

/*@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = "id")
@Entity
@Table(name = "tbl_parameter")*/
public class Parameter1 {

    /*@Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_competence_id")
    @SequenceGenerator(name = "seq_competence_id", sequenceName = "seq_competence_id", allocationSize = 1)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_parameter_type_id")
    private ParameterType parameterType;

    @Column(name = "c_title_fa", nullable = false, unique = true)
    @NotBlank
    private String titleFa;

    @Column(name = "c_description")
    private String description;*/
}
