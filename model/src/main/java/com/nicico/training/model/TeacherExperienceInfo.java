package com.nicico.training.model;

import com.nicico.training.model.enums.TeacherRank;
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
@Table(name = "tbl_teacher_exprience_info")
public class TeacherExperienceInfo extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "teacher_experience_info_seq")
    @SequenceGenerator(name = "teacher_experience_info_seq", sequenceName = "seq_teacher_experience_info_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "salary_base")
    private String salaryBase;

    @Column(name = "teaching_experience")
    private String teachingExperience;

    @Column(name = "t_rank", insertable = false, updatable = false)
    private TeacherRank teacherRank;
    @Column(name = "t_rank")
    private Integer teacherRankId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "teacher", insertable = false, updatable = false)
    private Teacher teacher;

}
