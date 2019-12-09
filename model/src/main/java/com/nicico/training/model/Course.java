package com.nicico.training.model;


import com.nicico.training.model.enums.ELevelType;
import com.nicico.training.model.enums.ERunType;
import com.nicico.training.model.enums.ETechnicalType;
import com.nicico.training.model.enums.ETheoType;
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
@Table(name = "tbl_course")
public class Course extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "Course_seq")
    @SequenceGenerator(name = "Course_seq", sequenceName = "seq_Course_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_code")
    private String code;

    @Column(name = "c_title_fa")
    private String titleFa;

    @Column(name = "c_title_en")
    private String titleEn;

    @Column(name = "n_theory_duration", length = 5)
    private Float theoryDuration;

    @Column(name = "c_description")
    private String description;

    @Column(name = "c_main_objective")
    private String mainObjective;

    @Column(name = "n_min_teacher_eval_score")
    private String minTeacherEvalScore;

    @Column(name = "n_min_teacher_exp_years")
    private String minTeacherExpYears;

    @Column(name = "n_min_teacher_degree")
    private String minTeacherDegree;

    @ManyToOne(fetch = FetchType.LAZY, cascade = {CascadeType.PERSIST})
    @JoinColumn(name = "category_id", insertable = false, updatable = false)
    private Category category;

    @Column(name = "category_id")
    private Long categoryId;

    @ManyToOne(fetch = FetchType.LAZY, cascade = {CascadeType.PERSIST})
    @JoinColumn(name = "subcategory_id", insertable = false, updatable = false)
    private SubCategory subCategory;

    @Column(name = "subcategory_id")
    private Long subCategoryId;

    @ManyToMany(mappedBy = "courseSet")
    private Set<Skill> skillSet;

    @OneToMany(mappedBy = "course", fetch = FetchType.LAZY)
    private Set<Tclass> tclassSet;
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_course_goal",
            joinColumns = {@JoinColumn(name = "f_course_id", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_goal_id", referencedColumnName = "id")})
    private List<Goal> goalSet;
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_pre_course",
            joinColumns = {@JoinColumn(name = "f_course_id", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_pre_course_id", referencedColumnName = "id")})
    private List<Course> perCourseList;
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_pre_course",
            joinColumns = {@JoinColumn(name = "f_pre_course_id", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_course_id", referencedColumnName = "id")})
    private List<Course> perCourseListOf;
    @Column(name = "e_run_type")
    private ERunType eRunType;
    @Column(name = "e_level_type")
    private ELevelType eLevelType;
    @Column(name = "e_theo_type")
    private ETheoType eTheoType;
    @Column(name = "e_technical_type")
    private ETechnicalType eTechnicalType;
    @Column(name = "c_pre_course")
    private String preCourse;

    //    @Transient
//    private Long knowledge = Long.valueOf(0);
//
//    @Transient
//    private Long skill = Long.valueOf(0);
//
//    @Transient
//    private Long attitude = Long.valueOf(0);
    @Column(name = "c_equal_course")
    private String equalCourse;
    @Column(name = "c_need_text")
    private String needText;
    @OneToMany()
    @JoinColumn(name = "f_course", insertable = false, updatable = false)
    private Set<EqualCourse> equalCourseSet;

    @Transient
    @Getter(AccessLevel.NONE)
    @Setter(AccessLevel.NONE)
    private Boolean hasGoal;

//    @ManyToOne(cascade={CascadeType.ALL})
//    @JoinColumn(name="pre_course_id")
//    private Course preCourse;
//
//    @OneToMany(mappedBy="preCourse")
//    private List<Course> preCourseList = new ArrayList<>();

    @PreRemove
    private void preRemove() {
        tclassSet.forEach(c -> c.setCourse(null));
    }

    @Transient
    public Boolean getHasGoal() {
        if(goalSet == null)return false;
        else return goalSet.isEmpty();
    }

    @Column(name = "c_workflow_status")
    private String workflowStatus;

    @Column(name = "c_workflow_status_code")
    private Integer workflowStatusCode;
}
