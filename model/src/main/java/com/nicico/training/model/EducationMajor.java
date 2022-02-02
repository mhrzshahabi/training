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
@Table(name = "tbl_education_major")
public class EducationMajor extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "education_major_seq")
    @SequenceGenerator(name = "education_major_seq", sequenceName = "seq_education_major_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_title_fa", nullable = false, unique = true)
    private String titleFa;

    @Column(name = "c_title_en")
    private String titleEn;

    @OneToMany(mappedBy = "educationMajor", fetch = FetchType.LAZY)
    private List<EducationOrientation> educationOrientationList;

    @OneToMany(mappedBy = "educationMajor", fetch = FetchType.LAZY)
    private List<PersonalInfo> personalInfoList;
}
