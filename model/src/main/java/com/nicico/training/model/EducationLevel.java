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
@Table(name = "tbl_education_level")
public class EducationLevel extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "education_level_seq")
    @SequenceGenerator(name = "education_level_seq", sequenceName = "seq_education_level_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_title_fa", nullable = false, unique = true)
    private String titleFa;

    @Column(name = "n_code")
    private Integer code;

    @Column(name = "c_title_en")
    private String titleEn;

    @OneToMany(mappedBy = "educationLevel", fetch = FetchType.LAZY)
    private List<EducationOrientation> educationOrientationList;

    @OneToMany(mappedBy = "educationLevel", fetch = FetchType.LAZY)
    private List<PersonalInfo> personalInfoList;
}