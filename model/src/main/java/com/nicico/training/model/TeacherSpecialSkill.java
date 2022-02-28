package com.nicico.training.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.persistence.*;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@Entity
@Table(name = "TBL_TEACHER_SPECIAL_SKILL")
public class TeacherSpecialSkill {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "SEQ_TEACHER_SPECIAL_SKILL_ID")
    @SequenceGenerator(name = "SEQ_TEACHER_SPECIAL_SKILL_ID", sequenceName = "SEQ_TEACHER_SPECIAL_SKILL_ID", allocationSize = 1)
    @Column(name = "ID", precision = 10)
    private Long id;

    @Column(name = "F_TEACHER_ID")
    private Long teacherId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "F_TEACHER_ID", insertable = false, updatable = false)
    private Teacher teacher;

    @Column(name = "F_FIELD_ID")
    private Long fieldId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "F_FIELD_ID", insertable = false, updatable = false)
    private ParameterValue field;

    @Column(name = "F_TYPE_ID")
    private Long typeId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "F_TYPE_ID", insertable = false, updatable = false)
    private ParameterValue type;

    @Column(name = "F_LEVEL_ID")
    private Long levelId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "F_LEVEL_ID", insertable = false, updatable = false)
    private ParameterValue level;

    @Column(name = "C_DESCRIPTION")
    private String description;

}
