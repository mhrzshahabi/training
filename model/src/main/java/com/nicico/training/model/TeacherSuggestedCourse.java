package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.Set;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_teacher_suggested_course")
public class TeacherSuggestedCourse extends Auditable{
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "teacher_suggested_course_seq")
    @SequenceGenerator(name = "teacher_suggested_course_seq", sequenceName = "seq_teacher_suggested_course_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_course_title")
    private String courseTitle;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_teacher_suggested_course_category",
            joinColumns = {@JoinColumn(name = "f_teacher_suggested_course", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_category", referencedColumnName = "id")})
    private Set<Category> categories;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_teacher_suggested_course_subcategory",
            joinColumns = {@JoinColumn(name = "f_teacher_suggested_course", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_subcategory", referencedColumnName = "id")})
    private Set<Subcategory> subcategories;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_teacher_id", insertable = false, updatable = false)
    private Teacher teacher;

    @Column(name = "f_teacher_id")
    private Long teacherId;

    @Column(name="c_course_description")
    private String description;
}
