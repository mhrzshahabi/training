package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_skill")

public class Skill extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "skill_seq")
    @SequenceGenerator(name = "skill_seq", sequenceName = "seq_skill_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_code", length = 10, nullable = false, unique = true)
    private String code;

    @Column(name = "c_title_fa", nullable = false)
    private String titleFa;

    @Column(name = "c_title_en")
    private String titleEn;

    @Column(name = "c_description", length = 500)
    private String description;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_skill_level", nullable = false, insertable = false, updatable = false)
    private SkillLevel skillLevel;

    @Column(name = "f_skill_level")
    private Long skillLevelId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_category", nullable = false, insertable = false, updatable = false)
    private Category category;

    @Column(name = "f_category")
    private Long categoryId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_sub_category", nullable = false, insertable = false, updatable = false)
    private Subcategory subCategory;

    @Column(name = "f_sub_category")
    private Long subCategoryId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_main_objective_course", insertable = false, updatable = false)
    private Course courseMainObjective;

    @Column(name = "f_main_objective_course")
    private Long courseMainObjectiveId;

    @ManyToOne
    @JoinColumn(name = "f_course", insertable = false, updatable = false)
    private Course course;

    @Column(name = "f_course")
    private Long courseId;

    @OneToMany(mappedBy = "skill", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE, orphanRemoval = true)
    private List<NeedsAssessment> needsAssessments;
}
