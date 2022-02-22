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
@Table(name = "tbl_teacher")
public class Teacher extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "teacher_seq")
    @SequenceGenerator(name = "teacher_seq", sequenceName = "seq_teacher_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_teacher_code", nullable = false, unique = true)
    private String teacherCode;

    @Column(name = "b_enabled")
    private Boolean enableStatus;

    @Column(name = "b_in_black_list")
    private boolean inBlackList;

    @Column(name = "c_black_list_description")
    private String blackListDescription;

    @Column(name = "b_personnel")
    private Boolean personnelStatus;

    @Column(name = "c_personnel_code")
    private String personnelCode;

    @OneToOne(fetch = FetchType.LAZY, cascade = {CascadeType.PERSIST, CascadeType.REFRESH, CascadeType.MERGE})
    @JoinColumn(name = "f_personality")
    private PersonalInfo personality;

    @Column(name = "f_personality", nullable = false, insertable = false, updatable = false)
    private Long personalityId;

    @Column(name = "F_TEACHING_BACKGROUND")
    private Long teachingBackground;

    @Column(name = "C_IBAN")
    private String iban;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_teacher_category",
            joinColumns = {@JoinColumn(name = "f_teacher", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_category", referencedColumnName = "id")})
    private Set<Category> categories;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_teacher_subcategory",
            joinColumns = {@JoinColumn(name = "f_teacher", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_subcategory", referencedColumnName = "id")})
    private Set<Subcategory> subCategories;

    @Column(name = "c_economical_code")
    private String economicalCode;

    @Column(name = "c_economical_record_number")
    private String economicalRecordNumber;

    @OneToMany(mappedBy = "teacher", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<EmploymentHistory> employmentHistories;

    @OneToMany(mappedBy = "teacher", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<TeachingHistory> teachingHistories;

    @OneToMany(mappedBy = "teacher", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<TeacherCertification> teacherCertifications;

    @OneToMany(mappedBy = "teacher", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<ForeignLangKnowledge> foreignLangKnowledges;

    @OneToMany(mappedBy = "teacher", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Publication> publications;

    @OneToMany(mappedBy = "teacher", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<AcademicBK> academicBKs;

    @Column(name = "c_other_activities", length = 500)
    private String otherActivities;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_major_category", insertable = false, updatable = false)
    private Category majorCategory;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_major_sub_category", insertable = false, updatable = false)
    private Subcategory majorSubCategory;

    @Column(name = "f_major_category")
    private Long majorCategoryId;

    @Column(name = "f_major_sub_category")
    private Long majorSubCategoryId;

    @OneToMany(mappedBy = "teacher", fetch = FetchType.LAZY)
    private Set<Tclass> tclasse;
}
