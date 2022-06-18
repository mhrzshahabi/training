package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.Id;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from view_post_grade")
@DiscriminatorValue("ViewPostGrade")
public class ViewPostGrade extends Auditable {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "c_title_fa", nullable = false)
    private String titleFa;

    @Column(name = "c_title_fa_2", nullable = false)
    private String titleFa2;

    @Column(name = "c_code", unique = true, nullable = false)
    private String code;

    @Column(name = "c_people_type")
    private String peopleType;

    @Column(name = "n_competence_count")
    private Integer competenceCount;

    @Column(name = "n_personnel_count")
    private Integer personnelCount;

    @Column(name = "d_last_modified_date_na")
    private Date lastModifiedDateNA;

    @Column(name = "c_modified_by_na")
    private String modifiedByNA;
}
