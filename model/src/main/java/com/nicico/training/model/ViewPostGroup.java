package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.*;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from view_post_group")
@DiscriminatorValue("ViewPostGroup")
public class ViewPostGroup extends Auditable {

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

    @Column(name = "d_last_modified_date_na")
    private Date lastModifiedDateNA;

    @Column(name = "c_modified_by_na")
    private String modifiedByNA;

    @Column(name = "committee")
    private String committee;


    @Column(name = "has_committee")
    private Boolean hasCommittee;
}
