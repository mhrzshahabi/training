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
@Table(name = "tbl_class")
public class Tclass extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "class_seq")
    @SequenceGenerator(name = "class_seq", sequenceName = "seq_class_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private long id;

    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.PERSIST)
    @JoinColumn(name = "f_course", insertable = false, updatable = false)
    private Course course;

    @Column(name = "f_course")
    private Long courseId;

    @Column(name = "c_reason")
    private String reason;

    @Column(name = "c_title_class")
    private String titleClass;

    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.PERSIST)
    @JoinColumn(name = "f_institute", insertable = false, updatable = false)
    private Institute institute;

    @Column(name = "f_institute")
    private Long instituteId;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_class_training_place",
            joinColumns = {@JoinColumn(name = "f_class_id", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_training_place_id", referencedColumnName = "id")})
    private Set<TrainingPlace> trainingPlaceSet;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_term", insertable = false, updatable = false)
    private Term term;

    @Column(name = "f_term")
    private Long termId;

    @Column(name = "n_group", nullable = false)
    private Long group;

    @Column(name = "c_teaching_type")
    private String teachingType;//روش آموزش

    @Column(name = "c_teaching_brand")
    private String teachingBrand;//نحوه آموزش

    @Column(name = "c_code", nullable = false)
    private String code;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_class_teacher",
            joinColumns = {@JoinColumn(name = "f_class_id", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_teacher_id", referencedColumnName = "id")})
    private Set<Teacher> teacherSet;

    @Column(name = "c_start_date", nullable = false)
    private String startDate;

    @Column(name = "c_end_date", nullable = false)
    private String endDate;

    @Column(name = "c_week_days")
    private String weekDays;

    @Column(name = "f_supervisor")
    private Long supervisor;

    @Column(name = "c_state")
    private String state;

    @Column(name = "c_topology")
    private String topology;//چیدمان

    @Column(name = "n_duration")
    private Long duration;

    @ManyToMany(fetch = FetchType.LAZY, cascade = {CascadeType.PERSIST})
    @JoinTable(name = "tbl_student_class",
            joinColumns = {@JoinColumn(name = "f_class", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_student", referencedColumnName = "id")})
    private List<Student> studentSet;




}
