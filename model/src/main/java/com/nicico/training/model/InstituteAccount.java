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
@Table(name = "tbl_institute_account")
public class InstituteAccount extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "institute_account_seq")
    @SequenceGenerator(name = "institute_account_seq", sequenceName = "seq_institute_account_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_account_number", length = 20)
    private String accountNumber;

    @Column(name = "c_cart_number", length = 20)
    private String cartNumber;

    @Column(name = "c_shaba_number", length = 100)
    private String shabaNumber;

    @Column(name = "c_account_owner_name", length = 255)
    private String accountOwnerName;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "c_institute", insertable = false, updatable = false)
    private Institute institute;

    @Column(name = "c_institute")
    private Long instituteId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "c_bank", insertable = false, updatable = false)
    private Bank bank;

    @Column(name = "c_bank")
    private Long bankId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "c_bank_branch", insertable = false, updatable = false)
    private BankBranch bankBranch;

    @Column(name = "c_bank_branch")
    private Long bankBranchId;

    @Column(name = "n_is_enable")
    private Integer isEnable;

    @Column(name = "c_description")
    private Long description;
}
