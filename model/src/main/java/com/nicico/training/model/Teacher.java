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

    @OneToOne(fetch = FetchType.LAZY, cascade = {CascadeType.PERSIST, CascadeType.REFRESH, CascadeType.MERGE})
    @JoinColumn(name = "f_personality")
    private PersonalInfo personality;

    @Column(name = "f_personality", nullable = false, insertable = false, updatable = false)
    private Long personalityId;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_teacher_category",
            joinColumns = {@JoinColumn(name = "f_teacher", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_category", referencedColumnName = "id")})
    private Set<Category> categories;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_teacher_sub_category",
            joinColumns = {@JoinColumn(name = "f_teacher", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_sub_category", referencedColumnName = "id")})
    private Set<SubCategory> subCategories;

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

    @Column(name = "c_other_activities", length = 500)
    private String otherActivities;
}
