package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.List;
import java.util.Set;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_teacher_presentable_course")
public class TeacherPresentableCourse  extends Auditable{
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "teacher_presentable_course_seq")
    @SequenceGenerator(name = "teacher_presentable_course_seq", sequenceName = "seq_teacher_presentable_course_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_course_title")
    private String courseTitle;
    @Column(name="c_course_id")
    private Long courseId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "c_course_id", insertable = false, updatable = false)
    private Course course;


    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_teacher_presentable_course_category",
            joinColumns = {@JoinColumn(name = "f_teacher_presentable_course", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_category", referencedColumnName = "id")})
    private Set<Category> categories;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_teacher_presentable_course_subcategory",
            joinColumns = {@JoinColumn(name = "f_teacher_presentable_course", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_subcategory", referencedColumnName = "id")})
    private Set<Subcategory> subCategories;

    @Column(name = "n_duration")
    private String duration;

//    @ManyToMany(fetch = FetchType.LAZY)
//    @JoinTable(name = "tbl_pre_course", uniqueConstraints = {@UniqueConstraint(columnNames = {"f_teacher_presentable_course_id", "f_pre_course_id"})},
//            joinColumns = {@JoinColumn(name = "f_teacher_presentable_course", referencedColumnName = "id")},
//            inverseJoinColumns = {@JoinColumn(name = "f_pre_course_id", referencedColumnName = "id")})
//    private List<Course> preCourseList;


//   private List<String> courseHeaders;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_teacher_id", insertable = false, updatable = false)
    private Teacher teacher;

    @Column(name = "f_teacher_id")
    private Long teacherId;

    @Column(name="c_description")
    private String description;

}
