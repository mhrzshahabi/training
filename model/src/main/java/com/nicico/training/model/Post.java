/*
ghazanfari_f, 8/29/2019, 9:11 AM
*/
package com.nicico.training.model;

import lombok.Getter;
import org.hibernate.annotations.Immutable;

import javax.persistence.*;

@Getter
@Entity
@Immutable
@Table(name = "tbl_post")
public class Post extends Auditable {

    @Id
    @Column(name = "id", precision = 10)
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

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_department_id", nullable = false)
    private Department department;

}
