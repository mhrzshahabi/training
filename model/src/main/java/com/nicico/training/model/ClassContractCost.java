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
@Table(name = "tbl_class_contract_cost")
public class ClassContractCost extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "class_contract_cost_seq")
    @SequenceGenerator(name = "class_contract_cost_seq", sequenceName = "seq_class_contract_cost_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "n_teacher_cost_per_hour")
    private Long teacherCostPerHour;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_class_id", nullable = false, insertable = false, updatable = false)
    private Tclass tclass;

    @Column(name = "f_class_id", nullable = false)
    private Long classId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_class_contract_id", nullable = false, insertable = false, updatable = false)
    private ClassContract classContract;

    @Column(name = "f_class_contract_id", nullable = false)
    private Long classContractId;
}
