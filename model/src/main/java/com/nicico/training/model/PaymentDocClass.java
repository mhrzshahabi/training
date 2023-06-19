package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_payment_doc_class")
public class PaymentDocClass extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "payment_doc_class_seq")
    @SequenceGenerator(name = "payment_doc_class_seq", sequenceName = "seq_payment_doc_class_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;


    @Column(name = "class_code")
    private String classCode;

    @Column(name = "class_duration")
    private String classDuration;

    @Column(name = "time_spent")
    private String timeSpent;

    @Column(name = "teaching_cost_per_hour")
    private Long teachingCostPerHour;

    @Column(name = "final_amount")
    private Long finalAmount;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_payment_doc", insertable = false, updatable = false, nullable = false)
    private PaymentDoc paymentDoc;

    @Column(name = "f_payment_doc")
    private Long paymentDocId;

}
