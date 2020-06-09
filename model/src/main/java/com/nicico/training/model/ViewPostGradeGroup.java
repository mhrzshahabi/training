package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.Id;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from view_post_grade_group")
@DiscriminatorValue("ViewPostGradeGroup")
public class ViewPostGradeGroup extends Auditable {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "c_title_fa", nullable = false)
    private String titleFa;

    @Column(name = "c_code", unique = true)
    private String code;

    @Column(name = "c_title_en")
    private String titleEn;

    @Column(name = "c_description")
    private String description;

    @Column(name = "n_competence_count")
    private Integer competenceCount;

    @Column(name = "n_personnel_count")
    private Integer personnelCount;
}
