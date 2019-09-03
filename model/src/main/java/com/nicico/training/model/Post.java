/*
ghazanfari_f, 8/29/2019, 9:11 AM
*/
package com.nicico.training.model;

import com.nicico.training.model.enums.EActive;
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

    @Column(name = "e_active")
    EActive eActive;

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
