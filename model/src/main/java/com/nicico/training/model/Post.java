package com.nicico.training.model;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import org.hibernate.annotations.Immutable;

import javax.persistence.*;
import java.util.Date;
import java.util.Set;

@Getter
@Entity
@Immutable
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Table(name = "tbl_post",
        uniqueConstraints = {@UniqueConstraint(columnNames = {"c_code", "c_people_type"})})
@DiscriminatorValue("Post")
public class Post extends Auditable {

    @Id
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_code")
    private String code;

    @Column(name = "c_title_fa")
    private String titleFa;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_job_id")
    private Job job;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_post_grade_id")
    private PostGrade postGrade;

    @ManyToMany(mappedBy = "postSet")
    private Set<PostGroup> postGroupSet;

    @ManyToMany(mappedBy = "postSet")
    private Set<TrainingPost> trainingPostSet;

    @Column(name = "c_area")
    private String area;

    @Column(name = "c_mojtame_title")
    private String mojtameTitle;

    @Column(name = "c_assistance")
    private String assistance;

    @Column(name = "c_affairs")
    private String affairs;

    @Column(name = "c_section")
    private String section;

    @Column(name = "c_unit")
    private String unit;

    @Column(name = "c_cost_center_code")
    private String costCenterCode;

    @Column(name = "c_cost_center_title_fa")
    private String costCenterTitleFa;

    @Column(name = "c_people_type", length = 50)
    private String peopleType;

    @Column(name = "f_department_id")
    private Long departmentId;

    @Column(name = "d_last_modified_date_na")
    private Date lastModifiedDateNA;

    @Column(name = "c_modified_by_na")
    private String modifiedByNA;

    @Column(name = "n_parent_id")
    private Long parentID;
}
