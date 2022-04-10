package com.nicico.training.model;

import com.nicico.training.model.enums.ELevelType;
import com.nicico.training.model.enums.ERunType;
import com.nicico.training.model.enums.ETechnicalType;
import com.nicico.training.model.enums.ETheoType;
import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.envers.AuditOverride;
import org.hibernate.envers.Audited;
import org.hibernate.envers.NotAudited;
import org.hibernate.envers.RelationTargetAuditMode;

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
@Audited(targetAuditMode = RelationTargetAuditMode.NOT_AUDITED)
@AuditOverride(forClass =Auditable.class )
public class Course extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "course_seq")
    @SequenceGenerator(name = "course_seq", sequenceName = "seq_course_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_code", unique = true, nullable = false)
    private String code;

    @Column(name = "c_title_fa")
    private String titleFa;

    @Column(name = "c_title_en")
    private String titleEn;

    @Column(name = "n_theory_duration", length = 5)
    private Float theoryDuration;

    @Column(name = "c_description")
    private String description;

    @Column(name = "n_min_teacher_eval_score")
    private String minTeacherEvalScore;

    @Column(name = "n_min_teacher_exp_years")
    private String minTeacherExpYears;

    @Column(name = "n_min_teacher_degree")
    private String minTeacherDegree;

    @Column(name = "c_evaluation")
    private String evaluation;

    @Column(name = "c_behavioral_level")
    private String behavioralLevel;

    @ManyToOne
    @JoinColumn(name = "category_id")
    @NotAudited
    private Category category;

    @Column(name = "category_id", insertable = false, updatable = false)
    @NotAudited
    private Long categoryId;

    @ManyToOne
    @JoinColumn(name = "subcategory_id")
    @NotAudited
    private Subcategory subCategory;

    @Column(name = "subcategory_id", insertable = false, updatable = false)
    @NotAudited
    private Long subCategoryId;

    @OneToMany(mappedBy = "course")
    @NotAudited
    private Set<Skill> skillSet;

    @OneToMany(mappedBy = "courseMainObjective", cascade = {CascadeType.MERGE})
    @NotAudited
    private Set<Skill> skillMainObjectiveSet;

    @OneToMany(mappedBy = "course", fetch = FetchType.LAZY)
    @NotAudited
    private Set<Tclass> tclassSet;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_course_goal",
            joinColumns = {@JoinColumn(name = "f_course_id", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_goal_id", referencedColumnName = "id")})
    @NotAudited
    private List<Goal> goalSet;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_pre_course", uniqueConstraints = {@UniqueConstraint(columnNames = {"f_course_id", "f_pre_course_id"})},
            joinColumns = {@JoinColumn(name = "f_course_id", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_pre_course_id", referencedColumnName = "id")})
    @NotAudited
    private List<Course> preCourseList;

    @Column(name = "e_run_type")
    @NotAudited
    private ERunType eRunType;

    @Column(name = "e_level_type")
    @NotAudited
    private ELevelType eLevelType;

    @Column(name = "e_theo_type")
    @NotAudited
    private ETheoType eTheoType;

    @Column(name = "e_technical_type")
    private ETechnicalType eTechnicalType;

    @Column(name = "scoring_method")
    private String scoringMethod;

    @Column(name = "c_acceptance_limit")
    private String acceptancelimit;

    @Column(name = "start_evaluation")
    private Integer startEvaluation;

    @Column(name = "c_need_text")
    @NotAudited
    private String needText;

    @OneToMany(mappedBy = "course", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    @NotAudited
    private List<EqualCourse> equalCourses;

    @Column(name = "b_has_goal")
    @NotAudited
    private Boolean hasGoal;

    @Column(name = "c_workflow_status")
    @NotAudited
    private String workflowStatus;

    @Column(name = "c_workflow_status_code")
    @NotAudited
    private Integer workflowStatusCode;

    @PreRemove
    private void preRemove() {
        tclassSet.forEach(c -> c.setCourse(null));
    }

    @Column(name = "n_has_skill")
    @NotAudited
    private Boolean hasSkill;
}
