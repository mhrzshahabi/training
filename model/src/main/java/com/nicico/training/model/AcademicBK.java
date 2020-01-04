package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.Date;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_teaching_history")
public class AcademicBK extends Auditable {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "teaching_history_seq")
    @SequenceGenerator(name = "teaching_history_seq", sequenceName = "seq_teaching_history_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_education_level")
    private EducationLevel educationLevel;

    @Column(name = "f_personality", nullable = false, insertable = false, updatable = false)
    private Long educationLevelId;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_education_major")
    private EducationMajor educationMajor;

    @Column(name = "f_education_major", nullable = false, insertable = false, updatable = false)
    private Long educationMajorId;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_education_orienation")
    private EducationOrientation educationOrientation;

    @Column(name = "f_education_orientation", nullable = false, insertable = false, updatable = false)
    private Long educationOrientationId;

    @Column(name = "d_date")
    private Date date;

    @Column(name = "c_duration")
    private String duration;

    @Column(name = "c_academic_grade")
    private String academicGrade;

    @Column(name = "c_collage_name")
    private String collageName;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_teacher_id", insertable = false, updatable = false)
    private Teacher teacher;

    @Column(name = "f_teacher_id")
    private Long teacherId;

}
