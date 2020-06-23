/*
ghazanfari_f, 8/29/2019, 9:11 AM
*/
package com.nicico.training.model;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import org.hibernate.annotations.Immutable;

import javax.persistence.*;
import java.util.Set;

@Getter
@Entity
@Immutable
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Table(name = "tbl_post")
@DiscriminatorValue("Post")
public class Post extends Auditable {

    @Id
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_code", nullable = false, unique = true)
    private String code;

    @Column(name = "c_title_fa", nullable = false)
    private String titleFa;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_job_id")
    private Job job;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_post_grade_id")
    private PostGrade postGrade;

//    @ManyToOne(fetch = FetchType.LAZY)
//    @JoinColumn(name = "f_department_id", nullable = false)
//    private Department department;

    @ManyToMany(mappedBy = "postSet")
    private Set<PostGroup> postGroupSet;

    @Column(name = "c_area")
    private String area;

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

}
