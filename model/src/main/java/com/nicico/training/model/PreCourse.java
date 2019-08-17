package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_pre_course")
public class PreCourse extends Auditable {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "pre_course_seq")
    @SequenceGenerator(name = "pre_course_seq", sequenceName = "seq_pre_course_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "pre_course_set")
    private String preCourseSet;

    @ManyToOne()
    @JoinColumn(name = "f_pre_course")
    private Course course1;

//    @Column(name = "f_pre_course")
//    private Long courseId;
}
