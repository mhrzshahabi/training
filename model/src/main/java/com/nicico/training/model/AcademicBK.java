package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_academic_bk")
public class AcademicBK extends Auditable {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "academic_bk_seq")
    @SequenceGenerator(name = "academic_bk_seq", sequenceName = "seq_academic_bk_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_education_level", insertable = false, updatable = false, nullable = false)
    private EducationLevel educationLevel;

    @Column(name = "f_education_level")
    private Long educationLevelId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_education_major", insertable = false, updatable = false, nullable = false)
    private EducationMajor educationMajor;

    @Column(name = "f_education_major")
    private Long educationMajorId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_education_orienation", insertable = false, updatable = false)
    private EducationOrientation educationOrientation;

    @Column(name = "f_education_orienation")
    private Long educationOrientationId;

    @Column(name = "c_date")
    private String date;

    @Column(name = "c_duration")
    private String duration;

    @Column(name = "c_academic_grade")
    private String academicGrade;

    @Column(name = "c_collage_name")
    private String collageName;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_teacher", insertable = false, updatable = false)
    private Teacher teacher;

    @Column(name = "f_teacher")
    private Long teacherId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_parameter_value_university", insertable = false, updatable = false)
    private ParameterValue university;

    @Column(name = "f_parameter_value_university")
    private Long universityId;
}
