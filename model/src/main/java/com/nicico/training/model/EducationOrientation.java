package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.List;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_education_orientation",
        uniqueConstraints = {@UniqueConstraint(columnNames = {"c_title_fa", "f_education_level", "f_education_major"})})
public class EducationOrientation extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "education_orientation_seq")
    @SequenceGenerator(name = "education_orientation_seq", sequenceName = "seq_education_orientation_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_title_fa", nullable = false)
    private String titleFa;

    @Column(name = "c_title_en")
    private String titleEn;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_education_level", insertable = false, updatable = false)
    private EducationLevel educationLevel;

    @Column(name = "f_education_level")
    private Long educationLevelId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_education_major", insertable = false, updatable = false)
    private EducationMajor educationMajor;

    @Column(name = "f_education_major")
    private Long educationMajorId;

    @OneToMany(mappedBy = "educationOrientation", fetch = FetchType.LAZY)
    private List<PersonalInfo> personalInfoList;
}
