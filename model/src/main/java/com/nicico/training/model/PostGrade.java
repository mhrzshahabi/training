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
@Table(name = "tbl_post_grade")
public class PostGrade extends Auditable {

    @Id
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_code", nullable = false, unique = true)
    private String code;

    @Column(name = "c_title_fa", nullable = false)
    private String titleFa;

    @ManyToMany(mappedBy = "postGradeSet", fetch = FetchType.LAZY)
    private Set<PostGradeGroup> postGradeGroup;

    @OneToMany(mappedBy = "postGrade", fetch = FetchType.LAZY)
    private Set<Post> postSet;

}
