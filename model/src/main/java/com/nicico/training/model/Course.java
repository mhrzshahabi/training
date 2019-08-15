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
@EqualsAndHashCode(of = {"id"},callSuper = false)
@Entity
@Table(name = "tbl_course", schema = "training")
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
    private String theoryDuration;

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

    @ManyToOne(fetch = FetchType.LAZY,cascade = {CascadeType.PERSIST})
    @JoinColumn(name = "category_id",insertable = false, updatable = false)
    private Category category;

    @Column(name="category_id")
    private Long categoryId;

    @ManyToOne(fetch = FetchType.LAZY,cascade = {CascadeType.PERSIST})
    @JoinColumn(name = "subcategory_id",insertable = false, updatable = false)
    private SubCategory subCategory;

    @Column(name="subcategory_id")
    private Long subCategoryId;

    @ManyToMany(mappedBy = "courseSet")
    private Set<Skill> skillSet;

    @OneToMany(mappedBy = "course" ,fetch = FetchType.LAZY)
    private Set<Tclass> tclassSet;

    @PreRemove
    private void preRemove() {
        tclassSet.forEach( c -> c.setCourse(null));
    }

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_course_goal", schema = "training",
            joinColumns = {@JoinColumn(name = "f_course_id", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_goal_id", referencedColumnName = "id")})
    private List<Goal> goalSet;

    @Column(name = "e_run_type")
    private ERunType eRunType;

    @Column(name = "e_level_type")
    private ELevelType eLevelType;

    @Column(name = "e_theo_type")
    private ETheoType eTheoType;

    @Column(name = "e_technical_type")
    private ETechnicalType eTechnicalType;

//    @OneToMany(mappedBy = "course")
//    private Set<PreCourse> preCourseSet;
}
