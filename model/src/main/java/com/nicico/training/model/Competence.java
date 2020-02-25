/*
ghazanfari_f,
1/14/2020,
1:32 PM
*/
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
@Table(name = "tbl_competence")
public class Competence extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_competence_id")
    @SequenceGenerator(name = "seq_competence_id", sequenceName = "seq_competence_id", allocationSize = 1)
    private Long id;

    @Column(name = "c_title", nullable = true, unique = true)
    private String title;

    @Column(name = "c_description")
    private String description;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_parameter_value", nullable = false, insertable = false, updatable = false)
    private ParameterValue competenceType;

    @Column(name = "f_parameter_value")
    private Long competenceTypeId;

}
