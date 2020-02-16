package com.nicico.training.model;


import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.Date;
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

    @Column(name = "n_min_capacity")
    private Long minCapacity;

    @Column(name = "n_max_capacity")
    private Long maxCapacity;

    @Column(name = "c_code", nullable = false)
    private String code;

    @Column(name = "c_title_class")
    private String titleClass;

    @Column(name = "c_teaching_type")
    private String teachingType;//روش آموزش

    @Column(name = "n_h_duration")
    private Long hDuration;

    @Column(name = "n_d_duration")
    private Long dDuration;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_teacher", insertable = false, updatable = false)
    private Teacher teacher;

    @Column(name = "f_teacher")
    private Long teacherId;

    @Column(name = "f_supervisor")
    private Long supervisor;

    @Column(name = "c_reason")
    private String reason;

    @Column(name = "c_status")
    private String classStatus;

    @Column(name = "c_status_date")
    private Date classStatusDate;

    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.PERSIST)
    @JoinColumn(name = "f_institute", insertable = false, updatable = false)
    private Institute institute;

    @Column(name = "f_institute")
    private Long instituteId;

    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.PERSIST)
    @JoinColumn(name = "f_institute_organizer", insertable = false, updatable = false)
    private Institute organizer;

    @Column(name = "f_institute_organizer")
    private Long organizerId;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_class_training_place",
            joinColumns = {@JoinColumn(name = "f_class_id", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_training_place_id", referencedColumnName = "id")})
    private Set<TrainingPlace> trainingPlaceSet;

    @Column(name = "n_group", nullable = false)
    private Long group;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_term", insertable = false, updatable = false)
    private Term term;

    @Column(name = "f_term")
    private Long termId;

    @Column(name = "c_teaching_brand")
    private String teachingBrand;//نحوه آموزش
    @Column(name = "c_start_date", nullable = false)
    private String startDate;
    @Column(name = "c_end_date", nullable = false)
    private String endDate;
    @Column(name = "b_saturday")
    private Boolean saturday;
    @Column(name = "b_sunday")
    private Boolean sunday;
    @Column(name = "b_monday")
    private Boolean monday;
    @Column(name = "b_tuesday")
    private Boolean tuesday;
    @Column(name = "b_wednesday")
    private Boolean wednesday;
    @Column(name = "b_thursday")
    private Boolean thursday;
    @Column(name = "b_friday")
    private Boolean friday;
    @Column(name = "b_first")
    private Boolean first;
    @Column(name = "b_second")
    private Boolean second;
    @Column(name = "b_third")
    private Boolean third;
    @Column(name = "b_fourth")
    private Boolean fourth;
    @Column(name = "b_fifth")
    private Boolean fifth;
    @Column(name = "c_topology")
    private String topology;

    @Column(name = "c_scoring_method")
    private String scoringMethod;

    @Column(name = "c_acceptance_limit")
    private String acceptancelimit;

    @Column(name = "start_evaluation")
    private Integer startEvaluation;

    @Column(name = "c_workflow_ending_status")
    private String workflowEndingStatus;
    @Column(name = "c_workflow_ending_status_code")
    private Integer workflowEndingStatusCode;

    @OneToMany(mappedBy = "tclass", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE, orphanRemoval = true)
    private Set<ClassStudent> classStudents;

    @OneToMany(mappedBy = "tclass", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
    private Set<ClassSession> classSessions;

    @ElementCollection
    @CollectionTable(name = "tbl_class_pre_course_test_question", joinColumns = @JoinColumn(name = "f_course_id"), uniqueConstraints = {@UniqueConstraint(columnNames = {"f_course_id", "c_pre_course_test_question"})})
    @OrderColumn(name = "n_order", nullable = false)
    @Column(name = "c_pre_course_test_question", nullable = false, length = 1000)
    private List<String> preCourseTestQuestions;

    @Column(name = "pre_course_test")
    private Boolean preCourseTest;

    @Transient
    public List<Long> getTrainingPlaceIds() {
        List<Long> ids = new ArrayList<>();
        trainingPlaceSet.forEach(c -> ids.add(c.getId()));
        return ids;
    }

    @Transient
    @Getter(AccessLevel.NONE)
    @Setter(AccessLevel.NONE)
    private String hasWarning;

    @Transient
    public String getHasWarning() {
        return "";
    }

}
