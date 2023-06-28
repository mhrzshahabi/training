package com.nicico.training.model;

import com.nicico.training.model.enums.AgreementStatus;
import lombok.*;

import javax.persistence.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_agreement")
public class Agreement extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "agreement_seq")
    @SequenceGenerator(name = "agreement_seq", sequenceName = "seq_agreement_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_agreement_number")
    private String agreementNumber;

    @Column(name = "d_agreement_date")
    private String agreementDate;

    @Column(name = "d_from_date")
    private String fromDate;

    @Column(name = "d_to_date")
    private String toDate;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_first_party_institute_id", nullable = false, insertable = false, updatable = false)
    private Institute firstParty;

    @Column(name = "f_first_party_institute_id")
    private Long firstPartyId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_second_party_teacher_id", insertable = false, updatable = false)
    private Teacher secondPartyTeacher;

    @Column(name = "f_second_party_teacher_id")
    private Long secondPartyTeacherId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_second_party_institute_id", insertable = false, updatable = false)
    private Institute secondPartyInstitute;

    @Column(name = "f_second_party_institute_id")
    private Long secondPartyInstituteId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_currency_id", nullable = false, insertable = false, updatable = false)
    private ParameterValue currency;

    @Column(name = "f_currency_id")
    private Long currencyId;

    @Column(name = "n_final_cost")
    private Long finalCost;

    @Column(name = "c_subject", length = 150)
    private String subject;

    @Column(name = "b_teacher_evaluation")
    private Boolean teacherEvaluation;

    @Column(name = "n_max_payment_hours")
    private Long maxPaymentHours;

    @Column(name = "c_file_name")
    private String fileName;

    @Column(name = "c_group_id")
    private String group_id;

    @Column(name = "c_key")
    private String key;

    @Column(name = "complex_id")
    private Long complexId;

    @Column(name = "complex_title")
    private String complexTitle;

    @Column(name = "agreement_status")
    private AgreementStatus agreementStatus;

    @Column(name = "process_instance_id")
    private String processInstanceId;


    @Column(name = "return_detail")
    private String returnDetail;
}
