package com.nicico.training.model;/*
com.nicico.training.model
@author : banifatemi
@Date : 5/28/2019
@Time :11:14 AM
    */

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.Set;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain=true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_skill")

public class Skill extends Auditable{
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE,generator = "skill_seq")
    @SequenceGenerator(name = "skill_seq",sequenceName = "seq_skill_id",allocationSize = 1)
    @Column(name = "id",precision = 0)
    private Long id;

    @Column(name = "c_code",length = 10,nullable = false,unique = true)
    private String code;

    @Column(name = "c_title_fa", nullable = false)
    private String titleFa;

    @Column(name = "c_title_en")
    private String titleEn;

    @Column(name = "c_description", length = 500)
    private String description;

//معرفی سطح مهارت(آشنایی، توانایی و تسلط)
    @ManyToOne
    @JoinColumn(name = "f_skill_level", nullable = false,insertable = false, updatable = false)
    private SkillLevel skillLevel;

    @Column(name = "f_skill_level")
    private Long skillLevelId;

//  گروه بندی مهارت(کامپیوتر/برق/...)
    @ManyToOne
    @JoinColumn(name = "f_category", nullable = false,insertable = false, updatable = false)
    private Category category;

    @Column(name = "f_category")
    private Long categoryId;


    @OneToMany(mappedBy = "skill" ,fetch = FetchType.LAZY)
    private Set<NeedAssessment> needAssessments;

//زیر گروه مثلا برای گروه کامپیوتر (شبکه، سخت افزار و ...)
    @ManyToOne
    @JoinColumn(name = "f_sub_category", nullable = false,insertable = false, updatable = false)
    private SubCategory subCategory;

    @Column(name = "f_sub_category")
    private Long subCategoryId;

    //-------------------------------------------------
    @ManyToMany(fetch = FetchType.LAZY, cascade = CascadeType.PERSIST)
	@JoinTable(name = "tbl_skill_course",
            joinColumns = {@JoinColumn(name = "f_skill_id", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_course_id", referencedColumnName = "id")})
    private Set<Course> courseSet;

    @ManyToMany(fetch = FetchType.LAZY,mappedBy = "skillSet" )
    private Set<SkillGroup> skillGroupSet;


}
