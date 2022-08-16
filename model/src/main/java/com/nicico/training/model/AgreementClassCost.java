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
@Table(name = "tbl_agreement_class_cost")
public class AgreementClassCost extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "agreement_class_cost_seq")
    @SequenceGenerator(name = "agreement_class_cost_seq", sequenceName = "seq_agreement_class_cost_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "n_teaching_cost_per_hour")
    private Double teachingCostPerHour;

    @Column(name = "n_teaching_cost_per_hour_auto")
    private Double teachingCostPerHourAuto;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_class_id", nullable = false, insertable = false, updatable = false)
    private Tclass tClass;

    @Column(name = "f_class_id")
    private Long classId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_agreement_id", nullable = false, insertable = false, updatable = false)
    private Agreement agreement;

    @Column(name = "f_agreement_id")
    private Long agreementId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_basis_calculate_id", nullable = false, insertable = false, updatable = false)
    private ParameterValue basisCalculate;

    @Column(name = "f_basis_calculate_id")
    private Long basisCalculateId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_teacher_id", insertable = false, updatable = false)
    private Teacher teacher;

    @Column(name = "f_teacher_id")
    private Long teacherId;
}
