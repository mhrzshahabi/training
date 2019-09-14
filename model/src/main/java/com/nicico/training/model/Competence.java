/*
ghazanfari_f, 9/7/2019, 10:47 AM
*/
package com.nicico.training.model;

import com.nicico.training.model.enums.ECompetenceInputType;
import com.nicico.training.model.enums.ETechnicalType;
import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.validator.constraints.UniqueElements;

import javax.persistence.*;
import javax.validation.constraints.NotBlank;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = "id", callSuper = false)
@Entity
@Table(name = "tbl_competence_new")
public class Competence extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_competence_id")
    @SequenceGenerator(name = "seq_competence_id", sequenceName = "seq_competence_id", allocationSize = 1)
    private Long id;

    @Column(name = "c_title_fa", nullable = false, unique = true)
    @NotBlank
    private String titleFa;

    @Column(name = "c_title_en")
    private String titleEn;

    @Column(name = "c_code")
    private String code;

    @Column(name = "e_competence_input_type", insertable = false, updatable = false)
    private ECompetenceInputType eCompetenceInputType;

    @Column(name = "e_competence_input_type")
    private Integer ecompetenceInputTypeId;

    @Column(name = "e_technical_type", insertable = false, updatable = false)
    private ETechnicalType eTechnicalType;

    @Column(name = "e_technical_type")
    private Integer etechnicalTypeId;

    @Column(name = "c_description")
    private String description;

}
