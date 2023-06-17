package com.nicico.training.model;

import com.nicico.training.model.enums.PaymentDocStatus;
import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.Set;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_payment_doc")
public class PaymentDoc extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "course_seq")
    @SequenceGenerator(name = "course_seq", sequenceName = "seq_course_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "agreement_id", insertable = false, updatable = false)
    private Agreement agreement;

    @Column(name = "agreement_id")
    private Long agreementId;


    @Column(name = "payment_doc_status")
    private PaymentDocStatus paymentDocStatus;



    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_payment_doc_class",
            joinColumns = {@JoinColumn(name = "f_payment_doc", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_class", referencedColumnName = "id")})
    private Set<Tclass> classList;





}
