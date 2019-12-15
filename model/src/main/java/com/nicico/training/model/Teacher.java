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

    @OneToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "f_personality", nullable = false, insertable = false, updatable = false)
    private PersonalInfo personality;

    @Column(name = "f_personality")
    private Long personalityId;

    @ManyToMany(fetch = FetchType.LAZY, cascade = {CascadeType.PERSIST})
    @JoinTable(name = "tbl_teacher_category",
            joinColumns = {@JoinColumn(name = "f_teacher", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_category", referencedColumnName = "id")})
    private Set<Category> categories;

    @Column(name = "c_economical_code")
    private String economicalCode;

    @Column(name = "c_economical_record_number")
    private String economicalRecordNumber;

    @OneToMany(mappedBy = "teacher", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<EmploymentHistory> employmentHistories;
}
