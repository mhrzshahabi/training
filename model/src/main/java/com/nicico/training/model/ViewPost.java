package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.*;
import java.util.Set;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from view_post")
@DiscriminatorValue("ViewPost")
public class ViewPost extends Auditable {
    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "c_code", unique = true, nullable = false)
    private String code;

    @Column(name = "c_title_fa", nullable = false)
    private String titleFa;

    @Column(name = "c_affairs")
    private String affairs;

    @Column(name = "c_area")
    private String area;

    @Column(name = "c_assistance")
    private String assistance;

    @Column(name = "c_cost_center_title_fa")
    private String costCenterTitleFa;

    @Column(name = "c_cost_center_code")
    private String costCenterCode;

    @Column(name = "c_section")
    private String section;

    @Column(name = "c_unit")
    private String unit;

    @Column(name = "f_post_grade_id")
    private Long postGradeId;

    @Column(name = "f_job_id")
    private Long jobId;

    @Column(name = "n_competence_count")
    private Integer competenceCount;

    @Column(name = "n_personnel_count")
    private Integer personnelCount;

    @ManyToMany(mappedBy = "postSet")
    private Set<PostGroup> postGroupSet;
}
