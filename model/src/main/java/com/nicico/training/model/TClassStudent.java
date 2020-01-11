package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.Set;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_tclass_student_new")
public class TClassStudent extends Auditable {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "tclass_student_new_seq")
    @SequenceGenerator(name = "tclass_student_new_seq", sequenceName = "seq_tclass_student_new_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "scores_state")
    private String scoresState;

    @Column(name = "failure_reason")
    private String failureReason;

    @Column(name = "score")
    private Float score;

    @Column(name = "applicant_company_name", nullable = false)
    private String applicantCompanyName;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "presence_type_id", nullable = false, insertable = false, updatable = false)
    private ParameterValue presenceType;

    @Column(name = "presence_type_id")
    private Long presenceTypeId;

    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.PERSIST)
    @JoinColumn(name = "student_id", nullable = false, insertable = false, updatable = false)
    private Student student;

    @Column(name = "student_id")
    private Long studentId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "class_id", nullable = false, insertable = false, updatable = false)
    private Tclass tclass;

    @Column(name = "class_id")
    private Long tclassId;
}
