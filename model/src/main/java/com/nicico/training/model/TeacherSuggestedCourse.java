package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_teacher_suggested_course")
public class TeacherSuggestedCourse {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "teacher_suggested_course_seq")
    @SequenceGenerator(name = "teacher_suggested_course_seq", sequenceName = "seq_teacher_suggested_course_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_course_title")
    private String courseTitle;
}
