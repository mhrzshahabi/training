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
@Table(name = "tbl_post_grade")
public class PostGrade extends Auditable {

    @Id
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_code", nullable = false)
    private String code;

    @Column(name = "c_title_fa", nullable = false)
    private String titleFa;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_post_grade_group_id", insertable = false, updatable = false)
    private PostGradeGroup postGradeGroup;

    @Column(name = "f_post_grade_group_id")
    private Long postGradeGroupId;
}
