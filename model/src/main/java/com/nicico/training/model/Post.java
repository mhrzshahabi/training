/*
ghazanfari_f, 8/29/2019, 9:11 AM
*/
package com.nicico.training.model;

import com.nicico.training.model.enums.EActive;
import com.nicico.training.model.enums.EDeleted;
import lombok.EqualsAndHashCode;
import lombok.Getter;

import javax.persistence.*;

@Entity
@Table(name = "tbl_post")
@Getter
@EqualsAndHashCode(of = "id")
public class Post {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "c_code", nullable = false)
    private String code;

    @Column(name = "c_title_fa", nullable = false)
    private String titleFa;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_job_id", nullable = false)
    private Job job;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_post_grade_id", nullable = false)
    private PostGrade postGrade;

    @Column(name = "c_cost_center_code", nullable = false)
    private String costCenterCode;

    @Column(name = "c_cost_center_title_fa", nullable = false)
    private String costCenterTitleFa;

    @Column(name = "c_department_area")
    private String departmentArea;

    @Column(name = "c_department_assistance")
    private String departmentAssistance;

    @Column(name = "c_department_affairs")
    private String departmentAffairs;

    @Column(name = "c_department_section")
    private String departmentSection;

    @Column(name = "c_department_unit")
    private String departmentUnit;

    @Column(name = "e_active")
    EActive eActive;

    @Column(name = "e_deleted")
    EDeleted eDeleted;
}
