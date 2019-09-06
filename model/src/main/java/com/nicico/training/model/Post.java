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

    @Column(name = "c_code")
    private String code;

    @Column(name = "c_title_fa")
    private String titleFa;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_job_id", nullable = true)
    private Job job;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_post_grade_id", nullable = true)
    private PostGrade postGrade;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_department_id", nullable = true)
    private Department department;

    @Column(name = "e_active")
    EActive eActive;
}
